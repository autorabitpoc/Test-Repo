public with sharing class Utility {
    
 public static  Map<Integer, String> constantMap =getConstantValues();
 
 public static Map<Integer, String> getConstantValues(){
    
    // Return Value
    Map<Integer, String> tempMap = new Map<Integer, String>(); 
    
    // Fetch values from Custom Setting - SG_Constants__c
    for (SG_Constants__c consObj : SG_Constants__c.getAll().values()) {
      tempMap.put(Integer.valueOf(consObj.Name), consObj.Constant_Values__c);
    }
  
    // return tempMap
    return tempMap;
 }
  
 
  public static void sendEmails (String toAddress, String subject, String emailMessage) {
        
        // Variable
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{};
        toAddresses.add(toAddress);
        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);
        mail.setPlainTextBody(emailMessage);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });        
    } 
    
    /**
   ** Author: Mei Chen
   ** parm: NumOfDays- number of days from start date. For example, 5 days from due date.
   ** this method is to calculate the business date with excluding weekend and holiday defined in the company business hours.
   ** 
   **/
  public static Date getBusinessDate(Integer numOfDays){
   
    Datetime currentTime = System.now();
    TimeZone tz = UserInfo.getTimeZone();
    Id businessHourId = [select id, name from businesshours where name='GEMS SLA Business Hours' limit 1].id;

//check the current datetime falling on the same business day
    Boolean isSameDayWithinBusinessHour = BusinessHours.isWithin(businessHourId, System.now());// BusinessHoursServices.isWithin(System.now());
    Integer slaHours = numOfDays*24;//in hours
   
   Datetime targetDT = BusinessHours.add(businessHourId,currentTime, SLAhours* 60 * 60 * 1000L);
   Date targetedDate=date.newinstance(targetDT.year(), targetDT.month(),targetDT.day());
    if(!isSameDayWithinBusinessHour){//if not within hr
      DateTime targetDT2=BusinessHours.nextStartDate(businessHourId, targetedDate);
       targetedDate=date.newinstance(targetDT2.year(), targetDT2.month(),targetDT2.day());
   }
    return targetedDate;
   }
   
   /**
   **Author: Mei Chen
   ** This method is calculate the last of month with given date, ie. created date.
   **
   */
   public static Date getLastDayOfMonth(Datetime givenDate){
    Datetime startDate=givenDate;
    if(startDate==null){
        startDate=system.now();
    }
    Integer numberOfDays = Date.daysInMonth(startDate.year(), startDate.month());
    Date lastDayOfMonth = Date.newInstance(startDate.year(), startDate.month(), numberOfDays);
	return lastDayOfMonth;
   }
   
   /**
   ** Method Name: insertIntegrationLog
   ** @Author: Mei Chen
   **/
    public static void insertIntegrationLog(String serviceName, String anyId, String status, String errorDesc, Datetime executionStartTime,Datetime executionEndTime, String input, String output){
        try{
            FW_Service_Status_Log__c statusLog = new FW_Service_Status_Log__c();
            statusLog.Name = serviceName;
            statusLog.UID__c = anyId;
            statusLog.Status__c = status;          
            statusLog.ErrorDescription__c = errorDesc;
            statusLog.StartTime__c = executionStartTime;
            statusLog.EndTime__c = executionEndTime;
            statusLog.RequestBody__c = string.valueof(input);
            statusLog.ResponseBody__c = string.valueof(output);
			Database.insert(statusLog, false);
        }catch(Exception e){
        	e.getMessage();
         }
        
    }
    
    /***
    **
    **/
    public static FW_Service_Status_Log__c getIntegrationLog(String serviceName, String anyId, String status, String errorDesc, Datetime executionStartTime,Datetime executionEndTime, String input, String output){
          FW_Service_Status_Log__c statusLog = new FW_Service_Status_Log__c();
            statusLog.Name = serviceName;
            statusLog.UID__c = anyId;
            statusLog.Status__c = status;          
            statusLog.ErrorDescription__c = errorDesc;
            statusLog.StartTime__c = executionStartTime;
            statusLog.EndTime__c = executionEndTime;
            statusLog.RequestBody__c = string.valueof(input);
            statusLog.ResponseBody__c = string.valueof(output);
			return statusLog;
    }
    
    public static Date parseDate(String dateStr) {
        Date resultDate = null;
        String dateSubStr = null;
        Boolean hasTime = false; // look for hh mm ss separator
        if(dateStr==null){
          return null;
        }
        if (dateStr!=null && !hasTime) {
           hasTime =dateStr.contains(':');
            try {
                dateSubStr = dateStr.substring(0, Math.min(10, dateStr.length())); // Ignore time component - grabs date if format is in dd/mm/yyyy           
                resultDate = Date.parse(dateSubStr);
            } catch(Exception e) {
                // check if format is yyyy-mm-dd
                dateSubStr = dateStr.substring(0,10); // ignore time portion
                resultDate = Date.valueOf(dateSubStr);                
            } 
        } else {
            resultDate = parseDate(dateStr.split('T')[0]);              
        }
        
        if(resultDate.year()>4000) {
            resultDate = resultDate.addYears(4000 - resultDate.year());
        }
       return resultDate;
    }
    
    //Akbar -  This method returns unique id.
    public static string generateGUID(){
        Blob aes = Crypto.generateAesKey(128);
        return EncodingUtil.convertToHex(aes);
    }
    
    //Ravi - This method is used to insert error logs occred during DML.
    public static List<Error_Log__c> createErroLog(List<Database.UpsertResult> results){
       List<Error_Log__c> errMsgsList = new List<Error_Log__c>();
        for(Database.UpsertResult sv:results){
                    if(!sv.isSuccess()){
   
                        for(Database.Error err : sv.getErrors()) {
                             Error_Log__c errLog=new Error_Log__c();
							 errLog.Application__c=System.label.ErrorLog_Application_TriggerOff;
                             errLog.Error_Message__c=String.valueOf(err);
                             errMsgsList.add(errLog);
                        }
                    }
                    
         }
         return errMsgsList;
  }
}