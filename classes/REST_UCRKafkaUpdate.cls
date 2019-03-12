@RestResource(urlMapping='/UCRKafkaUpdate/*')
global with sharing class REST_UCRKafkaUpdate {
    
    @HttpPost
    global static UCRKafkaSFResponse updateOpportuniy(String AccountNumber, String OpportunityId, String CorrespondanceId) {
        Boolean accountFound = false;
        Boolean opptyFound = false;
        String validationFailAccount = 'Unable to locate Account with Account #: {0}';
        String validationFailOppty = 'Unable to locate Opportunity with Id: {0}';
        String sucessMessage = 'Request process successfully';
        String failMessage = 'Request process failed';
        String FailureStatus = 'FAILURE';       
        system.debug('calling Update Opportunity from REST_UCRKafkaUpdate web service->> account Number:'+AccountnUmber);
        String divisionCode=null;
        UCRKafkaSFResponse response = new UCRKafkaSFResponse();

        response.AccountNumber = AccountNumber;
        response.OpportunityId = OpportunityId;
        response.CorrespondanceId = CorrespondanceId;
        response.Message = sucessMessage; 
        response.Status = 'SUCCESS';
        try{
            List<Opportunity> OpptyList = getOpportunities(response.OpportunityId);
            List<Account> AccList = getAccounts(response.AccountNumber);
            
          
            accountFound = AccList.size() > 0;
            opptyFound = OpptyList.size() > 0;

            if(!accountFound) {
                response.FailureReason = String.format(validationFailAccount, new String[] {response.AccountNumber});
                response.Message = failMessage;
                response.Status = FailureStatus;
            }else{
            	
                if(!opptyFound) {
               
                    response.FailureReason = String.format(validationFailOppty, new String[] {response.OpportunityId});
                    response.Message = failMessage;
                    response.Status = FailureStatus;
                }else{
                 String resultStr=updateOpportunity(AccountNumber, OpportunityId);
                 if(resultStr!=null && resultStr.Equals('SUCCESS')){
                 	 response.Status ='SUCCESS';
                 }else{
                 	response.Status = FailureStatus;
                    response.Message = failMessage;
                 	response.FailureReason=resultStr;
                 }
                }
            }
           
        }
        catch(Exception error){
            response.Message = failMessage;
            response.Status = FailureStatus;
            response.FailureReason = error.getMessage();
        }

 
        return response;
    }
    
    @testVisible
    private static String updateOpportunity(String accountNumber, String opportunityId){
    	string result='SUCCESS';
    	string accNum='';
    	String divisionCode='';
        String updateEmailOptout = '';
    	try{
    		
    		Opportunity opp=[select id,AccountId, Final_Renewal_Exhibit__c,Rating_Status__c,SGR_Workflow_Activity__c,Workflow_System_Status__c, Renewal_Document_Uploaded__c, Renewal_Upload_DateTime__c from Opportunity where id=:opportunityId limit 1];
    		if (opp!=null){
                if(AccountNumber!=null){
            	    divisionCode=getDivision(accountNumber);
            	    accNum=get6DigitNumber(accountNumber);
                 }
    			String ucrURL=system.label.UCR_Final_PDF_URL;
    			ucrUrl=ucrURL.replace('<division>',divisionCode);
    			ucrUrl=ucrURL.replace('<account number>',accNum);
    			//ucrUrl=ucrURL.replace('<hostname>',system.label.UCR_URL_TEST_HOST_NAME);
    			
    			opp.Final_Renewal_Exhibit__c=ucrURL;//system.label.UCR_Final_PDF_URL+accountNumber+system.label.UCR_FINAL_PDF_URL2;
    			opp.Renewal_Document_Uploaded__c=TRUE;
    			opp.Renewal_Upload_DateTime__c=system.now();
    			if(system.label.UCR_Rating_Status_Updated_Value!=''){
    			  opp.Rating_Status__c=system.label.UCR_Rating_Status_Updated_Value;//'Sold';
    			}
    			if(system.label.UCR_WorkFlow_Activity_Updated_Status!=''){
    			    opp.SGR_Workflow_Activity__c=system.label.UCR_WorkFlow_Activity_Updated_Status;//'Awaiting BlueSTAR Transfer';
    			}
    			if(system.label.UCR_WorkFlow_System_Status_Updated_Value!=''){
    			   opp.Workflow_System_Status__c=system.label.UCR_WorkFlow_System_Status_Updated_Value;//'Ready to Send to B-Engaged';
    			}
                try{
                    updateEmailOptout = SGR_Email_Optout.returnOppFieldsUpdate(opp.Rating_Status__c, opp.SGR_Workflow_Activity__c, opp.AccountId);
                    if(updateEmailOptout != NULL && !String.isBlank(updateEmailOptout)){
                        if(updateEmailOptout == 'Distribute_Via_Mail_to_Account__c_Producer__c')
                        {
                            opp.Distribute_Via_Mail_to_Account__c = True;
                            opp.Distribute_Via_Mail_to_Producer__c = True;
                        }
                        else if(updateEmailOptout == 'Distribute_Via_Mail_to_Producer__c'){
                             opp.Distribute_Via_Mail_to_Producer__c = True;
                        }
                        else if(updateEmailOptout == 'Distribute_Via_Mail_to_Account__c'){
                            opp.Distribute_Via_Mail_to_Account__c = True;
                        }
                    }
                }catch(exception e){
                    system.debug('SGR_Email_Optout.returnOppFieldsUpdate exception'+e+' '+e.getLineNumber());
                }
    			update opp;
    		}
    	}catch(dmlException dml){
    		system.debug('dml exception:'+dml+' update opportunity exception::'+dml.getMessage());
    		result=dml.getMessage();//'Update Error! Please Contact System Administrator.';//dml.getMessage();
    	}
    	return result;
    }
    
	@testVisible
    private static List<Opportunity> getOpportunities(String opportunityId) {
        return [SELECT Id, Name
                FROM Opportunity 
                WHERE Id = :opportunityId];
    }
	@testVisible
    private static List<Account> getAccounts(String AccountNumber){
        return [SELECT Id, External_Id__c 
                FROM Account 
                WHERE External_Id__c = :AccountNumber];
    }

    private static String getDivision(String accountNum){
    	String stateCode=null;
    	
    	if(accountNum!=null && accountNum.length()>2){
    	    stateCode=accountNum.subString(0,2); 
    	}
    	return stateCode;
    }

    private static String get6DigitNumber(String accountNum){
    
    	if(accountNum!=null && accountNum.length()>6){
    		return accountNum.substring(2);
    	}else{
    		return accountNum;
    	}
    }
    global class UCRKafkaSFResponse {
        public String Message {get; set;}
        public String Status {get; set;}
        public String AccountNumber {get; set;}
        public String OpportunityId {get; set;}
        public String CorrespondanceId {get; set;}
        public String FailureReason {get; set;}
    }

}