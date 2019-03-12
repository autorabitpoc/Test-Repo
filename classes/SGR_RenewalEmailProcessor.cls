/* 
 * Developer:  Vijaya Channamsetti	  Date  : 11/27/2018		Adding logic to send email when Batch initiated and Completed.
*/
 

public class SGR_RenewalEmailProcessor {
    
    public static void sendRenewalEmail(List<Id> renewalIds){
        List<SGRRenewalBatch__c> renewals;
        try{ 
            renewals = [select Id, CreatedDate, Renewal_Effective_date__c, BatchID__c, BatchType__c, RenewalType__c, Division__c, MarketSegment__c, FundingType__c, Number_of_Accounts__c from  SGRRenewalBatch__c where Id IN : renewalIds 
                        																															AND Action_Type__c = 'Renewals' AND BatchType__c = 'Batch'];
            system.debug('++++renewals.size()-- '+renewals.size());
            for(SGRRenewalBatch__c renewal : renewals){
              string subject = getSandboxName() + ': ' + system.label.SGR_Renewal_Email_Subject;  
              string bodyLabel = system.label.SGR_Renewel_Email_Body;              
              //Replace the subject and body with Renewal Type, BatchId, Division etc
              subject = subject.replace('<RenewalType>', renewal.RenewalType__c);
              subject = subject.replace('<EmailType>', 'submitted');
              system.debug('++++subject-- '+subject);
              bodyLabel = bodyLabel.replace('<RenewalType>', renewal.RenewalType__c);
              bodyLabel = bodyLabel.replace('<Division>', renewal.Division__c);
              bodyLabel = bodyLabel.replace('<EmailType>', 'submitted');
              Integer month = renewal.Renewal_Effective_date__c.month();
              Integer day = renewal.Renewal_Effective_date__c.day();  
              Integer year = renewal.Renewal_Effective_date__c.year(); 
              String myDate = month +'/'+ year;//month +'/' + day + '/' + year;
              system.debug('++++myDate-- '+myDate);
              bodyLabel = bodyLabel.replace('<created>', myDate);
              system.debug('++++bodyLabel-- '+bodyLabel);
              String bodyTable = getTableEmailBody(renewal, 'Initial', 0);
              system.debug('++++bodyTable-- '+bodyTable);
              String body = bodyLabel + bodyTable;          
              sendEmail(subject, body, renewal);  //.RenewalType__c);
        	}
        }Catch(Exception e){
            CreateExceptionLog.insertErrorLog(e, null, null, renewals, 'Apex Class', 'SGRRenewalBatch__c', null, 'SGR_RenewalEmailProcessor.sendRenewalEmail','Low');  
        }
    }
    
    public static string getTableEmailBody(SGRRenewalBatch__c renewal, String emailType, Integer count){

    String htmlBody = '';
    String tableTitle = '';
	if(renewal != null){
        system.debug('++++emailType--'+emailType);
        if(emailType == 'Initial'){
            //tableTitle += renewal.Division__c + ' email batch summary';
            //open table..<br><br>for line break
            //htmlBody = '<table border="1" align="center" style="border-collapse: collapse"><caption>Request Summary Data</caption><tr><th>Renewal Batch Id</th><th>Division</th><th>Account Count</th></tr>';
            htmlBody = '<br><table border="1" style="border-collapse: collapse"><tr><th>Batch Id</th><th>Division</th><th>Funding Type</th><th>Market Segment</th><th>Accounts</th></tr>';
            //htmlBody += '<tr><td>' + renewal.BatchId__c + '</td><td>' + renewal.Division__c + '</td>' + '</td><td>' + renewal.Number_of_Accounts__c + '</td></tr>';
            htmlBody += '<tr><td>' + renewal.BatchId__c + '</td><td>' + renewal.Division__c + '</td><td>' + renewal.FundingType__c + '</td><td>' + renewal.MarketSegment__c + '</td><td>' + renewal.Number_of_Accounts__c + '</td></tr>';
        }
        else{
            system.debug('++++emailType--'+emailType);
            //open table..<br><br>for line break
            htmlBody = '<br><table border="1" style="border-collapse: collapse"><tr><th>Batch Id</th><th>Division</th><th>Funding Type</th><th>Market Segment</th><th>Accounts</th><th>Opportunities</th></tr>';
            htmlBody += '<tr><td>' + renewal.BatchId__c + '</td><td>' + renewal.Division__c + '</td><td>' + renewal.FundingType__c + '</td><td>' + renewal.MarketSegment__c + '</td><td>' + renewal.Number_of_Accounts__c + '</td><td>' + count +'</td></tr>';
        }
    }

    //close table...
    htmlBody += '</table>';
    system.debug('Email Body: ' + htmlBody);   

    return htmlBody;

	}
    
    public static void sendEmail(String subject, String body, SGRRenewalBatch__c renewal){ 
        List<String> profileNames;
        List<String> analyticalUsers = new List<String>();
        List<String> productionUsers = new List<String>();
        //List<String> emails = new List<String>();
        Set<String> emails = new Set<String>();
        String rentype = renewal.RenewalType__c;
        system.debug('++++renType--'+renType);
        
        profileNames = new List<String>{'SGR Actuary User', 'SGR Operations User', 'SGR SAM User', 'SGR UW User', 'SG Service Center_LEX'};
        List<user> usersList = [Select email, Profile.Name, UserRole.Name, IsActive from user where Profile.Name IN :profileNames AND IsACtive = true];
        
        //Messaging.reserveSingleEmailCapacity(2);
        //Messaging.MassEmailMessage emails=new Messaging.MassEmailMessage(); 
        List<String> roles = getDivisionUserRoles('SG Service Center_LEX', renewal.Division__c);
        system.debug('++++roles--'+roles);
        //List<Messaging.SingleEmailMessage> listMails = new List<Messaging.SingleEmailMessage>();
        if(usersList != null){
            system.debug('++++User List--'+usersList);
            for(User u : usersList){
                if(u.isActive == true){
                    if(u.Profile.Name == 'SGR Actuary User'	|| (u.Profile.Name == 'SGR UW User' && u.UserRole.Name == 'SGR Underwriter Manager') )
                        emails.add(u.email);
                    if(u.Profile.Name == 'SGR Actuary User'	|| (u.Profile.Name == 'SGR UW User' && u.UserRole.Name == 'SGR Underwriter Manager') || (u.Profile.Name == 'SGR Operations User' && u.UserRole.Name == 'SGR Operations Manager'))
                        emails.add(u.email);
                    if(rentype == 'Production'){
                        if(roles != null){
                            if(roles.size() > 0 ){
                                if(roles.contains(u.userRole.Name)){
                                    emails.add(u.Email);
                                }
                            }
                        }
                	}
       			}
            }
            system.debug('+++Email list--'+emails);
            sendEmails(emails, subject, body);
        }
    }
    public static void sendEmails(Set<String> emails, String subject, String body){   
        List<Messaging.SingleEmailMessage> listMails = new List<Messaging.SingleEmailMessage>();
        for (String e : emails){          
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
    
                // Set list of peoples who should recieve an email
                List<String> sendTo = new List<String>();
                sendTo.add(e);
                email.setToAddresses(sendTo);
                email.setSenderDisplayName('SFDC SGR');
     
                // Sets the paramaters of the email
                email.setSubject( subject ); 
                email.setHTMLBody( body );
     
                // Add your email address into the master list
                listMails.add(email);
         }
         // Sends mass emails
         Messaging.sendEmail(listMails, false);
    }
        /*if(renType == 'Production' && productionUsers != null ){
            system.debug('++++renType--'+renType+'++++productionUsers--'+productionUsers);
            for (String e : productionUsers){          
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
    
                // Set list of peoples who should recieve an email
                List<String> sendTo = new List<String>();
                sendTo.add(e);
                email.setToAddresses(sendTo);
                email.setSenderDisplayName('SFDC SGR');
     
                // Sets the paramaters of the email
                email.setSubject( subject ); 
                email.setHTMLBody( body );
     
                // Add your email address into the master list
                listMails.add(email);
         	}
       // Sends mass emails
        Messaging.sendEmail(listMails);
        } 	
        if(renType == 'Analytical' && analyticalUsers != null){
            system.debug('++++renType--'+renType+'++++analyticalUsers--'+analyticalUsers);
            for (String e : analyticalUsers){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
    
                 // Set list of peoples who should recieve an email
                List<String> sendTo = new List<String>();
                sendTo.add(e);
                email.setToAddresses(sendTo);
                email.setSenderDisplayName('SFDC SGR');
                // Sets the paramaters of the email
                email.setSubject( subject ); 
                email.setHTMLBody( body );
                listMails.add(email);
         }
       // Sends mass emails
        Messaging.sendEmail(listMails, false);
        }*/
    
    public static void sendFinalRenewalEmail(Integer count, String batchId){
        List<SGRRenewalBatch__c> renewals;
        try{ 
            renewals = [select Id, CreatedDate, Renewal_Effective_date__c, BatchID__c, BatchType__c, RenewalType__c, Division__c, MarketSegment__c, FundingType__c, Number_of_Accounts__c from  SGRRenewalBatch__c where BatchID__c =: batchId];
            for(SGRRenewalBatch__c renewal : renewals){            
              string subject = getSandboxName() + ': ' + system.label.SGR_Renewal_Email_Subject;  
              string bodyLabel = system.label.SGR_Renewel_Email_Body;
              //Replace the subject and body with Renewal Type, BatchId, Division etc
              subject = subject.replace('<RenewalType>', renewal.RenewalType__c);
              subject = subject.replace('<EmailType>', 'completed');
              system.debug('++++subject-- '+subject);
              bodyLabel = bodyLabel.replace('<RenewalType>', renewal.RenewalType__c);
              bodyLabel = bodyLabel.replace('<Division>', renewal.Division__c);
              bodyLabel = bodyLabel.replace('<EmailType>', 'completed');
              Integer month = renewal.Renewal_Effective_date__c.month();
              Integer day = renewal.Renewal_Effective_date__c.day();  
              Integer year = renewal.Renewal_Effective_date__c.year(); 
              String myDate = month +'/'+ year;//month +'/' + day + '/' + year;
              system.debug('++++myDate-- '+myDate);
              bodyLabel = bodyLabel.replace('<created>', myDate);
              system.debug('++++bodyLabel-- '+bodyLabel);
              String bodyTable = getTableEmailBody(renewal, 'Final', count);
              system.debug('++++bodyTable-- '+bodyTable);
              String body = bodyLabel + bodyTable;          
              sendEmail(subject, body, renewal);
            }
        }Catch(Exception e){
            CreateExceptionLog.insertErrorLog(e, null, null, renewals, 'Apex Class', 'SGRRenewalBatch__c', null, 'SGR_RenewalEmailProcessor.sendRenewalEmail','Low');  
        }
    }
    private static List<String> getDivisionUserRoles(String profile, String division){
        List<String> roles;
        
        List<SGR_Renewal_Emails__mdt> divRoles = [Select Id, Division_Role__c from SGR_Renewal_Emails__mdt where User_Profile__c = :profile AND DeveloperName = :division LIMIT 1];
        if(divRoles.size() > 0){
            String role = divRoles[0].Division_Role__c;
            roles = role.split(',');
        }
        return roles;
    }
     private static String getSandboxName(){
        string sandboxName;
        Boolean isSandbox = [SELECT Id, InstanceName, IsSandbox, Name, OrganizationType FROM Organization].IsSandbox;
		if(isSandbox){
			sandboxName  = userInfo.getUserName().substringafterLast('.');
			system.debug('sandboxName--'+sandboxName);
		}
        return sandboxName;
    }
}