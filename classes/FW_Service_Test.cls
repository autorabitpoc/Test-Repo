@isTest
public class FW_Service_Test {
    
    public static testMethod void FW_Service_Test1(){
      
        //TestContext.testCase = 'ForTest';
        GEMS_AccountStructureSetupServiceInput inputAccSetup = new GEMS_AccountStructureSetupServiceInput();
        GEMS_AccountStructureSetupServiceInput.AccountDetails inputAccountDetails = new  GEMS_AccountStructureSetupServiceInput.AccountDetails();
        inputAccountDetails.accountName = 'TestAccount';
        inputAccountDetails.accountNumber ='12354';
        inputAccountDetails.effectiveDate ='04/22/2016';
        inputAccountDetails.marketSegment = 'TestSegment';
        inputAccountDetails.accountStructureCaseID = '';
        inputAccountDetails.corpCode = '125';
        inputAccountDetails.cobraAutoCancel = 'Yes';
        inputAccountDetails.cobraCode = '122';
        List<GEMS_AccountStructureSetupServiceInput.Address> listAddress = new List<GEMS_AccountStructureSetupServiceInput.Address>();
        GEMS_AccountStructureSetupServiceInput.Address inputAddress = new  GEMS_AccountStructureSetupServiceInput.Address();
        inputAddress.addressSequence = 1;
        inputAddress.addressName = 'TestName';
        inputAddress.street = 'TestStreet';
        inputAddress.state = 'Test';
        inputAddress.cityName = 'Test';
        inputAddress.zipCode = '789540';
        inputAddress.countyCode = 'CS';
        inputAddress.countryCode = 'CS';
        inputAddress.isPrimaryAddress = 'Yes';
        inputAddress.isMailingAddress = 'Yes';
        inputAddress.isSubsidaryAddress = 'Yes';
        inputAddress.isBillingAddress = 'Yes';
        inputAddress.isInvoiceAddress = 'Yes';
        inputAddress.isBaeAddress = 'Yes';
        inputAddress.isThirdPartyAddress = 'Yes';
        inputAddress.contactName = 'TestName';
        inputAddress.contactPhoneNumber = '236598701';
        inputAddress.contactEmailAddress = '542136487';
        listAddress.add(inputAddress);
        List<GEMS_AccountStructureSetupServiceInput.BenefitAggrement> listBenefitAggrement = new List<GEMS_AccountStructureSetupServiceInput.BenefitAggrement>();
     
        GEMS_AccountStructureSetupServiceInput.BenefitAggrement benefitAgrrem = new  GEMS_AccountStructureSetupServiceInput.BenefitAggrement();
        benefitAgrrem.baNumber = '1254';
        benefitAgrrem.baDescription = 'Desc';
        benefitAgrrem.prodTypeCode = '111';
        benefitAgrrem.corporateProdNumber = '111';
        benefitAgrrem.corporateProdName = 'Name';
        benefitAgrrem.baFundType = 'Test';
        benefitAgrrem.scheduleCode = '122';          
        listBenefitAggrement.add(benefitAgrrem);
        List<GEMS_AccountStructureSetupServiceInput.Category> listCategory = new List<GEMS_AccountStructureSetupServiceInput.Category>();
        GEMS_AccountStructureSetupServiceInput.Category ccategory = new  GEMS_AccountStructureSetupServiceInput.Category();
        ccategory.categoryNumber = '4456';
        ccategory.categoryDescription = 'Desc';
        ccategory.categoryCobraCode = '125';
        ccategory.productIndicator = 'Test';
        ccategory.billingIndicator = 'Test';
        ccategory.reportingIndicator = 'Test';
        ccategory.mailIndicator = 'Test';
        listCategory.add(ccategory);
         List<GEMS_AccountStructureSetupServiceInput.GroupSection> listGroupSection = new List<GEMS_AccountStructureSetupServiceInput.GroupSection>();
        GEMS_AccountStructureSetupServiceInput.GroupSection groupSec = new  GEMS_AccountStructureSetupServiceInput.GroupSection();
        groupSec.groupNumber = '4456';
        groupSec.sectionNumber = '1110';
        List<String> banums = new List<String>();
        banums.add('1254');
        List<String> catNums = new List<String>();
        catNums.add('4456');
        groupSec.sectionDescription = 'SecDesc';
        groupSec.assignedBANumbers = banums;
        groupSec.assignedCategoryNumbers = catNums;
        listGroupSection.add(groupSec);
        inputAccSetup.accountDetails = inputAccountDetails;
        inputAccSetup.addresses = listAddress;
        inputAccSetup.benefitAggrements = listBenefitAggrement;
        inputAccSetup.categories = listCategory;
        inputAccSetup.groupSections = listGroupSection;
        FW_Service fwTest = new FW_Service('GEMS_Account_Structure_Setup');
        Test.setMock(HttpCalloutMock.class, new GEMS_MockHttpResponseGenerator());  
        Object res = fwTest.callout(inputAccSetup); 
       }
}