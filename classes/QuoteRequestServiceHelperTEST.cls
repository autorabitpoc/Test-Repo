/**
 * This class contains unit tests for validating the behavior of Apex classes
 *  QuoteqRequestWebServiceHelper.cls
 *  DTOHeron*.cls
 *  
 *  Created  by MC
 *  Date: 10/10/2017
 */
@isTest
private class QuoteRequestServiceHelperTEST {

   static void setupTests(){
   	  Id groudActRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
		Account groupAccount = TestClassUtiltity.createAccountWithRecType('Test Account234', groudActRecId);
		groupAccount.Underwriter_Name__c='Smith Testing';
		groupAccount.Account_Executive_2__c='Smith Testing';
		groupAccount.Account_Cluster_Name__c='Smith Testing';
		update groupAccount;
		         
	    List<Opportunity> testOpp = TestClassUtiltity.CreateOpportunities(groupAccount.Id);
		testOpp[0].Requested_Effective_Date__c = System.now().date();//oppName 1
		testOpp[0].RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
		testOpp[1].RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
	    testOpp[2].RecordtypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
		insert testOpp;
		
			
	Profile uw = [SELECT Id FROM Profile WHERE Name = 'Underwriting'];
		User uwUser = new User(Alias = 'standt12', Email = 'smit.testing@testorg24.com',EmailEncodingKey = 'UTF-8', LastName = 'Testing', FirstName = 'Smith', LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US', ProfileId = uw.Id, TimeZoneSidKey = 'America/Los_Angeles',UserName = 'smith.testing@testorg24.com', isActive = TRUE);
		insert uwUser;
		
		
	  Id PriceBook2Id =TestClassUtiltity.getNonStandardPriceBook('Underwriting Price Book');
	  Quote existingQuote=TestClassUtiltity.createQuote(testOpp[0].id);
	  existingQuote.pricebook2Id=priceBook2Id;
	  insert existingQuote;
	  
	  Quote_Request_Summary__c testReq=TestClassUtiltity.createQuoteReq(existingQuote.id, uwUser.id);
	  testReq.Opportunity_Name__c=testOpp[0].name;
      testReq.Opportunity_Id__c=String.valueOf(testOpp[0].id);
      testReq.Request_Description__c='testreq123';
      //testReq.Account_Executive2_Name__c='John Smith';
      //testReq.Account_Executive1_Name__c='Test dummy';
      testReq.HCSC_Division__c='IL';
      testReq.Account_Name_tx__c='Heron test Account';
      testReq.Account_Number__c='0000555';
      testReq.Request_Effective_Date__c=system.today();
      testReq.Sales_Type__c='New Sale';
	    insert testReq;
   	
   }
    static testMethod void testQuoteRequestService() {
           
           setupTests();
        
         List<Username_Password__c> aList = Test.loadData(Username_Password__c.sObjectType,'UserNamePasswordTestData');
      //   List<Heron_OAuth__c> bList=Test.loadData(Heron_OAuth__c.sObjectType,'JwtOauthTestData');// 'HeronOauthTestData');
          List<OAuth_Jwt_Token__c> bList=Test.loadData(OAuth_Jwt_Token__c.sObjectType,'JwtOauthTestData');
           
        list<Quote_Request_Summary__c> quoteReq=[select id, Opportunity_Name__c,Account_Executive2_Name__c,Account_Executive1_Name__c,HCSC_Division__c,Account_Name_tx__c,Account_Number__c,Account_Sales_Executive1__c,Account_Sales_Executive2__c,Request_Description__c,Request_Effective_Date__c,Sales_Type__c, lastModifiedDate from Quote_Request_Summary__c where Account_Number__c='0000555'];


      test.startTest();
      if(quoteReq!=null && !quoteReq.isEmpty()){
          QuoteRequestWebServiceHelper.CreateGetRateWSCallout(quoteReq[0].id);


          ///test the API call

           DTOQuoteRateRequest reqDTO=new DTOQuoteRateRequest();
        
              //  updateReq=quoteReq[0];

          reqDTO.HCSCDivision=quoteReq[0].HCSC_Division__c;
          reqDTO.quoteReqId=quoteReq[0].id;
          reqDTO.opportunityName=quoteReq[0].Opportunity_Name__c;
          reqDTO.accountName=quoteReq[0].Account_Name_tx__c;
                // reqDTO.accountNumber=quoteReq[0].Account_Number__c;
            
          String accountNumber=quoteReq[0].Account_Number__c;
          if(accountNumber!=null && accountNumber.length()>2){
              reqDTO.accountNumber= accountNumber.substring(2);
                  //reqDTO.accountNumber=accountNumber;
                  // system.debug(' account number: '+reqDTO.accountNumber);
          }
          reqDTO.salesRep=quoteReq[0].Account_Executive1_Name__c;//Account_Sales_Executive1__c;
          if(reqDTO.salesRep==null){
               reqDTO.salesRep=quoteReq[0].Account_Executive2_Name__c;//Account_Sales_Executive2__c;
          }
            
           reqDTO.quoteReqDesc=quoteReq[0].Request_Description__c;
           reqDTO.rateEffectiveDate=quoteReq[0].Request_Effective_Date__c;
           reqDTO.lastModifiedDate=quoteReq[0].lastModifiedDate;
           reqDTO.requestType=quoteReq[0].Sales_Type__c;

           
        //  DTOQuoteRateRTResponse status= APIQuoteRateUtility.CreateGetRateCallout (reqDTO);
          
           //test apiQuoteRate Utility
          ///  Heron_OAuth__c heronOauth=customSettingInstance.getHeronOAuthSetting(heronIntId);
           String  accesstoken=blist[0].JWT_Token__c+blist[0].JWT_Token2__c+blist[0].JWT_Token3__c+blist[0].JWT_Token4__c+blist[0].JWT_Token5__c;
           
          // APIQuoteRateUtility.setupHttpRequest(accessToken, reqDTO);

       }
       test.stopTest();
        // TO DO: implement unit test  
    }
    
    
    
     
    static testMethod void testCreateRateService_initial_premium(){


       setupTests();
      
      test.startTest();
      list<DTOHeronRatesByTier> rateTierList=new list<DTOHeronRatesByTier>();
     

      list<DTOHeronPremiumRates> soldPremRates=new list<DTOHeronPremiumRates>();
      DTOHeronPremiumRates premRate=new DTOHeronPremiumRates();
       premRate.contractCount=100;
         premRate.projectedRates=12.09;
         premRate.tier='2 Tier';
         soldPremRates.add(premRate);
        
        list<DTOHeronPremiumRates> initialPremRates=new list<DTOHeronPremiumRates>();
      DTOHeronPremiumRates initialRate=new DTOHeronPremiumRates();
       initialRate.contractCount=100;
         initialRate.projectedRates=12.09;
         initialRate.tier='2 Tier';
         initialPremRates.add(initialRate); 
         
             
        list<DTOHeronPremiumRates> finalPremRates=new list<DTOHeronPremiumRates>();
      DTOHeronPremiumRates finalRate=new DTOHeronPremiumRates();
       finalRate.contractCount=200;
         finalRate.projectedRates=10.00;
         finalRate.tier='4 Tier';
         finalPremRates.add(finalRate);
         
     
      DTOHeronPremiumData premData=new DTOHeronPremiumData();
      premData.soldPremium=19.00;
        premData.initialRequestedPremium=771.00;
        premData.finalRequestedPremium=1.09;
        premData.rateTier='2 Tier';
        premData.heronSoldPremiumRates=soldPremRates;
        premData.initialRequestedPremiumRates=initialPremRates;
        premData.finalRequestedPremiumRates=finalPremRates;


      DTOHeronAssociationData asso=new DTOHeronAssociationData();
       asso.associationName='U65';
      asso.associationProduct='PPO';
      asso.runType='Renewal';
      asso.effectiveDate=system.today();
      asso.endDate=null;
      asso.projectedEnrollment=200;
      asso.projectedEnrollmentSingle=2300;
      asso.projectedEnrollmentFamily=3989;
      asso.accessFeeType='Pct_of_ADP';
      asso.aslFeeType='Monthly';
      asso.HeronPerCapitaData=null;//perCapitaData;
      asso.HeronPremiumData=premData;
      
      list<DTOHeronAssociationData> assoList=new list<DTOHeronAssociationData>();
      assoList.add(asso);
      
      DTOHeronOpportunityData opp=new DTOHeronOpportunityData();
      opp.opportunityId=23434;
      opp.opportunityName='testOpp';
      opp.underwriterId='uwId';
      opp.underwriterName='testUw';
      opp.coverageType='D';
      opp.businessType='standard';
      opp.ratingMethod='Full Service';
      opp.funding='PRO';
      opp.versionStatus='FNL UWTNG REQ';
      opp.singleFamilyInd='false';
      opp.adminFeeType='% of Net Claims';
      opp.HeronAssociationData=assoList;
      
      Quote testquote=new Quote();
        list<Quote_Request_Summary__c> quoteReq=[select id, Opportunity_Name__c,Account_Executive2_Name__c,Account_Executive1_Name__c,HCSC_Division__c,Account_Name_tx__c,Account_Number__c,Account_Sales_Executive1__c,Account_Sales_Executive2__c,Request_Description__c,Request_Effective_Date__c,Sales_Type__c, lastModifiedDate from Quote_Request_Summary__c where Account_Number__c='0000555'];
      
    
      DTOQuoteRateResponse heronData=new DTOQuoteRateResponse();
      heronData.customerName='TestAccount';
        heronData.blueStarAccountNumber='000555';
        heronData.corpEntCd='TX1';
        if(quoteReq!=null && !quoteReq.isEmpty()){
          heronData.salesforceQuoteRequestId=quoteReq[0].id;
        }
        
        
       heronData.heronOpportunityData=opp;
       
      DTOQuoteRateResponseStatus status= QuoteRequestWebServiceHelper.CreateQuoteRateData(heronData);
       
        status= QuoteRequestWebServiceHelper.CreateQuoteRateData(heronData);
       test.stopTest();
    	
    }
    static testMethod void testCreateRateService_final_premium(){

       setupTests();
      
      test.startTest();
      list<DTOHeronRatesByTier> rateTierList=new list<DTOHeronRatesByTier>();
     

      list<DTOHeronPremiumRates> soldPremRates=new list<DTOHeronPremiumRates>();
      DTOHeronPremiumRates premRate=new DTOHeronPremiumRates();
       premRate.contractCount=100;
         premRate.projectedRates=12.09;
         premRate.tier='2 Tier';
         soldPremRates.add(premRate);
        
        list<DTOHeronPremiumRates> initialPremRates=new list<DTOHeronPremiumRates>();
      DTOHeronPremiumRates initialRate=new DTOHeronPremiumRates();
       initialRate.contractCount=100;
         initialRate.projectedRates=12.09;
         initialRate.tier='2 Tier';
         initialPremRates.add(initialRate); 
         
             
        list<DTOHeronPremiumRates> finalPremRates=new list<DTOHeronPremiumRates>();
      DTOHeronPremiumRates finalRate=new DTOHeronPremiumRates();
       finalRate.contractCount=200;
         finalRate.projectedRates=10.00;
         finalRate.tier='4 Tier';
         finalPremRates.add(finalRate);
         
     
      DTOHeronPremiumData premData=new DTOHeronPremiumData();
      premData.soldPremium=19.00;
        premData.initialRequestedPremium=771.00;
        premData.finalRequestedPremium=1.09;
        premData.rateTier='2 Tier';
        premData.heronSoldPremiumRates=soldPremRates;
        premData.initialRequestedPremiumRates=initialPremRates;
        premData.finalRequestedPremiumRates=finalPremRates;


      DTOHeronAssociationData asso=new DTOHeronAssociationData();
       asso.associationName='U65';
      asso.associationProduct='PPO';
      asso.runType='Renewal';
      asso.effectiveDate=system.today();
      asso.endDate=null;
      asso.projectedEnrollment=200;
      asso.projectedEnrollmentSingle=2300;
      asso.projectedEnrollmentFamily=3989;
      asso.accessFeeType='Pct_of_ADP';
      asso.aslFeeType='Monthly';
      asso.HeronPerCapitaData=null;//perCapitaData;
      asso.HeronPremiumData=premData;
      
      list<DTOHeronAssociationData> assoList=new list<DTOHeronAssociationData>();
      assoList.add(asso);
      
      DTOHeronOpportunityData opp=new DTOHeronOpportunityData();
      opp.opportunityId=23434;
      opp.opportunityName='testOpp';
      opp.underwriterId='uwId';
      opp.underwriterName='testUw';
      opp.coverageType='D';
      opp.businessType='standard';
      opp.ratingMethod='Full Service';
      opp.funding='PRO';
      opp.versionStatus='INIT REQ';
      opp.singleFamilyInd='true';
      opp.adminFeeType='% of Net Claims';
      opp.HeronAssociationData=assoList;
      
      Quote testquote=new Quote();
        list<Quote_Request_Summary__c> quoteReq=[select id, Opportunity_Name__c,Account_Executive2_Name__c,Account_Executive1_Name__c,HCSC_Division__c,Account_Name_tx__c,Account_Number__c,Account_Sales_Executive1__c,Account_Sales_Executive2__c,Request_Description__c,Request_Effective_Date__c,Sales_Type__c, lastModifiedDate from Quote_Request_Summary__c where Account_Number__c='0000555'];
      
    
      DTOQuoteRateResponse heronData=new DTOQuoteRateResponse();
      heronData.customerName='TestAccount';
        heronData.blueStarAccountNumber='000555';
        heronData.corpEntCd='TX1';
        if(quoteReq!=null && !quoteReq.isEmpty()){
          heronData.salesforceQuoteRequestId=quoteReq[0].id;
        }
        
        
       heronData.heronOpportunityData=opp;
       
      DTOQuoteRateResponseStatus status= QuoteRequestWebServiceHelper.CreateQuoteRateData(heronData);
       
       test.stopTest();
 }
    	
 
    static testMethod void testCreateRateService_final_family_single(){
    	 setupTests();
      
      test.startTest();
      list<DTOHeronRatesByTier> rateTierList=new list<DTOHeronRatesByTier>();
      
      DTOHeronRatesByTier rateTier1=new DTOHeronRatesByTier();
       rateTier1.administrativeFee=12.0;
       rateTier1.drugAdministrativeFee=23.0;
         rateTier1.drugRebateCredit=209.00;
       rateTier1.islFee=23.00;
       rateTier1.aslFee=10.00;
       rateTier1.nonStdSvcFee=12.09;
       rateTier1.averageClaimValue=13.00;
         rateTier1.runOffClaimLiability=23.00;
         rateTier1.runOffAdministration=23.00;
         rateTier1.tierClass='Comp';
         
         DTOHeronRatesByTier rateTier2=new DTOHeronRatesByTier();
       rateTier2.administrativeFee=12.0;
       rateTier2.drugAdministrativeFee=23.0;
         rateTier2.drugRebateCredit=209.00;
       rateTier2.islFee=23.00;
       rateTier2.aslFee=10.00;
       rateTier2.nonStdSvcFee=12.09;
       rateTier2.averageClaimValue=13.00;
         rateTier2.runOffClaimLiability=23.00;
         rateTier2.runOffAdministration=23.00;
         rateTier2.tierClass='Single';


         DTOHeronRatesByTier rateTier3=new DTOHeronRatesByTier();
       rateTier3.administrativeFee=12.0;
       rateTier3.drugAdministrativeFee=23.0;
         rateTier3.drugRebateCredit=209.00;
       rateTier3.islFee=23.00;
       rateTier3.aslFee=10.00;
       rateTier3.nonStdSvcFee=12.09;
       rateTier3.averageClaimValue=13.00;
         rateTier3.runOffClaimLiability=23.00;
         rateTier3.runOffAdministration=23.00;
         rateTier3.tierClass='Family';

         
         rateTierList.add(rateTier1);
         rateTierList.add(rateTier2);
         rateTierList.add(rateTier3);
    
      DTOHeronRates heronRate=new DTOHeronRates();
       heronRate.ilAccessFee=9.0;
         heronRate.hcscAccessFeesPct=9.0;
         heronRate.nonHcscAccessFeesPct=1.0;
         heronRate.nonStdSvcOneTimeCharge=2.0;
         heronRate.commission=2.9;
         heronRate.allocatedTaxesAndFeePcpm=0.9;
         heronRate.physicianServiceFeeSingle=0.1;
         heronRate.physicianServiceFeeFamily=2.0;
         
         heronRate.hMOManagedCareFee=2.0;
      
        heronRate.aHPFee=1.0;
        heronRate.sharedSavingsPct=2.0;
         heronRate.sharedSavingsPctInNetwork=2.0;
        heronRate.sharedSavingsPctOutNetwork=2.0;
        heronRate.annualAggregateCap=1.0;
        heronRate.claimLevelCap=2.0;
        heronRate.guaranteeDiscountPercent=2.0;
        heronRate.totalFixedCost=1.0;
   
   
    
      DTOHeronPerCapitaData perCapitaData=new DTOHeronPerCapitaData();
      perCapitaData.soldRates=heronRate;
      perCapitaData.soldRatesByTier=rateTierList;
        perCapitaData.finalUnderwritingRequestedRates=heronRate;
        perCapitaData.finalUnderwritingRequestedRatesByTier=rateTierList;//new list<DTOHeronRatesByTier>();
        perCapitaData.initialRequestedRates=heronRate;
        perCapitaData.initialRequestedRatesByTier=rateTierList;//new list<DTOHeronRatesByTier>();
    
      DTOHeronAssociationData asso=new DTOHeronAssociationData();
       asso.associationName='U65';
      asso.associationProduct='PPO';
      asso.runType='Renewal';
      asso.effectiveDate=system.today();
      asso.endDate=null;
      asso.projectedEnrollment=200;
      asso.projectedEnrollmentSingle=2300;
      asso.projectedEnrollmentFamily=3989;
      asso.accessFeeType='Pct_of_ADP';
      asso.aslFeeType='Monthly';
      asso.HeronPerCapitaData=perCapitaData;
      asso.HeronPremiumData=null;//premData;
      
      list<DTOHeronAssociationData> assoList=new list<DTOHeronAssociationData>();
      assoList.add(asso);
      
      DTOHeronOpportunityData opp=new DTOHeronOpportunityData();
      opp.opportunityId=23434;
      opp.opportunityName='testOpp';
      opp.underwriterId='uwId';
      opp.underwriterName='testUw';
      opp.coverageType='M';
      opp.businessType='standard';
      opp.ratingMethod='Full Service';
      opp.funding='COST';
      opp.versionStatus='FNL UWTNG REQ';
      opp.singleFamilyInd='true';
      opp.adminFeeType='% of Net Claims';
      opp.HeronAssociationData=assoList;
      
      Quote testquote=new Quote();
        list<Quote_Request_Summary__c> quoteReq=[select id, Opportunity_Name__c,Account_Executive2_Name__c,Account_Executive1_Name__c,HCSC_Division__c,Account_Name_tx__c,Account_Number__c,Account_Sales_Executive1__c,Account_Sales_Executive2__c,Request_Description__c,Request_Effective_Date__c,Sales_Type__c, lastModifiedDate from Quote_Request_Summary__c where Account_Number__c='0000555'];
      
    
      DTOQuoteRateResponse heronData=new DTOQuoteRateResponse();
      heronData.customerName='TestAccount';
        heronData.blueStarAccountNumber='000555';
        heronData.corpEntCd='TX1';
        if(quoteReq!=null && !quoteReq.isEmpty()){
          heronData.salesforceQuoteRequestId=quoteReq[0].id;
        }
        
        
       heronData.heronOpportunityData=opp;
       
      DTOQuoteRateResponseStatus status= QuoteRequestWebServiceHelper.CreateQuoteRateData(heronData);
       
       test.stopTest();
    }

   
    
    static testMethod void testCreateRateService_initial_family_single(){
      setupTests();
    	
    	test.startTest();
    	list<DTOHeronRatesByTier> rateTierList=new list<DTOHeronRatesByTier>();
    	
    	DTOHeronRatesByTier rateTier1=new DTOHeronRatesByTier();
    	 rateTier1.administrativeFee=12.0;
	     rateTier1.drugAdministrativeFee=23.0;
         rateTier1.drugRebateCredit=209.00;
	     rateTier1.islFee=23.00;
	     rateTier1.aslFee=10.00;
	     rateTier1.nonStdSvcFee=12.09;
	     rateTier1.averageClaimValue=13.00;
         rateTier1.runOffClaimLiability=23.00;
         rateTier1.runOffAdministration=23.00;
         rateTier1.tierClass='Comp';
         
         DTOHeronRatesByTier rateTier2=new DTOHeronRatesByTier();
    	 rateTier2.administrativeFee=12.0;
	     rateTier2.drugAdministrativeFee=23.0;
         rateTier2.drugRebateCredit=209.00;
	     rateTier2.islFee=23.00;
	     rateTier2.aslFee=10.00;
	     rateTier2.nonStdSvcFee=12.09;
	     rateTier2.averageClaimValue=13.00;
         rateTier2.runOffClaimLiability=23.00;
         rateTier2.runOffAdministration=23.00;
         rateTier2.tierClass='Single';


         DTOHeronRatesByTier rateTier3=new DTOHeronRatesByTier();
       rateTier3.administrativeFee=12.0;
       rateTier3.drugAdministrativeFee=23.0;
         rateTier3.drugRebateCredit=209.00;
       rateTier3.islFee=23.00;
       rateTier3.aslFee=10.00;
       rateTier3.nonStdSvcFee=12.09;
       rateTier3.averageClaimValue=13.00;
         rateTier3.runOffClaimLiability=23.00;
         rateTier3.runOffAdministration=23.00;
         rateTier3.tierClass='Family';

         
         rateTierList.add(rateTier1);
         rateTierList.add(rateTier2);
         rateTierList.add(rateTier3);
    
    	DTOHeronRates heronRate=new DTOHeronRates();
    	 heronRate.ilAccessFee=9.0;
         heronRate.hcscAccessFeesPct=9.0;
         heronRate.nonHcscAccessFeesPct=1.0;
         heronRate.nonStdSvcOneTimeCharge=2.0;
         heronRate.commission=2.9;
         heronRate.allocatedTaxesAndFeePcpm=0.9;
         heronRate.physicianServiceFeeSingle=0.1;
         heronRate.physicianServiceFeeFamily=2.0;
         
         heronRate.hMOManagedCareFee=2.0;
      
        heronRate.aHPFee=1.0;
        heronRate.sharedSavingsPct=2.0;
         heronRate.sharedSavingsPctInNetwork=2.0;
        heronRate.sharedSavingsPctOutNetwork=2.0;
        heronRate.annualAggregateCap=1.0;
        heronRate.claimLevelCap=2.0;
        heronRate.guaranteeDiscountPercent=2.0;
        heronRate.totalFixedCost=1.0;
   
    
    	DTOHeronPerCapitaData perCapitaData=new DTOHeronPerCapitaData();
    	perCapitaData.soldRates=heronRate;
    	perCapitaData.soldRatesByTier=rateTierList;
        perCapitaData.finalUnderwritingRequestedRates=heronRate;
        perCapitaData.finalUnderwritingRequestedRatesByTier=rateTierList;//new list<DTOHeronRatesByTier>();
        perCapitaData.initialRequestedRates=heronRate;
        perCapitaData.initialRequestedRatesByTier=rateTierList;//new list<DTOHeronRatesByTier>();
    
    	DTOHeronAssociationData asso=new DTOHeronAssociationData();
    	 asso.associationName='O65';
  		asso.associationProduct='PPO';
  		asso.runType='Renewal';
  		asso.effectiveDate=system.today();
  		asso.endDate=null;
 		  asso.projectedEnrollment=200;
 		  asso.projectedEnrollmentSingle=2300;
 		  asso.projectedEnrollmentFamily=3989;
 		  asso.accessFeeType='Per_Capita';
 		  asso.aslFeeType='Annual';
	 	  asso.HeronPerCapitaData=perCapitaData;
	    asso.HeronPremiumData=null;//premData;

    DTOHeronAssociationData asso1=new DTOHeronAssociationData();
       asso1.associationName='U65';
      asso1.associationProduct='HMO';
      asso1.runType='Renewal';
      asso1.effectiveDate=system.today();
      asso1.endDate=null;
      asso1.projectedEnrollment=200;
      asso1.projectedEnrollmentSingle=2300;
      asso1.projectedEnrollmentFamily=3989;
      asso1.accessFeeType='Built_into_Admin';
      asso1.aslFeeType='Annual';
      asso1.HeronPerCapitaData=perCapitaData;
      asso1.HeronPremiumData=null;//premData;
	    
	    list<DTOHeronAssociationData> assoList=new list<DTOHeronAssociationData>();
	    assoList.add(asso);
      assoList.add(asso1);
	    
    	DTOHeronOpportunityData opp=new DTOHeronOpportunityData();
    	opp.opportunityId=23434;
   		opp.opportunityName='testOpp';
   		opp.underwriterId='uwId';
   		opp.underwriterName='testUw';
   		opp.coverageType='M';
   		opp.businessType='standard';
   		opp.ratingMethod='Full Service';
   		opp.funding='ASO';
   		opp.versionStatus='INIT REQ';
   		opp.singleFamilyInd='false';
   		opp.adminFeeType='Per Capita';
   		opp.HeronAssociationData=assoList;
   		
   		Quote testquote=new Quote();
        list<Quote_Request_Summary__c> quoteReq=[select id, Opportunity_Name__c,Account_Executive2_Name__c,Account_Executive1_Name__c,HCSC_Division__c,Account_Name_tx__c,Account_Number__c,Account_Sales_Executive1__c,Account_Sales_Executive2__c,Request_Description__c,Request_Effective_Date__c,Sales_Type__c, lastModifiedDate from Quote_Request_Summary__c where Account_Number__c='0000555'];
   		
   	
    	DTOQuoteRateResponse heronData=new DTOQuoteRateResponse();
    	heronData.customerName='TestAccount';
        heronData.blueStarAccountNumber='000555';
        heronData.corpEntCd='IL1';
        if(quoteReq!=null && !quoteReq.isEmpty()){
          heronData.salesforceQuoteRequestId=quoteReq[0].id;
        }
        
        
       heronData.heronOpportunityData=opp;
       
      DTOQuoteRateResponseStatus status= QuoteRequestWebServiceHelper.CreateQuoteRateData(heronData);
       
       test.stopTest();
    }
}