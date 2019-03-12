//************************************************************************************
// Name             : GEMS_AccountSetup .cls
// Description      : Wrapper Class for formatting Data
// Created By       : Janakiram Jonnadula
// Created Date     : 6/22/2016
// 
// ************************Version Updates********************************************
// Date             Developer           Description
// -----------------------------------------------------------------------------------
// 4/3/2017         Ranjit Gandhi        Cancelled Ba's added to Grid output
// 4/12/2017        Phani Kommareddy     SFDC-3951 Prevent Creation of Duplicate Group Sections in GEMS
// 3/25/2017        Phani Kommareddy     SFDC-7859 GEMS: Acct Structure - Redesign of GEMS Account Structure Excel Output
// 4/19/2018        Gokul               SFDC-8523 GEMS: BlueSTAR - Add existing Category to an existing BA
// 4/30/2018        Luke Chen           SFDC-6942 GEMS: Acct Structure - Move Billing Association to the Group Section level in the "Create Account Structure" view.
// 5/10/2018        Luke Chen           SFDC-8446 GEMS: Acct Structure - Select group number for overall BAs (but still be editable)
// 5/29/2018        Malathi.K           SFDC-9952 Add ProductCode to Grid,Excel and VF Page.
// ************************************************************************************

public without sharing class GEMS_AccountSetup {
    
    public Case asCase {get; set;}
    public list<GEMS_Characteristic_Value__c> CharVals {get; set;}
    public list<BenefitAgreement> benefitAgreements {get; set;}
    
    public list<BenefitAgreement> cancelledbenefitAgreements {get; set;}
    public list<StructureWorksheet> reportData {get;set;}
    public List<GEMS_Characteristic__c> Characts {get; set;}
    public List<Integer> NumberOfChars {get; set;}
    
    public list<SelectOption> groupNumbers {get; set;}
    public Integer renderMe{get; set;}  
    public class BenefitAgreement{
        public GEMS_Benefit_Agreement__c ba {get; set;}     
        public list<Category> categories {get; set;}
        public string groupNumber {get; set;}     // already exists but not used, use it now for SFDC-8446
    }
    
    public class Category{
        public GEMS_Category__c cat {get; set;} 
        public list<GEMS_Characteristic_Value__c> catCharValues {get; set;} 
        public List<String> AlignedCharValsperRow {get; set;}
        public GEMS_Group_Section__c groupSection {get; set;}
        public GroupSection gs {get; set;}
        public GEMS_Category_Assignment__c catGSAssign {get; set;}
        public GEMS_BA_Assignment__c baGSAssign {get; set;}
        
        public GEMS_Billing_Profile__c billingProfile{get; set;}
        public GEMS_BP_Category_Association__c bpCategoryAssign {get; set;}
        public GEMS_BP_BA_Association__c bpBAAssign {get; set;}
        
        public boolean isDuplicate {get; set;}
        //SFDC-8523
        public GEMS_BA_Category_Assignment__c bacat{get;set;}
        //SFDC-8523
    }
    
    public class GroupSection{
        public string gsId {get; set;}
        public string caseId {get; set;}
        public string acctId {get; set;}
        public string gsName {get; set;}
        public boolean isNew {get; set;}
        public string groupNumber {get; set;}
        public string sectionNumber {get; set;}
        public string sectionDesc {get; set;}
        public date effDate {get; set;}
        public string spiCodes {get; set;}
        public string alphaPrefix {get; set;}
        public string parPlanCodes {get; set;}
        public string billingAssoc {get; set;} // SFDC-6942
    }
    
    //SFDC-3951 - HELPER CLASS TO PREVENT DUPLICATE ACCOUNT STRUCTURE ON (BA,CAT,GN,SN) COMBO
    public class AccStrUniqueCombo {
        public string BAName {get; set;}
        public string cat {get; set;}
        public string groupNumber {get; set;}
        public string sectionNumber {get; set;}     
        
        public Boolean equals(Object obj) {
            Boolean checkEquals = false;
            if (obj instanceof AccStrUniqueCombo ) {
                AccStrUniqueCombo accStrUniqueCombo = (AccStrUniqueCombo)obj;
                //System.debug('accStrUniqueCombo : '+accStrUniqueCombo);      
                //System.debug('existing values : '+ BAName +' '+cat+' '+groupNumber+' '+sectionNumber); 
                //remove nulls for any values
                if(String.isBlank(groupNumber))
                    groupNumber = '';
                if(String.isBlank(sectionNumber))
                    sectionNumber = '';
                if(BAName.equals(accStrUniqueCombo.BAName) && cat.equals(accStrUniqueCombo.cat) && groupNumber.equals(accStrUniqueCombo.groupNumber) && sectionNumber.equals(accStrUniqueCombo.sectionNumber)){
                    
                    checkEquals = true;
                } 
            }
            //System.debug('Equals : '+checkEquals);
            return checkEquals ;
            
        }
        
        public Integer hashCode() {
            
            return BAName!=null?BAName.length():0 + cat!=null?cat.length():0+groupNumber!=null?groupNumber.length():0+sectionNumber!=null?sectionNumber.length():0;
            
        }
    }
    
    
    //SFDC-7859 GEMS: Acct Structure - Redesign of GEMS Account Structure Excel Output
    //SFDC-9952 Added Product Code
    public class StructureWorksheet {
        public String baName{get;set;}
        public String baProductCode{get;set;}
        public String baProduct{get;set;}        
        public String baDescription{get;set;} 
        public String baFundType{get;set;}
        public String catBillingNumber {get;set;}
        public String catMailingNumber {get;set;}
        public String catReportingNumber {get;set;}
        public String catProductNumber {get;set;}
        public String catBillingDescription {get;set;}
        public String catMailingDescription {get;set;}
        public String catReportingDescription {get;set;}
        public String catProductDescription {get;set;} 
        public string groupNumber {get;set;}
        public string sectionNumber {get;set;}
        public string sectionDesc {get;set;}
        public date sEffDate {get;set;}
        public date sCanDate {get;set;}
        public String billingProfile {get;set;}
        public String billingAssociation {get;set;}
        public string alphaPrefix {get;set;}
        public string idCardType {get;set;}
        public string spiCodes {get;set;}
        public string parPlanCodes {get;set;}
        public string billingAssoc {get; set;} // SFDC-6942
    }  
}