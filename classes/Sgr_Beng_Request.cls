/*
*   12/11/2018  Keerthi Navya Poornima Motupalli        SFDC-14852 SGR-BEngaged: Create request to call (send XML to) B-Engaged
*/
public class Sgr_Beng_Request {
    
    Private final static String SOURCE='salesforce';
    Private final static String DOCTYPE='Renewal';
    public final static String CORRESPONDANCE =Utility.generateGUID();
    
    public static SGR_Beng_XML_Response SendRequest(String oppId , String documentVersion,String printType)
    { 
        APICallOutRestWSUtility acr = new APICallOutRestWSUtility('B-Engage Callout');
        SGR_Beng_XML_Response response = acr.SendBengCallout(oppId,printType, documentVersion,DOCTYPE,CORRESPONDANCE,SOURCE);
            if(response!=null && oppId!=null){
                Opportunity opp = [SELECT ID,Beng_LatestCorrespondanceID__c FROM Opportunity WHERE ID=:oppId];
                opp.Beng_LatestCorrespondanceID__c=correspondance;        
                update opp;
            }
      return response;
    }
   
}