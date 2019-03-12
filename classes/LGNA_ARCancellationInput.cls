public class LGNA_ARCancellationInput {
    public AccountCanDetails accountCanDetails;
    public list<GroupSection> groupSections;
    public list<BillingProfile> billingProfiles;
    public list<Category> categories;
    
    public class AccountCanDetails{
        public string accountName;
        public string accountNumber;                
        public string effectiveDate;        
        public string marketSegment;
        public string accountStructureCaseID;
        public string corpCode;
        public string cobraAutoCancel;
        public string cobraCode;
        public string autoCatInd;
        public string changereasoncode;
        public string cancellationEffDate;
        public string cancellationCode;
        public string sourceSystemCd;
    }
    public class GroupSection{
        public string groupNumber;      
        public string sectionNumber;
        public string sectionDescription;
        public string changeReasonCode;
        public string cancellationEffDate;
        public string cancellationCode;
        public list<string> assignedBANumbers;
        public list<string> assignedCategoryNumbers;        
              
    }
     public class BillingProfile{
         public string billingProfileNumber;
         public string description;
         public string changeReasonCode; 
         public string cancellationEffDate;
         public string cancellationCode;
         public list<string> baNumbers;
         public list<string> categoryNumbers;
         public string billingAddressSequence; 
         
    }
     public class Category{
        public string categoryNumber;
        public string categoryDescription;  
        public string categoryCobraCode;  
     	public string changeReasonCode;
        public string cancellationEffDate;
        public string cancellationCode;
        public string productIndicator;
        public string billingIndicator;
        public string reportingIndicator;
        public string mailIndicator;      
       
    }

}