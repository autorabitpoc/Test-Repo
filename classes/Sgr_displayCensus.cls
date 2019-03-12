public without sharing class Sgr_displayCensus {
    
    @AuraEnabled
    public static List<SGR_Opportunity_Census__c> OppCensus(Id oppId, String tier) {
        List<SGR_Opportunity_Census__c> returnList = new List <SGR_Opportunity_Census__c> ();

        List<String> marList = new List<String>();
        for (SGR_Opportunity_Benefit_Agreement__c ob : [SELECT Marketing_Plan_ID_13__c FROM SGR_Opportunity_Benefit_Agreement__c WHERE Opportunity__c = :oppId]) {
            marList.add(ob.Marketing_Plan_ID_13__c);
        }
        List <SGR_Opportunity_Census__c> lstOfOppCensus = [
                SELECT Id, SGR_DentalIsChecked__c,SGR_HealthIsChecked__c,SGR_VisionIsChecked__c,CensusId__c,Name, Date_of_Birth__c,Gender__c,Retiree__c,State_Continuation__c
                        ,CreatedDate,Created_Date_only__c, CreatedBy.Name, LastModifiedDate,Last_Modify_Date_Only__c, LastModifiedBy.Name,LastModifiedById, Age__c,
                        LastViewedDate, LastReferencedDate, Opportunity__c, Subscriber_Number__c, COBRA__c,
                        Membership_Number__c, Age_New__c,Last_Name__c, First_Name__c, Member_Effective_Date__c,
                        Member_Cancel_Date__c, Relationship__c, Zip_Code__c, Medicare_Primary__c, Tobacco_Use__c,Tobacco_Y_N__c, Plan_Name__c,
                        Group_Number__c, Member_Benefit_Effective_Date__c, Member_Benefit_Cancel_Date__c,Subscriber_number1__c,
                        Total_Number_of_Health_Subscribers__c,Row__c, Health_Plan_ID__c, Dental_Tier__c, Dental_Plan_ID__c,Vision_Comp__c,Dental_comp__c,Health_Comp__c,
                        Relationship_Code__c, Member_Characteristic_Type__c,Acc_Census_External_Id__c, State__c,
                        Health_Tier__c, Vision_Tier__c, Vision_Plan_ID__c,Employee_Status_Code__c, Account__c,Group_Section_Number__c,Dental_Coverage__c,Vision_Coverage__c,Health_Coverage__c,
                        Group_Section_Number__r.Name, Member_Rates__c, Composite_Rates__c,Opportunity__r.Rating_Status__c,Opportunity__r.HCSC_Division__c,
                        Opportunity__r.Account.Domestic_Partner__c,Opportunity__r.Renewal_Date__c,Opportunity_Group_Section__r.Opportunity_Group_Section_Number__c,
                        Health_Group_Number__c,Dental_Group_Number__c,Vision_Group_Number__c,Health_Group_Section__c,Dental_Group_Section__c,Vision_Group_Section__c
                FROM SGR_Opportunity_Census__c
                WHERE Opportunity__c = :oppId AND Relationship__c = 'Subscriber'
                LIMIT 100
        ];
        
        for (SGR_Opportunity_Census__c oppcen : lstOfOppCensus) {
            returnList.add(oppcen);
        }
        return returnList;
    }

    public static List<SGR_Opportunity_Census__c> updateTier(Id opptyId, String tabName, SGR_Opportunity_Census__c optyCensusList) {
        Set<Decimal> rowString = new Set<Decimal>();
        Set<String> opportunityIdStr = new Set<String>();
        Set<Id> censusId = new Set<Id>();
        List<SGR_Opportunity_Census__c> opptyCensusList = new List<SGR_Opportunity_Census__c>();
        Map<String, SGR_Opportunity_Census__c> spousemap = new Map<String, SGR_Opportunity_Census__c>();
        Map<String, SGR_Opportunity_Census__c> childmap = new Map<String, SGR_Opportunity_Census__c>();
        Map<String, SGR_Opportunity_Census__c> rowCensusMap = new Map<String, SGR_Opportunity_Census__c>();

        for (SGR_Opportunity_Census__c soc : [
                SELECT Id, Subscriber_Number__c, Opportunity__c, Health_Plan_ID__c, Dental_Plan_ID__c,
                        Vision_Plan_ID__c, Relationship__c
                FROM SGR_Opportunity_Census__c
                WHERE Opportunity__c != NULL AND Opportunity__c = :opptyId AND Id != :optyCensusList.Id
                LIMIT 1000]) {
            censusId.add(soc.Opportunity__c);
            if (soc.Relationship__c == 'Child') {
                if (tabName == 'Health') {
                    if (soc.Health_Plan_ID__c != null) {
                        childmap.put(String.valueOf(soc.Subscriber_Number__c) + String.valueOf(soc.Opportunity__c), soc);
                        rowString.add(soc.Subscriber_Number__c);
                        opportunityIdStr.add(soc.Opportunity__c);
                    }
                } else if (tabName == 'Dental') {
                    if (soc.Dental_Plan_ID__c != null) {
                        childmap.put(String.valueOf(soc.Subscriber_Number__c) + String.valueOf(soc.Opportunity__c), soc);
                        rowString.add(soc.Subscriber_Number__c);
                        opportunityIdStr.add(soc.Opportunity__c);
                    }
                } else if (tabName == 'Vision') {
                    if (soc.Vision_Plan_ID__c != null) {
                        childmap.put(String.valueOf(soc.Subscriber_Number__c) + String.valueOf(soc.Opportunity__c), soc);
                        rowString.add(soc.Subscriber_Number__c);
                        opportunityIdStr.add(soc.Opportunity__c);
                    }
                }
            } else if (soc.Relationship__c == 'Spouse' || soc.Relationship__c == 'Domestic Partner') {
                if (tabName == 'Health') {
                    if (soc.Health_Plan_ID__c != null) {
                        spousemap.put(String.valueOf(soc.Subscriber_Number__c) + String.valueOf(soc.Opportunity__c), soc);
                        rowString.add(soc.Subscriber_Number__c);
                        opportunityIdStr.add(soc.Opportunity__c);
                    }
                } else if (tabName == 'Dental') {
                    if (soc.Dental_Plan_ID__c != null) {
                        spousemap.put(String.valueOf(soc.Subscriber_Number__c) + String.valueOf(soc.Opportunity__c), soc);
                        rowString.add(soc.Subscriber_Number__c);
                        opportunityIdStr.add(soc.Opportunity__c);
                    }
                } else if (tabName == 'Vision') {
                    if (soc.Vision_Plan_ID__c != null) {
                        spousemap.put(String.valueOf(soc.Subscriber_Number__c) + String.valueOf(soc.Opportunity__c), soc);
                        rowString.add(soc.Subscriber_Number__c);
                        opportunityIdStr.add(soc.Opportunity__c);
                    }
                }
            }
        }
        if (rowString.size() > 0 && opportunityIdStr.size() > 0) {
            for (SGR_Opportunity_Census__c socRec : [
                    SELECT Id, Health_Tier__c, Dental_Tier__c, Vision_Tier__c, Subscriber_Number__c, Opportunity__c,
                            Health_Plan_ID__c, Dental_Plan_ID__c, Vision_Plan_ID__c
                    FROM SGR_Opportunity_Census__c
                    WHERE Relationship__c = 'Subscriber' AND Subscriber_Number__c IN:rowString AND Opportunity__c IN:opportunityIdStr AND Subscriber_Number__c != NULL
                    LIMIT 1000]) {
                rowCensusMap.put(String.valueOf(socRec.Subscriber_Number__c) + String.valueOf(socRec.Opportunity__c), socRec);
            }
        }
        
        if (rowCensusMap != null && rowCensusMap.size() > 0) {
            for (SGR_Opportunity_Census__c socObj : [
                    SELECT Id, Subscriber_Number__c, Health_Tier__c, Dental_Tier__c, Vision_Tier__c, Opportunity__c,
                            Relationship__c, Health_Plan_ID__c, Dental_Plan_ID__c, Vision_Plan_ID__c
                    FROM SGR_Opportunity_Census__c
                    WHERE Id = :optyCensusList.Id
                    LIMIT 1000]) {
                if (childmap.containsKey(String.valueOf(socObj.Subscriber_Number__c) + String.valueOf(socObj.Opportunity__c)) && childmap.get(String.valueOf(socObj.Subscriber_Number__c) + String.valueOf(socObj.Opportunity__c)) != null &&
                        spousemap.containsKey(String.valueOf(socObj.Subscriber_Number__c) + String.valueOf(socObj.Opportunity__c)) && spousemap.get(String.valueOf(socObj.Subscriber_Number__c) + String.valueOf(socObj.Opportunity__c)) != null &&
                        rowCensusMap.containsKey(String.valueOf(socObj.Subscriber_Number__c) + String.valueOf(socObj.Opportunity__c))) {
                    SGR_Opportunity_Census__c parentSoc = rowCensusMap.get(String.valueOf(socObj.Subscriber_Number__c) + String.valueOf(socObj.Opportunity__c));
                    if (parentSoc != null) {
                        if (tabName == 'Health') {
                            parentSoc.Health_Tier__c = 'EF';
                        } else if (tabName == 'Dental') {
                            parentSoc.Dental_Tier__c = 'EF';
                        } else if (tabName == 'Vision') {
                            parentSoc.Vision_Tier__c = 'EF';
                        }
                        opptyCensusList.add(parentSoc);
                    }
                } else if (childmap.containsKey(String.valueOf(socObj.Subscriber_Number__c) + String.valueOf(socObj.Opportunity__c)) && childmap.get(String.valueOf(socObj.Subscriber_Number__c) + String.valueOf(socObj.Opportunity__c)) != null &&
                        !spousemap.containsKey(String.valueOf(socObj.Subscriber_Number__c) + String.valueOf(socObj.Opportunity__c))) {
                    SGR_Opportunity_Census__c parentSoc = rowCensusMap.get(String.valueOf(socObj.Subscriber_Number__c) + String.valueOf(socObj.Opportunity__c));
                  
                    if (parentSoc != null) {
                        if (tabName == 'Health') {
                            parentSoc.Health_Tier__c = 'EC';
                        } else if (tabName == 'Dental') {
                            parentSoc.Dental_Tier__c = 'EC';
                        } else if (tabName == 'Vision') {
                            parentSoc.Vision_Tier__c = 'EC';
                        }
                        opptyCensusList.add(parentSoc);
                    }
                } else if (spousemap.containsKey(String.valueOf(socObj.Subscriber_Number__c) + String.valueOf(socObj.Opportunity__c)) && spousemap.get(String.valueOf(socObj.Subscriber_Number__c) + String.valueOf(socObj.Opportunity__c)) != null &&
                        !childmap.containsKey(String.valueOf(socObj.Subscriber_Number__c) + String.valueOf(socObj.Opportunity__c))) {
                    SGR_Opportunity_Census__c parentSoc = rowCensusMap.get(String.valueOf(socObj.Subscriber_Number__c) + String.valueOf(socObj.Opportunity__c));
                    if (parentSoc != null) {
                        if (tabName == 'Health') {
                            parentSoc.Health_Tier__c = 'ES';
                        } else if (tabName == 'Dental') {
                            parentSoc.Dental_Tier__c = 'ES';
                        } else if (tabName == 'Vision') {
                            parentSoc.Vision_Tier__c = 'ES';
                        }
                        opptyCensusList.add(parentSoc);
                    }
                }
            }
        }
        return opptyCensusList;
    }

    @AuraEnabled
    public static void saveCensus(SGR_Opportunity_Census__c optyCensusList) {
        update optyCensusList;
    }

    @AuraEnabled
    public static SGR_Opportunity_Census__c saveCensusRecord(SGR_Opportunity_Census__c optyCensus, Id subId, String tabName) {
        SGR_Opportunity_Census__c subscriber = [
                SELECT Id,Health_Tier__c,Dental_Tier__c,Vision_Tier__c,Health_Plan_ID__c,
                        Dental_Plan_ID__c,Vision_Plan_ID__c,Subscriber_Number__c,Backend_Created__c
                FROM SGR_Opportunity_Census__c
                WHERE Id = :subId
                LIMIT 1
        ];

        optyCensus.Backend_Created__c = subscriber.Backend_Created__c;
        if (optyCensus.Id == null) {
            Integer count = CountDependents(optyCensus.Opportunity__c, subscriber.Subscriber_Number__c);
            if (count == 0) {
                count++;
                if (optyCensus.Subscriber_Number__c != null) {
                    optyCensus.Subscriber_Number__c = optyCensus.Subscriber_Number__c;
                    optyCensus.Membership_Number__c = count + 1;
                }
                if (optyCensus.Relationship__c == 'Spouse') {
                    subscriber.Health_Tier__c = optyCensus.Health_Plan_ID__c != null ? 'ES' : subscriber.Health_Tier__c;
                    subscriber.Dental_Tier__c = optyCensus.Dental_Plan_ID__c != null ? 'ES' : subscriber.Dental_Tier__c;
                    subscriber.Vision_Tier__c = optyCensus.Vision_Plan_ID__c != null ? 'ES' : subscriber.Vision_Tier__c;
                } else if (optyCensus.Relationship__c == 'Child') {
                    subscriber.Health_Tier__c = optyCensus.Health_Plan_ID__c != null ? 'EC' : subscriber.Health_Tier__c;
                    subscriber.Dental_Tier__c = optyCensus.Dental_Plan_ID__c != null ? 'EC' : subscriber.Dental_Tier__c;
                    subscriber.Vision_Tier__c = optyCensus.Vision_Plan_ID__c != null ? 'EC' : subscriber.Vision_Tier__c;
                } else if (optyCensus.Relationship__c == 'Domestic Partner') {
                    subscriber.Health_Tier__c = optyCensus.Health_Plan_ID__c != null ? 'ES' : subscriber.Health_Tier__c;
                    subscriber.Dental_Tier__c = optyCensus.Dental_Plan_ID__c != null ? 'ES' : subscriber.Dental_Tier__c;
                    subscriber.Vision_Tier__c = optyCensus.Vision_Plan_ID__c != null ? 'ES' : subscriber.Vision_Tier__c;
                }
            } else {
                count++;
                optyCensus.Subscriber_Number__c = optyCensus.Subscriber_Number__c;
                optyCensus.Membership_Number__c = count + 1;
                subscriber.Health_Tier__c = (optyCensus.Health_Plan_ID__c != null && subscriber.Health_Tier__c == 'EC' && optyCensus.Relationship__c == 'Child') ? 'EC' : (optyCensus.Health_Plan_ID__c != null && subscriber.Health_Tier__c == 'ES' && optyCensus.Relationship__c == 'Spouse') ? 'ES' : (optyCensus.Health_Plan_ID__c != null && subscriber.Health_Tier__c == 'EC' && optyCensus.Relationship__c != 'Child') ? 'EF' : (optyCensus.Health_Plan_ID__c != null && subscriber.Health_Tier__c == 'ES' && optyCensus.Relationship__c != 'Spouse') ? 'EF' : subscriber.Health_Tier__c;
                subscriber.Dental_Tier__c = (optyCensus.Dental_Plan_ID__c != null && subscriber.Dental_Tier__c == 'EC' && optyCensus.Relationship__c == 'Child') ? 'EC' : (optyCensus.Dental_Plan_ID__c != null && subscriber.Dental_Tier__c == 'ES' && optyCensus.Relationship__c == 'Spouse') ? 'ES' : (optyCensus.Dental_Plan_ID__c != null && subscriber.Dental_Tier__c == 'EC' && optyCensus.Relationship__c != 'Child') ? 'EF' : (optyCensus.Dental_Plan_ID__c != null && subscriber.Dental_Tier__c == 'ES' && optyCensus.Relationship__c != 'Spouse') ? 'EF' : subscriber.Dental_Tier__c;
                subscriber.Vision_Tier__c = (optyCensus.Vision_Plan_ID__c != null && subscriber.Vision_Tier__c == 'EC' && optyCensus.Relationship__c == 'Child') ? 'EC' : (optyCensus.Vision_Plan_ID__c != null && subscriber.Vision_Tier__c == 'ES' && optyCensus.Relationship__c == 'Spouse') ? 'ES' : (optyCensus.Vision_Plan_ID__c != null && subscriber.Vision_Tier__c == 'EC' && optyCensus.Relationship__c != 'Child') ? 'EF' : (optyCensus.Vision_Plan_ID__c != null && subscriber.Vision_Tier__c == 'ES' && optyCensus.Relationship__c != 'Spouse') ? 'EF' : subscriber.Vision_Tier__c;

            }
        } else {
            if (updateTier(optyCensus.Opportunity__c, tabName, optyCensus).size() > 0) {
                subscriber = updateTier(optyCensus.Opportunity__c, tabName, optyCensus)[0];
                subscriber.Health_Tier__c = (optyCensus.Health_Plan_ID__c != null && subscriber.Health_Tier__c == 'EC' && optyCensus.Relationship__c == 'Child') ? 'EC' : (optyCensus.Health_Plan_ID__c != null && subscriber.Health_Tier__c == 'ES' && optyCensus.Relationship__c == 'Spouse') ? 'ES' : (optyCensus.Health_Plan_ID__c != null && subscriber.Health_Tier__c == 'EC' && optyCensus.Relationship__c != 'Child') ? 'EF' : (optyCensus.Health_Plan_ID__c != null && subscriber.Health_Tier__c == 'ES' && optyCensus.Relationship__c != 'Spouse') ? 'EF' : subscriber.Health_Tier__c;
                subscriber.Dental_Tier__c = (optyCensus.Dental_Plan_ID__c != null && subscriber.Dental_Tier__c == 'EC' && optyCensus.Relationship__c == 'Child') ? 'EC' : (optyCensus.Dental_Plan_ID__c != null && subscriber.Dental_Tier__c == 'ES' && optyCensus.Relationship__c == 'Spouse') ? 'ES' : (optyCensus.Dental_Plan_ID__c != null && subscriber.Dental_Tier__c == 'EC' && optyCensus.Relationship__c != 'Child') ? 'EF' : (optyCensus.Dental_Plan_ID__c != null && subscriber.Dental_Tier__c == 'ES' && optyCensus.Relationship__c != 'Spouse') ? 'EF' : subscriber.Dental_Tier__c;
                subscriber.Vision_Tier__c = (optyCensus.Vision_Plan_ID__c != null && subscriber.Vision_Tier__c == 'EC' && optyCensus.Relationship__c == 'Child') ? 'EC' : (optyCensus.Vision_Plan_ID__c != null && subscriber.Vision_Tier__c == 'ES' && optyCensus.Relationship__c == 'Spouse') ? 'ES' : (optyCensus.Vision_Plan_ID__c != null && subscriber.Vision_Tier__c == 'EC' && optyCensus.Relationship__c != 'Child') ? 'EF' : (optyCensus.Vision_Plan_ID__c != null && subscriber.Vision_Tier__c == 'ES' && optyCensus.Relationship__c != 'Spouse') ? 'EF' : subscriber.Vision_Tier__c;
            } else {
                subscriber.Health_Tier__c = (optyCensus.Health_Plan_ID__c != null && optyCensus.Relationship__c == 'Child') ? 'EC' : (optyCensus.Health_Plan_ID__c != null && optyCensus.Relationship__c == 'Spouse') ? 'ES' : (optyCensus.Health_Plan_ID__c != null && optyCensus.Relationship__c == 'Domestic Partner') ? 'ES' : subscriber.Health_Tier__c;
                subscriber.Dental_Tier__c = (optyCensus.Dental_Plan_ID__c != null && optyCensus.Relationship__c == 'Child') ? 'EC' : (optyCensus.Dental_Plan_ID__c != null && optyCensus.Relationship__c == 'Spouse') ? 'ES' : (optyCensus.Dental_Plan_ID__c != null && optyCensus.Relationship__c != 'Domestic Partner') ? 'ES' : subscriber.Dental_Tier__c;
                subscriber.Vision_Tier__c = (optyCensus.Vision_Plan_ID__c != null && optyCensus.Relationship__c == 'Child') ? 'EC' : (optyCensus.Vision_Plan_ID__c != null && optyCensus.Relationship__c == 'Spouse') ? 'ES' : (optyCensus.Vision_Plan_ID__c != null && optyCensus.Relationship__c != 'Domestic Partner') ? 'ES' : subscriber.Vision_Tier__c;
            }
        }

        if (!Test.isRunningTest()) {
            upsert optyCensus;
        }
        update subscriber;
        if (optyCensus.Relationship__c != 'Subscriber') {
            Opportunity opty = [
                    SELECT Id, Rating_Status__c
                    FROM Opportunity
                    WHERE Id = :optyCensus.Opportunity__c
                    LIMIT 1
            ];
            opty.Rating_Status__c = 'Pended';
            update opty;
        }
        return optyCensus;
    }
    @AuraEnabled
    public static Integer CountDependents(Id optyId, Decimal subNumber) {
        return [
                SELECT COUNT()
                FROM SGR_Opportunity_Census__c
                WHERE Opportunity__c = :optyId AND Relationship__c != 'Subscriber' AND Subscriber_Number__c = :subNumber
        ];
    }

    @AuraEnabled
    public static Boolean CountSpouseOrDpExists(Id optyId, Decimal subNumber, String relationship) {
        Boolean countVar = false;
        Integer countsp = [
                SELECT COUNT() FROM SGR_Opportunity_Census__c
                WHERE Opportunity__c = :optyId AND Subscriber_Number__c = :subNumber AND (Relationship__c = 'Spouse' OR Relationship__c = 'Domestic Partner')
        ];
        if (countsp > 0) {
            countVar = true;
        } else {
            countVar = false;
        }
        return countVar;
    }

    @AuraEnabled
    public static List<SGR_Opportunity_Census__c> showSubscribersAndDependents(Id oppId, String Tier) {
        if (cleanData(oppId)) {
            List < SGR_Opportunity_Census__c > returnList = new List < SGR_Opportunity_Census__c > ();
            List<SGR_Opportunity_Census__c > lstOfOppCensus = [
                    SELECT Id, SGR_DentalIsChecked__c, SGR_HealthIsChecked__c, SGR_VisionIsChecked__c, CensusId__c, Name,
                            Date_of_Birth__c, Gender__c, Age__c, Age_New__c, Retiree__c, Opportunity__r.Rating_Status__c,
                            CreatedDate, CreatedBy.Name, LastModifiedDate, LastModifiedBy.Name, COBRA__c,
                            State_Continuation__c, LastViewedDate, LastReferencedDate, Opportunity__c,
                            Subscriber_Number__c, Opportunity_Group_Section__r.Opportunity_Group_Section_Number__c,
                            Membership_Number__c, Last_Name__c, First_Name__c, Member_Effective_Date__c,
                            Backend_Created__c, Member_Cancel_Date__c, Relationship__c, Zip_Code__c, Medicare_Primary__c,
                            Tobacco_Use__c, Plan_Name__c,Group_Number__c, Member_Benefit_Effective_Date__c,
                            Member_Benefit_Cancel_Date__c, Subscriber_number1__c, Total_Number_of_Health_Subscribers__c,
                            Row__c, Health_Plan_ID__c, Dental_Tier__c, Dental_Plan_ID__c, Vision_Comp__c,Dental_comp__c,
                            Health_Comp__c, Relationship_Code__c, Member_Characteristic_Type__c,
                            Acc_Census_External_Id__c, State__c, Health_Tier__c, Vision_Tier__c, Vision_Plan_ID__c,
                            Employee_Status_Code__c, Account__c, Group_Section_Number__c, Health_Coverage__c,
                            Dental_Coverage__c, Vision_Coverage__c, Group_Section_Number__r.Name, Member_Rates__c,
                            Composite_Rates__c, Tobacco_Y_N__c, Opportunity__r.Renewal_Date__c,
                            Opportunity__r.Account.Domestic_Partner__c, Health_Group_Number__c, Dental_Group_Number__c,
                            Vision_Group_Number__c, Health_Group_Section__c, Dental_Group_Section__c,
                            Vision_Group_Section__c, Opportunity__r.HCSC_Division__c
                    FROM SGR_Opportunity_Census__c
                    WHERE Opportunity__c = :oppId ORDER BY Subscriber_Number__c, Membership_Number__c
                    LIMIT 100
            ]; 

            for (SGR_Opportunity_Census__c oppcen : lstOfOppCensus) {
                if (Tier == 'Health') {
                    if (oppcen.Health_Plan_ID__c != null) {
                        returnList.add(oppcen);
                    }
                } else if (Tier == 'Dental') {
                    if (oppcen.Dental_Plan_ID__c != null) {
                        returnList.add(oppcen);
                    }
                } else if (Tier == 'Vision') {
                    if (oppcen.Vision_Plan_ID__c != null) {
                        returnList.add(oppcen);
                    }
                }
            }
            return returnList;
        }
        return null;
    }
    @AuraEnabled
    public static Boolean getOpportunityData(Id oppId, String tabName) {
        Opportunity opp = [
                SELECT Id, Rating_Status__c, HCSC_Division__c
                FROM Opportunity
                WHERE Id = :oppId
                LIMIT 1
        ];
        User currentUser = SGR_TriggerRenewal.getloggedinuserinfo();
        if (currentUser.Profile.Name == 'System Administrator' || currentUser.Profile.Name == 'SGR Actuary User' ||
                currentUser.Profile.Name == 'SGR UW User') {
            if (opp.Rating_Status__c == 'Sold' || opp.Rating_Status__c == 'Underwriting-Released' ||
                    opp.Rating_Status__c == 'Marketing Release' || opp.Rating_Status__c == 'Finalized' ||
                    opp.Rating_Status__c == 'Closed') {
                return true;
            } else {
                if (tabName != 'Vision') {
                    return false;
                } else {
                    return true;
                }
            }
        } else {
            return true;
        }
    }

    @AuraEnabled
    public static String CensuValidation(Id oppId) {
        Opportunity opp = [
                SELECT Id, Rating_Status__c, HCSC_Division__c
                FROM Opportunity
                WHERE Id = :oppId
                LIMIT 1
        ];
        User currentUser = SGR_TriggerRenewal.getloggedinuserinfo();
        if (currentUser.Profile.Name == 'System Administrator' || currentUser.Profile.Name == 'SGR Actuary User' ||
                currentUser.Profile.Name == 'SGR UW User') {
            if (opp.Rating_Status__c != 'Sold') {
                if (opp.Rating_Status__c != 'Underwriting-Released') {
                    if (opp.Rating_Status__c != 'Marketing Release') {
                        if (opp.Rating_Status__c != 'Finalized') {
                            if (opp.Rating_Status__c != 'Closed') {
                                return opp.HCSC_Division__c;
                            }
                        }
                    }
                }
            }
        }
        return null;
    }


    @AuraEnabled
    public static List<String> getRelationShip(Id oppId, String currentPlanId) {
        List<String> relationList = new List<String>();
        Opportunity opp = [
                SELECT Id, Account.Domestic_Partner__c
                FROM Opportunity
                WHERE Id = :oppId
                LIMIT 1
        ];
        if (currentPlanId != 'Subscriber') {
            if (currentPlanId == 'Spouse') {
                if (opp.Account.Domestic_Partner__c == 'Y') {
                    relationList.add('Domestic Partner');
                }
                relationList.add('Child');
            } else if (currentPlanId == 'Child') {
                if (opp.Account.Domestic_Partner__c == 'Y') {
                    relationList.add('Domestic Partner');
                } else {
                    relationList.add('Spouse');
                }
            } else {
                relationList.add('Child');
                if (opp.Account.Domestic_Partner__c == 'N') {
                    relationList.add('Spouse');
                }
            }

        }
        return relationList;
    }

    @AuraEnabled
    public static Boolean isDeleteEnabled(Id oppId) {

        Opportunity opty = [
                SELECT Id, Rating_Status__c
                FROM Opportunity
                WHERE Id = :oppId
                LIMIT 1
        ];
        String sRatingStatus = opty.Rating_Status__c;
        User currentUser = SGR_TriggerRenewal.getloggedinuserinfo();
        if (currentUser.Profile.Name == 'System Administrator' || currentUser.Profile.Name == 'SGR Actuary User' ||
                currentUser.Profile.Name == 'SGR UW User') {
            if (sRatingStatus == 'Sold' || sRatingStatus == 'Underwriting-Released' ||
                    sRatingStatus == 'Marketing Release' || sRatingStatus == 'Finalized' || sRatingStatus == 'Closed') {
                return true;
            }
        } else{
            return true;
        }
        return false;
    }
    @AuraEnabled
    public static Map<String, String> deleteOptyCensus(List<Id> optyCensusIds, String planType) {
        Map<String, String> value = new Map<String, String>();
        try {
            List<SGR_Opportunity_Census__c> delCensus = new List<SGR_Opportunity_Census__c>();
            List<SGR_Opportunity_Census__c> updCensus = new List<SGR_Opportunity_Census__c>();
            List<SGR_Opportunity_Census__c> subscriberCensus = new List<SGR_Opportunity_Census__c>();
            Set<String> subscriberNums = new Set<String>();
            Set<String> subscriberOnly = new Set<String>();
            String optyId;
            Boolean deleteFlag = true;
            value.put('Warning', System.Label.Sgr_Select_Dependent);
            List<SGR_Opportunity_Census__c> lstOptyCensus = [
                    SELECT Id, Name, Relationship__c,Subscriber_number1__c, Opportunity__r.Id, Health_Plan_ID__c,
                            Vision_Plan_ID__c, Dental_Plan_ID__c
                    FROM SGR_Opportunity_Census__c
                    WHERE Id IN :optyCensusIds
                    LIMIT 1000
            ];
            if (lstOptyCensus.size() > 0) {
                optyId = lstOptyCensus[0].Opportunity__r.Id;
                for (SGR_Opportunity_Census__c optyCen : lstOptyCensus) {
                    if (optyCen.Relationship__c != 'Subscriber') {
                        subscriberNums.add(optyCen.Subscriber_number1__c);
                        deleteFlag = true;
                        if (subscriberNums.size() > 1) {
                            value = new Map<String, String>();
                            value.put('Error', System.Label.Sgr_Dependents_belonging_to_same_subscriber);
                            deleteFlag = false;
                            break;
                        }
                    } else {
                        subscriberOnly.add(optyCen.Subscriber_number1__c);
                        deleteFlag = true;
                    }
                }
                if (deleteFlag) {
                    if (subscriberOnly.size() == 0) {
                        for (SGR_Opportunity_Census__c census : lstOptyCensus) {
                            if (planType == 'Health' && (census.Dental_Plan_ID__c == null ||
                                    census.Dental_Plan_ID__c == '')) {
                                delCensus.add(census);
                            } else if (planType == 'Health' && (census.Dental_Plan_ID__c != null &&
                                    census.Dental_Plan_ID__c != '')) {
                                census.Health_Plan_ID__c = '';
                                census.Vision_Plan_ID__c = '';
                                updCensus.add(census);
                            } else if (planType == 'Dental' &&
                                    (census.Health_Plan_ID__c == null || census.Health_Plan_ID__c == '') &&
                                    (census.Vision_Plan_ID__c == null || census.Vision_Plan_ID__c == '')){
                                delCensus.add(census);
                            } else {
                                census.Dental_Plan_ID__c = '';
                                updCensus.add(census);
                            }
                        }
                    } else {
                        subscriberCensus = [
                                SELECT Id, Name, Relationship__c,Subscriber_number1__c, Opportunity__r.Id,
                                        Health_Plan_ID__c, Vision_Plan_ID__c, Dental_Plan_ID__c
                                FROM SGR_Opportunity_Census__c
                                WHERE Subscriber_number1__c IN :subscriberOnly
                                LIMIT 1000
                        ];
                        subscriberNums.clear();
                        for (SGR_Opportunity_Census__c census : subscriberCensus) {
                            if (planType == 'Health' && (census.Dental_Plan_ID__c == '' ||
                                    census.Dental_Plan_ID__c == null)) {
                                delCensus.add(census);
                            } else if (planType == 'Health' && (census.Dental_Plan_ID__c != '' &&
                                    census.Dental_Plan_ID__c != null)) {
                                census.Health_Plan_ID__c = '';
                                census.Vision_Plan_ID__c = '';
                                updCensus.add(census);
                                subscriberNums.add(census.Subscriber_number1__c);
                            } else if (planType == 'Dental' &&
                                    (census.Health_Plan_ID__c == '' || census.Health_Plan_ID__c == null) &&
                                    (census.Vision_Plan_ID__c == '' || census.Vision_Plan_ID__c == null)) {
                                delCensus.add(census);
                            } else {
                                census.Dental_Plan_ID__c = '';
                                updCensus.add(census);
                                subscriberNums.add(census.Subscriber_number1__c);
                            }
                        }
                    }
                    if (delCensus.size() > 0) {
                        delete delCensus;
                    }
                    if (updCensus.size() > 0) {
                        update updCensus;

                    }
                    if (planType == 'Health') {
                        updateSubscriberTier(subscriberNums, 'H', optyId);
                    } else {
                        updateSubscriberTier(subscriberNums, 'D', optyId);
                    }

                    value = new Map<String, String>();
                    value.put('Success', System.Label.Sgr_deleted_successful);
                    Opportunity opty = [
                            SELECT Id, Rating_Status__c
                            FROM Opportunity
                            WHERE Id = :optyId
                            LIMIT 1
                    ];
                    if (opty.Rating_Status__c != 'Pended') {
                        opty.Rating_Status__c = 'Pended';
                        update opty;
                    }
                }
            }
        } catch (Exception e) {
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'SGR_Opportunity_Census__c', null,
                    'Sgr_displayCensus.deleteHealthDependents', 'High');
        }
        return value;
    }
    public static void updateSubscriberTier(Set<String> subscriberNums, String coverageType, Id optyId) {
        List<SGR_Opportunity_Census__c> optySubCensus = [
                SELECT Relationship__c, Health_Tier__c, Vision_Tier__c, Dental_Tier__c, Health_Plan_ID__c,
                        Vision_Plan_ID__c, Dental_Plan_ID__c
                FROM SGR_Opportunity_Census__c
                WHERE Subscriber_number1__c IN :subscriberNums AND Relationship__c = 'Subscriber' AND Opportunity__c = :optyId
                LIMIT 1000
        ];

        Integer cCount = 0, sCount = 0, dpCount = 0;
        String coverageTier = '';
        AggregateResult[] groupedResults;
        if (coverageType == 'H') {
            groupedResults = [
                    SELECT Relationship__c, COUNT(Id)
                    FROM SGR_Opportunity_Census__c
                    WHERE Subscriber_number1__c IN :subscriberNums AND Health_Plan_ID__c != NULL AND Opportunity__c = :optyId GROUP BY Relationship__c
            ];
        }
        if (coverageType == 'D') {
            groupedResults = [
                    SELECT Relationship__c, COUNT(Id)
                    FROM SGR_Opportunity_Census__c
                    WHERE Subscriber_number1__c IN :subscriberNums AND Dental_Plan_ID__c != NULL AND Opportunity__c = :optyId GROUP BY Relationship__c
            ];
        }
        for (AggregateResult ar : groupedResults) {
            if (ar.get('Relationship__c') == 'Child') {
                cCount = Integer.valueOf(ar.get('expr0'));
            } else if (ar.get('Relationship__c') == 'Spouse') {
                sCount = Integer.valueOf(ar.get('expr0'));
            } else if (ar.get('Relationship__c') == 'Domestic Partner') {
                dpCount = Integer.valueOf(ar.get('expr0'));
            }
        }

        if ((cCount == 0 || cCount == null) && (sCount == 0 || sCount == null) && (dpCount == 0 || dpCount == null)) {
            coverageTier = 'EO';
        } else if (cCount > 0 && (sCount > 0 || dpCount > 0)) {
            coverageTier = 'EF';
        } else if ((cCount == 0 || cCount == null) && (sCount > 0 || dpCount > 0)) {
            coverageTier = 'ES';
        } else if (cCount > 0 && ((sCount == 0 || sCount == null) && (dpCount == 0 || dpCount == null))) {
            coverageTier = 'EC';
        }
        if (optySubCensus.size() > 0) {
            SGR_Opportunity_Census__c optyCensus = optySubCensus[0];
            if (coverageType == 'H') {
                optyCensus.Health_Tier__c = coverageTier;
                if (optyCensus.Vision_Plan_ID__c != null) {
                    optyCensus.Vision_Tier__c = coverageTier;
                    //coverageTier = '';
                }
            }
            if (optyCensus.Dental_Plan_ID__c != null && coverageType == 'D') {
                optyCensus.Dental_Tier__c = coverageTier;
                //coverageTier = '';
            }
            update optyCensus;
        }
    }

    @AuraEnabled
    public static void saveOppCensus(SGR_Opportunity_Census__c oppCensus, String tabName) {
        if (oppCensus != null && oppCensus.Opportunity__c != null) {
            Opportunity opp = [
                    SELECT Id, Rating_Status__c, HCSC_Division__c,
                    (SELECT Id FROM Opportunity_Census__r WHERE Relationship__c = 'Subscriber')
                    FROM Opportunity
                    WHERE Id = :oppCensus.Opportunity__c
                    LIMIT 1
            ];
            opp.Rating_Status__c = 'Pended';
            update opp;
            if (oppCensus != null) {
                if (oppCensus.Id == null) {
                    oppCensus.Name = oppCensus.First_Name__c + '' + oppCensus.Last_Name__c;
                    oppCensus.Relationship__c = 'Subscriber';
                    oppCensus.Membership_Number__c = 1;
                    oppCensus.Subscriber_Number__c = Datetime.now().getTime();
                    if (tabName == 'Health') {
                        oppCensus.Health_Tier__c = 'EO';
                        oppCensus.Vision_Tier__c = 'EO';
                    }
                    if (tabName == 'Dental') {
                        oppCensus.Dental_Tier__c = 'EO';
                    }
                    if (((oppCensus.Age_New__c >= 19 && opp.HCSC_Division__c == 'MT') || opp.HCSC_Division__c == 'NM') && tabName == 'Health') {
                        if (oppCensus.Health_Group_Number__c != null && oppCensus.Health_Group_Section__c != null && oppCensus.Health_Plan_ID__c != null) {
                            oppCensus.Vision_Group_Section__c = oppCensus.Health_Group_Section__c;
                            oppCensus.Vision_Plan_ID__c = oppCensus.Health_Plan_ID__c;
                            oppCensus.Vision_Group_Number__c = oppCensus.Health_Group_Number__c;
                        }
                    }
                }
                upsert oppCensus;
            }
        }
    }

    @AuraEnabled
    public static Map<String, List<String>> getPlanIds(Id oppId) {
        Map<String, List<String>> planMap = new Map<String, List<String>>();
        for (SGR_Opportunity_Benefit_Agreement__c benAgreement : [
                SELECT Id, Marketing_Plan_ID_13__c, Line_of_Business__c
                FROM SGR_Opportunity_Benefit_Agreement__c
                WHERE Opportunity__c = :oppId
                LIMIT 1000]) {
            if (benAgreement != null) {
                if (benAgreement.Line_of_Business__c == 'H') {
                    if (planMap.containsKey('H')) {
                        planMap.get('H').add(benAgreement.Marketing_Plan_ID_13__c);
                    } else {
                        planMap.put('H', new List<String>{
                                benAgreement.Marketing_Plan_ID_13__c
                        });
                    }
                }
                if (benAgreement.Line_of_Business__c == 'D') {
                    if (planMap.containsKey('D')) {
                        planMap.get('D').add(benAgreement.Marketing_Plan_ID_13__c);
                    } else {
                        planMap.put('D', new List<String>{
                                benAgreement.Marketing_Plan_ID_13__c
                        });
                    }
                }
                if (benAgreement.Line_of_Business__c == 'V') {
                    if (planMap.containsKey('V')) {
                        planMap.get('V').add(benAgreement.Marketing_Plan_ID_13__c);
                    } else {
                        planMap.put('V', new List<String>{
                                benAgreement.Marketing_Plan_ID_13__c
                        });
                    }
                }
            }
        }
        return planMap;
    }
    @AuraEnabled
    public static List<SGR_Opportunity_Group_Section__c> getgroupSection(Id oppId, String planId) {
        List<SGR_Opportunity_Group_Section__c> groupSection = new List<SGR_Opportunity_Group_Section__c>();
        Set<Opportunity_BA_GS_Assignment__c> groupSectionAssignment = new Set<Opportunity_BA_GS_Assignment__c>();
        Set<Id> gSIds = new Set<Id>();
        for (SGR_Opportunity_Benefit_Agreement__c plan : [
                SELECT Id,
                (SELECT Id, Opportunity_Group_Section__c FROM Opportunity_BA_GS_Assignments__r)
                FROM SGR_Opportunity_Benefit_Agreement__c
                WHERE Marketing_Plan_ID_13__c = :planId AND Opportunity__c = :oppId
                LIMIT 1000]) {
            groupSectionAssignment.addAll(plan.Opportunity_BA_GS_Assignments__r);
        }
        for (Opportunity_BA_GS_Assignment__c bAssign : [
                SELECT Id, Opportunity_Group_Section__c
                FROM Opportunity_BA_GS_Assignment__c
                WHERE Id IN:groupSectionAssignment
                LIMIT 1000]) {
            gSIds.add(bAssign.Opportunity_Group_Section__c);
        }
        if (gSIds.size() > 0) {
            groupSection = [
                    SELECT Id, Opportunity_Group_Section_Number__c, Name, Opportunity_Group_Number__c
                    FROM SGR_Opportunity_Group_Section__c
                    WHERE Id IN:gSIds
                    LIMIT 1000
            ];
        }
        return groupSection;
    }

    @AuraEnabled
    public static List<String> getActiveOppBA(Id oppId) {
        Set<String> coverageTypeSet = new Set<String>();
        for (SGR_Opportunity_Benefit_Agreement__c oprBA : [
                SELECT Id, Status__c, Line_of_Business__c, Opportunity__r.HCSC_Division__c
                FROM SGR_Opportunity_Benefit_Agreement__c
                WHERE Status__c = 'Active' AND Opportunity__c = :oppId
                LIMIT 1000
        ]) {
            if (oprBA.Line_of_Business__c != null && oprBA.Line_of_Business__c != 'V') {
                coverageTypeSet.add(oprBA.Line_of_Business__c);
            } else {
                if (oprBA.Line_of_Business__c != null && (oprBA.Opportunity__r.HCSC_Division__c == 'MT' || oprBA.Opportunity__r.HCSC_Division__c == 'NM')) {
                    coverageTypeSet.add(oprBA.Line_of_Business__c);
                }
            }
        }
        List<String> coverageTypelist = new List<String>();
        coverageTypelist.addAll(coverageTypeSet);
        return coverageTypelist;
    }


    @AuraEnabled
    public static void refreshCensusData(Id oppId) {
        Opportunity opp = [
                SELECT Id, Renewal_Date__c, AccountId, Rating_Status__c,
                (SELECT Id FROM Opportunity_Census__r)
                FROM Opportunity
                WHERE Id = :oppId
                LIMIT 1
        ];
        if (opp.Opportunity_Census__r.size() > 0) {
            delete opp.Opportunity_Census__r;
        }
        Set<Id> accIdSet = new Set<Id>();
        accIdSet.add(opp.AccountId);
        List<Opportunity> oppList = new List<Opportunity>();oppList.add(opp);
        SGR_AccountRenewalsHelper.insertOpportunitiesCencus(accIdSet, oppList, 'Refresh');
        SGR_AccountRenewalsHelper.createEventAuditLog(oppList, 'Internal Workflow', 'Refresh Census  event is fired by the user ');
        opp.Rating_Status__c = 'Pended';
        update opp;

    }
    @AuraEnabled
    public static SGR_Opportunity_Census__c getCensusFields(Id oppId, String subIdNumber) {
        return [
                SELECT Id, First_Name__c, Last_Name__c, Health_Plan_ID__c, Backend_Created__c, Vision_Plan_ID__c,
                        Health_Coverage__c, Dental_Coverage__c, Vision_Coverage__c, Dental_Plan_ID__c, Vision_Comp__c,
                        Dental_comp__c, Health_Comp__c, Health_Group_Number__c, Dental_Group_Number__c,
                        Vision_Group_Number__c, Health_Group_Section__c, Dental_Group_Section__c,
                        Vision_Group_Section__c, Opportunity__r.HCSC_Division__c
                FROM SGR_Opportunity_Census__c
                WHERE Subscriber_number1__c = :subIdNumber AND Relationship__c = 'Subscriber' AND Opportunity__c != NULL AND Opportunity__c = :oppId
                LIMIT 1
        ];

    }
    @AuraEnabled
    public static List<SGR_Country_State_Mapping__c> getStates(Id oppCensusId) {
        return [
                SELECT Id, State_Code__c
                FROM SGR_Country_State_Mapping__c
                ORDER BY State_Code__c
                LIMIT 1000
        ];
    }

    @AuraEnabled
    public static Opportunity OppHeader(String oppId) {
        List<Opportunity> lstopp = [
                SELECT Id, AccountId, Name, Rating_Status__c, sgrAccountHoldReason__c, SGR_Workflow_Activity__c,
                        Current_Tier_Billing__c, Has_Notes__c, RecordType.Name, HCSC_Division__c,
                        Account_Market_Segment__c, External_ID__c, SGR_Opportunity_Auto_Number__c, Renewal_Date__c,
                        Batch_Id__c, Funding_Type__c
                FROM Opportunity
                WHERE Id = :oppId
                LIMIT 1
        ];
        return lstopp[0];
    }

    @AuraEnabled
    public static SGR_Opportunity_Census__c getDependentData(Id oppCensusId) {
        return [
                SELECT Id, Health_Plan_ID__c, Dental_Plan_ID__c, Vision_Plan_ID__c
                FROM SGR_Opportunity_Census__c
                WHERE Id = :oppCensusId
                LIMIT 1
        ];
    }

    @AuraEnabled
    public static Opportunity getOppData(Id oppId) {
        return [
                SELECT Id, Rating_Status__c, CurrentUserProfileName__c, Renewal_Date__c, HCSC_Division__c
                FROM Opportunity
                WHERE Id = :oppId
                LIMIT 1
        ];
    }

    @AuraEnabled
    public static Boolean updateCensusRows(List<SGR_Opportunity_Census__c> updateObjects) {
        try{
            update updateObjects;
            return true;
        }catch (DmlException e){
            return false;
        }
    }

    public static Boolean cleanData(Id oppId) {
        List<SGR_Opportunity_Census__c> fullOrderedList = getCensusListForOpportunity(oppId);
        if (fullOrderedList != null && !fullOrderedList.isEmpty()) {
            Date renewalDate = getRenewalEffectiveDate(oppId);
            List<SGR_Opportunity_Census__c> updateList = new List<SGR_Opportunity_Census__c>();
            Integer subRowNum = 0;
            Integer depRowNum = 0;
            for (SGR_Opportunity_Census__c oppCensusRecord : fullOrderedList) {
                Boolean needsUpdate = false;
                if (oppCensusRecord.Relationship__c == 'Subscriber') {
                    subRowNum++;
                    depRowNum = 0;
                    String key = subRowNum + '.0';
                    if (oppCensusRecord.Row__c == null || oppCensusRecord.Row__c != key) {
                        oppCensusRecord.Row__c = key;
                        needsUpdate = true;
                    }
                } else {
                    depRowNum++;
                    String key = subRowNum + '.' + depRowNum;
                    if (oppCensusRecord.Row__c == null || oppCensusRecord.Row__c != key) {
                        oppCensusRecord.Row__c = key;
                        needsUpdate = true;
                    }
                }
                if (renewalDate != null && oppCensusRecord.Date_of_Birth__c != null) {
                    Datetime renewalDatetime = Datetime.newInstanceGmt(renewalDate, Time.newInstance(0, 0, 0, 0));
                    Datetime dobDatetime = Datetime.newInstanceGmt(oppCensusRecord.Date_of_Birth__c, Time.newInstance(0, 0, 0, 0));
                    Integer age = calcAge(renewalDatetime.getTime(), dobDatetime.getTime());
                    if (oppCensusRecord.Age_New__c == null || oppCensusRecord.Age_New__c != age) {
                        oppCensusRecord.Age_New__c = age;
                        needsUpdate = true;
                    }
                }
                if (needsUpdate) {
                    updateList.add(oppCensusRecord);
                }
            }
            if (!updateList.isEmpty()) {
                update updateList;
            }
        }
        return true;
    }

    private static Integer calcAge(Long renewalMillis, Long dobMillies) {
        Long diffMillies = renewalMillis - dobMillies;
        Datetime diffDate = Datetime.newInstance(diffMillies);
        Integer yearVal = diffDate.yearGmt();
        return yearVal - 1970;
    }

    private static Date getRenewalEffectiveDate(Id oppId) {
        Opportunity opp = [
                SELECT Id, Renewal_Date__c
                FROM Opportunity
                WHERE Id = :oppId
                LIMIT 1
        ];
        return (opp != null && opp.Renewal_Date__c != null ? opp.Renewal_Date__c : null);
    }

    private static List<SGR_Opportunity_Census__c> getCensusListForOpportunity(Id oppId) {
        List<SGR_Opportunity_Census__c> returnList = [
                SELECT Id, SGR_DentalIsChecked__c, SGR_HealthIsChecked__c, SGR_VisionIsChecked__c, CensusId__c, Name,
                        Date_of_Birth__c, Gender__c, Retiree__c, State_Continuation__c, CreatedDate,
                        Created_Date_only__c, CreatedBy.Name, LastModifiedDate, Last_Modify_Date_Only__c,
                        LastModifiedBy.Name, LastModifiedById, Age__c, LastViewedDate, LastReferencedDate,
                        Opportunity__c, Subscriber_Number__c, COBRA__c, Membership_Number__c, Age_New__c,Last_Name__c,
                        First_Name__c, Member_Effective_Date__c, Member_Cancel_Date__c, Relationship__c, Zip_Code__c,
                        Medicare_Primary__c, Tobacco_Use__c, Tobacco_Y_N__c, Plan_Name__c, Group_Number__c,
                        Member_Benefit_Effective_Date__c, Member_Benefit_Cancel_Date__c,
                        Total_Number_of_Health_Subscribers__c, Row__c, Health_Plan_ID__c, Dental_Tier__c,
                        Dental_Plan_ID__c, Vision_Comp__c, Dental_comp__c, Health_Comp__c, Relationship_Code__c,
                        Member_Characteristic_Type__c, Acc_Census_External_Id__c, State__c, Health_Tier__c,
                        Vision_Tier__c, Vision_Plan_ID__c, Employee_Status_Code__c, Account__c, Group_Section_Number__c,
                        Dental_Coverage__c, Vision_Coverage__c, Health_Coverage__c, Group_Section_Number__r.Name,
                        Member_Rates__c, Composite_Rates__c, Opportunity__r.Rating_Status__c,
                        Opportunity__r.HCSC_Division__c, Opportunity__r.Account.Domestic_Partner__c,
                        Opportunity__r.Renewal_Date__c, Opportunity_Group_Section__r.Opportunity_Group_Section_Number__c,
                        Health_Group_Number__c, Dental_Group_Number__c, Vision_Group_Number__c,
                        Health_Group_Section__c, Dental_Group_Section__c, Vision_Group_Section__c
                FROM SGR_Opportunity_Census__c
                WHERE Opportunity__c = :oppId AND (Health_Plan_ID__c != NULL OR Dental_Plan_ID__c != NULL OR Vision_Plan_ID__c != NULL)
                ORDER BY Subscriber_Number__c, Membership_Number__c
                LIMIT 1000
        ];
        return (returnList.isEmpty() ? null : returnList);
    }
}