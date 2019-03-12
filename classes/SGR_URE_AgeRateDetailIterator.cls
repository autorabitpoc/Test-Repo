global class SGR_URE_AgeRateDetailIterator implements Iterator<SGR_Plan_Age_Rate_Detail__c>, Iterable<SGR_Plan_Age_Rate_Detail__c> { 

   public List<SGR_Plan_Age_Rate_Detail__c> source {get; set;} 
   Integer i {get; set;} 

   global Iterator<SGR_Plan_Age_Rate_Detail__c> iterator() { 
       return this;
   }   

  global SGR_URE_AgeRateDetailIterator(List<SGR_Plan_Age_Rate_Detail__c> source) { 
       this.source = source;
       i = 0;
   }  

   global boolean hasNext(){ 
   		return (i>source.size());
   }    

   global SGR_Plan_Age_Rate_Detail__c next(){ 

       if(i >= source.size()) {return null;} 
       i++; 
       return source[i-1]; 
   } 
}