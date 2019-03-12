//************************************************************************************
// Name             : GEMS_AccountStructureHelper.cls
// Description      : Helper class to get, validate and save account strcuture details.
// Created By       : Janakiram Jonnadula
// Created Date     : 4/14/2016
// 
// ************************Version Updates********************************************
// Date             Developer           Description
// -----------------------------------------------------------------------------------
// ************************************************************************************

public without sharing class GEMS_AccountStructureHelper {
    
    //Get account structure details
    public GEMS_AccountStructure getAccountStructure(id caseId){
        
        GEMS_AccountStructure accountStructure = new GEMS_AccountStructure();
        
        list<GEMS_Benefit_Agreement__c> basCatsGSs = getBACategoriesAndGroupSections(caseID);
        
        //list<GEMS_Category__c> catsBAsGSs = getCategoryGroupSections(caseID);        
        list<GEMS_Group_Section__c> gsBAsCats = getGroupSectionBAsCategories(caseID); 
        
        accountStructure.Characts = getCharacts(caseID);
        list<GEMS_Characteristic_Value__c> CharVals = getCharValues(caseID);
        accountStructure.CharVals = CharVals;
        
        if(basCatsGSs != null && basCatsGSs.size() > 0){
            accountStructure.groupNumbers = getGroupNumbers(basCatsGSs[0].AccountStructureCase__r.GEMS_Reserved_Group_Numbers__c);
            accountStructure.renderME = getrenderMe(basCatsGSs[0].AccountStructureCase__r.GEMS_Account_Submission_Info__r.Funding_Type_Multiselect__c);
            //accountStructure.renderME = getrenderMe(CaseID);
        }
        
        //accountStructure.NumberOfChars = getNumberOfCharacteristics(accountStructure.Characts);
        
        //Build Benefit Agreements
        list<GEMS_AccountStructure.BenefitAgreement> benefitAgreements = new list<GEMS_AccountStructure.BenefitAgreement>();
        if(basCatsGSs != null){
            for(GEMS_Benefit_Agreement__c baCatGS : basCatsGSs){
                GEMS_AccountStructure.BenefitAgreement benefitAgreement = new GEMS_AccountStructure.BenefitAgreement();
                benefitAgreement.ba = baCatGS;
                
                //Get all Group Numbers
                /*List<SelectOption> options = new List<SelectOption>();
                options.add(new SelectOption('None', '--None--'));
                List<String> listOfGroupNos = new list<String>();
                
                //To get the list of available Group Numbers    
                if (baCatGS.AccountStructureCase__r.GEMS_Reserved_Group_Numbers__c != Null){
                    listOfGroupNos = baCatGS.AccountStructureCase__r.GEMS_Reserved_Group_Numbers__c.split(';');
                }
                
                for(String GroupNo : listOfGroupNos) {
                    options.add(new SelectOption(GroupNo, GroupNo));
                }   
                accountStructure.groupNumbers = options;*/
                
                //Build Categories
                //list<GEMS_BA_Category_Assignment__c> baCatAssignments = baCatGS.BA_Category_Assignments__r;           
                list<GEMS_AccountStructure.Category> categories = new list<GEMS_AccountStructure.Category>();
                if(baCatGS.BA_Category_Assignments__r != null){
                    for(GEMS_BA_Category_Assignment__c baCatAssignment : baCatGS.BA_Category_Assignments__r){
                        GEMS_AccountStructure.Category category = new GEMS_AccountStructure.Category();
                        category.cat = baCatAssignment.Category__r; 
                        
                        //Assign Category Group Sections - 1 Category can be assigned to only 1 unique section for a given group number
                        //Build GS, BA-GS, CAT-GS Assignment details for a given category and given BA                        
                        boolean found = false;
                        for(GEMS_Group_Section__c gsBAsCat : gsBAsCats){
                                                        
                            if(gsBAsCat.Category_Assignments__r != null){
                                //boolean found = false;
                                for(GEMS_Category_Assignment__c catGSAssign : gsBAsCat.Category_Assignments__r){                                    
                                    if(category.cat.id == catGSAssign.Category__r.id){
                                        
                                        if(gsBAsCat.GS_Assignments__r != null){
                                            for(GEMS_BA_Assignment__c baGSAssign : gsBAsCat.GS_Assignments__r){
                                                if(baGSAssign.Benefit_Agreement__r.Name == benefitAgreement.ba.Name){                                                   
                                                    found = true;
                                                    category.groupSection = gsBAsCat;                                                                                        
                                                    category.catGSAssign = catGSAssign;
                                                    category.baGSAssign = baGSAssign;
                                                    category.groupNumber = category.groupSection.group_no__c;
                                                    category.catCharValues = new list<GEMS_Characteristic_Value__c>();
                                                    if (!CharVals.isEmpty()){
                                                       for (GEMS_Characteristic_Value__c CharVal : CharVals){
                                                            for (GEMS_Cat_Char_Value_Association__c CatCharValAss : CharVal.GEMS_Cat_Char_Value_Associations__r){
                                                                if(CatCharValAss.Category__c == category.cat.id ) {
                                                                    category.catCharValues.add(charVal);
                                                                    System.debug('CharValsssssssssssssss ' + charVal );
                                                                } 
                                                            }
                                                        }
                                                    }

                                                    break;
                                                }
                                            }
                                        }
                                                                                
                                    }   
                                    if(found) break;
                                }         
                            }
                            if(found) break;
                            
                        }
                        
                        //Build the Group Section details if no section associated for given category, group number and BA  
                        if(!found){
                            //Create new Group Section record
                            GEMS_Group_Section__c groupSection = new GEMS_Group_Section__c();                                       
                            groupSection.Section_Eff_Date__c = benefitAgreement.ba.AccountStructureCase__r.GEMS_Case_Effective_Date__c;
                            groupSection.case__c = caseId;
                            groupSection.account__c = benefitAgreement.ba.account__c;  
                            groupSection.Section_No__c = category.cat.Name;
                            groupSection.Section_Description__c = benefitAgreement.ba.AccountStructureCase__r.Account.Name;                                      
                            category.groupSection = groupSection;                                                        
                            
                            //Create new Category GS Assign record 
                            GEMS_Category_Assignment__c catAssign = new GEMS_Category_Assignment__c();   
                            catAssign.case__c = caseId;
                            catAssign.account__c = benefitAgreement.ba.account__c;
                            catAssign.category__r =  category.cat;   
                            catAssign.category__c =  category.cat.id;
                            catAssign.Group_Section__r = groupSection;                                     
                            category.catGSAssign = catAssign;
                            
                            //Create new BA GS Assign record
                            GEMS_BA_Assignment__c baGSAssign = new GEMS_BA_Assignment__c();
                            baGSAssign.case__c = caseId;      
                            baGSAssign.account__c = benefitAgreement.ba.account__c;                                                   
                            baGSAssign.Benefit_Agreement__r = benefitAgreement.ba; 
                            baGSAssign.Benefit_Agreement__c = benefitAgreement.ba.id;  
                            baGSAssign.Group_Section__r = groupSection;
                            category.baGSAssign = baGSAssign;
                            
                            System.debug('New Category Group Section' + category);
                        }                        
                        
                        //// 
                        categories.add(category);            
                    }
                     
                }
                
                benefitAgreement.categories = categories;  
                benefitAgreements.add(benefitAgreement);        
            }
            accountStructure.benefitAgreements = benefitAgreements;
        }
                
        return accountStructure;
    }
    //Validate Account Structure
    public Boolean validateAccountStructure(GEMS_AccountStructure accountStructure){
        Boolean result = true;
        list<GEMS_AccountStructure.Category> catGSAssignments = new list<GEMS_AccountStructure.Category>();
        if(accountStructure != null && accountStructure.benefitAgreements != null){
          for(GEMS_AccountStructure.BenefitAgreement benefitAgreement : accountStructure.benefitAgreements){
           if(benefitAgreement.categories != null){
              for(GEMS_AccountStructure.Category category : benefitAgreement.categories){                     
                    catGSAssignments.add(category);
              }
            }
          } 
        }
        if (catGSAssignments != Null){
            Integer i = 0;
            for (GEMS_AccountStructure.Category category1: catGSAssignments){
                integer j = 0;
                for (GEMS_AccountStructure.Category category2: catGSAssignments){
                    if (i != j && category2.cat.Name == category1.cat.Name && category2.groupSection.Name == category1.groupSection.Name){
                        result = false;
                        break;
                    }
                    j = j +1;
                }
                i = i +1;
            }
        }
       return result;
    }
    //Validate and Save Account Structure
    public string saveAccountStructure(GEMS_AccountStructure accountStructure){

        string result;
        
        try{                
            list<GEMS_Group_Section__c> groupSections = new list<GEMS_Group_Section__c>(); 
            map<string, GEMS_Group_Section__c> mapOfGroupSections = new map<string, GEMS_Group_Section__c>();
            map<string, list<GEMS_Group_Section__c>> mapOflistOfGroupSection = new map<string, list<GEMS_Group_Section__c>>();
            
            list<GEMS_Group_Section__c> groupSectionsToDelete = new list<GEMS_Group_Section__c>();
            map<id, GEMS_Group_Section__c> mapOfgroupSectionsToDelete = new map<id, GEMS_Group_Section__c>();            
             
            list<GEMS_Category_Assignment__c> catGSAssignments = new list<GEMS_Category_Assignment__c>();
            map<string, GEMS_Category_Assignment__c> mapOfCatGSAssignments = new map<string, GEMS_Category_Assignment__c>();            
            list<GEMS_Category_Assignment__c> catGSAssignmentsToDelete = new list<GEMS_Category_Assignment__c>();
            map<id, GEMS_Category_Assignment__c> mapOfCatGSAssignmentsToDelete = new map<id, GEMS_Category_Assignment__c>();
             
            list<GEMS_BA_Assignment__c> baGSAssignments = new list<GEMS_BA_Assignment__c>();
            map<string, GEMS_BA_Assignment__c> mapOfbaGSAssignments = new map<string, GEMS_BA_Assignment__c>();            
            list<GEMS_BA_Assignment__c> baGSAssignmentsToDelete = new list<GEMS_BA_Assignment__c>();  
            map<id, GEMS_BA_Assignment__c> mapOfbaGSAssignmentsToDelete = new map<id, GEMS_BA_Assignment__c>();
            
            system.debug('Account Strcuture : ' + accountStructure);
            
            if(accountStructure != null && accountStructure.benefitAgreements != null){
                for(GEMS_AccountStructure.BenefitAgreement benefitAgreement : accountStructure.benefitAgreements){
                    if(benefitAgreement.categories != null){
                        for(GEMS_AccountStructure.Category category : benefitAgreement.categories){                     
                            if(category.groupSection != null){
                                                                
                                //Valied if any group section has no group number, section number and section desc
                                if(category.groupSection.Group_No__c != null && category.groupSection.Group_No__c != 'None' && category.groupSection.Section_No__c != null && category.groupSection.Section_Description__c != null){
                                    //groupSection.Group_No__c
                                    //category.groupSection.Group_No__c = category.groupNumber;
                                    category.groupSection.Name = category.groupSection.Group_No__c + '-' + category.groupSection.Section_No__c;    
                                    
                                    if(category.groupSection.id != null){
                                        mapOfgroupSectionsToDelete.put(category.groupSection.id, category.groupSection);
                                    }
                                    
                                    //Prepare map of group sections                                                                                                         
                                    if(mapOflistOfGroupSection.get(category.groupSection.Name) != null){
                                        list<GEMS_Group_Section__c> tempList = mapOflistOfGroupSection.get(category.groupSection.Name);
                                        tempList.add(category.groupSection);
                                        mapOflistOfGroupSection.put(category.groupSection.Name, tempList);
                                    }
                                    else{
                                        list<GEMS_Group_Section__c> tempList = new list<GEMS_Group_Section__c>();
                                        tempList.add(category.groupSection);
                                        mapOflistOfGroupSection.put(category.groupSection.Name, tempList);                                                                              
                                    }
                                                           
                                }
                                //Return error if any of the data missing
                                else{
                                    result = 'Please enter Group No, Section No & Section Description details for all BAs.';
                                    return result;
                                }                                                    
                            }
                            if(category.catGSAssign != null){ 
                                category.catGSAssign.Name = category.groupSection.Name;
                                catGSAssignments.add(category.catGSAssign);
                                if(category.catGSAssign.id != null){
                                    mapOfCatGSAssignmentsToDelete.put(category.catGSAssign.id, category.catGSAssign);
                                }
                            }
                            
                            if(category.baGSAssign != null){ 
                                category.baGSAssign.Name = category.groupSection.Name;
                                baGSAssignments.add(category.baGSAssign);
                                if(category.baGSAssign.id != null){
                                    mapOfbaGSAssignmentsToDelete.put(category.baGSAssign.id, category.baGSAssign);
                                }
                            }
                        }
                    }
                }
            }
            
                        
            system.debug('mapOflistOfGroupSection:' + groupSections);
            system.debug('catGSAssignments before save :' + catGSAssignments);
            system.debug('baGSAssignments before save:' + baGSAssignments);
            
            for(Id gsId : mapOfCatGSAssignmentsToDelete.keySet()){
                catGSAssignmentsToDelete.add(mapOfCatGSAssignmentsToDelete.get(gsId));
            }
               
            for(Id gsId : mapOfbaGSAssignmentsToDelete.keySet()){
                baGSAssignmentsToDelete.add(mapOfbaGSAssignmentsToDelete.get(gsId));
            }
            
            for(Id gsId : mapOfgroupSectionsToDelete.keySet()){
                groupSectionsToDelete.add(mapOfgroupSectionsToDelete.get(gsId));
            }
            
            Savepoint sp = Database.setSavepoint();
                            
            try{
                
	        	if(catGSAssignmentsToDelete != null && catGSAssignmentsToDelete.size() > 0)
                    delete catGSAssignmentsToDelete; 
                                
				if(baGSAssignmentsToDelete != null && baGSAssignmentsToDelete.size() > 0)
                    delete baGSAssignmentsToDelete; 
                
                if(groupSectionsToDelete != null && groupSectionsToDelete.size() > 0)
                    delete groupSectionsToDelete; 
                    
                //Add Unique Group Numbers
                system.debug('Map of Group Sections : ' + mapOflistOfGroupSection);
                for(string groupSectionName : mapOflistOfGroupSection.keySet() ){
                    list<GEMS_Group_Section__c> tempList = mapOflistOfGroupSection.get(groupSectionName);
                    if(tempList.size() > 0){
                        tempList[0].id = null;
                        groupSections.add(tempList[0]);
                    }
                }
                
                system.debug('groupSections before save:' + groupSections);
                                           
                if(groupSections != null) 
                    insert groupSections;
                
                system.debug('groupSections after save:' + groupSections);
                
                for(GEMS_Group_Section__c gs : groupSections)
                    mapOfGroupSections.put(gs.Name, gs);
                    
                for(GEMS_Category_Assignment__c catGSAssign : catGSAssignments){
                    GEMS_Group_Section__c gs = mapOfGroupSections.get(catGSAssign.Name);
                    catGSAssign.Group_section__c = gs.id;
                    catGSAssign.Group_section__r = null;
                    catGSAssign.id = null;
                    
                    mapOfCatGSAssignments.put(catGSAssign.Name + string.valueOf(catGSAssign.Category__c),  catGSAssign);
                }
                
                for(GEMS_BA_Assignment__c baGAAssign : baGSAssignments){
                    GEMS_Group_Section__c gs = mapOfGroupSections.get(baGAAssign.Name);
                    baGAAssign.Group_section__c = gs.id;
                    baGAAssign.Group_section__r = null;
                    baGAAssign.id = null;
                                        
                    mapOfbaGSAssignments.put(baGAAssign.Name + string.valueOf(baGAAssign.Benefit_agreement__c), baGAAssign);
                }
                 
                 
                 list<GEMS_Category_Assignment__c> catGSAssignmentsToUpdate = new list<GEMS_Category_Assignment__c>();
                 list<GEMS_BA_Assignment__c> baGSAssignmentsToUpdate = new list<GEMS_BA_Assignment__c>();
                 
                 for(string catGSAssignment : mapOfCatGSAssignments.keySet() ){
                    catGSAssignmentsToUpdate.add(mapOfCatGSAssignments.get(catGSAssignment));
                 }
                 
                 for(string baGSAssignment : mapOfbaGSAssignments.keySet() ){
                    baGSAssignmentsToUpdate.add(mapOfbaGSAssignments.get(baGSAssignment));
                 }
                
                 if(catGSAssignmentsToUpdate != null) 
                    insert catGSAssignmentsToUpdate;
                 if(baGSAssignmentsToUpdate != null) 
                    insert baGSAssignmentsToUpdate;                    
            }
            catch(exception ex){
                Database.rollback(sp);    
                result = 'Line# : ' + ex.getLineNumber() + ' : ' + ex.getMessage();                                                                         
            }
        }
        catch(Exception ex){
            result = 'Line# : ' + ex.getLineNumber() + ' : ' + ex.getMessage();            
        }
        
        return result;
    }
    
    //Get all catgories and Group-Sections assigned to BAs
    public static list<GEMS_Benefit_Agreement__c> getBACategoriesAndGroupSections(id caseID){
        
        list<GEMS_Benefit_Agreement__c> basCatsGSs =  [SELECT Id, Name, Account__c, Product_Name__c, Product__r.Name, Plan__r.Name, Plan__c, BA_Description__c, 
                                                            BA_Fund_Type__c, Schedule__c, Billing_Profile__c, Billing_Assoc__c, ID_Card_Type__c, Dental_Product_Type__c, Copays__c, Prescription_Drug_Type__c,
                                                            AccountStructureCase__c, AccountStructureCase__r.HCSC_Division__c, AccountStructureCase__r.Account.AccountNumber, AccountStructureCase__r.Account.External_ID__c,AccountStructureCase__r.Account.Name, AccountStructureCase__r.GEMS_Case_Effective_Date__c, AccountStructureCase__r.GEMS_Submission_Type__c, AccountStructureCase__r.GEMS_Submission_Sub_Type__c,AccountStructureCase__r.GEMS_Line_of_Business__c, AccountStructureCase__r.GEMS_Account_Submission_Info__c, AccountStructureCase__r.Market_Segment__c, AccountStructureCase__r.Status, AccountStructureCase__r.Owner.Name, AccountStructureCase__r.GEMS_Type__c,AccountStructureCase__r.GEMS_Is_Account_Derivated__c ,
                                                            
                                                             AccountStructureCase__r.GEMS_Reserved_Group_Numbers__c, AccountStructureCase__r.GEMS_Account_Submission_Info__r.Funding_Type_Multiselect__c, AccountStructureCase__r.Funding_Type_Multiselect__c, 
                                                            
                                                            (SELECT Id, Name, Case__c, Account__c, Benefit_Agreement__c, Category__c, 
                                                                    Category__r.Category_Description__c , Category__r.id, Category__r.Name, Category__r.Account__c,
                                                                    Category__r.Case__c, Category__r.Category_Cobra_Code__c, Category__r.Usage_Billing__c, 
                                                                    Category__r.Usage_Mailing__c, Category__r.Usage_Product__c, Category__r.Usage_Reporting__c
                                                                FROM BA_Category_Assignments__r order by Category__r.Name asc),
                                                                
                                                            (SELECT Id, Name, Case__c, Account__c, Benefit_Agreement__c, Group_Section__c, Group_Section__r.id, 
                                                                    Group_Section__r.Name, Group_Section__r.Group_No__c, Group_Section__r.Section_No__c,  Group_Section__r.Account__c,
                                                                    Group_Section__r.Section_Description__c, Group_Section__r.Section_Eff_Date__c, Group_Section__r.Section_Can_Date__c,
                                                                    Group_Section__r.SPI_Codes__c, Group_Section__r.Par_Plan_Codes__c, Group_Section__r.Alpha_Prefix__c
                                                                FROM BA_Assignments__r)
                                                                
                                                                    FROM GEMS_Benefit_Agreement__c
                                                                        WHERE AccountStructureCase__c = : caseId
                                                                            ORDER BY Name ASC];
                                                                                    
        return basCatsGSs;
    }
    
    public static list<GEMS_Category__c> getCategoryGroupSections(id caseID){
        
        list<GEMS_Category__c> catsBAsGSs =  [SELECT Id, Name, Case__c, Account__c, Category_Cobra_Code__c, Category_Description__c, 
                                                    Usage_Billing__c, Usage_Mailing__c, Usage_Product__c, Usage_Reporting__c, 
                                                    
        
                                                    (SELECT Id, Name, Case__c, Account__c, Benefit_Agreement__c, Category__c, Benefit_Agreement__r.id, 
                                                            Benefit_Agreement__r.Name, Benefit_Agreement__r.AccountStructureCase__c, Benefit_Agreement__r.Account__c,
                                                            Benefit_Agreement__r.Product_Name__c, Benefit_Agreement__r.BA_Description__c, 
                                                            Benefit_Agreement__r.BA_Fund_Type__c, Benefit_Agreement__r.Schedule__c, Benefit_Agreement__r.Billing_Profile__c,
                                                            Benefit_Agreement__r.ID_Card_Type__c, Benefit_Agreement__r.Dental_Product_Type__c, Benefit_Agreement__r.Copays__c, Benefit_Agreement__r.Prescription_Drug_Type__c
                                                        FROM Category_BA_Assignments__r),
                                                        
                                                    (SELECT Id, Name, Case__c, Account__c, Category__c, Group_Section__c, Group_Section__r.id, Group_Section__r.Name, 
                                                            Group_Section__r.Group_No__c, Group_Section__r.Section_No__c, Group_Section__r.Section_Description__c,
                                                            Group_Section__r.Account__c, Group_Section__r.Section_Eff_Date__c, Group_Section__r.Section_Can_Date__c,
                                                            Group_Section__r.SPI_Codes__c, Group_Section__r.Par_Plan_Codes__c, Group_Section__r.Alpha_Prefix__c
                                                        FROM GS_Assignments__r),
                                                        
                                                    (SELECT Id, Characteristic_Value__c FROM GEMS_Category_Characteristic_Association__r)
                                              
                                                            FROM GEMS_Category__c
                                                                WHERE Case__c= : caseId
                                                                    ORDER BY Name ASC];
        
        return catsBAsGSs;
    }
    
    public static list<GEMS_Group_Section__c> getGroupSectionBAsCategories(id caseID){
        
        list<GEMS_Group_Section__c> gsBAsCats =  [SELECT Id, Name, Case__c, Account__c, Group_No__c, Section_No__c, Section_Description__c, 
                                                    Section_Eff_Date__c, Section_Can_Date__c, SPI_Codes__c, Par_Plan_Codes__c, Alpha_Prefix__c, 
                                                    
                                                    (SELECT id, Case__c, Account__c, Benefit_Agreement__r.AccountStructureCase__c, Benefit_Agreement__r.Account__c, Benefit_Agreement__r.id, Benefit_Agreement__r.Name, Benefit_Agreement__r.BA_Description__c, 
                                                        Benefit_Agreement__r.BA_Fund_Type__c, Benefit_Agreement__r.Product__c, Benefit_Agreement__r.Schedule__c, Benefit_Agreement__r.Billing_Profile__c,
                                                     Benefit_Agreement__r.ID_Card_Type__c, Benefit_Agreement__r.Dental_Product_Type__c, Benefit_Agreement__r.Copays__c, Benefit_Agreement__r.Prescription_Drug_Type__c
                                                        FROM GS_Assignments__r),
                                                        
                                                    (SELECT id, Case__c, Account__c, Category__r.Case__c, Category__r.Account__c, Category__r.id, Category__r.Name, Category__r.Category_Description__c, Category__r.Usage_Billing__c, Category__r.Usage_Mailing__c, Category__r.Usage_Product__c, Category__r.Usage_Reporting__c                                                         
                                                     FROM Category_Assignments__r)
                                                        
                                                            FROM GEMS_Group_Section__c
                                                                WHERE Case__c= : caseId
                                                                    ORDER BY Name ASC];
        
        return gsBAsCats;
    }
    
    public List<SelectOption> getGroupNumbers(string groupNumbers){
        //Get all Group Numbers
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None', '--None--'));
        List<String> listOfGroupNos = new list<String>();
        
        //To get the list of available Group Numbers    
        if (groupNumbers != Null){
            listOfGroupNos = groupNumbers.split(';');
        }
        
        for(String GroupNo : listOfGroupNos) {
            options.add(new SelectOption(GroupNo, GroupNo));
        }   
        
        return options;

    }
    
    public static list<GEMS_Characteristic_Value__c> getCharValues(id caseId){
               list<GEMS_Characteristic_Value__c> CharValues = [SELECT Id, Char_Code__c, Characteristic__r.Mandatory__c , Characteristic__r.Comments__c , Characteristic__r.Corp_Characteristic_Code__r.Name, Characteristic__r.Id, Characteristic__r.Name, Characteristic__r.Effective_Date__c, Characteristic__r.End_Date__c, Characteristic__r.Usage__c, Code__c, Name,
                                                                          (SELECT Id, Category__r.Id FROM GEMS_Cat_Char_Value_Associations__r)
                                                                            FROM GEMS_Characteristic_Value__c WHERE Case__c =: caseId];
                return CharValues;    
    }
    
    
    public list<GEMS_Characteristic__c> getCharacts(id CaseId) {
        return [SELECT Id, Characteristic_Code__c FROM GEMS_Characteristic__c WHERE Case__c =:caseId];
    }
    
    /*public Integer getrenderMe(id CaseId){
        Case ParCase = [SELECT ID, GEMS_Account_Submission_Info__r.Funding_Type_Multiselect__c FROM Case WHERE id =: CaseId]; 
            String[] tmpString;
            if(ParCase.GEMS_Account_Submission_Info__r.Funding_Type_Multiselect__c != null)
             tmpString = ParCase.GEMS_Account_Submission_Info__r.Funding_Type_Multiselect__c.split(';');
            //if(ParCase.GEMS_Account_Submission_Info__r.Funding_Type_Multiselect__c != null)
                //tmpString = ParCase.GEMS_Account_Submission_Info__r.Funding_Type_Multiselect__c.split(';'); 
                
            Integer renderMe = 2; 
            if(tmpString != null){                 
            for(String Val : tmpString){
                if (Val == 'ASO'){
                    renderMe =  1;
                    break;
                }
                else if (Val == 'Premium'){
                    renderMe = 0;
                    break;
                }
            }
            }
            return renderMe;

    }*/
    
    public Integer getrenderMe(string fundTypes){
        String[] tmpString;
        if(fundTypes != null)
            tmpString = fundTypes.split(';');
                
        Integer renderMe = 2; 
        if(tmpString != null){                 
            for(String Val : tmpString){
                if (Val == 'ASO'){
                    renderMe =  1;
                    break;
                }
                else if (Val == 'Premium'){
                    renderMe = 0;
                    break;
                }
            }
        }
        return renderMe;

    }
    /*
    public static list<Integer> getNumberOfCharacteristics(list<GEMS_Characteristic__c> Characts) {
        
        //list<GEMS_Characteristic__c> Characts = [SELECT Id, Characteristic_Code__c FROM GEMS_Characteristic__c WHERE Case__c =:caseId];
        Integer i = 0;
        Integer count = Characts.size();
        List<Integer> Iter = new list<Integer>();
        while (i < count){
            iter.add(i);
            i = i +1;
        }
        return Iter;
    }
*/
}