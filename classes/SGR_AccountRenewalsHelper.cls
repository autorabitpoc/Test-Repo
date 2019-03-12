/**************************************************************************************
Apex Class Name     : SGR_AccountRenewalsHelper     
Version             : 1.0
Function            : Created all methods for child insertion related to Opportunity Object
Modification Log    :
* TarunKumar Gajula     09/07/2018      Created all methods for child insertion related to Opportunity object
* SantoshKumar Nalli    08/07/2018       Description
* Nidhi Reddy           10/03/2018       Description
* Shankar               10/30/2018       SFDC-14055. Assign gate to opportunity
* Landry                11/01/2018       SFDC-14082 Added member policy tier reference to account/opp member benefits
* TarunKumar Gajula     11/12/2018       SFDC-14515 Handled Database.SaveResult for all insertion methods
* Shankar               01/04/2019       SFDC-16508. Changes to assign Plan look up to Opportunity plan rate records
* Shankar               01/04/2019       SFDC-16516. Changes to set Rating_Status, WorkFlow_Activity & Workflow_System_Status fields on Opportunity during initiation
* Shankar               01/19/2019       Jan-19 urgent fixes for regionCode (BlueSTAR)
* Shankar               01/20/2019       Jan-20 urgent fixes for Trigger renewal issues
* Padma                 01/22/2019       Jan-22 Added code for regionCode (BlueSTAR) Added Regio_Code__c on Benefit Agreement Copy over to Opportunity Benefit Agreement
* Anil                  01/25/2019       Populate Opportunity Census relationship field based on the Account Census Relationship Code. Values are driven based off the SGR RELATIONSHIP MAPPING custom setting 
* Anil                  01/27/2019       Limited the creation of Opportunity Census / Member Benefits based on whether the Census is active or not
*Roopa                  01/28/2019      Adding ACA_Indicator__c field on opportunity benefit aggrement.
* ----------------------------------------------------------------------------               
* INFOSYS                  05/09/2018                Original Version
*************************************************************************************/

public class SGR_AccountRenewalsHelper{
    
    public String record_Type;
    public String Opp_name;
    public String Batch_type;
    public String Opp_Stage;
    public String Opp_Number;
    public String bIdForErrLog;
    // Akbar - 2/7/2019 - E2E fix - avoiding too many DML rows on plan rate records insertion. 
    public static List<id> opprIdList = new List<id>();
    
    // public static boolean flag=false;
    @AuraEnabled
    public static String renewalBatchInsert(String division,String accNum,String marketSegment,String fundingType,Date renewEffDate,String renType){
        String msg='';
        list<SGRRenewalBatch__c> rbList=new list<SGRRenewalBatch__c>();
        list<SGRRenewalBatch__c> rbListUpdate=new list<SGRRenewalBatch__c>();
        SGRRenewalBatch__c rb=new SGRRenewalBatch__c();
        
        rb.Account_Number__c =accNum;
        rb.BatchType__c  ='On-Demand';
        rb.Number_of_Accounts__c =1;
        rb.Division__c=division;
        rb.RenewalType__c=renType;
        rb.FundingType__c=fundingType;
        rb.MarketSegment__c=marketSegment;
        System.debug('Before insert :-------->'+renewEffDate);
        rb.Renewal_Effective_date__c=renewEffDate;
        rbList.add(rb);
        
        
        
        
        if(rbList.size()> 0) {
            
            
            insert rbList;
            rbListUpdate=[select id from SGRRenewalBatch__c where Account_Number__c =:accNum AND Division__c=:division AND RenewalType__c=:renType AND FundingType__c=:fundingType AND MarketSegment__c=:marketSegment];
            for(SGRRenewalBatch__c temp:rbListUpdate){
                rbList[0].BatchID__c=temp.id;
            }
            update rbList;
            // OpportunityInsert(acc,renewalType,renEffDate,batchType,batchId);
            msg='Batch ID #<strong>'+rbList[0].BatchID__c+'</strong> created for <strong>'+division+'</strong> Division. <strong>'+ '1' + '</strong> opportunity is created.' ;
            return msg;    
        }
        else{
            throw new AuraHandledException('No opportunities will be created!');  
        }
        
        
    }
    
    
    public static SGRRenewalBatch__c createRenewalBatchRec(String division,String accNum,String marketSegment,String fundingType,Date renewEffDate,String renType, String batchType, Integer count, String batchId){
        SGRRenewalBatch__c[] rbList= new list<SGRRenewalBatch__c>();
        SGRRenewalBatch__c rb=new SGRRenewalBatch__c();
        if (accNum!='') rb.Account_Number__c =accNum;
        rb.BatchType__c  = batchType;
        
        rb.BatchID__c = batchId;
        rb.Number_of_Accounts__c = count;
        rb.Division__c=division;
        rb.RenewalType__c=renType;
        rb.FundingType__c=fundingType;
        rb.MarketSegment__c=marketSegment;       
        rb.Renewal_Effective_date__c=renewEffDate;
        //SFDC-14249 Start
        // system.debug('djkghsdfg'+renewEffDate);
        //   system.debug('djkghsdfgdsgsdgmndfjkghdfjkbg'+ rb.Renewal_Effective_date__c);
        Date mydate=Date.newInstance(rb.Renewal_Effective_date__c.Year(),rb.Renewal_Effective_date__c.Month(),rb.Renewal_Effective_date__c.day());
        // System.debug('@@@ '+mydate);
        string year = String.valueOf(rb.Renewal_Effective_date__c.Year());
        string month = String.valueOf(rb.Renewal_Effective_date__c.Month());
        string day = '1';
        string stringDate = year + '-' + month+ '-' + day;
        mydate=date.valueOf(stringDate);
        System.debug('After adding two days : ' +mydate);
        
        if(division!=null && division.equalsIgnoreCase('IL')){
            rb.Date_to_Account__c=mydate.addDays(-79);
            rb.Date_to_GA__c=mydate.addDays(-85);
            rb.Date_to_Producer__c=mydate.addDays(-82);
            system.debug('DFrb.Date_to_Producer__c'+rb.Date_to_Producer__c);
        }
        if(division!=null && division.equalsIgnoreCase('TX')){
            rb.Date_to_Account__c=mydate.addDays(-68);
            rb.Date_to_Producer__c=mydate.addDays(-75);
        }
        if(division!=null && division.equalsIgnoreCase('MT')){
            rb.Date_to_Account__c=mydate.addDays(-68);
            rb.Date_to_Producer__c=mydate.addDays(-75);
        }
        if(division!=null && division.equalsIgnoreCase('OK')){
            rb.Date_to_Account__c=mydate.addDays(-87);
            rb.Date_to_Producer__c=mydate.addDays(-95);
        }
        if(division!=null && division.equalsIgnoreCase('NM')){
            rb.Date_to_Account__c=mydate.addDays(-7);
            rb.Date_to_Producer__c=mydate.addDays(-95);
        }
        //SFDC-14249 END
        rbList.add(rb);
        Database.SaveResult[] result=database.insert(rbList,false);
        list<String> errMsgsList=new list<String>();
        List<String> successList = new List<String>();
        for(Database.SaveResult sr : result){
            if (!sr.isSuccess()) {
                for(Database.Error err : sr.getErrors()) {
                    errMsgsList.add(err.getMessage());
                }
                createErroLog(errMsgsList,batchId);
            }
            //Vijaya 16388 
            else{                
                if(batchType == 'Batch') {
                    
                    successList.add(sr.Id);
                }
            }
            
        }
        SGR_RenewalEmailProcessor.sendRenewalEmail(successList);
        //Vijaya 16388
        system.debug('+++successList--'+successList);
        return rb;           
    }
    /*private static Integer getDaysToSubmit(String division, Date renDate){
Integer month = renDate.month();
Integer daysToSubmit = 0;
Map<String, List<SGR_Opty_Days_to_Submit__mdt>> submitDaysMap = new Map<String, List<SGR_Opty_Days_to_Submit__mdt>>();
List<SGR_Opty_Days_to_Submit__mdt> daysList = new List<SGR_Opty_Days_to_Submit__mdt>();
List<SGR_Opty_Days_to_Submit__mdt> daystoSub = new List<SGR_Opty_Days_to_Submit__mdt>();
daystoSub = [select Days_to_Submit__c, HCSC_Division__c, Start_Month__c, End_Month__c from SGR_Opty_Days_to_Submit__mdt];
for(SGR_Opty_Days_to_Submit__mdt submitDays : daystoSub){
if(submitDaysMap.get(submitDays.HCSC_Division__c).size() > 0){
List<SGR_Opty_Days_to_Submit__mdt> daysLt = submitDaysMap.get(submitDays.HCSC_Division__c);
daysLt.add(submitDays);
submitDaysMap.put(submitDays.HCSC_Division__c, daysLt);
}
else{
List<SGR_Opty_Days_to_Submit__mdt> daysLtNew = new List<SGR_Opty_Days_to_Submit__mdt>();
daysLtNew.add(submitDays);
submitDaysMap.put(submitDays.HCSC_Division__c, daysLtNew);
}

}
system.debug('+++submitDaysMap'+submitDaysMap);
if(submitDaysMap.containsKey(division)){
List<SGR_Opty_Days_to_Submit__mdt> subLst = submitDaysMap.get(division);
for(SGR_Opty_Days_to_Submit__mdt mtd : subLst){
system.debug('+++mtd.Start_Month__c--'+mtd.Start_Month__c);
system.debug('+++mtd.End_Month__c--'+mtd.End_Month__c);
if(month >= mtd.Start_Month__c && month <= mtd.End_Month__c){
daysToSubmit = Integer.valueof(mtd.Days_to_Submit__c);
break;
}
}
}
system.debug('+++daysToSubmit'+daysToSubmit);
return daysToSubmit;
}*/
    
    @AuraEnabled
    public static String createOpportunities( list<Account> acc,String renewalType,String batchType,String batchId,DAte renEffDate, Actuary_Gate__c gateRec){
        Id sgrProdOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Production Opportunity').getRecordTypeId(); 
        Id sgrAnalytOpp = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('SGR Analytical Opportunity').getRecordTypeId();
        String dateAppend;
         //--Vijaya-- 16873
        Integer daysToSubmit = 0;
        // Akbar - 2/7/2019 - E2E fix - avoiding too many DML rows on plan rate records insertion.
        opprIdList.clear();
        //List<Opportunity__c> divisionDays = new List<Opportunity__c>();
        List<SGR_Opty_Days_to_Submit__mdt> divisionDays = new List<SGR_Opty_Days_to_Submit__mdt>();
        //divisionDays = [select Days_to_Submit__c, HCSC_Division_c__c from Opportunity__c where HCSC_Division_c__c = :acc[0].HCSC_Division__c];
        divisionDays = [select Days_to_Submit__c, End_Month__c, HCSC_Division__c, Start_Month__c from SGR_Opty_Days_to_Submit__mdt where HCSC_Division__c = :acc[0].HCSC_Division__c];
        //Added list Null Check -Padma
        system.debug('++++divisionDays.size()---'+divisionDays.size());
        if(!divisionDays.isEmpty() && divisionDays.size() > 0){
            for(SGR_Opty_Days_to_Submit__mdt mdt : divisionDays){
                if(mdt.HCSC_Division__c == acc[0].HCSC_Division__c && mdt.Start_Month__c <= renEffDate.month() && mdt.End_Month__c >= renEffDate.month()){
                    daysToSubmit = Integer.valueof(mdt.Days_to_Submit__c);
                }
            }
        }
        //--Vijaya-- 16873  
        
        System.debug('Executing opps insertion'+acc);
        list<SGRRenewalBatch__c> rbList=new list<SGRRenewalBatch__c>();
        rbList=[select id,BatchID__c,Date_to_GA__c,Date_to_Account__c,Date_to_Producer__c from SGRRenewalBatch__c where BatchID__c =:batchId];
        Double bId;
        list<String> msgs=new list<STring>();
        String message;
        List<Opportunity> oppLst = new List<Opportunity>();
        list<SGR_Renewal_Batch_Oppty__c> sgopList=new list<SGR_Renewal_Batch_Oppty__c>();
        System.debug('&*&*&&**'+acc);
        oppLst.clear();
        String renDt;
        for(Account temp:acc){
            Opportunity opp=new Opportunity();
            
            // SFDC-14055 Changes Start
            // Assign Gate to Opportunity based on division, renEffDate, market segment & funding type
            if (null != gateRec) {
                opp.Gate__c = gateRec.Id;
            }
            // SFDC-14055 Changes End
            dateAppend=String.valueof(temp.Renewal_Date__c.month())+'/'+String.valueof(temp.Renewal_Date__c.day())+'/'+String.valueof(temp.Renewal_Date__c.year());
            system.debug('Date Test'+dateAppend);
            dateAppend=dateAppend.replaceAll('-', '/');
            system.debug('Date Test'+dateAppend);
            dateAppend=dateAppend.remove('00:00:00');
            system.debug('Date Test'+dateAppend);
            
            renDt=String.valueof(renEffDate.month())+'/'+String.valueof(renEffDate.day())+'/'+String.valueof(renEffDate.year());
            system.debug('Date Test'+renDt);
            renDt=renDt.replaceAll('-', '/');
            system.debug('Date Test'+renDt);
            renDt=renDt.remove('00:00:00');
            system.debug('Date Test'+renDt);
            
            system.debug('opp name'+opp.Name);
            if(batchType=='Batch'){
                opp.SGR_Opportunity_Name__c=temp.name+' '+dateAppend+' '+renewalType; 
                opp.Name=temp.name+' '+dateAppend+' '+renewalType; 
            }
            else{
                System.debug('Date after new modification'+renDt);
                opp.SGR_Opportunity_Name__c=temp.name+' '+renDt+' '+renewalType;
                opp.Name=temp.name+' '+renDt+' '+renewalType; 
            }
            
            // Urgent fixes - Offshore - 19-Jan - Start
            //opp.Region__c = temp.Region__c;
            // Urgent fixes - Offshore - 19-Jan - End
            
            system.debug('opp name'+opp.SGR_Opportunity_Name__c);
            opp.AccountId=temp.id;
            opp.EIN__c=temp.EIN__c;
            opp.Forecast_Segment__c = temp.Forecast_Segment__c;
            opp.Account_Market_Segment__c=System.label.Market_Segment;
            opp.HCSC_Division__c=temp.HCSC_Division__c;
            opp.Assigned_UW__c=UserInfo.getUserId();
            opp.Rating_Status__c='Initiated';
            system.debug('stage name'+opp.StageName);
            opp.StageName=System.label.Opportunity_Stage_Name;
            //opp.Funding_Type__c=System.label.Funding_Type;
            //SFDC-14508 (Landry) - changed opportunity funding type from hardcoded to value of corresponding account's FT
            opp.Funding_Type__c = temp.Funding_Type__c;
            //To populate Fips code
           system.debug('+++temp.County_Code__c ---'+temp.County_Code__c);
            //Integer cc = integer.valueof(temp.County_Code__c);
            /*if(cc!=null && cc< 10){
opp.FIPS_Code__c = fourzeros+string.valueof(cc);
}
else if(cc!=null && cc< 100){
opp.FIPS_Code__c = threezeros+string.valueof(cc);
}
else if(cc!=null && cc< 1000){
opp.FIPS_Code__c = twozeros+string.valueof(cc);
}            
else if(cc!=null && cc< 10000){
opp.FIPS_Code__c = onezero+string.valueof(cc);
}
else {
opp.FIPS_Code__c = string.valueof(cc);
}*/
            if(temp.County_Code__c!=null){
               String countyCode1=String.ValueOf(temp.County_Code__c);
                 String countyCode= countyCode1.removeEnd('.0');
                String zeroSet=System.Label.zeroSet;         
                Integer countyCodeAllowedLength = Integer.valueof(System.Label.countyCodeAllowedLength);
                if(countyCode.length() == 5){
                    opp.County_Code__c = String.valueOf(temp.County_Code__c);
                    opp.FIPS_Code__c = opp.County_Code__c;
                }else{
                system.debug('entered else.......');
                opp.County_Code__c = zeroSet.subString(0,countyCodeAllowedLength- countyCode.length()) + countyCode;
                opp.FIPS_Code__c = opp.County_Code__c;
                }
            }
            //opp.Assigned_UW__c='0054D000001FFfi';
            //SFDC-14515 changes start here
            if(batchType=='Batch'){
                opp.Renewal_Date__c=temp.Renewal_Date__c;
            }else{
                opp.Renewal_Date__c=renEffDate;
            }
            //SFDC-17474
            opp.Requested_Effective_Date__c = opp.Renewal_Date__c;
            //end of SFDC-17474
            //Vijaya SFDC-14337
            if(temp.Domestic_Partner__c == 'Y'){
                opp.Domestic_Partner__c= true;
                system.debug('Inside If--Y');
            }
            else{
                opp.Domestic_Partner__c=false;
                system.debug('Inside If--N');
            }
            opp.Batch_Type__c=batchType;
            opp.Batch_Id__c=batchId;
            
            /*  if(cc!=null && cc< 10){
opp.County_Code__c = fourzeros+string.valueof(temp.County_Code__c);
}
else if(cc!=null && cc< 100){
opp.County_Code__c = threezeros+string.valueof(temp.County_Code__c);
}
else if(cc!=null && cc< 1000){
opp.County_Code__c = twozeros+string.valueof(temp.County_Code__c);
}

else if(cc!=null && cc< 10000){
opp.County_Code__c = onezero+string.valueof(temp.County_Code__c);
}
else {
opp.County_Code__c = string.valueof(temp.County_Code__c);
}
*/
            
            if(renewalType=='Production'){
                // opp.RecordTypeId='0124D0000004ZM2';
                opp.RecordTypeId= sgrProdOpp;
            }
            else{
                //opp.RecordTypeId='0124D0000004arz';
                opp.RecordTypeId=sgrAnalytOpp;
                
            }
            opp.Zip_Code__c=temp.ShippingPostalCode;
            opp.CloseDate=temp.Renewal_Date__c;
            
            system.debug('close date '+ opp.CloseDate);
            system.debug(' print Opp'+opp);
            // if(flag==false){
            if(rbList!=null){
                for(SGRRenewalBatch__c sgrnew:rbList){
                    if(opp.Batch_Id__c==sgrnew.BatchID__c){
                        opp.Date_to_GA__c=sgrnew.Date_to_GA__c;
                        opp.Date_to_Account__c=sgrnew.Date_to_Account__c;
                        opp.Date_to_Producer__c=sgrnew.Date_to_Producer__c;
                    }
                }
            }
            // SFDC-16646 Changes Start
            // Set Rating_Status, WorkFlow_Activity & Workflow_System_Status fields
            opp.Rating_Status__c = 'Initiated';
            opp.SGR_Workflow_Activity__c = '';
            opp.Workflow_System_Status__c = 'Ready to Fetch Mapped Plans';
            oppLst.add(opp);
            // SFDC-16646 Changes End
            
            //--Vijaya-- 16873
            //daystoSubmit = getDaysToSubmit(acc[0].Hcsc_division__c, renEffDate);
            
            system.debug('+++daystoSubmit---'+daystoSubmit);
            opp.Submit_Date__c = opp.Renewal_Date__c - daysToSubmit;
            //--Vijaya-- 16873
            
            // }
            
        }
        system.debug(' print Opp size '+oppLst.size());
        if(oppLst.size()>0)
        {
            System.debug('no of opps'+oppLst.size());
            // if(flag==false){
            //insert oppLst; 
            Database.SaveResult[] result=database.insert(oppLst,false);
            list<String> errMsgsList=new list<String>();
            for(Database.SaveResult sr : result){
                if (!sr.isSuccess()) {
                    for(Database.Error err : sr.getErrors()) {
                        errMsgsList.add(err.getMessage());
                    }
                    createErroLog(errMsgsList,batchId);
                }else{ // Akbar - 2/7/2019 - E2E fix - avoiding too many DML rows on plan rate records insertion.
                    opprIdList.add(sr.getId());
                }
            }
            // }
            
            createRenewalBatchOpps(oppLst,batchId);
            // return 'BatchID created :'+batchId+'created for the division:'+acc[0].HCSC_Division__c+'Opportunity created:'+oppLst[0].name;
            return 'Batch ID #<strong>'+batchId+'</strong> created for <strong>'+acc[0].HCSC_Division__c+'</strong> division. <strong>';
        }
        
        //return 'Error! Active Opportunity for the Entered Account Number Already Exists '+oppLst[0].id;
        throw new SGR_Exception('Error! Active Opportunity for the Entered Account Number Already Exists :' +oppLst[0].id);
        
        //throw new AuraHandledException('Error! Active Opportunity for the Entered Account Number Already Exists :' +oppLst[0].id);
        
        
    }
    
    @AuraEnabled
    public static void createRenewalBatchOpps(list<Opportunity> oppLst,String batchId){
        System.debug('Into Opty');
        
        list<SGR_Renewal_Batch_Oppty__c> renBatOppLst=new list<SGR_Renewal_Batch_Oppty__c>();
        list<Opportunity> opps=new list<Opportunity>();
        for(Opportunity temp:oppLst){
            SGR_Renewal_Batch_Oppty__c renBatOpp=new SGR_Renewal_Batch_Oppty__c();
            renBatOpp.Batch_ID__c=batchId;
            //Nidhi: replaced accountnumber with external_ID__c
            System.debug('------->'+temp.Account.external_ID__c);
            renBatOpp.Account_Number__c=temp.Account.external_ID__c;
            renBatOpp.Opportunity__c=temp.id;
            renBatOpp.Account_Id__c=temp.AccountId;
            renBatOpp.Processing_Status__c=System.label.Opportunity_Stage_Name;
            renBatOppLst.add(renBatOpp);
        }
        
        // insert renBatOppLst;
        // done as a part of SFDC-14515 changes 
        Database.SaveResult[] result=database.insert(renBatOppLst,false);
        list<String> errMsgsList=new list<String>();
        for(Database.SaveResult sr : result){
            if (!sr.isSuccess()) {
                for(Database.Error err : sr.getErrors()) {
                    errMsgsList.add(err.getMessage());
                }
                createErroLog(errMsgsList,batchId);
            }
        }
        //SFDC-14515 changes end here
        
    }        
    
    // SFDC-14515 Re-usable method that is being called in all child data creation methods
    @AuraEnabled
    public static void createErroLog(List<String> errMsgsLst,String bidForErr){
        
        System.debug('+++Limits.getDMLRows() 1 = ' + Limits.getDMLRows());
        list<Error_Log__c> errLst=new list<Error_Log__c>();
        for(String er:errMsgsLst){
            Error_Log__c errLog=new Error_Log__c();
            errLog.Batch_Id__c=bidForErr;
            errLog.Application__c=System.label.ErrorLog_Application_TriggerOff;
            errLog.Error_Message__c=er;
            errLst.add(errLog);
        }
        system.debug('+++errLst.size()--'+errLst.size());
        if(errLst.size()>0){
            if(Limits.getDMLRows() < 8000)
                insert errLst;
        }
        System.debug('+++Limits.getDMLRows() 2 = ' + Limits.getDMLRows());
    }
    // Create event audit   
    
    @AuraEnabled
    public static void createEventAuditLog(list<opportunity> opplist,string eventType, string eventmsg)
    {
        system.debug('came into Audit');
        EventAuditTrail__c ev = new EventAuditTrail__c();
        ev.Event_Message__c=eventmsg;
        ev.Event_Type__c=eventType;
        ev.Opportunity__c=opplist[0].id;
        
        insert ev;
        
    }
    
    
    
    
    
    
    
    // SFDC-14515 changes Ends Here
    
    @AuraEnabled
    public static void createErrorLog(list<Account> accLst,String batchId){
        System.debug('Executing error log method');
        Integer i=0;
        
        list<Error_Log__c> errLst=new list<Error_Log__c>();
        set<id> accid = new set<id>();
        for(account a:accLst){
            
            accid.add(a.id);
        }
        list<Account> accToOpp= [select id ,Renewal_Date__c, (select id,name,stageName,Renewal_Date__c from Opportunities where SGR_Opportunity_Type__c='Production') from account where id IN: accid]; 
        
        for(Account temp:accToOpp){
            System.debug('$$$$$$$'+temp);
            for(Opportunity op:temp.Opportunities){
                System.debug('$#$#$#$#'+op);
                if(op.stageName!='won'){
                    if(op.stageName!='Lost'){
                        if(op.Renewal_Date__c==temp.Renewal_Date__c){
                            Error_Log__c errLog=new Error_Log__c();
                            errLog.Batch_Id__c=batchId;
                            errLog.Application__c=System.label.ErrorLog_Application_Name;
                            errLog.Account_Id__c=temp.id;
                            errLog.Account_Idl__c=temp.id;
                            errLog.Opportunity_Id__c=op.id;
                            errLog.Opportunity_Idl__c=op.id;
                            System.debug('errrrrrrrrrrrrr'+errLog);
                            errLog.Error_Message__c='Multiple production Opportunities are not allowed for the same account and renewal date. Production Opportunity #'+op.name+'Already Exists';
                            i++;
                            errLst.add(errLog);
                            
                        }}}
            }
            
        }
        System.debug('almost done'+errLst);
        // System.debug('printing flag'+flag);
        if(errLst.size()>0){
            
            //insert errLst;
            database.insert(errLst,false);
            
        }
        
        
    }
    
    @AuraEnabled
    public static String validateRenewalEffectiveDate(String marketSegment, String fundingType, String batchType, String renewalType, String division, Date renEffDate) {
        
        
        String profileName = [SELECT ID,profile.name FROM User WHERE ID=:UserInfo.getUserId()].profile.Name;
        String result = '';
        Map<String,String> divisionMap = new Map<String,String>();
        for(Division_Mapping__mdt mdt : [SELECT ID,MasterLabel,Config_Division__c FROM Division_Mapping__mdt]){
            divisionMap.put(mdt.MasterLabel,mdt.Config_Division__c);
        }
        
        List<SGR_Renewal_Date_Configuration__c> configData = [SELECT ID,Market_Segment__c,Prior_Current_Date__c,Post_Current_Date__c,Minimum_Renewal_Date__c ,Maximum_Renewal_Date__c,Division__c,Funding_Type__c,Trigger_Type__c,Renewal_Type__c,Group__c FROM SGR_Renewal_Date_Configuration__c WHERE Market_Segment__c=:marketSegment AND Division__c=:divisionMap.get(division) AND
                                                              Funding_Type__c=:fundingType AND Trigger_Type__c=:batchType AND Renewal_Type__c=:renewalType];
        system.debug('+++configData'+configData);
        for(SGR_Renewal_Date_Configuration__c config : configData){
            if(configData.size()>0 && ((config.Group__c=='Actuary' && profileName=='SGR Actuary User') || (config.Group__c=='Underwriting' && profileName=='SGR UW User'))){
                system.debug('+++config'+config);
                Integer priorDate = (Integer)config.Prior_Current_Date__c*(-1);
                if(renEffDate.Year()==configData[0].Minimum_Renewal_Date__c.Year()){
                    if(!(renEffDate.Month()>=configData[0].Minimum_Renewal_Date__c.Month() && renEffDate.Month()<=configData[0].Maximum_Renewal_Date__c.Month())){
                        result = label.Error_for_Trigger_Batch_Validation;
                    }
                }
                else if(renEffDate.Year()>configData[0].Minimum_Renewal_Date__c.Year()){
                    if(!(renEffDate.Year()<=configData[0].Maximum_Renewal_Date__c.Year())){
                        result = label.Error_for_Trigger_Batch_Validation;
                    }
                }
                if(!(renEffDate.toStartOfMonth()>=System.Today().addDays(priorDate) && renEffDate.toStartOfMonth()<=System.Today().addDays((Integer)config.Post_Current_Date__c))){
                    result = label.Error_for_Trigger_Batch_Validation;
                } 
            }
        }
        return result;
    }
    
    public static void addBAGSAssignments(set<String> accNums, String bidErr) {
        list<Group_Section__c> gsList = new List<Group_Section__c>();
        gsList = [select id, Benefit_Agreement__c from Group_Section__c where Group_Account__r.External_ID__c in :accNums order by Group_Number__c ];
        List<BA_GS_Assignment__c> bagsList = new List<BA_GS_Assignment__c>();
        for(Group_Section__c gs : gsList) {
            BA_GS_Assignment__c bags = new BA_GS_Assignment__c();
            bags.Group_Section__c = gs.id;
            bags.Benefit_Agreement__c = gs.Benefit_Agreement__c;
            bags.External_ID__c = String.valueOf(gs.id)+'-'+String.valueOf(gs.Benefit_Agreement__c);
            bagsList.add(bags);
        }
        if(!bagsList.isEmpty()){
            try{
                Database.SaveResult[] result=database.insert(bagsList,false);
                list<String> errMsgsList=new list<String>();
                for(Database.SaveResult sr : result){
                    if (!sr.isSuccess()) {
                        for(Database.Error err : sr.getErrors()) {
                            errMsgsList.add(err.getMessage());
                        }
                        //createErroLog(errMsgsList,bidErr);
                    }
                }
                //  }
            }
            catch(exception e){
                system.debug('Exception Occured'+e);
            }
        }
    }    
    
    //Tarun 01/02/2019 : Changed method return type as a part of E2E Fixes
    Public static map<id,list<SGR_Opportunity_Benefit_Agreement__c>> insertOpportunitiesBenefitAgreement(set<id> ID,list<Opportunity> ossTr,String bidErr){
        Set<Id> accId = new Set<Id>();
        if(ID!=null || !ID.isEmpty()){
            accID = ID;
        }
        map<id,list<SGR_Opportunity_Benefit_Agreement__c>> opBenMap=new map<id,list<SGR_Opportunity_Benefit_Agreement__c>>();
        Set<String> baPlanSet =new Set<String>();//set of Ba Market Plan number
        list<SGR_Opportunity_Benefit_Agreement__c> opBenList = new list<SGR_Opportunity_Benefit_Agreement__c>();
               
        Map<id,list<Benefit_Agreement__c>> aChild = new Map<id,list<Benefit_Agreement__c>>();
        list<Account> accs = [select Id,(select id,Name,Market_Plan_Number__c,Benefit_Agreement_Number__c,Product__c,Renewal_Date__c,Renewal_Month__c,Region_Code__c,
                                         Funding_Type__c,Premium_Type__c,Effective_Date__c,Status__c,Insurance_Type_Code__c, End_Date__c,
                                         Cancellation_Code__c,ACA_Indicator__c,Cancellation_Date__c, Plan__c From Benefit_Agreements__r)
                              from Account where Id In : accId];
        System.debug('Initial Check:'+accs);
        for(Account a:accs)
        {
            if(aChild.get(a.id)==Null){
                aChild.put(a.ID,new List<Benefit_Agreement__c>{});
            }
            if(aChild.get(a.id)!=Null){
                
                list<Benefit_Agreement__c> baList=a.Benefit_Agreements__r;
                
                if(baList!=null && !baList.isEmpty()){
                  aChild.get(a.id).addall(baList);//a.Benefit_Agreements__r);
                 for(Benefit_Agreement__c ba:baList){//MC: collect mpn
                    baPlanSet.add(ba.Market_Plan_Number__c);
                 }
               }
            }
        }
        
       //MC: find plan object for Plan__ from Benefit Agreement by the Marketing plan number
        system.debug('Benefit Agreement Plan Marketing Plan Numbers set::'+baPlanSet);
        Map<String,Id> baPlanMap=new Map<String,Id>();
        
        if(baPlanSet!=null && !baPlanSet.isEmpty()){
            list<Plan__c> baPlans =[select Id, Marketing_Plan_Number__c from Plan__c where Marketing_Plan_Number__c in: baPlanSet];
            system.debug(' Benefit Agreement Plans::'+baPlans);
            if(baPlans!=null && !baPlans.isEmpty()){
                for(Plan__c p:baPlans){
                    baPlanMap.put(p.Marketing_Plan_Number__c, p.Id);
                }
            }
        }
        //--------------------------------------------
         List<Opportunity> opps=ossTr;
        for(Opportunity op:opps ){
             //Tarun 01/02/2019     
            list<SGR_Opportunity_Benefit_Agreement__c> opBenListForMap = new list<SGR_Opportunity_Benefit_Agreement__c>();
            opBenListForMap.clear();
            if(!aChild.isEmpty())
                system.debug('***Map****'+aChild);
            
            list<Benefit_Agreement__c> blist = aChild.get(op.accountID);
            if(blist!=null && blist.size()>0){
                
                for(Benefit_Agreement__c b:blist){
                if((b.Cancellation_Date__c > op.Renewal_Date__c || b.Cancellation_Date__c==NULL) && (b.Status__c=='Active')){
                    SGR_Opportunity_Benefit_Agreement__c oppBa = new SGR_Opportunity_Benefit_Agreement__c();
                    
                    oppBa.Opportunity__c = op.Id;
                    oppBa.name=b.name;
                    if(b.Benefit_Agreement_Number__c != null){
                        oppBa.Benefit_Agreement_Number__c=b.Benefit_Agreement_Number__c;
                    }
                    oppBa.Funding_Type__c = b.Funding_Type__c;
                    oppBa.Premium_Type__c = b.Premium_Type__c;
                    oppBa.Effective_Date__c = b.Effective_Date__c;
                    oppBa.Product__c=b.Product__c;
                    oppBa.Renewal_Date__c=b.Renewal_Date__c;
                    oppBa.Status__c=b.Status__c;
                    oppBa.Insurance_Type_Code__c= b.Insurance_Type_Code__c ;   
                    //Region Code added - Padma
                    oppBa.Region_Code__c = b.Region_Code__c;
                    // Urgent fixes - Offshore - 20-Jan - Start
                    // opp.Plan1__c = b.Plan__c;//alway empty
                    oppBa.Plan1__c =baPlanMap.get(b.Market_Plan_Number__c);// MC: updated to find plan by the Marketing plan Number
                    oppBa.Rate_Effective_Date__c = b.Effective_Date__c;
                    oppBa.Rate_End_Date__c = b.End_Date__c;
                    // Urgent fixes - Offshore - 20-Jan - End
                    oppBa.ACA_Indicator__c = b.ACA_Indicator__c;
                    oppBa.Cancellation_Date__c = b.Cancellation_Date__c;
                    oppBa.Include_BA__c=('Active'.equalsignorecase(oppBa.Status__c)?true:false);
                    opBenList.add(oppBa);
                    opBenListForMap.add(oppBa);
                }
                }
                
            }
            //Tarun 01/02/2019 
             opBenMap.put(op.id,opBenListForMap);
            
        }
        
        if(!opBenList.isEmpty()){
            try{
                //  if(flag==false){
                //Insert opBenList;
                Database.SaveResult[] result=database.insert(opBenList,false);
                list<String> errMsgsList=new list<String>();
                for(Database.SaveResult sr : result){
                    if (!sr.isSuccess()) {
                        for(Database.Error err : sr.getErrors()) {
                            errMsgsList.add(err.getMessage());
                        }
                        createErroLog(errMsgsList,bidErr);
                    }
                }
                //  }
            }
            catch(exception e){
                system.debug('Exception Occured'+e);
            }
        }
        //Tarun 01/02/2019 : Added return type as a part of E2E Fixes
         return opBenMap;
    }
    Public static void insertOpportunitiesCencus(set<id> ID,list<Opportunity> ossTr,String bidErr){
        
        list<opportunity> opps1 = ossTr;
        set<Id> oppIdSet=new set<Id>();
        id oppId;
        for(Opportunity temp:opps1){
            oppId=temp.id;
            oppIdSet.add(oppId);
        }
        Set<Id> accId = new Set<Id>();
        if(ID!=null || !ID.isEmpty())
            accID = ID;
        list<SGR_Opportunity_Census__c> opBenList = new list<SGR_Opportunity_Census__c>();
        set<Opportunity> oppset = new set<Opportunity>();
        List<Opportunity> opplist=new List<Opportunity>();
        //SFDC-14982:Opportunity Census Object has GS lookups and that needs to change them to opp group section
        map<String,Id>  OppGSmap = new map<String,Id>();
        
        //Gather Census who are related to Active Benefit Agreements only -- Fix 18th Feb 2019 - By Anil Kamisetty
        Set<Id> censusIds = new Set<Id>();
        List<SGR_Account_Member_Benefit__c> accMemBnftLst = [Select ID, Name,Account_Census__c from SGR_Account_Member_Benefit__c where Benefit_Agreement__r.Status__c ='Active' and Group_Section__r.Id in :accid and Account_Census__c != null ];
        for (SGR_Account_Member_Benefit__c amb: accMemBnftLst) {        
            censusIds.add(amb.Account_Census__c);
        }
        
        //Added additional columns in Census and Member Benefits -- Anil Kamisetty 29 Jan 2019
        Map<id,list<SGR_Account_Census__c>> aChild = new Map<id,list<SGR_Account_Census__c>>();
        List<Account> accs1=[select Id,Renewal_Date__c  ,(Select Id,name,Acc_Census_External_Id__c,Account__c,Composite_Rates__c,Date_of_Birth__c,Dental_Plan_ID__c,Dental_Tier__c,Employee_Status_Code__c,First_Name__c,Gender__c,Group_Number__c,Group_Section_Number__c,Group_Section_Number__r.name,Dental_Policy_Tier__c, Health_Policy_Tier__c, Vision_Policy_Tier__c ,
                                                          Health_Plan_ID__c,Health_Tier__c,Last_Name__c,Medicare_Primary__c,Member_Benefit_Cancel_Date__c,Member_Benefit_Effective_Date__c,Member_Cancel_Date__c,Member_Characteristic_Type__c,Member_Effective_Date__c,Member_Rates__c,Membership_Number__c,Plan_Name__c,Relationship__c,Relationship_Code__c,Row__c,State__c,Subscriber_Number__c,Tobacco_Use__c,Total_Number_of_Dental_Subscribers__c,Total_Number_of_Health_Subscribers__c,Vision_Plan_ID__c,Vision_Tier__c ,Zip_Code__c
                                                          From Account_Censuses__r where Id in :censusIds), (Select Id, Account_Census__c, Account__c, Insurance_Type_Code__c, Marketing_Plan_Number__c, Supplemental_Insurance_type_Code__c,
                                                          Account_Census__r.Account__r.Renewal_Date__c, Account_Census__r.Name, Account_Census__r.Member_Cancel_Date__c, Account_Census__r.Member_Effective_Date__c, User_Display_Group_Number__c, User_Display_Section_Number__c
                                                          from Account_Member_Benefits__r where Account_Census__c in :censusIds)
                             from Account where (Id In : accId)   ];        
        
        List<Account> accs2 = new List<Account>();
        
        System.debug('within census method, printing accs'+accs1);
        //SFDC-14982:Opportunity Census Object has GS lookups and that needs to change them to opp group section
        list<SGR_Opportunity_Group_Section__c> OPPGSList=[SELECT Id, Name,Group_Name__c, Opportunity__r.accountID FROM SGR_Opportunity_Group_Section__c where Opportunity__c IN:oppIdSet];
        system.debug('OPPGSList'+OPPGSList);
        if(OPPGSList!=null && !OPPGSList.isEmpty()){
            for(SGR_Opportunity_Group_Section__c OppGS :OPPGSList )
            {
                OppGSmap.put(OppGS.Name.toUpperCase()+OppGS.Opportunity__r.accountID, OppGS.id);
            }
        }
        system.debug(OppGSmap+'OppGSmapCensus');
        
        //Prepare Map of Account Census and Account Member Benefits
       Map<Id,list<SGR_Account_Member_Benefit__c>> acntCensusMemBenftMap = new Map<id,list<SGR_Account_Member_Benefit__c>>();
        
        for(Account a:accs1 )
        {
            if(aChild.get(a.id)==Null){
                aChild.put(a.ID,new List<SGR_Account_Census__c>{});
            }
            
            if(aChild.get(a.id)!=Null)
            {
                //Dont copy everything. Copy what's active -- Anil Kamisetty 27 Jan 2019
                //aChild.get(a.id).addall(a.Account_Censuses__r);
                if(a.Account_Censuses__r != null)//List not null
                if(a.Account_Censuses__r.size() > 0)//List not empty
                for(SGR_Account_Census__c c:a.Account_Censuses__r)
                if((c.Member_Cancel_Date__c > a.Renewal_Date__c || c.Member_Cancel_Date__c==NULL)  && c.Member_Effective_Date__c < a.Renewal_Date__c) 
                {
                    aChild.get(a.id).add(c); // Add the Census
                }
            }
            
            for(SGR_Account_Member_Benefit__c amb :a.Account_Member_Benefits__r)
                if(amb.Account_Census__c != null) // Ensure the field is not null
                //Create if the Account Census is Active -- Anil Kamisetty 27 Jan 2019
                if((amb.Account_Census__r.Member_Cancel_Date__c > amb.Account_Census__r.Account__r.Renewal_Date__c || amb.Account_Census__r.Member_Cancel_Date__c == null) && amb.Account_Census__r.Member_Effective_Date__c < amb.Account_Census__r.Account__r.Renewal_Date__c) // Account Census is Active
                if(amb.Marketing_Plan_Number__c <> '') // Marketing Plan filled in
            {
                if(acntCensusMemBenftMap.get(amb.Account_Census__c) == null) // Element does not exist, add the element
                    acntCensusMemBenftMap.put(amb.Account_Census__c,new List<SGR_Account_Member_Benefit__c>{});                 
                
                if(acntCensusMemBenftMap.get(amb.Account_Census__c) != null) // Element does exist
                    acntCensusMemBenftMap.get(amb.Account_Census__c).add(amb);
            }
        }
        
        //Get all the Relationship Mapping
        Map<string, SGR_Relationship_Mapping__c> relMap = SGR_Relationship_Mapping__c.getall();      
                
        for(Opportunity op:opps1){
            integer HealthCount=0;
            integer DentalCount=0;
            
            if(!aChild.isEmpty())
                system.debug('census creation for new Opp:'+aChild);
            
            list<SGR_Account_Census__c> blist = aChild.get(op.accountID);
            if(blist!=null && blist.size()>0){
                for(SGR_Account_Census__c c:blist){
                    boolean Healthcountdone=false;
                    boolean dentalcountdone=false;
                    System.debug('Account Census Record : ' + c);
                    SGR_Opportunity_Census__c oppcen = new SGR_Opportunity_Census__c();
                    if((c.Member_Cancel_Date__c > op.Renewal_Date__c || c.Member_Cancel_Date__c==NULL)  && c.Member_Effective_Date__c < op.Renewal_Date__c) {
                        system.debug('Santosh test passed');
                        oppcen.name=c.name;
                        oppcen.Acc_Census_External_Id__c =c.Acc_Census_External_Id__c;
                        oppcen.Opportunity__c = op.id;
                        System.debug('Opp lookup Id :'+oppcen.Opportunity__c+'Before assigning to it'+op.id);
                        oppcen.Account__c = c.Account__c;
                        oppcen.Composite_Rates__c = c.Composite_Rates__c;
                        oppcen.Date_of_Birth__c= c.Date_of_Birth__c;
                        
                        oppcen.Employee_Status_Code__c = c.Employee_Status_Code__c;
                        oppcen.First_Name__c= c.First_Name__c;
                        oppcen.Gender__c = c.Gender__c;
                        oppcen.Group_Number__c = c.Group_Number__c;
                        oppcen.Group_Section_Number__c= c.Group_Section_Number__c;
                        system.debug(c.Group_Section_Number__r.Name+'c.Group_Section_Number__r.Name');
                        //SFDC-14982:Opportunity Census Object has GS lookups and that needs to change them to opp group section
                        system.debug('OppGSmap'+OppGSmap);
                        if(OppGSmap!=null && !OppGSmap.isEmpty()){
                            system.debug('Test14982'+c.Group_Section_Number__r.Name);
                            if(c.Group_Section_Number__r.Name != null)
                            {
                                if(OppGSmap.containsKey(c.Group_Section_Number__r.Name.toUpperCase()+op.accountID))
                                {
                                    system.debug('Test14982V1'+c.Group_Section_Number__r.Name);
                                    oppcen.Opportunity_Group_Section__c = OppGSmap.get(c.Group_Section_Number__r.Name.toUpperCase()+op.accountID);
                                } 
                            }
                        } 
                        
                        oppcen.Last_Name__c= c.Last_Name__c;
                        oppcen.Medicare_Primary__c= c.Medicare_Primary__c;
                        oppcen.Member_Benefit_Cancel_Date__c = c.Member_Benefit_Cancel_Date__c;
                        oppcen.Member_Benefit_Effective_Date__c = c.Member_Benefit_Effective_Date__c;
                        oppcen.Member_Cancel_Date__c= c.Member_Cancel_Date__c;
                        oppcen.Member_Characteristic_Type__c= c.Member_Characteristic_Type__c;
                        oppcen.Member_Effective_Date__c= c.Member_Effective_Date__c;
                        oppcen.Member_Rates__c = c.Member_Rates__c;
                        oppcen.Membership_Number__c= Decimal.valueOf(c.Membership_Number__c);
                        oppcen.Plan_Name__c= c.Plan_Name__c;
                        
                         //oppcen.Relationship__c = c.Relationship__c;
                        if(c.Relationship_Code__c != '')
                        if(relMap.get(c.Relationship_Code__c) != null)
                            oppcen.Relationship__c = relMap.get(c.Relationship_Code__c).Census_Relationship__c;
                        
                        oppcen.Relationship_Code__c = c.Relationship_Code__c;
                        oppcen.Row__c= String.valueOf(c.Row__c);
                        oppcen.State__c = c.State__c;
                        oppcen.Subscriber_Number__c=(null != c.Subscriber_Number__c)?Integer.valueof(c.Subscriber_Number__c):null; 
                        //oppcen.Subscriber_Number__c=integer.valueof(c.Subscriber_Number__c);
                        oppcen.Tobacco_Use__c= c.Tobacco_Use__c;
                        oppcen.Total_Number_of_Dental_Subscribers__c = c.Total_Number_of_Dental_Subscribers__c;
                        oppcen.Total_Number_of_Health_Subscribers__c = c.Total_Number_of_Health_Subscribers__c;
                        
                        
                        oppcen.Zip_Code__c= string.valueof(c.Zip_Code__c);//changes made while data type is changed from Text to Number
                        
                        //Logic to populate Plan Id is given below
                        //Health Plan Id <- (Use Account_Member_Benefit__c.Marketing_Plan_Number__c WHERE Insurance_Type_Code__c = 'H' AND Supplemental_Insurance_Type_Code__c NOT IN ('V1','V2'))
                        //Dental Plan Id <- (Use Account_Member_Benefit__c.Marketing_Plan_Number__c WHERE Insurance_Type_Code__c = 'D')
                        //Vision Plan Id <- (Use Account_Member_Benefit__c.Marketing_Plan_Number__c WHERE Insurance_Type_Code__c = 'H'WHERE Insurance_Type_Code__c = 'H' AND Supplemental_Insurance_Type_Code__c IN ('V1','V2'))
                        
                        if(acntCensusMemBenftMap.get(c.Id) == null) // Member Benefit records does not exist
                        {
                            oppcen.Dental_Plan_ID__c = '';
                            oppcen.Health_Plan_ID__c = '';
                            oppcen.Vision_Plan_ID__c = '';
                        }
                        else
                        {
                            if(acntCensusMemBenftMap.get(c.Id).size()>0) // Elements Exists
                            {
                                for(SGR_Account_Member_Benefit__c amb :acntCensusMemBenftMap.get(c.Id))
                                {
                                    if(amb.Insurance_Type_Code__c == 'H' && (amb.Supplemental_Insurance_Type_Code__c == '' || amb.Supplemental_Insurance_Type_Code__c == null))
                                        oppcen.Health_Plan_ID__c = amb.Marketing_Plan_Number__c ;
                                     if (oppcen.Relationship__c == 'Subscriber' && oppcen.Health_Plan_ID__c!=null && !Healthcountdone) {
                                            HealthCount++;
                                          Healthcountdone=true;
                                         oppcen.Health_Group_Number__c = amb.User_Display_Group_Number__c;
                                        oppcen.Health_Group_Section__c = amb.User_Display_Section_Number__c;
                                        }
                                    if(amb.Insurance_Type_Code__c == 'D')
                                        oppcen.Dental_Plan_ID__c = amb.Marketing_Plan_Number__c ;
                                   if (oppcen.Relationship__c == 'Subscriber' && oppcen.Dental_Plan_ID__c!=null && !dentalcountdone) {
                                            DentalCount++;
                                       dentalcountdone=true;
                                       oppcen.Dental_Group_Number__c = amb.User_Display_Group_Number__c;
                                        oppcen.Dental_Group_Section__c = amb.User_Display_Section_Number__c;
                                        }
                                    if(amb.Insurance_Type_Code__c == 'H' && (amb.Supplemental_Insurance_Type_Code__c == 'V1' || amb.Supplemental_Insurance_Type_Code__c == 'V2'))
                                        oppcen.Vision_Plan_ID__c = amb.Marketing_Plan_Number__c ;
                                        oppcen.Vision_Group_Number__c = amb.User_Display_Group_Number__c;
                                        oppcen.Vision_Group_Section__c = amb.User_Display_Section_Number__c;
                                  
                                }
                            }
                        }
                        /* tiers */
                        oppcen.Health_Tier__c = c.Health_Policy_Tier__c;
                        oppcen.Dental_Tier__c = c.Dental_Policy_Tier__c;
                        oppcen.Vision_Tier__c = c.Vision_Policy_Tier__c;
                        
                         
                        system.debug('demo dental comp'+oppcen.Dental_comp__c);
                        //  if(oppcen.Dental_Plan_ID__c!=null ){
                        //   oppcen.Dental_Coverage__c=true;
                        //  }
                        //  if(oppcen.Health_Plan_ID__c!=null){
                        //        oppcen.Health_Coverage__c=true;
                        //  }
                        //    if(oppcen.Vision_Plan_ID__c!=null){
                        //    oppcen.Vision_Coverage__c=true;
                        //  }
                        oppcen.Backend_Created__c=true;
                        opBenList.add(oppcen);
                       
                        System.debug('New Opportunity Census = ' + oppcen);
                        System.debug('opBenList'+opBenList);
                    }
                }
               op.Health_Count__c = HealthCount;
                op.Dental_Count__c = DentalCount;
                op.Subscribers_Count__c = HealthCount + DentalCount;
                opplist.add(op);
            }
        }
          System.debug('opplist::'+ opplist);
       update opplist;
        opplist.clear();
    
        if(!opBenList.isEmpty()){
            try{
                //  if(flag==false){
                //Insert opBenList;
                System.debug('opBenList'+opBenList);
                
                Database.SaveResult[] result= database.insert(opBenList,false);
                list<String> errMsgsList=new list<String>();
                for(Database.SaveResult sr : result){
                    if (!sr.isSuccess()) {
                        for(Database.Error err : sr.getErrors()) {
                            errMsgsList.add(err.getMessage());
                        }
                        // createErroLog(errMsgsList,bidErr);
                    }
                }
                //  }
            }
            catch(exception e){
                CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'Case', null, 'SGR_AccountRenewalsHelper.insertOpportunitiesCencus','High');  
                system.debug('Exception Occured'+e);
            }
        }
    }
    public static void insertOptyPlanCompRate(Set<ID> planRateIDs){
        List<SGR_Opportunity_Plan_Rate__c> planRates = [Select Id, Member_Premium__c, ACA_Fee__c from SGR_Opportunity_Plan_Rate__c where ID IN : planRateIDs];
        List<SGR_Opportunity_Plan_Composite_Rate__c> optyCompPlanRates = new List<SGR_Opportunity_Plan_Composite_Rate__c>();
        for(SGR_Opportunity_Plan_Rate__c planRate : planRates){
            
            SGR_Opportunity_Plan_Composite_Rate__c compPlanRateEO = createCompPlanRate(planRate, 'EO');
            optyCompPlanRates.add(compPlanRateEO);
            SGR_Opportunity_Plan_Composite_Rate__c compPlanRateES = createCompPlanRate(planRate, 'ES');
            optyCompPlanRates.add(compPlanRateES);
            SGR_Opportunity_Plan_Composite_Rate__c compPlanRateEC = createCompPlanRate(planRate, 'EC');
            optyCompPlanRates.add(compPlanRateEC);
            SGR_Opportunity_Plan_Composite_Rate__c compPlanRateEF = createCompPlanRate(planRate, 'EF');
            optyCompPlanRates.add(compPlanRateEF);
            
        }
        system.debug('+++optyCompPlanRates.size()--'+optyCompPlanRates.size());
        if(optyCompPlanRates.size() > 0)
            insert optyCompPlanRates;
        
    }
    private static SGR_Opportunity_Plan_Composite_Rate__c createCompPlanRate(SGR_Opportunity_Plan_Rate__c planRate, String tier){
        SGR_Opportunity_Plan_Composite_Rate__c optyCompPlanRate = new SGR_Opportunity_Plan_Composite_Rate__c();
        optyCompPlanRate.Gross_Premium__c = planRate.Member_Premium__c;
        optyCompPlanRate.Name = 'Comp';
        optyCompPlanRate.Opportunity_Plan_Rate__c = planRate.Id;
        optyCompPlanRate.ACA_Fees__c = planRate.ACA_Fee__c;
        optyCompPlanRate.Tier_Code__c = tier;
        return optyCompPlanRate;
    }
    
    //Tarun 01/02/2019 : Added extra parameter as a part of E2E Fixes
    Public static void insertOpportunitiesPlanRate(set<id> accIDs,list<Opportunity> ossTr,String bidErr,map<id,list<SGR_Opportunity_Benefit_Agreement__c>> opBenMap){
        
        set<Id> oppIdSet=new set<Id>();
        //List<SearchFIPS__c> fipsCode;
        //Set<String> fipsCodes = new Set<String>();
        //List<SGR_Plan_FIPS_Map__c> fipsPlans;
        Set<String> fipsCodes = new Set<String>();
        Set<String>marketingPlanIdsSet=new Set<String>();
        if(ossTr.size()> 0){
            for(Opportunity opty : ossTr){
                oppIdSet.add(opty.id);
                fipsCodes.add(opty.FIPS_Code__c);
            }
            //SearchFIPS__c fipsCode = [select State__c, ZipCode__c, FIPS_Code__c  from SearchFIPS__c where State__c = :ossTr[0].HCSC_Division__c Limit 1];
            List<SGR_Plan_FIPS_Map__c> fipsPlans = [Select Id, Effective_Date__c, FIPS_Code__c, Plan__c, Plan__r.Marketing_Sales_Plan_ID__c,plan__r.Marketing_Plan_Number__c,  Plan__r.Plan_Sales_ID__c from SGR_Plan_FIPS_Map__c where FIPS_Code__c IN : fipsCodes AND Division__c = :ossTr[0].HCSC_division__c];
            
            Map<ID, List<SGR_Plan_FIPS_Map__c>> fipPlansMap = new Map<ID, List<SGR_Plan_FIPS_Map__c>>();
            for(Opportunity opty : ossTr){
                List<SGR_Plan_FIPS_Map__c> effectiveFipsPlans = new List<SGR_Plan_FIPS_Map__c>();
                for(SGR_Plan_FIPS_Map__c fipsPlan : fipsPlans){
                    if(fipsPlan.Effective_Date__c == opty.Renewal_Date__c && fipsPlan.FIPS_Code__c == opty.FIPS_Code__c){
                        effectiveFipsPlans.add(fipsPlan);
                    }
                }
                fipPlansMap.put(opty.Id, effectiveFipsPlans);
                
            }
            system.debug('+++fipPlansMap--' + fipPlansMap);     
            
            list<SGR_Opportunity_Plan_Rate__c> opBenList = new list<SGR_Opportunity_Plan_Rate__c>();
            
            Map<id,list<SGR_Account_Plan_Rate__c>> aChild = new Map<id,list<SGR_Account_Plan_Rate__c>>();
            Map<String,Id> OppGSmap= new Map<String,Id>();
            //SFDC-14982:Added Group_SectionLK_Key__r.Name to the Query
            //Change on SOQL as a part of Integration e2e Testing : Mei Chen - Start
            List<Account> accs2 = [select Id, ShippingPostalCode, (select id,name,AccountLK_Key__c,Benefit_Agreement__r.Status__c,Acc_Plan_Rate_External_Id__c,Funding_Type__c,Group_Number__c,Benefit_Agreement_Cancel_Date__c,
                                                                   Benefit_Agreement_Effective_Date__c,Benefit_Agreement_End_Date__c,Benefit_Agreement_Number__c,Benefit_Agreement_Renewal_Date__c,
                                                                   Cancel_Code__c,Corporate_Product_Name__c,Corporate_Product_Number__c,Group_Name__c,Group_SectionLK_Key__c,
                                                                   Group_SectionLK_Key__r.Name,Group_Section_Cancel_Date__c,Group_Section_Number__c,Group_Section_Original_Effective_Date__c, ACA_Fee__c,
                                                                   Group_Section_Renewal_Date__c,isInvitro__c,Marketing_Plan_ID__c,isMaternity__c,Member_Rate__c,Rate_Effective_Date__c,Group_Account__c,
                                                                   Sales_Plan_ID__c,Tier_Agreement_Sequence_Number__c,Benefit_Agreement__r.name,Tier_Number__c,Member_Premium__c,Health_Rating_Area_Number__c,Plan__r.Name, Rate_Type_Code__c, Plan__c,plan__r.id,plan__r.Marketing_Plan_Number__c, Benefit_Agreement_Rate_Effective_Date__c
                                                                   From SGR_Plan_Rates_Account__r) from Account where Id In : accIDs];        
            //Change on SOQL as a part of Integration e2e Testing : Mei Chen - End
            
            //SFDC-14982:For Getting Group_Section__c value to opportunity GS--Start
            list<SGR_Opportunity_Group_Section__c> OPPGSList=[SELECT Id, Name,Group_Name__c, Opportunity__r.accountID FROM SGR_Opportunity_Group_Section__c where Opportunity__c IN:oppIdSet] ;
            
            for(SGR_Opportunity_Group_Section__c OppGS :OPPGSList )
            {
                OppGSmap.put(OppGS.Name.toUpperCase()+OppGS.Opportunity__r.accountID, OppGS.id);
            }
            Map<id,Map<String, List<SGR_Account_Plan_Rate__c>>> accPlanRateMap = new Map<id,Map<String, List<SGR_Account_Plan_Rate__c>>>();
            Map<Id, List<SGR_Account_Plan_Rate__c>> accPRLst = new Map<Id, List<SGR_Account_Plan_Rate__c>>();
            
            //For generating the Map per Plan Id
            for(Account a:accs2){
                Map<String, List<SGR_Account_Plan_Rate__c>> planRatesMap = new Map<String, List<SGR_Account_Plan_Rate__c>>(); 
                for(SGR_Account_Plan_Rate__c planRate : a.SGR_Plan_Rates_Account__r){
                    
                    if(planRate!=null){
                        
                        if(planRatesMap.get(planRate.Marketing_Plan_ID__c) == null){//c
                            List<SGR_Account_Plan_Rate__c> planRateEmptyLst = new List<SGR_Account_Plan_Rate__c>();
                            planRateEmptyLst.add(planRate);
                            String planId = planRate.Marketing_Plan_ID__c;//c
                            if(planId != null && planId != '')//c
                                planRatesMap.put(planRate.Marketing_Plan_ID__c, planRateEmptyLst);//c
                        }    
                        else{
                            
                            if(planRatesMap.get(planRate.Marketing_Plan_ID__c).size() > 0){//c
                                continue;
                            }
                            else{                    
                                List<SGR_Account_Plan_Rate__c> planRateLst = planRatesMap.get(planRate.Marketing_Plan_ID__c);//c
                                planRateLst.add(planRate);
                                planRatesMap.put(planRate.Marketing_Plan_ID__c, planRateLst);//c
                            }    
                        }
                        system.debug('+++planRatesMap--' + planRatesMap);
                        accPlanRateMap.put(a.Id, planRatesMap);
                        marketingPlanIdsSet=planRatesMap.keySet();
                    }
                }
            }
            system.debug('+++accPlanRateMap--' + accPlanRateMap);
            
            system.debug('marketingPlanIdsSet::'+marketingPlanIdsSet);
            
            //SFDC-14982:For Getting Group_Section__c value to opportunity GS--End      
            List<SGR_Account_Plan_Rate__c> aprList = new List<SGR_Account_Plan_Rate__c>();        
            for(Account a:accs2 )
            {
                if(aChild.get(a.id)==Null){
                    aChild.put(a.ID,new List<SGR_Account_Plan_Rate__c>{});
                }
                
                if(aChild.get(a.id)!=Null){
                    aChild.get(a.id).addall(a.Plan_Rates_Account__r);
                    // SFDC-16508 Changes - Start
                    aprList.addAll(a.Plan_Rates_Account__r);
                }
            }
            // Iterate through SGR Account Plan rate records and collect associated plan information
            Map<String, Plan__c> marketingPlanIdPlanMap = new Map<String, Plan__c>();
            
            // Query the corresponding plan information
            //List<Plan__c> plans = [Select Id, Name, Marketing_Sales_Plan_ID__c,Expiry_Date__c from Plan__c where Name in :marketingPlanIds];
            List<Plan__c> plans = [Select Id, Name, Marketing_Sales_Plan_ID__c,Line_Of_Business__c, Marketing_Plan_Number__c,Expiry_Date__c from Plan__c where Marketing_Plan_Number__c in :marketingPlanIdsSet];//marketingPlanIds];
            System.debug('Matching Plans:: ' + plans);
            if (null != plans || !plans.isEmpty()) {
                for (Plan__c p: plans) {
                    //marketingPlanIdPlanMap.put(p.Name, p);
                    marketingPlanIdPlanMap.put(p.Marketing_Plan_Number__c, p);
                }
            }
            // SFDC-16508 Changes - End
            List<Opportunity> opps3= ossTr;
            for(Opportunity op:opps3 ){
                
                if(!aChild.isEmpty())
                    system.debug('***Map****'+aChild);
                //Vijaya - Alternate Plan Rate creation logic - START
                if(fipPlansMap.containsKey(op.Id)){
                    for(SGR_Plan_FIPS_Map__c fip : fipPlansMap.get(op.Id)){
                        SGR_Opportunity_Plan_Rate__c altPlanRate = createAlternateOptyPlanRate(op.Id, 'Alternate', fip.Plan__c);
                        altPlanRate.Marketing_Plan_ID__c = fip.plan__r.Marketing_Plan_Number__c;
                        altPlanRate.Sales_Plan_ID__c = fip.Plan__r.Plan_Sales_ID__c;
                            opBenList.add(altPlanRate);
                    }
                }
                //Vijaya - Alternate Plan Rate creation logic - END
                //list<SGR_Account_Plan_Rate__c> blist = aChild.get(op.accountID);
                
                //Tarun 01/02/2019 : Added below line as a part of E2E Fixes
                list<SGR_Opportunity_Benefit_Agreement__c> opBenListFrmMap=opBenMap.get(op.id);
                Map<string,SGR_Opportunity_Benefit_Agreement__c> benMap = new Map<string,SGR_Opportunity_Benefit_Agreement__c>();
                if(opBenListFrmMap != NULL)
                for(SGR_Opportunity_Benefit_Agreement__c opB:opBenListFrmMap){
                    benMap.put(opB.name,opB);
                }
                Map<String, List<SGR_Account_Plan_Rate__c>> planRatesMap = accPlanRateMap.get(op.accountID);        
                if(planRatesMap != null){
                    
                    for(String planId : planRatesMap.keySet()){
                        
                        list<SGR_Account_Plan_Rate__c> blist = planRatesMap.get(planId);
                        
                        if(blist!=null && blist.size()>0){
                            for(SGR_Account_Plan_Rate__c accPlanRate:blist){
                                
                                //Added Field - 15079
                                //opplanrate.Health_Rating_Area_Number__c = c.Health_Rating_Area_Number__c;
                                //SFDC-14982:Modified the Group_Section__c value to opportunity GS
                                //for creating 'current' Opportunity Plan Rate
                                SGR_Opportunity_Plan_Rate__c opplanrateCurrent;
                                
                                if(planRatesMap.containsKey(accPlanRate.Marketing_Plan_ID__c) && planRatesMap.get(accPlanRate.Marketing_Plan_ID__c).size() > 0)//c
                                     //Tarun 01/02/2019 : Added parameter to method calling as a part of E2E Fixes
                                     if(accPlanRate.Benefit_Agreement__r.Status__c == 'Active') // Only for Active Benefit Agreements
                                    opplanrateCurrent =  createOptyPlanRate(accPlanRate, 'Current', op.Id,op.Renewal_Date__c, marketingPlanIdPlanMap,benMap);
                                
                                if(OppGSmap!=null && !OppGSmap.isEmpty()){
                                    if(accPlanRate.Group_SectionLK_Key__r.Name!=null){
                                        if(OppGSmap.containsKey(accPlanRate.Group_SectionLK_Key__r.Name.toUpperCase()+op.accountID))
                                        {
                                            opplanrateCurrent.Group_Section__c = OppGSmap.get(accPlanRate.Group_SectionLK_Key__r.Name.toUpperCase()+op.accountID);
                                        }
                                    } 
                                }
                                // SFDC-16508 Changes - Start
                                // Set plan look up field 
                                
                                //String key = accPlanRate.Plan__r.Name;
                                String key = accPlanRate.Marketing_Plan_ID__c;//c
                                Plan__c p = (Plan__c) marketingPlanIdPlanMap.get(key);
                                //opplanrateCurrent.Plan__c = (marketingPlanIdPlanMap!=null && null != p) ? p.Id : null;
                                
                                //for creating 'Renewal' Opportunity Plan Rate
                                SGR_Opportunity_Plan_Rate__c opplanrateRenewal;
                                if(planRatesMap.containsKey(accPlanRate.Marketing_Plan_ID__c) && planRatesMap.get(accPlanRate.Marketing_Plan_ID__c).size() > 0)//c
                                   //Tarun 01/02/2019 : Added parameter to method calling as a part of E2E Fixes
                                    if(accPlanRate.Benefit_Agreement__r.Status__c == 'Active') // Only for Active Benefit Agreements
                                    opplanrateRenewal =  createOptyPlanRate(accPlanRate, 'Renewal', op.Id,op.Renewal_Date__c, marketingPlanIdPlanMap,benMap);
                                if(OppGSmap!=null && !OppGSmap.isEmpty()){
                                    if(accPlanRate.Group_SectionLK_Key__r.Name!=null){
                                        if(OppGSmap.containsKey(accPlanRate.Group_SectionLK_Key__r.Name.toUpperCase()+op.accountID))
                                        {
                                            opplanrateRenewal.Group_Section__c = OppGSmap.get(accPlanRate.Group_SectionLK_Key__r.Name.toUpperCase()+op.accountID);
                                        }
                                    } 
                                }
                                // SFDC-16508 Changes - Start
                                // Set plan look up field 
                                
                                key = accPlanRate.Marketing_Plan_ID__c;//c
                                p = (Plan__c) marketingPlanIdPlanMap.get(key);
                                //opplanrateRenewal.Plan__c = (marketingPlanIdPlanMap!=null && null != p) ? p.Id : null;
                                // SFDC-16508 Changes - End
                                opBenList.add(opplanrateCurrent);
                                opBenList.add(opplanrateRenewal);
                            }
                        }
                    }
                }
            }
            
            if(!opBenList.isEmpty()){
                try{
                    //    if(flag==false){
                    //Insert opBenList;
                    Database.SaveResult[] result= database.insert(opBenList,false);
                    list<String> errMsgsList=new list<String>();
                    Set<ID> optyPlanRateIDs = new Set<ID>();
                    for(Database.SaveResult sr : result){
                        if (!sr.isSuccess()) {
                            for(Database.Error err : sr.getErrors()) {
                                errMsgsList.add(err.getMessage());
                            }
                            createErroLog(errMsgsList,bidErr);
                        }
                        else{
                            optyPlanRateIDs.add(sr.getId());
                        }
                    }
                    system.debug('+++optyPlanRateIDs.size()--'+optyPlanRateIDs.size()+errMsgsList);
                    if(optyPlanRateIDs.size() > 0)
                        insertOptyPlanCompRate(optyPlanRateIDs);
                }
                catch(exception e){
                    system.debug('Exception Occured'+e);
                }
            }
        }
    }
    @TestVisible  private Static SGR_Opportunity_Plan_Rate__c createAlternateOptyPlanRate(String optyId, String type, String planId){
        SGR_Opportunity_Plan_Rate__c oppPlanRate = new SGR_Opportunity_Plan_Rate__c();
        oppPlanRate.Name = 'Alternate Plan';
        oppPlanRate.Opportunity__c = optyId;
        oppPlanRate.Plan__c = planId;
        oppPlanRate.Type__c = type;
        return oppPlanRate;
    }
    
    //Tarun 01/02/2019 : Added parameter to method as a part of E2E Fixes
    @TestVisible private Static SGR_Opportunity_Plan_Rate__c createOptyPlanRate(SGR_Account_Plan_Rate__c accPlanRate, String type, String optyId,date opRenDate, Map<String, Plan__c> marketingPlanIdPlanMap,Map<String,SGR_Opportunity_Benefit_Agreement__c> BenMap){
        SGR_Opportunity_Plan_Rate__c oppPlanrate;
        if(accPlanRate != null){
            oppPlanrate = new SGR_Opportunity_Plan_Rate__c();
            oppPlanrate.name=accPlanRate.name;
            oppPlanrate.Plan_Name__c=accPlanRate.Plan__r.Name;
            
            // Urgent fixes - Offshore - 20-Jan - Start
            //   if (null != marketingPlanIdPlanMap && null != accPlanRate.Plan__r.Marketing_Plan_Number__c && null != marketingPlanIdPlanMap.get(accPlanRate.Plan__r.Marketing_Plan_Number__c)) {
            //oppPlanrate.Plan__c=marketingPlanIdPlanMap.get(accPlanRate.Marketing_Plan_ID__c)!=null? marketingPlanIdPlanMap.get(accPlanRate.Marketing_Plan_ID__c).id : null;//Plan__r.Marketing_Plan_Number__c).Id;
            // }
            
            //system.debug('+++plan Id ---'+accPlanRate.Plan__r.Id);
            //oppPlanrate.Plan__c=accPlanRate.Plan__r.Id;
            //oppPlanrate.Plan__c=accPlanRate.Marketing_Plan_ID__c;
            // Urgent fixes - Offshore - 20-Jan - End
            System.debug('marketingPlanIdPlanMap;;;'+marketingPlanIdPlanMap);
            oppPlanRate.Opportunity__c = optyId;
            oppPlanRate.Account__c = accPlanRate.Group_Account__c;//AccountLK_Key__c;
            oppPlanRate.Acc_Plan_External_Id__c= accPlanRate.Acc_Plan_Rate_External_Id__c;
            oppPlanRate.Funding_Type__c = accPlanRate.Funding_Type__c;
            oppPlanRate.Group_Number__c= accPlanRate.Group_Number__c;
            oppPlanRate.Benefit_Agreement_Cancel_Date__c = accPlanRate.Benefit_Agreement_Cancel_Date__c;
            // Urgent fixes - 20-Jan
            oppPlanRate.Benefit_Agreement_Effective_Date__c= accPlanRate.Benefit_Agreement_Rate_Effective_Date__c;
            //oppPlanRate.Benefit_Agreement_Effective_Date__c= accPlanRate.Benefit_Agreement_Rate_Effective_Date__c; TODO: Change to BA lookup once Maha confirms
            // Urgent fixes - 20-Jan
            oppPlanRate.Benefit_Agreement_End_Date__c = accPlanRate.Benefit_Agreement_End_Date__c;
            oppPlanRate.Benefit_Agreement_Number__c= accPlanRate.Benefit_Agreement_Number__c;
            oppPlanRate.Benefit_Agreement_Renewal_Date__c= accPlanRate.Benefit_Agreement_Renewal_Date__c;
            oppPlanRate.Cancel_Code__c= accPlanRate.Cancel_Code__c;
            oppPlanRate.Corporate_Product_Name__c = accPlanRate.Corporate_Product_Name__c;
            oppPlanRate.Corporate_Product_Number__c= accPlanRate.Corporate_Product_Number__c;
            //oppPlanRate.Coverage_Type__c= accPlanRate.Coverage_Type__c;
            oppPlanRate.Group_Name__c= accPlanRate.Group_Name__c;
            oppPlanRate.Type__c = type;
            oppPlanRate.Health_Rating_Area_Number__c = accPlanRate.Health_Rating_Area_Number__c;
            oppPlanRate.Group_Section_Cancel_Date__c=accPlanRate.Group_Section_Cancel_Date__c;
            oppPlanRate.Group_Section_Number__c= accPlanRate.Group_Section_Number__c;
            oppPlanRate.Group_Section_Original_Effective_Date__c = accPlanRate.Group_Section_Original_Effective_Date__c;
            oppPlanRate.Group_Section_Renewal_Date__c = accPlanRate.Group_Section_Renewal_Date__c;
            oppPlanRate.Invitro_TX_only__c= accPlanRate.isInvitro__c;
            oppPlanRate.Marketing_Plan_ID__c= accPlanRate.Marketing_Plan_ID__c;
            
            //SFDC-16508
            oppPlanrate.Plan__c=marketingPlanIdPlanMap.get(accPlanRate.Marketing_Plan_ID__c)!=null? marketingPlanIdPlanMap.get(accPlanRate.Marketing_Plan_ID__c).Id : null;//Plan__r.Marketing_Plan_Number__c).Id;
            system.debug('plan__c::;;'+oppPlanrate.Plan__c);
            oppPlanRate.Maternity__c= accPlanRate.isMaternity__c;
            // oppPlanRate.Member_Rates_or_Composite_Rates__c = accPlanRate.Member_Rate__c;
            oppPlanRate.Rate_Effective_Date__c= accPlanRate.Rate_Effective_Date__c;
            oppPlanRate.Sales_Plan_ID__c= accPlanRate.Sales_Plan_ID__c;
            oppPlanRate.Tier_Agreement_Sequence_Number__c= accPlanRate.Tier_Agreement_Sequence_Number__c;
            oppPlanRate.Tier_Number__c = accPlanRate.Tier_Number__c;
            oppPlanRate.Rate_Type_Code__c = accPlanRate.Rate_Type_Code__c;
            oppPlanRate.ACA_Fee__c = accPlanRate.ACA_Fee__c;
            oppPlanRate.Member_Premium__c = accPlanRate.Member_Premium__c;//added by Cesar/Mei @2/13
            oppPlanRate.Plan_Status__c='Renewing';
            
            //MC - get plan object by the marketing plan id
            Plan__c gspsPlan=marketingPlanIdPlanMap.get(accPlanRate.Marketing_Plan_ID__c);
            system.debug('+++gspsPlan--'+gspsPlan);
             if(gspsPlan!=null){
                oppPlanRate.Coverage_Type__c=gspsPlan.Line_Of_Business__c;
                 system.debug('+++plan Id ---'+gspsPlan.Id);
            }
            if((gspsPlan!=null && gspsPlan.Expiry_Date__c < opRenDate)
               || (!accPlanRate.Benefit_Agreement__r.Status__c.equalsignorecase('Active'))){
                oppPlanRate.Plan_Status__c='Cancelled';
               
            }
             oppPlanRate.Member_Premium__c = accPlanRate.Member_Premium__c;
             //Tarun 01/02/2019 : Added logic as a part of E2E Fixes start here
            if(benMap!=NULL && accPlanRate.Benefit_Agreement__r != NULL && benMap.get(accPlanRate.Benefit_Agreement__r.name)!= NULL){
                   oppPlanRate.Opportunity_Benefit_Agreement__c = benMap.get(accPlanRate.Benefit_Agreement__r.name).id;
            }
             //Tarun 01/02/2019 : Added logic as a part of E2E Fixes end here
            

           // system.debug('+++plan Id ---'+accPlanRate.Plan__r.Id);
        }
        
        return oppPlanrate;
    }
    
    
    Public static void insertOpportunitiesGroupSection(set<id> ID,list<Opportunity> ossTr,String bidErr){
        Set<Id> accId = new Set<Id>();
        if(ID!=null || !ID.isEmpty())
            accID = ID;
        list<SGR_Opportunity_Group_Section__c> opBenList = new list<SGR_Opportunity_Group_Section__c>();
        
        Map<id,list<Group_Section__c>> aChild = new Map<id,list<Group_Section__c>>();
        List<Account> acc1 =[select Id,(select id,name,Funding_Type__c,Invitro__c,Maternity__c,Group_Number__c,
                                        External_ID__c,Effective_Date__c,Benefit_Agreement_Cancel_Date__c, 
                                        Group_Section_Original_Effective_Date__c, Group_Section_Cancel_Code__c, 
                                        Group_Section_Cancel_Date__c, Cancellation_Code__c, Cancellation_Date__c, 
                                        Status__c,Group_Section_Number__c From Group_Sections__r) from Account where Id In : accId]; 
        for(Account a:acc1 )
        {
            //if(aChild.containsKey(a.id)){
            if(aChild.get(a.id)==Null){
                aChild.put(a.ID,new List<Group_Section__c>{});
            }
            //if(!aChild.containsKey(a.id)){
            if(aChild.get(a.id)!=Null){
                aChild.get(a.id).addall(a.Group_Sections__r);
                
            }
        }
        system.debug('aChild'+aChild.size());
        List<Opportunity> oppps = ossTr;
        for(Opportunity op:oppps ){
            
            if(!aChild.isEmpty())
                system.debug('***Map****'+aChild);
            
            list<Group_Section__c> blist = aChild.get(op.accountID);
            if(blist!=null && blist.size()>0){
                for(Group_Section__c b:blist){
                    SGR_Opportunity_Group_Section__c opp = new SGR_Opportunity_Group_Section__c();
                    
                    opp.name=b.name;
                    opp.Opportunity__c = op.id;
                    opp.Group_Name__c =b.Group_Number__c;
                    opp.Funding_Type__c=b.Funding_Type__c;
                    //opp.Benefit_Agreement__c=op.Parent_Opportunity;
                    opp.Invitro__c=b.Invitro__c;
                    opp.Maternity__c=b.Maternity__c;
                    opp.GS_External_Id__c=b.External_ID__c;
                    opp.BEN_AGMT_effective_date__c=b.Effective_Date__c;
                    opp.Benefit_Agreement_Cancel_Date__c=b.Benefit_Agreement_Cancel_Date__c;
                    // Urgent fixes - Offshore - 20-Jan - Start
                    opp.Group_Section_Original_Effective_Date__c = b.Group_Section_Original_Effective_Date__c;
                    opp.Group_Section_Cancel_Code__c = b.Group_Section_Cancel_Code__c;
                    opp.Group_Section_Cancel_Date__c = b.Group_Section_Cancel_Date__c;
                    opp.Status__c = b.Status__c;
                    opp.Opportunity_Group_Number__c = b.Group_Number__c;
                    // Urgent fixes - Offshore - 20-Jan - End
                    opBenList.add(opp);
                    
                }
            }
        }
        system.debug('opBenList'+ opBenList.size());
        if(!opBenList.isEmpty()){
            try{
                //   if(flag==false){
                //Insert opBenList;
                Database.SaveResult[] result=database.insert(opBenList,false);
                list<String> errMsgsList=new list<String>();
                for(Database.SaveResult sr : result){
                    if (!sr.isSuccess()) {
                        for(Database.Error err : sr.getErrors()) {
                            errMsgsList.add(err.getMessage());
                        }
                        createErroLog(errMsgsList,bidErr);
                    }
                }
                System.debug('Done with groups');
                //   }
            }
            catch(exception e){
                system.debug('Exception Occured'+e);
            }
        }
    } 
    
    Public static void insertOpportunitiesMemberBenefit(set<id> accId,list<Opportunity> ossTr,String bidErr){
        SGR_AccRenewalCopyMemberBenefitsHelper.InsertOpportunitiesMemberBenefit(accId, ossTr, bidErr);
    }
    
    // Created as a part of SFDC-14982, to copy the junction object records. Dev : Tarun Kumar
    // Blocked with other Subtasks
    Public static void insertOppBAGSAssignment(set<id> accId,list<Opportunity> ossTr,String bidErr){
        list<opportunity> opplist1 = ossTr;
        set<Id> oppIdSet=new set<Id>();
        id oppId;
        for(Opportunity temp:opplist1){
            oppId=temp.id;
            oppIdSet.add(oppId);
        }
        
        list<SGR_Opportunity_Benefit_Agreement__c> oppBAgmnt =new list<SGR_Opportunity_Benefit_Agreement__c>();
        List<SGR_Opportunity_Group_Section__c> oppGsec=new List<SGR_Opportunity_Group_Section__c>(); 
        list<Opportunity_BA_GS_Assignment__c> oppBAGSLst = new list<Opportunity_BA_GS_Assignment__c>();
        
        list<BA_GS_Assignment__c> accBAGSLst=[select name,id,External_ID__c,Benefit_Agreement__r.name,Group_Section__r.name,Total_Active_Health_Members__c 
                                              from BA_GS_Assignment__c where Benefit_Agreement__r.Group_Account__c IN:accId];
        map<id,List<SGR_Opportunity_Group_Section__c>> oppGrpScMap = new map<id,List<SGR_Opportunity_Group_Section__c>>();   
        map<id,List<SGR_Opportunity_Benefit_Agreement__c>> oppBAgmntMap = new map<id,List<SGR_Opportunity_Benefit_Agreement__c>>();
        
        List<opportunity> lstopp = [SELECT Id, name,Batch_Id__c ,(SELECT id,Name,Opportunity__c FROM Opportunity_Benefit_Agreements__r),(SELECT Id, Name,Group_Name__c FROM Opportunity_Group_Section__r) FROM opportunity where id IN:oppIdSet];
        System.debug('accMemBefs'+accBAGSLst);
        System.debug('lstopp'+lstopp);
        
        for(Opportunity os :lstopp){
            
            
            oppBAgmntMap.put(os.id,os.Opportunity_Benefit_Agreements__r);
            oppGrpScMap.put(os.id,os.Opportunity_Group_Section__r);
        }
        for(Opportunity os :lstopp){
            oppGsec.addAll(oppGrpScMap.get(os.id));
            oppBAgmnt.addAll(oppBAgmntMap.get(os.id));
        }
        
        System.debug('Opp grp sec lst:'+oppGsec);
        System.debug('Opp Ben Agrmnt lst:'+oppBAgmnt);
        
        for(BA_GS_Assignment__c accBaGs:accBAGSLst){
            Opportunity_BA_GS_Assignment__c oppBAGS=new Opportunity_BA_GS_Assignment__c();
            oppBAGS.name=accBaGs.name;
            oppBAGS.External_ID__c=accBaGs.External_ID__c;
            oppBAGS.Total_Active_Health_Members__c=accBaGs.Total_Active_Health_Members__c;
            for(SGR_Opportunity_Group_Section__c ogs:oppGsec){
                
                System.debug(accBaGs.Group_Section__r.name+'---compare---'+ogs.name);
                if(accBaGs.Group_Section__r.name==ogs.name){
                    oppBAGS.Opportunity_Group_Section__c=ogs.id;
                    
                    System.debug('finally copied'+oppBAGS.Opportunity_Group_Section__c);
                    break;
                }
                
            }
            for(SGR_Opportunity_Benefit_Agreement__c oba:oppBAgmnt){
                
                System.debug(accBaGs.Benefit_Agreement__r.name+'---compare---'+oba.name);
                if(accBaGs.Benefit_Agreement__r.name==oba.name){
                    oppBAGS.Opportunity_Benefit_Agreement__c=oba.id;
                    System.debug('finally copied');
                    break;
                }
                
            }
            if(oppBAGS.Opportunity_Benefit_Agreement__c != null && oppBAGS.Opportunity_Group_Section__c != null)
                oppBAGSLst.add(oppBAGS); // Add when both the lookup fields are filled in
        }
        
        if(!oppBAGSLst.isEmpty()){
            try{
                //Insert opBenList;
                System.debug('pls run now'+oppBAGSLst);
                Database.SaveResult[] result=database.insert(oppBAGSLst,false);
                list<String> errMsgsList=new list<String>();
                
                for(Database.SaveResult sr : result){
                    if (!sr.isSuccess()) {
                        for(Database.Error err : sr.getErrors()) {
                             System.debug('pls run now11'+errMsgsList);
                            errMsgsList.add(err.getMessage());
                            
                        }
                        createErroLog(errMsgsList,bidErr);
                    }
                }
            }
            catch(exception e){
                system.debug('Exception Occured'+e);
            }
        }
        
    } 
    
    
    
    // SFDC-14055 Method to get list of gate records for the effective date-division combination
    public static Actuary_Gate__c fetchGateRecord(String division, String marketSeg, String fundingType, Date renEffDate) {
        System.debug('Executing fetchGateRecord');
        Actuary_Gate__c matchingGate = null;
        Map<String, Actuary_Gate__c> matchingGateRecs = new Map<String, Actuary_Gate__c>();
        Integer renEffMonth = renEffDate.month();
        Integer renEffYear = renEffDate.year();
        
        List<Actuary_Gate__c> gateRecs = [SELECT Id, Division__c, Effective_Date__c, Funding_Type__c, Market_Segment__c 
                                          FROM Actuary_Gate__c 
                                          WHERE 
                                          Division__c=:division AND
                                          Funding_Type__c = :fundingType AND
                                          CALENDAR_MONTH(Effective_Date__c) = :renEffMonth AND
                                          CALENDAR_YEAR(Effective_Date__c) = :renEffYear                                                 
                                         ];
        
        for (Actuary_Gate__c gate: gateRecs) {
            String key = gate.Division__c + gate.Funding_Type__c + gate.Market_Segment__c + gate.Effective_Date__c;
            matchingGateRecs.put(key, gate);
        }                                                
        if (!gateRecs.isEmpty()) {
            matchingGate = gateRecs[0];
        }
        return matchingGate;
    } 
    
    
}