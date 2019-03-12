public class LGNA_EIN_SendInput {
    public AccountDetails accountDetails;
    public list<EINInfo> einInfo;
    
    public class AccountDetails{
        public string accountName;
        public string accountNumber;                
        public string effectiveDate;        
        public string marketSegment;
        public string accountStructureCaseID;
        public string corpCode;
        public string sourceSystemCd;
        public string cobraAutoCancel;
        public string cobraCode;
        public string autoCatInd;
        //public string changereasoncode;
		public string primaryEIN;
        public string multipleEIN;
    }
    public class EINInfo{
        public string ein;
        public string einSeqNbr;
        public string chgReasonCode;
        public string effectiveDate;
        public string endDate;
        public string locName;
        public string street1;
        public string street2;
        public string city;
        public string state;
        public string zipCode;
        public string countyCode;
        public string countryName;
        public string countryCode;
    }
    
}