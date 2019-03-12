/**************************************************************************************
  Apex Class Name     : BenefitAgreementTriggerHandler  
  Version             : 1.0
  Function            : This is a handler class for BenefitAgreementTrigger.
  Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
*   Jermaine Lindsay       03/08/2016                Original Version
*************************************************************************************/

public class BenefitAgreementTriggerHandler{

    /*  updateAccountFundingType
    *   @description:   This method checks if the account record is of record type Producer Account and its type is Sub Producer. It inserts/updates the producer contact record
    *                   This method is used for the after insert scenario.
    *   @parameters     Id <Account> newAccounts : accounts under current context.
    *   @return type    void
    */
    public static void updateAccountFundingType(List<Benefit_Agreement__c> benefitAgreements) {

        Id accountId;
        List<Benefit_Agreement__c> BAList;
        Set<String> setFundingTypes; 
        String stringFundingTypes;
        Set<Id> accountIds = new Set<Id>();
        List<Account> accounts;
        List<Account> targetAccounts = new List<Account>();
        List<Account> updatedTargetAccounts = new List<Account>();
        AccountDAO.IAccountDAO accountDAOInstance = new AccountDAO();
        BenefitAgreementDAO.IBenefitAgreementDAO benefitAgreementDAOInstance = new BenefitAgreementDAO();

        try{
            for( Benefit_Agreement__c ba : benefitAgreements ) {
                    accountIds.add(ba.Group_Account__c);
            }
            accounts = accountDAOInstance.getAccounts( accountIds );

            //Get list of group accounts to update
            for(Account acc : accounts) {
                if( acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get( Label.Group_Account ).getRecordTypeId() ) {
                    targetAccounts.add(acc);
                }
            }

            //Get list of Benefit Agreements for the target accounts
            BAList = benefitAgreementDAOInstance.getGroupAccountBenefitAgreements( targetAccounts );

            //Get Current Funding Type list from Group Account
            for(Account account : targetAccounts){
                setFundingTypes = new Set<String>();
                stringFundingTypes = '';
                for(Benefit_Agreement__c ba : BAList){
                    if(ba.Group_Account__r.id == account.Id && ba.Funding_Type__c != null)
                        setFundingTypes.add(ba.Funding_Type__c);
                }

                for(String ft:setFundingTypes) {
                    stringFundingTypes += (stringFundingTypes==''?'':';')+ft;
                }

                account.Funding_Type__c = stringFundingTypes;
                updatedTargetAccounts.add(account);          
            }
            if ( !updatedTargetAccounts.isEmpty()) {
                accountDAOInstance.updateAccounts( updatedTargetAccounts );
            }
        } catch (Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Benefit Agreement', 'BenefitAgreementTrigger', 'BenefitAgreementTriggerHandler.updateAccountFundingType()', 'High');
        } 
    }

    /*  createProducerContact
    *   @description:   This method checks if the account record is of record type Producer Account and its type is Sub Producer. It inserts/updates the producer contact record
                        This method is used for the after updates scenario.
    *   @parameters     List<Account> newAccounts : new accounts under current context.
    *                   List<Account> oldAccounts : old accounts under current context.
    *   @return type    void
    */
    public static void setBenefitAgreementRecType( List<Benefit_Agreement__c> baList ) {
        try{
            Set<Id> ProdIdSet = new Set<Id>();
            for(Benefit_Agreement__c ba : baList){
                ProdIdSet.add(ba.Product__c);
            }    
            Map<Id,Product2> productMap = new Map<Id,Product2>([SELECT id, RecordType.Name FROM Product2 WHERE Id IN: ProdIdSet]);
            Id BlueStarRecordType = Schema.SObjectType.Benefit_Agreement__c.getRecordTypeInfosByName().get('BlueStar').getRecordTypeId();
            Id NonBluestarRecordType = Schema.SObjectType.Benefit_Agreement__c.getRecordTypeInfosByName().get('Non BlueStar').getRecordTypeId();
            for(Benefit_Agreement__c ba : baList){
                if(productMap.keySet().contains(ba.Product__c)){
                    if(productMap.get(ba.Product__c).RecordType.Name == 'HCSC Non BlueStar Product'){
                        ba.RecordTypeId = NonBluestarRecordType;
                    }else{
                        ba.RecordTypeId = BluestarRecordType;
                    }
                }
            }
        }catch (Exception ex){
            for ( Benefit_Agreement__c ba : baList ) {
                ba.addError( Label.AnErrorHasOcurred + ' : ' + ex.getMessage() );
            }
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Benefit Agreement', 'BenefitAgreementTrigger', 'BenefitAgreementTriggerHandler.updateAccountFundingType()', 'High');
        }
    }

    /**
    * @author       Sana Fatima/Slalom
    * @description  Computes the Account Complexity Score for the Benefit Agreement object
    */
    public static void updateAccountComplexityScoreForBenefitAgreement(List<Benefit_Agreement__c> BAsToUpdate) {
        Id groupAccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get( Label.Group_Account ).getRecordTypeId();
        AccountDAO.IAccountDAO accountDAOInstance = new AccountDAO();

        Set<Id> parentAccountIds = new Set<Id>();
        Map<Id, Account> groupAccounts = new Map<Id, Account>();

        for ( Benefit_Agreement__c currBA : BAsToUpdate ) {
            if( currBA.Group_Account__c != null)
                parentAccountIds.add(currBA.Group_Account__c);
        }
        if( !parentAccountIds.isEmpty() ) {
            groupAccounts = new Map<Id, Account>( accountDAOInstance.getBenefitAgreementComplexityGroupAccounts(parentAccountIds, groupAccountRecordType) );
        }
        if( !groupAccounts.isEmpty() ) {
            calculateBenefitAgreementComplexityScore(groupAccounts);
        }
    }

    /**
    * @author       Sana Fatima/Slalom
    * @description  Computes the Account Complexity Score for the Benefit Agreement object
    */
    public static void calculateBenefitAgreementComplexityScore(Map<Id, Account> groupAccounts) {
        List<Benefit_Agreement__c> childBAs = new List<Benefit_Agreement__c>();
        List<Account> accountsToUpdate = new List<Account>();
        Map<Id, Integer> numBAsByAccIds = new Map<Id, Integer>();
        Map<Id, List<Benefit_Agreement__c>> BAMap = new Map<Id, List<Benefit_Agreement__c>>();
        Decimal oldValue;
        Integer numActiveBAs;
        Decimal stopLossScore;
        Decimal HMOScore;
        Decimal DearbornOrDentalScore;
        Decimal DRUGCoverages;
        Decimal BLUEEDGEPlanScore;
        AccountDAO.IAccountDAO accountDAOInstance = new AccountDAO();
        BenefitAgreementDAO.IBenefitAgreementDAO benefitAgreementDAOInstance = new BenefitAgreementDAO();

        try {
            childBAs = benefitAgreementDAOInstance.getActiveBenefitAgreementsAndCoverages( groupAccounts );
        
            //map active BAs by account id
            for( Benefit_Agreement__c currBA :childBAs ) {
                if ( BAMap.containsKey(currBA.Group_Account__c) ) {
                    BAMap.get(currBA.Group_Account__c).add( currBA );
                } else {
                    BAMap.put( currBA.Group_Account__c, new List<Benefit_Agreement__c>{currBa} );
                }
            }

            for( Account currAccount: groupAccounts.values() ) {
                oldValue = currAccount.ComplexityScoreBenefitAgreement__c;
                stopLossScore = 0;
                HMOScore = 0;
                DearbornOrDentalScore = 0;
                DRUGCoverages = 0;
                BLUEEDGEPlanScore = 0;
                numActiveBAs = 0;
                if ( BAMap.containsKey(currAccount.id) ) {
                    numActiveBAs = BAMap.get( currAccount.Id ).size();
                }
                if (numActiveBAs != null && numActiveBAs >= 1  && numActiveBAs <= 5) {
                    currAccount.ComplexityScoreBenefitAgreement__c = 1; 
                } else if (numActiveBAs != null && numActiveBAs >= 6  && numActiveBAs <= 10) {
                    currAccount.ComplexityScoreBenefitAgreement__c = 3; 
                } else if (numActiveBAs != null && numActiveBAs >= 11  && numActiveBAs <= 20) {
                    currAccount.ComplexityScoreBenefitAgreement__c = 7; 
                } else if (numActiveBAs != null && numActiveBAs >= 21  && numActiveBAs <= 39) {
                    currAccount.ComplexityScoreBenefitAgreement__c = 9; 
                } else if (numActiveBAs != null && numActiveBAs >= 40 ) {
                    currAccount.ComplexityScoreBenefitAgreement__c = 12; 
                } else if ( numActiveBAs != null && numActiveBAs == 0){
                    currAccount.ComplexityScoreBenefitAgreement__c = 0; 
                }
                List<Benefit_Agreement__c> baList = new List<Benefit_Agreement__c>();
                if( BAMap.containsKey(currAccount.id)) {
                    baList = BAMap.get(currAccount.Id);
                }
                for( Benefit_Agreement__c ba: baList) {
                    if( ba.Stop_Loss__c != null && ba.Stop_Loss__c == ConstantsController.stopLossY ) {
                        stopLossScore = 3;
                    } 
                    if ( ba.Product_Category__c != null && ba.Product_Category__c == ConstantsController.productCategoryHMO ) {
                        HMOScore = 1;
                    }
                    if (  ba.Product_Category__c != null && ba.Product_Category__c == ConstantsController.productCategoryDearborn 
                                || ba.Product_Category__c == ConstantsController.productCategoryDental ) {
                        DearbornOrDentalScore = 1;
                    } 
                    if ( ba.Plan__r.Name != null && ba.Plan__r.Name.contains( ConstantsController.BLUEEDGEplan ) ) {
                        BLUEEDGEPlanScore = 1;
                    } 
                    if ( ba.ComplexityScoreCoverage__c != null ) {
                        DRUGCoverages = ba.ComplexityScoreCoverage__c;
                    }
                }
                currAccount.ComplexityScoreBenefitAgreement__c += stopLossScore + HMOScore + DearbornOrDentalScore + DRUGCoverages + BLUEEDGEPlanScore;
                if( currAccount.ComplexityScoreBenefitAgreement__c != oldValue) {
                    accountsToUpdate.add(currAccount);
                } 
            }
            if( !accountsToUpdate.isEmpty() ) {
                accountDAOInstance.updateAccounts( accountsToUpdate );
            }
        } catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'BenefitAgreement', 'BenefitAgreementTrigger', 'BenefitAgreementTriggerHandler.calculateBenefitAgreementComplexityScore', 'High');
        }
    }
}