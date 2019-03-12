public class SGR_DateUtils {
    public static Date parseDate(String dateStr) {
        Date resultDate = null;
        String dateSubStr = null;
        Boolean hasTime = dateStr.contains(':'); // look for hh mm ss separator
        if (!hasTime) {
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
		System.debug('Returning resultDate::'+resultDate);
        return resultDate;
    }

}