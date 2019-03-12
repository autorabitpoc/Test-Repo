/**************************************************************************************
  Apex Class Name     : GEMS_CaseTeamPageController
  Version             : 1.0
  Function            : This is a handler class for CaseTrigger. The methods in this class are used as utility methods for CaseTrigger
  Modification Log    :
* Developer           :    Date                   Description
* ----------------------------------------------------------------------------                 
* Siva Thimmannagari        06/01/2016                Original Version
*************************************************************************************/
@isTest 
public class GEMS_CaseTeamPageControllertest {
    public static testMethod void GEMS_CaseTeamPageController1(){
    Case caseRec = new Case();       
        caseRec.RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('GEMS GET').getRecordTypeId();
        caseRec.Status='In Progress';
        caseRec.HCSC_Division__c='IL';
        caseRec.Funding_Type_Multiselect__c = 'ACAP';
        caseRec.GEMS_Products__c = 'Dearborn;EPO;HSA;FSA;BCC;Cobra';
        caseRec.GEMS_Integrated__c = false;
        caseRec.GEMS_BCC_Products__c = 'Selective I/O';
        caseRec.GEMS_Bank__c = '' ;
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
        caseRec.GEMS_Request_Resource__c='Account Specialist;Underwriter';     
        insert caseRec;
        
        
        ApexPages.currentpage().getParameters().put('id',caseRec.id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(caseRec);
        GEMS_CaseTeamPageController g1 = new GEMS_CaseTeamPageController(sc1);
        g1.save();
 }
 }