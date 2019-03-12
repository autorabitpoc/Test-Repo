/********************
  Name:Roopa Pothuluri
  Project:SGR
  Date:1/10/2019
  Description: This class is used to clone complete Opportunity and its child objects.
  *********************/

public without sharing class Sgr_CloneOppty {

    @AuraEnabled
    public static Opportunity OppNew(Id oppId) {
        Id sgrAnalytOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SGR Analytical Opportunity').getRecordTypeId();
        Opportunity oppNew = [
                SELECT Id, SGR_Opportunity_Name__c, Cloned_From__c, SGR_Opportunity_Type__c, Name,
                        RecordType.DeveloperName, AccountId, Account_Market_Segment__c, HCSC_Division__c, Assigned_UW__c,
                        StageName, Funding_Type__c, Associated_Opportunity__c, Renewal_Date__c, Domestic_Partner__c,
                        Batch_Type__c, Batch_Id__c, County_Code__c, RecordTypeId, Zip_Code__c, CloseDate,
                        Date_to_GA__c, Date_to_Account__c, Date_to_Producer__c, Rating_Status__c,
                        SGR_Workflow_Activity__c, Workflow_System_Status__c, (SELECT Id, Name, Acc_Census_External_Id__c,
                        Opportunity__c, Account__c, Composite_Rates__c, Date_of_Birth__c, Dental_Tier__c,
                        Employee_Status_Code__c, First_Name__c, Gender__c, Group_Number__c, Group_Section_Number__c,
                        Opportunity_Group_Section__c, Health_Tier__c, Last_Name__c, Medicare_Primary__c,
                        Member_Benefit_Cancel_Date__c, Member_Benefit_Effective_Date__c, Member_Cancel_Date__c,
                        Member_Characteristic_Type__c, Member_Effective_Date__c, Member_Rates__c, Membership_Number__c,
                        Plan_Name__c, Relationship__c, Relationship_Code__c, Row__c, State__c, Subscriber_Number__c,
                        Tobacco_Use__c, Vision_Tier__c, Zip_Code__c, Dental_Plan_ID__c, Health_Plan_ID__c,
                        Vision_Plan_ID__c, Dental_Coverage__c, Health_Coverage__c, Vision_Coverage__c,
                        Backend_Created__c FROM Opportunity_Census__r), (SELECT Id, Name, Benefit_Agreement_Number__c,
                        Effective_Date__c, Funding_Type__c, Include_BA__c, Insurance_Type_Code__c, Line_of_Business__c,
                        Marketing_Plan_ID_13__c, Marketing_Plan_ID_7__c, Marketing_Plan_Name__c, Opportunity__c,Plan1__c,
                        Premium_Type__c, Product__c, Rate_Effective_Date__c, Rate_End_Date__c, Renewal_Date__c,
                        Renewal_Month__c, SGR_RemovedPlan__c, Status__c FROM Opportunity_Benefit_Agreements__r), (SELECT
                        Id, Name, BEN_AGMT_effective_date__c, BEN_AGMT_renewal_date__c, Benefit_Agreement__c,
                        Benefit_Agreement_Cancel_Date__c, Corporate_Product_Name__c, Corporate_Product_Number__c,
                        Funding_Type__c, Group_Name__c, Group_Section_Cancel_Code__c, Group_Section_Cancel_Date__c,
                        Group_Section_Original_Effective_Date__c, GS_External_Id__c, Invitro__c,Maternity__c,
                        Opportunity__c, Opportunity_Group_Number__c, Opportunity_Group_Section_Number__c, Status__c,
                        Total_Healthcare_Active_Members__c FROM Opportunity_Group_Section__r), (SELECT Id, Name,
                        Opt2_Plan_Id__c, Opt2_Renw_Age_Total_Est_Tax_and_Fees__c, Opt2_Renw_Age_Total_Monthly_Premium__c,
                        Opt2_Renw_Comp_Total_Est_Tax_and_Fees__c, Opt2_Renw_Comp_Total_Monthly_Premium__c,
                        Opt3_Plan_Id__c, Opt3_Renw_Age_Total_Est_Tax_and_Fees__c, Opt3_Renw_Age_Total_Monthly_Premium__c,
                        Opt3_Renw_Comp_Total_Est_Tax_and_Fees__c, Opt3_Renw_Comp_Total_Monthly_Premium__c, Plan__c,
                        Prototype_Plan_Indicated__c, Prototype_Plan_Level__c, Plan_Name__c, Plan_Status__c, Plan_Type__c,
                        Prototype_Project_Mo_Premium__c, Rate_Effective__c, Rate_Effective_Date__c, Rate_Size_Code__c,
                        Rate_Type_Code__c, RecordId__c, Renw_Age_Total_Est_Tax_and_Fees__c,
                        Renw_Age_Total_Monthly_Premium__c, Renw_Comp_Total_Est_Tax_and_Fees__c,
                        Renw_Comp_Total_Monthly_Premium__c, Sales_Plan_ID__c, Sold_Date__c, Test_plan__c,
                        Tier_Agreement_Sequence_Number__c, Tier_Number__c, Type__c, Opportunity__c FROM
                        Opportunity_Plan_Rates__r), (SELECT Id, Name, Event_Message__c, Event_Type__c,
                        Opportunity__c FROM EventAuditTrails__r)
                FROM Opportunity
                WHERE Id = :oppId
                LIMIT 1
        ];


        List<Opportunity_BA_GS_Assignment__c> BA_GSRecs = new List<Opportunity_BA_GS_Assignment__c>([
                SELECT Id, Opportunity_Group_Section__c, Opportunity_Benefit_Agreement__c, External_ID__c
                FROM Opportunity_BA_GS_Assignment__c
                WHERE Opportunity_Benefit_Agreement__r.Opportunity__c = :oppId
                LIMIT 1000
        ]);
        Opportunity clonedOpp = oppNew.clone(true, true, false, false);
        clonedOpp.Id = null;
        if (oppNew.SGR_Opportunity_Type__c == 'Analytical') {
            clonedOpp.Associated_Opportunity__c = oppId;
        } else {
            if (oppNew.SGR_Opportunity_Type__c == 'Production' && oppNew.Rating_Status__c != 'Sold') {
                clonedOpp.Cloned_From__c = oppId;
                clonedOpp.SGR_Opportunity_Name__c = 'Analytical';
            } else {
                if (oppNew.SGR_Opportunity_Type__c == 'Production' && oppNew.Rating_Status__c == 'Sold') {
                    clonedOpp.Rating_Status__c = 'Marketing Release';
                    clonedOpp.Cloned_From__c = oppId;
                    clonedOpp.SGR_Opportunity_Name__c = 'Analytical';
                }
            }
            if (oppNew.SGR_Opportunity_Type__c == 'Production' && oppNew.Rating_Status__c != 'Closed') {
                clonedOpp.Cloned_From__c = oppId;
                clonedOpp.SGR_Opportunity_Name__c = 'Analytical';
            } else {
                if (oppNew.SGR_Opportunity_Type__c == 'Production' && oppNew.Rating_Status__c == 'Closed') {
                    clonedOpp.Rating_Status__c = 'Marketing Release';
                    clonedOpp.Cloned_From__c = oppId;
                    clonedOpp.SGR_Opportunity_Name__c = 'Analytical';
                }
            }
            if (oppNew.SGR_Opportunity_Type__c == 'Production' && oppNew.Rating_Status__c != 'Finalized') {
                clonedOpp.Cloned_From__c = oppId;
                clonedOpp.SGR_Opportunity_Name__c = 'Analytical';
            } else {
                if (oppNew.SGR_Opportunity_Type__c == 'Production' && oppNew.Rating_Status__c == 'Finalized') {
                    clonedOpp.Rating_Status__c = 'Marketing Release';
                    clonedOpp.Cloned_From__c = oppId;
                    clonedOpp.SGR_Opportunity_Name__c = 'Analytical';
                }
            }
            if (oppNew.RecordType.DeveloperName == 'sgr_production_opportunity') {
                clonedOpp.RecordTypeId = sgrAnalytOpp;
            }
        }
        clonedOpp = insertopprec(clonedOpp);
        createEventAuditLogNew(oppId, clonedOpp);
        createEventAuditLogOld(oppId, clonedOpp);
        Map<Id, Id> newGARecID = new Map<Id, Id>();               // used for grouping in junction object
        Map<Id, Id> newBARecID = new Map<Id, Id>();               // used for grouping in junction object
        Map<Id, Id> newCensuRecID = new Map<Id, Id>();            // not reuired just used
        Map<Id, Id> newPlanRatesID = new Map<Id, Id>();
        Map<Id, Id> newEventID = new Map<Id, Id>();

        Map<String, String> replaceCensusValues = new Map<String, String>();  // used for replacing the values to be replaced with
        replaceCensusValues.put('Id', null);
        replaceCensusValues.put('Opportunity__c', clonedOpp.Id);
        createChildRecord(clonedOpp, newCensuRecID, 'Opportunity_Census__r', replaceCensusValues);

        Map<String, String> replaceBAValues = new Map<String, String>();  // used for replacing the values to be replaced with
        replaceBAValues.put('Id', null);
        replaceBAValues.put('Opportunity__c', clonedOpp.Id);
        replaceBAValues.put('Opportunity__c', clonedOpp.Id);
        createChildRecord(clonedOpp, newBARecID, 'Opportunity_Benefit_Agreements__r', replaceBAValues);

        Map<String, String> replaceGAValues = new Map<String, String>();  // used for replacing the values to be replaced with
        replaceGAValues.put('Id', null);
        replaceGAValues.put('Opportunity__c', clonedOpp.Id);
        createChildRecord(clonedOpp, newGARecID, 'Opportunity_Group_Section__r', replaceGAValues);

        Map<String, String> replacePRValues = new Map<String, String>();  // used for replacing the values to be replaced with
        replacePRValues.put('Id', null);
        replacePRValues.put('Opportunity__c', clonedOpp.Id);
        createChildRecord(clonedOpp, newPlanRatesID, 'Opportunity_Plan_Rates__r', replacePRValues);

        Map<String, String> replaceEventValues = new Map<String, String>();  // used for replacing the values to be replaced with
        replaceEventValues.put('Id', null);
        replaceEventValues.put('Opportunity__c', clonedOpp.Id);
        createChildRecord(clonedOpp, newEventID, 'EventAuditTrails__r', replaceEventValues);

        createBAGSRecords(newGARecID, newBARecID, BA_GSRecs);
        return clonedOpp;
    }

    @AuraEnabled
    public static void createChildRecord(SObject clonedRec, Map<Id, Id> newRecID, String sobjectRelName, Map<String, String> replaceValues) {
        try {
            Map<Integer, Id> tmpNewRecID = new Map<Integer, Id> ();
            List<SObject> childRecords = clonedRec.getSObjects(sobjectRelName);
            if (clonedRec != null && childRecords != null) {
                for (Integer i = 0; i < childRecords.size(); i++) {// SObject rec :childRecords){
                    tmpNewRecID.put(i, childRecords[i].Id);
                    for (String fieldName : replaceValues.keySet()) {
                        childRecords[i].put(fieldName, replaceValues.get(fieldName)) ;
                    }
                }
                Database.SaveResult[] result = Database.insert(childRecords, true);
                if (newRecID != null && newRecID.keySet() != null) {
                    for (Integer i = 0; i < result.size(); i++) {
                        newRecID.put(tmpNewRecID.get(i), result[i].getId());
                    }
                }
            }
        } catch (Exception EX) {
            System.debug('Exception Occured' + EX.getStackTraceString());

        }

    }

    @AuraEnabled    // check if this you need to do generic like the above method
    public static Opportunity insertopprec(Opportunity clonedOpp) {
        if (clonedOpp != null) {
            try {
                insert clonedOpp;
            } catch (Exception Ex) {
            }
        } return clonedOpp;
    }

    @AuraEnabled
    public static void createEventAuditLogNew(Id oppId, Opportunity clonedOpp) {
        String eventType = 'Internal Workflow';
        String eventmsg = 'Cloned From Existing Opportunity :';
        EventAuditTrail__c ev = new EventAuditTrail__c();
        ev.Event_Message__c = eventmsg + oppId;
        ev.Event_Type__c = eventType;
        ev.Opportunity__c = clonedOpp.Id;
        ev.Name = 'Cloned Opportunity';
        insert ev;

    }
    @AuraEnabled
    public static void createEventAuditLogOld(Id oppId, Opportunity clonedOpp) {
        String eventType = 'Internal Workflow';
        String eventmsg = 'Opportunity Cloned :';
        EventAuditTrail__c ev = new EventAuditTrail__c();
        ev.Event_Message__c = eventmsg + oppId;
        ev.Event_Type__c = eventType;
        ev.Opportunity__c = clonedOpp.Id;
        ev.Name = 'New Created Opportunity';
        insert ev;

    }

    @AuraEnabled  // check if this you need to do generic like the above method
    public static void createBAGSRecords(Map<Id, Id> newGARecID, Map<Id, Id> newBARecID, List<Opportunity_BA_GS_Assignment__c> BAGS_Records) {
        List<Opportunity_BA_GS_Assignment__c> childrecs = new List<Opportunity_BA_GS_Assignment__c >();
        for (Opportunity_BA_GS_Assignment__c BA_GRecA : BAGS_Records) {
            childrecs.add(new Opportunity_BA_GS_Assignment__c(External_ID__c = BA_GRecA.External_ID__c,
                    Opportunity_Benefit_Agreement__c = newBARecID.get(BA_GRecA.Opportunity_Benefit_Agreement__c),
                    Opportunity_Group_Section__c = newGARecID.get(BA_GRecA.Opportunity_Group_Section__c)));
        }
        Database.SaveResult[] result = Database.insert(childrecs, true);
    }
}