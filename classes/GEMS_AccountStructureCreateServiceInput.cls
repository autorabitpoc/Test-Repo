//************************************************************************************
// Name             : GEMS_AccountStructureCreateServiceInput.cls
// Description      : Input Class for Account Structure Create Service
// Created By       : Janakiram Jonnadula
// Created Date     : 6/22/2016
// 
// ************************Version Updates********************************************
// Date             Developer           Description
// 05/17/2018       Malathi.K           SFDC-4287 GEMS: BlueSTAR - Member Counts at BA Level (GEMS Integration)
// 05/25/2018		Bharath				SFDC-8691 Included EIN information so that BlueStar can respond with EIN details of Account when EIN retrieval is requested.
// -----------------------------------------------------------------------------------
// ************************************************************************************


global without sharing class GEMS_AccountStructureCreateServiceInput {
    
    webService string status;
    webService string message;
    webService string accountStructureCaseID;
    webService string validSession;
    
    webService AccountDetails accountDetails;
    webService list<Address> addresses;
    webService list<BenefitAggrement> benefitAggrements;
    webService list<Characteristic> characteristics;
    webService list<Category> categories;
    webService list<BillingProfile> billingProfiles;
    webService list<GroupSection> groupSections;
    webService list<string> groupNumbers;
    webService list<AccountEin> acctEin;
    
    webService string requestCode;
    global class AccountDetails{
        webService string accountName;
        webService string accountNumber;
        webService date effectiveDate;   
        
        webService string marketSegment;    
        webService string corpCode;
        
        webService boolean cobraAutoCancel;
        webService string cobraCode;
        
        webService boolean autoCategorizationIndicator;
        webService string einNbr;
        webservice string mltpEinIndicator;
    }
    
    global class Address{
        webService string addressSequence;    
        webService string addressName;
        webService string street;
        webService string state;
        webService string cityName;
        webService string zipCode;
        webService string countyCode;
        webService string countryCode;
        
        webService boolean isPrimaryAddress;
        webService boolean isMailingAddress;
        webService boolean isSubsidaryAddress;
        webService boolean isBillingAddress;
        webService boolean isInvoiceAddress;
        webService boolean isBaeAddress;
        webService boolean isStlmAddress;
        webService boolean isThirdPartyAddress;
        
        webService string contactName;
        webService string contactPhoneNumber;
        webService string contactEmailAddress;
    }  
    
    global class BenefitAggrement{  
        webService string baNumber;
        webService string baDescription;
        webService date effectiveDate;    
        
        webService string prodTypeCode;
        webService string corporateProdNumber;
        
        webService string baFundType;  
        webService string scheduleCode;
        
        webService string idCardType;
        //webService date idCardTypeEffectiveDate;
        
        webService string prescriptionDrugType;
        webService string copays;
        webService string dentalProductType;
        webService string activeMemberCount;
        // SFDC-4287 Added New field Member Count above        
    }
    
    global class Characteristic{
        
        webService string characteristicCode;
        webService string characteristicDescription;
        webService date effectiveDate;
        
        webService boolean productIndicator;
        webService boolean billingIndicator;
        webService boolean reportingIndicator;
        webService boolean mailIndicator;
        webService boolean otherIndicator;
        
        webService boolean mandatoryGroupIndicator;
        
        webService list<CharacteristicValue> characteristicValues;
        
    }
    
    global class CharacteristicValue{
        webService string valueCode;
        webService string value;
        webService date effectiveDate;
    }
    
    global class Category{
        webService string categoryNumber;
        webService string categoryDescription;  
        webService date effectiveDate;    
        webService string categoryCobraCode;
        
        webService boolean reportingIndicator;
        
        webService boolean productIndicator;
        webService list<string> productBANumbers;
        
        webService boolean billingIndicator;
        
        webService boolean mailIndicator;
        webService string mailingAddressSequence;
        
        webService list<CategoryCharacteristic> categoryCharacteristics;
        webService string membersDerivationTypeCode;  
        
    }
    
    global class CategoryCharacteristic{  
        webService string characteristicCode;
        webService list<string> valueCodes;
    }
    
    global class BillingProfile{
        webService string billingProfileNumber;
        webService string description;
        webService date effectiveDate;
        
        webService list<string> baNumbers;
        webService list<string> categoryNumbers;
        webService string billingAddressSequence;  
    }
    
    global class GroupSection{
        webService string groupNumber;    
        webService string sectionNumber;    
        webService string sectionDescription;
        
        webService date effectiveDate;
        
        webService list<string> assignedBANumbers;
        webService list<string> assignedCategoryNumbers;  
        
        webService string alphaPrefix;
        //webService date alphaPrefixEffectiveDate;
        
        webService string spiCodes;
        //webService date spiCodesEffectiveDate;
        
        //webService string parPlanCodes;
        webService string blueCrossPlanCode;
        webService string blueShieldPlanCode;
        webService string majorMedicalPlanCode;
        webService string drugPlanCode;
        webService string dentalPlanCode;
    }
    
    global class AccountEin {
        webService string einNbr;    
        webService double einSeqNbr;
        webService date einEffDt;
        webService date einEndDt;
        webService string changeReasonCd;
        webService string locNm;
        webService string strLn1;
        webService string strLn2;
        webService string ctyNm;
        webService string stCd;
        webService string zipCd;
        webService string cntyCd;
        webService string cntryNm;
        webService string cntryCd;
        webService string prvncCd;
        webService string frgnPostlCd;
    }    
}