/**************************************************************************************
  Apex Class Name     : GEMS_RequestImplementerController
  Version             : 1.0
  Function            : This is a handler class for CaseTrigger. The methods in this class are used as utility methods for CaseTrigger
  Modification Log    :
* Developer           :    Date                   Description
* ----------------------------------------------------------------------------                 
* Siva Thimmannagari        06/01/2016                Original Version
*************************************************************************************/
@isTest 
public class GEMS_RequestImplementerControllertest{
    public static testMethod void GEMS_RequestImplementerControllertest1(){
    
        Account acc = new Account();
        acc.status__c = 'Sold123';
        acc.Fax = '1234567';
        acc.ShippingStreet = 'test';
        acc.ShippingCity = 'Florida';
        acc.ShippingState = 'IL';
        acc.ShippingPostalCode = '12345';
        acc.Name = 'Praveen Account';
        insert acc;
        
        
       
          Case subRec= GEMS_UtilityClassTest.insertionCase('GEMS Account Submission');
        subRec.status = 'In Progress';
        subRec.Funding_Type_Multiselect__c = 'ACAP';
        subRec.GEMS_AEP_Account__c= true;
        insert subRec;
     
     
        Case medRec= GEMS_UtilityClassTest.insertionCase('GEMS Request Implementer');
        medRec.GEMS_Account_Submission_Info__c  = subRec.Id;
        
        //medRec.accountId = acc.Id;
        medRec.Status = 'In Progress';
        insert medRec;
         
        
        CaseTeamMember team = GEMS_UtilityClassTest.insertionCaseTeam(subRec.id, 'Implementer');
        insert team;
        
        
                ApexPages.currentPage().getParameters().put('Id',medRec.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(medRec);
        GEMS_RequestImplementerController g = new GEMS_RequestImplementerController(sc);
        
       g.getApproveOrRejectStatus(); 
       g.enableSelectImplementer();
       g.Save();
       g.getItems();
       g.displayImplementer=true;
       g.caseStatus='ABS';
       g.setApproveOrRejectStatus('ABS');
        
        
       
        
        }
        }