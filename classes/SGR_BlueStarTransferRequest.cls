public class SGR_BlueStarTransferRequest {
    public opportunityDetails opportunityDetails;
    public list<plan> plans;
    public class opportunityDetails{
        public string corpEntCd;
        public string acctNbr;                
        public string acctNm;        
        public string acctRnewlDt;
        public string mktSegCd;
        public string opportunityId;
        public string modNbr;
        public string underwriterID;
        public string acaAtstnCd;
        public string formRcvdDt;
        public string rtSzCd;
    }
    public class plan{
        public string mktgPlnNbr;
        public string effectiveDate;                
        public string oldMktgPlnNbr;
		public string regionCd;      
        public string invitroInd;
        public string visInd;
        public string hsaInd;
        public string totRtChgPct;
        public string totAdminChrgPct;
        public string ureAreaNbr;
    }
}