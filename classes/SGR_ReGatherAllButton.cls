public without sharing class SGR_ReGatherAllButton {

    @AuraEnabled
    public static String Regatherall(String oppId) {
        List<Opportunity> lstopp = [
                SELECT Id, AccountId, Name, FIPS_Code__c, HCSC_Division__c, Renewal_Date__c, Rating_Status__c,
                        Batch_Id__c, Funding_Type__c,
                (SELECT Id, Name,Status__c FROM Opportunity_Benefit_Agreements__r),
                (SELECT Id, Name FROM Opportunity_Plan_Rates__r),
                (SELECT Id, Name, Account__c, Opportunity__c, Relationship_Code__c, Member_Cancel_Date__c,
                        Membership_Number__c, Member_Effective_Date__c, Relationship__c, Subscriber_Number__c,
                        Date_of_Birth__c FROM Opportunity_Census__r),
                (SELECT Id, Name, Benefit_Agreement_Cancel_Date__c FROM Opportunity_Group_Section__r)
                FROM Opportunity
                WHERE Id = :oppId
                LIMIT 1000
        ];
        Set<Id> accset = new Set<Id>();
        if (!lstopp.isEmpty()) {
            for (Opportunity accop : lstopp) {
                accset.add(accop.AccountId);
            }
        }
        List<Account> accinfo = new List<Account>([
                SELECT Id, Name, Sic, SicDesc, HCSC_Division__c, Funding_Type__c, Renewal_Date__c, County_Code__c,
                        ShippingPostalCode__c, Market_Segment__c
                FROM Account
                WHERE Id = :lstopp[0].AccountId
                LIMIT 1000]);
        String Message = null;

        List<Opportunity> lstoppinsert = new List<Opportunity>();
        List<SGR_Opportunity_Group_Section__c> oppsgrogs1 = new List<SGR_Opportunity_Group_Section__c>();
        List<SGR_Opportunity_Benefit_Agreement__c> oppsgrobamap = new List<SGR_Opportunity_Benefit_Agreement__c>();
        List<SGR_Opportunity_Census__c> oppsCensus = new List<SGR_Opportunity_Census__c>();
        List<SGR_Opportunity_Plan_Rate__c> Oppplans = new List<SGR_Opportunity_Plan_Rate__c>();
        Map<Id, List<SGR_Opportunity_Benefit_Agreement__c>> op_Ben_Map = new Map<Id, List<SGR_Opportunity_Benefit_Agreement__c>> ();
        if (!lstopp.isEmpty()) {
            for (Opportunity os : lstopp) {
                oppsgrobamap.addAll(os.Opportunity_Benefit_Agreements__r);
                oppsCensus.addAll(os.Opportunity_Census__r);
                oppsgrogs1.addAll(os.Opportunity_Group_Section__r);
                Oppplans.addAll(os.Opportunity_Plan_Rates__r);
            }
        }
        try {
            if (!oppsgrobamap.isEmpty()) {
                delete oppsgrobamap;
            }
            op_Ben_Map = SGR_AccountRenewalsHelper.insertOpportunitiesBenefitAgreement(accset, lstopp, Message);
            if (!Oppplans.isEmpty()) {
                delete Oppplans;
            }
            SGR_AccountRenewalsHelper.insertOpportunitiesPlanRate(accset, lstopp, Message, op_Ben_Map);
            if (!oppsCensus.isEmpty()) {
                delete oppsCensus;
            }
            SGR_AccountRenewalsHelper.insertOpportunitiesCencus(accset, lstopp, Message);
            if (!oppsgrogs1.isEmpty()) {
                delete oppsgrogs1;

            }
            SGR_AccountRenewalsHelper.insertOpportunitiesGroupSection(accset, lstopp, Message);
            SGR_AccountRenewalsHelper.insertOppBAGSAssignment(accset, lstopp, Message);
            SGR_AccountRenewalsHelper.insertOpportunitiesMemberBenefit(accset, lstopp, Message);
            SGR_AccountRenewalsHelper.createEventAuditLog(lstopp, 'Internal Workflow', 'ReGatherAll event is fired by the user ');
            for (Opportunity os : lstopp) {
                os.Rating_Status__c = 'Pended';
                os.SIC_Code__c = accinfo[0].Sic;
                os.SIC_Code_Description__c = accinfo[0].SicDesc;
                os.Account_Market_Segment__c = accinfo[0].Market_Segment__c;
                os.HCSC_Division__c = accinfo[0].HCSC_Division__c;
                os.Funding_Type__c = accinfo[0].Funding_Type__c;
                os.Renewal_Date__c = accinfo[0].Renewal_Date__c;
                os.County_Code__c = accinfo[0].County_Code__c;
                os.Zip_Code__c = accinfo[0].ShippingPostalCode__c;
                os.SGR_Renewal_Account_Name__c = accinfo[0].Name;
                lstoppinsert.add(os);
            }
            update lstoppinsert;

        } catch (Exception E) {

        }
        return 'Success';
    }
}