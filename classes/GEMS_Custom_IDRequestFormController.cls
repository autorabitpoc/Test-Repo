/**************************************************************************************
* Apex Class Name       : GEMS_Custom_IDRequestFormController
* Version               : 1.0
* Function              : This Class is for assigning ID Card record to ID Card Child Case under Selected BA(For GEMS Project).
* Modification Log      :
* Developer           Date                   Description
* ------------------------------------------------------------------------------------
* Praveen             06/10/2016             Original Version
* Malathi             05/15/2017             SFDC-2814 Ability to Clone Custom ID Form
* Phani Kommareddy    06/12/2017             SFDC-3064 Change how BAs are associated to Custom ID Card, Prospective and Suppression requests
* Phani Kommareddy    08/13/2017             SFDC-5306 Custom ID Request Form Enhancements
* Phani Kommareddy    09/13/2017             SFDC-4442 Ability to associate group sections to Custom ID Card requests
* Bharath             11/03/2017             SFDC-7099 Change the label for standard and custom options. 
* Phani Kommareddy    11/27/2017             SFDC-6369 GEMS - ID Card Maintenance: ID Card Case Page Layout & Functionality
* Phani Kommareddy	  02/19/2017			 SFDC-4244 GEMS: Acct Structure - Special Handling of Complex/Co-op Accounts (Downstream Processing)
*************************************************************************************/

public without sharing class GEMS_Custom_IDRequestFormController {
    public string saveResult {get; set;}
    public Id caseId {get; set;}
    public Id custFormRecId{get;set;}
    public Id customIdCardId{get;set;}
    public Id accountId;    
    public Id newcloneId{get;set;}    
    public Case ParentCase {get; set;}
    public GEMS_Custom_ID_Request_Form__c customIdCard{set;get;}
    public List<GEMS_Benefit_Agreement__c> benefitAgreementsList{set;get;}
    public List<Case> structureBAs{get;set;}
    public List<GEMS_BAIdWrapper> listOfBARecords{get; set;}
    public List<GEMS_GSIdWrapper> listOfGSRecords{get; set;}
    public String baCaseNums{set;get;}
    public String gsCaseNums{set;get;}
    public String assignmentType = null;
    public String clientLogo{get;set;}
    public String companyName{Set;get;}
    public String companyPlanName{Set;get;}
    public String alternativeNetwork{get;set;}
    public String customCardCarrier{get;set;}
    public String customStandardAlphaPrefix{get;set;}
    public String customFaceMesssage{get;set;}
    public String carvedOutRxVendorLogo{get;set;}
    public String familyOrSingleCoverage{get;set;}
    public String combineHealthAndMedicalCards{set;get;}
    public String includeCustomWebAddressOnBack{set;get;}
    public String includeClientWebAddress{set;get;}
    public String selectOneOptionForPhoneNumbers{set;get;}
    public String selectOneOptionForBackText{set;get;}
    public boolean disableSubmitButton{set;get;}
    public String stateInCustomWebsite{set;get;}
    
    public GEMS_Custom_IDRequestFormController(ApexPages.StandardController controller) {
        try {
            caseId = ApexPages.currentPage().getParameters().get('caseId');
            custFormRecId = ApexPages.currentPage().getParameters().get('Id');
            Id caseAccountStructureRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Account Structure').getRecordTypeId();
            clientLogo = customCardCarrier = customCardCarrier =  null;
            if(caseId!=null) {
                disableSubmitButton = true;
                ParentCase = [SELECT Id, CaseNumber, HCSC_Division__c, GEMS_Case_Effective_Date__c, GEMS_Submission_Type__c, GEMS_Submission_Sub_Type__c, 
                                GEMS_Line_of_Business__c, GEMS_Account_Submission_Info__c, GEMS_Account_Submission_Info__r.GEMS_Products__c, Market_Segment__c, Status, Owner.Name, Owner.Email, GEMS_Type__c,
                                Account.AccountNumber, Account.External_ID__c, Account.Name,Gems_Assigned_BAs__c
                                FROM Case WHERE id =: caseId];
                                
                customIdCard = new GEMS_Custom_ID_Request_Form__c();
                customIdCard.Custom_ID_Request_Form_Case__c=caseId;
                customIdCard.Print_FAMILY_SINGLE_Coverage_on_card__c='No';
                customIdCard.Combine_Health_Dental_Cards__c='N/A';
                customIdCard.Status__c='In Progress';
            } else if(custFormRecId!=null) {
                customIdCard= [SELECT ID, Name, GEMS_Account_Name__c,Phone_1__c,Phone_2__c ,Phone_3__c ,Phone_4__c, Phone_5__c, Phone_6__c, Phone_7__c ,Phone_8__c ,  GEMS_Account_Number__c, Account_Type__c,
                                Custom_ID_Request_Form_Case__c, Print_Company_Plan_Name_Other__c, Print_Company_Name_Other__c,Alternative_Network__c, Other_Alternative_Network__c, Card_Back_Message_long__c, 
                                BAs_Product_Type__c, Applicable_BAs__c,Status__c,Re_Submitted__c /*,Account_Specialist_Email_ID__c*/,Parent_ID_Card_Case_Url__c, Submitter_Email_ID__c,
                                Print_Company_Name__c, Print_Company_Plan_Name__c, Print_Company_Name_Value__c, CoPay_Label_1__c,CoPay_Label_1_value__c,Copay_Amount_1__c,
                                Copay_Label_2__c,CoPay_Label_2_value__c,Copay_Amount_2__c,Copay_Label_3__c,CoPay_Label_3_value__c,Copay_Amount_3__c,Copay_Label_4__c,Print_Client_Logo__c,
                                CoPay_Label_4_value__c,Copay_Amount_4__c,Copay_Label_5__c,CoPay_Label_5_value__c,Copay_Amount_5__c,Rx_Information__c,Print_Carve_Out_Rx_Vendor_Logo__c,
                                Print_Company_Plan_Name_Value__c,RxBin__c,RxPCN__c,RxGRP__c,Print_FAMILY_SINGLE_Coverage_on_card__c,Print_C_S_alpha_prefix_on_card__c,Print_custom_face_message_s_on_front__c,
                                Combine_Health_Dental_Cards__c,Include_a_custom_web_address_extension_o__c,Include_client_web_address__c,Select_one_option_for_phone_numbers_on_t__c,
                                Phone_Label_1__c,Phone_Label_Value_1__c,Not_a_BCBS_product_1__c,Phone_Label_2__c,Phone_Label_Value_2__c,Not_a_BCBS_product_2__c,Phone_Label_3__c,
                                Phone_Label_Value_3__c,Not_a_BCBS_product_3__c,Phone_Label_4__c,Phone_Label_Value_4__c,Not_a_BCBS_product_4__c,Phone_Label_5__c,Phone_Label_Value_5__c,Not_a_BCBS_product_5__c,
                                Not_a_BCBS_product_6__c,Phone_Label_6__c,Phone_Label_Value_6__c,Phone_Label_7__c,Phone_Label_Value_7__c,Not_a_BCBS_product_7__c,Phone_Label_8__c,
                                Phone_Label_Value_8__c,Not_a_BCBS_product_8__c,Select_one_option_for_the_Back_Text_Mess__c,Include_a_custom_card_carrier__c,Additional_comments_or_instructions__c,
                                Carved_Out_Rx_Vendor_s_Name__c,Custom_face_message_1__c,Custom_Face_Message_2__c,Print_Custom_alpha_prefix_on_card__c,Print_Company_Name_Value1__c,
                                Custom_Website__c,Client_Custom_Website__c,Card_Back_Message__c,Approved_Custom_Carrier_Message__c,Issuance_Type__c,Assignment_Type__c,Applicable_GSs__c FROM GEMS_Custom_ID_Request_Form__c WHERE Id=:custFormRecId];
                
                ParentCase = [SELECT Id, CaseNumber, HCSC_Division__c, GEMS_Case_Effective_Date__c, GEMS_Submission_Type__c, GEMS_Submission_Sub_Type__c, 
                                GEMS_Line_of_Business__c, GEMS_Account_Submission_Info__c, GEMS_Account_Submission_Info__r.GEMS_Products__c, Market_Segment__c, Status, Owner.Name, owner.email, GEMS_Type__c,
                                Account.AccountNumber, Account.External_ID__c, Account.Name,Gems_Assigned_BAs__c
                                FROM Case WHERE id =: customIdCard.Custom_ID_Request_Form_Case__c];
                                
            }
            
            if(customIdCard.Print_Client_Logo__c=='Yes') {
                clientlogo='Yes';
            }
            if(customIdCard.Print_Client_Logo__c=='No') {
                clientlogo='No';
            }
            
            if(customIdCard.Print_Company_Name__c=='Yes'){
                CompanyName='Yes';
            }
            if(customIdCard.Print_Company_Name__c=='No'){
                CompanyName='No';
            }
            
            if(customIdCard.Print_Company_Plan_Name__c=='Yes'){
                companyPlanName='Yes';
            }
            if(customIdCard.Print_Company_Plan_Name__c=='No') {
                companyPlanName='No';
            }
            
            if(customIdCard.Alternative_Network__c=='Yes') {
                alternativeNetwork='Yes';
            }
            if(customIdCard.Alternative_Network__c=='No') {
                alternativeNetwork='No';
            }
            
            if(customIdCard.Include_a_custom_card_carrier__c=='Yes') {
                customCardCarrier='Yes';
            }
            if(customIdCard.Include_a_custom_card_carrier__c=='No') {
                customCardCarrier='No';
            }
            
            if(customIdCard.Print_FAMILY_SINGLE_Coverage_on_card__c=='Yes(standard)') {
                familyOrSingleCoverage='Yes';
            }
            if(customIdCard.Print_FAMILY_SINGLE_Coverage_on_card__c=='No') {
                familyOrSingleCoverage='No';
            }
            if(customIdCard.Print_FAMILY_SINGLE_Coverage_on_card__c=='N/A when IDs are issued at the member level') {
                familyOrSingleCoverage='N/A';
            }
            if(customIdCard.Print_C_S_alpha_prefix_on_card__c=='Yes (standard)') {
                customStandardAlphaPrefix='Yes';
            }
            if(customIdCard.Print_C_S_alpha_prefix_on_card__c=='No') {
                customStandardAlphaPrefix='No';
            }
            if(customIdCard.Print_custom_face_message_s_on_front__c=='Yes') {
                customFaceMesssage='Yes';
            }
            if(customIdCard.Print_custom_face_message_s_on_front__c=='No') {
                customFaceMesssage='No';
            }
            if(customIdCard.Print_custom_face_message_s_on_front__c=='N/A') {
                customFaceMesssage='N/A';
            }
            
            if(customIdCard.Print_Carve_Out_Rx_Vendor_Logo__c=='Yes') {
                carvedOutRxVendorLogo='Yes';
            }
            if(customIdCard.Print_Carve_Out_Rx_Vendor_Logo__c=='No')  {
                carvedOutRxVendorLogo='No';
            }
            
            if(customIdCard.Combine_Health_Dental_Cards__c=='N/A') {
                combineHealthAndMedicalCards='N/A';
            }
            if(customIdCard.Combine_Health_Dental_Cards__c=='No') {
                combineHealthAndMedicalCards='No';
            }
            if(customIdCard.Combine_Health_Dental_Cards__c=='Yes, meets requirements outlined below') {
                combineHealthAndMedicalCards='Yes';
            }
            
            if(customIdCard.Include_a_custom_web_address_extension_o__c=='Yes, list custom website up to 28 characters') {
                includeCustomWebAddressOnBack='Yes';
            }
            if(customIdCard.Include_a_custom_web_address_extension_o__c=='No, use standard www.bcbsXX.com (where XX is applicable stateâs prefix)') {
                includeCustomWebAddressOnBack='No';
            }
            
            if(customIdCard.Include_client_web_address__c=='Yes, list custom website') {
                includeClientWebAddress='Yes';
            }
            if(customIdCard.Include_client_web_address__c=='No') {
                includeClientWebAddress='No';
            }
            
            if(customIdCard.Select_one_option_for_phone_numbers_on_t__c=='Include standard phone numbers?') {
                selectOneOptionForPhoneNumbers='Standard';
            }
            if(customIdCard.Select_one_option_for_phone_numbers_on_t__c=='Include customized labels/phone numbers?') {
                selectOneOptionForPhoneNumbers='Custom';
            }
            
            if(customIdCard.Select_one_option_for_the_Back_Text_Mess__c=='Include standard back messages?') {
                selectOneOptionForBackText='Standard';
            }
            if(customIdCard.Select_one_option_for_the_Back_Text_Mess__c=='Include custom back messages?') {
                selectOneOptionForBackText='Custom';
            }
            
            if(parentCase.HCSC_Division__c!=null) {
                stateInCustomWebsite=parentCase.HCSC_Division__c;
            }
            
            if(customIdCard.Assignment_Type__c != null && customIdCard.Assignment_Type__c != '') {
                assignmentType = customIdCard.Assignment_Type__c;
            } else {
                assignmentType = 'Benefit Agreement';
            }
            
            
            //SFDC-3064 Change how BAs are associated to Custom ID Card, Prospective and Suppression requests
            //SFDC-4244 - Added GEMS_BAs_SpHandling__c condition
            structureBAs = [SELECT id, (SELECT ID, Name, BA_Description__c, BA_Fund_Type__c, product__r.Name from GEMS_Benefit_Agreements__r where GEMS_BAs_SpHandling__c = true  order by Name),
                            (select name,group_no__c,section_no__c,section_description__c from Group_Sections__r) 
                            FROM Case WHERE RecordTypeId= :caseAccountStructureRecordTypeId AND GEMS_Account_Submission_Info__c= :ParentCase.GEMS_Account_Submission_Info__c LIMIT 1];
            listOfBARecords = new List<GEMS_BAIdWrapper>();
            listOfGSRecords = new List<GEMS_GSIdWrapper>();
            if(!structureBAs.isEmpty()){
                Case baCase = structureBAs.get(0);
                List<GEMS_Benefit_Agreement__c> baList = new List<GEMS_Benefit_Agreement__c>();
                baList = baCase.GEMS_Benefit_Agreements__r;
                for(GEMS_Benefit_Agreement__c ba: baList) {
                    listOfBARecords.add(new GEMS_BAIdWrapper(false, ba));                
                }
                
                List<GEMS_Group_Section__c> gsList = new List<GEMS_Group_Section__c>();
                gsList = baCase.Group_Sections__r;
                for(GEMS_Group_Section__c gs: gsList) {
                    listOfGSRecords.add(new GEMS_GSIdWrapper(false, gs));                
                }
            }
        }
        Catch(Exception ex) {
            System.debug('Exception'+ex.getMessage());
        }
    }
    
    public List<SelectOption> getClientlogoItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes','Yes'));
        options.add(new SelectOption('No','No'));
        return options;
    }
    
    public List<SelectOption> getAssignmentItems() {
        return GEMS_IDCardUtil.getAssignmentItems();
    }
    
    public List<SelectOption> getCompanyNameItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes','Yes'));
        options.add(new SelectOption('No','No'));
        return options;
    }
    
    public List<SelectOption> getCompanyPlanNameItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes','Yes'));
        options.add(new SelectOption('No','No'));
        return options;
    }
    
    public List<SelectOption> getAlternativeNetworkItems()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes','Yes'));
        options.add(new SelectOption('No','No'));
        return options;
    }
    
    public List<SelectOption> getCustomCardCarrierItems()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes','Yes'));
        options.add(new SelectOption('No','No'));
        return options;
    }
    
    public List<SelectOption> getFamilyOrSingleCoverageItems()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes','Yes (standard)'));
        options.add(new SelectOption('No','No'));
        options.add(new SelectOption('N/A','N/A when IDs are issued at the member level'));
        return options;
    }
    
    public List<SelectOption> getCustomStandardAlphaPrefixItems()
    {
        List<SelectOption> options = new List<SelectOption>();
        //7099 - Change the label of options for prefix on card.
        //options.add(new SelectOption('Yes','Yes (standard)'));
        //options.add(new SelectOption('No','No'));
        options.add(new SelectOption('Yes','Standard'));
        options.add(new SelectOption('No','Custom'));
        return options;
    }
    
    public List<SelectOption> getCustomFaceMesssageItems()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes','Yes'));
        options.add(new SelectOption('No','No'));
        options.add(new SelectOption('N/A','N/A with HMO/POS plans as these fields will list the PCP Information'));
        return options;
    }
    
    public List<SelectOption> getCarvedOutRxVendorLogoItems()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes','Yes'));
        options.add(new SelectOption('No','No'));
        return options;
    }
    
    public List<SelectOption> getCombineHealthAndMedicalCardsItems()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('N/A','N/A'));
        options.add(new SelectOption('No','No'));
        options.add(new SelectOption('Yes','Yes, meets requirements outlined below'));
        return options;
    }
    
    public List<SelectOption> getIncludeCustomWebAddressOnBackItems()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes','Yes, list custom website up to 28 characters'));
        options.add(new SelectOption('No','No, use standard www.bcbs'+stateInCustomWebsite+'.com'));
        return options;
    }
    
    public List<SelectOption> getIncludeClientWebAddressItems()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes','Yes, list custom website'));
        options.add(new SelectOption('No','No'));
        return options;
    }
    
    public List<SelectOption> getSelectOneOptionForPhoneNumbersItems()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Standard','Include standard phone numbers?'));
        options.add(new SelectOption('Custom','Include customized labels/phone numbers?'));
        return options;
    }
    
    public List<SelectOption> getSelectOneOptionForBackTextItems()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Standard','Include standard back messages?'));
        options.add(new SelectOption('Custom','Include custom back messages?'));
        return options;
    }
    
   
    public PageReference ClonecustID() 
    {      
      GEMS_Custom_ID_Request_Form__c Newclonedcustidform = customIdCard.clone(false,true);      
      Newclonedcustidform.Applicable_BAs__c = '';
      insert Newclonedcustidform;
      system.debug('Clone ID is ' +Newclonedcustidform.id);            
      newcloneId = Newclonedcustidform.id;             
      return null;
    }
    
      
    public PageReference submitIdCard() {
        if(customIdCard.Status__c=='In Progress') {

            customIdCard.Status__c='Submitted';
            update customIdCard;
        }
        else if(customIdCard.Status__c=='Submitted' || customIdCard.Status__c == 'Re-Submitted') {
            customIdCard.Status__c='Re-Submitted';
            update customIdCard;
        } else {
        return null;
    }        
    return null;
    }
    
    public PageReference saveAndAssignBAs() {
        customIdCard.Parent_ID_Card_Case_Url__c = URL.getSalesforceBaseUrl().toExternalForm() +'/'+ParentCase.Id;
        if(clientlogo=='Yes') {
            customIdCard.Print_Client_Logo__c='Yes';
        }
        if(clientlogo=='No') {
            customIdCard.Print_Client_Logo__c='No';
        }
        
        if(CompanyName=='Yes') {
            customIdCard.Print_Company_Name__c='Yes';
        }
        if(CompanyName=='No') {
            customIdCard.Print_Company_Name__c='No';
            customIdCard.Print_Company_Name_Value1__c='';
            customIdCard.Print_Company_Name_Other__c='';
        }
        
        if(companyPlanName=='Yes') {
            customIdCard.Print_Company_Plan_Name__c='Yes';
        }
        if(companyPlanName=='No') {
            customIdCard.Print_Company_Plan_Name__c='No';
            customIdCard.Print_Company_Plan_Name_Value__c='';
            customIdCard.Print_Company_Plan_Name_Other__c='';
        }
        
        if(alternativeNetwork=='Yes') {
            customIdCard.Alternative_Network__c='Yes';
        }
        if(alternativeNetwork=='No') {
            customIdCard.Alternative_Network__c='No';
            customIdCard.Other_Alternative_Network__c='';
        }
        
        if(customCardCarrier=='Yes') {
            customIdCard.Include_a_custom_card_carrier__c='Yes';
        }
        if(customCardCarrier=='No') {
            customIdCard.Include_a_custom_card_carrier__c='No';
            customIdCard.Approved_Custom_Carrier_Message__c='';
        }
        
        if(customStandardAlphaPrefix=='Yes') {
            customIdCard.Print_C_S_alpha_prefix_on_card__c='Yes (standard)';
            customIdCard.Print_Custom_alpha_prefix_on_card__c='';
        }
        if(customStandardAlphaPrefix=='No') {
            customIdCard.Print_C_S_alpha_prefix_on_card__c='No';
        }
        
        if(customFaceMesssage=='Yes') {
            customIdCard.Print_custom_face_message_s_on_front__c='Yes';
        }
        if(customFaceMesssage=='No') {
            customIdCard.Print_custom_face_message_s_on_front__c='No';
            customIdCard.Custom_face_message_1__c='';
            customIdCard.Custom_Face_Message_2__c='';
        }
        if(customFaceMesssage=='N/A') {
            customIdCard.Print_custom_face_message_s_on_front__c='N/A';
            customIdCard.Custom_face_message_1__c='';
            customIdCard.Custom_Face_Message_2__c='';
        }
        
        if(carvedOutRxVendorLogo=='Yes') {
            customIdCard.Print_Carve_Out_Rx_Vendor_Logo__c='Yes';
        }
        if(carvedOutRxVendorLogo=='No') {
            customIdCard.Print_Carve_Out_Rx_Vendor_Logo__c='No';
        }
        
        if(familyOrSingleCoverage=='Yes') {
            customIdCard.Print_FAMILY_SINGLE_Coverage_on_card__c='Yes(standard)';
        }
        if(familyOrSingleCoverage=='No') {
            customIdCard.Print_FAMILY_SINGLE_Coverage_on_card__c='No';
        }
        if(familyOrSingleCoverage=='N/A') {
            customIdCard.Print_FAMILY_SINGLE_Coverage_on_card__c='N/A when IDs are issued at the member level';
        }
        
        if(combineHealthAndMedicalCards=='N/A') {
            customIdCard.Combine_Health_Dental_Cards__c='N/A';
        }
        if(combineHealthAndMedicalCards=='No') {
            customIdCard.Combine_Health_Dental_Cards__c='No';
        }
        if(combineHealthAndMedicalCards=='Yes') {
            customIdCard.Combine_Health_Dental_Cards__c='Yes, meets requirements outlined below';
        }
        
        if(includeCustomWebAddressOnBack=='Yes') {
            customIdCard.Include_a_custom_web_address_extension_o__c='Yes, list custom website up to 28 characters';
        }
        if(includeCustomWebAddressOnBack=='No') {
            customIdCard.Include_a_custom_web_address_extension_o__c='No, use standard www.bcbsXX.com (where XX is applicable stateâs prefix)';
            customIdCard.Custom_Website__c='';
        }
        
        if(includeClientWebAddress=='Yes') {
            customIdCard.Include_client_web_address__c='Yes, list custom website';
        }
        if(includeClientWebAddress=='No') {
            customIdCard.Include_client_web_address__c='No';
            customIdCard.Client_Custom_Website__c='';
        }
        
        if(selectOneOptionForPhoneNumbers=='Standard') {
            customIdCard.Select_one_option_for_phone_numbers_on_t__c='Include standard phone numbers?';
        }
        if(selectOneOptionForPhoneNumbers=='Custom') {
            customIdCard.Select_one_option_for_phone_numbers_on_t__c='Include customized labels/phone numbers?';
        }
        
        if(selectOneOptionForBackText=='Standard') {
            customIdCard.Select_one_option_for_the_Back_Text_Mess__c='Include standard back messages?';
            customIdCard.Card_Back_Message__c='';
        }
        if(selectOneOptionForBackText=='Custom') {
            customIdCard.Select_one_option_for_the_Back_Text_Mess__c='Include custom back messages?';
        }
        
        
        //SFDC-3064 Change how BAs are associated to Custom ID Card, Prospective and Suppression requests
        customIdCard.Applicable_BAs__c=baCaseNums;
        customIdCard.Applicable_GSs__c=gsCaseNums;
        
        //SFDC-6369 GEMS - ID Card Maintenance: ID Card Case Page Layout & Functionality
        if(ParentCase.GEMS_Submission_Type__c == GEMS_Constants.SubmissionTypeIDCardMaintenance) {
            if(String.isNotBlank(baCaseNums) && String.isNotBlank(gsCaseNums)) 
                customIdCard.Assignment_Type__c = GEMS_Constants.IDCardAssignTypeBoth;
            else if(String.isNotBlank(baCaseNums)) 
                customIdCard.Assignment_Type__c = GEMS_Constants.IDCardAssignTypeBA;
             else if(String.isNotBlank(gsCaseNums))  
                customIdCard.Assignment_Type__c = GEMS_Constants.IDCardAssignTypeGS;
             else 
                customIdCard.Assignment_Type__c = GEMS_Constants.IDCardAssignTypeNone;
            
        } else {
            customIdCard.Assignment_Type__c = assignmentType;
        }
        
        upsert customIdCard;
       
        if(customIdCard.id !=null){
            customIdCardId = customIdCard.id;
        }
        //SFDC-6369 GEMS - ID Card Maintenance: ID Card Case Page Layout & Functionality
        if(ParentCase.GEMS_Submission_Type__c != GEMS_Constants.SubmissionTypeIDCardMaintenance) {
            List<GEMS_Custom_ID_Request_Form__c> customIDCardOfParentIDCard = 
                [Select ID, Applicable_BAs__c, Applicable_GSs__c, assignment_type__c from GEMS_Custom_ID_Request_Form__c where Custom_ID_Request_Form_Case__c=:ParentCase.id];
            Map<Id, GEMS_Custom_ID_Request_Form__c> customIDMap = new Map<Id, GEMS_Custom_ID_Request_Form__c>();
            for(GEMS_Custom_ID_Request_Form__c cidForm : customIDCardOfParentIDCard) {
                customIDMap.put(cidForm.id,cidForm);
            }
            List<GEMS_IDCompare> idCompareList = GEMS_IDCardUtil.CopyCustomIDFormToIDCompare(customIDCardOfParentIDCard);
            GEMS_CustomFormInput customFormInput = new GEMS_CustomFormInput(customIdCardId,assignmentType,baCaseNums,gsCaseNums,idCompareList);
            List<GEMS_IDCompare> idcompareListUpdated = GEMS_IDCardUtil.updateExistingAssignments(customFormInput);
            List<GEMS_Custom_ID_Request_Form__c> custIdUpdateList = GEMS_IDCardUtil.copyIDCompareToCustomIDForm(idcompareListUpdated, customIDMap);
            update custIdUpdateList; 
        }
        return null;
    }
    
    public void dummy() {       
    }    
    
    
    public String removeBaFromForm(String formBas,String ba) {
        return '';
    }
    
    
    public PageReference gotoCase() {
        Id returnId;
        if(caseId!=null) {
            returnId=caseId;
        } else {
            returnId=ParentCase.Id;
        }
        return new PageReference('/'+returnId);
    }
    
    public String getAssignmentType() {
        return assignmentType;
    }
    
    public void setAssignmentType(String assignmentType) {
        this.assignmentType = assignmentType;
    }
}