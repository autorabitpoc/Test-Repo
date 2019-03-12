public with sharing class OppQuoteRequestDAO {
	
	   
	  
	 //   public String pricing1{get;set;}
		//public String pricing1Note{get;set;}
	//	public String pricing2{get;set;}
	//	public String pricing3{get;set;}
	 //   public String pricing2Note {get;set;}
	 //   public String pricing3Note{get;set;}
	  	public String netWork {get;set;}
	
	   
	//    public Decimal price=0.0;
	
	 //   public boolean onExchange {get;set;}
	   
	   
	    public Date effectiveDate {get;set;}
	    public id priceBookEntryId {get;set;}
	    public id priceBookId{get;set;}
	   
	    public id quoteId{get;set;}
	    public id productId{get;set;}
	    public String prodId{get;set;}
		public String prodName{get;set;}
		public String prodFamily {get;set;}
		public String prodCode {get;set;}
		public String prodType{get;set;}
	    public String prodrecordType{get;set;}
	    public boolean isFuture {get;set;}
	    public boolean isCurrent{get;set;}
	    public boolean isMarketCheck {get;set;}
	    public integer rowIndex{get;set;}
	  //  public String pricing{get;set;}
	  //  public String pricingNote{get;set;}
	    public list<SelectOption> billingOptions {get;set;}
	    public list<SelectOption>productDetailOptions {get;set;}
        public list<SelectOption>pricingReferenceOptions {get;set;}
      //  public String selectedProductDetailNum {get;set;}
        public String pricingReferenceOption {get;set;}
        public String productDetailOption {get;set;}
        public String billingOption {get;set;}

	  //  public String selectedBillingOption {get;set;}
	    public String hcscState{get;set;}
	  //  public String prodRecordType{get;set;}
	    
	  //  public list<SelectOption>pricingOptions {get;set;}
	 //  public String selectedPrice {get;set;}
	
	   
	   // public PriceBookEntry pbeData{get;set;}
	//    public Account  acct{get;set;}
	 //   public Opportunity opp{get;set;}
	    public String comment{get;set;}
	    public String extraFundingtype{get;set;}
	    public String oppotunityType {get;set;}
	
	    
        public OppQuoteRequestDAO(){}
      //  public OppQuoteRequestDAO(PriceBookEntry book){
        //	this.pbeData=book;
        //}
    
}