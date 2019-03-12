/**
** Apex Class Name: LGNA_NewRequestHubItemController
** Version: 05/2018
** Description: This Controller is used with the LGNA_NewRHItemTotals Lightning Component
** 
***  Modification Log
**   Developer                        Date                 Description
**-----------------------------------------------------------------------------
**  Shuyler, Nathan                 05/2018                Initial Version
***********************************************************************************************************************/

public with sharing class LGNA_NewRHItemTotalsController {
        
    public class A { 
        String str;        
        public A(String s) { str = s; }
    }
    
    @AuraEnabled 
    public static string fetchItemTotals(String itemName, String theObjectID, String theObject){
        
        system.debug('fetchItemTotals: itemName: '+ itemName + 'theObjectID: '+theObjectID+' theObject: '+theObject);        
               
        String returnJSONString = theJSONGenerateMethod(itemname,0,0);        
        String methodString = '';
        
        if(String.isBlank(theObjectID)){
            //return the default JSON 
            returnJSONString = returnJSONString;            
        }else{
            //Continue with the Logic
            Id theID = Id.valueOf(theObjectID);
            
            if(itemName == 'Account_Maintenance'){
                methodString = getAccountMaintenanceTotals(theID,itemName,theObject); 
                if(String.isNotBlank(methodString)){
                    returnJSONString = methodString;
                }
            }
            
            if(itemName == 'CBSR'){
                methodString = getCustomBenefitServiceTotals(theID,itemName,theObject); 
                if(String.isNotBlank(methodString)){
                    returnJSONString = methodString;
                }
            }
            
            if(itemName == 'Cede'){
                methodString = getCedeTotals(theID,itemName,theObject); 
                if(String.isNotBlank(methodString)){
                    returnJSONString = methodString;
                }
            }            
            
            if(itemName == 'Contract_Admin'){
                methodString = getContractAdminTotals(theID,itemName,theObject); 
                if(String.isNotBlank(methodString)){
                    returnJSONString = methodString;
                }
            }  
            
             if(itemName == 'Contract_Admin_Request'){
                methodString = getContractAdminRequestTotals(theID,itemName,theObject); 
                if(String.isNotBlank(methodString)){
                    returnJSONString = methodString;
                }
            }
            
            if(itemName == 'CSS_Tasks'){
                methodString = getCSSTaskTotals(theID,itemName,theObject); 
                if(String.isNotBlank(methodString)){
                    returnJSONString = methodString;
                }
            }
            
            if(itemName == 'Network_Information'){
                methodString = getNetworkInformationTotals(theID,itemName,theObject); 
                if(String.isNotBlank(methodString)){
                    returnJSONString = methodString;
                }
            }            
            
            if(itemName == 'Open_Enrollment'){
                methodString = getOpenEnrollmentTotals(theID,itemName,theObject); 
                if(String.isNotBlank(methodString)){
                    returnJSONString = methodString;
                }
            }            
            
            if(itemName == 'Performance_Guarantee'){
                methodString = getPerformanceGuaranteeTotals(theID,itemName,theObject); 
                if(String.isNotBlank(methodString)){
                    returnJSONString = methodString;
                }
            }
            
            if(itemName == 'Private_Exchange _ External'){
                methodString = getPrivateExchangeExternalTotals(theID,itemName,theObject); 
                if(String.isNotBlank(methodString)){
                    returnJSONString = methodString;
                }
            }
            
            if(itemName == 'Proposal'){
                methodString = getProposalTotals(theID,itemName,theObject); 
                if(String.isNotBlank(methodString)){
                    returnJSONString = methodString;
                }
            }
            
            
        }    
        return returnJSONString;
    }
    
    @AuraEnabled 
    public static string getAccountMaintenanceTotals(Id theID, String itemName, String theObject){
        
        String theReturnString = '';
        
        If(theObject == 'Account'){
            
            //current Count
            String QueryString01 = 'SELECT Count() FROM Case WHERE AccountId = :theID AND Status NOT IN (\'Cancelled\',\'Completed\') AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'GEMS_Cosmetic_Account_Maintenance\') AND sobjecttype = \'Case\')';
            Integer currentCount = Database.countQuery(QueryString01);        
            
            //Year To Date Count
            String QueryString02 = 'SELECT Count() FROM Case WHERE AccountId = :theID AND Status IN (\'Cancelled\',\'Completed\') AND ClosedDate = THIS_YEAR AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'GEMS_Cosmetic_Account_Maintenance\') AND sobjecttype = \'Case\')';
            Integer YTDCount = Database.countQuery(QueryString02);                
            
            theReturnString = theJSONGenerateMethod(itemName,currentCount,YTDCount);            
            
        }        
        
        Return theReturnString;
    }
    
    @AuraEnabled 
    public static string getCustomBenefitServiceTotals(Id theID,String itemName,String theObject){
        
        String theReturnString = '';
        
        // for the Account Request Hub
        if(theObject == 'Account'){
            //current Count
            String QueryString01 = 'SELECT Count() FROM Case WHERE AccountId = :theID AND Status NOT IN (\'Closed\',\'Withdrawn\') AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'Custom_Benefit_Service\') AND sobjecttype = \'Case\')';
            Integer currentCount = Database.countQuery(QueryString01);        
            
            //Year To Date Count
            String QueryString02 = 'SELECT Count() FROM Case WHERE AccountId = :theID AND Status IN (\'Closed\',\'Withdrawn\') AND ClosedDate = THIS_YEAR AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'Custom_Benefit_Service\') AND sobjecttype = \'Case\')';
            Integer YTDCount = Database.countQuery(QueryString02);                
            
            theReturnString = theJSONGenerateMethod(itemName,currentCount,YTDCount);           
        }
        
        // For the Opportunity Request Hub
        if(theObject == 'Opportunity'){
            //current Count
            String QueryString01 = 'SELECT Count() FROM Case WHERE Opportunity_Name__c = :theID AND Status NOT IN (\'Closed\',\'Withdrawn\') AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'Custom_Benefit_Service\') AND sobjecttype = \'Case\')';
            Integer currentCount = Database.countQuery(QueryString01);        
            
            //Year To Date Count
            String QueryString02 = 'SELECT Count() FROM Case WHERE Opportunity_Name__c = :theID AND Status IN (\'Closed\',\'Withdrawn\') AND ClosedDate = THIS_YEAR AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'Custom_Benefit_Service\') AND sobjecttype = \'Case\')';
            Integer YTDCount = Database.countQuery(QueryString02);                
            
            theReturnString = theJSONGenerateMethod(itemName,currentCount,YTDCount);           
        }        
        
        Return theReturnString;
    }
    
    @AuraEnabled 
    public static string getCedeTotals(Id theID,String itemName,String theObject){
        
        String theReturnString = '';
        
        // for the Account Request Hub
        if(theObject == 'Account'){
            //current Count
            String QueryString01 = 'SELECT Count() FROM Case WHERE AccountId = :theID AND Status NOT IN (\'Approved\',\'Denied\') AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'Cede\') AND sobjecttype = \'Case\')';
            Integer currentCount = Database.countQuery(QueryString01);        
            
            //Year To Date Count
            String QueryString02 = 'SELECT Count() FROM Case WHERE AccountId = :theID AND Status IN (\'Approved\',\'Denied\') AND ClosedDate = THIS_YEAR AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'Cede\') AND sobjecttype = \'Case\')';
            Integer YTDCount = Database.countQuery(QueryString02);                
            
            theReturnString = theJSONGenerateMethod(itemName,currentCount,YTDCount);           
        }
        
        // For the Opportunity Request Hub
        if(theObject == 'Opportunity'){
            //current Count
            String QueryString01 = 'SELECT Count() FROM Case WHERE Opportunity_Name__c = :theID AND Status NOT IN (\'Approved\',\'Denied\') AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'Cede\') AND sobjecttype = \'Case\')';
            Integer currentCount = Database.countQuery(QueryString01);        
            
            //Year To Date Count
            String QueryString02 = 'SELECT Count() FROM Case WHERE Opportunity_Name__c = :theID AND Status IN (\'Approved\',\'Denied\') AND ClosedDate = THIS_YEAR AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'Cede\') AND sobjecttype = \'Case\')';
            Integer YTDCount = Database.countQuery(QueryString02);                
            
            theReturnString = theJSONGenerateMethod(itemName,currentCount,YTDCount);           
        }        
        
        Return theReturnString;
    }
    
    @AuraEnabled 
    public static string getContractAdminTotals(Id theID, String itemName, String theObject){
        
        String theReturnString = '';
        
        if(theObject == 'Account'){
            
            //current Count
            String QueryString01 = 'SELECT Count() FROM Case WHERE AccountId = :theID AND Status NOT IN (\'Cancelled\',\'Completed but No Signature Required\',\'Withdrawn\',\'Fully Executed\') AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'Standard_Contracts\',\'Custom_Contracts\') AND sobjecttype = \'Case\')';
            Integer currentCount = Database.countQuery(QueryString01);        
            
            //Year To Date Count
            String QueryString02 = 'SELECT Count() FROM Case WHERE AccountId = :theID AND Status IN (\'Cancelled\',\'Completed but No Signature Required\',\'Withdrawn\',\'Fully Executed\') AND ClosedDate = THIS_YEAR AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'Standard_Contracts\',\'Custom_Contracts\') AND sobjecttype = \'Case\')';
            Integer YTDCount = Database.countQuery(QueryString02);                
            
            theReturnString = theJSONGenerateMethod(itemName,currentCount,YTDCount);           
            
        }        
        
        Return theReturnString;
    }
    
    @AuraEnabled 
    public static string getContractAdminRequestTotals(Id theID, String itemName,String theObject){
        
        String theReturnString = '';
        
        if(theObject == 'Opportunity'){
            
            //current Count
            String QueryString01 = 'SELECT Count() FROM GEMS_Contract_Admin_Request__c WHERE Opportunity_Link__c = :theID AND Status__c NOT IN (\'Cancelled\',\'Completed\') AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'GEMS_SBC_Benefit_Booklet_Request\') AND sobjecttype = \'GEMS_Contract_Admin_Request__c\')';
            Integer currentCount = Database.countQuery(QueryString01);        
            
            //Year To Date Count
            String QueryString02 = 'SELECT Count() FROM GEMS_Contract_Admin_Request__c WHERE Opportunity_Link__c = :theID AND Status__c IN (\'Cancelled\',\'Completed\') AND Created_Date_Time__c = THIS_YEAR AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'GEMS_SBC_Benefit_Booklet_Request\') AND sobjecttype = \'GEMS_Contract_Admin_Request__c\')';
            Integer YTDCount = Database.countQuery(QueryString02);                
            
            theReturnString = theJSONGenerateMethod(itemName,currentCount,YTDCount);
            
        }
        
        Return theReturnString;
    }
    
    @AuraEnabled 
    public static string getCSSTaskTotals(Id theID,String itemName,String theObject){
        
        String theReturnString = '';
        
        // for the Account Request Hub
        if(theObject == 'Account'){
            //current Count
            String QueryString01 = 'SELECT Count() FROM Task WHERE WhatId = :theID AND Status NOT IN (\'Completed\') AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'CSS_Task_Record_Type\') AND sobjecttype = \'Task\')';
            Integer currentCount = Database.countQuery(QueryString01);        
            
            //Year To Date Count
            String QueryString02 = 'SELECT Count() FROM Task WHERE WhatId = :theID AND Status IN (\'Completed\') AND CreatedDate = THIS_YEAR AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'CSS_Task_Record_Type\') AND sobjecttype = \'Task\')';
            Integer YTDCount = Database.countQuery(QueryString02);                
            
            theReturnString = theJSONGenerateMethod(itemName,currentCount,YTDCount);           
        }
        
        // For the Opportunity Request Hub
        if(theObject == 'Opportunity'){
            //current Count
            String QueryString01 = 'SELECT Count() FROM Task WHERE WhatId = :theID AND Status NOT IN (\'Completed\') AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'CSS_Task_Record_Type\') AND sobjecttype = \'Task\')';
            Integer currentCount = Database.countQuery(QueryString01);        
            
            //Year To Date Count
            String QueryString02 = 'SELECT Count() FROM Task WHERE WhatId = :theID AND Status IN (\'Completed\') AND CreatedDate = THIS_YEAR AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'CSS_Task_Record_Type\') AND sobjecttype = \'Task\')';
            Integer YTDCount = Database.countQuery(QueryString02);                
            
            theReturnString = theJSONGenerateMethod(itemName,currentCount,YTDCount);           
        }        
        
        Return theReturnString;
    }
    
    @AuraEnabled 
    public static string getNetworkInformationTotals(Id theID,String itemName,String theObject){
        
        String theReturnString = '';
        
        // for the Account Request Hub
        if(theObject == 'Account'){
            //current Count
            String QueryString01 = 'SELECT Count() FROM Case WHERE AccountId = :theID AND Status NOT IN (\'Closed\',\'Withdrawn\') AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'Network_Information\') AND sobjecttype = \'Case\')';
            Integer currentCount = Database.countQuery(QueryString01);        
            
            //Year To Date Count
            String QueryString02 = 'SELECT Count() FROM Case WHERE AccountId = :theID AND Status IN (\'Closed\',\'Withdrawn\') AND ClosedDate = THIS_YEAR AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'Network_Information\') AND sobjecttype = \'Case\')';
            Integer YTDCount = Database.countQuery(QueryString02);                
            
            theReturnString = theJSONGenerateMethod(itemName,currentCount,YTDCount);           
        }
        
        // For the Opportunity Request Hub
        if(theObject == 'Opportunity'){
            //current Count
            String QueryString01 = 'SELECT Count() FROM Case WHERE Opportunity_Name__c = :theID AND Status NOT IN (\'Closed\',\'Withdrawn\') AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'Network_Information\') AND sobjecttype = \'Case\')';
            Integer currentCount = Database.countQuery(QueryString01);        
            
            //Year To Date Count
            String QueryString02 = 'SELECT Count() FROM Case WHERE Opportunity_Name__c = :theID AND Status IN (\'Closed\',\'Withdrawn\') AND ClosedDate = THIS_YEAR AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'Network_Information\') AND sobjecttype = \'Case\')';
            Integer YTDCount = Database.countQuery(QueryString02);                
            
            theReturnString = theJSONGenerateMethod(itemName,currentCount,YTDCount);           
        }        
        
        Return theReturnString;
    }
    
    @AuraEnabled 
    public static string getOpenEnrollmentTotals(Id theID,String itemName,String theObject){
        
        String theReturnString = '';
        
        if(theObject == 'Account'){
            
            //current Count
            String QueryString01 = 'SELECT Count() FROM Service_Request__c WHERE Account__c = :theID AND Date_of_Meeting__c >= TODAY AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'Open_Enrollment\') AND sobjecttype = \'Service_Request__c\')';
            Integer currentCount = Database.countQuery(QueryString01);        
            
            //Year To Date Count
            String QueryString02 = 'SELECT Count() FROM Service_Request__c WHERE Account__c = :theID AND Date_of_Meeting__c < TODAY AND Enrollment_Specialist__c != null AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'Open_Enrollment\') AND sobjecttype = \'Service_Request__c\')';
            Integer YTDCount = Database.countQuery(QueryString02);                
            
            theReturnString = theJSONGenerateMethod(itemName,currentCount,YTDCount);                      
            
        }       
        
        Return theReturnString;
    }
    
    @AuraEnabled 
    public static string getPerformanceGuaranteeTotals(Id theID,String itemName,String theObject){
        
        String theReturnString = '';
        
        // for the Account Request Hub
        if(theObject == 'Account'){
            //current Count
            String QueryString01 = 'SELECT Count() FROM Case WHERE AccountId = :theID AND Status NOT IN (\'Approved\',\'Declined\',\'Withdrawn\') AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'Performance_Guarantee\') AND sobjecttype = \'Case\')';
            Integer currentCount = Database.countQuery(QueryString01);        
            
            //Year To Date Count
            String QueryString02 = 'SELECT Count() FROM Case WHERE AccountId = :theID AND Status IN (\'Approved\',\'Declined\',\'Withdrawn\') AND ClosedDate = THIS_YEAR AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'Performance_Guarantee\') AND sobjecttype = \'Case\')';
            Integer YTDCount = Database.countQuery(QueryString02);                
            
            theReturnString = theJSONGenerateMethod(itemName,currentCount,YTDCount);           
        }
        
        // For the Opportunity Request Hub
        if(theObject == 'Opportunity'){
            //current Count
            String QueryString01 = 'SELECT Count() FROM Case WHERE Opportunity_Name__c = :theID AND Status NOT IN (\'Approved\',\'Declined\',\'Withdrawn\') AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'Performance_Guarantee\') AND sobjecttype = \'Case\')';
            Integer currentCount = Database.countQuery(QueryString01);        
            
            //Year To Date Count
            String QueryString02 = 'SELECT Count() FROM Case WHERE Opportunity_Name__c = :theID AND Status IN (\'Approved\',\'Declined\',\'Withdrawn\') AND ClosedDate = THIS_YEAR AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'Performance_Guarantee\') AND sobjecttype = \'Case\')';
            Integer YTDCount = Database.countQuery(QueryString02);                
            
            theReturnString = theJSONGenerateMethod(itemName,currentCount,YTDCount);           
        }        
        
        Return theReturnString;
    }
    
    @AuraEnabled 
    public static string getPrivateExchangeExternalTotals(Id theID,String itemName,String theObject){
        
        String theReturnString = '';
        
        // for the Account Request Hub
        if(theObject == 'Account'){
            //current Count
            String QueryString01 = 'SELECT Count() FROM Case WHERE AccountId = :theID AND Status NOT IN (\'Closed\',\'Declined\',\'Withdrawn\') AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'Private_Exchange_External\') AND sobjecttype = \'Case\')';
            Integer currentCount = Database.countQuery(QueryString01);        
            
            //Year To Date Count
            String QueryString02 = 'SELECT Count() FROM Case WHERE AccountId = :theID AND Status IN (\'Closed\',\'Declined\',\'Withdrawn\') AND LastModifiedDate = THIS_YEAR AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'Private_Exchange_External\') AND sobjecttype = \'Case\')';
            Integer YTDCount = Database.countQuery(QueryString02);                
            
            theReturnString = theJSONGenerateMethod(itemName,currentCount,YTDCount);           
        }
        
        // For the Opportunity Request Hub
        if(theObject == 'Opportunity'){
            //current Count
            String QueryString01 = 'SELECT Count() FROM Case WHERE Opportunity_Name__c = :theID AND Status NOT IN (\'Closed\',\'Declined\',\'Withdrawn\') AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'Private_Exchange_External\') AND sobjecttype = \'Case\')';
            Integer currentCount = Database.countQuery(QueryString01);        
            
            //Year To Date Count
            String QueryString02 = 'SELECT Count() FROM Case WHERE Opportunity_Name__c = :theID AND Status IN (\'Closed\',\'Declined\',\'Withdrawn\') AND LastModifiedDate = THIS_YEAR AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'Private_Exchange_External\') AND sobjecttype = \'Case\')';
            Integer YTDCount = Database.countQuery(QueryString02);                
            
            theReturnString = theJSONGenerateMethod(itemName,currentCount,YTDCount);           
        }        
        
        Return theReturnString;
    }
    
    @AuraEnabled 
    public static string getProposalTotals(Id theID,String itemName,String theObject){
        
        String theReturnString = '';
        
        // for the Account Request Hub
        if(theObject == 'Account'){
            //current Count
            String QueryString01 = 'SELECT Count() FROM Case WHERE AccountId = :theID AND Status NOT IN (\'Closed\',\'Withdrawn\') AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'Proposal\') AND sobjecttype = \'Case\')';
            Integer currentCount = Database.countQuery(QueryString01);        
            
            //Year To Date Count
            String QueryString02 = 'SELECT Count() FROM Case WHERE AccountId = :theID AND Status IN (\'Closed\',\'Withdrawn\') AND ClosedDate = THIS_YEAR AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'Proposal\') AND sobjecttype = \'Case\')';
            Integer YTDCount = Database.countQuery(QueryString02);                
            
            theReturnString = theJSONGenerateMethod(itemName,currentCount,YTDCount);           
        }
        
        // For the Opportunity Request Hub
        if(theObject == 'Opportunity'){
            //current Count
            String QueryString01 = 'SELECT Count() FROM Case WHERE Opportunity_Name__c = :theID AND Status NOT IN (\'Closed\',\'Withdrawn\') AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'Proposal\') AND sobjecttype = \'Case\')';
            Integer currentCount = Database.countQuery(QueryString01);        
            
            //Year To Date Count
            String QueryString02 = 'SELECT Count() FROM Case WHERE Opportunity_Name__c = :theID AND Status IN (\'Closed\',\'Withdrawn\') AND ClosedDate = THIS_YEAR AND RecordTypeId IN (SELECT Id FROM RecordType WHERE DeveloperName IN (\'Proposal\') AND sobjecttype = \'Case\')';
            Integer YTDCount = Database.countQuery(QueryString02);                
            
            theReturnString = theJSONGenerateMethod(itemName,currentCount,YTDCount);           
        }        
        
        Return theReturnString;
    }
    
    @AuraEnabled 
    public static String theJSONGenerateMethod(String name, Integer currentCount, Integer YTDCount){
        
        String theJSONReturn = '';
        
        // Create a JSONGenerator object.
        // Pass true to the constructor for pretty print formatting.
        JSONGenerator gen = JSON.createGenerator(true);
        
        // Create an object to write to the JSON string.
        A x = new A('X');
        
        // Write data to the JSON string.
        gen.writeStartObject();
        gen.writeStringField('name', name);
        gen.writeNumberField('Current', currentCount);
        gen.writeNumberField('YTD', YTDCount);
        gen.writeEndObject();       
        
        // Get the JSON string.
        theJSONReturn = gen.getAsString();
        
        System.debug('theJSONReturn: '+theJSONReturn);
        
        Return theJSONReturn;
        
    }
    
}