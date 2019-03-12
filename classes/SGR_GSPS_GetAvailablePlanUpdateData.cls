public class SGR_GSPS_GetAvailablePlanUpdateData {
    public List<Plan__c> allPlanList;
    public List<Product2> allProductList;
    public List<Benefit_Header_Detail__c> allBenefitHeaderDetailList;
    public List<Benefit_Header__c> allBenefitHeaderList;
    public List<SGR_Note__c> allNoteList;
    public List<Benefit_Header_Detail_Association__c> allBHDAssignList;
    public List<Plan_Note_Association__c> allPlanNoteAssignList;
    public List<Product_Note_Detail_Association__c> allProductNoteDetailAssoList;
    public List<Benefit_Header_Association__c> allBenefitHeaderAssoList;
    public List<SGR_Note_Detail__c> allNoteDetailList;
    public List<FW_Service_Status_Log__c> allInteLogList;
    public List<SGR_Plan_FIPS_Map__c> allPlanFipsList;
    public String newAccessToken;// temporarly hold the newAccessToken if current access token is expired. doing this is to avoid update until the end of the loop. 
    public Datetime lastTokenUpdateDateTime;

    public SGR_GSPS_GetAvailablePlanUpdateData() {
        this.allPlanList = new List<Plan__c>();
        this.allProductList = new List<Product2>();
        this.allBenefitHeaderDetailList = new List<Benefit_Header_Detail__c>();
        this.allBenefitHeaderList = new List<Benefit_Header__c>();
        this.allNoteList = new List<SGR_Note__c>();
        this.allNoteDetailList = new List<SGR_Note_Detail__c>();
        this.allInteLogList = new List<FW_Service_Status_Log__c>();
        this.allPlanNoteAssignList = new List<Plan_Note_Association__c>();
        this.allBHDAssignList = new List<Benefit_Header_Detail_Association__c>();
        this.allBenefitHeaderAssoList = new List<Benefit_Header_Association__c>();
        this.allProductNoteDetailAssoList = new List<Product_Note_Detail_Association__c>();
        this.allPlanFipsList = new List<SGR_Plan_FIPS_Map__c>();
        this.newAccessToken = null;
        this.lastTokenUpdateDateTime = null;
    }
}