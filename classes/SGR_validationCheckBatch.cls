/**************************************************************************************
Apex Class Name     : SGR_validationCheckBatch  
Version             : 1.0
Function            : This class is used to Handle Batch  related to the validations of business.
Modification Log    :

* Developer:  SantoshKumar Nalli                 Date  : 28/10/2018               Description:US14334

* ----------------------------------------------------------------------------------               
* INFOSYS                  28/10/2018                Original Version
*************************************************************************************/



global  class SGR_validationCheckBatch  implements Database.Batchable<sObject>, Database.stateful
{
    String BatchId;
    list<Opportunity> opplst;
    public integer optyCount = 0;
    
    global SGR_validationCheckBatch(String BatchId)
    {
        this.BatchId=BatchId;
        
        
    }

    global Database.QueryLocator start( Database.BatchableContext BC )
    {
		// US12536 & US11982 - Added Rating_Status__c and SGR_Workflow_Activity__c fields into the below query.
		// Akbar - 2/12/2019 - E2E fixes, Account.ShippingState__c field replaced with Account.ShippingState
       String query1 = 'SELECT Id,RecordTypeId,Account.ShippingState, HCSC_Division__c,Renewal_Date__c,Product_Type__C, Zip_Code__c,name,Batch_Id__c,County_Code__c,AccountId,Funding_Type__c,Rating_Status__c,SGR_Workflow_Activity__c,Workflow_System_Status__c,Assigned_UW__c from Opportunity '
                  + 'where Batch_Id__c	=\''+BatchId+'\'';
                  
                 
        system.debug(query1);
       return Database.getQueryLocator(query1); 
        
    }
    global void execute(Database.BatchableContext BC, List<Opportunity> scope)
    {
    //list<Opportunity> 
    optyCount += scope.size();
    opplst=new list<Opportunity>();
    list<Id> oppIdsList = new list<Id>();
     Id oppid;
     try{
        for(Opportunity s:scope){
          //Opportunity recrds=new Opportunity();
          //recrds=(Opportunity)s;
          s.Workflow_System_Status__c='Ready to Validate';
          opplst.add(s);
          System.debug('=======================>'+opplst);  
      }
       if(opplst !=null && !opplst.isEmpty()){
        update opplst;
       }
        
        
        for(Opportunity temp:opplst){
          oppid=temp.id;
          oppIdsList.add(oppid);
      }
      System.debug('Printing list of Ids'+oppIdsList);
        
       /* List<SGR_Opportunity_Benefit_Agreement__c> sobfa = new List<SGR_Opportunity_Benefit_Agreement__c> ();
        sobfa=[select id, Opportunity__c from SGR_Opportunity_Benefit_Agreement__c where Opportunity__c IN :oppIdsList];
        system.debug('Opportunity benefit agreements++++'+sobfa);
        
        List<SGR_Opportunity_Group_Section__c> sogs = new List<SGR_Opportunity_Group_Section__c> ();
        sogs=[select id, Opportunity__c from SGR_Opportunity_Group_Section__c where Opportunity__c IN :oppIdsList];
        system.debug('Opportunity Group Section ++++'+sogs);
        
        List<SGR_Opportunity_Census__c> soc = new List<SGR_Opportunity_Census__c> ();
        soc=[select id, Opportunity__c from SGR_Opportunity_Census__c where Opportunity__c IN :oppIdsList];
        system.debug('Opportunity Group Section ++++'+soc);
        
        //List<Business_Rule__c> br = new List<Business_Rule__c>();
       // br=[select id,Rule_Code__c,Rule_Type__c,Level__c from Business_Rule__c ];
        
       /* List<SGR_Opportunity_Age_Rate__c> soar = new List<SGR_Opportunity_Age_Rate__c> ();
        soar=[select id, Opportunity__c from SGR_Opportunity_Age_Rate__c where Opportunity__c IN :oppIdsList];
        system.debug('Opportunity Group Section ++++'+soar);*/

       /*List<Opportunity> accs= new List<Opportunity>();
        accs=[Select id,AccountId,County_Code__c,Batch_Id__c from opportunity where Id IN:oppIdsList];*/
 
       /* List<SGR_Renewal_Batch_Oppty__c> srwo = new List<SGR_Renewal_Batch_Oppty__c>();
         srwo=[select id from SGR_Renewal_Batch_Oppty__c where Opportunity__c IN :oppIdsList];*/
               
           // SGR_validationHelper.CountyCode(accs);
           system.debug('batchid---'+BatchId);
        if(opplst!=null && opplst.size()>0){
            system.debug(opplst+'16646');
           	SGR_validationHelper svh = new SGR_validationHelper(opplst,BatchId);//call validation
            // SGR_validationHelper.callingMethods(opplst, BatchId);
          }
     }catch(Exception e){
     	system.debug('SGR_ValidationCheckBatch Exception:'+e.getLineNumber()+':::'+e);
     }
     
    }
    
    global void finish(Database.BatchableContext BC)
    {
    	callURERateService();
       //Vijaya SFDC-11978 Start
        	
            //SGR_RenewalEmailProcessor.sendFinalRenewalEmail(optyCount, BC.getJobId());
        
        //Vijaya SFDC-11978 End
     }
    
    private void callURERateService(){
    	
    	List<Id> oppIdSet = new List<Id>();
    
    
    try{
    	
    if(opplst!=null && !opplst.isEmpty()){
    	
        for(Opportunity opt: opplst)
			oppIdSet.add(opt.Id);
        
      //  List< Opportunity> oppLst =[select id from Opportunity where Id IN : oppIdSet AND Rating_Status__C='Initiated' and SGR_Workflow_Activity__C='' and Workflow_System_Status__C = 'Ready to Rate'];
        List< Opportunity> oppLst =[select id from Opportunity where Id IN : oppIdSet AND Rating_Status__C='Initiated'  and Workflow_System_Status__C = 'Ready to Rate'];
		
		oppIdSet.clear(); // reset the Set
		
        for(Opportunity opt: oppLst){
			oppIdSet.add(opt.Id);
        }
        system.debug('oppId Set:::'+oppIdSet);
        
        if(oppIdSet!=null && oppIdSet.size()>0)  // When Not Empty
        {
            system.debug('calling URE Opportunity Rate Batch......');
            SGR_URE_OpportunityRatingBatch batch = new SGR_URE_OpportunityRatingBatch(oppIdSet);
		 	Database.executeBatch(batch);
    	}
    	
     }else{
     	system.debug('no URE Rate Service call due to no validated opportunity. ');
     }
  }catch(Exception e){
  	 system.debug('calling SGR_ValidationCheckBatch calling URE Opportunity Rate Batch Exception:::'+e.getLineNumber()+'==>'+e);
  }
    
  }
}