public class Trigger_SGR_Opportunity_Census_Helper {
    
    public static void createSGROpportunityMemberBenefits(List<SGR_Opportunity_Census__c> listInput){
        System.debug('in Trigger_SGR_Opportunity_Census_Helper.createSGROpportunityMemberBenefits');
        
        List<SGR_Opportunity_Member_Benefits__c> listFinal = new List<SGR_Opportunity_Member_Benefits__c>();
        
        //Get the Oppportunity Plan Rate records that will be needed based on the data in the Opportunity Census records
        List<SGR_Opportunity_Plan_Rate__c> listOpportunityPlanRates = new List<SGR_Opportunity_Plan_Rate__c>();        
        listOpportunityPlanRates = getRatesForTheInput(listInput);
        
        //Get the Opportunity Group Section records that will be needed based on the data in the Opportunity Census records
        List<SGR_Opportunity_Group_Section__c> listOpportunityGroupSections = new List<SGR_Opportunity_Group_Section__c>();
        listOpportunityGroupSections = getOpportunityGroupSections(listInput);
        
        //Handle the Health
        for(SGR_Opportunity_Census__c aRecord : listInput){
            if(String.isNotEmpty(aRecord.Health_Plan_ID__c)){                
                SGR_Opportunity_Member_Benefits__c anEntry = createInsertRecords(aRecord,'Health',listOpportunityPlanRates,listOpportunityGroupSections);                
                //Do not want to Add Records where Lookup to Opportunity_Plan_Rate__c is not established
                if(String.isNotEmpty(anEntry.Opportunity_Plan_Rate__c)){
                    listFinal.add(anEntry);
                }                   
            }
        }
        
        //Handle the Dental
        for(SGR_Opportunity_Census__c aRecord : listInput){
            if(String.isNotEmpty(aRecord.Dental_Plan_ID__c)){                
                SGR_Opportunity_Member_Benefits__c anEntry = createInsertRecords(aRecord,'Dental',listOpportunityPlanRates,listOpportunityGroupSections);                      
                //Do not want to Add Records where Lookup to Opportunity_Plan_Rate__c is not established
                if(String.isNotEmpty(anEntry.Opportunity_Plan_Rate__c)){
                    listFinal.add(anEntry);
                }                   
            }            
        }        
        
        //Handle the Vision
        for(SGR_Opportunity_Census__c aRecord : listInput){
            if(String.isNotEmpty(aRecord.Vision_Plan_ID__c)){                
                SGR_Opportunity_Member_Benefits__c anEntry = createInsertRecords(aRecord,'Vision',listOpportunityPlanRates,listOpportunityGroupSections);                
                //Do not want to Add Records where Lookup to Opportunity_Plan_Rate__c is not established
                if(String.isNotEmpty(anEntry.Opportunity_Plan_Rate__c)){
                    listFinal.add(anEntry);
                }                   
            }            
        }        
        
        //Insert the records
        if(listFinal.size() > 0){
            try{
                insert listFinal;    
            }catch (DmlException e){
                CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Trigger', 'SGR_Opportunity_Census__c', 'Trigger_SGR_Opportunity_Census_Helper', 'createSGROpportunityMemberBenefits', 'High');                                                           
            }            
        }        
    }
    
    public static void updateSGROpportunityMemberBenefits(List<SGR_Opportunity_Census__c> listInput, map<Id,SGR_Opportunity_Census__c> oldMapInput){
        
        System.debug('in Trigger_SGR_Opportunity_Census_Helper.updateSGROpportunityMemberBenefits');
        
        List<SGR_Opportunity_Member_Benefits__c> listToInsert = new List<SGR_Opportunity_Member_Benefits__c>();
        List<SGR_Opportunity_Member_Benefits__c> listToUpdate = new List<SGR_Opportunity_Member_Benefits__c>();
        List<SGR_Opportunity_Member_Benefits__c> listToDelete = new List<SGR_Opportunity_Member_Benefits__c>();
        List<SGR_Opportunity_Member_Benefits__c> listOfExisting = new List<SGR_Opportunity_Member_Benefits__c>();
        
        SGR_Opportunity_Member_Benefits__c existingOpportunityMemberBenefit = new SGR_Opportunity_Member_Benefits__c();
        
        Set<Id> listInputIDs = new Set<Id>();
        
        Boolean foundRecord;
        
        //Create a Set of IDs for the input List
        for(SGR_Opportunity_Census__c aRecord : listInput){
            listInputIDs.add(aRecord.Id);
        }
        
        //Use the Set of IDs to get the existing SGR Opportunity Member Benefits records        
        listOfExisting = [SELECT
                          ID,
                          Name,
                          Line_of_Business__c,
                          Opportunity_Census__c,
                          Opportunity_Group_Section__c,
                          Opportunity_Plan_Rate__c
                          FROM SGR_Opportunity_Member_Benefits__c
                          WHERE Opportunity_Census__c IN :listInputIDs
                          LIMIT 2000];               
        
        for(SGR_Opportunity_Member_Benefits__c aRecord : listOfExisting){
            System.debug('Existing:  ' + aRecord.Id + ' ' + aRecord.Line_of_Business__c + ' ' + aRecord.Opportunity_Census__c);
        }
        
        //Get the Oppportunity Plan Rate records that will be needed based on the data in the Opportunity Census records
        List<SGR_Opportunity_Plan_Rate__c> listOpportunityPlanRates = new List<SGR_Opportunity_Plan_Rate__c>();
        listOpportunityPlanRates = getRatesForTheInput(listInput);    
        
        //Get the Opportunity Group Section records that will be needed based on the data in the Opportunity Census records
        List<SGR_Opportunity_Group_Section__c> listOpportunityGroupSections = new List<SGR_Opportunity_Group_Section__c>();
        listOpportunityGroupSections = getOpportunityGroupSections(listInput);        
        
        //Handle the Health
        for(SGR_Opportunity_Census__c aRecord : listInput){
            
            foundRecord = checkExistingOppMbrBenefits(listOfExisting,'H',aRecord);
            
            if(foundRecord == true){
                //Had an existing Record
                existingOpportunityMemberBenefit = getExistingRecord(listOfExisting,'H',aRecord);
                
                if(String.isNotEmpty(aRecord.Health_Plan_ID__c)){         
                    //Health Plan is not empty, Need to update existing record
                    
                    //Use the common method to get a Temp Record and then take that value to put on existing record
                    SGR_Opportunity_Member_Benefits__c tempEntry = createInsertRecords(aRecord,'Health',listOpportunityPlanRates,listOpportunityGroupSections);                
                    
                    //Swap the tempEntry onto the existingRecord                    
                    existingOpportunityMemberBenefit.Opportunity_Plan_Rate__c = tempEntry.Opportunity_Plan_Rate__c;  
                    existingOpportunityMemberBenefit.Opportunity_Group_Section__c = tempEntry.Opportunity_Group_Section__c;
                    listToUpdate.add(existingOpportunityMemberBenefit);
                    
                }else{
                    //Health Plan is empty, Need to delete existing record
                    listToDelete.add(existingOpportunityMemberBenefit);                    
                }
            }else{
                //Had no existing Record
                if(String.isNotEmpty(aRecord.Health_Plan_ID__c)){                
                    SGR_Opportunity_Member_Benefits__c anEntry = createInsertRecords(aRecord,'Health',listOpportunityPlanRates,listOpportunityGroupSections);                
                    //Do not want to Add Records where Lookup to Opportunity_Plan_Rate__c is not established
                    if(String.isNotEmpty(anEntry.Opportunity_Plan_Rate__c)){
                        listToInsert.add(anEntry);
                    }    
                }                
            }            
        }
        
        //Handle the Dental
        for(SGR_Opportunity_Census__c aRecord : listInput){
            
            foundRecord = checkExistingOppMbrBenefits(listOfExisting,'D',aRecord);
            
            if(foundRecord == true){
                //Had an existing Record
                existingOpportunityMemberBenefit = getExistingRecord(listOfExisting,'D',aRecord);
                
                if(String.isNotEmpty(aRecord.Dental_Plan_ID__c)){         
                    //Health Plan is not empty, Need to update existing record
                    
                    //Use the common method to get a Temp Record and then take that value to put on existing record
                    SGR_Opportunity_Member_Benefits__c tempEntry = createInsertRecords(aRecord,'Dental',listOpportunityPlanRates,listOpportunityGroupSections);                
                    
                    //Swap the tempEntry onto the existingRecord                    
                    existingOpportunityMemberBenefit.Opportunity_Plan_Rate__c = tempEntry.Opportunity_Plan_Rate__c;
                    existingOpportunityMemberBenefit.Opportunity_Group_Section__c = tempEntry.Opportunity_Group_Section__c;                    
                    listToUpdate.add(existingOpportunityMemberBenefit);
                    
                }else{
                    //Dental Plan is empty, Need to delete existing record
                    listToDelete.add(existingOpportunityMemberBenefit);                    
                }
            }else{
                //Had no existing Record
                if(String.isNotEmpty(aRecord.Dental_Plan_ID__c)){                
                    SGR_Opportunity_Member_Benefits__c anEntry = createInsertRecords(aRecord,'Dental',listOpportunityPlanRates,listOpportunityGroupSections);                
                    //Do not want to Add Records where Lookup to Opportunity_Plan_Rate__c is not established
                    if(String.isNotEmpty(anEntry.Opportunity_Plan_Rate__c)){
                        listToInsert.add(anEntry);
                    }    
                }                
            }            
        }        
        
        //Handle the Vision
        for(SGR_Opportunity_Census__c aRecord : listInput){
            
            foundRecord = checkExistingOppMbrBenefits(listOfExisting,'V',aRecord);
            
            if(foundRecord == true){
                //Had an existing Record
                existingOpportunityMemberBenefit = getExistingRecord(listOfExisting,'V',aRecord);
                
                if(String.isNotEmpty(aRecord.Vision_Plan_ID__c)){         
                    //Health Plan is not empty, Need to update existing record
                    
                    //Use the common method to get a Temp Record and then take that value to put on existing record
                    SGR_Opportunity_Member_Benefits__c tempEntry = createInsertRecords(aRecord,'Vision',listOpportunityPlanRates,listOpportunityGroupSections);                
                    
                    //Swap the tempEntry onto the existingRecord                    
                    existingOpportunityMemberBenefit.Opportunity_Plan_Rate__c = tempEntry.Opportunity_Plan_Rate__c;                    
                    existingOpportunityMemberBenefit.Opportunity_Group_Section__c = tempEntry.Opportunity_Group_Section__c;
                    listToUpdate.add(existingOpportunityMemberBenefit);
                    
                }else{
                    //Vision Plan is empty, Need to delete existing record
                    listToDelete.add(existingOpportunityMemberBenefit);                    
                }
            }else{
                //Had no existing Record
                if(String.isNotEmpty(aRecord.Vision_Plan_ID__c)){                
                    SGR_Opportunity_Member_Benefits__c anEntry = createInsertRecords(aRecord,'Vision',listOpportunityPlanRates,listOpportunityGroupSections);                
                    //Do not want to Add Records where Lookup to Opportunity_Plan_Rate__c is not established
                    if(String.isNotEmpty(anEntry.Opportunity_Plan_Rate__c)){
                        listToInsert.add(anEntry);
                    }    
                }                
            }            
        }
        
        //Delete the Old Records
        if(listToDelete.size() > 0){
            try{
                delete listToDelete;    
            }catch (DmlException e){
                CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Trigger', 'SGR_Opportunity_Census__c', 'Trigger_SGR_Opportunity_Census_Helper', 'updateSGROpportunityMemberBenefits', 'High');                                                           
            }               
        }        
        
        //Insert the New Records
        if(listToInsert.size() > 0){
            try{
                insert listToInsert;    
            }catch (DmlException e){
                CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Trigger', 'SGR_Opportunity_Census__c', 'Trigger_SGR_Opportunity_Census_Helper', 'updateSGROpportunityMemberBenefits', 'High');                                                           
            }            
        }
        
        //Update the Existing Records
        if(listToUpdate.size() > 0){
            try{
                update listToUpdate;
            }catch (DmlException e){
                CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Trigger', 'SGR_Opportunity_Census__c', 'Trigger_SGR_Opportunity_Census_Helper', 'updateSGROpportunityMemberBenefits', 'High');                                                           
            }
        }        
    }
    
    public static void deleteSGROpportunityMemberBenefits(List<SGR_Opportunity_Census__c> listInput){
        System.debug('in Trigger_SGR_Opportunity_Census_Helper.deleteSGROpportunityMemberBenefits');
        
        List<Id> listIDsDeleted = new List<Id>();
        
        for(SGR_Opportunity_Census__c aRecord : listInput){
            listIDsDeleted.add(aRecord.Id);
        }
        
        List<SGR_Opportunity_Member_Benefits__c> listFinal = new List<SGR_Opportunity_Member_Benefits__c>();  
        
        listFinal = [SELECT 
                     Id,
                     Opportunity_Census__c
                     FROM SGR_Opportunity_Member_Benefits__c
                     WHERE
                     Opportunity_Census__c IN :listInput];
        
        if(listFinal.size() > 0){
            try{
                delete listFinal;    
            }catch (DmlException e){
                CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Trigger', 'SGR_Opportunity_Census__c', 'Trigger_SGR_Opportunity_Census_Helper', 'deleteSGROpportunityMemberBenefits', 'High');                                                           
            }               
        }
    }
    
    //**********************************************************************//
    //               P R I V A T E  M E T H O D S  B E L O W                //
    // *********************************************************************//
    
    private static List<SGR_Opportunity_Group_Section__c> getOpportunityGroupSections(List<SGR_Opportunity_Census__c> listInput){
        List<SGR_Opportunity_Group_Section__c> returnList = new List<SGR_Opportunity_Group_Section__c>();
        
        Set<String> setOfOppGrpSecNames = new Set<String>();
        
        for(SGR_Opportunity_Census__c aRecord: listInput){
            if(String.isNotEmpty(aRecord.Health_Group_Section__c)){
                setOfOppGrpSecNames.add(aRecord.Health_Group_Section__c);                
            }
            if(String.isNotEmpty(aRecord.Dental_Group_Section__c)){
                setOfOppGrpSecNames.add(aRecord.Dental_Group_Section__c);                
            }
            if(String.isNotEmpty(aRecord.Vision_Group_Section__c)){
                setOfOppGrpSecNames.add(aRecord.Vision_Group_Section__c);                
            }
        }
        
        returnList = [SELECT 
                      Id,
                      Opportunity_Group_Section_Number__c
                      FROM SGR_Opportunity_Group_Section__c
                      WHERE
                      Opportunity_Group_Section_Number__c IN :setOfOppGrpSecNames 
                      LIMIT 2000];
        
        return returnList;
    }
    
    private static Boolean checkExistingOppMbrBenefits (List<SGR_Opportunity_Member_Benefits__c> inputExisting, string inputCheckFor, SGR_Opportunity_Census__c inputCensus){
        Boolean returnValue = false;
        
        for(SGR_Opportunity_Member_Benefits__c aRecord: inputExisting){
            if(aRecord.Line_of_Business__c == inputCheckFor){
                if(aRecord.Opportunity_Census__c == inputCensus.Id){
                    returnValue = true;
                    break;
                }
            }
        }
        
        return returnValue;
    } 
    
    private static SGR_Opportunity_Member_Benefits__c getExistingRecord(List<SGR_Opportunity_Member_Benefits__c> inputExisting, string inputCheckFor, SGR_Opportunity_Census__c inputCensus){
        SGR_Opportunity_Member_Benefits__c returnValue = new SGR_Opportunity_Member_Benefits__c();
        
        for(SGR_Opportunity_Member_Benefits__c aRecord: inputExisting){
            if(aRecord.Line_of_Business__c == inputCheckFor){
                if(aRecord.Opportunity_Census__c == inputCensus.Id){
                    returnValue = aRecord;
                    break;
                }
            }
        }
        
        return returnValue;
    }
    
    private static SGR_Opportunity_Member_Benefits__c createInsertRecords(SGR_Opportunity_Census__c inputRecord, String inputNamePart1, List<SGR_Opportunity_Plan_Rate__c> inputListOpportunityPlanRates,List<SGR_Opportunity_Group_Section__c> inputListOpportunityGroupSection){
        
        SGR_Opportunity_Member_Benefits__c theReturn = new SGR_Opportunity_Member_Benefits__c();
        
        DateTime dttmNow = DateTime.now();
        String stringDTTMForName = dttmNow.format('yyyyMMddhhmmssSSS', 'America/Chicago'); 	
        
        theReturn.Name = inputNamePart1 + ' ' + inputRecord.Health_Plan_ID__c + ' ' + stringDTTMForName;  //Name Subject to Design Change
        theReturn.Opportunity_Census__c = inputRecord.Id;  //Set the Opportunity Census Reference        
        
        switch on inputNamePart1{
            when 'Health'{
                theReturn.Name = inputNamePart1 + ' ' + inputRecord.Health_Plan_ID__c + ' ' + stringDTTMForName;  //Name Subject to Design Change
                if(String.isNotBlank(inputRecord.Health_Group_Section__c)){
                    Id tempValue = getOpportunityGroupSectionID(inputListOpportunityGroupSection, inputRecord, 'Health');                    
                    theReturn.Opportunity_Group_Section__c = tempValue;                    
                }                
            }
            when 'Dental'{
                theReturn.Name = inputNamePart1 + ' ' + inputRecord.Dental_Plan_ID__c + ' ' + stringDTTMForName;  //Name Subject to Design Change
                if(String.isNotBlank(inputRecord.Dental_Group_Section__c)){
                    Id tempValue = getOpportunityGroupSectionID(inputListOpportunityGroupSection, inputRecord, 'Dental');                    
                    theReturn.Opportunity_Group_Section__c = tempValue;   
                }                
            }
            when 'Vision'{
                theReturn.Name = inputNamePart1 + ' ' + inputRecord.Vision_Plan_ID__c + ' ' + stringDTTMForName;  //Name Subject to Design Change
                if(String.isNotBlank(inputRecord.Dental_Group_Section__c)){
                    Id tempValue = getOpportunityGroupSectionID(inputListOpportunityGroupSection, inputRecord, 'Vision');                    
                    theReturn.Opportunity_Group_Section__c = tempValue;  
                }                
            }
        } 
        
        theReturn.Opportunity_Plan_Rate__c = getRateID(inputNamePart1,inputListOpportunityPlanRates,inputRecord);                
        
        return theReturn;
    }
    
    private static Id getOpportunityGroupSectionID(List<SGR_Opportunity_Group_Section__c> inputListOppGrpSec, SGR_Opportunity_Census__c inputOppCensus, String inputNamePart1){
        
        Id returnValue;
        
        String tempName; 
        
        Switch on inputNamePart1{
            when 'Health'{
                tempName = inputOppCensus.Health_Group_Section__c;
            }
            when 'Vision'{
                tempName = inputOppCensus.Vision_Group_Section__c;
            }
            when 'Dental'{
                tempName = inputOppCensus.Dental_Group_Section__c;
            }
        }
        
        for(SGR_Opportunity_Group_Section__c aRecord : inputListOppGrpSec){
            if(aRecord.Opportunity_Group_Section_Number__c == tempName){
                returnValue = aRecord.Id;
                break;
            }
        }
        
        return returnValue;        
    }
    
    private static List<SGR_Opportunity_Plan_Rate__c> getRatesForTheInput(List<SGR_Opportunity_Census__c> listInput){
        
        List<SGR_Opportunity_Plan_Rate__c> returnList = new List<SGR_Opportunity_Plan_Rate__c>();
        
        //Create a list of Health, Dental, and Vision Plan Ids using the input List
        Map<String,Id> mapPlanIdsOnInput = new Map<String,Id>();        
        for(SGR_Opportunity_Census__c aRecord : listInput){
            
            //Check the Health field
            if(String.isNotEmpty(aRecord.Health_Plan_ID__c)){
                mapPlanIdsOnInput.put(aRecord.Health_Plan_ID__c,aRecord.Id);
            }
            
            //Check the Dental field
            if(String.isNotEmpty(aRecord.Dental_Plan_ID__c)){
                mapPlanIdsOnInput.put(aRecord.Dental_Plan_ID__c,aRecord.Id);
            }
            
            //Check the Vision field
            if(String.isNotEmpty(aRecord.Vision_Plan_ID__c)){
                mapPlanIdsOnInput.put(aRecord.Vision_Plan_ID__c,aRecord.Id);
            }            
        }
        
        //Get the Oppportunity Plan Rate records that will be needed based on the data in the Opportunity Census records      
        returnList = [SELECT 
                      Id, 
                      Account__c,
                      Type__c,
                      Plan__c,
                      Plan__r.Line_of_Business__c,
                      Plan_Name__c
                      FROM SGR_Opportunity_Plan_Rate__c
                      WHERE
                      Type__c = 'Renewal' 
                      AND
                      Plan_Name__c IN :mapPlanIdsOnInput.keySet()
                      LIMIT 2000];                
        
        //Strip out those records where the Plan__r.Line_of_Business__c is not established
        List<SGR_Opportunity_Plan_Rate__c> listTemp = new List<SGR_Opportunity_Plan_Rate__c>();
        for (SGR_Opportunity_Plan_Rate__c aRate : returnList){
            if(String.isNotEmpty(ARate.Plan__r.Line_of_Business__c)){
                listTemp.add(aRate);
            }
        }        
        returnList.clear();
        
        returnList.addAll(listTemp);
        
        return returnList;                
    }
    
    private static Id getRateID(String inputWhichPlan, List<SGR_Opportunity_Plan_Rate__c> inputListOpportunityPlanRates, SGR_Opportunity_Census__c inputOpportunityCensus){
        
        Id returnID;
        
        Boolean booleanBreakLoop = false;        
        
        for(SGR_Opportunity_Plan_Rate__c aRate : inputListOpportunityPlanRates){
            
            if(inputWhichPlan == 'Health'){
                if(inputOpportunityCensus.Health_Plan_ID__c == aRate.Plan_Name__c){
                    booleanBreakLoop = true; 
                    returnID = aRate.Id;  
                }
            }
            
            if(inputWhichPlan == 'Dental'){
                if(inputOpportunityCensus.Dental_Plan_ID__c == aRate.Plan_Name__c){
                    booleanBreakLoop = true; 
                    returnID = aRate.Id;  
                }
            }
            
            if(inputWhichPlan == 'Vision'){
                if(inputOpportunityCensus.Vision_Plan_ID__c == aRate.Plan_Name__c){
                    booleanBreakLoop = true; 
                    returnID = aRate.Id;  
                }
            }
            
            if(booleanBreakLoop == true){
                break;
            }
            
        }
        return returnID;
    }
    
}