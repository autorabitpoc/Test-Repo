public with sharing class ShowAccountDetails{
    public List<Account> acntLst {get;set;}
    public String AccountNumber{get;set;}
    public Account acnt {get;set;}
    public string ACCID;
    
    public List<SGR_Account_Census__c> acntCensus {get;set;}
    public List<SGR_Account_Member_Benefit__c > acntMemBen {get;set;}
    public List<Benefit_Agreement__c> ba {get;set;}
    public List<SGR_Account_Plan_Rate__c> acntPlnRte {get;set;}

    public List<Opportunity> oppLst  {get;set;}
    public List<SGR_Opportunity_Census__c> oppCensus  {get;set;}
    public list<SGR_Opportunity_Member_Benefits__c> oppMemBen   {get;set;}
    public list<SGR_Opportunity_Benefit_Agreement__c> oppBA    {get;set;}
    public list<SGR_Opportunity_Plan_Rate__c> oppPlnRte   {get;set;}
    //public 
    
    public ShowAccountDetails(ApexPages.StandardSetController controller) {
    }
    
    public PageReference RefreshAccount()
    {
     list<account> acc = new  list<account>();
         //Fetch Account Details
    if(AccountNumber != null)
    {
      
        acc = [Select ID, Name, Aca_Indicator__c, Renewal_Date__c,External_ID__c,Market_Segment__c,County_Code__c,Email__c,ShippingCity__c,ShippingPostalCode__c, HCSC_Division__C,ShippingState__c,ShippingStreet__c from Account where Accountnumber = :AccountNumber];
        if(acc!=null && acc.size()>0){
        acnt=acc[0];
        ACCID=acnt.id;
        acntLst = new List<Account>();
        acntLst.add(acnt); 
        }
    }
    system.debug('Reached here'+ ACCID);
    //Fetch Account Census
    if(ACCID!=null){
    acntCensus = [SELECT Id, Name, Membership_Number__c, Relationship__c, Relationship_Code__c, First_Name__c, Last_Name__c, Date_of_Birth__c, Gender__c, Tobacco_Use__c  , Member_Effective_Date__c, Member_Cancel_Date__c,Subscriber_Number__c FROM SGR_Account_Census__c  WHERE Account__c = :ACCID Order by Subscriber_Number__c asc,Membership_Number__c asc] ;
    system.debug('Reached here'+acntCensus);
    //Fetch Account Member Benefits
   acntMemBen = [SELECT Id, Account__r.Name,Name,Marketing_Plan_Number__c, Member_Benefit_Effective_Date__c, Premium_Amount__c , Insurance_Type_Code__c, Supplemental_Insurance_Type_Code__c, Account_Census__c, Account_Plan_Rate__c FROM SGR_Account_Member_Benefit__c  WHERE Account__c = :ACCID ];
       
    //Fetch Benefit Agreement
    ba = [SELECT Group_Account__r.Name, Id, Name, ACA_Indicator__c, Market_Plan_Number__c , Effective_Date__c, Cancellation_Date__c, Status__c FROM Benefit_Agreement__c   WHERE Group_Account__c = :ACCID];    
                
    //Account Plan Rate 
    acntPlnRte  = [ Select Id,name,Type__c, ACA_Fee__c, ACA_Indicator__c, Acc_Plan_Rate_External_Id__c, Account_Member_Benefit__c, Account_Number__c from SGR_Account_Plan_Rate__c where Group_Account__c = :ACCID];  
    system.debug('acntPlnRte'+acntPlnRte);
    //Opportunity List
    oppLst = [Select Id,Name,Requested_Effective_Date__c,Renewal_Date__c,Effective_Month__c,HCSC_Division__c,County_Name__c,Zip_Code__c,FIPS_Code__c,SGR_Opportunity_Auto_Number__c,account.Primary_Producer_Account__r.name, Total_Medical_Monthly_Premium__c, Total_Dental_Monthly_Premium__c, Total_Vision_Monthly_Premium__c,Total_Est_Medical_Insurer_Fees__c, Total_Est_Dental_Insurer_Fees__c, Total_Est_Vision_Insurer_Fees__c,account.External_ID__c, Submit_Date__c,Days_To_Submit__c,Expected_Dental_Members__c,Account_Market_Segment__c,Opportunity_Number__c,account.Id,account.name,account.AccountNumber,account.Line_of_business__c, createdBy.Name, CreatedDate
      from Opportunity where AccountId = :ACCID Order by CreatedDate Desc ]; 
    }
    if(oppLst!=null){
    //Opportunity Census
    oppCensus = [SELECT Id, Subscriber_Number__c, Membership_Number__c , Relationship__c, Relationship_Code__c, First_Name__c, Last_Name__c, Date_of_Birth__c     , Gender__c, Tobacco_Use__c , Member_Effective_Date__c, Member_Cancel_Date__c ,
                    Age__c,State__c,Row__c,Health_Tier__c,Health_Plan_ID__c,Dental_Tier__c,Dental_Plan_ID__c,Vision_Tier__c,Vision_Plan_ID__c
        FROM SGR_Opportunity_Census__c  WHERE Opportunity__c = :oppLst  Order by Subscriber_Number__c asc,Membership_Number__c asc ]; 
    
    //Opportunity Member Benefits
	
    oppMemBen = [SELECT Id,   Member_Benefit_Effective_Date__c, Insurance_Type_Code__c,  Opportunity_Census__c, Opportunity_Plan_Rate__c FROM SGR_Opportunity_Member_Benefits__c  WHERE Opportunity__c = :oppLst ];
    
    //Opportunity Plan Rate
    oppPlnRte = [SELECT Id, Name, Type__c, ACA_Fee__c FROM SGR_Opportunity_Plan_Rate__c   WHERE Opportunity__c  = :oppLst  ];
    } 
     return null; 
    }   

}