/* This class is a collection of methods to query the database for the Reporting Milestone functions
 * Update History:
 * 09-28-2017   Luke Chen   SFDC-6129,6871,6872 GEMS Reporting Milestone
 * 02-01-2018   Luke Chen   SFDC-7461,7462,7463 bug fix for GEMS Reporting Milestone
 * 02-21-2018   Gokul       SFDC-4244 GEMS: Acct Structure - Special Handling of Complex/Co-op Accounts (Downstream Processing)
 * 05/30/2018   Gokul       SFDC-4112 GEMS: Dental Only Cases should not Create Medical Underwriting Cases
 */

public class GEMS_ReportingMilestoneUtil{
    // case record type ID - Name map
    public static Map<Id, String> CaseRecordTypeMap = null;
    // record type name and its milestone-specific status map
    public static Map<String, Set<String>> MilestoneCaseMap = null;

    /* getTrackingRecords method
    *  This method gets a list of submission case ID and look up the GEMS_ReportingMilestone_Tracking__c object.
    *  It collects the corresponding records whose submission case id matches.
    *  If the record does not exist, it creates one and populate the status and related fields from all its downstream cases
    *  Return: Map<submission case ID, Tracking Object>
    */
    public static Map<Id, GEMS_ReportingMilestone_Tracking__c> getTrackingRecords(Set<Id> submissionCaseIds){
        List<GEMS_ReportingMilestone_Tracking__c> trackingRecs = 
                [select id, Submission_Type__c, Submission_Sub_Type__c, Submission_Case_Number__c, Submission_Case__c, Product_Type__c,
                 Milestone_Date__c, Milestone__c, isReleased__c, hasTeamAdditionalUWer__c, hasRx__c, hasMedical__c, hasDental__c, 
                 GEMS_Pharmacy_Coding_Status__c, GEMS_Membership_Status__c, GEMS_Medical_Underwriting_Status__c, GEMS_Medical_Benefit_Coding_Status__c,
                 GEMS_Manual_Eligibility_Status__c, GEMS_ID_Card_Status__c, GEMS_Eligibility_Status__c, GEMS_Dental_Underwriting_Status__c,                                                 
                 GEMS_Dental_Benefit_Coding_Status__c, GEMS_Additional_Underwriting_Status__c, GEMS_Account_Submission_Status__c,                                                 
                 GEMS_Account_Structure_Status__c, GEMS_Account_Setup_Status__c, GEMS_ID_Card_Mailed_Date__c, Milestone_Member_Ready_Date__c,
                 Milestone_Member_Ready_ID_Cards_Mailed__c, Milestone_Service_Ready_Date__c, 
                 // #START 7461,7462,7463
                 Check_Dental_Coding__c, Check_Medical_Coding__c, Check_Rx_Coding__c, 
                 // 7461,7462,7463
                 Submission_Case__r.GEMS_Ready_to_release_to_screening__c, Submission_Case__r.status from GEMS_ReportingMilestone_Tracking__c 
                 where Submission_Case__c in :submissionCaseIds order by id desc];
        List<GEMS_ReportingMilestone_Tracking__c> upsertTrackings = new List<GEMS_ReportingMilestone_Tracking__c>();
        List<GEMS_ReportingMilestone_Tracking__c> returnTrackings = new List<GEMS_ReportingMilestone_Tracking__c>();
        Set<Id> caseIdSet = new Set<Id>();
        Set<ID> existingTrackings = new Set<Id>();
        /* Below for-block is to
         * 1. identify existing tracking records
         * 2. reset tracking records if their submission cases reset release
         * 3. pick up submission cases which are just released
         */
        for(GEMS_ReportingMilestone_Tracking__c t : trackingRecs) {
            // item 1, identify existing tracking records
            existingTrackings.add(t.Submission_Case__c);  
            if(t.isReleased__c && t.Submission_Case__r.GEMS_Ready_to_release_to_screening__c != GEMS_Constants.Released)
                // item 2, submission cases reset release, reset the tracking record
                returnTrackings.add(clearTrackingRec(t));
            else if( ! t.isReleased__c && t.Submission_Case__r.GEMS_Ready_to_release_to_screening__c == GEMS_Constants.Released)
                // item 3, submission cases are just released, add them to upsertTrackings list to populate BA related data
                { upsertTrackings.add(t); caseIdSet.add(t.Submission_Case__c); }
            else returnTrackings.add(t);
        }
        // pick up submission cases which do not have a tracking record yet
        for(Id i : submissionCaseIds) {
            if( ! existingTrackings.contains(i)) {
                upsertTrackings.add(new GEMS_ReportingMilestone_Tracking__c(Submission_Case__c = i));
                caseIdSet.add(i);
            }
        }
        if( ! upsertTrackings.isEmpty()) {
            // populate submission case submission, sub, product fields, downstream case status, BA's info, etc.
            Set<Id> caseTypeIdSet = getCaseRecordTypeMap().keySet();
            Map<Id,Case> subm = new Map<Id,Case>([Select id, casenumber, status, GEMS_Ready_to_release_to_screening__c, LastModifiedDate, GEMS_Submission_Type__c, GEMS_Submission_Sub_Type__c, 
                                                  GEMS_StdCust_Product__c, GEMS_Rx_Vendor__c, GEMS_Products__c,  
                                                (select id,RecordTypeId,status,LastModifiedDate,GEMS_ID_card_mailed_date__c,
                                                // #START 7461,7462,7463
                                                Sub_Category__c 
                                                // #END 7461,7462,7463
                                                from Cases1__r where recordtypeid in :caseTypeIdSet), 
                                                (select id,parentid, memberid, teamroleid from TeamMembers WHERE TeamRole.name='Additional Underwriter')
                                                from case where id in :caseIdSet]);
            // get BA info from structure case
            Id caseAccountStructureId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
            Set<Id> strIdSet = new Set<Id>();
            for(Case c : subm.values())
                if(c.Cases1__r != null)
                    for(Case child : c.Cases1__r)
                        if(child.RecordTypeId == caseAccountStructureId) {strIdSet.add(child.id) ; break;}
            // SFDC-4244 Added new field filter for selected BA
            List<Case> strList = [select id, GEMS_Account_Submission_Info__c,           
                                  (select id, Product__r.Product_Category__c, Plan__r.Product__r.Product_Category__c from GEMS_Benefit_Agreements__r where GEMS_BAs_SpHandling__c = true)
                                  from case where id in :strIdSet];
            Map<Id,Case> strm = new Map<Id,Case>();
            for(Case strc : strList) strm.put(strc.GEMS_Account_Submission_Info__c, strc);
            // populate data to tracking record
            // when upsert, only upsert the fields that are changed
            Map<Id,GEMS_ReportingMilestone_Tracking__c> ttMap = new Map<Id,GEMS_ReportingMilestone_Tracking__c>();
            for(GEMS_ReportingMilestone_Tracking__c t : upsertTrackings){
                GEMS_ReportingMilestone_Tracking__c tt = new GEMS_ReportingMilestone_Tracking__c(id = t.id, Submission_Case__c = t.Submission_Case__c);
                ttMap.put(t.Submission_Case__c,tt);
                Case subc = subm.get(t.Submission_Case__c);
                Case strc = strm.get(t.Submission_Case__c);
                if( subc.GEMS_Ready_to_release_to_screening__c == GEMS_Constants.Released) {t.isReleased__c = true; tt.isReleased__c = true; }
                else {t.isReleased__c = false; tt.isReleased__c = false;}
                if(subc.TeamMembers != null && subc.TeamMembers.size() > 0) {t.hasTeamAdditionalUWer__c = true; tt.hasTeamAdditionalUWer__c = true;}
                else {t.hasTeamAdditionalUWer__c = false; tt.hasTeamAdditionalUWer__c = false;}
                if(subc.GEMS_Rx_Vendor__c != null && subc.GEMS_Products__c != null && subc.GEMS_Rx_Vendor__c.contains('Prime') && subc.GEMS_Products__c.contains('RX')) {t.hasRx__c = true; tt.hasRx__c = true;}
                else {t.hasRx__c = false; tt.hasRx__c = false;}
                
                /* #NEED UPDATE 
                 * hasDental uses GEMS_Products__c from submission case for now. It will change to use BA's dental Product_Category__c from struction case 
                 */
                // t.hasDental__c = false;  // default to false
                // if(strc != null && strc.GEMS_Benefit_Agreements__r != null)
                // #START 7461,7462,7463
                // #END 7461,7462,7463  

                 //SFDC-4112 hasMedical__c is set to false if structure case has only Dental BAs
                t.hasMedical__c = true; tt.hasMedical__c = true; 
                
                if(subc.GEMS_Products__c != null && subc.GEMS_Products__c.contains('Dental')){ 
                     t.hasDental__c = true; tt.hasDental__c = true;
                }
                else{
                     t.hasDental__c = false; tt.hasDental__c = false; 
                }  
                
                if(subc.GEMS_Products__c != null && subc.GEMS_Products__c == 'Dental') 
                {
                    t.hasMedical__c = false; tt.hasMedical__c = false;
                }
                //SFDC-4112
                // populate downstream cases status
                if(subc.Cases1__r != null)
                    for(Case child : subc.Cases1__r)
                        populateStatus(getCaseRecTypeName(child.RecordTypeId), child, t, tt);
            }

            upsert ttMap.values();
            // assign back IDs to the original tracking objects because some of them are new objects
            for(GEMS_ReportingMilestone_Tracking__c t : upsertTrackings) t.id = ttMap.get(t.Submission_Case__c).id;
                
            returnTrackings.addAll(upsertTrackings);
        }
        
        Map<Id, GEMS_ReportingMilestone_Tracking__c> returnMap = new Map<Id, GEMS_ReportingMilestone_Tracking__c>();
        for(GEMS_ReportingMilestone_Tracking__c t : returnTrackings) returnMap.put(t.Submission_Case__c, t);
    
        return returnMap;
    }
    

    /* updateReportingMilestoneMatrixLogic method
    *  This method gets a list of GEMS_ReportingMilestone_Tracking__c objects.
    *  It figures out via all the fields whether certain milestones are reached or not
    */
    public static void updateReportingMilestoneMatrixLogic(List<GEMS_ReportingMilestone_Tracking__c> trackingList){
        try{
            for(GEMS_ReportingMilestone_Tracking__c trackingRecord : trackingList){
                if( ! trackingRecord.isReleased__c ) continue; // if not released, don't bother checking the milestone status
                String submissionType = trackingRecord.Submission_Type__c;
                Set<String> subTypeSet = (String.isEmpty(trackingRecord.Submission_Sub_Type__c) ? null : new Set<String>(trackingRecord.Submission_Sub_Type__c.split(';')));
                subTypeSet = trimSet(subTypeSet);
                String productType = (trackingRecord.Product_Type__c.contains('Custom') ? 'Custom' : 'Standard Products only');

                // check and update for Member Ready milestone
                updateMemberReadyMilestone(submissionType, subTypeSet, productType, trackingRecord);
                // check and update for Member Ready ID Card mailed milestone
                updateMemberReadyIdCardMilestone(submissionType, subTypeSet, productType, trackingRecord);
                // check and udpate for Service Ready milestone
                updateServiceReadyMilestone(submissionType, subTypeSet, productType, trackingRecord);

            } // end of for loop
            system.debug('>>> updateReportingMilestoneMatrixLogic, trackingList => see below line '); system.debug(trackingList);
            
            // upsert trackingList;
        }catch(Exception ex){
            system.debug('Error in updateReportingMilestoneMatrixLogic >>> ' + ex.getMessage());
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'GEMS_ReportingMilestone_Tracking__c', null, 'GEMS_ReportingMilestoneUtil.updateReportingMilestoneMatrixLogic(List<GEMS_ReportingMilestone_Tracking__c> trackingList)','High');  
        }

    }
    
    /* getCases method
    *  get a list of case objects via their IDs for reporting milestone processing
    *
    */
    public static List<Case> getCases(Set<Id> caseList){
        if(caseList.isEmpty()) return null;
        return [select id, recordtypeid, status, GEMS_Account_Submission_Info__c, LastModifiedDate, GEMS_ID_card_mailed_date__c, GEMS_Account_Submission_Info__r.recordtypeid, Sub_Category__c from case where id in :caseList];
    }
    
    /* populateStatus method
    *  This method populates a case's status to its corresponding tracking record
    *  1. ID card case does not populate status but the GEMS_ID_card_mailed_date__c
    *  2. Screen cases only handle Medical/Dental/Rx coding only. They are to set Check_Dental_Coding__c/Check_Medical_Coding__c/Check_Rx_Coding__c fields
    *     in tracking object. They don't populate status in tracking object.
    *  3. All other cases populate status
    */
    public static void populateStatus(String caseRecordTypeName, Case oneCase, GEMS_ReportingMilestone_Tracking__c trackingRecord, GEMS_ReportingMilestone_Tracking__c tt){
        GEMS_ReportingMilestone_Tracking__c toUpdate = new GEMS_ReportingMilestone_Tracking__c(Submission_Case__c = trackingRecord.Submission_Case__c);
        if(caseRecordTypeName == GEMS_Constants.IDCardCaseRecordType){
            // need to track ID card mailed date
            if(oneCase.GEMS_ID_card_mailed_date__c != trackingRecord.GEMS_ID_Card_Mailed_Date__c) {
                trackingRecord.GEMS_ID_Card_Mailed_Date__c = oneCase.GEMS_ID_card_mailed_date__c; 
                if(tt != null) tt.GEMS_ID_Card_Mailed_Date__c = oneCase.GEMS_ID_card_mailed_date__c; else toUpdate.GEMS_ID_Card_Mailed_Date__c = oneCase.GEMS_ID_card_mailed_date__c;
            }else{  // must be ID card case status change
                if(oneCase.status != trackingRecord.GEMS_ID_Card_Status__c) {
                    trackingRecord.GEMS_ID_Card_Status__c = oneCase.status;
                    trackingRecord.GEMS_ID_Card_Status_Date__c = oneCase.LastModifiedDate;
                    if(tt != null ){
                        tt.GEMS_ID_Card_Status__c = oneCase.status;
                        tt.GEMS_ID_Card_Status_Date__c = oneCase.LastModifiedDate;
                    }else{
                        toUpdate.GEMS_ID_Card_Status__c = oneCase.status;
                        toUpdate.GEMS_ID_Card_Status_Date__c = oneCase.LastModifiedDate;
                    }
                }
            }
        // #START 7461,7462,7463
        }else if(caseRecordTypeName == GEMS_Constants.CaseRecdType_Screening){
            if(oneCase.Sub_Category__c==null) return; // not the screening case we want to track, return, doing nothing
            if(oneCase.status != GEMS_Constants.StatusRouteErr) return; // we only need cases whose status is 'Routed In Error'
            if(oneCase.Sub_Category__c == 'Benefit Coding Screening'){ trackingRecord.Check_Medical_Coding__c = false; if(tt != null ) tt.Check_Medical_Coding__c = false; else toUpdate.Check_Medical_Coding__c = false;}
            else if(oneCase.Sub_Category__c == 'Dental Benefit Coding Screening'){ trackingRecord.Check_Dental_Coding__c = false; if(tt != null ) tt.Check_Dental_Coding__c = false; else toUpdate.Check_Dental_Coding__c = false;}
            else if(oneCase.Sub_Category__c == 'Pharmacy Coding Screening'){ trackingRecord.Check_Rx_Coding__c = false; if(tt != null ) tt.Check_Rx_Coding__c = false; else toUpdate.Check_Rx_Coding__c = false;}
            else return; // not the Sub Category we want, return, doing nothing
        // #END 7461,7462,7463
        }else{
            String tmp = caseRecordTypeName.replace(' ', '_');
            String statusFieldName = tmp + '_Status__c';
            String dateFieldName = tmp + '_Status_Date__c';
            trackingRecord.put(statusFieldName, oneCase.status);
            trackingRecord.put(dateFieldName, oneCase.LastModifiedDate );
            if(tt != null ){
                tt.put(statusFieldName, oneCase.status);
                tt.put(dateFieldName, oneCase.LastModifiedDate );
            }else{
                toUpdate.put(statusFieldName, oneCase.status);
                toUpdate.put(dateFieldName, oneCase.LastModifiedDate );
            }
            /* SFDC-8279 DBC will still be created in below condition so we comment out below block
            // #START 7461,7462,7463
            // if either Medical or Dental UW is routed in error, the Check_Dental_Coding__c boolean field is set to false
            // because the dental coding case will not be generated
            if(caseRecordTypeName == 'GEMS Dental Underwriting' || caseRecordTypeName == 'GEMS Medical Underwriting'){
                if(trackingRecord.GEMS_Dental_Underwriting_Status__c == GEMS_Constants.StatusRouteErr || trackingRecord.GEMS_Medical_Underwriting_Status__c == GEMS_Constants.StatusRouteErr){
                    trackingRecord.Check_Dental_Coding__c = false;
                    if(tt != null ) tt.Check_Dental_Coding__c = false;
                    else toUpdate.Check_Dental_Coding__c = false;                  
                }
            }
            // #END 7461,7462,7463
            End of SFDC-8279 */
        }
        if(tt != null) return;  // no need to update the record, toUpdate, below because the caller method will upsert this tt record later
        toUpdate.id = trackingRecord.id;
        update toUpdate;
        /*
        if(caseRecordTypeName == GEMS_Constants.IDCardCaseRecordType || caseRecordTypeName == 'GEMS Account Submission')
            if(oneCase.GEMS_ID_card_mailed_date__c != trackingRecord.GEMS_ID_Card_Mailed_Date__c) trackingRecord.GEMS_ID_Card_Mailed_Date__c = oneCase.GEMS_ID_card_mailed_date__c;
        String tmp = caseRecordTypeName.replace(' ', '_');
        String statusFieldName = tmp + '_Status__c';
        String dateFieldName = tmp + '_Status_Date__c';
        trackingRecord.put(statusFieldName, oneCase.status);
        trackingRecord.put(dateFieldName, oneCase.LastModifiedDate );    
        */
    }

    /* getCaseRecTypeName method
     * build a case record type ID-Name map for updating tracking object if does not exist yet
     * return the case record type name
     */
    public static String getCaseRecTypeName(Id anId){
        return getCaseRecordTypeMap().get(anId);
    }
    
    // get method for CaseRecordTypeMap property field
    public static Map<Id, String> getCaseRecordTypeMap(){
        if(CaseRecordTypeMap == null){
            List<GEMS_ReportingMilestone_CaseRecord_Type__mdt> caseRecordTypes =
                    [select CaseRecord_Type_Name__c from GEMS_ReportingMilestone_CaseRecord_Type__mdt];
                    CaseRecordTypeMap = new Map<Id, String>(); // <ID, Name>
                    for(GEMS_ReportingMilestone_CaseRecord_Type__mdt caseTypeName : caseRecordTypes)
                        CaseRecordTypeMap.put(Schema.SObjectType.Case.getRecordTypeInfosByName().get(caseTypeName.CaseRecord_Type_Name__c).getRecordTypeId(),
                                              caseTypeName.CaseRecord_Type_Name__c);            
        }
        return CaseRecordTypeMap;
    }
    
    
    /* getMilestoneStatus method
     * build a map for case record type to its milestone-specific status
     * return the milestone-specific status set
     */
    public static Set<String> getMilestoneStatus(String caseRecType){
        if(MilestoneCaseMap == null){
            List<GEMS_ReportingMilestone_CaseRecord_Type__mdt> caseRecordTypes =
                    [select CaseRecord_Type_Name__c, Milestone_Status_List__c from GEMS_ReportingMilestone_CaseRecord_Type__mdt];
            MilestoneCaseMap = new Map<String, Set<String>>(); // <record type name, milestone status set>
            for(GEMS_ReportingMilestone_CaseRecord_Type__mdt caseTypeName : caseRecordTypes){
                String statusString = caseTypeName.Milestone_Status_List__c;
                if( String.isEmpty(statusString)){
                    MilestoneCaseMap.put(caseTypeName.CaseRecord_Type_Name__c, null);
                }else{
                    List<String> milestoneList = statusString.split(';');
                    Set<String> milestoneSet = new Set<String>();
                    for(String s : milestoneList) milestoneSet.add(s);
                    MilestoneCaseMap.put(caseTypeName.CaseRecord_Type_Name__c, milestoneSet);
                }
            }
        }
        return MilestoneCaseMap.get(caseRecType);
    }

    /* isReadyMet method
     * Check if one of the required case types is in Approved, Completed, etc. status
     */
    private static boolean isReadyMet(String caseType, GEMS_ReportingMilestone_Tracking__c trackingRecord){
        String fieldName = caseType.replace(' ', '_') + '_Status__c';
        String caseStatus = (String) trackingRecord.get(fieldName);
        if(String.isEmpty(caseStatus) || caseStatus == 'New' || caseStatus == 'In Progress') return false; // no need to check, case just started
        Set<String> caseMilestoneSet = getMilestoneStatus(caseType);
        if(caseMilestoneSet == null){
            // something wrong that this case type does not have milestone status provisioned in meta data
            system.debug('Error! GEMS_ReportingMilestoneUtil.isReadyMet(String, GEMS_ReportingMilestone_Tracking__c) >>> ' + caseType + ' has no Milestone status in GEMS_ReportingMilestone_CaseRecord_Type__mdt');  
            return false;
        }
        if( caseMilestoneSet.contains(caseStatus) ) return true;
        return false;
    }
    
    /* isIdCardMet method
     * Check if ID Card case's GEMS_ID_card_mailed_date__c field has value
     */
    private static boolean isIdCardMet(GEMS_ReportingMilestone_Tracking__c trackingRecord){
        if(trackingRecord.GEMS_ID_Card_Mailed_Date__c != null) return true;
        return false;
    }    
    
    
    /* clearTrackingRec method
     * reset fields in a tracking record when the release flag is reset in the submission case
     */
    private static GEMS_ReportingMilestone_Tracking__c clearTrackingRec(GEMS_ReportingMilestone_Tracking__c t){
        t.Milestone_Date__c = null; t.Milestone__c = null; t.isReleased__c = false; t.hasTeamAdditionalUWer__c = true;  
        t.hasRx__c = true; t.hasMedical__c = true;  t.hasDental__c = true; t.GEMS_Pharmacy_Coding_Status__c = null;  
        t.GEMS_Membership_Status__c = null; t.GEMS_Medical_Underwriting_Status__c = null;  
        t.GEMS_Medical_Benefit_Coding_Status__c = null; t.GEMS_Manual_Eligibility_Status__c = null;  
        t.GEMS_ID_Card_Status__c = null;  t.GEMS_Eligibility_Status__c = null; 
        t.GEMS_Dental_Underwriting_Status__c = null; t.GEMS_Dental_Benefit_Coding_Status__c = null; 
        t.GEMS_Additional_Underwriting_Status__c = null;  t.GEMS_Account_Submission_Status__c = t.Submission_Case__r.status;  
        t.GEMS_Account_Structure_Status__c = null;  t.GEMS_Account_Setup_Status__c = null; t.GEMS_ID_Card_Mailed_Date__c = null;
        // #START 7461,7462,7463
        t.Check_Dental_Coding__c = true; t.Check_Medical_Coding__c = true; t.Check_Rx_Coding__c = true;
        // #END 7461,7462,7463 
        update t;
        return t;
    }

    /* updateMemberReadyMilestone method
     * This method checks if the Member Ready milestone is reached
     */
    private static void updateMemberReadyMilestone(String submissionType, Set<String> subTypeSet, String productType, GEMS_ReportingMilestone_Tracking__c trackingRecord){
        // Get Member Ready Case set
        Set<String> memReadyCaseSet = new Set<String>();
        if(subTypeSet == null || subTypeSet.isEmpty()){ 
            GEMS_ReportingMilestone_Matrix__mdt memReadyMatrix = [select Member_Ready_Cases__c from GEMS_ReportingMilestone_Matrix__mdt where Submission_Type__c = :submissionType and Product_Type__c = :productType limit 1];
            memReadyCaseSet.addAll(memReadyMatrix.Member_Ready_Cases__c.split(';'));
        }else{  // sub type may have  more than one selection so combine all required cases
            List<GEMS_ReportingMilestone_Matrix__mdt> memMatrixList = [select Member_Ready_Cases__c from GEMS_ReportingMilestone_Matrix__mdt where Submission_Type__c = :submissionType and Product_Type__c = :productType and Submission_Sub_Type__c in :subTypeSet];
            for(GEMS_ReportingMilestone_Matrix__mdt m : memMatrixList) memReadyCaseSet.addAll(m.Member_Ready_Cases__c.split(';'));
        }
        
        List<String> memReadyCaseFinalList = new List<String>();
        // Do the Member Ready milestone
        // pick up member ready milestone cases for this Submission case
        for(String s : memReadyCaseSet){
            boolean isToPickup = true;
            if( notToPickupThisCase(trackingRecord, s) ) isToPickup = false;
            else if (notToPickupCodingCase(trackingRecord, s)) isToPickup = false; 
            if(isToPickup) memReadyCaseFinalList.add(s);
        }

        // check if milestone is reached
        boolean isMemReady = true;
        for(String caseType : memReadyCaseFinalList){
            if( ! isReadyMet(caseType, trackingRecord) ){
                isMemReady = false;
                break;
            }
        }
        
        if( isMemReady ) {
            if(String.isEmpty(trackingRecord.Milestone__c)){
                trackingRecord.Milestone__c = GEMS_Constants.MemberReady;
                trackingRecord.Milestone_Date__c = system.now();
                trackingRecord.Milestone_Member_Ready_Date__c = trackingRecord.Milestone_Date__c;
                GEMS_ReportingMilestone_Tracking__c tt = new GEMS_ReportingMilestone_Tracking__c(id = trackingRecord.id, Submission_Case__c = trackingRecord.Submission_Case__c);
                tt.Milestone__c = trackingRecord.Milestone__c;
                tt.Milestone_Date__c = trackingRecord.Milestone_Date__c;
                tt.Milestone_Member_Ready_Date__c = trackingRecord.Milestone_Member_Ready_Date__c;
                update tt;
            }
        }else{
            if( ! String.isEmpty(trackingRecord.Milestone__c)){
                // downgrade to nothing
                trackingRecord.Milestone__c = null;
                trackingRecord.Milestone_Date__c = null;
                trackingRecord.Milestone_Member_Ready_Date__c = null;  
                GEMS_ReportingMilestone_Tracking__c tt = new GEMS_ReportingMilestone_Tracking__c(id = trackingRecord.id, Submission_Case__c = trackingRecord.Submission_Case__c);
                tt.Milestone__c = null;
                tt.Milestone_Date__c = null;
                tt.Milestone_Member_Ready_Date__c = null;                 
                update tt;
            }
        }
    }
    
    /* updateMemberReadyIdCardMilestone method
     * This method checks if the Member Ready ID card mailed milestone is reached
     */
    private static void updateMemberReadyIdCardMilestone(String submissionType, Set<String> subTypeSet, String productType, GEMS_ReportingMilestone_Tracking__c trackingRecord){
        // if the tracking record did not pass the previous milestone (Member Ready), don't bother checking ID card milestone
        if(String.isEmpty(trackingRecord.Milestone__c)) return;
        
        // Get Member Ready ID card Case set
        Set<String> idCardReadyCaseSet = new Set<String>();
        if(subTypeSet == null || subTypeSet.isEmpty()){ 
            GEMS_ReportingMilestone_Matrix__mdt idCardReadyMatrix = [select Member_Ready_ID_Cards_Cases__c from GEMS_ReportingMilestone_Matrix__mdt where Submission_Type__c = :submissionType and Product_Type__c = :productType limit 1];
            idCardReadyCaseSet.addAll(idCardReadyMatrix.Member_Ready_ID_Cards_Cases__c.split(';'));
        }else{  // sub type may have  more than one selection so combine all required cases
            List<GEMS_ReportingMilestone_Matrix__mdt> idCardMatrixList = [select Member_Ready_ID_Cards_Cases__c from GEMS_ReportingMilestone_Matrix__mdt where Submission_Type__c = :submissionType and Product_Type__c = :productType and Submission_Sub_Type__c in :subTypeSet];
            for(GEMS_ReportingMilestone_Matrix__mdt m : idCardMatrixList) idCardReadyCaseSet.addAll(m.Member_Ready_ID_Cards_Cases__c.split(';'));
        }
        
        List<String> idCardReadyCaseFinalList = new List<String>();
        // Do the Member Ready ID card milestone
        // pick up member ready ID card milestone cases for this Submission case
        for(String s : idCardReadyCaseSet){
            boolean isToPickup = true;
            if( notToPickupThisCase(trackingRecord, s) ) isToPickup = false;
            else if (notToPickupCodingCase(trackingRecord, s)) isToPickup = false; 
            if(isToPickup) idCardReadyCaseFinalList.add(s);
        }

        // check if milestone is reached
        boolean isIdCardReady = true;
        for(String caseType : idCardReadyCaseFinalList){
            if(caseType == GEMS_Constants.IDCardCaseRecordType ){
                if( ! isIdCardMet(trackingRecord)){
                    isIdCardReady = false;
                    break;                  
                }
            }else{
                if( ! isReadyMet(caseType, trackingRecord) ){
                    isIdCardReady = false;
                    break;
                }
            }
        }
        
        if( isIdCardReady ) {
            if(String.isEmpty(trackingRecord.Milestone__c) || trackingRecord.Milestone__c == GEMS_Constants.MemberReady){
                trackingRecord.Milestone__c = GEMS_Constants.MemberIDCardReady;
                trackingRecord.Milestone_Date__c = system.now();
                trackingRecord.Milestone_Member_Ready_ID_Cards_Mailed__c = trackingRecord.Milestone_Date__c;
                GEMS_ReportingMilestone_Tracking__c tt = new GEMS_ReportingMilestone_Tracking__c(id = trackingRecord.id, Submission_Case__c = trackingRecord.Submission_Case__c);
                tt.Milestone__c = trackingRecord.Milestone__c;
                tt.Milestone_Date__c = trackingRecord.Milestone_Date__c;
                tt.Milestone_Member_Ready_ID_Cards_Mailed__c = trackingRecord.Milestone_Member_Ready_ID_Cards_Mailed__c;
                update tt;
            }
        }else{
            if( ! String.isEmpty(trackingRecord.Milestone__c) && (trackingRecord.Milestone__c == GEMS_Constants.MemberIDCardReady || trackingRecord.Milestone__c == GEMS_Constants.ServiceReady)){
                // downgrade to member ready milestone
                trackingRecord.Milestone__c = GEMS_Constants.MemberReady;
                trackingRecord.Milestone_Date__c = trackingRecord.Milestone_Member_Ready_Date__c;
                trackingRecord.Milestone_Member_Ready_ID_Cards_Mailed__c = null;   
                GEMS_ReportingMilestone_Tracking__c tt = new GEMS_ReportingMilestone_Tracking__c(id = trackingRecord.id, Submission_Case__c = trackingRecord.Submission_Case__c);
                tt.Milestone__c = trackingRecord.Milestone__c;
                tt.Milestone_Date__c = trackingRecord.Milestone_Date__c;
                tt.Milestone_Member_Ready_ID_Cards_Mailed__c = null;
                update tt;
            }                
        }       
    }
    
     /* updateServiceReadyMilestone method
     * This method checks if the Service Ready milestone is reached
     */
    private static void updateServiceReadyMilestone(String submissionType, Set<String> subTypeSet, String productType, GEMS_ReportingMilestone_Tracking__c trackingRecord){
        // if the tracking record did not pass the previous milestones (Member Ready ID card), don't bother checking Service Ready milestone
        if(String.isEmpty(trackingRecord.Milestone__c) || trackingRecord.Milestone__c == GEMS_Constants.MemberReady) return;
        
        // Get Service Ready Case set
        Set<String> servReadyCaseSet = new Set<String>();
        if(subTypeSet == null || subTypeSet.isEmpty()){ 
            GEMS_ReportingMilestone_Matrix__mdt servReadyMatrix = [select Service_Ready_Cases__c from GEMS_ReportingMilestone_Matrix__mdt where Submission_Type__c = :submissionType and Product_Type__c = :productType limit 1];
            servReadyCaseSet.addAll(servReadyMatrix.Service_Ready_Cases__c.split(';'));
        }else{ 
        // sub type may have  more than one selection so combine all required cases
            List<GEMS_ReportingMilestone_Matrix__mdt> servReadyMatrix = [select Service_Ready_Cases__c from GEMS_ReportingMilestone_Matrix__mdt where Submission_Type__c = :submissionType and Product_Type__c = :productType and Submission_Sub_Type__c in :subTypeSet];
            for(GEMS_ReportingMilestone_Matrix__mdt m : servReadyMatrix) 
            servReadyCaseSet.addAll(m.Service_Ready_Cases__c.split(';'));
        }
        
        List<String> servCaseReadyFinalList = new List<String>();
        // Do the Service Ready Case milestone
        // pick up Service Ready Case milestone cases for this Submission case
        for(String s : servReadyCaseSet){
            boolean isToPickup = true;
            if( notToPickupThisCase(trackingRecord, s)) isToPickup = false; 
            else if (notToPickupCodingCase(trackingRecord, s)) isToPickup = false; 
            if(isToPickup) servCaseReadyFinalList.add(s);
        }

        // check if milestone is reached
        boolean isServiceReady = true;
        for(String caseType : servCaseReadyFinalList){
         if(caseType == GEMS_Constants.IDCardCaseRecordType ){
                if(!isIdCardMet(trackingRecord)){
                    isServiceReady = false;
                    break;                  
                }  
         }   else{
                if(!isServiceReadyMet(caseType, trackingRecord) ){
                    isServiceReady = false;
                    break;
                }
            }
        }
        
        if( isServiceReady ) {
            if(trackingRecord.Milestone__c == GEMS_Constants.MemberReady || trackingRecord.Milestone__c == GEMS_Constants.MemberIDCardReady){
                trackingRecord.Milestone__c = GEMS_Constants.ServiceReady;
                trackingRecord.Milestone_Date__c = system.now();
                trackingRecord.Milestone_Service_Ready_Date__c = trackingRecord.Milestone_Date__c;
                GEMS_ReportingMilestone_Tracking__c tt = new GEMS_ReportingMilestone_Tracking__c(id = trackingRecord.id, Submission_Case__c = trackingRecord.Submission_Case__c);
                tt.Milestone__c = trackingRecord.Milestone__c;
                tt.Milestone_Date__c = trackingRecord.Milestone_Date__c;
                tt.Milestone_Service_Ready_Date__c = trackingRecord.Milestone_Service_Ready_Date__c;
                update tt;
            }
        }
        else{
           if(!String.isEmpty(trackingRecord.Milestone__c) && trackingRecord.Milestone__c == GEMS_Constants.ServiceReady){
                // downgrade to ID card member ready milestone
                trackingRecord.Milestone__c = GEMS_Constants.MemberIDCardReady;
                trackingRecord.Milestone_Date__c = trackingRecord.Milestone_Member_Ready_ID_Cards_Mailed__c;   
                trackingRecord.Milestone_Service_Ready_Date__c = null;
                GEMS_ReportingMilestone_Tracking__c tt = new GEMS_ReportingMilestone_Tracking__c(id = trackingRecord.id, Submission_Case__c = trackingRecord.Submission_Case__c);
                tt.Milestone__c = trackingRecord.Milestone__c;
                tt.Milestone_Date__c = trackingRecord.Milestone_Date__c;
                tt.Milestone_Service_Ready_Date__c = null;
                update tt;
            }
        }
    }
    
    
    /* isServiceReadyMet method
     * Check if one of the required case types is in Approved, Completed, etc. status
     */
    private static boolean isServiceReadyMet(String caseType, GEMS_ReportingMilestone_Tracking__c trackingRecord){
        String fieldName = caseType.replace(' ', '_') + '_Status__c';
        String caseStatus = (String) trackingRecord.get(fieldName);
        if(String.isEmpty(caseStatus) || caseStatus == 'New' || caseStatus == 'In Progress') return false; // no need to check, case just started
        Set<String> caseMilestoneSet = getMilestoneStatus(caseType);
        if(caseMilestoneSet == null){
            //something wrong that this case type does not have milestone status provisioned in meta data
            system.debug('Error! GEMS_ReportingMilestoneUtil.isReadyMet(String, GEMS_ReportingMilestone_Tracking__c) >>> ' + caseType + ' has no Milestone status in GEMS_ReportingMilestone_CaseRecord_Type__mdt');  
            return false;
        }
        if( caseMilestoneSet.contains(caseStatus) ) {
        return true;
        }
        return false;
    }
    
    /*
     * Trim the values in the set
     */
    private static Set<String> trimSet(Set<String> subTypeSet){
        if(subTypeSet == null) return null;
        Set<String> ss = new Set<String>();
        for(String s : subTypeSet)
            if( ! String.isEmpty(s))
                ss.add(s.trim());
        
        return ss;
    }
    
    /*
     * This is 1st round check to check hasXXXX boolean field if a case is required to be picked up for check
     */
    private static boolean notToPickupThisCase(GEMS_ReportingMilestone_Tracking__c trackingRecord, String s){
        return (!trackingRecord.hasDental__c && GEMS_Constants.DentalCaseSet.contains(s)) ||
                (!trackingRecord.hasMedical__c && GEMS_Constants.MedicalCaseSet.contains(s)) ||
                (!trackingRecord.hasTeamAdditionalUWer__c && GEMS_Constants.AdditionalUWSet.contains(s)) ||
                (!trackingRecord.hasRx__c && GEMS_Constants.RxCaseSet.contains(s)) ;
    }

    /*
     * This is 2nd round check to further check Check_XXXX_Coding__c boolean field if a coding case is required to be picked up for check
     */
    private static boolean notToPickupCodingCase(GEMS_ReportingMilestone_Tracking__c trackingRecord, String s){  
        // #START 7461,7462,7463
        return (!trackingRecord.Check_Dental_Coding__c && s == 'GEMS Dental Benefit Coding') ||
                (!trackingRecord.Check_Medical_Coding__c && s == 'GEMS Medical Benefit Coding') ||
                (!trackingRecord.Check_Rx_Coding__c && s == 'GEMS Pharmacy Coding');
       // #END 7461,7462,7463
       // return false;  //#Remove this line after un-comment above '7461,7462,7463' block
    }

}