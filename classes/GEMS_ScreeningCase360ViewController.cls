/*
* 04/22/2018	Luke Chen	SFDC-9342 GEMS: Prod Issue - 360 view showing a different open/closed date than actual cases
*
*/
public without sharing class GEMS_ScreeningCase360ViewController
{
    public Id caseId {get; set;}
    public Double offset{get; set;}  // SFDC-9342
    public Case caseObj 
    {
        get 
        {
            if (caseObj == null)
            {
                caseObj = new Case();
                caseObj = [SELECT ID, Subject, Account_Number__c, HCSC_Division__c, Market_Segment__c, GEMS_Case_Effective_Date__c, Opportunity_Name__c FROM Case WHERE Id = :caseId];
                System.debug('case record:' +caseObj);
            }
            return caseObj;
        } 
        set;
    }
    //public Id accountId {get; set;}
    public GEMS_ScreeningCase360ViewController(){}
    
    public  Integer noOfOpportunityProducts {get; set;}
    public List<Opportunity_Product__c> listOfOpportunityProducts {get; set;}
    public List<Case> openChildCasesList{get; set;}
    public GEMS_ScreeningCase360ViewController(ApexPages.StandardController stdController) 
    {
        try
        {   
            offset = GEMS_Utility.getLocalTimeZoneOffset(); // SFDC-9342
            
            noOfOpportunityProducts = 0;
            
            caseId = stdController.getId();
            listOfOpportunityProducts = new List<Opportunity_Product__c>();
            
            listOfOpportunityProducts = [SELECT Id, Product__c, Product__r.Name,Funding_Type__c,Product_Category__c, Opportunity_Product__c.Win_Probability__c, Opportunity_Product__c.Projected_Members__c FROM Opportunity_Product__c WHERE Opportunity_Name__c =:caseObj.Opportunity_Name__c];
            openChildCasesList= [SELECT ID, casenumber, CreatedDate, ClosedDate ,Type, GEMS_Benefit_Agreement__r.Name, isclosed, Sub_Category__c, Product_Type__c, status, Days_Open__c, Owner.Name from Case WHERE GEMS_Account_Submission_Info__c =: caseId and GEMS_Benefit_Agreement__c ='' Order by CreatedDate ASC];
                System.debug('Case ID:'+caseId);
                System.debug('opp prod list:'+listOfOpportunityProducts);
    
        }catch(Exception ex){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
            System.debug('+myMsg++'+myMsg);
            //GEMS_CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_ScreeningCase360ViewController','High'); 
            ApexPages.addMessage(myMsg);
            System.debug( 'Exception : ' +ex.getMessage() );
        }
    }
}