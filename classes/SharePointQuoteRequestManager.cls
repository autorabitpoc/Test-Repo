/***********************************************************************************************************
* Apex Class Name     : SharePointQuoteRequestManager
* Version             : 1.0
* Function            : Submits SharePoint callouts to build the folder path for LGNA Quote Requests
* Modification Log    :
* Developer				Date			Description
* ----------------------------------------------------------------------------
* Zachary Campbell		12/22/17		SFDC-4784 - Initial version created 
***********************************************************************************************************/

public class SharePointQuoteRequestManager implements IQueueable, Database.AllowsCallouts {

    @TestVisible private CustomSettingDAO.ICustomSettingDAO customSettingDAOInstance {get; set;}
    @TestVisible private CustomMetadataTypeDAO.ICustomMetadataTypeDAO customMetadatTypeDAOInstance {get; set;}
    @TestVisible private OrganizationDAO.IOrganizationDAO organizationDAOInstance {get; set;}
    @TestVisible private SharePointCalloutUtility.ISharePointCalloutUtility sharePointcalloutUtilityInstance {get; set;}
    @TestVisible private SharePointConfiguration sharePointConfigurationInstance {get; set;}
    
    private String action;
    private List<Quote_Request_Summary__c> newQRs;
    
    public static final String APEX_CLASS = 'Apex Class';
    public static final String SOBJECT_TYPE = String.valueOf(Quote_Request_Summary__c.sObjectType);
    public static final String HIGH_PRIORITY = 'High';

    public SharePointQuoteRequestManager(List<Quote_Request_Summary__c> newQRs) { 
        this(newQRs, new CustomSettingDAO(), new CustomMetadataTypeDAO(),
             new OrganizationDAO(), new SharePointCalloutUtility(), new SharePointConfiguration());
    }

    @TestVisible private SharePointQuoteRequestManager(List<Quote_Request_Summary__c> newQRs,
                                                       CustomSettingDAO.ICustomSettingDAO customSettingDAOInstance,
                                                       CustomMetadataTypeDAO.ICustomMetadataTypeDAO customMetadatTypeDAOInstance,
                                                       OrganizationDAO.IOrganizationDAO organizationDAOInstance,
                                                       SharePointCalloutUtility.ISharePointCalloutUtility sharePointCalloutUtilityInstance,
                                                       SharePointConfiguration sharePointConfigurationInstance) {
                                                           
                                                           this.newQRs = newQRs;
                                                           this.customSettingDAOInstance = customSettingDAOInstance;
                                                           this.customMetadatTypeDAOInstance = customMetadatTypeDAOInstance;
                                                           this.organizationDAOInstance = organizationDAOInstance;
                                                           this.sharePointCalloutUtilityInstance = sharePointCalloutUtilityInstance;
                                                           this.sharePointConfigurationInstance = sharePointConfigurationInstance;
                                                       }
    
    public void setSObject(List<SObject> sObjects) {
        this.newQRs = (List<Quote_Request_Summary__c>) sObjects;
    }
    
    public void execute(QueueableContext context) {
        Map<String, Exception> exceptions = new Map <String, Exception>();
        String recDetails;
        //Map containing parent Opp info including account id and opp name
        
        Map<Id, Quote> quoMap = new Map<Id, Quote>();
        for (Quote quo : [Select Id, Name, AccountId, OpportunityId From Quote WHERE Id IN
                          (Select Quote_Name__c from Quote_Request_Summary__c WHERE Id IN :newQRs)]) {
                              quoMap.put(quo.Id, quo);
                          }
        
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        for (Opportunity opp : [Select Id, Name, AccountId From Opportunity WHERE Id IN
                                (Select OpportunityId from Quote WHERE Id IN :quoMap.keySet())]) {
                                    oppMap.put(opp.Id, opp);
                                }
        
        Map<Id, Account> accMap = new Map<Id, Account>();
        for (Account acc : [Select Id, Name, External_Id__c From Account WHERE Id IN
                            (Select AccountId from Quote WHERE Id IN :quoMap.keySet())]) {
                                accMap.put(acc.Id, acc);
                            }
        
        HttpResponse response;
        String oldFolderName;
        String newFolderName;
        String action;
        
        for (Quote_Request_Summary__c currQR : newQRs) {
            sharePointConfigurationInstance = new SharePointConfiguration('LGNAQuoteRq'); 
            sharePointCalloutUtilityInstance = new  SharePointCalloutUtility(sharePointConfigurationInstance);       
            
            Quote qrQuote = quoMap.get(currQR.Quote_Name__c);
            Opportunity qrOpp = oppMap.get(currQR.Opportunity_Id__c);
            Account qrAcc = accMap.get(currQR.Account_Id__c);             
            
			newFolderName = SharePointFolderBuilder.buildQuoteRqFolderPath(currQR.name, qrQuote.Name, qrOpp.Name, qrAcc.Name, qrAcc.External_Id__c);
			action = SharePointCalloutUtility.CREATE_FOLDER;
            
            system.debug('QR Quote Name = '+ qrQuote.Name);
            System.debug('SharePointQuoteRequestManager: ' + newFolderName);
            
            recDetails = qrQuote.Name + ' ' + currQR.Id + ' Folder: ' + newFolderName;
            
            if (!Test.isRunningTest()) {
                
                //Flags for determinig position in Folder build process
                Boolean AccountSegmentIsBuilt = false;
                Boolean OpportunitySegmentIsBuilt = false;
                Boolean QuoteSegmentIsBuilt = false;
                Boolean QuoteRequestSegmentIsBuilt = false;

				/*AccountSegment/OppSegment/QouteSeg/QRSegment*/
                
                response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout( action, newFolderName, oldFolderName, currQR);

				if((response.getStatusCode() == 401 && response.getBody().contains(sharePointConfigurationInstance.getTokenExpiredResponseText())) || response.getStatusCode() == 403){
					sharePointCalloutUtilityInstance.refreshAccessToken();  
                	response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout( action, newFolderName, oldFolderName, currQR);
                }                    
                    
                if(response.getStatusCode() == 201){
                    system.debug('ZC - Quote Request folder created successfully.');
                    
                }else if(response.getStatusCode() == 500){                
                    
                    /**** Account Segment *****/
                    try{
                        System.debug('ZC - Account Segment Try/Catch');
                        for(Integer A=0;A<2;A++){
                            System.debug('Account Segment Loop:' + A);
                            
                            /* Verify if Account Segment Exists */
                            //newfoldername = Year/AccountName
                            newFolderName = SharePointFolderBuilder.buildQuoteRqAcctFolderPath(qrAcc.Name, qrAcc.External_Id__c);
                            response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout( action, newFolderName, oldFolderName, currQR);
                            System.debug('ZC - Account Segment Loop Response:' + response.getStatusCode() + ' Loop: '+ A);
                            
                            // Pass - Segment Created Successfully 
                            if(response.getStatusCode() == 201){
                                //Set Flag
                                AccountSegmentIsBuilt = true;
                                //Break Loop
                                A=5;                            
                            }
                            
                            // Error - Segment Already Existed
                            if(response.getStatusCode() == 500){
                                //Set Flag
                                AccountSegmentIsBuilt = true;                                                        
                                //Break Loop
                                A=5;
                            }
                            
                            // Error - Expired Token
                            if((response.getStatusCode() == 401 && response.getBody().contains(sharePointConfigurationInstance.getTokenExpiredResponseText())) || response.getStatusCode() == 403){
								sharePointCalloutUtilityInstance.refreshAccessToken();   
                                AccountSegmentIsBuilt = false;                                                        
                            }
                        }                    
                    }catch(System.CalloutException e){
                        exceptions.put('SP Exception ' + recDetails, e);
                    }
                    catch(Exception e){
                        exceptions.put('SP Exception ' + recDetails, e);                    
                    }
                    
                    /* Opportunity Segment */
                    try{
                        System.debug('ZC - Opportunity Segment Try/Catch');
                        for(Integer O=0;O<2;O++){
                            System.debug('Opportunity Segment Loop:' + O);
                            
                            If (AccountSegmentIsBuilt == False){
                                //Account Segment Not Built - Break Loop
                                O = 5;
                                OpportunitySegmentIsBuilt = False;
                                Break;
                            }
                            
                            /* Verify if Opportunity Segment Exists */
                            //newfoldername = Year/AccountName/OpportunityName
                            newFolderName = SharePointFolderBuilder.buildQuoteRqOppFolderPath(qrOpp.Name, qrAcc.Name, qrAcc.External_Id__c);
                            response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout( action, newFolderName, oldFolderName, currQR);
                            System.debug('Opportunity Segment Loop Response:' + response.getStatusCode() + ' Loop: '+ O);
                            
                            //Pass - Segment Created Successfully 
                            if(response.getStatusCode() == 201){
                                //Set Flag
                                OpportunitySegmentIsBuilt = true;
                                //Break Loop
                                O=5;                            
                            }
                            
                            //Error - Segment Already Existed
                            if(response.getStatusCode() == 500){
                                //Set Flag
                                OpportunitySegmentIsBuilt = true;                                                        
                                //Break Loop
                                O=5;
                            }
                            
                            //Error - Expired Token
                            if((response.getStatusCode() == 401 && response.getBody().contains(sharePointConfigurationInstance.getTokenExpiredResponseText())) || response.getStatusCode() == 403){
                                sharePointCalloutUtilityInstance.refreshAccessToken();   
                                OpportunitySegmentIsBuilt = false;                                                        
                            }                        
                        }                    
                    }catch(System.CalloutException e){
                        exceptions.put('SP Exception ' + recDetails, e);
                    }
                    catch(Exception e){
                        exceptions.put('SP Exception ' + recDetails, e);                    
                    }
                    
                    /***** Quote Segment ******/
                    try{
                        System.debug('ZC - Quote Segment Try/Catch');
                        for(Integer Q=0;Q<2;Q++){
                            System.debug('Quote Segment Loop:' + Q);
                            
                            If (OpportunitySegmentIsBuilt == False){
                                //Quote Segment Not Built - Break Loop
                                Q = 5;
                                QuoteSegmentIsBuilt = False;
                                Break;
                            }
                            
                            /* Verify if Quote Segment Exists */
                            //newfoldername = Year/AccountName/OpportunityName/QuoteName
                            newFolderName = SharePointFolderBuilder.buildQuoteRqQuoteFolderPath(qrQuote.Name, qrOpp.Name, qrAcc.Name, qrAcc.External_Id__c);
                            response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout( action, newFolderName, oldFolderName, currQR);
                            System.debug('Quote Segment Loop Response:' + response.getStatusCode() + ' Loop: '+ Q);
                            
                            //Pass - Segment Created No Problems 
                            if(response.getStatusCode() == 201){
                                //Set Flag
                                QuoteSegmentIsBuilt = true;
                                //Break Loop
                                Q=5;                            
                            }
                            
                            //Error - Segment Already Existed
                            if(response.getStatusCode() == 000){
                                //Set Flag
                                QuoteSegmentIsBuilt = true;                                                        
                                //Break Loop
                                Q=5;
                            }
                            
                            //Error - Expired Token
                            if((response.getStatusCode() == 401 && response.getBody().contains(sharePointConfigurationInstance.getTokenExpiredResponseText())) || response.getStatusCode() == 403){
                                sharePointCalloutUtilityInstance.refreshAccessToken();   
                                QuoteSegmentIsBuilt = false;                                                        
                            }        
                        }                    
                    }catch(System.CalloutException e){
                        exceptions.put('SP Exception ' + recDetails, e);
                    }
                    catch(Exception e){
                        exceptions.put('SP Exception ' + recDetails, e);                    
                    }
                    
                    /* Quote Request Segment */
                    try{
                        System.debug('ZC - Quote Request Segment Try/Catch');
                        for(Integer QR=0;QR<2;QR++){
                            System.debug('Quote Request Segment Loop:' + QR);
                            
                            If (QuoteSegmentIsBuilt == False){
                                //Quote Request Segment Not Built - Break Loop
                                QR = 5;
                                QuoteRequestSegmentIsBuilt = False;
                                Break;
                            }
                            
                            /* Verify if Quote Request Segment Exists */                        
                            //newfoldername = Year/AccountName/OpportunityName/QuoteName/QuoteRequestName
                            newFolderName = SharePointFolderBuilder.buildQuoteRqFolderPath(currQR.Name, qrQuote.Name, qrOpp.Name, qrAcc.Name, qrAcc.External_Id__c);
                            response = (HttpResponse) sharePointCalloutUtilityInstance.sendCallout( action, newFolderName, oldFolderName, currQR);
                            System.debug('Quote Request Segment Loop Response:' + response.getStatusCode() + ' Loop: '+ QR);
                            system.debug('QR segment newfolder name = '+ newFolderName);
                            
                            //Pass - Segment Created Successfully 
                            if(response.getStatusCode() == 201){
                                //Set Flag
                                QuoteRequestSegmentIsBuilt = true;
                                //Break Loop
                                QR=5;                            
                            }
                            
                            //Error - Segment Already Existed
                            if(response.getStatusCode() == 500){
                                //Set Flag
                                QuoteRequestSegmentIsBuilt = true;                                                        
                                //Break Loop
                                QR=5;
                            }
                            
                            //Error - Expired Token
                            if((response.getStatusCode() == 401 && response.getBody().contains(sharePointConfigurationInstance.getTokenExpiredResponseText())) || response.getStatusCode() == 403){
                                sharePointCalloutUtilityInstance.refreshAccessToken();   
                                QuoteRequestSegmentIsBuilt = false;                                                        
                            }                                
                        }                    
                    }catch(System.CalloutException e){
                        exceptions.put('SP Exception ' + recDetails, e);
                    }
                    catch(Exception e){
                        exceptions.put('SP Exception ' + recDetails, e);                    
                    }
                }
            }
        }
        if ( !exceptions.isEmpty() ) {
            for ( String e : exceptions.keySet() ) {
                CreateExceptionLog.insertErrorLog(exceptions.get(e), null, null, null, APEX_CLASS, SOBJECT_TYPE,
                                                  e, SharePointCaseManager.class.getName() +
                                                  '.execute()', HIGH_PRIORITY);
            }
        }
    }
}