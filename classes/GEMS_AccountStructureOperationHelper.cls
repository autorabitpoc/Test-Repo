//******************************************************************************************************************************
// Name             : GEMS_AccountStructureOperationHelper.cls
// Description      : Helper class for special operations on the account structures
// ********************************************Version Updates******************************************************************
// Date             Developer           Description
// ----------------------------------------------------------------------------------------------------------------------------
// 4/19/2018        Phani               SFDC-4903 GEMS: BlueSTAR - Un-assigning & re-assigning (moving) Group Sections
// 4/19/2018        Gokul               SFDC-8523 GEMS: BlueSTAR - Add existing Category to an existing BA
// *****************************************************************************************************************************

public class GEMS_AccountStructureOperationHelper {
       
    //get category   
    public static List<GEMS_Category__c> getCAT(string enterCAT,Id caseId){   
        List<GEMS_Category__c> CATList = [select Id,Name,Account__c,isNew__c,Category_Description__c,Effective_Date__c,Usage_Billing__c,Usage_Reporting__c,Usage_Product__c,Usage_Mailing__c,Category_Cobra_Code__c from GEMS_Category__c where Name =:enterCAT and Case__c=:caseId LIMIT 1];
        return CATList;      
    }
    
    //get Benefit Agreement
    public static List<GEMS_Benefit_Agreement__c> getBA(string enterBA,Id caseId){    
        List<GEMS_Benefit_Agreement__c> BAList = [select Id,Name,Account__c,isNew__c,Product_Name__c,Product_Type__c,BA_Description__c,Effective_Date__c,BA_Fund_Type__c,Schedule__c,Billing_Assoc__c from GEMS_Benefit_Agreement__c where Name =:enterBA  and AccountStructureCase__c=:caseId and IsCancelled__c = false LIMIT 1];          
        return BAList;      
    }
    
    //Get BA CAT Association for a existing BA and existing Category
    public static List<GEMS_BA_Category_Assignment__c> getBACAT(string enterBA,string enterCAT,Id caseId){
        
        List<GEMS_BA_Category_Assignment__c> BACat= [select Id,Benefit_Agreement__c,Case__c,Category__c,isNew__c from GEMS_BA_Category_Assignment__c 
                                                     where Case__c=:caseId and Benefit_Agreement__r.Name=:enterBA and Category__r.Name=:enterCAT and Benefit_Agreement__r.isNew__c = false and Category__r.isNew__c = false LIMIT 1];            
        return BACat;
    }
    
    //Get BA CAT Association for a existing BA and existing Category
    public static List<GEMS_BA_Category_Assignment__c> getNewBACAT(string enterBA,string enterCAT,Id caseId){
        
        List<GEMS_BA_Category_Assignment__c> BACat= [select Id,Benefit_Agreement__r.name,Category__r.name,Benefit_Agreement__c,Case__c,Category__c,isNew__c from GEMS_BA_Category_Assignment__c 
                                                     where Case__c=:caseId and Benefit_Agreement__r.Name=:enterBA and Category__r.Name=:enterCAT and Benefit_Agreement__r.isNew__c = false and Category__r.isNew__c = false and isNew__c = true LIMIT 1];            
        return BACat;
    }
    
    //retrive BP-BA
    public static List<GEMS_BP_BA_Association__c> getBPBAAssociations(Id caseId, String baName, String catName) {
        List<GEMS_BP_BA_Association__c> bpbaAssociation = [select id, Billing_Profile__r.name,Billing_Profile__c from GEMS_BP_BA_Association__c where Benefit_Agreement__r.name =:baName and Case__c =:caseId and 
                                                           Billing_Profile__c in (select billing_profile__c from GEMS_BP_Category_Association__c where Category__r.name =:catName and Case__c =:caseId)];
        return bpbaAssociation;
    }
    
    //delete SObjects
    public static string deleteSObjects(List<SObject> sObjects) {
        string message = '';
        try {
            delete sObjects;
            message = 'Successfully Deleted';
        } catch(Exception ex) {
            message = ex.getLineNumber() + ':' + ex.getMessage();
        } 
        return message;
    }
    
    //insert SObjects
    public static string insertSObjects(List<SObject> sObjects) {
        string message = '';
        try {
            insert sObjects;
            message = 'Successfully Inserted';
        } catch(Exception ex) {
            message = ex.getLineNumber() + ':' + ex.getMessage();
        } 
        return message;
    }
    
    //update SObjects
    public static string updateSObjects(List<SObject> sObjects) {
        string message = '';
        try {
            update sObjects;
            message = 'Successfully Updated';
        } catch(Exception ex) {
            message = ex.getLineNumber() + ':' + ex.getMessage();
        } 
        return message;
    }
    
    
    
    //returns GS,GS-BA,GS-CAT
    public static List<GEMS_Group_Section__c> getGSAssociations(Id caseId, string gn, string sn) {
        List<GEMS_Group_Section__c> gsAssociations = [Select id, name,IsNew__c, Account__c,isUpdated__c,Group_No__c, Section_No__c, Section_Description__c, Section_Eff_Date__c, Alpha_Prefix__c, SPI_Codes__c, Par_Plan_Codes__c,
                                                      (select id,benefit_agreement__c,benefit_agreement__r.name,benefit_agreement__r.Product__r.Name, benefit_agreement__r.BA_Description__c, benefit_agreement__r.BA_Fund_Type__c from GS_Assignments__r where benefit_agreement__r.IsNew__c = false),
                                                      (select id,category__c, Category__r.name, Category__r.Category_Description__c,Category__r.Usage_Billing__c,Category__r.Usage_Reporting__c, Category__r.Usage_Product__c,Category__r.Usage_Mailing__c from Category_Assignments__r where Category__r.IsNew__c = false)
                                                      from GEMS_Group_Section__c where Group_No__c = :gn and Section_No__c = :sn and case__c = :caseId and IsCancelled__c = false LIMIT 1];
        return gsAssociations;
    }
       
    //get BACATBP
    public static List<GEMS_Benefit_Agreement__c> getBAAssociations(String baName, String catName, Id caseId){
        List<GEMS_Benefit_Agreement__c> baList = 
            [SELECT Id, Name, IsNew__c, Product__r.Name, BA_Description__c,BA_Fund_Type__c,
             (SELECT Id, Name FROM BA_Category_Assignments__r 
              WHERE Category__r.IsCancelled__c = false AND Category__r.Has_Group_Sections__c = true and 
              category__r.name = :catName  ORDER BY Category__r.Name asc LIMIT 1),
             (SELECT Id FROM BA_Associations__r where Benefit_Agreement__r.name = :baName and Billing_Profile__c in 
              (select billing_profile__c from GEMS_BP_Category_Association__c where Category__r.name =:catName and Case__c =:caseId) LIMIT 1) 
             FROM GEMS_Benefit_Agreement__c
             WHERE AccountStructureCase__c = :caseId AND IsCancelled__c = false AND Has_Group_Sections__c = true and 
             Name= :baName  LIMIT 1];
        return baList;
    }
    
}