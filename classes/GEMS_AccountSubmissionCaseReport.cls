public class GEMS_AccountSubmissionCaseReport {
    @Auraenabled
    public static List<Id> GEMS_AccSubmissionCaseReport(){
        Id theId;
        String testValue;
        List<Id> caseIds = new List<Id>();                
        
        //Call method to get ReportId for SOQL
        String reportId = caseReportID();
        if(reportId != Null)
        {
            // Run the report
            Reports.ReportResults results = Reports.ReportManager.runReport(reportId, true);
            
            // Get the first down-grouping in the report
            Map<String,Reports.ReportFact> factDetails = results.getFactMap();
            Map<String,Reports.ReportDataCell> returnMapList = new Map<String,Reports.ReportDataCell>();
            System.debug('Map: '+ factDetails);
            Set<String> s = factDetails.keySet();
            System.debug('Map Keyset: '+ s);
            
            for(String theKey : factDetails.keySet()){ 
                Reports.ReportFactWithDetails theReportFact = (Reports.ReportFactWithDetails)factDetails.get(theKey);
                System.debug('factDetails' + theReportFact); 
                LIST<Reports.ReportDetailRow> theReportDetailRows = theReportFact.getRows();
                for(Reports.ReportDetailRow aDetailRow : theReportDetailRows){
                    List<Reports.ReportDataCell> theReportDataCells = aDetailRow.getDataCells();
                    for(Reports.ReportDataCell aCell : theReportDataCells){
                        System.debug('aCell value: ' + aCell.getValue() + ' label: ' + aCell.getLabel());
                        testValue = String.valueOf(aCell.getValue());  //convert the Report Data to a String to Test if it is a Case Id
                        system.debug('testValue  '+testValue);
                        if(testValue instanceof Id){
                            // it is a SF Id 
                            theId = Id.valueOf(testValue);
                            // determine what type of Object belongs to that Id
                            Schema.sObjectType entityType = theId.getSObjectType();
                            if(entityType == Case.sObjectType){
                                caseIds.add(theId);
                                //the Id matches the Case Object       
                                System.debug('This is a Case from Report: ' + theId);
                            }
                        }
                    }
                }
            } 
        }
        
        return caseIds;
    }
    
    @Auraenabled
    public static List<Case> caseReportDetails(){
        List<case> returnCaseList = new List<Case>();
        List<case> returnTempCaseList = new List<Case>();
        List<Id> returnedCaseIds = new List<Id>();
        returnedCaseIds = GEMS_AccSubmissionCaseReport();
        try{
            if(returnedCaseIds.size()>0)
            {
                returnCaseList = [Select 
                                  Id, 
                                  Subject, 
                                  CaseNumber, 
                                  AccountId, 
                                  Account_Name__c, 
                                  Account.Name, Milestone__c, 
                                  Opportunity_Name__c,
                                  Opportunity_Name__r.Name,
                                  Owner_Name__c,
                                  Status,
                                  GEMS_Case_Effective_Date__c
                                  FROM CASE 
                                  WHERE Id IN :returnedCaseIds 
                                  ORDER BY Account_Name__c ASC, CaseNumber ASC 
                                 ];
            }
            
        }catch(Exception e){
            system.debug('Error Message'+e.getMessage());
            throw new AuraHandledException('Unexpected system error has occured: ' + e.getMessage());
        }
        system.debug('returnCaseList:::::'+returnCaseList);
        return returnCaseList;
    }
    
    @Auraenabled
    public static String caseReportID(){
        String theReturn = '';
        
        //Get the Report Name from Custom Setting
        GEMS_AccountSubmissionCaseReport__c customSetting = GEMS_AccountSubmissionCaseReport__c.getInstance();        
        String theReportName = customSetting.Report_Name__c;        
        
        //Get the Report Id to pass back to Component
        Report aReport = [SELECT Id FROM Report WHERE DeveloperName = :theReportName LIMIT 1];
        if(aReport !=Null)
        {
            //Convert to STring
            theReturn = Id.valueOf(aReport.Id);   
        }
        Return theReturn;
    }
    
}