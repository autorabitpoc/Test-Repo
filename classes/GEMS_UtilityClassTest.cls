/**************************************************************************************
  Apex Class Name     : GEMS_UtilityClassTest
  Version             : 1.0
  Function            : This class serves as Unit Test Class for Generating mockdata for all GEMS related objects.
  Modification Log    :
* Developer           :    Date                   Description
* ----------------------------------------------------------------------------                 
* Siva Thimmannagari     06/29/2016                Original Version
*************************************************************************************/

@isTest
public class GEMS_UtilityClassTest{


  public static User CreateUserRecord(Id ProfileId, String UserNameStr, String LastNameStr, String EmailStr) {
    User newUser = new User(Alias = 'test', Email = EmailStr, EmailEncodingKey = 'UTF-8', LastName = LastNameStr, LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = ProfileId, TimeZoneSidKey = 'America/Los_Angeles', UserName = UserNameStr);
    
    return newUser;
  }
            
    
    public static  product2 insertionProduct(){  
        product2 prod= new product2(); 
        prod.Name='BCS Stop Loss';
        prod.Product_Category__c='EPO';
        prod.Family='Ancillary and other';
        prod.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
        prod.IsActive=true;
        prod.HCSC_State__c='IL';
        prod.External_ID__c='IL-Accident Insurance (EPO)';
        return prod;
    }
    
    
    
    public static Account insertionAccount(){
        Account accRec = new Account();
        accRec.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        accRec.Name = 'BenefitAgreementControllerTest';
        accRec.External_ID__c='1234578';
        accRec.Funding_Type__c='PREM';
        accRec.Renewal_Notification_in_days__c=180;
        accRec.Group_Number__c='9898';
        accRec.Reserved_Group_Number__c='123456';
        accRec.status__c = 'Active';
        accRec.Effective_Date__c = Date.Today().addDays(30);
        return accRec;
    }
    
    public static  Opportunity  insertionOpp(ID accId){      
        ID OppRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.RecordTypeId=OppRecTypeId;
        opp.Name='BenefitAgreementControllerTest';
        opp.AccountId=accId;
        opp.Type='RFI';
        opp.StageName='Expected In';
        opp.Exchange_Offering_Type__c='No Private Exchange';
        opp.CloseDate=Date.Today().addDays(8);
        opp.Due_Date_Notification_in_Days__c=2;
        opp.Expected_RFP_Release_Date__c=Date.Today().addDays(8);
        opp.RFI_RFP_Received_Date__c=Date.Today().addDays(8);
        opp.Requested_Effective_Date__c=Date.Today().addDays(8);
        opp.Expected_Health_Members__c=2;
        opp.HCSC_Division__c='IL';
        opp.Region__c='N/A - IL';
        opp.District__c='290';
        opp.Clusters__c='020';
        opp.Account_Market_Segment__c='LG';
        opp.FSU_Location__c='Chicago';
        return opp;
    }
    
    public static  Opportunity_Product__c  insertionOppProd(ID prodId, ID opptyId){
        Opportunity_Product__c OppProd = New Opportunity_Product__c();       
        OppProd.Product__c =prodId;
        OppProd.Opportunity_Name__c =opptyId;
        OppProd.Funding_Type__c ='ACAP';
        oppProd.Status__c='Won';
        OppProd.Win_Probability__c =100;
        OppProd.Projected_Members__c =2;
        return OppProd;         
    }
    
    public static  Opportunity_Product__c  insertionOppProd8(ID prodId, ID opptyId){
        Opportunity_Product__c OppProd8 = New Opportunity_Product__c();       
        OppProd8.Product__c =prodId;
        OppProd8.Opportunity_Name__c =opptyId;
        OppProd8.Funding_Type__c ='ACAP';
        oppProd8.Status__c='Won';
        OppProd8.Win_Probability__c =100;
        OppProd8.Projected_Members__c =2;
        return OppProd8;         
    }
    
    public static  Attachment  insertionStandardAttach(ID accSubCaseId){
        Attachment attachS=new Attachment();     
        attachS.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attachS.body=bodyBlob;
        attachS.parentId=accSubCaseId;
        return attachS;
    }
    
    public static GEMS_Attachment__c insertionGemsAttach(ID accSubCaseId){
        GEMS_Attachment__c gemsAttach = new GEMS_Attachment__c();
        gemsAttach.type__c='BPA';
        gemsAttach.Attachment__c = 'ts';
        gemsAttach.case__c=accSubCaseId;
        return gemsAttach;
    }
    
    public static CaseTeamMember insertionCaseTeam(Id accSubCaseId, String caseTeamRoleName){
        
        User u = [SELECT ID, Profile.Name FROM User WHERE isActive = True And Profile.Name='System Administrator' LIMIT 1];
        List<CaseTeamRole> rolesList = [Select ID from CaseTeamRole where name=:caseTeamRoleName];
        CaseTeamRole role = new CaseTeamRole() ;
        CaseTeamMember caseTeamMembr = new CaseTeamMember();
        if(rolesList == null || rolesList.isEmpty()) {
            User sysu = [SELECT ID, Profile.Name FROM User WHERE isActive = True And Profile.Name='System Administrator' LIMIT 1];
            System.runAs(sysu) {
            role = new CaseTeamRole();
            role.name=caseTeamRoleName;
            role.AccessLevel = 'Edit';
            insert role;
            }
            caseTeamMembr.ParentId = accSubCaseId;
            caseTeamMembr.TeamRoleId = role.Id;
            caseTeamMembr.MemberID = u.ID;
        }else {
        role = rolesList [0];
        caseTeamMembr.ParentId = accSubCaseId;
        caseTeamMembr.TeamRoleId = role.Id;
        caseTeamMembr.MemberID = u.ID;
        
        }
        return caseTeamMembr;
    }
    
    public static GEMS_Benefit_Agreement__c insertionBenefitAgg(ID accId, ID accSubCaseId,ID product2RecId){
        GEMS_Benefit_Agreement__c benefit = new GEMS_Benefit_Agreement__c();
        benefit.Name='1234';
        benefit.Account__c = accId;
        benefit.AccountStructureCase__c=accSubCaseId;
        Plan__c plan = insertionPlan(product2RecId);
        insert plan;
        benefit.Plan__c = plan.Id;
        benefit.Product__c=product2RecId; 
        benefit.BA_Fund_Type__c='ACAP';
        benefit.Has_Group_Sections__c = true; 
        
        return benefit;
    }
    
    public static  GEMS_Category__c insertionGemsCatg(ID accId, ID accSubCaseId){ 
        GEMS_Category__c gemsCat =new GEMS_Category__c();
        gemsCat.Account__c=accId;
        gemsCat.Case__c=accSubCaseId;
        gemsCat.Category_Cobra_Code__c='CO';
        gemsCat.Category_Description__c='ABS';
        gemsCat.Usage_Billing__c=true;
        gemsCat.Usage_Mailing__c=true;
        gemsCat.Usage_Product__c=true;
        gemsCat.Usage_Reporting__c=true;
        gemsCat.name ='1234';
        gemsCat.Has_Group_Sections__c = true;
        return gemsCat;
    }

    
 /**********************************************************/
    public static  Opportunity  insertionOpp1(ID accId){      
        ID OppRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
        Opportunity oppty = new Opportunity();
        oppty.RecordTypeId=OppRecTypeId;
        oppty.Name='BenefitAgreementControllerTest';
        oppty.AccountId=accId;
        oppty.Type='Other';
        oppty.StageName='Expected In';
        oppty.Exchange_Offering_Type__c='No Private Exchange';
        oppty.CloseDate=Date.Today().addDays(8);
        oppty.Expected_RFP_Release_Date__c=Date.Today().addDays(8);
        oppty.RFI_RFP_Received_Date__c=Date.Today().addDays(8);
        oppty.Requested_Effective_Date__c=Date.Today().addDays(8);
        oppty.Expected_Health_Members__c=2;
        oppty.Account_Market_Segment__c='LG';
        oppty.HCSC_Division__c='IL';
        oppty.Region__c='N/A - IL';
        oppty.District__c='290';
        oppty.Clusters__c='020';
        return oppty;
 }
 
        
    public static Account insertionAccountNew( ){
    Account acc = new Account();
    acc.Name = 'Example';
    acc.status__c = 'Active';
    acc.Fax = '1234567'; 
    acc.Effective_Date__c = Date.Today().addDays(30);
    return acc;
 
 }
 
 
  public static  Opportunity  insertionOppNew(ID accId){
 Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Sale').getRecordTypeId();
    Opportunity opp =new Opportunity();
    opp.Accountid= accId;
    opp.Name ='Test3';
    opp.Type ='Other';
    opp.Clusters__c = '005';
    opp.Exchange_Offering_Type__c ='Private Exchange';
    opp.Primary_Closed_Reason__c ='Reputation of selected carrier';
    opp.StageName ='Won';
    opp.Requested_Effective_Date__c = system.today();    
    opp.Expected_Health_Members__c = 2;
    opp.HCSC_Division__c = 'IL';
    opp.CloseDate = system.today();
    opp.RFI_RFP_Received_Date__c = system.today();
    opp.Probability = 100.00;
    opp.recordTypeId = oppRecordTypeId;
     return opp;
 
 }
 
 public static  product2 insertionProductNew( ){  
        product2 prod1 = new product2();
       prod1.name = 'BCS Stop Loss'; 
       //prod1.Status__c='Active';  
       prod1.isActive=true;
       prod1.Product_Category__c = 'PPO';
       return prod1;
 }
    public static Attachment insertAttachment(Id parntId){  
        Attachment attachS=new Attachment();     
        attachS.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attachS.body=bodyBlob;
        attachS.parentId=parntId;
        return attachS;
    }
    
    public static GEMS_Attachment__c insertGemsAttachment(Id caseId){  
        GEMS_Attachment__c attach = new GEMS_Attachment__c();
        attach.type__c='BPA';
        attach.Attachment__c = 'ts';
        attach.case__c=caseId;
        return attach;
    }
  public static  Opportunity_Product__c  insertionOppProdNew(ID prod1Id, ID oppId){ 
        Opportunity_Product__c OppProd = New Opportunity_Product__c();
        OppProd.Product__c =prod1Id;
        OppProd.Funding_Type__c ='ACAP';
        OppProd.Opportunity_Name__c = oppId; 
        OppProd.Status__c='In Progress';
     return OppProd;         
} 
 
 
      public static  product2 insertionProduct1( ){  
        Product2 productRec1 = new Product2();
        productRec1.Name='BCS Stop Loss';
        productRec1.Product_Category__c='HSA';
        productRec1.Family='Ancillary and other';
        productRec1.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
        productRec1.IsActive=true;
        productRec1.HCSC_State__c='IL';
        productRec1.External_ID__c='IL-Accident Insurance (HSA)';
        return productRec1 ;
 }
 
   public static  product2 insertionProduct2( ){  
        Product2 productRec2 = new Product2();
        productRec2.Name='BCS Stop Loss';
        productRec2.Product_Category__c='FSA';
        productRec2.Family='Ancillary and other';
        productRec2.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
        productRec2.IsActive=true;
        productRec2.HCSC_State__c='IL';
        productRec2.External_ID__c='IL-Accident Insurance (FSA)';
        return productRec2;
 }
  
  public static  product2 insertionProduct3( ){  
        Product2 productRec3 = new Product2();
        productRec3.Name='BCS Stop Loss';
        productRec3.Product_Category__c='BCC';
        productRec3.Family='Ancillary and other';
        productRec3.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
        productRec3.IsActive=true;
        productRec3.HCSC_State__c='IL';
        productRec3.External_ID__c='IL-Accident Insurance (BCC)';
        return productRec3;
 }
  
   public static  product2 insertionProduct4( ){  
        Product2 productRec4 = new Product2();
        productRec4.Name='BCS Stop Loss';
        productRec4.Product_Category__c='Cobra';
        productRec4.Family='Ancillary and other';
        productRec4.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
        productRec4.IsActive=true;
        productRec4.HCSC_State__c='IL';
        productRec4.External_ID__c='IL-Accident Insurance (Cobra)';
        return productRec4;
 }
 
  public static  product2 insertionProduct5( ){  
        Product2 productRec5 = new Product2();
        productRec5.Name='BCS Stop Loss';
        productRec5.Product_Category__c='EPO';
        productRec5.Family='Ancillary and other';
        productRec5.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
        productRec5.IsActive=true;
        productRec5.HCSC_State__c='IL';
        productRec5.External_ID__c='IL-Accident Insurance (EPO)';
        return productRec5;
 }
  
  
  public static  product2 insertionProduct6( ){  
        Product2 productRec6 = new Product2();
        productRec6.Name='BCS Stop Loss';
        productRec6.Product_Category__c='Shared Accums';
        productRec6.Family='Ancillary and other';
        productRec6.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
        productRec6.IsActive=true;
        productRec6.HCSC_State__c='IL';
        productRec6.External_ID__c='IL-Accident Insurance (Shared Accums)';
        return productRec6;
 }
  
  public static  product2 insertionProduct7( ){  
        Product2 productRec7 = new Product2();
        productRec7.Name='BCS Stop Loss';
        productRec7.Product_Category__c='PPO';
        productRec7.Family='Ancillary and other';
        productRec7.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
        productRec7.IsActive=true;
        productRec7.HCSC_State__c='IL';
        productRec7.External_ID__c='IL-Accident Insurance (Shared Accums)';
        return productRec7;
 }
   public static  product2 insertionProduct8( ){  
        Product2 productRec8 = new Product2();
        productRec8.Name='Dental PPO';
        productRec8.Product_Category__c='Dental';
        productRec8.Family='Ancillary and other';
        productRec8.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
        productRec8.IsActive=true;
        productRec8.HCSC_State__c='IL';
        productRec8.External_ID__c='IL-Accident Insurance (Shared Accums)';
        return productRec8;
 }
  
  
  
  public static  Opportunity_Product__c  insertionOppProd1(ID prodId, ID opptyId){ 
        Opportunity_Product__c oppProd1 = new Opportunity_Product__c(); 
        oppProd1.Product__c= prodId;
        oppProd1.Opportunity_Name__c=opptyId;
        oppProd1.Status__c='In Progress';
        oppProd1.Win_Probability__c=10;
        oppProd1.Funding_Type__c='ASO';
        oppProd1.Projected_Members__c=2;
         return oppProd1;         
} 
  
  public static  Opportunity_Product__c  insertionOppProd2(ID prodId, ID opptyId){  
        Opportunity_Product__c oppProd2 = new Opportunity_Product__c();
        oppProd2.Product__c= prodId;
        oppProd2.Opportunity_Name__c=opptyId;
        oppProd2.Status__c='In Progress';
        oppProd2.Win_Probability__c=100;
        oppProd2.Funding_Type__c='PREM';
        oppProd2.Projected_Members__c=2;
         return oppProd2;         
} 
  
  public static  Opportunity_Product__c  insertionOppProd3( ID prodId, ID opptyId){  
        Opportunity_Product__c oppProd3 = new Opportunity_Product__c();
        oppProd3.Product__c=prodId;
        oppProd3.Opportunity_Name__c=opptyId;
        oppProd3.Status__c='In Progress';
        oppProd3.Win_Probability__c=10;
        oppProd3.Funding_Type__c='ACAP';
        oppProd3.Projected_Members__c=2;
         return oppProd3;         
}
         
   public static  Opportunity_Product__c  insertionOppProd4(ID prodId, ID opptyId){ 
       Opportunity_Product__c oppProd4 = new Opportunity_Product__c(); 
        oppProd4.Product__c=prodId;
        oppProd4.Opportunity_Name__c=opptyId;
        oppProd4.Status__c='In Progress';
        oppProd4.Win_Probability__c=10;
        oppProd4.Funding_Type__c='COST';
        oppProd4.Projected_Members__c=2;
         return oppProd4;         
} 

public static  Opportunity_Product__c  insertionOppProd5(ID prodId, ID opptyId){ 
       Opportunity_Product__c oppProd5 = new Opportunity_Product__c(); 
        oppProd5.Product__c=prodId;
        oppProd5.Opportunity_Name__c=opptyId;
        oppProd5.Status__c='In Progress';
        oppProd5.Win_Probability__c=10;
        oppProd5.Funding_Type__c='SERV';
        oppProd5.Projected_Members__c=2;
         return oppProd5;         
} 

public static  Opportunity_Product__c  insertionOppProd6(ID prodId, ID opptyId){ 
       Opportunity_Product__c oppProd6 = new Opportunity_Product__c(); 
        oppProd6.Product__c=prodId;
        oppProd6.Opportunity_Name__c=opptyId;
        oppProd6.Status__c='In Progress';
        oppProd6.Win_Probability__c=10;
        oppProd6.Funding_Type__c='SERV';
        oppProd6.Projected_Members__c=2;
         return oppProd6;         
}

  public static  Opportunity_Product__c  insertionOppProd7(ID prodId, ID opptyId){ 
       Opportunity_Product__c oppProd7 = new Opportunity_Product__c(); 
        oppProd7.Product__c=prodId;
        oppProd7.Opportunity_Name__c=opptyId;
        oppProd7.Status__c='In Progress';
        oppProd7.Win_Probability__c=10;
        oppProd7.Funding_Type__c='SERV';
        oppProd7.Projected_Members__c=2;
         return oppProd7;         
}

  
  
  
     
  public static Case insertionCase(String RecordTypeName){
  Case caseRec = new Case();
        caseRec.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get(RecordTypeName).getRecordTypeId();
        //caseRec.Opportunity_Name__c=opptyId;
        caseRec.Status='In Progress';
        caseRec.HCSC_Division__c='IL';
        caseRec.Funding_Type_Multiselect__c = 'ACAP';
      //  caseRec.GEMS_Standard_Product__c = 'Standard Products only';
        caseRec.GEMS_Products__c = 'Dearborn;EPO;HSA;FSA;BCC;Cobra;RX';
       // caseRec.Accountid=accRec.ID;
        caseRec.GEMS_Integrated__c = false;
        caseRec.GEMS_BCC_Products__c = 'Selective I/O';
        caseRec.GEMS_Bank__c = '' ;
       // caseRec.GEMS_public_Exchange__c =False ;
        caseRec.GEMS_Rx_Vendor__c ='Prime' ;
        caseRec.GEMS_Vendor__c = '';
        caseRec.GEMS_Line_of_Business__c='Major National';
        caseRec.GEMS_Submission_Type__c='Renewal';
        caseRec.GEMS_Submission_Sub_Type__c='Funding Change';
        caseRec.GEMS_Effective_Date__c= system.today();
        caseRec.GEMS_Case_Effective_Date__c=system.today();
        caseRec.GEMS_Enter_number_of_Benefit_Agreements__c='4';
        caseRec.GEMS_Enter_the_number_of_Group_Sections__c='2';
        caseRec.GEMS_Enter_number_of_categories__c='3';
      //  caseRec.GEMS_Private_Exchange_Values__c ='No';
        return caseRec;
 }
  
    public static Case insertionCaseMaintenance(String RecordTypeName){
  		Case caseRec = new Case();
        caseRec.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get(RecordTypeName).getRecordTypeId();
        caseRec.Status='In Progress';
        caseRec.HCSC_Division__c='IL';
        caseRec.Funding_Type_Multiselect__c = 'ACAP';
        caseRec.GEMS_Products__c = 'Dearborn;EPO;HSA;FSA;BCC;Cobra;RX';
        caseRec.GEMS_Integrated__c = false;
        caseRec.GEMS_BCC_Products__c = 'Selective I/O';
        caseRec.GEMS_Bank__c = '' ;
        caseRec.GEMS_Rx_Vendor__c ='Prime' ;
        caseRec.GEMS_Vendor__c = '';
        caseRec.GEMS_Line_of_Business__c='Major National';
        caseRec.GEMS_Submission_Type__c='ID Card Maintenance';
        caseRec.GEMS_Submission_Sub_Type__c='ID Card Changes, No Benefit Changes';
        caseRec.GEMS_ID_Cards_Format__c = 'Custom';
        caseRec.GEMS_Effective_Date__c= system.today();
        caseRec.GEMS_Case_Effective_Date__c=system.today();
        caseRec.GEMS_Enter_number_of_Benefit_Agreements__c='4';
        caseRec.GEMS_Enter_the_number_of_Group_Sections__c='2';
        caseRec.GEMS_Enter_number_of_categories__c='3';
        return caseRec;
 	}
  
    public static Case insertionCase1(String RecordTypeName){
        Case caseRec1 = new Case();
        caseRec1.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get(RecordTypeName).getRecordTypeId();
        //caseRec1.Opportunity_Name__c=opptyId;
        caseRec1.Status='Design In Progress';
        caseRec1.Funding_Type_Multiselect__c = 'ACAP';
        caseRec1.GEMS_Products__c = 'Shared Accums';
       // caseRec.Accountid=accRec.ID;
        caseRec1.GEMS_Integrated__c = false;
        caseRec1.GEMS_BCC_Products__c = 'Selective I/O';
        caseRec1.GEMS_Bank__c = '' ;
       // caseRec.GEMS_public_Exchange__c =False ;
        caseRec1.GEMS_Rx_Vendor__c ='Prime' ;
        caseRec1.GEMS_Vendor__c = 'Benefit';
        caseRec1.GEMS_Shared_Accums_Shared_With__c='';
        caseRec1.GEMS_Line_of_Business__c='Major National';
        caseRec1.GEMS_Effective_Date__c= Date.today().addDays(9);
        caseRec1.GEMS_Case_Effective_Date__c=Date.today().addDays(9);
        return caseRec1;
 }
  
   public static Case insertionCase2(String RecordTypeName){
  Case caseRec2 = new Case();
        caseRec2.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get(RecordTypeName).getRecordTypeId();
        //caseRec.Opportunity_Name__c=opp.Id;
        caseRec2.Status='Design In Progress';
        caseRec2.Funding_Type_Multiselect__c = 'ACAP';
        caseRec2.GEMS_Products__c = 'HSA';
       // caseRec.Accountid=accRec.ID;
        caseRec2.GEMS_Integrated__c = true;
        caseRec2.GEMS_BCC_Products__c = 'Selective I/O';
        caseRec2.GEMS_Bank__c = '' ;
       // caseRec.GEMS_public_Exchange__c =False ;
        caseRec2.GEMS_Rx_Vendor__c ='Prime' ;
        caseRec2.GEMS_Vendor__c = 'Benefit';
        caseRec2.GEMS_Line_of_Business__c='Major National';
        caseRec2.GEMS_Effective_Date__c= Date.today().addDays(9);
        caseRec2.GEMS_Case_Effective_Date__c=Date.today().addDays(9);
        return caseRec2;
 }
  
 public static Case insertionCase4(String RecordTypeName){
        Case caseRec4 = new Case();
        caseRec4.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get(RecordTypeName).getRecordTypeId();
        //caseRec1.Opportunity_Name__c=opptyId;
        caseRec4.Status='Design In Progress';
        caseRec4.Funding_Type_Multiselect__c = 'ACAP';
        caseRec4.GEMS_Products__c = '';
       // caseR4c.Accountid=accRec.ID;
        caseRec4.GEMS_Integrated__c = false;
        caseRec4.GEMS_BCC_Products__c = 'Selective I/O';
        caseRec4.GEMS_Bank__c = '' ;
       // caseRec.GEMS_public_Exchange__c =False ;
        caseRec4.GEMS_Rx_Vendor__c ='Prime' ;
        caseRec4.GEMS_Vendor__c = 'Benefit';
        caseRec4.GEMS_Shared_Accums_Shared_With__c='';
        caseRec4.GEMS_Line_of_Business__c='Major National';
        caseRec4.GEMS_Effective_Date__c= Date.today().addDays(9);
        caseRec4.GEMS_Case_Effective_Date__c=Date.today().addDays(9);
        return caseRec4;
 }
 
 
 
 
  public static  GEMS_Benefit_Agreement__c insertionBenefit(ID accRecId, ID caseRecId,ID productRec1Id){
        GEMS_Benefit_Agreement__c benefit = new GEMS_Benefit_Agreement__c();
        
        benefit.Name='1234';
        benefit.Account__c = accRecId;
        benefit.AccountStructureCase__c=caseRecId;        
        benefit.Product__c=productRec1Id; 
        Plan__c plan = insertionPlan(productRec1Id);
        insert plan;
        benefit.Plan__c = plan.Id;
        benefit.BA_Fund_Type__c='ACAP'; 
        benefit.IsNew__c=true;
        return benefit;
 }
      public static  GEMS_Benefit_Agreement__c insertionBenefitWithoutProductType(ID accRecId, ID caseRecId){
        GEMS_Benefit_Agreement__c benefit = new GEMS_Benefit_Agreement__c();
        benefit.Name='1234';
        benefit.Account__c = accRecId;
        benefit.AccountStructureCase__c=caseRecId;                
        benefit.BA_Fund_Type__c='ACAP';      
        return benefit;
 	  }    

    public static  GEMS_Benefit_Agreement__c insertionBenefitWithoutProductCode(ID accRecId, ID caseRecId) {
        Product2 prod = new Product2();
        prod.Name='BCS Stop Loss';
        prod.Product_Category__c='HSA';
        prod.Family='Ancillary and other';
        prod.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
        prod.IsActive=true;
        prod.HCSC_State__c='IL';
        prod.External_ID__c='IL-Accident Insurance (HSA)1';
        insert prod;
        
        Plan__c plan= new Plan__c ();
  		plan.Product__c = prod.Id;
  		plan.External_Id__c = 'plan999';
  		plan.Plan_Type__c = 'PDent';
  		insert plan;
        
        GEMS_Benefit_Agreement__c benefit = new GEMS_Benefit_Agreement__c();
        benefit.Name='1';
        benefit.IsNew__c = true;
        benefit.Account__c = accRecId;
        benefit.AccountStructureCase__c=caseRecId;                
        benefit.BA_Fund_Type__c='ACAP'; 
        benefit.Plan__c = plan.Id;
        benefit.Product__c = prod.id;
        return benefit;
 	  }
    
     public static  GEMS_Benefit_Agreement__c insertionBenefitWithProductCode(ID accRecId, ID caseRecId) {
        Product2 prod = new Product2();
        prod.Name='BCS Stop Loss';
        prod.Product_Category__c='HSA';
        prod.Family='Ancillary and other';
        prod.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
        prod.IsActive=true;
        prod.HCSC_State__c='IL';
        prod.External_ID__c='IL-Accident Insurance (HSA)2';
        prod.ProductCode='PPO';
        insert prod;
        
        Plan__c plan= new Plan__c ();
  		plan.Product__c = prod.Id;
  		plan.External_Id__c = 'plan999';
  		plan.Plan_Type__c = 'PDent';
  		insert plan;
        
        GEMS_Benefit_Agreement__c benefit = new GEMS_Benefit_Agreement__c();
        benefit.Name='2';
        benefit.IsNew__c = true;
         benefit.Account__c = accRecId;
        benefit.AccountStructureCase__c=caseRecId;                
        benefit.BA_Fund_Type__c='ACAP'; 
        benefit.Plan__c = plan.Id;
        benefit.Product__c = prod.id;
        return benefit;
 	  }
     public static  GEMS_Benefit_Agreement__c insertionBenefitWithProductCode2(ID accRecId, ID caseRecId) {
        Product2 prod = new Product2();
        prod.Name='BCS Stop Loss2';
        prod.Product_Category__c='HSA';
        prod.Family='Ancillary and other';
        prod.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
        prod.IsActive=true;
        prod.HCSC_State__c='IL';
        prod.External_ID__c='IL-Accident Insurance (HSA)3';
        prod.ProductCode='PPO';
        insert prod;
        
        Plan__c plan= new Plan__c ();
  		plan.Product__c = prod.Id;
  		plan.External_Id__c = 'plan999';
  		plan.Plan_Type__c = 'PDent';
  		insert plan;
        
        GEMS_Benefit_Agreement__c benefit = new GEMS_Benefit_Agreement__c();
        benefit.Name='2';
        benefit.IsNew__c = true;
         benefit.Account__c = accRecId;
        benefit.AccountStructureCase__c=caseRecId;                
        benefit.BA_Fund_Type__c='ACAP'; 
        benefit.Plan__c = plan.Id;
        benefit.Product__c = prod.id;
        return benefit;
 	  }
    public static  GEMS_Benefit_Agreement__c insertionBenefitWithoutProduct(ID accRecId, ID caseRecId) {
        Product2 prod = new Product2();
        prod.Name='BCS Stop Loss';
        prod.Product_Category__c='HSA';
        prod.Family='Ancillary and other';
        prod.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
        prod.IsActive=true;
        prod.HCSC_State__c='IL';
        prod.External_ID__c='IL-Accident Insurance (HSA)3';
        prod.ProductCode='PPO';
        insert prod;
        
        Plan__c plan= new Plan__c ();
  		plan.Product__c = prod.Id;
  		plan.External_Id__c = 'plan999';
  		plan.Plan_Type__c = 'PDent';
  		insert plan;
        
        GEMS_Benefit_Agreement__c benefit = new GEMS_Benefit_Agreement__c();
        benefit.Name='3';
        benefit.IsNew__c = true;
        benefit.Account__c = accRecId;
        benefit.AccountStructureCase__c=caseRecId;                
        benefit.BA_Fund_Type__c='ACAP'; 
        benefit.Plan__c = plan.Id;
        return benefit;
 	  }
    
    public static  GEMS_Benefit_Agreement__c insertionBenefitWithoutPlan(ID accRecId, ID caseRecId) {
        Product2 prod = new Product2();
        prod.Name='BCS Stop Loss';
        prod.Product_Category__c='HSA';
        prod.Family='Ancillary and other';
        prod.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('HCSC Non BlueStar Product').getRecordTypeId();
        prod.IsActive=true;
        prod.HCSC_State__c='IL';
        prod.External_ID__c='IL-Accident Insurance (HSA)4';
        prod.ProductCode='PPO';
        
        GEMS_Benefit_Agreement__c benefit = new GEMS_Benefit_Agreement__c();
        benefit.Name='4';
        benefit.IsNew__c = true;
        benefit.Account__c = accRecId;
        benefit.AccountStructureCase__c=caseRecId;                
        benefit.BA_Fund_Type__c='ACAP'; 
        benefit.Product__c = prod.id;
        return benefit;
 	  }
    
    public static  GEMS_Benefit_Agreement__c insertionBenefitWithoutPlanAndProduct(ID accRecId, ID caseRecId) {
        GEMS_Benefit_Agreement__c benefit = new GEMS_Benefit_Agreement__c();
        benefit.Name='5';
        benefit.IsNew__c = true;
        benefit.Account__c = accRecId;
        benefit.AccountStructureCase__c=caseRecId;                
        benefit.BA_Fund_Type__c='ACAP'; 
        return benefit;
 	}
    
    
  public static  GEMS_Shared_Accums__c  insertionShared(){         
  GEMS_Shared_Accums__c sharedAccums =new GEMS_Shared_Accums__c();
    //        sharedAccums.GEMS_Case__c=caseRec.id;
      //      sharedAccums.Benefit_Agreement__c=benefit.id;                        
            sharedAccums.Accum_Period__c='Calendar Year';    
            sharedAccums.Shared_Accums_Effective_Date__c=Date.today();
            sharedAccums.HCSC_responsible_for_Vendor_Eligibility__c='Yes';
            boolean s = true;   
            boolean s2 = false;   
            sharedAccums.Deductible__c= s;
            sharedAccums.Aggregate_or_Embedded_Deductible__c='Aggregate';
            Decimal d1 = 5000;
            Decimal d2 = 7000;
            Decimal d3 = 9000;
            sharedAccums.Individual_Deductible_Amount__c=d1;
            //sharedAccums.Deductible_Middle_Tier_s_if_Applicable__c=d2;                        
            sharedAccums.Family_Deductible_Amount__c=d1;    
            sharedAccums.Does_Deductible_apply_to_Out_of_Pocket__c='Yes';
            sharedAccums.Does_Copay_apply_to_Out_of_Pocket__c='Yes';
            sharedAccums.Out_of_Pocket__c=s2;
            sharedAccums.Aggregate_or_Embedded_Out_of_Pocket__c='Aggregate';
            sharedAccums.Individual_Out_of_Pocket_Amount__c=d3;
            //sharedAccums.Out_of_Pocket_Middle_Tier_if_Applicable__c=d1;                       
            sharedAccums.Family_Out_of_Pocket_Amount__c=d1;            
            sharedAccums.Lifetime_Maximum__c=s;            
            sharedAccums.Amount__c=900000;
            sharedAccums.Accums_Shared_With__c='Pharmacy Only';
            sharedAccums.Accums_Feeding_feaking__c='In Network Updates/Feeds Out of Network';
            sharedAccums.Shared_Accum_ID__c='ABS';
            sharedAccums.Shared_Accum_with_Vendor_Using__c='SSN';         
            return sharedAccums;
 } 
           
        
  public static  GEMS_Group_Section__c insertionGroup(ID accRecId, ID caseRecId){         
        GEMS_Group_Section__c groupSection = new GEMS_Group_Section__c();
        groupSection.Section_Eff_Date__c = system.today();
        groupSection.case__c = caseRecId;
        groupSection.account__c = accRecId;
        groupSection.Section_No__c ='2001';
        groupSection.Group_No__c='TeSt02';                                       
        groupSection.Section_Description__c='TeSt02';
        return groupSection;
 }
    
    //Added Billing Profile Creation Method
     public static  GEMS_Billing_Profile__c insertionBA(ID accRecId, ID caseRecId){         
        GEMS_Billing_Profile__c billingProf = new GEMS_Billing_Profile__c();
        billingProf.Effective_Date__c = system.today();
        billingProf.case__c = caseRecId;
        billingProf.account__c = accRecId;
        //billingProf.Billing_Address__c =Add;
                                          
        billingProf.Name='TeSt02';
        return billingProf;
 }

       
  public static  GEMS_Category__c insertiongemscat1(ID accRecId, ID caseRecId){ 
  GEMS_Category__c gemscat1 =new GEMS_Category__c();
       gemscat1.Account__c=accRecId;
        gemscat1.Case__c=caseRecId;
        gemscat1.Category_Cobra_Code__c='CO';
        gemscat1.Category_Description__c='ABS';
        gemscat1.Usage_Billing__c= false;
        gemscat1.Usage_Mailing__c=false;
        gemscat1.Usage_Product__c=false;
        gemscat1.Usage_Reporting__c= false;
        gemscat1.name ='1234';
        return gemscat1;
 }
 
 public static  GEMS_Category__c insertiongemscat2(ID accRecId, ID caseRecId){ 
  GEMS_Category__c gemscat1 =new GEMS_Category__c();
       gemscat1.Account__c=accRecId;
        gemscat1.Case__c=caseRecId;
        gemscat1.Category_Cobra_Code__c='CO';
        gemscat1.Category_Description__c='ABS';
        gemscat1.Usage_Billing__c=true;
        gemscat1.Usage_Mailing__c=true;
        gemscat1.Usage_Product__c=true;
        gemscat1.Usage_Reporting__c=true;
        gemscat1.name ='5678';
        return gemscat1;
 }
 
  public static  GEMS_Category__c insertiongemscat3(ID accRecId, ID caseRecId){ 
  GEMS_Category__c gemscat1 =new GEMS_Category__c();
       gemscat1.Account__c=accRecId;
        gemscat1.Case__c=caseRecId;
        gemscat1.Category_Cobra_Code__c='CO';
        gemscat1.Category_Description__c='ABS';
        gemscat1.Usage_Billing__c=true;
        gemscat1.Usage_Mailing__c=true;
        gemscat1.Usage_Product__c=true;
        gemscat1.Usage_Reporting__c=true;
        gemscat1.name ='9012';
        return gemscat1;
 }
 
   public static  GEMS_Category__c insertiongemscat4(ID accRecId, ID caseRecId){ 
  GEMS_Category__c gemscat1 =new GEMS_Category__c();
       gemscat1.Account__c=accRecId;
        gemscat1.Case__c=caseRecId;
        gemscat1.Category_Cobra_Code__c='CO';
        gemscat1.Category_Description__c='ABS';
        gemscat1.Usage_Billing__c=true;
        gemscat1.Usage_Mailing__c=true;
        gemscat1.Mailing_Address__c=null;
        gemscat1.Usage_Product__c=true;
        gemscat1.Usage_Reporting__c=true;
        gemscat1.name ='9012';
        return gemscat1;
 }
 
  public static GEMS_Corp_Characteristic_Code__c insertionCorp(){    
       GEMS_Corp_Characteristic_Code__c corp = new GEMS_Corp_Characteristic_Code__c();
        corp.CORP_Characteristic_Code__c ='simple';
        return corp;
 }
            
  public static  GEMS_Characteristic__c insertionCharacteristic(ID accRecId, ID caseRecId){           
  GEMS_Characteristic__c gemscha =new GEMS_Characteristic__c();     
     gemscha.Account__c= accRecId;
      gemscha.Case__c = caseRecId;
        gemscha.Comments__c ='Good';      
     //   gemscha.Corp_Characteristic_Code__c = corp.id;
        gemscha.Effective_Date__c = system.today();
        gemscha.End_Date__c = system.today();           
        gemscha.Usage__c ='ABS';
        gemscha.Other__c = false ;
        gemscha.Billing__c= false;
        gemscha.Mailing__c = false;
        gemscha.Product__c = false;
        gemscha.Reporting__c = false;      
        return gemscha;
        }
        public static  GEMS_Characteristic__c insertionCharacteristic2(ID accRecId, ID caseRecId){           
  GEMS_Characteristic__c gemscha =new GEMS_Characteristic__c();     
     gemscha.Account__c= accRecId;
      gemscha.Case__c = caseRecId;
        gemscha.Comments__c ='Bad';      
     //   gemscha.Corp_Characteristic_Code__c = corp.id;
        gemscha.Effective_Date__c = system.today();
        gemscha.End_Date__c = system.today();           
        gemscha.Usage__c ='Other';
        
        gemscha.Other__c = false ;
          gemscha.Billing__c=true;
        gemscha.Mailing__c=true;
        gemscha.Product__c=true;
        gemscha.Reporting__c=true;       
        return gemscha;
        }
        
 public static  GEMS_Group_Section__c insertionGroupSection(ID accRecId, ID caseRecId){     
 GEMS_Group_Section__c grpSec= new GEMS_Group_Section__c();
        grpSec.Name = 'Testing';
       grpSec.Account__c = accRecId;
       grpSec.Case__c = caseRecId;
        grpSec.Group_No__c = 'grpest';
        grpSec.Section_Description__c = 'section';
        grpSec.Section_No__c = '1223';
        return grpSec;           
}

 public static  GEMS_Attachment__c insertionAttach(ID caseRecId){ 
 GEMS_Attachment__c attach = new GEMS_Attachment__c();          
      attach.Attachment__c='test';
      attach.Case__c=caseRecId;
      attach.Type__c='ABS';
      attach.Description__c='testing';
      return attach; 
}
 public static GEMS_Return_Reason__c insertionReturn(){ 
 GEMS_Return_Reason__c reason = new GEMS_Return_Reason__c();  
      reason.GEMS_Sub_Type__c='ABS';
    //  reason.GEMS_Case__c=caseRec.id;
      reason.GEMS_Comments__c='ABC';
      reason.Process_Name__c='Account Setup Screening';
      reason.GEMS_Type__c='ABS/Matrix';
      reason.Return_Reason__c='Missing doc';
      return reason;
 }
 public static GEMS_BA_Assignment__c insertionBaAssign(ID accRecId, ID caseRecId,ID benfitAgrmtId,ID groupSectionId){ 
 GEMS_BA_Assignment__c BAassign = new GEMS_BA_Assignment__c();
     BAassign.Account__c=accRecId;
     BAassign.Case__c=caseRecId;
     BAassign.Group_Section__c=groupSectionId;
     BAassign.Benefit_Agreement__c=benfitAgrmtId;
     BAassign.Name='ABS';
     return BAassign;
 }
 
 public static GEMS_Category_Assignment__c insertionCategoryAssign(ID accRecId, ID caseRecId,ID gemscat1Id,ID groupSectionId){ 
 GEMS_Category_Assignment__c catAssign = new GEMS_Category_Assignment__c();
     catAssign.Account__c=accRecId;
    catAssign.Case__c=caseRecId;
    catAssign.Category__c=gemscat1Id;
    catAssign.Group_Section__c=groupSectionId;
     return catAssign;
     
 }
 
 public static GEMS_Characteristic_Value__c insertionCharacValue(ID gemschaId, ID caseRecId){ 
 GEMS_Characteristic_Value__c value = new GEMS_Characteristic_Value__c();
    value.Case__c=caseRecId;
    value.Characteristic__c=gemschaId;
     value.Code__c='ABS';
     value.Effective_Date__c = Date.Today().addDays(8);
     return value;
 }
 
 public static GEMS_Characteristic_Value__c insertionCharacValue2(ID gemschaId, ID caseRecId){ 
 GEMS_Characteristic_Value__c value = new GEMS_Characteristic_Value__c();
    value.Case__c=caseRecId;
    value.Characteristic__c=gemschaId;
     value.Code__c='ABS1';
     value.Effective_Date__c = Date.Today().addDays(8);
     return value;
 }
 
 public static GEMS_Cat_Char_Value_Association__c insertionAssociate(ID caseRecId,ID accRecId,ID valueId,ID gemscat1Id){ 
 GEMS_Cat_Char_Value_Association__c associate = new GEMS_Cat_Char_Value_Association__c();
      associate.Case__c=caseRecId;
     associate.Account__c=accRecId;
     associate.Characteristic_Value__c=valueId;
   associate.Category__c=gemscat1Id;
     return associate;
 }
 
 public static GEMS_BA_Category_Assignment__c insertionBACategory(ID accRecId, ID caseRecId,ID benfitAgrmtId,ID gemscat1Id){ 
 GEMS_BA_Category_Assignment__c bacateg = new GEMS_BA_Category_Assignment__c();
     bacateg.Account__c=accRecId;
     bacateg.Case__c=caseRecId;
     bacateg.Benefit_Agreement__c=benfitAgrmtId;
     bacateg.Category__c=gemscat1Id;
     return bacateg;
 }
 
 public static GEMS_Eligibility_Testing__c insertionEligibility(){ 
 GEMS_Eligibility_Testing__c eligible = new GEMS_Eligibility_Testing__c();
  //   eligible.Eligiblity_Case__c=caseRec.id;
     eligible.File_to_IT__c=Date.today();
     eligible.Receipt__c=Date.today();
     eligible.Res_from_IT__c=Date.today();
     eligible.Res_to_Client__c=Date.today();
     eligible.Target__c=Date.today();
     eligible.Total_Accept__c=2;
     eligible.Total_Reject__c=2;
     return eligible;
 }
 
 public static GEMS_Eligibility_Production__c insertionEligibilityProd(){ 
 GEMS_Eligibility_Production__c eligibleProduction = new GEMS_Eligibility_Production__c();
     eligibleProduction.Auth_to_Comp__c=Date.today();
     eligibleProduction.Auth_to_Valid__c=Date.today();
   //  eligibleProduction.Eligiblity_Case__c=caseRec.id;
     eligibleProduction.Load__c=Date.today();
     eligibleProduction.Receipt__c=Date.today();
     eligibleProduction.Target__c=Date.today();
     eligibleProduction.Total_Accept__c=2;
     eligibleProduction.Total_Reject__c=3;
     return eligibleProduction;
 }
 
 public static GEMS_Pharmacy_Scope_Code__c insertionPharmacy(){ 
 GEMS_Pharmacy_Scope_Code__c pharm = new GEMS_Pharmacy_Scope_Code__c();
  //   pharm.Case__c=caseRec.id;
   //  pharm.Peer_Reviewer__c=user.id;
     pharm.Copay_Type__c='Flat';
     pharm.Group_Pay_Code__c='ABCD';
     pharm.Mail__c='G=Flat/F=Flat/NF=Percent';
     pharm.Related_Scope_Code__c='ABCD';
     pharm.Retail__c='No Retail Benefits';
     pharm.Rider_Code__c='00';
     pharm.Scope_Status__c='No Scope Code Changes';
     pharm.Status__c='Started';
     pharm.Temp__c=False;
     pharm.Type__c='Permanent';
     return pharm;
 }
 
 public static Plan__c insertionPlan(ID productRec5Id){ 
 Plan__c plan= new Plan__c ();
  plan.Product__c = productRec5Id;
  plan.External_Id__c = 'plan999';
  plan.Plan_Type__c = 'PDent';
  return plan;
 }
 
 
 public static  GEMS_Benefit_Agreement__c insertionbenfitAgrmt(ID accRecId, ID caseRecId,ID productRec5Id,ID planId){
  GEMS_Benefit_Agreement__c benfitAgrmt= new GEMS_Benefit_Agreement__c();
        benfitAgrmt.Name='4561';
        benfitAgrmt.Account__c = accRecId;
        benfitAgrmt.AccountStructureCase__c=caseRecId;
        benfitAgrmt.Product__c=productRec5Id; 
        benfitAgrmt.Plan__c = planId;
        benfitAgrmt.BA_Fund_Type__c='ACAP';      
        return benfitAgrmt;
 }
  public static  GEMS_Custom_ID_Request_Form__c insertionRequest(){
  GEMS_Custom_ID_Request_Form__c request= new GEMS_Custom_ID_Request_Form__c();
 // request.Custom_ID_Request_Form_Case__c=caseRecId;
 return request;
  }
  
  public static String opportunityStatus() {
      return 'Expected In';
  }
  
 }