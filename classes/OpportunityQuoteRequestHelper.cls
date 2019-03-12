public with sharing class OpportunityQuoteRequestHelper {
    
    public list<OppQuoteRequestDAO> oppQuoteRequestlist {get;set;}
    public Opportunity opp{get;set;}
    public Account oppAcct{get;set;}
    public Quote_Request_Summary__c quoteRequest{get;set;}
    public String oppRecordTypeName{get;set;}
    
  //  public String selectedPricingOption {get;set;}
    
   
    public OpportunityQuoteRequestHelper(){}
    
    public Opportunity getOpp(){
    	return this.opp;
    }
    
  	public static List<SelectOption> getProdCategories() {
  		List<SelectOption> options = new List<SelectOption>();
        
   		Schema.DescribeFieldResult fieldResult =product2.Product_Category__c.getDescribe();
   		List<Schema.PicklistEntry> categories = fieldResult.getPicklistValues();
           options.add(new SelectOption('', 'All'));//first one
           
   		for( Schema.PicklistEntry c : categories){
   			if(!c.getValue().equalsIgnoreCase('none')){
      			options.add(new SelectOption(c.getValue(),c.getLabel()));
   			}
   		}       
   		 return options;
 	}
 
 	public static List<SelectOption> getFundingType() {
  		List<SelectOption> options = new List<SelectOption>();
        
   		Schema.DescribeFieldResult fieldResult =Account.Funding_Type__c.getDescribe();
   		List<Schema.PicklistEntry> fundingTypes = fieldResult.getPicklistValues();
        //   options.add(new SelectOption('', 'All'));//first one
           
   		for( Schema.PicklistEntry f : fundingTypes){
      		options.add(new SelectOption(f.getValue(),f.getLabel()));
   		}       
   		 return options;
 	}
 	
 	public static List<SelectOption> getProdTypes(){
 		List<SelectOption> options = new List<SelectOption>();
        
 		
 		Schema.DescribeFieldResult fieldResult =Product2.Product_Type__c.getDescribe();
   		List<Schema.PicklistEntry> prodTypes = fieldResult.getPicklistValues();
           options.add(new SelectOption('', 'All'));//first one
           
   		for( Schema.PicklistEntry p :prodTypes){
   			if(!p.getValue().equalsIgnoreCase('none')){
      			options.add(new SelectOption(p.getValue(),p.getLabel()));
   			}
   		}       
   		 return options;
 	}
 	
    public static List<SelectOption> getProdFamilies(){
    	List<SelectOption> options = new List<SelectOption>();
        
    	Schema.DescribeFieldResult fieldResult =Product2.Family.getDescribe();
   		List<Schema.PicklistEntry> families= fieldResult.getPicklistValues();
           options.add(new SelectOption('', 'All'));//first one
           
   		for( Schema.PicklistEntry f :families){
   			if(!f.getValue().equalsIgnoreCase('none')){
      			options.add(new SelectOption(f.getValue(),f.getLabel()));
   			}
   		}       
   		return options;
    }
    
   /*  public static List<SelectOption> getBillings(){
    	List<SelectOption> options = new List<SelectOption>();
        
    	Schema.DescribeFieldResult fieldResult =Pricebookentry.Billings__c.getDescribe();
   		List<Schema.PicklistEntry> bills= fieldResult.getPicklistValues();
    
        options.add(new SelectOption('None', '-None-'));//first one
   		for( Schema.PicklistEntry b :bills){
      		options.add(new SelectOption(b.getValue(),b.getLabel()));
   		}       
   		return options;
    }*/
    
   public Id getRecordTypeId(String typeName, String objectName){
    	
    	RecordType recType=[select Id, name from RecordType where (developerName =:typeName OR name=:typeName) and SobjectType =:objectName];
    	if(recType!=null){
    		return recType.id;
    	}
    	return null;
    }
    
    /**
    **This method to parse stringtoken by ; into string list and return in option list
    ** @return list<SelectOption>
    **
    */
    /* public List<SelectOption> parseForOption(String optionStr){
    
    
          //Get all Group Numbers
        List<SelectOption> options = new List<SelectOption>();
     
        
       Integer ct=1;
       options.add(new SelectOption('0', '-None-'));
       
       for(String op : getStrOption(optionStr)) {
            op=op.trim();
            op=op.replace('  ',' ');
            system.debug('op:::-->'+op+'<----');
            options.add(new SelectOption(ct+'', op));
            system.debug('price option:::::'+options);
           ct++;
        }   
       
        return options;
    }
    */
    
  /*public List<SelectOption> parseBillingOptions(String optionStr){
    
    
          //Get all Group Numbers
        List<SelectOption> options = new List<SelectOption>();
     
        system.debug(' optionStr:::::'+optionStr);
       Integer ct=1;
       
       list<String> optionsList=getStrOption(optionStr);

       if(optionsList!=null && optionsList.size()>1){ // if there are more than two, if only one,dispaly the actual value
          options.add(new SelectOption('0', '-None-'));
       }

        for(String op : optionsList) {
            op=op.trim();
            op=op.replace('  ',' ');
            options.add(new SelectOption(op, op)); // '1', 'Option1'
          //  system.debug('price option:::::'+options);
          
        }   
        system.debug(' options::::::'+options);
       
        return options;
    }  */
    
   /**
    **This method to parse stringtoken by || into string list and return in option list
    ** @return list<SelectOption>
    **
    */
     public List<SelectOption> parseStrTxtIntoOptions(String optionStr){
    
    
          //Get all Group Numbers
        List<SelectOption> options = new List<SelectOption>();
     
        system.debug(' optionStr:::::'+optionStr);
       Integer ct=1;
       
       list<String> optionsList=getStrOption(optionStr);

       if(optionsList!=null && optionsList.size()>1){ // if there are more than one
          options.add(new SelectOption('0', '-None-'));
       }
       for(String op : optionsList) {
            op=op.trim();
            op=op.replace('  ',' ');
            system.debug('op:::-->'+op+'<----');
            options.add(new SelectOption(ct+'', op)); // '1', 'Option1'
            system.debug('price option:::::'+options);
           ct++;
        }   

        system.debug(' options::::::'+options);
       
        return options;
    }  
    
  private list<String> getStrOption(String longStr){
  	 List<String> listOpt = new list<String>();
        
        //To get the list of available Group Numbers    
       if (longStr != null && longStr.length()>0){
            listOpt = longStr.remove('<BR>').split('</b>');    
            system.debug(listOpt);
        }
        
        return listOpt;
  }

  /**
  ** this method is to return the Pricing reference option based on the selected Product Service Detail from UI.
  **/
    
  public String getPricingReference(OppQuoteRequestDAO row){

    String pricingReference='Not Available';
    SelectOption option=null;//new SelectOption();
    if(row!=null){
      system.debug(' selected ProductDetail Option:::::: '+row.productDetailOption);
      if(row.productDetailOption !=null){

          Integer num=Integer.valueOf(row.productDetailOption); //value if "Int", Label is text
        system.debug('pricing Reference Options::::::'+row.PricingReferenceOptions);
         if(row.pricingReferenceOptions!=null){ 
             if(num+1<=row.pricingReferenceOptions.size()){
               option=row.pricingReferenceOptions[num];//.get(num);
               system.debug(' pricing Reference Options:::::'+option);
               pricingReference=option.getLabel();
            }
         }
             
      }
    }
    
    system.debug(' return Pricing Reference : '+pricingReference);
    return pricingReference;

  }

  /*
  public String getPriceNote(OppQuoteRequestDAO row){
    String priceNote='Not Available';
    
    
    if(row!=null){
    
   	 system.debug('selectedPricingOption: '+row.pricing);
     String longNote=row.pricingNote;
     
     //check if the price1Note have [All] which mean the same note for all pricing
     if(row.pricing1Note!=null && row.pricing1Note.startsWithIgnoreCase('[All]')){
      	 priceNote=row.pricing1Note;
      } else{
    
         	 if(row.pricing!=null && Integer.valueOf(row.pricing)==1){
            
            	  priceNote=row.pricing1Note;
             
            	 system.debug('priceNote1:::::'+priceNote);
     		  }else if(row.pricing!=null && Integer.valueOf(row.pricing)==2){
       	     
             	 priceNote=row.pricing2Note;
              
      		  }else if(row.pricing!=null && Integer.valueOf(row.pricing)==3){
             		 priceNote=row.pricing3Note;
       		  } else { 
       		  	     priceNote='None';
       		  }
         
         		if(priceNote==null ||priceNote==''){
         		   priceNote='None';
       	  }  
     } 
    
    }
    system.debug('priceNote:::::'+priceNote);
    return priceNote;
    
 }
 
  */
}