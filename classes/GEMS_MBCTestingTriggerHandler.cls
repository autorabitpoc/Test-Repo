/**************************************************************************************
  Apex Class Name     : GEMS_MBCTestingTriggerHandler 
  Version             : 1.0
  Function            : This is a handler class for GEMS_MBC_Testing__c(For GEMS Project).
  Modification Log    :
* Developer           Date                   Description
* ----------------------------------------------------------------------------                 
* Rajeesha Popuri       9/14/2017               SFDC-5928 GEMS-MBC Update BA Level Status Field - based on MBC Testing Object Statuses
* Bharath               9/25/2017               SFDC-6459 Status of case to be updated only when the status of testing record is changed.
* Bharath               9/26/2017               SFDC-6593 Update the DTU signoff date from the first DTU record to other testing records. 
* Bharath               10/22/2017              SFDC-7246 Update the BA level medical benefit coding as Testing Passed when all the testing records are marked as Passed.
* Ranjit Gandhi         10/22/2017              SFDC-7430 GEMS: MBC - Update BA Level Status Field when FEAK Analysis is in progress
*************************************************************************************/

public  class GEMS_MBCTestingTriggerHandler{ 
    public static Boolean updBAChldCaseOwnRecurChk = false;
    public static Boolean insBAChldCaseOwnRecurChk = false;
    public static Boolean updDTUDateRecurChk = false;

/******************************************************************** 
    *    Method Name : updateMBCBALevelStatus
    *   @description :   This method is to Update BA level Medical Benefit Coding Case Status based on MBC Testing Object Status
    *   @parameters  :   List<GEMS_MBC_Testing__c> NewMBCTesting, Map<id,GEMS_MBC_Testing__c> oldMBC
    *   @return type :   void
    *   @Author : Rajeesha
    ***************************************************************/
public static void updateMBCBALevelStatus(List<GEMS_MBC_Testing__c> NewMBCTesting, Map<id,GEMS_MBC_Testing__c> oldMBC){
    //6459 - Including recursion check.
    if(!updBAChldCaseOwnRecurChk){
    Id CDHPTestingid = Schema.SObjectType.GEMS_MBC_Testing__c.getRecordTypeInfosByName().get('CDHP Testing').getRecordTypeId();
    Id DTUTestingid = Schema.SObjectType.GEMS_MBC_Testing__c.getRecordTypeInfosByName().get('DTU Testing').getRecordTypeId();
    Id FEAKAnalysisid = Schema.SObjectType.GEMS_MBC_Testing__c.getRecordTypeInfosByName().get('FEAK Analysis').getRecordTypeId();
    Id FEAKTestingid = Schema.SObjectType.GEMS_MBC_Testing__c.getRecordTypeInfosByName().get('FEAK Testing').getRecordTypeId();
    Id SharedAccumsTestingid = Schema.SObjectType.GEMS_MBC_Testing__c.getRecordTypeInfosByName().get('Shared Accums Testing').getRecordTypeId();
    System.debug('NewMBCTesting'+NewMBCTesting);
    Map<id,string> BACase = new Map<id,string>();
    
   Map<id,string> BACase1 = new Map<id,string>();
        
   for(GEMS_MBC_Testing__c TestRec: NewMBCTesting){
        //6459 - Processing to happen only when the status of the testing records has changed.
        if((TestRec.Status__c != oldMBC.get(TestRec.Id).Status__c) || (TestRec.Case_Owner_Email__c != oldMBC.get(TestRec.Id).Case_Owner_Email__c)){
        if(TestRec.recordtypeid == CDHPTestingid){
            BACase.put(TestRec.MBC_BA_Level_Case_CDHP__c,TestRec.Status__c);
        }  
        else if(TestRec.recordtypeid == DTUTestingid){
            BACase.put(TestRec.MBC_BA_Level_Case_DTU__c,TestRec.Status__c);
        }
        else if(TestRec.recordtypeid == FEAKAnalysisid){
            BACase.put(TestRec.MBC_BA_Level_Case_FEAK__c,TestRec.Status__c);
        }
        else if(TestRec.recordtypeid == FEAKTestingid){
            BACase.put(TestRec.MBC_BA_Level_Case_FEAK_Testing__c,TestRec.Status__c);
        }
        else if(TestRec.recordtypeid == SharedAccumsTestingid){
            BACase.put(TestRec.MBC_BA_Level_Case_Shared_Accums__c,TestRec.Status__c);
        }
        }
        
    }
        //6459 - Including condition to proceed with execution only when any of the case has had its status changed. 
    if(!BACase.isEmpty()){
    Map<id,Case> updateStatus = new Map<id,Case>();
    List<Case> CaseStatus = [Select id, status, GEMS_Coding_Complete_Date__c from Case where id in : BACase.keyset()];
    List<GEMS_MBC_Testing__c> uniqueRec = [Select id, status__c,MBC_BA_Level_Case_FEAK__c from GEMS_MBC_Testing__c where 
                                           (MBC_BA_Level_Case_CDHP__c In: BACase.keyset()
                                            OR MBC_BA_Level_Case_DTU__c In: BACase.keyset()
                                            OR MBC_BA_Level_Case_FEAK__c In: BACase.keyset()
                                            OR MBC_BA_Level_Case_FEAK_Testing__c In: BACase.keyset()
                                            OR MBC_BA_Level_Case_Shared_Accums__c In: BACase.keyset())];
        
    
    Boolean InProgressStatus = false; Boolean InProgressStatus1 = false;
    Boolean FailedStatus=false;
    Boolean newTestStatus=false; 
    Boolean FeakAnalysisInProgressStatus=false;    
    //7246 - Including a new boolean value to track the passed testing records.
    Boolean passedStatus=false;     
        
    for(GEMS_MBC_Testing__c changeStatus : uniqueRec){      
        System.debug('changeStatus'+changeStatus);
        if(changeStatus.Status__c.contains('Failed')){
          FailedStatus = true;
        }        
        
        else if(changeStatus.Status__c.contains('In Progress') && changeStatus.MBC_BA_Level_Case_FEAK__c==null){
            InProgressStatus = true;
        }
        else if(changeStatus.Status__c.contains('In Progress') && changeStatus.MBC_BA_Level_Case_FEAK__c!=null){
            InProgressStatus1 = true;
        }
        else if(changeStatus.Status__c.contains('Passed')){
                passedStatus = true;
            }  
        else if(changeStatus.Status__c == 'New'){
            newTestStatus = true; 
        }
    }
        
    for(Case newStatus : CaseStatus){
        System.debug('newStatus'+newStatus);
       //6459 - Do not change the status of case if it is 'Return'.
        if(newstatus.status != 'Return'){
            System.debug('newstatus.status'+newstatus.status);
                
       If(FailedStatus){
            newstatus.status = 'Testing Failed';
            updateStatus.put(newStatus.id,newStatus);
       }
            //7430 - Mark the status of BA level medical benefit coding case as 'FEAK Analysis In Progress' if FEAK Analysis In Progress.
       
       else If(InProgressStatus){           
            newStatus.status = 'Testing In Progress';
            updateStatus.put(newStatus.id,newStatus);
        }
            else If(InProgressStatus1){           
            newStatus.status = 'FEAK Analysis In Progress';
            updateStatus.put(newStatus.id,newStatus);
        }
        //7246 - Mark the status of BA level medical benefit coding case as 'Testing Passed' if all the testing records are marked as Passed.
                else If(passedStatus){
                    newStatus.status = 'Testing Passed';
                    updateStatus.put(newStatus.id,newStatus);
                }    
        else If(newTestStatus){
           newStatus.Status = 'Medical Coding Complete';
           updateStatus.put(newStatus.id,newStatus);
        }
      
        }
    }
    if(!test.isRunningTest()){
    update updateStatus.values();
    }
    updBAChldCaseOwnRecurChk = true;
    }
    }
}
/******************************************************************** 
    *    Method Name : insertMBCBALevelStatus
    *   @description :   6459 - Update the status of MBC case when a new testing record is created and the case status meets certain criteria. 
    *   @parameters  :   List<GEMS_MBC_Testing__c> NewMBCTesting
    *   @return type :   void
    *   @Author : Bharath
    ***************************************************************/
public static void insertMBCBALevelStatus(List<GEMS_MBC_Testing__c> NewMBCTesting){
    if(!insBAChldCaseOwnRecurChk){
    Id CDHPTestingid = Schema.SObjectType.GEMS_MBC_Testing__c.getRecordTypeInfosByName().get('CDHP Testing').getRecordTypeId();
    Id DTUTestingid = Schema.SObjectType.GEMS_MBC_Testing__c.getRecordTypeInfosByName().get('DTU Testing').getRecordTypeId();
    Id FEAKAnalysisid = Schema.SObjectType.GEMS_MBC_Testing__c.getRecordTypeInfosByName().get('FEAK Analysis').getRecordTypeId();
    Id FEAKTestingid = Schema.SObjectType.GEMS_MBC_Testing__c.getRecordTypeInfosByName().get('FEAK Testing').getRecordTypeId();
    Id SharedAccumsTestingid = Schema.SObjectType.GEMS_MBC_Testing__c.getRecordTypeInfosByName().get('Shared Accums Testing').getRecordTypeId();
    
    Map<id,string> BACase = new Map<id,string>();
    Map<id,string> BACase1 = new Map<id,string>();
        
    for(GEMS_MBC_Testing__c TestRec: NewMBCTesting){
        if(TestRec.recordtypeid == CDHPTestingid){
            BACase.put(TestRec.MBC_BA_Level_Case_CDHP__c,TestRec.Status__c);
        }  
        else if(TestRec.recordtypeid == DTUTestingid){
            BACase.put(TestRec.MBC_BA_Level_Case_DTU__c,TestRec.Status__c);
        }  
        else if(TestRec.recordtypeid == FEAKTestingid){
            BACase.put(TestRec.MBC_BA_Level_Case_FEAK_Testing__c,TestRec.Status__c);
        }
        else if(TestRec.recordtypeid == SharedAccumsTestingid){
            BACase.put(TestRec.MBC_BA_Level_Case_Shared_Accums__c,TestRec.Status__c);
        }
    }
     //7430 - Feak Analysis 
    for(GEMS_MBC_Testing__c TestRec: NewMBCTesting){
        if(TestRec.recordtypeid == FEAKAnalysisid){
            BACase1.put(TestRec.MBC_BA_Level_Case_FEAK__c,TestRec.Status__c);
        }
        
    }
        
    //7430    
    if(!BACase.isEmpty() ||  !BACase1.isEmpty() ){
    Map<id,Case> updateStatus = new Map<id,Case>();
    List<Case> CaseStatus = [Select id, status, GEMS_Coding_Complete_Date__c from Case where id in : BACase.keyset()];
       //7430
    List<Case> CaseStatus1 = [Select id, status, GEMS_Coding_Complete_Date__c from Case where id in : BACase1.keyset()];
    for(Case newStatus : CaseStatus){        
        if(newstatus.status != 'Return' && newstatus.status != 'Testing Failed' && newstatus.status != 'Testing In Progress' 
           && newstatus.status != 'Medical Benefits Production Ready' ){
            newstatus.status = 'Testing In Progress';
            updateStatus.put(newStatus.id,newStatus);
             
        } }
        //7430
     for(Case newStatus : CaseStatus1){        
        if(newstatus.status != 'Return' && newstatus.status != 'Testing Failed' && newstatus.status != 'Testing In Progress' 
           && newstatus.status != 'Medical Benefits Production Ready' ){
            newstatus.status = 'FEAK Analysis In Progress';
            updateStatus.put(newStatus.id,newStatus);
             
           }}
        
       
   
    if(!test.isRunningTest()){
    update updateStatus.values();
    }
    insBAChldCaseOwnRecurChk = true;
    }
    }
}
    /******************************************************************** 
    *    Method Name : updateDTUSignOffDate
    *   @description :   6593 - This method will update the dtu sign off date in non-dtu testing records when the sign-off date of the first dtu record is updated.
    *   @parameters  :   List<GEMS_MBC_Testing__c> NewMBCTesting, Map<id,GEMS_MBC_Testing__c> oldMBC
    *   @return type :   void
    *   @Author : Bharath
    ***************************************************************/
    public static void updateDTUSignOffDate(List<GEMS_MBC_Testing__c> NewMBCTesting, Map<id,GEMS_MBC_Testing__c> oldMBC){
        if(!updDTUDateRecurChk){
        Set<Id> reqCases = new Set<Id>();
        Map<Id, GEMS_MBC_Testing__c> curTest = new Map<Id,GEMS_MBC_Testing__c>();
        List<GEMS_MBC_Testing__c> updTest = new List<GEMS_MBC_Testing__c>();
        Map<Id, GEMS_MBC_Testing__c> updTestRecs = new Map<Id, GEMS_MBC_Testing__c>();
        Map<Id, GEMS_MBC_Testing__c> updTests = new Map<Id, GEMS_MBC_Testing__c>();
        for(GEMS_MBC_Testing__c TestRec: NewMBCTesting){
            if(TestRec.DTU_Sign_Off_Date__c != oldMBC.get(TestRec.Id).DTU_Sign_Off_Date__c && 
              TestRec.MBC_BA_Level_Case_DTU__c != NULL){
                  reqCases.add(TestRec.MBC_BA_Level_Case_DTU__c);
                  curTest.put(TestRec.Id,TestRec);
            }
        }
        for(Id reqCase : reqCases){
            //Pick the first DTU record for each case and populate to updTestRecs.
            GEMS_MBC_Testing__c updTestRec = [select Id, DTU_Sign_Off_Date__c, MBC_BA_Level_Case_DTU__c from GEMS_MBC_Testing__c where MBC_BA_Level_Case_DTU__r.id = :reqCase order by name limit 1];
            //Check if the current record being processed is the first record.
            if(curTest.containsKey(updTestRec.Id)){
                updTestRecs.put(updTestRec.MBC_BA_Level_Case_DTU__c,updTestRec);
                updTests.put(updTestRec.Id,updTestRec);
            }
        }
        
        if(!updTestRecs.isEmpty()){
            //Process all the non-DTU test records for which the first DTU changed.
            List<GEMS_MBC_Testing__c> nonDTUTests = [select id, name, DTU_Sign_Off_Date__c, DTU_Record_Id_Invisible__c, 
                MBC_BA_Level_Case_CDHP__c, MBC_BA_Level_Case_FEAK__c, MBC_BA_Level_Case_FEAK_Testing__c, MBC_BA_Level_Case_Shared_Accums__c
                from GEMS_MBC_Testing__c where (MBC_BA_Level_Case_CDHP__c In: updTestRecs.keyset() OR 
                MBC_BA_Level_Case_FEAK__c In: updTestRecs.keyset() OR MBC_BA_Level_Case_FEAK_Testing__c In: updTestRecs.keyset() OR 
                MBC_BA_Level_Case_Shared_Accums__c In: updTestRecs.keyset())];
            for(GEMS_MBC_Testing__c nonDTUTest : nonDTUTests){
                if(nonDTUTest.DTU_Record_Id_Invisible__c != NULL && updTests.containsKey(nonDTUTest.DTU_Record_Id_Invisible__c)){
                    nonDTUTest.DTU_Sign_Off_Date__c = updTests.get(nonDTUTest.DTU_Record_Id_Invisible__c).DTU_Sign_Off_Date__c;
                    updTest.add(nonDTUTest);
                }
                else if(nonDTUTest.DTU_Record_Id_Invisible__c == NULL){
                    if(nonDTUTest.MBC_BA_Level_Case_CDHP__c != NULL){
                        nonDTUTest.DTU_Sign_Off_Date__c = updTestRecs.get(nonDTUTest.MBC_BA_Level_Case_CDHP__c).DTU_Sign_Off_Date__c;
                        nonDTUTest.DTU_Record_Id_Invisible__c = updTestRecs.get(nonDTUTest.MBC_BA_Level_Case_CDHP__c).Id;
                        updTest.add(nonDTUTest);
                    }
                    if(nonDTUTest.MBC_BA_Level_Case_FEAK__c != NULL){
                        nonDTUTest.DTU_Sign_Off_Date__c = updTestRecs.get(nonDTUTest.MBC_BA_Level_Case_FEAK__c).DTU_Sign_Off_Date__c;
                        nonDTUTest.DTU_Record_Id_Invisible__c = updTestRecs.get(nonDTUTest.MBC_BA_Level_Case_FEAK__c).Id;
                        updTest.add(nonDTUTest);
                    }
                    if(nonDTUTest.MBC_BA_Level_Case_FEAK_Testing__c != NULL){
                        nonDTUTest.DTU_Sign_Off_Date__c = updTestRecs.get(nonDTUTest.MBC_BA_Level_Case_FEAK_Testing__c).DTU_Sign_Off_Date__c;
                        nonDTUTest.DTU_Record_Id_Invisible__c = updTestRecs.get(nonDTUTest.MBC_BA_Level_Case_FEAK_Testing__c).Id;
                        updTest.add(nonDTUTest);
                    }
                    if(nonDTUTest.MBC_BA_Level_Case_Shared_Accums__c != NULL){
                        nonDTUTest.DTU_Sign_Off_Date__c = updTestRecs.get(nonDTUTest.MBC_BA_Level_Case_Shared_Accums__c).DTU_Sign_Off_Date__c;
                        nonDTUTest.DTU_Record_Id_Invisible__c = updTestRecs.get(nonDTUTest.MBC_BA_Level_Case_Shared_Accums__c).Id;
                        updTest.add(nonDTUTest);
                    }                                        
                }
            }
                        
        }
        if(!updTest.isEmpty()){
            update updTest;
        }
            updDTUDateRecurChk = true;
        }
    }    
}