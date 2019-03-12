/**************************************************************************************
Apex Class Name     : SimplifiedProductLookup
Version             : 1.0
Function            : This class handles the logic to search for a Simplified product on the AddOpportunityProducts visualforce page
History             : SFDC-5041 - 07/2017 - Limit Products for Users with Dearborn Profile 
                      SFDC-7474 - 12/2017 - Ensure only Active Products are returned and that Products with 
                                            a Record Type of Service are not included in Search results
*************************************************************************************/
public with sharing class SimplifiedProductLookup { 
    
    public List<Product2> results{get;set;} 
    public String searchString{get;set;} 
    public Id oppId{get;set;}
    public String HCSC{get;set;}
    
    /** SFDC-7474 - 12/2017 - BEGIN **/
    Public List<Id> ListOfRecordTypeIds{get;set;}
    /** SFDC-7474 - 12/2017 - END   **/
    
    /** SFDC-5041 - 07/2017 - BEGIN **/
    Public List<Profile> aProfile{get;set;}
    Public String aProfileName{get;set;}  
    Public Boolean isDearborn{get;set;}
    Public List<String> aProductCategory{get;set;}
    Public List<String> aProductFamily{get;set;}
    /* Public Id aRecordTypeIdByName{get;set;} */    
    /** SFDC-5041 - 07/2017 - END   **/
    
    /**
* @Method:Constructor
* @description: Grabs the related opportunity Id to find the state for the search query and also grabs the search string from the user if found
*/
    public SimplifiedProductLookup() {
        oppId = ApexPages.currentPage().getParameters().get('Id');
        Opportunity opp = [SELECT HCSC_Division__c FROM Opportunity WHERE Id = :oppId LIMIT 1];
        HCSC = opp.HCSC_Division__c;
        searchString = System.currentPageReference().getParameters().get('lksrch');
        
        /** SFDC-5041 - 07/2017 - BEGIN **/
        
        isDearborn = False;
        ListOfRecordTypeIds = new List<Id>();
        
        /** get the current User Profile **/
        aProfile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        aProfileName = aProfile[0].Name;
        
        /** check for Specific Profiles **/
        If (aProfileName == 'LGNA - Dearborn'){
            isDearborn = True;
            aProductCategory = new List<String>();
            aProductCategory.add('Dental');
            aProductCategory.add('Vision');
            aProductCategory.add('Dearborn');
            aProductFamily = new List<String>();
            aProductFamily.add('Ancillary and other'); 
            /** SFDC-7474 - 12/2017 - BEGIN **/
            /* aRecordTypeIdByName = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Dearborn Products').getRecordTypeId(); */ 
            ListOfRecordTypeIds.add(Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Dearborn Products').getRecordTypeId());
            /** SFDC-7474 - 12/2017 - END   **/
        }else{
            isDearborn = False;
            /** SFDC-7474 - 12/2017 - BEGIN **/
            ListOfRecordTypeIds.add(Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Service').getRecordTypeId());
            /** SFDC-7474 - 12/2017 - END   **/
        }            
        /** SFDC-5041 - 07/2017 - END   **/
        
        System.debug('ListOfRecordTypeIds:  '+ ListOfRecordTypeIds);
        
        runSearch();  
    }    
    
    /**
* @Method:search()
* @description: preforms the keyword search
*/
    public PageReference search() {
        runSearch();
        return null;
    }
    
    /**
* @Method:runSearch()
* @description: sets the results to the getProducts() method which displays all the products is searchString is empty
*/
    private void runSearch() {
        
        results = getProducts(SearchString);               
    } 
    
    /**
* @Method:performSearch(string searchString)
* @description: runs the search query from the user
*/
    private List<Product2> performSearch(string searchString) {
        String soql = 'SELECT Simplified_Product__c, HCSC_State__c FROM Product2';        
        if(searchString != '' && searchString != null){
            soql = soql +  ' WHERE Simplified_Product__c LIKE \'%' + searchString +'%\'';
            soql = soql + ' AND HCSC_State__c = :HCSC ';
            soql = soql + ' AND NotSimple__c = false '; 
            /** SFDC-7474 - 12/2017 - BEGIN **/
            soql = soql + ' AND IsActive = true '; 
            
            /** SFDC-7474 - 12/2017 - END   **/
        }
        
        /** SFDC-5041 - 07/2017 - BEGIN **/
        
        /** Add SOQL to limit to Dearborn Record Type **/
        if (isDearborn==True){
            /** SFDC-7474 - 12/2017 - BEGIN **/
            soql = soql + ' AND ((RecordType.Id IN :ListOfRecordTypeIds) OR (Product_Category__c IN :aProductCategory AND Family IN :aProductFamily))';
            
        }else{
            soql = soql + ' AND RecordType.Id NOT IN :ListOfRecordTypeIds';
        }
        /** SFDC-7474 - 12/2017 - END   **/
        
        /** SFDC-5041 - 07/2017 - END  **/        
        return database.query(soql); 
    }
    
    /**
* @Method:getProducts()
* @description: If the searchString is empty the method will grab all Simplified Products to display 
*                 otherwise it calls the performSearch() method
*/
    public List<Product2> getProducts(String searchString) {
        
        /** SFDC-5041 - 07/2017 - BEGIN **/
        
        /** Create a list to Return **/
        List<Product2> aListOfProduct2 = new List<Product2>(); 
        
        if (searchString == '') {
            if (isDearborn==False){
                aListOfProduct2 = [SELECT 
                                   Simplified_Product__c, 
                                   HCSC_State__c 
                                   FROM 
                                   Product2 
                                   WHERE    
                                   HCSC_State__c = :HCSC AND 
                                   NotSimple__c = false AND
                                   /** SFDC-7474 - 12/2017 - BEGIN **/
                                   IsActive = true AND
                                   RecordType.Id NOT IN :ListOfRecordTypeIds 
                                   /** SFDC-7474 - 12/2017 - END   **/
                                   ORDER BY 
                                   Simplified_Product__c];
            }else{
                /** add Dearborn Record Type to SOQL **/
                if (isDearborn==True){                    
                    aListOfProduct2 = [SELECT 
                                       Simplified_Product__c, 
                                       HCSC_State__c 
                                       FROM 
                                       Product2 
                                       WHERE
                                       HCSC_State__c = :HCSC AND
                                       NotSimple__c = false AND 
                                       /** SFDC-7474 - 12/2017 - BEGIN **/
                                       IsActive = true AND 
                                       ((RecordType.Id IN :ListOfRecordTypeIds) OR
                                        /** SFDC-7474 - 12/2017 - END  **/
                                        (Product_Category__c IN :aProductCategory AND Family IN :aProductFamily))
                                       ORDER BY Simplified_Product__c];
                }
            }
            return aListOfProduct2;
            /** SFDC-5041 - 07/2017 - END   **/
        }
        else{
            return performSearch(searchString);
        }        
    }
    
    /**
* @Method:getFormTag()
* @description: used by the visualforce page to send the link to the right dom element
*/
    public string getFormTag() {
        return System.currentPageReference().getParameters().get('lkfm');
    }
    
    /**
* @Method:getTextBox()
* @description: used by the visualforce page to send the link to the right dom element for the text box
*/
    public string getTextBox() {
        return System.currentPageReference().getParameters().get('lknm');
    }
}