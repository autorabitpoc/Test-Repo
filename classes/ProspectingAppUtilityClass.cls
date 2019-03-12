/********************************************************************************
* Apex Class Name     : ProspectingAppUtilityClass
* Version             : 1.0
* Function            : This is a class of methods used for the Prosepcting App.
* Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Zachary Campbell		6/09/2017	added methods findName() and findProfile()
*									used to determine access to the App.
* Nathan Shuyler        6/09/2017   added queryContactInfo() and
*                                   queryCompetitorInfo() methods.
*********************************************************************************/
public with sharing class ProspectingAppUtilityClass {
    public static Account queryAccount(Id accountId) {
        return [SELECT Id, Name, Owner.Name, BillingCity, BillingState, Industry, NumberOfEmployees, 
                Total_Num_of_Potential_Subscribers__c, Group_Total_Eligible_Members__c,
                Client_Competitors__c, Status__c, Website,
                (SELECT Id, Name, CreatedDate, Description FROM Attachments
                 ORDER BY CreatedDate DESC NULLS LAST),
                (SELECT Id, Name, Title, Email, MobilePhone, RecordType.Name FROM Contacts
                 ORDER BY Name ASC NULLS LAST), 
                (SELECT Id, Title, Body, CreatedDate FROM Notes
                 ORDER BY CreatedDate DESC NULLS LAST),
                (SELECT Id, Subject, Description, OwnerId, Owner.Name, Status, Type, Priority, CreatedDate FROM Tasks
                 ORDER BY CreatedDate DESC NULLS LAST),
                (SELECT Id, Competitor_Account__r.Name, Status__c, Sliced__c,
                 Number_of_Sliced_Products__c, Carve_Out__c, Number_of_Carve_Out_Products__c,
                 Total_Contracts__c, Total_Members__c FROM Competitor_Relationships1__r
                 ORDER BY Competitor_Account__r.Name ASC NULLS LAST),
                (SELECT Id, Producer_Account__r.Name, Producer_Type__c, Primary__c, Effective_Date__c, End_Date__c FROM Group_Associated__r 
                 ORDER BY Producer_Account__r.Name ASC NULLS LAST)
                FROM Account WHERE Id=:accountId ORDER BY Name ASC NULLS LAST];
    }
    
    public static Contact queryContactRelatedAccountsInfo(Id contactId) {
        return [SELECT Id, (SELECT Id, Account.Name, Account.RecordType.Name FROM AccountContactRelations ORDER BY Account.Name ASC NULLS LAST) 
                FROM Contact WHERE Id=:contactId];
    }
    
    //<!-- SFDC-4497 - 06/2017 - SHUYLER - Begin -->
    
    public static Contact queryContactInfo(Id contactId) {
        system.debug('contactId' + contactId);
        Contact aContact = [SELECT Id,Title,Lastname,Firstname,Email,Phone,MailingStreet,MailingCity,MailingState,MailingPostalCode
                            FROM Contact WHERE Id = :contactId];
        System.debug('Contact Object'+ aContact);
        
        return [SELECT Id,Title,Lastname,Firstname,Email,Phone,MailingStreet,MailingCity,MailingState,MailingPostalCode 
                FROM Contact WHERE Id = :contactId];
    }
    
    public static Competitor_Relationship__c queryCompetitorInfo(Id competitorId) {
        system.debug('competitorId' + competitorId);
        Competitor_Relationship__c aCompetitor = [Select Id, 
                                                  Competitor_Account__r.Name, 
                                                  Group_Account__r.Name, 
                                                  Producer_Consultant_Firm__r.Name, 
                                                  Producer_Consultant__r.Name, 
                                                  Status__c, 
                                                  Rate_Effective_Date__c,
                                                  Contract_End_Date__c, 
                                                  Total_Contracts__c, 
                                                  Total_Members__c, 
                                                  AFA__c, 
                                                  Not_Insured__c, 
                                                  Reinsurer__c, 
                                                  Length_of_Relationship_with_Group__c,
                                                  Group_Satisfaction_with_Competitor__c, 
                                                  Does_Incumbent_slash_rates_to_keep_busin__c, 
                                                  Current_Carrier_Win_Factors__c, 
                                                  Strengths__c, 
                                                  Weaknesses__c, 
                                                  Claims_Data_Shared__c, 
                                                  Eligibility_Data_Shared__c, 
                                                  Lab_Data_Shared__c, 
                                                  Discharge_Data_Shared__c, 
                                                  Accums_Data_Shared__c, 
                                                  Pharmacy_Data_Shared__c, 
                                                  Comments__c  
                                                  FROM Competitor_Relationship__c 
                                                  WHERE  Id = :competitorId];
        System.debug('Competitor Object: '+ aCompetitor);
        System.debug('Competitor Object Name: '+ aCompetitor.Claims_Data_Shared__c);
        
        return [Select Id, 
                Competitor_Account__r.Name, 
                Group_Account__r.Name, 
                Producer_Consultant_Firm__r.Name, 
                Producer_Consultant__r.Name, 
                Status__c, 
                Rate_Effective_Date__c,
                Contract_End_Date__c, 
                Total_Contracts__c, 
                Total_Members__c, 
                AFA__c, 
                Not_Insured__c, 
                Reinsurer__c, 
                Length_of_Relationship_with_Group__c,
                Group_Satisfaction_with_Competitor__c, 
                Does_Incumbent_slash_rates_to_keep_busin__c, 
                Current_Carrier_Win_Factors__c, 
                Strengths__c, 
                Weaknesses__c, 
                Claims_Data_Shared__c, 
                Eligibility_Data_Shared__c, 
                Lab_Data_Shared__c, 
                Discharge_Data_Shared__c, 
                Accums_Data_Shared__c, 
                Pharmacy_Data_Shared__c, 
                Comments__c  
                FROM Competitor_Relationship__c 
                WHERE  Id = :competitorId];
    }
    //<!-- SFDC-4497 - 06/2017 - SHUYLER - End   -->
    
    public static List<String> getPicklistValues(String ObjectApi_name, String Field_name) { 
        List<String> lstPickvals = new List<String>();
        Schema.sObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject   
        
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
            lstPickvals.add(a.getValue());//add the value  to our final list
        }
        System.debug('Picklist Values: '+ lstPickvals);
        return lstPickvals;
    }
    
    public static List<Contact> getAccountContacts(Account curAccount) {
        return [SELECT Id, Name, Title, Email, MobilePhone, RecordType.Name FROM Contact WHERE AccountId=:curAccount.Id ORDER BY Name ASC NULLS LAST];
    }
    
    public static List<Competitor_Relationship__c> queryAccountCompetitorsAndVendorsList(Account curAcc) {
        return [SELECT Id, Competitor_Account__r.Name, Sliced__c, Number_of_Sliced_Products__c, Carve_Out__c, 
                Number_of_Carve_Out_Products__c, Status__c, Total_Contracts__c, Total_Members__c FROM Competitor_Relationship__c
                WHERE Group_Account__c=:curAcc.Id ORDER BY Name ASC NULLS LAST];
    }
    
    public static List<Producer_Group_Association__c> queryAccountProdGroupAssocList(Account curAccount) {
        return [SELECT Id, Producer_Account__r.Name, Producer_Type__c, Primary__c, Effective_Date__c, End_Date__c FROM Producer_Group_Association__c
                WHERE Group_Account__c=:curAccount.Id ORDER BY Producer_Account__r.Name ASC NULLS LAST];    
    }
    
    public static List<RecordType> querySobjectRecordtypes(String sobjectName) {
        return [SELECT Id, DeveloperName, Name FROM RecordType WHERE Sobjecttype=:sobjectName];
    }
    
    public static List<Note> queryAccountNotes(Account curAccount) {
        return [SELECT Id, Title, Body, CreatedDate FROM Note
                WHERE ParentId=:curAccount.Id ORDER BY CreatedDate DESC NULLS LAST];
    }
    
    public static List<Task> queryAccountTasks(Account curAccount) {
        return [SELECT Id, Subject, Description, OwnerId, Owner.Name, Status, Type, Priority, CreatedDate FROM Task
                WHERE WhatId=:curAccount.Id ORDER BY CreatedDate DESC NULLS LAST];
    }
    
    /* SFDC-5353 - 07/2017 - BEGIN */    
    public static List<Attachment> queryAccountAttachments(Account curAccount) {
        return [SELECT Id, Name, CreatedDate, Description FROM Attachment WHERE ParentId = :curAccount.Id ORDER BY CreatedDate DESC NULLS LAST];
    }
    /*SFDC-5353 - 07/2017 - END */
    
    public static boolean findName() {
        boolean nfound = false;
        String uName = userinfo.getName();
        for(Lightning_Prospecting_Pilot_Names__c foundName : Lightning_Prospecting_Pilot_Names__c.getAll().values()) {
            if (uname == foundName.Name){
                nfound = true;
            }
        }
        return nfound;
    }
    
    public static boolean findProfile() {
        boolean pfound = false;
        Profile p = [Select Name from Profile where Id =: userinfo.getProfileid()];
        String pname = p.name;
        
        for(Lightning_Prospecting_Profiles__c foundProfile : Lightning_Prospecting_Profiles__c.getAll().values()) {
            if (pname == foundProfile.Name){
                pfound = true;
            }
        }
        return pfound;
    }   
}