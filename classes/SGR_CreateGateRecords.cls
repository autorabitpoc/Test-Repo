/**************************************************************************************
  Apex Class Name     : SGR_CreateGateRecords     
  Version             : 1.0
  Function            : Batch class to populate Gate records
  
* Modification Log    :
* Shankar		10/03/2018		SFDC-12882 - Initial version
* Shankar		11/29/2018		Changes to send emails using EmailUtility
* ----------------------------------------------------------------------------               
* INFOSYS                 10/03/2018               Original Version
*************************************************************************************/
global class SGR_CreateGateRecords implements Schedulable {
	
	Integer refYear;
    String fundingType;
    String marketSeg;
	
	global SGR_CreateGateRecords(Integer refYear, String fundingType, String marketSeg) {
		this.refYear = refYear;	
        this.fundingType = fundingType;
        this.marketSeg = marketSeg;
	}
	
    global void execute(SchedulableContext con) {
    	String body ='';
    	String subject = '';
        List<Division__c> divs = Division__c.getAll().values();
        
        
         List<String> toAddresses = new List<String>();
         List<SGR_EmailDL__c> dls = SGR_EmailDL__c.getAll().Values();
       
        
        for (SGR_EmailDL__c dl: dls) {
        	if (dl.TaskName__c == 'SGR_CreateGateRecords') {
            	toAddresses.add(dl.To__c);
        	}
        }
        
        
        
        if (divs.isEmpty()) {
             System.debug('Divison__c custom setting not set properly');
            if (!Test.isRunningTest()) {
                body = 'Hi,<br/>Gates could not be created.<br/><br/>Reason: <br/>No divisions found in Division__c custom setting<br/><br/>Thanks,<br/>SGR Gate Creation Batch Job';
                subject = 'Gate Creation batch job Failed';
            	EmailUtility.circulateEmail(toAddresses, subject, body);
            }
            return;
        }
        if (null == refYear) {
        	refYear = System.today().year()+1;
        }
        Date referenceDate = Date.newInstance(refYear, 1, 1);
        System.debug('referenceDate:'+referenceDate);
        
        
        
        String divsInExistingGates = '<br/>';
        List<Actuary_Gate__c> existingGates = [Select Id, Effective_Date__c, Division__c, Funding_Type__c, Market_Segment__c from Actuary_Gate__c where Effective_Date__c >= :referenceDate];
        Set<String> gateKeys = new Set<String>();
        if (!existingGates.isEmpty()) {
            
            for (Actuary_Gate__c eg: existingGates) {
            	String key = eg.Division__c + ':' + eg.Effective_Date__c + ':' + eg.Funding_Type__c + ':' + eg.Market_Segment__c;
            	key = key.toUpperCase();
                gateKeys.add(key);
                divsInExistingGates = divsInExistingGates+ eg.Division__c + ': ' + eg.Effective_Date__c + '<br/>';
            }           
        }
        
        try {
            List<String> divNames = new List<String>();
            for (Division__c d: divs) {
                divNames.add(d.Name);
            }
            
            System.debug('gateKeys:: '+ gateKeys);
            List<Actuary_Gate__c> gatesToInsert = new List<Actuary_Gate__c>();
            
            for(String div: divNames) {
                for (integer month = 1; month<=12; month++) {
                    Date effDate = Date.newInstance(refYear, month, 1);
                    
                    String key = div + ':' + effDate + ':' + this.fundingType + ':' + this.marketSeg;
                    key = key.toUpperCase();
                    if (gateKeys.contains(key)) { 
                    	continue;
                    }
                    
                    Actuary_Gate__c gate = new Actuary_Gate__c(Division__c=div, Funding_Type__c='PREM', Status__c='Down',Market_Segment__c='SG', Effective_Date__c=effDate);
                    gatesToInsert.add(gate);
                }
            }
            System.debug('Gates to be inserted:'+gatesToInsert);
            
            if (!gatesToInsert.isEmpty()) {
                insert gatesToInsert;
            }
            
            if (!Test.isRunningTest() && !'<br/>'.equalsIgnoreCase(divsInExistingGates)) {
				System.debug('Gates already exists'); 
            	body = 'Hi,<br/>Gates could not be created.<br/>Reason: <br/>Gates exists already for these Division-Month combination:<br/><br/>'+divsInExistingGates + 'Thanks,<br/>SGR Gate Creation Batch Job';
                subject = 'Gate creation batch job Failed';
            	EmailUtility.circulateEmail(toAddresses, subject, body);  
            	return;          	
            }
            
        } catch(Exception e) {
            System.debug(e.getMessage());
            if (!Test.isRunningTest()) {
            	body = 'Hi,<br/>Gates could not be created for the year ' + refYear + '.<br/><br/>Reason: <br/>: '+e.getMessage() + '<br/>Thanks,<br/>SGR Gate Creation Batch Job';
                subject = 'Gate creation batch job Failed';
            	EmailUtility.circulateEmail(toAddresses, subject, body);  
            }
        }
        if (!Test.isRunningTest()) {
        	body = 'Hi,<br/>Gates created successfully for the year ' + refYear + '<br/>Thanks,<br/>SGR Gate Creation Batch Job';
            subject = 'Gate creation batch job Completed';
            EmailUtility.circulateEmail(toAddresses, subject, body);  
        }
    }
}