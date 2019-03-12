/**************************************************************************************
Apex Class Name     : SGR_ViewOppBAController     
Version             : 1.0
Function            : Controller class to get BA details for Opportunity
Modification Log    :
* Developer: Shankar                 Date: 11/10/2018                   Description
* ----------------------------------------------------------------------------               
* Shankar                  11/10/2018                 Initial Version
* Shankar                  22/10/2018                 1.1 Added Last Modified By in query
* Saurav                   11/1/2018                  method Added to get valodation Log List(getOppVLList)
*************************************************************************************/
public without sharing class SGR_ViewOppBAController {

    @AuraEnabled
    public static List<SGR_Opportunity_Benefit_Agreement__c> getOppBAList(Id oppId, String sortField, String sortOrder) {
        List<SGR_Opportunity_Benefit_Agreement__c> baList = new List<SGR_Opportunity_Benefit_Agreement__c>();

        String baListQuery = 'Select Id, Name, Benefit_Agreement_Number__c, Include_BA__c, Renewal_Date__c, Effective_Date__c, Rate_End_Date__c, Rate_Effective_Date__c, Funding_Type__c, LastModifiedDate, LastModifiedBy.Name, Marketing_Plan_Name__c, Marketing_Plan_ID_7__c, Marketing_Plan_ID_13__c,Line_of_Business__c from SGR_Opportunity_Benefit_Agreement__c where Opportunity__c = :oppId ORDER BY ' + sortField + ' ' + sortOrder;

        try {
            baList = (List<SGR_Opportunity_Benefit_Agreement__c>) Database.query(baListQuery);
        } catch (Exception e) {
            throw new AuraHandledException('Error while retreiving BAs. Contact System Administrator');
        }
        return baList;
    }

    @AuraEnabled
    public static Map<Id, List<SGR_Opportunity_Group_Section__c>> getOppGSList(Id oppId, String sortField, String sortOrder) {
        List<SGR_Opportunity_Benefit_Agreement__c> baList = new List<SGR_Opportunity_Benefit_Agreement__c>();
        List<SGR_Opportunity_Group_Section__c> gsAllList = new List<SGR_Opportunity_Group_Section__c>();
        Map<Id, List<SGR_Opportunity_Group_Section__c>> comMAP = new Map<Id, List<SGR_Opportunity_Group_Section__c>>();

        String baListQuery = 'Select Id, Name, Benefit_Agreement_Number__c from SGR_Opportunity_Benefit_Agreement__c where Opportunity__c = :oppId ORDER BY ' + sortField + ' ' + sortOrder;
        String grpSecQuery = 'select id from SGR_Opportunity_Group_Section__c where Opportunity__c = :oppId';
        Set<String> agreeNum = new Set<String>();
        Set<Id> GrpSet = new Set<Id>();
        Set<Id> gsNum = new Set<Id>();
        baList = Database.query(baListQuery);
        gsAllList = Database.query(grpSecQuery);
        try {
            if (baList != null && baList.size() > 0) {
                for (SGR_Opportunity_Benefit_Agreement__c agre : baList) {
                    if (agre.Benefit_Agreement_Number__c != null) {
                        agreeNum.add(agre.Benefit_Agreement_Number__c);
                    }
                }
                if (gsAllList != null && gsAllList.size() > 0) {
                    for (SGR_Opportunity_Group_Section__c agre : gsAllList) {
                        if (agre.Id != null) {
                            GrpSet.add(agre.Id);
                        }
                    }
                }
                List<Opportunity_BA_GS_Assignment__c> bagsid = [
                        SELECT Opportunity_Group_Section__c, Opportunity_Benefit_Agreement__c
                        FROM Opportunity_BA_GS_Assignment__c
                        WHERE Opportunity_Benefit_Agreement__r.Benefit_Agreement_Number__c IN :agreeNum AND Opportunity_Group_Section__c IN :GrpSet
                        LIMIT 1000
                ];
                if (bagsid != null) {
                    for (Opportunity_BA_GS_Assignment__c temp : bagsid) {
                        if (temp.Opportunity_Group_Section__c != null) {
                            gsNum.add(temp.Opportunity_Group_Section__c);
                        }
                    }
                }
                List<SGR_Opportunity_Group_Section__c> nwgslist = [
                        SELECT Group_Name__c, Group_Section_Original_Effective_Date__c, Status__c,
                                Group_Section_Cancel_Date__c, Opportunity_Group_Section_Number__c,
                                Group_Section_Cancel_Code__c
                        FROM SGR_Opportunity_Group_Section__c
                        WHERE Id IN :gsNum
                        LIMIT 1000
                ];

                for (SGR_Opportunity_Benefit_Agreement__c temp : baList) {
                    List<SGR_Opportunity_Group_Section__c> gsmaList = new List<SGR_Opportunity_Group_Section__c>();
                    for (Opportunity_BA_GS_Assignment__c mashup : bagsid) {
                        for (SGR_Opportunity_Group_Section__c agre : nwgslist) {
                            if (temp.Id == mashup.Opportunity_Benefit_Agreement__c && agre.Id == mashup.Opportunity_Group_Section__c) {
                                gsmaList.add(agre);
                            }
                        }
                        comMAP.put(temp.Id, gsmaList);
                    }
                }
            }
        }
        catch (Exception e) {
            throw new AuraHandledException('Error while retreiving BAs. Contact System Administrator');
        }
        return comMAP;
    }


    @AuraEnabled
    public static List<String> initiaterefresh(Id oppId) {
        List<String> successmsg = new List<String>();
        List<Opportunity> opps = new List<Opportunity>();
        Set<Id> ide = new Set<Id>();
        Set<Id> accids = new Set<Id>();
        Set<Id> baID = new Set<Id>();
        List<SGR_Opportunity_Benefit_Agreement__c> OlBA = new List<SGR_Opportunity_Benefit_Agreement__c>();
        List<SGR_Opportunity_Benefit_Agreement__c> obfaList = new List<SGR_Opportunity_Benefit_Agreement__c>();
        obfaList = [
                SELECT Id, Name,Opportunity__c, Benefit_Agreement_Number__c, Include_BA__c, Renewal_Date__c,
                        Effective_Date__c, Rate_End_Date__c, Rate_Effective_Date__c, Funding_Type__c, LastModifiedDate,
                        Marketing_Plan_Name__c, Marketing_Plan_ID_7__c, Marketing_Plan_ID_13__c
                FROM SGR_Opportunity_Benefit_Agreement__c
                WHERE Opportunity__c = :oppId
                LIMIT 1000
        ];
        if (!obfaList.isEmpty()) {
            OlBA = obfaList;
            for (SGR_Opportunity_Benefit_Agreement__c sg : obfaList) {
                ide.add(sg.Opportunity__c);
                baID.add(sg.Id);
            }
        }

        List<Opportunity> sgrList = [
                SELECT AccountId, Account.Name, SGR_Workflow_Status__c
                FROM Opportunity
                WHERE Id IN :ide
                LIMIT 1000
        ];

        if (!sgrList.isEmpty()) {
            for (Opportunity opp : sgrList) {
                accids.add(opp.AccountId);
            }
        }
        List<SGR_Opportunity_Group_Section__c> gaList = [
                SELECT Id, Benefit_Agreement__c
                FROM SGR_Opportunity_Group_Section__c
                WHERE Benefit_Agreement__c IN :baID
                LIMIT 1000
        ];

        try {
            delete OlBA;
            if (!gaList.isEmpty()) {
                delete gaList;
            }
        }

        catch (Exception E) {
            throw new AuraHandledException('Error while erasing Child Records. Contact System Administrator');
        }
        OlBA.clear();
        gaList.clear();

        opps = [
                SELECT Id, Name, AccountId, SGR_Workflow_Status__c, Rating_Status__c
                FROM Opportunity
                WHERE Id = :oppId
                LIMIT 1000
        ];

        if (OlBA.isEmpty() || OlBA.size() == 0 || OlBA == null) {
            SGR_AccountRenewalsHelper.insertOpportunitiesBenefitAgreement(accids, opps, null);
        }

        if (gaList.isEmpty() || gaList.size() == 0 || gaList == null) {
            SGR_AccountRenewalsHelper.insertOpportunitiesGroupSection(accids, opps, null);
        }

        SGR_AccountRenewalsHelper.insertOppBAGSAssignment(accids, opps, null);
        SGR_AccountRenewalsHelper.createEventAuditLog(opps, 'Internal Workflow', 'Refresh BA event is fired by the user ');

        String successmsg1 = 'refresh done successfully.';
        successmsg.add(successmsg1);


        for (Opportunity record : opps) {
            record.Rating_Status__c = 'Pended';
        }
        update opps;

        return successmsg;
    }

    @AuraEnabled
    public static List<SGR_Opportunity_Group_Section__c > getbaGSList(Id BAId) {
        List<SGR_Opportunity_Group_Section__c> gSLIST = new List<SGR_Opportunity_Group_Section__c>();
        String GSLISTQuery = 'Select Group_Name__c, Group_Section_Original_Effective_Date__c, Status__c, Group_Section_Cancel_Date__c, Opportunity_Group_Section_Number__c, Group_Section_Cancel_Code__c from SGR_Opportunity_Group_Section__c where Benefit_Agreement__c=:BAId ORDER BY Group_Name__c ASC';
        try {
            gSLIST = Database.query(GSLISTQuery);
        } catch (Exception e) {
            throw new AuraHandledException('Error while retreiving GAs. Contact System Administrator');
        }
        return gSLIST;
    }

    @AuraEnabled
    public static String getratingStatus(Id oppId) {
        String ratsatus = [
                SELECT Rating_Status__c
                FROM Opportunity
                WHERE Id = :oppId
                LIMIT 1
        ].Rating_Status__c;
        return ratsatus;
    }

    @AuraEnabled
    public static User getloggedinuserinfo() {
        String users = UserInfo.getUserId();
        User us = [
                SELECT Id, Name, ProfileId, Profile.Name, UserRole.Name
                FROM User
                WHERE Id = :users
                LIMIT 1
        ];
        return us;

    }

    @AuraEnabled
    public static void updateBARecord(SGR_Opportunity_Benefit_Agreement__c bARec) {
        try {
            update bARec;
            List<SGR_Opportunity_Census__c> updateCensusList = new List<SGR_Opportunity_Census__c>();
            SGR_Opportunity_Benefit_Agreement__c benAgreement = [
                    SELECT Id, Include_BA__c, Line_of_Business__c, Opportunity__c, Marketing_Plan_ID_13__c
                    FROM SGR_Opportunity_Benefit_Agreement__c
                    WHERE Id = :bARec.Id
                    LIMIT 1
            ];
            List<SGR_Opportunity_Census__c> lstOfOppCensus = [
                    SELECT Id, SGR_DentalIsChecked__c, SGR_HealthIsChecked__c, SGR_VisionIsChecked__c
                    FROM SGR_Opportunity_Census__c
                    WHERE Opportunity__c = :benAgreement.Opportunity__c AND Relationship__c = 'Subscriber' AND
                    (Health_Plan_ID__c = :benAgreement.Marketing_Plan_ID_13__c OR Dental_Plan_ID__c = :benAgreement.Marketing_Plan_ID_13__c OR Vision_Plan_ID__c = :benAgreement.Marketing_Plan_ID_13__c)
                    LIMIT 1000
            ];
            if (!lstOfOppCensus.isEmpty()) {
                for (SGR_Opportunity_Census__c census : lstOfOppCensus) {
                    if (benAgreement.Include_BA__c) {
                        census.SGR_DentalIsChecked__c = true;
                        census.SGR_HealthIsChecked__c = true;
                        census.SGR_VisionIsChecked__c = true;
                    } else {
                        if (benAgreement.Line_of_Business__c == 'H') {
                            census.SGR_DentalIsChecked__c = true;
                            census.SGR_HealthIsChecked__c = false;
                            census.SGR_VisionIsChecked__c = true;
                        } else if (benAgreement.Line_of_Business__c == 'D') {
                            census.SGR_DentalIsChecked__c = false;
                            census.SGR_HealthIsChecked__c = true;
                            census.SGR_VisionIsChecked__c = true;
                        } else if (benAgreement.Line_of_Business__c == 'V') {
                            census.SGR_DentalIsChecked__c = true;
                            census.SGR_HealthIsChecked__c = true;
                            census.SGR_VisionIsChecked__c = false;
                        }
                    }
                    updateCensusList.add(census);
                }
                if (!updateCensusList.isEmpty()) {
                    update updateCensusList;
                }
            }
        } catch (Exception e) {
        }
    }

    @AuraEnabled
    public static Opportunity getOppData(Id oppId) {
        return [
                SELECT Id, Rating_Status__c, CurrentUserProfileName__c
                FROM Opportunity
                WHERE Id = :oppId
                LIMIT 1
        ];
    }
}