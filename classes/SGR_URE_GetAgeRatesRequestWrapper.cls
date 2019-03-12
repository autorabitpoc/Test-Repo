public class SGR_URE_GetAgeRatesRequestWrapper {

    
    
    public RffRequestWrapper rffRequest;
   
    public class RffRequestWrapper {
    public URE_CompositeRates compositeRates;
    public URE_Census census;
	public String rateEffectiveDate;
    public string referenceId;
    public Integer requestType;
    public string applicationId;
    public string rateSize;    
    public string corporateEntityCode; 
    public string marketSegment;
    public boolean isExchange;
    public String countyCode; 
    public URE_Plans plans;
	public URE_Tasks tasks;
    
}
    
    public class URE_CompositeRates {
		public List<String> type ;
    }
 public class URE_Plans 
    {
    	public List<URE_Plan> plan;
        
    }
    public class URE_Tasks 
    {
    	public List<String> task;
    }  
    
 public class URE_Census 
 {
   public List<URE_CensusDetail> censusDetail;
 }
 public class URE_CensusDetail 
    {
		public URE_Plans plans;
		public String censusDetailId;
		public String subscriberId;
		public String dateOfBirth;
		public Integer age;
		public String relationshipCode;
		public Boolean isTobacco;
		public Boolean isTefra;
		public String countyCode;
	}
    
    public class URE_Plan
    {
       public String planId;
    }
       
    
}