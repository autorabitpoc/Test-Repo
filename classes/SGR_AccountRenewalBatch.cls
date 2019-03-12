/**************************************************************************************
Apex Class Name     : SGR_AccountRenewalBatch     
Version             : 1.0
Function            : This class is used to Count the Number of Accounts Per division which are about to be renewed.
Modification Log    :
* Developer:Tarun Gajula                 Date: 4/9/2018                   Description
* Developer:SantoshKumar Nalli           Date: 5/9/2018                   Description
* Developer:Nidhi Reddy                  Date: 10/3/2018                  Description
* Developer:Saritha Boyapati             Date: 22/11/2018                 Description
* ----------------------------------------------------------------------------               
* INFOSYS                  09/05/2018                Original Version
*************************************************************************************/
global class SGR_AccountRenewalBatch implements Database.Batchable<sObject>, Database.stateful{
    
    
    public String divisions;
    public String marketSegment;
    public String fundingType;
    public  DATE renewEffDate;
    public String renType;
    public integer optyCount = 0;
    private Actuary_Gate__c gateRec;
    
    global SGR_AccountRenewalBatch( String divisions,String marketSegment,String fundingType,DATE renewEffDate,String renType)
    {
        this.divisions=divisions; 
        this.marketSegment=marketSegment;   
        this.fundingType=fundingType;
        this.renewEffDate=renewEffDate;   
        this.renType=renType;
        this.gateRec = SGR_AccountRenewalsHelper.fetchGateRecord(divisions, marketSegment, fundingType, renewEffDate);
    }
    
    /************************************************
* Method name  : start
* Description  : Start method queries all the records matching criteria and returns a Database.QueryLocator for it.
* Return Type  : Database.QueryLocator
*************************************************/
    global Database.QueryLocator start( Database.BatchableContext BC ){
        //Date myDate = renewEffDate.date();    
        // renewEffDate=date(renewEffDate);
        STring fDate1=String.valueof(renewEffDate).split('\\s[0-9,:]*')[0];
        STring fDate2=String.valueof(renewEffDate.addMonths(1)).split('\\s[0-9,:]*')[0];
        String smallGroup = 'Small Group';
        Id sgrGroupAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        String status = 'Active';
        String ACA_Indicator='Y';
        list<account> AccData= new  list<account>();
        //14499:Added Is_Metallic_Account__c to the query.
        String query1 = 'SELECT Id, EIN__c , Domestic_Partner__c, Forecast_Segment__c,County_Code__c,HCSC_Division__c,Renewal_Date__c,Product_Type__c,name,Funding_Type__c,ShippingPostalCode, Region__c, External_ID__c from  Account '
            + 'where HCSC_Division__c=\''+divisions+'\''
            + ' AND Forecast_Segment__c=\''+ constantsController.opportunityForecastSegmentSmallGroup +'\''    //+ ' AND Market_Segment__c=\''+marketSegment+'\''      
            + ' AND Funding_Type__c=\''+fundingType+'\''
            + ' AND Renewal_Date__c >='+fDate1
            + ' AND Renewal_Date__c <'+fDate2
            + ' AND Status__c= \'' +status+'\''
            + ' AND recordTypeId=\''+sgrGroupAccount+'\''
            + ' AND ACA_Indicator__c=\''+ACA_Indicator+'\'';
        System.debug('query1 :: '+query1);
        
        return Database.getQueryLocator(query1);
       
        
        // return [select id from Account where Market_Segment__c=:marketSegment AND Funding_Type__c=:fundingType AND (Renewal_Effective_Date__c >=:renewEffDate AND Renewal_Effective_Date__c <:renewEffDate.addMonths(1)) AND HCSC_Division__c =:divisions];
    }
    
    /*************************************************
* Method name  : execute
* Description  : No functionality for current US 11983 
* Return Type  : void
*************************************************/
    global void execute(Database.BatchableContext BC, List<Account> scope){
        System.debug('Executing first line of exe method');
        Id sgrProdOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId(); 
        Id sgrAnalytOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Analytical Opportunity').getRecordTypeId();
        Id sgrGrpAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId();
        Date renewEffDate1= date.valueOf(renewEffDate);
        Id currentBatchId;
        list<Account> accs=new list<Account>();
        Opportunity op=new Opportunity();
        list<Opportunity> actOpps=new list<Opportunity>();
        list<Opportunity> oss=new list<Opportunity>();
        list<Opportunity> inActOpps=new list<Opportunity>();
        list<Account> noOpsAccLst=new list<Account>();
        list<Account> zeroOpsAccLst=new list<Account>();
        set<Id> noOpsAccId=new set<Id>();
        list<Account> actOppAccs=new list<Account>();
        list<Account> inActOppAccs=new list<Account>();
        set<Account> inActOppAccsToBSent=new set<Account>();
        list<Account> inActOppAccsToBSentLst=new list<Account>();
        list<Opportunity> inActOpp=new list<Opportunity>();
        Set<Id> accIdsSet = new Set<Id>();
        //SFDC-14499:
       /* map<id,Integer> Metallicacc= new map<id,Integer>();
        
        set<id> AccIds= new set<id>();
        Set<ID> MetallicSend=new Set<ID>();
        system.debug('scope :: '+scope);
        system.debug('scopefirst :: '+scope[0].id);
        //for testing
        for(Account Acs:scope){
            AccIds.add(Acs.id); 
        }
        
        for(AggregateResult ar :[select count(id) Cnt,Group_Account__c grp from Benefit_Agreement__c  group by Group_Account__c having Group_Account__c In :AccIds ]){
            Metallicacc.put((ID)ar.get('grp'),(Integer)ar.get('cnt'));
        }
         map<id,Integer> Metallicacc1= new map<id,Integer>();
        for(AggregateResult ar :[select count(id) Cnt,Group_Account__c grp from Benefit_Agreement__c where  Status__c='Active' AND ACA_Indicator__c='TRUE'  group by Group_Account__c having Group_Account__c In :AccIds]){
            
            Metallicacc1.put((ID)ar.get('grp'),(Integer)ar.get('cnt')); 
            
        }
        for( Account acc:scope)
        {
            if(!Metallicacc.isEmpty() && Metallicacc!=null && Metallicacc1!=null && !Metallicacc1.isEmpty()){ 
                if(Metallicacc.get(acc.Id) == Metallicacc1.get(acc.Id)){
                    system.debug('Reached here metallic');
                    MetallicSend.add(acc.id);
                    system.debug(MetallicSend);
                }
            }
        }
        //14499:End */
        Id accId;
        
        for(sobject s:scope){
            Account recrds=new Account();
               recrds=(Account)s;
              //added Logic to check Group Section
            /*boolean isValidAcc = false;
            for(Benefit_Agreement__c ba : recrds.Benefit_Agreements1__r){
               if(ba.Group_Section_Assigned_Count__c > 0){
                  isValidAcc = true;
              } 
                else{
                    isValidAcc = false; 
                    break;
                }
            }
            system.debug('+++isValidAcc--'+isValidAcc);
            if(isValidAcc){
                system.debug('+++Account Id--'+recrds.Id);
                accs.add(recrds);
            }*/
                  accs.add(recrds);
            
                System.debug('=======================>'+accs); 
           
        }
        
        if(!test.isRunningTest())
        {
            AsyncApexJob a = [SELECT Id FROM AsyncApexJob WHERE Id = :BC.getJobId()]; 
            system.debug('****************************ID*********'+ a.Id);
            currentBatchId=a.id;
        }
        else
        { currentBatchId=null;
        }
        System.debug('=======================>'+accs);
        
        set<id> acIdSet=new set<id>();
        set<String> acNoSet = new set<String>();
        if(!accs.isEmpty() && accs!= null ){
            for(Account temp:accs){
                accId=temp.id;
                acNoSet.add(temp.External_ID__c);
                accIdsSet.add(accId);
            }
        }
        System.debug('Printing list of Ids'+accIdsSet);
        
        System.debug('Checking for renType');
        if(!accs.isEmpty() && accs!= null ){
            if(renType=='Analytical'){
                SGR_AccountRenewalsHelper.createOpportunities(accs, renType,'Batch',currentBatchId,renewEffDate, gateRec); 
                // Akbar - 2/7/2019 - E2E fix - avoiding too many DML rows on plan rate records insertion. 
                List<id> oppridList = SGR_AccountRenewalsHelper.opprIdList; 
                oss=[Select id,AccountId, Forecast_Segment__c, Renewal_Date__c, County_Code__c,Batch_Id__c, HCSC_Division__c, FIPS_Code__c,Health_Count__c,Dental_Count__c,Subscribers_Count__c from opportunity where id IN :oppridList];//Batch_Id__c=:currentBatchId];
                optyCount += oss.size();
                SGR_AccountRenewalsHelper.addBAGSAssignments(acNoSet,currentBatchId);
                //Tarun 01/02/2019 : Added return type as a part of E2E Fixes
                map<id,list<SGR_Opportunity_Benefit_Agreement__c>> opBenMap1=
                    SGR_AccountRenewalsHelper.insertOpportunitiesBenefitAgreement(accIdsSet,oss,currentBatchId);
                SGR_AccountRenewalsHelper.insertOpportunitiesGroupSection(accIdsSet,oss,currentBatchId);
                SGR_AccountRenewalsHelper.insertOpportunitiesCencus(accIdsSet,oss,currentBatchId);
                //Tarun 01/02/2019 : Added extra parameter as a part of E2E Fixes
                /*SGR_AccountRenewalsHelper.insertOpportunitiesBenefitAgreement(accIdsSet,oss,currentBatchId);
                SGR_AccountRenewalsHelper.insertOpportunitiesGroupSection(accIdsSet,oss,currentBatchId);
                SGR_AccountRenewalsHelper.insertOpportunitiesCencus(accIdsSet,oss,currentBatchId);*/
                SGR_AccountRenewalsHelper.insertOpportunitiesPlanRate(accIdsSet,oss,currentBatchId,opBenMap1);
                SGR_AccountRenewalsHelper.insertOpportunitiesMemberBenefit(accIdsSet,oss,currentBatchId);
                //  SFDC:14982      
                SGR_AccountRenewalsHelper.insertOppBAGSAssignment(accIdsSet,oss,currentBatchId);
                //SGR_AccountRenewalsHelper.insertOptyPlanCompRate(accIdsSet,oss,currentBatchId);
                SGR_PGA_Opportunity.sgrCreateProducerAssociationForOpportunity(oss);
            }
            else{
                //Nidhi: replaced accountnumber with external_ID__c 
                //SFDC:14536:Adding Rating_Status__c field to the Query
                noOpsAccLst=[select id,name,HCSC_Division__c,EIN__c,Domestic_Partner__c,Funding_Type__c,Forecast_Segment__c,ShippingPostalCode , county_code__c,Renewal_Date__c, Region__c, (select id,name,AccountId,Renewal_Date__c,stageName,Opportunity.Account.external_ID__c,Rating_Status__c from Opportunities where SGR_Opportunity_Type__c='Production') from Account where id IN:accIdsSet AND recordtype.id=:sgrGrpAcc AND Status__c='Active'];
                //  inActOpps=[select id,name,AccountId,stageName,Opportunity.Account.external_ID__c from opportunity where Account.id IN: accIdsList AND (stageName='Won' OR stageName='Lost') AND recordtype.id=:sgrProdOpp ];
                System.debug('fetching in active opps:'+noOpsAccLst);
                //*******Insertion of Zero opportunities scenario**********
                for(Account temp:noOpsAccLst){
                    if(temp.Opportunities.size()==0){
                        noOpsAccId.add(temp.id);
                        zeroOpsAccLst.add(temp);
                    }
                }
                
                //*******Insertion of Inactive Opportunities***************         
                //SFDC-14536(Saritha):change in duplicate condition check based on rating status of 'Finalized' or 'Closed' instead of WON/LOST status
                for(Account parent:noOpsAccLst){
                    System.debug('Testing--'+parent.Opportunities);
                    Integer activeCount=0;
                    for(Opportunity child:parent.Opportunities){
                        if(child.Rating_Status__c!='Finalized' && child.Rating_Status__c!='Closed' && child.Renewal_Date__c==parent.Renewal_Date__c ){
                            
                            actOpps.add(child); 
                            actOppAccs.add(parent);
                            System.debug('Round--'+activeCount+'--'+child);
                            System.debug('Round--'+activeCount+'--'+parent);
                            activeCount++;
                        }
                    }
                    if(activeCount==0){
                        inActOppAccsToBSentLst.add(parent);
                    }
                }
                System.debug('inActOppAccsToBSentLst --'+inActOppAccsToBSentLst);
                System.debug('After all rounds --'+actOppAccs); 
                
                /*   Preparing the list of accounts and its Ids to be sent for creations  */  
                for(Account tmp:inActOppAccsToBSentLst){
                    id cId=tmp.id;
                    acIdSet.add(cId);
                    
                }
                
                System.debug('inActOppAccsToBSentLst'+inActOppAccsToBSentLst);
                
                if(inActOppAccsToBSentLst.size()>0){
                    String bId=String.valueOf(currentBatchId);
                    //SGR_AccountRenewalsHelper.createRenewalBatchOpps(inActOpp,bId);
                    SGR_AccountRenewalsHelper.createOpportunities(inActOppAccsToBSentLst, renType,'Batch',currentBatchId,renewEffDate, gateRec);
                    // Akbar - 2/7/2019 - E2E fix - avoiding too many DML rows on plan rate records insertion. 
                  List<id> oppridList = SGR_AccountRenewalsHelper.opprIdList; 
                    oss=[Select id,name,Renewal_Date__c,AccountId,FIPS_Code__c,Forecast_Segment__c,HCSC_Division__c,County_Code__c,Batch_Id__c from opportunity where id IN :oppridList];//Batch_Id__c=:currentBatchId];
                    optyCount += oss.size();
                    SGR_AccountRenewalsHelper.addBAGSAssignments(acNoSet,currentBatchId);
                     //Tarun 01/02/2019 : Added return type as a part of E2E Fixes
                    map<id,list<SGR_Opportunity_Benefit_Agreement__c>> opBenMap2=
                        SGR_AccountRenewalsHelper.insertOpportunitiesBenefitAgreement(acIdSet,oss,currentBatchId);
                    SGR_AccountRenewalsHelper.insertOpportunitiesGroupSection(acIdSet,oss,currentBatchId);
                    SGR_AccountRenewalsHelper.insertOpportunitiesCencus(acIdSet,oss,currentBatchId);
                    
                    //Tarun 01/02/2019 : Added extra parameter as a part of E2E Fixes
                    
                    /*SGR_AccountRenewalsHelper.insertOpportunitiesBenefitAgreement(acIdSet,oss,currentBatchId);
                    SGR_AccountRenewalsHelper.insertOpportunitiesGroupSection(acIdSet,oss,currentBatchId);
                    SGR_AccountRenewalsHelper.insertOpportunitiesCencus(acIdSet,oss,currentBatchId);*/
                    SGR_AccountRenewalsHelper.insertOpportunitiesPlanRate(acIdSet,oss,currentBatchId,opBenMap2);
                    SGR_AccountRenewalsHelper.insertOpportunitiesMemberBenefit(acIdSet,oss,currentBatchId);
                    //SFDC:14982
                    SGR_AccountRenewalsHelper.insertOppBAGSAssignment(accIdsSet,oss,currentBatchId);
                    SGR_PGA_Opportunity.sgrCreateProducerAssociationForOpportunity(oss);
                }
                
                if(actOppAccs.size()>0)
                {
                    String bId=String.valueOf(currentBatchId);
                    System.debug('#############'+bId);
                    SGR_AccountRenewalsHelper.createRenewalBatchOpps(actOpps,bId);
                    SGR_AccountRenewalsHelper.createErrorLog(actOppAccs, bId);
                    
                }
                
            }
        }
    }
    
    /**************************************************
* Method name  : finish
* Description  : No finish method behaviour is identified yet. 
* Return Type  : void
*************************************************/  
    global void finish(Database.BatchableContext BC){
        
        String BatchId;
        
        Id RenewBatchId;
        AsyncApexJob a1 = [SELECT Id,TotalJobItems,JobItemsProcessed FROM AsyncApexJob WHERE Id = :BC.getJobId()]; 
        system.debug('****************************ID*********'+ a1.Id);
        BatchId=a1.id;
        //if(BatchId !='' || BatchId != null){
        //RenewBatchId=[select Id,BatchID__c from SGRRenewalBatch__c where BatchID__c =:BatchId].Id;
        //system.debug('****************************ID*********'+ RenewBatchId);
        //Vijaya SFDC-11978 Start
          //List<Opportunity> optys = [select Id from Opportunity where Batch_Id__c = :BC.getJobId()];
          Integer countofOptys = [select count() from Opportunity where Batch_Id__c = :BC.getJobId()];
          system.debug('++++countofOptys--'+countofOptys);
            //SGR_RenewalEmailProcessor.sendFinalRenewalEmail(optyCount, BC.getJobId());
          SGR_RenewalEmailProcessor.sendFinalRenewalEmail(countofOptys, BC.getJobId());
        //Vijaya SFDC-11978 End
        
    //16508 - Commenting the submission of balidation check batch and including the submission of gsps call map batch. 
    //Validation check batch will be submitted on completion of gsps call map batch.        
        //SGR_validationCheckBatch svc = new SGR_validationCheckBatch(BatchId);
        //ID batchId1 = Database.executeBatch(svc,50);
        SGR_GSPS_CallMappedPlans sgcmp = new SGR_GSPS_CallMappedPlans(BatchId);
        //ID batchId1 = Database.executeBatch(sgcmp, 50);
        //16508 - Changes end.
        
        //} 
    }
}