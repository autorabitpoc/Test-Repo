public with sharing class DTOQuoteRateRequest {
    public String hcscDivision;
    public String accountNumber;
    public String accountName;
    public String requestType;
    public String opportunityName;
    public String quoteReqId;
    public String quoteReqDesc;
    public String salesRep;
    public Date rateEffectiveDate;
    public DateTime lastModifiedDate;
   
   public DTOQuoteRateRequest(){
      hcscDivision=null;
      accountNumber=null;
      accountName=null;
      requestType=null;
      opportunityName=null;
      quoteReqId=null;
      quoteReqDesc=null;
      salesRep=null;
      rateEffectiveDate=null;
      lastModifiedDate=null;
 }
}