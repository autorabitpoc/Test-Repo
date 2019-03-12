@isTest
Public class GEMS_PharmacyScopeCodingHelper_Test{
    
     Private static testmethod void  GEMS_PharmacyScopeHelper(){
     
        Account acc= GEMS_UtilityClassTest.insertionAccount();
        insert acc;
        
     
        Case accSubCaseRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        accSubCaseRec.accountid = acc.id;
        insert accSubCaseRec;
        
        GEMS_PharmacyScopeCodingHelper gemsPhHelper = new GEMS_PharmacyScopeCodingHelper();
        gemsPhHelper.getPharmacyScopeCodingDetails(accSubCaseRec.Id);
        gemsPhHelper.savePharmacyScopeCodingDetails();
     }

}