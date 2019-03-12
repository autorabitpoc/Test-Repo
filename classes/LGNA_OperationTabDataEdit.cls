//************************************************************************//
// Purpose:
// 	Apex Class for use with Lightning Component LGNA_OperationTabDataEdit
// History:
//   Date               Developer                  Description
//                  Rakesh 	      SFDC-8545 - Initial Version - 2018-04 
//                  Rakesh        SFDC-9901 - Modified By Rakesh Nunna
// 06/19/2018	    Mei           SFDC-9901 - Add Method hasModifyAllPermission to check if current user has ModifyAll permission
//************************************************************************//

public class LGNA_OperationTabDataEdit {
    
    public class A { 
        String str;        
        public A(String s) { str = s; }
    }
    
    
    @AuraEnabled
    public static Boolean hasModifyAllPermission(){
    	
    Id userId=UserInfo.getUserId();
    list<PermissionSetAssignment> perm=[SELECT AssigneeId, id FROM PermissionSetAssignment WHERE PermissionSet.PermissionsModifyAllData = true and AssigneeId=:userId limit 1];
    system.debug('permission result::'+perm);
     if( perm!=null && !perm.isEmpty()){
     	return true;
     }
     return false;
    }
    @AuraEnabled
    public static String getselectOptions(sObject objObject, string fld) {
        
        //Used to return Picklist Values for Specified sObject/Fields for use 
        // 	in Lightning Components
        
        system.debug('objObject --->' + objObject);
        system.debug('fld --->' + fld);        
        
        // Get the object type of the SObject.
        Schema.sObjectType objType = objObject.getSObjectType();
        
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();       
        
        
        //create the JSON to Return from the Method
        JSONGenerator gen = JSON.createGenerator(true);
        
        // Create an object to write to the JSON string.
        A x = new A('X');       
        
        gen.writeStartArray();
        
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {            
            gen.writeStartObject();            
            gen.writeStringField('label', a.getLabel());
            gen.writeStringField('value', a.getValue());
            gen.writeEndObject();            
        }
        
        gen.writeEndArray();
        
        // Get the JSON string.
        String resultJSON = gen.getAsString();
        System.debug('JSON : ' + resultJSON);
        
        return resultJSON;        
    }    
    @AuraEnabled
    public static Map<String,boolean> getFieldAccess() {
        
        
        Map<String,boolean> fieldAccessMap = new Map<String,boolean>();
        String [] accountAccessFields = new String [] {'Id',
                              'Name',
                              'Effective_Date__c',
                              'Group_Anniversary_Date__c',
                              'Contract_End__c',
                              'Contract_Signer__c',                             
                              'Open_Enrollment_End_Date__c',
                              'Open_Enrollment_Date__c',
                              'Renewal_Date__c',
                              'Ceded_From_ICL__c',
                              'Ceded_To_ACL__c',
                              'Ceded__c',
                              'HCSC_as_Fiduciary__c',
 	                          'Critical_Account__c',
                              'Funding_Type__c',
                              'Grandfathered_Account__c',
                              'Grandfathered_Date__c',
                              'Premium_Type__c',
                              'COBRA_Administration_Type__c',
                              'BillingStreet',
                              'BillingCity',
                              'BillingState',
                              'BillingPostalCode',
                              'BillingCountry',	
                              'Billing_County__c',						                              
                              'ShippingStreet',
                              'ShippingCity',
                              'ShippingState',
                              'ShippingPostalCode',
                              'ShippingCountry',                              
                              'Key_Locations__c',
                              'Sales_Team__c',
                              'Account_Cluster_Effective_Date__c',
		                      'Account_Cluster_Number__c',
                              'Account_Cluster_User_Identification__c',
                              'Account_Cluster_Name__c',
                              'Account_Executive_2__c',
                              'Sales_Cluster_Number__c',
                              'Underwriter_Effective_Date__c',
                              'Underwriter_End_Date__c',
                              'Underwriter__c',
                              'Underwriter_Name__c',
                              'Underwriter_Team_Code__c',
                              'Underwriter_User_ID__c',
                              'Cancellation_Code__c',
                              'Cancellation_Date__c',
                              'Cancellation_Explanation__c',
                              'Cancellation_Reason__c',
                              'Cancellation_Submitted_Date__c',
                              'Cancelled_Health_Contracts__c',
                              'Cancelled_Health_Members__c',
                              'Claim_Stop_Date__c',
                              'Integration_Status__c',
                              'Requested_Cancellation_Date__c'                                                     
            };
                
                
                // Obtain the field name/token map for the Expense object
                Map<String,Schema.SObjectField> m = Schema.SObjectType.Account.fields.getMap();
        System.debug('=m='+m);
        
        for (String fieldToCheck : accountAccessFields) {
        	Boolean hasEdit=m.get(fieldToCheck).getDescribe().isUpdateable();
            system.debug('field to Check:::'+fieldToCheck+ 'is Updateable??'+hasEdit);
            
            fieldAccessMap.put(fieldToCheck,m.get(fieldToCheck).getDescribe().isUpdateable());
            
        }
        System.debug('=fieldAccessMap='+fieldAccessMap);
        return fieldAccessMap;
    }
    
}