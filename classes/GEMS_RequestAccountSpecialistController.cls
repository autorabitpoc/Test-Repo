/**************************************************************************************
  Apex Class Name     : GEMS_RequestAccountSpecialistController
  Version             : 1.0
  Function            : This method is to create Account Specialist Case
  Modification Log    :
* Developer           Date                   Description
* ----------------------------------------------------------------------------   
*	Ranjit Gandhi			06/26/2017		SFDC-4250-GEMS - NO GET case should be created for cosmetic account maintenance case (even if account team has a CIC on it) 
* Offshore            09/26/2016             Original Version
*************************************************************************************/

global class GEMS_RequestAccountSpecialistController {
    public GEMS_RequestAccountSpecialistController() {
        
    }        
    /******************************************************************** 
    *    Method Name :  createAccSpecialistCase
    Action
    *   @description :   This method is to create Account Specialist Case
    *   @parameters  : String,String  
    *   @return type :   String
    ***************************************************************/
webservice static String createAccSpecialistCase(String caseID,String businessArea){
  try {  
        Id requestResourceRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS Request Resource').getRecordTypeId();
        GEMS_Request_Resource__mdt requestAccSpecilistRec = [select Business_Area__c,Queue_Name__c from GEMS_Request_Resource__mdt where Business_Area__c=:businessArea];
        List<Group> resourceQues =[select Id,Name from Group where Type = 'Queue' and name =:requestAccSpecilistRec.Queue_Name__c];        
        Case caserec = [select id,subject,GEMS_Request_Resource__c,account.name,HCSC_Division__c,GEMS_Submission_Type__c,GEMS_Submission_Sub_Type__c,GEMS_Case_Effective_Date__c,GEMS_AEP_Account__c,FSU_Location__c,GEMS_Line_of_Business__c,GEMS_Products__c,Opportunity_Name__c,Accountid,GEMS_Effective_Date__c,GEMS_account_submission_info__c,Account.External_ID__c,ownerId from case where id =:caseID ];
        List<case> requestResourceCase = [select id,sub_category__c from case where GEMS_Account_Submission_Info__c = :caseID and recordtypeid = :requestResourceRecordTypeId and sub_category__c=:businessArea];
        System.debug('===businessArea='+businessArea);
        if(requestResourceCase!=null && requestResourceCase.isEmpty()) {
            Case AccSpecialistCase = new Case();
            //SFDC-4250-GEMS - NO GET case should be created for cosmetic account maintenance case (even if account team has a CIC on it) 
            //Added if condition for AM case- as it does not have effective date.
            if(caserec.Opportunity_Name__c !=null)
            {
                AccSpecialistCase.Opportunity_Name__c = caserec.Opportunity_Name__c; 
                AccSpecialistCase.Effective_Date__c=caserec.GEMS_Effective_Date__c;
                DateTime effectiveDate = caserec.GEMS_Effective_Date__c;                
                AccSpecialistCase.subject = caserec.account.name + ' ' +caserec.Account.External_ID__c+' '+effectiveDate.format('M/d/yyyy')+' '+businessArea;
 	        }
            else
               AccSpecialistCase.subject = caserec.account.name + ' ' +caserec.Account.External_ID__c+' '+businessArea;
           
            AccSpecialistCase.recordtypeid = requestResourceRecordTypeId;
            AccSpecialistCase.status = 'In Progress';
            AccSpecialistCase.parentid = caseID;
            AccSpecialistCase.ownerId = resourceQues[0].id;
            AccSpecialistCase.type = 'Request Resource';
            AccSpecialistCase.Sub_Category__c = businessArea;
            AccSpecialistCase.GEMS_Account_Submission_Info__c = caseID;
            AccSpecialistCase.Accountid = caserec.Accountid; 
            AccSpecialistCase.GEMS_Products__c = caserec.GEMS_Products__c;
            AccSpecialistCase.HCSC_Division__c = caserec.HCSC_Division__c;
            AccSpecialistCase.GEMS_Submission_Type__c = caserec.GEMS_Submission_Type__c;
            AccSpecialistCase.GEMS_Submission_Sub_Type__c = caserec.GEMS_Submission_Sub_Type__c;
            AccSpecialistCase.GEMS_Line_of_Business__c = caserec.GEMS_Line_of_Business__c;
            AccSpecialistCase.FSU_Location__c = caserec.FSU_Location__c;                   
            AccSpecialistCase.GEMS_AEP_Account__c = caserec.GEMS_AEP_Account__c;
            AccSpecialistCase.GEMS_Case_Effective_Date__c = caserec.GEMS_Case_Effective_Date__c; 
            AccSpecialistCase.GEMS_Submitter__c = caserec.ownerId;
            insert AccSpecialistCase;
             return 'Requested account Specialist case created successfully';
    }
    else return 'An Account Specialist already exists on the Case Team';

   }catch(Exception ex){
            System.debug('==exception=='+ex.getMessage());
   }
   return null;
  }
  }