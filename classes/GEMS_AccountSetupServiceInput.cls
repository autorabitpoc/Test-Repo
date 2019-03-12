//*************************************************************************************
// Name             : GEMS_AccountSetupServiceInput.cls
// Description      : Input Class for Account Setup Service
// Created By       : Janakiram Jonnadula
// Created Date     : 6/22/2016
// 
// ************************Version Updates********************************************
// Date             Developer           Description
// -----------------------------------------------------------------------------------
// 07/10/2017       Ketki J             SFDC 3641 and 4900. Added IsDescUpdate flags at BA, Category, GS and BP
// 07/21/2017       Shankar             SFDC 4890, 4893. Added isNew for BA changeReasonCode for BA, Category & GroupSection
// 10/26/2017       Shankar             SFDC-7140. Add ADD changeReasonCd at account level
// 5/10/2018        Gokul               SFDC-4912 GEMS: BlueSTAR - Transfer Updated Characteristic Value Descriptions from GEMS to B*.
// ************************************************************************************

public without sharing class GEMS_AccountSetupServiceInput {
        
    public AccountDetails accountDetails;
    public list<Address> addresses;
    public list<Characteristic> characteristics;
    public list<BenefitAggrement> benefitAggrements;
    public list<Category> categories;
    public list<GroupSection> groupSections;
    public list<BillingProfile> billingProfiles;   
        
    public class AccountDetails{
        public string accountName;
        public string accountNumber;                
        public string effectiveDate;        
        public string marketSegment;
        public string accountStructureCaseID;
        public string corpCode;               
        public string cobraAutoCancel;
        public string cobraCode;       
        public string autoCatInd;
        // SFDC-7140. Change reason code at account level
        public string changeReasonCode;
        // SFDC-7140 End
    }
    
    public class Address{
        public integer addressSequence;     
        public string addressName;
        public string street;
        public string state;
        public string cityName;
        public string zipCode;
        public string countyCode;
        public string countryCode;
        
        public string isPrimaryAddress;
        public string isMailingAddress;
        public string isSubsidaryAddress;
        public string isBillingAddress;
        public string isInvoiceAddress;
        public string isBaeAddress;
        public string isStlmAddress;
        public string isThirdPartyAddress;
        
        public string contactName;
        public string contactPhoneNumber;
        public string contactEmailAddress;
    }   
    
    public class Characteristic{
      
        public string characteristicCode;
        public string characteristicDescription;
    
        public string productIndicator;
        public string billingIndicator;
        public string reportingIndicator;
        public string mailIndicator;
        public string otherIndicator;
    
        public string mandatoryGroupIndicator;
    
        public list<CharacteristicValue> characteristicValues;
    }
  
    public class CharacteristicValue{
        public string valueCode;
        public string value;
        // SFDC-4912 Change reason code at characterstics value level
        public string changeReasonCode;
        // SFDC-4912 End        
    }
    
    public class BenefitAggrement{  
        public string baNumber;     
        public string baDescription;
        public string prodTypeCode;
        public string corporateProdNumber;
        public string corporateProdName;        
        public string baFundType;   
        public string scheduleCode;
        public string IsDescUpdate;
        public Boolean isNew;
        public string changeReasonCode;
    }
    
    public class Category{
        public string categoryNumber;
        public string categoryDescription;  
        public string categoryCobraCode;
        public string IsDescUpdate;
        public string mailAddrSeqNbr;
        
        public string memDrvdTypCd;
                
        public string productIndicator;
        public string billingIndicator;
        public string reportingIndicator;
        public string mailIndicator;
        
        public list<CategoryCharacteristic> categoryCharacteristics;
        
        public list<string> associatedBANumbers;
        public Boolean isNew;
        public string changeReasonCode;
    }
    
    public class CategoryCharacteristic{  
        public string characteristicCode;
        public list<string> valueCodes;
    }
    
    public class GroupSection{
        public string groupNumber;
        public string IsDescUpdate;
        public string sectionNumber;
        public string sectionDescription;
        
        public list<string> assignedBANumbers;
        public list<string> assignedCategoryNumbers;        
        public string changeReasonCode;        
    }
    
    public class BillingProfile{
        public string billingProfileNumber;
        public string description;
        public string IsDescUpdate;   
        
        public list<string> baNumbers;
        public list<string> categoryNumbers;
        public string billingAddressSequence; 
        public string changeReasonCode; 
    }     
       
}