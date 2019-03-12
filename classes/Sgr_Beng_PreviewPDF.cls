public class Sgr_Beng_PreviewPDF {    
    @AuraEnabled
    public static Opportunity getOppData(Id oppId) {
        
        Opportunity opp = [SELECT ID,Rating_Status__c,CurrentUserProfileName__c,Account.External_ID__c FROM Opportunity WHERE ID=:oppId];
        return opp;
    }
    
    @AuraEnabled
    public static Map<ID,String> oppDetails(String oppId,String documentVersion,string printtype, String accNumber) {
        
        Map<ID,String> conDocIdAndMessage= new Map<ID,String>();
        Beng_PDF_Preview_profiles__c cs = Beng_PDF_Preview_profiles__c.getValues(UserInfo.getProfileId());
        if(cs!=null){
            SGR_Beng_XML_Response Response = Sgr_Beng_Request.SendRequest(oppId, 'DRAFT','Account');       
            // pass to SGR_Beng_DocHandler to start testing
            SGR_Beng_DocHandler handler = new SGR_Beng_DocHandler();
            handler.oppId = oppId;  
            String dt = Datetime.now().format('yyyy-MM-dd\'_\'HHmmss');
            handler.fileName = accNumber+'_'+dt+'.pdf';    
            handler.documentBase64Encoded=String.valueOf(Response.base64Template);
            handler.saveDraft();
            system.debug('+++Response'+Response);
            if(Response!=null){
                String docName = accNumber+'_'+dt+'.pdf';
                List<contentDocument> contDocList = [Select id,Title,FileType,CreatedBy.Name,ContentSize From contentDocument where Title=:docName LIMIT 1];
                Opportunity opty = [SELECT Id,Beng_LatestTransactionID__c FROM Opportunity WHERE ID=:oppId];    
                opty.Beng_LatestTransactionID__c=Response.transactionId;
                update opty;
                if(contDocList.size()>0){
                    conDocIdAndMessage.put(contDocList[0].Id,Response.message);
                }else{
                    conDocIdAndMessage.put(null,Response.message);
                }
            }
        }else{
            conDocIdAndMessage.put(null,null);
        }
        return conDocIdAndMessage;
    }
}