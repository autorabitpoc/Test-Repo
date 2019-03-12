/*****************************************************************************************************
* Apex Class Name     : ARCancelllationHelper
* Version             : 1.0
* Function            : This is callout class for Account, Group Section, Billing Profile, Category Cancellation.
* Modification Log    :
* Developer				Date			Description
* ----------------------------------------------------------------------------
* Padma Bedampeta     10/20/2017       Added code for Account Cancellation SFDC-5043
*                                      related apex classes LGNA_AccountCancellationCallout, LGNA_ARCancellationInput, LGNA_ARCancellationOutput, GEMS_AccountStructureStatusService
*                                      AccountCancellationClass, Laveraged existing GEMS framework by using apex classes- FW_Service, FW_Service_Helper, 
*                                      FW_Service_Interface, FW_Service_BASE, FW_ServiceIO_REST, FW_ServiceIO_Base, FW_ServiceIO_Interface . 
*                                      Custom Metadata Types - FW_Service_Headers__mdt, FW_Service_Settings__mdt
* Padma Bedamoeta     12/15/2017       Added code for Group Section, Billing Profile Cancellation
* Padma Bedampeta     01/19/2018       Added code for Category Cancellation
*------------------------------------------------------------------------------------------------------------------------------*/
Public class ARCancelllationHelper {
    Public static String sendAccountCancellation(Id accID){
        string result;
        system.debug('accID:::::::::'+accID);
        try{
            if(accID != null){
                Account  acc = [select id,Name,HCSC_Division__c,External_Id__c,Market_Segment__c,Cancellation_Status__c,
                                COBRA_Administration_Type__c,Requested_Cancellation_Date__c,Cancellation_Code__c, 
                                Effective_Date__c,Cancellation_Reason__c,AR_Cancellation_Flag__c
                                from Account where id =: accID];
                
                LGNA_ARCancellationInput input = new LGNA_ARCancellationInput();
                LGNA_ARCancellationInput.accountCanDetails accountCanDetails = new LGNA_ARCancellationInput.accountCanDetails();
                
                accountCanDetails.accountName = acc.Name.escapeXML();
                string accountNumber = acc.External_Id__c;                    
                if(accountNumber!= null){                    
                    if(accountNumber.length() > 6) {
                        accountNumber = accountNumber.substring(2, accountNumber.length());   
                    }
                    accountCanDetails.accountNumber = accountNumber;                    
                }
                accountCanDetails.effectiveDate = string.valueof(date.newinstance(acc.Effective_Date__c.year(), acc.Effective_Date__c.month(), acc.Effective_Date__c.day()));  
                System.debug('effectiveDate'+accountCanDetails.effectiveDate);
                
                accountCanDetails.marketSegment = acc.Market_Segment__c;
                System.debug('marketSegment'+accountCanDetails.marketSegment);
                String azId = String.valueOf(acc.Id).substring(0, 15);
                
                //String accountStructureCaseIDlValue = ARCancellationConstants__c.getValues('accountStructureCaseID').ARCancelRequiredField__c;
                accountCanDetails.accountStructureCaseID = azId;
                
                accountCanDetails.corpCode = acc.HCSC_Division__c + '1';
                System.debug('corpCode'+accountCanDetails.corpCode);
                
                String cobraAutoCancelValue = ARCancellationConstants__c.getValues('cobraAutoCancel').ARCancelRequiredField__c;
                System.debug('cobraAutoCancel:::::::::::'+cobraAutoCancelValue);
                accountCanDetails.cobraAutoCancel = cobraAutoCancelValue;
                
                accountCanDetails.cobraCode = acc.COBRA_Administration_Type__c;
                System.debug('cobraCode'+accountCanDetails.cobraCode);
                
                String autoCatIndValue = ARCancellationConstants__c.getValues('autoCatInd').ARCancelRequiredField__c;
                accountCanDetails.autoCatInd = autoCatIndValue;
                System.debug('autoCatInd'+accountCanDetails.autoCatInd);
                
                accountCanDetails.changereasoncode = ARCancellationConstants__c.getValues('changeReasonCode').ARCancelRequiredField__c;
                System.debug('changereasoncode'+ accountCanDetails.changereasoncode);
                
                accountCanDetails.sourceSystemCd = acc.AR_Cancellation_Flag__c;
                System.debug('sourceSystemCd'+ accountCanDetails.sourceSystemCd);
                
                accountCanDetails.cancellationEffDate = string.valueof(date.newinstance(acc.Requested_Cancellation_Date__c.year(), acc.Requested_Cancellation_Date__c.month(), acc.Requested_Cancellation_Date__c.day()));  
                System.debug('cancellationEffDate'+ acc.Requested_Cancellation_Date__c);
                
                accountCanDetails.cancellationCode = (ARCancelMapReasonCode__c.getValues(acc.Cancellation_Reason__c).BlueStar_Cancel_Code__c);
                system.debug('Input::::::::::::'+input);
                
                input.accountCanDetails = accountCanDetails;
                
                System.debug('acc.AR_Cancellation_Flag__c ::::::'+acc.AR_Cancellation_Flag__c);
                if(acc.AR_Cancellation_Flag__c != NULL && acc.AR_Cancellation_Flag__c !='' && acc.AR_Cancellation_Flag__c=='ARCAN'){
                    FW_Service s = new FW_Service('LGNA_AR_Cancellation');   
                    system.debug('FW_Service::::::::::::');
                    LGNA_ARCancellationOutput output = (LGNA_ARCancellationOutput) s.callout(input);
                    system.debug('output::::::::::::'+output);
                    
                    if(output.status == 'S'){            
                        acc.Integration_Status__c = 'Sent';
                        String Canceldate = Date.today().format();
                        system.debug('Canceldate::::::::::'+Canceldate);
                        acc.Cancellation_Submitted_Date__c = date.parse(Canceldate);
                        system.debug('acc.Cancellation_Date__c::::::::::'+acc.Cancellation_Date__c);
                        result = 'Account Cancellation Request has been sent to BlueSTAR successfully.';
                    }
                    else if(output.status == 'I'){
                        acc.Integration_Status__c = 'Failure'; 
                        result = 'System failed to send Account Cancellation Request to BlueSTAR.';
                        String Canceldate = Date.today().format();
                        system.debug('Canceldate::::::::::'+Canceldate);
                        acc.Cancellation_Submitted_Date__c = date.parse(Canceldate);
                        system.debug('acc.Cancellation_Date__c::::::::::'+acc.Cancellation_Date__c);
                    }                      
                    else{
                        acc.Integration_Status__c = 'Failure';
                        String Canceldate = Date.today().format();
                        system.debug('Canceldate::::::::::'+Canceldate);
                        acc.Cancellation_Submitted_Date__c = date.parse(Canceldate);
                        result = output.message;
                        if(result == null)
                            result = 'BlueSTAR failed to send Account Cancellation Request to BlueSTAR. Please contact System Admin.';
                        //accountStructureCase.GEMS_Integration_Message__c = output.message;                                              
                    }
                    String Canceldate = Date.today().format();
                    system.debug('Canceldate::::::::::'+Canceldate);
                    acc.Cancellation_Submitted_Date__c = date.parse(Canceldate);
                    acc.Integration_Message__c = result;
                    //if (ConstantsController.canMakeFutureCalls) {
                    system.debug('acc::::::::::::'+acc);
                    acc.AR_Cancellation_Flag__c = NULL;
                    update acc;
                    // }
                }
            }
            
        }
        catch(exception e){
            system.debug('exception'+e);
        }
        return result;
    }  
    //************ Group Section, Billing Profile, Category Cancellation Start ************//    
    Public static String sendLGNAAccountStructureCancellation(Id CaseId){
        string result;
        string cancelDate = Date.today().format();
        Account acc = new Account();
        try{
            if(CaseId != null){
                /* Account  acc = [select id,Name,HCSC_Division__c,External_Id__c,Market_Segment__c,Cancellation_Status__c,
COBRA_Administration_Type__c,Requested_Cancellation_Date__c,Cancellation_Code__c, 
Effective_Date__c,Cancellation_Reason__c,(Select id,GEMS_Integration_Status__c,GEMS_Integration_Message__c	
from Cases where id =: CaseId)
from Account where id =: accID];*/
                CASE accountStructureCancelCase = [SELECT 
                                                   Account.Id, Account.Name, Account.External_Id__c, Account.COBRA_Administration_Type__c, 
                                                   Account.HCSC_Division__c, Account.Market_Segment__c,Account.Effective_Date__c,
                                                   Id,RecordtypeId,Account.AR_Cancellation_Flag__c,AR_Cancellation_Flag__c,                                                 
                                                   GEMS_Integration_Status__c, GEMS_Integration_Message__c, GEMS_Integration_Request_Time__c, GEMS_Integration_Response_Time__c,
                                                   GEMS_Failed_Account_Message__c, GEMS_Failed_Categories__c, GEMS_Failed_Group_Sections__c,
                                                   Status                           
                                                   FROM CASE WHERE Id = : CaseId];
                //acc = [select id,AR_Cancellation_Flag__c from Account where id=:accountStructureCancelCase.Account.id];
                //SFDC-7839 check case recordtype: Process cancellation only for Account cancellation Record type.
                Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Account Cancellation').getRecordTypeId();
                if(accountStructureCancelCase.RecordTypeId == caseRecordTypeId){
                    LGNA_ARCancellationInput input = new LGNA_ARCancellationInput();
                    LGNA_ARCancellationInput.accountCanDetails accountCanDetails = new LGNA_ARCancellationInput.accountCanDetails();
                    
                    accountCanDetails.accountName = accountStructureCancelCase.Account.Name.escapeXML();
                    string accountNumber = accountStructureCancelCase.Account.External_Id__c;                    
                    if(accountNumber!= null){                    
                        if(accountNumber.length() > 6) {
                            accountNumber = accountNumber.substring(2, accountNumber.length());   
                        }
                        accountCanDetails.accountNumber = accountNumber;                    
                    }
                    accountCanDetails.effectiveDate = string.valueof(date.newinstance(accountStructureCancelCase.Account.Effective_Date__c.year(), accountStructureCancelCase.Account.Effective_Date__c.month(), accountStructureCancelCase.Account.Effective_Date__c.day()));  
                    System.debug('effectiveDate'+accountCanDetails.effectiveDate);
                    String acc1 = accountStructureCancelCase.Account.Market_Segment__c;
                    accountCanDetails.marketSegment = accountStructureCancelCase.Account.Market_Segment__c;
                    System.debug('marketSegment'+acc1);
                    String AccountCanCaseId = String.valueOf(CaseId).substring(0, 15);
                    System.debug('AccountCanCaseId'+AccountCanCaseId);
                    //String accountStructureCaseIDlValue = ARCancellationConstants__c.getValues('accountStructureCaseID').ARCancelRequiredField__c;
                    accountCanDetails.accountStructureCaseID = AccountCanCaseId;
                    
                    accountCanDetails.corpCode = accountStructureCancelCase.Account.HCSC_Division__c + '1';
                    System.debug('corpCode'+accountCanDetails.corpCode);
                    
                    String cobraAutoCancelValue = ARCancellationConstants__c.getValues('cobraAutoCancel').ARCancelRequiredField__c;
                    System.debug('cobraAutoCancel:::::::::::'+cobraAutoCancelValue);
                    accountCanDetails.cobraAutoCancel = cobraAutoCancelValue;
                    
                    accountCanDetails.cobraCode = accountStructureCancelCase.Account.COBRA_Administration_Type__c;
                    System.debug('cobraCode'+accountCanDetails.cobraCode);
                    
                    String autoCatIndValue = ARCancellationConstants__c.getValues('autoCatInd').ARCancelRequiredField__c;
                    accountCanDetails.autoCatInd = autoCatIndValue;
                    System.debug('autoCatInd'+accountCanDetails.autoCatInd);
                    
                    accountCanDetails.sourceSystemCd = accountStructureCancelCase.AR_Cancellation_Flag__c;
                    System.debug('sourceSystemCd'+ accountCanDetails.sourceSystemCd);
                    
                    input.accountCanDetails = accountCanDetails;
                    system.debug('accountCanDetails::::::::::::'+accountCanDetails);
                    
                    //***   Group Section Cancellation start ***//
                    list<GEMS_Group_Section__c> grpsecnlst = [SELECT Group_No__c, Section_No__c, Cancellation_Code__c, Section_Description__c,Requested_Cancellation_Date__c,
                                                              Cancellation_Date__c, Cancellation_Status__c, Cancellation_Reason__c, Cancellation_Explanation__c,
                                                              (SELECT Benefit_Agreement__r.Name
                                                               FROM GS_Assignments__r
                                                               WHERE Benefit_Agreement__r.IsCancelled__c = false),
                                                              (SELECT Category__r.Name
                                                               FROM Category_Assignments__r
                                                               WHERE Category__r.IsCancelled__c = false)
                                                              FROM GEMS_Group_Section__c
                                                              WHERE Account__c =:accountStructureCancelCase.Account.Id AND 
                                                              Case__c =: CaseId AND
                                                              Cancellation_Status__c = 'Requested Cancellation' AND
                                                              Requested_Cancellation_Date__c != NULL AND
                                                              Cancellation_Reason__c  != NULL                                                                                                     
                                                             ];  
                    system.debug('grpsecnlst::::::::::::'+grpsecnlst);
                    if(grpsecnlst!=null){
                        list<LGNA_ARCancellationInput.GroupSection> groupSections = new list<LGNA_ARCancellationInput.GroupSection>();
                        for(GEMS_Group_Section__c gs : grpsecnlst){
                            LGNA_ARCancellationInput.GroupSection groupSection = new LGNA_ARCancellationInput.GroupSection();
                            groupSection.groupNumber = gs.Group_No__c;
                            system.debug('gs.Group_No__c::::::::::::'+gs.Group_No__c); 
                            
                            groupSection.sectionNumber = gs.Section_No__c;
                            system.debug('gs.Section_No__c::::::::::::'+gs.Section_No__c); 
                            
                            groupSection.sectionDescription = gs.Section_Description__c;
                            system.debug('gs.Section_Description__c::::::::::::'+gs.Section_Description__c); 
                            
                            if(groupSection.sectionDescription != null)
                                groupSection.sectionDescription = groupSection.sectionDescription.escapeXML();
                            system.debug('groupSection.sectionDescription::::::::::::'+groupSection.sectionDescription); 
                            
                            groupSection.changeReasonCode = ARCancellationConstants__c.getValues('changeReasonCode').ARCancelRequiredField__c;
                            
                            groupSection.cancellationEffDate = string.valueof(date.newinstance(gs.Requested_Cancellation_Date__c.year(), gs.Requested_Cancellation_Date__c.month(), gs.Requested_Cancellation_Date__c.day()));
                            //string.valueof(date.newinstance(gs.Cancellation_Date__c.year(), gs.Cancellation_Date__c.month(), gs.Cancellation_Date__c.day()));
                            system.debug('groupSection.cancellationEffDate::::::::::::'+groupSection.cancellationEffDate);
                            
                            //(ARCancelMapReasonCode__c.getValues(gs.Cancellation_Reason__c).Grp_Section_Bluestar_Code__c)
                            groupSection.cancellationCode = (ARCancelMapReasonCode__c.getValues(gs.Cancellation_Reason__c).Grp_Section_Bluestar_Code__c);
                            system.debug('gs.Cancellation_Reason__c::::::::::::'+gs.Cancellation_Reason__c);
                            
                            groupSection.assignedBANumbers = new list<string>();
                            set<string> assignedBANumbers = new set<string>();
                            if(!gs.GS_Assignments__r.IsEmpty()){
                                for(GEMS_BA_Assignment__c b : gs.GS_Assignments__r){
                                    if(!assignedBANumbers.contains(b.Benefit_Agreement__r.Name)){
                                        assignedBANumbers.add(b.Benefit_Agreement__r.Name);                                   
                                    }
                                }
                            }
                            else{
                                continue;
                            }
                            groupSection.assignedBANumbers.addAll(assignedBANumbers);
                            groupSection.assignedCategoryNumbers = new list<string>();
                            set<string> assignedCategoryNumbers = new set<string>();
                            /* if(catUsages == null || (catUsages != null && catUsages.size() < 4))
groupSection.assignedCategoryNumbers.add('0000');*/
                            if(!gs.Category_Assignments__r.IsEmpty()) {
                                for(GEMS_Category_Assignment__c c : gs.Category_Assignments__r) {
                                    if(!assignedCategoryNumbers.contains(c.Category__r.Name)){
                                        assignedCategoryNumbers.add(c.Category__r.Name);
                                    }  
                                }
                            }
                            else{
                                continue;
                            }
                            groupSection.assignedCategoryNumbers.addAll(assignedCategoryNumbers);
                            groupSections.add(groupSection);
                            
                        }
                        
                        input.groupSections = groupSections;
                        system.debug('groupSections::::::::::::'+groupSections);
                    }
                    //*** End Group Section Cancellation ***//
                    
                    //***  start Billing Profile Cancellation  ***//
                    list<GEMS_Billing_Profile__c> bps = [SELECT Billing_Profile_Number__c, Name, Billing_Address__r.Address_Sequence__c,Billing_Address__c,
                                                         Requested_Cancellation_Date__c, Cancellation_Status__c, Cancellation_Reason__c, Cancellation_Submitted_Date__c,
                                                         (SELECT Benefit_Agreement__r.Name
                                                          FROM BP_Associations__r
                                                          WHERE Benefit_Agreement__r.IsCancelled__c = false ),
                                                         (SELECT Category__r.Name
                                                          FROM BA_BP_Associations__r
                                                          WHERE Category__r.IsCancelled__c = false)
                                                         FROM GEMS_Billing_Profile__c
                                                         WHERE Account__c =:accountStructureCancelCase.Account.Id AND                                                      
                                                         Case__c =: accountStructureCancelCase.Id AND
                                                         Cancellation_Status__c = 'Requested Cancellation' AND
                                                         Requested_Cancellation_Date__c != NULL AND
                                                         Cancellation_Reason__c  != NULL           
                                                        ];
                    system.debug('Billing Profiles list::::::::::::'+bps);
                    if(bps!=null){
                        list<LGNA_ARCancellationInput.BillingProfile> billingProfiles = new list<LGNA_ARCancellationInput.BillingProfile>();
                        for(GEMS_Billing_Profile__c bp : bps){
                            LGNA_ARCancellationInput.BillingProfile billingProfile = new LGNA_ARCancellationInput.BillingProfile();
                            system.debug('Billing Profile ::::::::::::'+billingProfile);
                            
                            billingProfile.billingProfileNumber = bp.Billing_Profile_Number__c;
                            system.debug(' billingProfile.billingProfileNumber::::::::::::'+bp.Billing_Profile_Number__c);
                            
                            billingProfile.description = bp.Name;
                            system.debug('billingProfile.description::::::::::::'+bp.Name);
                            
                            if(billingProfile.description != null)
                                billingProfile.description = billingProfile.description.escapeXML();
                            
                            if(bp.Billing_Address__c != null && bp.Billing_Address__r.Address_Sequence__c != null &&  bp.Billing_Address__r.Address_Sequence__c.contains('-')){
                                billingProfile.billingAddressSequence = bp.Billing_Address__r.Address_Sequence__c.substringAfterLast('-'); 
                                system.debug('billingProfile.billingAddressSequence::::::::::::'+billingProfile.billingAddressSequence);
                            }
                            else
                                continue;
                            billingProfile.changeReasonCode = ARCancellationConstants__c.getValues('changeReasonCode').ARCancelRequiredField__c;
                            
                            billingProfile.cancellationEffDate = string.valueof(date.newinstance(bp.Requested_Cancellation_Date__c.year(), bp.Requested_Cancellation_Date__c.month(), bp.Requested_Cancellation_Date__c.day()));
                            system.debug('billingProfile.cancellationEffDate ::::::::::::'+billingProfile.cancellationEffDate);
                            
                            billingProfile.cancellationCode = (ARCancelMapReasonCode__c.getValues(bp.Cancellation_Reason__c).BP_BlueStar_Code__c);
                            system.debug('billingProfile.cancellationCode ::::::::::::'+billingProfile.cancellationCode);
                            
                            billingProfile.baNumbers = new list<string>();
                            set<string> baNumbers = new set<string>();
                            if(!bp.BP_Associations__r.IsEmpty()){
                                for(GEMS_BP_BA_Association__c b : bp.BP_Associations__r){
                                    if(!baNumbers.contains(b.Benefit_Agreement__r.Name)){
                                        baNumbers.add(b.Benefit_Agreement__r.Name);
                                    }
                                }
                                system.debug('bp.BP_Associations__r ::::::::::::'+baNumbers);
                            }
                            else{
                                continue;
                            }
                            billingProfile.baNumbers.addAll(baNumbers);
                            billingProfile.categoryNumbers = new list<string>();
                            set<string> categoryNumbers = new set<string>();
                            if(!bp.BA_BP_Associations__r.IsEmpty()){
                                for(GEMS_BP_Category_Association__c c : bp.BA_BP_Associations__r){
                                    if(!categoryNumbers.contains(c.Category__r.Name)){
                                        categoryNumbers.add(c.Category__r.Name);
                                    }
                                }
                                system.debug('bp.BA_BP_Associations__r ::::::::::::'+categoryNumbers); 
                            } else{
                                continue;
                            }
                            billingProfile.categoryNumbers.addAll(categoryNumbers);
                            system.debug('bp.BA_BP_Associations__r ::::::::::::'+categoryNumbers);
                            billingProfiles.add(billingProfile);
                        }
                        input.billingProfiles = billingProfiles;
                        system.debug('billingProfiles:::::::'+billingProfiles);
                    }
                    //***  END Billing Profile Cancellation  ***//
                    
                    //***  Start Category Cancellation  ***//
                    list<GEMS_Category__c> cats = [SELECT Id, Name, Category_Description__c, Category_Cobra_Code__c,
                                                   Usage_Billing__c, Usage_Mailing__c, Usage_Product__c, Usage_Reporting__c,
                                                   Cancellation_Date__c,Cancellation_Explanation__c, 
                                                   Cancellation_Reason__c,Cancellation_Status__c,Cancellation_Submitted_Date__c,
                                                   Requested_Cancellation_Date__c
                                                   FROM GEMS_Category__c
                                                   WHERE Case__r.Id = : accountStructureCancelCase.Id AND
                                                   // (Case__r.Status = 'In Progress' OR Case__r.Status = 'Approved') AND
                                                   Cancellation_Status__c = 'Requested Cancellation' AND
                                                   Requested_Cancellation_Date__c != NULL AND
                                                   Cancellation_Reason__c  != NULL ];
                    system.debug('Categories to Cancel :::::::::::'+cats);
                    If(cats != NULL){
                        list<LGNA_ARCancellationInput.Category> categories = new list<LGNA_ARCancellationInput.Category>();
                        for(GEMS_Category__c cat : cats){
                            LGNA_ARCancellationInput.Category category = new LGNA_ARCancellationInput.Category();
                            category.categoryNumber = cat.Name;
                            system.debug('category Number:::::::::'+cat.Name);
                            category.categoryDescription = cat.Category_Description__c;
                            system.debug('category Description:::::::::'+cat.Category_Description__c);
                            if(category.categoryDescription != null){
                                category.categoryDescription = category.categoryDescription.escapeXML();
                                system.debug('category Description:::::::::'+category.categoryDescription);   
                            }                            
                            if(cat.Category_Cobra_Code__c != null){
                                category.categoryCobraCode = cat.Category_Cobra_Code__c;
                                system.debug('category CobraCode:::::::::'+category.categoryCobraCode);  
                            }                        
                            category.changeReasonCode = ARCancellationConstants__c.getValues('changeReasonCode').ARCancelRequiredField__c;
                            system.debug('category changeReasonCode:::::::::'+category.changeReasonCode);  
                            category.cancellationEffDate = string.valueof(date.newinstance(cat.Requested_Cancellation_Date__c.year(), cat.Requested_Cancellation_Date__c.month(), cat.Requested_Cancellation_Date__c.day()));
                            system.debug('category cancellationEffDate:::::::::'+category.cancellationEffDate);  
                            category.cancellationCode = (ARCancelMapReasonCode__c.getValues(cat.Cancellation_Reason__c).Cat_BlueStar_Code__c);//should change after category reason codes are confirmed from Business
                            system.debug('category cancellationCode:::::::::'+category.cancellationCode);  
                            category.productIndicator = cat.Usage_Product__c == true ? 'Y': 'N';
                            category.billingIndicator = cat.Usage_Billing__c == true ? 'Y': 'N';
                            category.reportingIndicator = cat.Usage_Reporting__c == true ? 'Y': 'N';
                            category.mailIndicator = cat.Usage_Mailing__c == true ? 'Y': 'N';
                            categories.add(category);
                        }
                        input.categories = categories;
                    }
                    //***  END Category Cancellation  ***//
                    
                    //Calling FW_Service apex class by passing Custom metadata type FW_Service_Settings__mdt record Name for Account Receivable Cancellation Process SFDC-7454
                    
                    if(accountStructureCancelCase.AR_Cancellation_Flag__c!='' && accountStructureCancelCase.AR_Cancellation_Flag__c!=NULL && 
                       accountStructureCancelCase.AR_Cancellation_Flag__c == 'ARCAN'){
                           FW_Service s = new FW_Service('LGNA_AR_Cancellation');   
                           system.debug('FW_Service::::::::::::');      
                           LGNA_ARCancellationOutput output = (LGNA_ARCancellationOutput) s.callout(input);
                           system.debug('output::::::::::::'+output);
                           if(output.status == 'S'){
                               // Updating Selected Group Sections after hand shake response from B* SFDC-7454 Start
                               if(grpsecnlst != NULL){
                                   for(GEMS_Group_Section__c gs : grpsecnlst){
                                       system.debug('output S::::::::::::'+output);
                                       gs.Cancellation_Status__c = 'Submitted';
                                       gs.Cancellation_Submitted_Date__c = date.parse(Canceldate);                            
                                   }
                                   //  accountStructureCancelCase.GEMS_Integration_Status__c = 'Sent';
                                   //  accountStructureCancelCase.GEMS_Integration_Message__c = 'Cancellation Request has been sent to BlueSTAR successfully.';
                                   //  accountStructureCancelCase.Status = 'Submitted';
                                   Update grpsecnlst;
                                   //  Update accountStructureCancelCase;
                                   system.debug('output::::::::::::'+output); 
                                   system.debug('Result::::::::::::'+Result); 
                               }  
                               // Updating Selected Group Sections after hand shake response from B* SFDC-7454 End
                               // Updating Selected Billing Profiles after hand shake response from B* SFDC-7454 Start
                               if(bps != NULL){
                                   for(GEMS_Billing_Profile__c bp : bps){
                                       system.debug('output S::::::::::::'+output);
                                       bp.Cancellation_Status__c = 'Submitted';
                                       bp.Cancellation_Submitted_Date__c = date.parse(Canceldate); 
                                   }
                                   //  accountStructureCancelCase.GEMS_Integration_Status__c = 'Sent';
                                   //  accountStructureCancelCase.GEMS_Integration_Message__c = 'Cancellation Request has been sent to BlueSTAR successfully.';
                                   //  accountStructureCancelCase.Status = 'Submitted';
                                   Update bps;
                                   // Update accountStructureCancelCase;
                                   system.debug('output::::::::::::'+output);
                                   system.debug('Result::::::::::::'+Result); 
                               } 
                               // Updating Selected Billing Profiles after hand shake response from B* SFDC-7454 End
                               // Updating Selected Categories after hand shake response from B* SFDC-7839 start
                               if(cats != NULL){
                                   for(GEMS_Category__c ct : cats){
                                       system.debug('output S::::::::::::'+output);
                                       ct.Cancellation_Status__c = 'Submitted';
                                       ct.Cancellation_Submitted_Date__c = date.parse(Canceldate); 
                                   }
                                   //  accountStructureCancelCase.GEMS_Integration_Status__c = 'Sent';
                                   //  accountStructureCancelCase.GEMS_Integration_Message__c = 'Cancellation Request has been sent to BlueSTAR successfully.';
                                   //  accountStructureCancelCase.Status = 'Submitted';
                                   Update cats;
                                   //  Update accountStructureCancelCase;
                                   system.debug('output::::::::::::'+output);
                                   system.debug('Result::::::::::::'+Result); 
                               } 
                               // Updating Selected Categories after hand shake response from B* SFDC-7839 End
                               accountStructureCancelCase.GEMS_Integration_Status__c = 'Sent';
                               accountStructureCancelCase.GEMS_Integration_Message__c = 'Cancellation Request has been sent to BlueSTAR successfully.';
                               accountStructureCancelCase.Status = 'Submitted';
                               accountStructureCancelCase.AR_Cancellation_Flag__c = NULL;
                               try{
                                   //Update acc;
                                   Update accountStructureCancelCase;
                               }Catch(system.dmlexception e){
                                   system.debug('DML Expception:::'+e);
                               }
                           }
                           else if(output.status == 'I'){
                               system.debug('output I::::::::::::'+output);
                               // Updating Selected Group Sections after hand shake response from B* SFDC-7454 Start
                               if(grpsecnlst != NULL){
                                   for(GEMS_Group_Section__c gs : grpsecnlst){
                                       system.debug('output S::::::::::::'+output);
                                       gs.Cancellation_Status__c = '';
                                       // gs.Cancellation_Submitted_Date__c = date.parse(Canceldate);                            
                                   }
                                   // accountStructureCancelCase.GEMS_Integration_Status__c = 'Fail';
                                   // accountStructureCancelCase.GEMS_Integration_Message__c = 'Account Structure details retrieved successfully from BlueSTAR';
                                   //  accountStructureCancelCase.Status = 'In Progress';
                                   
                                   Update grpsecnlst;
                                   // Update accountStructureCancelCase;
                                   system.debug('output::::::::::::'+output);
                                   system.debug('Result::::::::::::'+Result); 
                               }
                               // Updating Selected Group Sections after hand shake response from B* SFDC-7454 End
                               // Updating Selected Billing Profiles after hand shake response from B* SFDC-7454 Start
                               if(bps != NULL){
                                   for(GEMS_Billing_Profile__c bp : bps){
                                       system.debug('output I::::::::::::'+output);
                                       bp.Cancellation_Status__c = '';
                                       // bp.Cancellation_Submitted_Date__c = date.parse(Canceldate); 
                                   }
                                   // accountStructureCancelCase.GEMS_Integration_Status__c = 'Fail';
                                   // accountStructureCancelCase.GEMS_Integration_Message__c = 'Account Structure details retrieved successfully from BlueSTAR';
                                   // accountStructureCancelCase.Status = 'In Progress';
                                   
                                   Update bps;
                                   // Update accountStructureCancelCase;
                                   system.debug('output::::::::::::'+output);
                                   system.debug('Result::::::::::::'+Result); 
                               }
                               // Updating Selected Billing Profiles after hand shake response from B* SFDC-7454 End
                               // Updating Selected Categories after hand shake response from B* SFDC-7839 start
                               if(cats != NULL){
                                   for(GEMS_Category__c ct : cats){
                                       system.debug('output I::::::::::::'+output);
                                       ct.Cancellation_Status__c = '';
                                       //  ct.Cancellation_Submitted_Date__c = date.parse(Canceldate); 
                                   }
                                   //  accountStructureCancelCase.GEMS_Integration_Status__c = 'Fail';
                                   //  accountStructureCancelCase.GEMS_Integration_Message__c = 'Account Structure details retrieved successfully from BlueSTAR';
                                   //accountStructureCancelCase.Status = 'Submitted';
                                   Update cats;
                                   // Update accountStructureCancelCase;
                                   system.debug('output::::::::::::'+output);
                                   system.debug('Result::::::::::::'+Result); 
                               }
                               // Updating Selected Categories after hand shake response from B* SFDC-7839 End
                               accountStructureCancelCase.AR_Cancellation_Flag__c = NULL;
                               accountStructureCancelCase.GEMS_Integration_Status__c = 'Fail';
                               accountStructureCancelCase.GEMS_Integration_Message__c = 'Account Structure details retrieved successfully from BlueSTAR';
                               try{
                                   // Update acc;
                                   Update accountStructureCancelCase;
                               }Catch(system.dmlexception e){
                                   system.debug('Fail DML Expception:::'+e);
                               }
                           }
                           else{
                               // Updating Selected Group Sections after hand shake response from B* SFDC-7454 Start
                               if(grpsecnlst != NULL){
                                   for(GEMS_Group_Section__c gs : grpsecnlst){
                                       system.debug('output ::::::::::::'+output);
                                       gs.Cancellation_Status__c = '';
                                       // gs.Cancellation_Submitted_Date__c = date.parse(Canceldate);                            
                                   }
                                   // accountStructureCancelCase.GEMS_Integration_Status__c = 'Fail';
                                   //  accountStructureCancelCase.GEMS_Integration_Message__c = 'Account Structure details retrieved successfully from BlueSTAR';
                                   // accountStructureCancelCase.Status = 'Submitted';
                                   Update grpsecnlst;
                                   // Update accountStructureCancelCase;
                                   system.debug('output::::::::::::'+output);
                                   system.debug('Result::::::::::::'+Result); 
                               }
                               // Updating Selected Group Sections after hand shake response from B* SFDC-7454 End
                               // Updating Selected Billing Profiles after hand shake response from B* SFDC-7454 Start
                               if(bps != NULL){
                                   for(GEMS_Billing_Profile__c bp : bps){
                                       system.debug('output ::::::::::::'+output);
                                       bp.Cancellation_Status__c = '';
                                       // bp.Cancellation_Submitted_Date__c = date.parse(Canceldate); 
                                   }
                                   // accountStructureCancelCase.GEMS_Integration_Status__c = 'Fail';
                                   // accountStructureCancelCase.GEMS_Integration_Message__c = 'Account Structure details retrieved successfully from BlueSTAR';
                                   //  accountStructureCancelCase.Status = 'In Progress';
                                   Update bps;
                                   // Update accountStructureCancelCase;
                                   system.debug('output::::::::::::'+output);
                                   system.debug('Result::::::::::::'+Result); 
                               }
                               // Updating Selected Billing Profiles after hand shake response from B* SFDC-7454 End
                               // Updating Selected Categories after hand shake response from B* SFDC-7839 start
                               if(cats != NULL){
                                   for(GEMS_Category__c ct : cats){
                                       system.debug('output ::::::::::::'+output);
                                       ct.Cancellation_Status__c = '';
                                       //  ct.Cancellation_Submitted_Date__c = date.parse(Canceldate); 
                                   }
                                   // accountStructureCancelCase.GEMS_Integration_Status__c = 'Fail';
                                   // accountStructureCancelCase.GEMS_Integration_Message__c = 'Account Structure details retrieved successfully from BlueSTAR';
                                   //accountStructureCancelCase.Status = 'Submitted';
                                   
                                   Update cats;
                                   // Update accountStructureCancelCase;
                                   system.debug('output::::::::::::'+output);
                                   system.debug('Result::::::::::::'+Result); 
                               } 
                               // Updating Selected Categories after hand shake response from B* SFDC-7839 End
                               system.debug('output else::::::::::::'+output);
                               accountStructureCancelCase.AR_Cancellation_Flag__c = NULL;
                               accountStructureCancelCase.GEMS_Integration_Status__c = 'Fail';
                               accountStructureCancelCase.GEMS_Integration_Message__c = 'Account Structure details retrieved successfully from BlueSTAR';
                           }
                           
                           try{
                               // Update acc;
                               Update accountStructureCancelCase;
                           }Catch(system.dmlexception e){
                               system.debug('Else Fail DML Expception:::'+e);
                           }
                       }
                }
            }
        }
        Catch(exception e){
            system.debug('exception'+e);  
        }
        return result;
    }
    
    
    
    @InvocableMethod
    public static void sendAccountCancellation(List<Id> accountIds)
    {
        sendAccountCancellationInFuture(accountIds);
        system.debug('sendAccountCancellation::::::::::::::::');
    }
    
    @future (callout=true)
    public static void sendAccountCancellationInFuture(List<Id> accountIds){
        for(id accId : accountIds){
            string result = sendAccountCancellation(accId);
        }
        system.debug('sendAccountCancellationInFuture::::::::::::::::');
    }
    //************ This Method called from Case trigger based on Account Cancellation Case status change ************//
    @future (callout=true)
    // public static void sendLGNAAccountStructureCancellation(List<Id> accountIds, List<Id> CaseIds){
    public static void sendLGNAAccountStructureCancellation(List<Id> CaseIds){
        // id accId;
        //  accId = accountIds[0];
        for(id CaseId : CaseIds){
            
            string result = sendLGNAAccountStructureCancellation(CaseId);
            system.debug('sendAccountCancellationInFuture::::::::::::::::'+result);
        }
        system.debug('sendAccountCancellationInFuture::::::::::::::::');
    }
    
}