//************************************************************************************
// Name             : GEMS_AccountStructureOutputController .cls
// ************************Version Updates********************************************
// Date             Developer           Description
// -----------------------------------------------------------------------------------
// 4/3/2017         Ranjit Gandhi        Cancelled Ba's added to Grid output
// 4/15/2018        Jenny Dalsania       Acct Structure Excel Output Hide usage columns with no data in output
// 5/25/2018        Gokul Bharati        SFDC-9866 GEMS: Auto fit column width to data in rows on Account Structure output
// 05/29/2018       Malathi.K            SFDC-9952 Add Product Code Field to Grid, Account Structure Export and VF.
// ************************************************************************************

public class GEMS_AccountStructureOutputController {
    
    public String xlsHeader {
        get {
            String strHeader = '';
            strHeader += '<?xml version="1.0"?>';
            strHeader += '<?mso-application progid="Excel.Sheet"?>';
            return strHeader;
        }
    }
    public GEMS_AccountSetup accSetUp {get; set;}
    //Excel Config
    public boolean isBillingNumber {get; set;}
    public boolean isBillingDescription {get; set;}
    public boolean isMailingNumber {get; set;}
    public boolean isMailingDescription {get; set;}
    public boolean isReportingNumber {get; set;}
    public boolean isReportingDescription {get; set;}
    public boolean isProductNumber {get; set;}
    public boolean isProductDescription {get; set;}
    //Set the Column Label
    public string BANoLabel{get; set;}
    public string BACancelDateLabel{get; set;}
    public string BAProductLabel{get; set;}
    public string BADescriptionLabel{get; set;}
    public string BAProductCodeLabel{get; set;}
    public string BAFundTypeLabel{get; set;}
    public string BillingCategoryNoLabel{get; set;}
    public string BillingCategoryDescriptionLabel{get; set;}
    public string MailingCategoryNoLabel{get; set;}
    public string MailingCategoryDescriptionLabel{get; set;}
    public string ReportingCategoryNoLabel{get; set;}
    public string ReportingCategoryDescriptionLabel{get; set;}
    public string ProductCategoryNoLabel{get; set;}
    public string ProductCategoryDescriptionLabel{get; set;}
    public string GroupNoLabel{get; set;}
    public string SectionNoLabel{get; set;}
    public string SectionDescriptionLabel{get; set;}
    public string SectionEffDateLabel{get; set;}
    public string SectionCanDateLabel{get; set;}
    public string BillingProfileLabel{get; set;}
    public string BillingAssociationLabel{get; set;}
    public string AlphaPrefixLabel{get; set;}
    public string IDCardTypeLabel{get; set;}
    public string SPICodesLabel{get; set;}
    public string ParPlanCodesLabel{get; set;}
    //Set column Width
    public static final decimal maxDigitWidth = 7.0; 
    public decimal BANoWidth{get;set;}
    public decimal BACancelDateWidth{get;set;}
    public decimal BAProductWidth{get;set;}
    public decimal BAProductCodeWidth{get; set;}
    public decimal BADescriptionWidth{get;set;}    
    public decimal BAFundTypeWidth{get;set;}
    public decimal BillingCategoryNoWidth{get;set;}
    public decimal BillingCategoryDescriptionWidth{get;set;}
    public decimal MailingCategoryNoWidth{get;set;}
    public decimal MailingCategoryDescriptionWidth{get;set;}
    public decimal ReportingCategoryNoWidth{get;set;}
    public decimal ReportingCategoryDescriptionWidth{get;set;}
    public decimal ProductCategoryNoWidth{get;set;}
    public decimal ProductCategoryDescriptionWidth{get;set;}
    public decimal GroupNoWidth{get;set;}
    public decimal SectionNoWidth{get;set;}
    public decimal SectionDescriptionWidth{get;set;}
    public decimal SectionEffDateWidth{get;set;}
    public decimal SectionCanDateWidth{get;set;}
    public decimal BillingProfileWidth{get;set;}
    public decimal BillingAssociationWidth{get;set;}
    public decimal AlphaPrefixWidth{get;set;}
    public decimal IDCardTypeWidth{get;set;}
    public decimal SPICodesWidth{get;set;}
    public decimal ParPlanCodesWidth{get;set;}
    //Excel Config
    public Id caseId {get; set;}
    public Integer noOfBAs {get; set;}
    public Integer limitSize {get; set;}
    public Integer offsetSize {get; set;}
    public boolean disableNext {get; set;}
    public Boolean disablePrev{
        get {
            return offsetSize >= limitSize ? true : false;
        }
        set;
    } 
    
    public list<GEMS_Characteristic_Value__c> CharValsDocument {get;set;}
    list<GEMS_Benefit_Agreement__c> bas;
    public decimal basperpage;
    GEMS_AccountSetupHelper helper = new GEMS_AccountSetupHelper();
    
    public integer CharColumnCount {
        get{
            Integer count = 0;
            count = accSetUp.Characts.size();
            return count;
        }
        set;
    }
    
    public List<Integer> LoopCharVals {
        get{
            List<Integer> ListofInts = new List<integer>();
            Integer i = 0;
            while (i < CharColumnCount){
                ListOfInts.add(i);
                i = i+1;
            }
            return ListOfInts;
        }
        set;
    }
    
    public List<list<String>> getcharValforColumn(){
        List<List<String>> listOfAllCharVals = new list<List<String>>();
        for (GEMS_AccountSetup.BenefitAgreement BA : accSetup.benefitAgreements){
            for(GEMS_AccountSetup.Category Cat : Ba.Categories){
                list<String> listOfCharValPerColumn = new list<String>();
                Integer i = 0;
                while (i < CharColumnCount){
                    String tempString = '';
                    if(Cat.CatCharValues != null){
                        for(GEMS_Characteristic_Value__c CatCharVal: Cat.CatCharValues){
                            if (accSetUp.Characts[i].id == CatCharVal.Characteristic__c){
                                if (tempString == '') {
                                    tempString = CatCharVal.Code__c;
                                }
                                else {
                                    tempString = tempstring + ', ' + CatCharVal.Code__c;
                                }
                            }                       
                        }
                    }
                    listOfCharValPerColumn.add(tempString);
                    i = i +1;  
                } 
                Cat.AlignedCharValsperRow = listOfCharValPerColumn;
                listOfAllCharVals.add(listOfCharValPerColumn);
            }
        }
        return listOfAllCharVals;
    }
    
   
    
    
    public List<List<String>> AlignedCharVals {get; set;}
    
    public GEMS_AccountStructureOutputController(ApexPages.StandardSetController controller) {
        caseId = ApexPages.currentPage().getParameters().get('caseId');      
        System.debug('CaseId====>'+caseId);
        bas = [SELECT Id, AccountStructureCase__r.GEMS_BAs_Per_Page__c FROM GEMS_Benefit_Agreement__c WHERE 
               AccountStructureCase__c = : caseId];
        
        if(caseId != null && bas != null && bas.size() > 0){
            helper.pagination = true;
            helper.pullChars = true;
            basperpage = bas[0].AccountStructureCase__r.GEMS_BAs_Per_Page__c;
            if(basperpage == null)
                basperpage = 20;
            helper.limitSize = Integer.ValueOf(basperpage);
            helper.offsetSize = 0;
            accSetUp = helper.getAccountStructure(caseId);
            AlignedCharVals = getcharValforColumn();
            noOfBAs = bas.size();
            limitSize = helper.limitSize;
            offsetSize = helper.offsetSize;
            if(noOfBAs < = limitSize)
                disableNext = true;
            else
                disableNext = false;
        }
        ExcelConfigInitialization();   
    }
    
    
    
    public PageReference getNext(){
        if(caseId != null){
            helper.limitSize = Integer.ValueOf(basperpage);
            helper.offsetSize = helper.offsetSize + helper.limitSize;
            accSetUp = helper.getAccountStructure(caseId);
            AlignedCharVals = getcharValforColumn();
            noOfBAs = bas.size();
            limitSize = helper.limitSize;
            offsetSize = helper.offsetSize;
            if(noOfBAs < = (offsetSize + limitSize))
                disableNext = true;
            else
                disableNext = false;
        }
        return null;
    }
    
    public PageReference getPrevious(){
        if(caseId != null){
            helper.limitSize = Integer.ValueOf(basperpage);
            helper.offsetSize = helper.offsetSize - helper.limitSize;
            accSetUp = helper.getAccountStructure(caseId);
            AlignedCharVals = getcharValforColumn();
            noOfBAs = bas.size();
            limitSize = helper.limitSize;
            offsetSize = helper.offsetSize;
            if(noOfBAs < = limitSize)
                disableNext = true;
            else
                disableNext = false;
            // init();
        }
        return null;
    }
    
    public PageReference GenerateDocument(){
        CharValsDocument = getcharvalues(caseId);
        if(accSetUp.asCase.GEMS_Is_Account_Derivated__c == false){
            return new PageReference('/apex/GEMSAccountStructureDocument?caseId='+caseId);
        }
        else {
            return new PageReference('/apex/GEMSDerivatedAccountStructureDocument?caseId='+caseId+'&Offset='+OffsetSize+'&Limit='+LimitSize);
        }
    }
    
    public PageReference DownloadPDF(){
        return new PageReference('/apex/GEMSAccountStructureTreePDF?caseId='+caseId);
    }
    
    public PageReference gotoCase() {
        return new PageReference('/'+caseId);
    }
    
    public list<GEMS_Characteristic_Value__c> getCharValues(id caseId){
        list<GEMS_Characteristic_Value__c> CharValues = [SELECT Id,Char_Code__c, Effective_Date__c, Characteristic__r.Name, Characteristic__r.Comments__c, Characteristic__r.Effective_Date__c, 
                                                         Characteristic__r.Corp_Characteristic_Code__r.Name,  Characteristic__r.End_Date__c, Characteristic__r.Usage__c, 
                                                         Characteristic__r.Corp_Characteristic_Code__c,Characteristic__r.Id, Characteristic__r.Mandatory__c, Characteristic__r.Other__c , 
                                                         Characteristic__r.Reporting__c, Characteristic__r.Product__c , Characteristic__r.Mailing__c , Characteristic__r.Billing__c, 
                                                         Code__c, Name, (SELECT Id, Category__r.Id FROM GEMS_Cat_Char_Value_Associations__r)
                                                         FROM GEMS_Characteristic_Value__c WHERE Case__c =: caseId];
        return CharValues;    
    } 
    /*
     * SFDC-9614 - Acct Structure Excel Output hide usage columns with no data in output
     * Set Boolean values to true if fields are not null
     * SFDC-9866 - GEMS: Auto fit column width to data in rows on Account Structure output
    */
    public void ExcelConfigInitialization(){    
        BANoLabel='BA No.';
        BACancelDateLabel='BA Cancel Date';
        BAProductLabel='BA Product';
        BAProductCodeLabel='Product Code';
        BADescriptionLabel='BA Description';        
        BAFundTypeLabel='BA Fund Type';
        BillingCategoryNoLabel='Billing Category No';
        BillingCategoryDescriptionLabel='Billing Category Description';
        MailingCategoryNoLabel='Mailing Category No';
        MailingCategoryDescriptionLabel='Mailing Category Description';
        ReportingCategoryNoLabel='Reporting Category No';
        ReportingCategoryDescriptionLabel='Reporting Category Description';
        ProductCategoryNoLabel='Product Category No';
        ProductCategoryDescriptionLabel='Product Category Description';
        GroupNoLabel='Group No.';
        SectionNoLabel='Section No.';
        SectionDescriptionLabel='Section Description';
        SectionEffDateLabel='Section Eff Date';
        SectionCanDateLabel='Section Can Date';
        BillingProfileLabel='Billing Profile';
        BillingAssociationLabel='Billing Association';
        AlphaPrefixLabel='Alpha Prefix';
        IDCardTypeLabel='ID Card Type';
        SPICodesLabel='SPI Codes';
        ParPlanCodesLabel='Par Plan Codes';
        //Set default width using Label
        BANoWidth = BANoLabel.trim().length();
        BACancelDateWidth = BACancelDateLabel.trim().length();
        BAProductWidth = BAProductLabel.trim().length();
        BADescriptionWidth = BADescriptionLabel.trim().length();
        BAProductCodeWidth = BAProductCodeLabel.trim().length();
        BAFundTypeWidth = BAFundTypeLabel.trim().length();
        BillingCategoryNoWidth = BillingCategoryNoLabel.trim().length();
        BillingCategoryDescriptionWidth = BillingCategoryDescriptionLabel.trim().length();
        MailingCategoryNoWidth = MailingCategoryNoLabel.trim().length();
        MailingCategoryDescriptionWidth = MailingCategoryDescriptionLabel.trim().length();
        ReportingCategoryNoWidth = ReportingCategoryNoLabel.trim().length();
        ReportingCategoryDescriptionWidth = ReportingCategoryDescriptionLabel.trim().length();
        ProductCategoryNoWidth = ProductCategoryNoLabel.trim().length();
        ProductCategoryDescriptionWidth = ProductCategoryDescriptionLabel.trim().length();
        GroupNoWidth = GroupNoLabel.trim().length();
        SectionNoWidth = SectionNoLabel.trim().length();
        SectionDescriptionWidth = SectionDescriptionLabel.trim().length();
        SectionEffDateWidth = SectionEffDateLabel.trim().length();
        SectionCanDateWidth = SectionCanDateLabel.trim().length();
        BillingProfileWidth = BillingProfileLabel.trim().length();
        BillingAssociationWidth = BillingAssociationLabel.trim().length();
        AlphaPrefixWidth = AlphaPrefixLabel.trim().length();
        IDCardTypeWidth = IDCardTypeLabel.trim().length();
        SPICodesWidth = SPICodesLabel.trim().length();
        ParPlanCodesWidth = ParPlanCodesLabel.trim().length();
        
        for(GEMS_AccountSetup.StructureWorksheet ba: accSetup.reportData){
            //SFDC-9866          
            if(!string.isBlank(ba.baName) && ba.baName.trim().length() > BANoWidth){
                BANoWidth = ba.baName.trim().length();
            }
            if(!string.isBlank(ba.baProduct) && ba.baProduct.trim().length() > BAProductWidth){
                BAProductWidth = ba.baProduct.trim().length();
            }
            //SFDC-9952 Add ProductCode
            if(!string.isBlank(ba.baProductCode) && ba.baProductCode.trim().length() > BAProductCodeWidth){
               BAProductCodeWidth = ba.baProductCode.trim().length();
            }
            if(!string.isBlank(ba.baDescription) && ba.baDescription.trim().length() > BADescriptionWidth){
                BADescriptionWidth = ba.baDescription.trim().length();
            }
            if(!string.isBlank(ba.catBillingNumber) && ba.catBillingNumber.trim().length() > BillingCategoryNoWidth){
                BillingCategoryNoWidth = ba.catBillingNumber.trim().length();
            }
            if(!string.isBlank(ba.catBillingDescription) && ba.catBillingDescription.trim().length() > BillingCategoryDescriptionWidth){   
                BillingCategoryDescriptionWidth = ba.catBillingDescription.trim().length();
            }
            if(!string.isBlank(ba.catMailingNumber) && ba.catMailingNumber.trim().length() > MailingCategoryNoWidth){
                MailingCategoryNoWidth = ba.catMailingNumber.trim().length();
            }
            if(!string.isBlank(ba.catMailingDescription) && ba.catMailingDescription.trim().length() > MailingCategoryDescriptionWidth){
                MailingCategoryDescriptionWidth = ba.catMailingDescription.trim().length();
            }
            if(!string.isBlank(ba.catReportingNumber) && ba.catReportingNumber.trim().length() > ReportingCategoryNoWidth){
                ReportingCategoryNoWidth = ba.catReportingNumber.trim().length();
            }   
            if(!string.isBlank(ba.catReportingDescription) && ba.catReportingDescription.trim().length() > ReportingCategoryDescriptionWidth){
                ReportingCategoryDescriptionWidth = ba.catReportingDescription.trim().length();
            }           
            if(!string.isBlank(ba.catProductNumber) && ba.catProductNumber.trim().length() > ProductCategoryNoWidth){
                ProductCategoryNoWidth = ba.catProductNumber.trim().length();
            }
            if(!string.isBlank(ba.catProductDescription) && ba.catProductDescription.trim().length() > ProductCategoryDescriptionWidth){
                ProductCategoryDescriptionWidth = ba.catProductDescription.trim().length();
            }
            if(!string.isBlank(ba.groupNumber) && ba.groupNumber.trim().length() > GroupNoWidth){
                GroupNoWidth = ba.groupNumber.trim().length();
            }
            if(!string.isBlank(ba.sectionNumber) && ba.sectionNumber.trim().length() > SectionNoWidth){
                SectionNoWidth = ba.sectionNumber.trim().length();
            }
            if(!string.isBlank(ba.sectionDesc) && ba.sectionDesc.trim().length() > SectionDescriptionWidth){
                SectionDescriptionWidth = ba.sectionDesc.trim().length();
            }
            if(ba.sEffDate != null && string.valueOf(ba.sEffDate).trim().length() > SectionEffDateWidth){
                SectionEffDateWidth = string.valueOf(ba.sEffDate).trim().length();
            }
            if(ba.sCanDate != null && string.valueOf(ba.sCanDate).trim().length() > SectionCanDateWidth){
                SectionCanDateWidth = string.valueOf(ba.sCanDate).trim().length();
            }
            if(!string.isBlank(ba.billingProfile) && ba.billingProfile.trim().length() > BillingProfileWidth){
                BillingProfileWidth = ba.billingProfile.trim().length();
            }
            if(!string.isBlank(ba.billingAssociation) && ba.billingAssociation.trim().length() > BillingAssociationWidth){
                BillingAssociationWidth = ba.billingAssociation.trim().length();
            }
            if(!string.isBlank(ba.alphaPrefix) && ba.alphaPrefix.trim().length() > AlphaPrefixWidth){
                AlphaPrefixWidth = ba.alphaPrefix.trim().length();
            }
            if(!string.isBlank(ba.idCardType) && ba.idCardType.trim().length() > IDCardTypeWidth){
                IDCardTypeWidth = ba.idCardType.trim().length();
            }
            if(!string.isBlank(ba.spiCodes) && ba.spiCodes.trim().length() > SPICodesWidth){
                SPICodesWidth = ba.spiCodes.trim().length();
            }
            if(!string.isBlank(ba.parPlanCodes) && ba.parPlanCodes.trim().length() > ParPlanCodesWidth){
                ParPlanCodesWidth = ba.parPlanCodes.trim().length();
            }
            if(!string.isBlank(ba.baFundType) && ba.baFundType.trim().length() > BAFundTypeWidth){
                BAFundTypeWidth = ba.baFundType.trim().length();
            }
            //SFDC-9866
            if(ba.catBillingNumber != ''){
                isBillingNumber = true; 
            } 
            
            if(ba.catBillingDescription != ''){
                isBillingDescription = true;
                
            } 
                       
            if(ba.catMailingNumber != ''){
                isMailingNumber = true;               
            }
            
            if(ba.catMailingDescription != ''){
                isMailingDescription = true;               
            }

            if(ba.catReportingNumber != ''){
                isReportingNumber = true;                
            }
            
            if(ba.catReportingDescription != ''){
                isReportingDescription = true;  
            }
            
            if(ba.catProductNumber != ''){
                isProductNumber = true;
            }
            
            if(ba.catProductDescription != ''){
                isProductDescription = true;  
            }
         } 
         calculateColumnWidth();
        
    }   
    
    public void calculateColumnWidth(){    
        BANoWidth = BANoWidth * maxDigitWidth;
        BACancelDateWidth = BACancelDateWidth * maxDigitWidth;
        BAProductWidth = BAProductWidth * maxDigitWidth;
        BADescriptionWidth = BADescriptionWidth * maxDigitWidth;
        BAProductCodeWidth = BAProductCodeWidth * maxDigitWidth;
        BAFundTypeWidth = BAFundTypeWidth * maxDigitWidth;
        BillingCategoryNoWidth = BillingCategoryNoWidth * maxDigitWidth;
        BillingCategoryDescriptionWidth = BillingCategoryDescriptionWidth * maxDigitWidth;
        MailingCategoryNoWidth = MailingCategoryNoWidth * maxDigitWidth;
        MailingCategoryDescriptionWidth = MailingCategoryDescriptionWidth * maxDigitWidth;
        ReportingCategoryNoWidth = ReportingCategoryNoWidth * maxDigitWidth;
        ReportingCategoryDescriptionWidth = ReportingCategoryDescriptionWidth * maxDigitWidth;
        ProductCategoryNoWidth = ProductCategoryNoWidth * maxDigitWidth;
        ProductCategoryDescriptionWidth = ProductCategoryDescriptionWidth * maxDigitWidth;
        GroupNoWidth = GroupNoWidth * maxDigitWidth;
        SectionNoWidth = SectionNoWidth * maxDigitWidth;
        SectionDescriptionWidth = SectionDescriptionWidth * maxDigitWidth;
        SectionEffDateWidth = SectionEffDateWidth * maxDigitWidth;
        SectionCanDateWidth = SectionCanDateWidth * maxDigitWidth;
        BillingProfileWidth = BillingProfileWidth * maxDigitWidth;
        BillingAssociationWidth = BillingAssociationWidth * maxDigitWidth;
        AlphaPrefixWidth = AlphaPrefixWidth * maxDigitWidth;
        IDCardTypeWidth = IDCardTypeWidth * maxDigitWidth;
        SPICodesWidth = SPICodesWidth * maxDigitWidth;
        ParPlanCodesWidth = ParPlanCodesWidth * maxDigitWidth;
    }    
}