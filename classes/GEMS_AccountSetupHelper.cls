//************************************************************************************
// Name             : GEMS_AccountSetupHelper.cls
// Description      : Helper class to get, validate and save account strcuture details.
// Created By       : Janakiram Jonnadula
// Created Date     : 6/22/2016
// 
// ************************Version Updates********************************************
// Date             Developer           Description
// -----------------------------------------------------------------------------------
// 4/3/2017         Ranjit Gandhi        Cancelled Ba's added to Grid output
// 4/12/2017        Phani Kommareddy     SFDC-3951 Prevent Creation of Duplicate Group Sections in GEMS
// 5/19/2017        Phani Kommareddy     SFDC-4781 Optimize duplicate check 
// 5/18/2017        Luke Chen            SFDC-4277 add Save Draft functionality
// 7/11/2017        Ketki Jagdale        SFDC-3641 added IsDescUpdated flag to check desc is updated and need to send record to b*
// 7/20/2017        Phani Kommareddy     SFDC-3641 added IsDescUpdated flag to check desc is updated and need to send record to b*
// 10/20/2017       Shankar              SFDC-6718. Description update production bug fix
// 03/21/2019       Jenny Dalsania       SFDC-8445 Default Section number to Category number for new account structures 
// 03/25/2017       Phani Kommareddy     SFDC-7859 GEMS: Acct Structure - Redesign of GEMS Account Structure Excel Output
// 4/19/2018        Gokul                SFDC-8523 GEMS: BlueSTAR - Add existing Category to an existing BA
// 4/30/2018		Luke Chen			 SFDC-6942 GEMS: Acct Structure - Move Billing Association to the Group Section level in the "Create Account Structure" view.
// 5/29/2018		Malathi.K			 SFDC-9952 Add product Code to Grid, Excel and VF Page.
// ************************************************************************************

public without sharing class GEMS_AccountSetupHelper {
    
    public boolean pagination = false;
    public integer limitSize;
    public integer offsetSize;
    public boolean pullChars = false;
    public boolean download = false;
    public map<Id, GEMS_Group_Section__c> mapOfSavedGroupSectionIds = new map<Id, GEMS_Group_Section__c>();
    public map<string, GEMS_Group_Section__c> mapOfSavedGroupSections = new map<string, GEMS_Group_Section__c>();
    public String accName;
    
    
    //Get account structure details
    public GEMS_AccountSetup getAccountStructure(id caseId){
        
        GEMS_AccountSetup accountStructure = new GEMS_AccountSetup();
        
        Case asCase = getAccountStructureCaseDetails(caseID);
        accountStructure.asCase = asCase;
        accName = asCase.Account.Name;
        
        //list<GEMS_Benefit_Agreement__c> basCatsGSs;
        map<Id, GEMS_Benefit_Agreement__c> mapBAsCatsGSs;
        map<Id, GEMS_Benefit_Agreement__c> mapCancelledBAs;
        
        if(pagination){
            //basCatsGSs = getBACategoriesAndGroupSectionsLimit(caseID, this.limitSize, this.offsetSize);
            mapBAsCatsGSs = getMapBACategoriesAndGroupSectionsLimit(caseID, this.limitSize, this.offsetSize);
            mapCancelledBAs = getMapcancelledBALimit(caseID, this.limitSize, this.offsetSize);
        }
        else{
            //basCatsGSs = getBACategoriesAndGroupSections(caseID); 
            mapBAsCatsGSs = getMapBACategoriesAndGroupSections(caseID); 
            mapCancelledBAs = getMapCancelledBA(caseID);
            system.debug('mapCancelledBAs'+mapCancelledBAs);
        }
        
        //list<GEMS_Group_Section__c> gsBAsCats = getGroupSectionBAsCategories(caseID); 
        //list<GEMS_Billing_Profile__c> bpBAsCats = getBillingProfileBAsCategories(caseID);   
        list<GEMS_Group_Section__c> gsBAsCats = getMapGroupSectionBAsCategories(caseID, mapBAsCatsGSs.keySet()); 
        list<GEMS_Billing_Profile__c> bpBAsCats = getMapBillingProfileBAsCategories(caseID, mapBAsCatsGSs.keySet());
        
        map<string, list<GEMS_Group_Section__c>> mapGSBAsCats = new map<string, list<GEMS_Group_Section__c>>();
        map<string, list<GEMS_BA_Assignment__c>> mapBAsGSs = new map<string, list<GEMS_BA_Assignment__c>>();
        map<string, list<GEMS_Category_Assignment__c>> mapCATsGSs = new map<string, list<GEMS_Category_Assignment__c>>();
        
        set<Id> catIds = new set<Id>();
        
        for(GEMS_Group_Section__c gs : gsBAsCats){
            if(gs.GS_Assignments__r == null || gs.Category_Assignments__r == null) continue;
            
            for(GEMS_BA_Assignment__c baAssoc : gs.GS_Assignments__r){
                for(GEMS_Category_Assignment__c catAssoc : gs.Category_Assignments__r){
                    string assoc = string.valueOf(baAssoc.Benefit_Agreement__r.Id) + string.valueOf(catAssoc.Category__r.Id);
                    
                    if(mapGSBAsCats.get(assoc) != null){
                        list<GEMS_Group_Section__c> gss = mapGSBAsCats.get(assoc);
                        gss.add(gs);
                        mapGSBAsCats.put(assoc, gss);
                    }
                    else{
                        list<GEMS_Group_Section__c> gss = new list<GEMS_Group_Section__c>();
                        gss.add(gs);
                        mapGSBAsCats.put(assoc, gss);    
                    }   
                    
                    if(mapBAsGSs.get(assoc) != null){
                        list<GEMS_BA_Assignment__c> bas = mapBAsGSs.get(assoc);
                        bas.add(baAssoc);
                        mapBAsGSs.put(assoc, bas);
                    }
                    else{
                        list<GEMS_BA_Assignment__c> bas = new list<GEMS_BA_Assignment__c>();
                        bas.add(baAssoc);
                        mapBAsGSs.put(assoc, bas);    
                    }
                    
                    if(mapCATsGSs.get(assoc) != null){
                        list<GEMS_Category_Assignment__c> cats = mapCATsGSs.get(assoc);
                        cats.add(catAssoc);
                        mapCATsGSs.put(assoc, cats);
                    }
                    else{
                        list<GEMS_Category_Assignment__c> cats = new list<GEMS_Category_Assignment__c>();
                        cats.add(catAssoc);
                        mapCATsGSs.put(assoc, cats);    
                    }
                    
                    catIds.add(catAssoc.Category__c);
                    
                }
            }   
            
        }
        
        map<string, list<GEMS_Billing_Profile__c>> mapBPBAsCats = new map<string, list<GEMS_Billing_Profile__c>>();
        map<string, list<GEMS_BP_BA_Association__c>> mapBAsBPs = new map<string, list<GEMS_BP_BA_Association__c>>();
        map<string, list<GEMS_BP_Category_Association__c>> mapCATsBPs = new map<string, list<GEMS_BP_Category_Association__c>>();
        
        for(GEMS_Billing_Profile__c bp : bpBAsCats){
            if(bp.BP_Associations__r == null || bp.BA_BP_Associations__r == null) continue;
            
            for(GEMS_BP_BA_Association__c baAssoc : bp.BP_Associations__r){
                for(GEMS_BP_Category_Association__c catAssoc : bp.BA_BP_Associations__r){
                    string assoc = string.valueOf(baAssoc.Benefit_Agreement__r.Id) + string.valueOf(catAssoc.Category__r.Id);
                    if(mapBPBAsCats.get(assoc) != null){
                        list<GEMS_Billing_Profile__c> bps = mapBPBAsCats.get(assoc);
                        bps.add(bp);
                        mapBPBAsCats.put(assoc, bps);
                    }
                    else{
                        list<GEMS_Billing_Profile__c> bps = new list<GEMS_Billing_Profile__c>();
                        bps.add(bp);
                        mapBPBAsCats.put(assoc, bps);    
                    }    
                    
                    if(mapBAsBPs.get(assoc) != null){
                        list<GEMS_BP_BA_Association__c> bas = mapBAsBPs.get(assoc);
                        bas.add(baAssoc);
                        mapBAsBPs.put(assoc, bas);
                    }
                    else{
                        list<GEMS_BP_BA_Association__c> bas = new list<GEMS_BP_BA_Association__c>();
                        bas.add(baAssoc);
                        mapBAsBPs.put(assoc, bas);    
                    }
                    
                    if(mapCATsBPs.get(assoc) != null){
                        list<GEMS_BP_Category_Association__c> cats = mapCATsBPs.get(assoc);
                        cats.add(catAssoc);
                        mapCATsBPs.put(assoc, cats);
                    }
                    else{
                        list<GEMS_BP_Category_Association__c> cats = new list<GEMS_BP_Category_Association__c>();
                        cats.add(catAssoc);
                        mapCATsBPs.put(assoc, cats);    
                    }
                    
                }
            } 
            
        }
        
        list<GEMS_Characteristic_Value__c> CharVals;
        map<Id, list<GEMS_Characteristic_Value__c>> mapCharVals;
        if(pullChars){
            accountStructure.Characts = getCharacts(caseID);          
            if(download){
                CharVals = getCharValues(caseID);
                accountStructure.CharVals = CharVals;
            }            
            mapCharVals = getMapCharValues(caseID, catIds);
        }
        
        if(mapBAsCatsGSs != null && mapBAsCatsGSs.size() > 0){
            accountStructure.groupNumbers = getGroupNumbers(asCase.GEMS_Reserved_Group_Numbers__c);
            //accountStructure.renderME = getrenderMe(asCase.GEMS_Account_Submission_Info__r.Funding_Type_Multiselect__c);
        }
        
        //Build Cancelled Benefit Agreements
        list<GEMS_AccountSetup.BenefitAgreement> cancelledbenefitAgreements = new list<GEMS_AccountSetup.BenefitAgreement>();
        if(mapCancelledBAs != null){
            for(GEMS_Benefit_Agreement__c ba : mapCancelledBAs.values()){
                GEMS_AccountSetup.BenefitAgreement cancelledbenefitAgreement = new GEMS_AccountSetup.BenefitAgreement();
                cancelledbenefitAgreement.ba = ba;
                cancelledbenefitAgreements.add(cancelledbenefitAgreement);
            }
            accountStructure.cancelledbenefitAgreements = cancelledbenefitAgreements;
        }
        //Build Benefit Agreements
        list<GEMS_AccountSetup.BenefitAgreement> benefitAgreements = new list<GEMS_AccountSetup.BenefitAgreement>();
        if(mapBAsCatsGSs != null){
            for(GEMS_Benefit_Agreement__c baCatGS : mapBAsCatsGSs.values()){
                GEMS_AccountSetup.BenefitAgreement benefitAgreement = new GEMS_AccountSetup.BenefitAgreement();
                benefitAgreement.ba = baCatGS;
                
                //Build Categories
                //list<GEMS_BA_Category_Assignment__c> baCatAssignments = baCatGS.BA_Category_Assignments__r;           
                list<GEMS_AccountSetup.Category> categories = new list<GEMS_AccountSetup.Category>();
                if(baCatGS.BA_Category_Assignments__r != null){
                    for(GEMS_BA_Category_Assignment__c baCatAssignment : baCatGS.BA_Category_Assignments__r){
                        GEMS_AccountSetup.Category category = new GEMS_AccountSetup.Category();
                        category.cat = baCatAssignment.Category__r; 
                        //SFDC-8523
                        category.bacat = baCatAssignment;
                        //SFDC-8523
                        string assoc = string.valueOf(baCatGS.Id) + string.valueOf(baCatAssignment.Category__r.Id);
                        
                        //Build Group Sections                                                
                        if(mapGSBAsCats.get(assoc) != null){
                            category.groupSection = mapGSBAsCats.get(assoc)[0];    
                            
                            GEMS_AccountSetup.GroupSection gs = new GEMS_AccountSetup.GroupSection();
                            gs.gsId = category.groupSection.id;
                            gs.caseId = category.groupSection.Case__c;
                            gs.acctId = category.groupSection.Account__c;
                            gs.gsName = category.groupSection.Name;
                            gs.isNew = category.groupSection.IsNew__c;
                            gs.groupNumber = category.groupSection.Group_No__c;
                            gs.sectionNumber = category.groupSection.Section_No__c;
                            gs.sectionDesc = category.groupSection.Section_Description__c;                            
                            if(category.groupSection.Section_Eff_Date__c == null)
                                category.groupSection.Section_Eff_Date__c = asCase.GEMS_Case_Effective_Date__c;                            
                            gs.effDate = category.groupSection.Section_Eff_Date__c;
                            
                            gs.spiCodes = category.groupSection.SPI_Codes__c;
                            gs.alphaPrefix = category.groupSection.Alpha_Prefix__c;
                            gs.parPlanCodes = category.groupSection.Par_Plan_Codes__c;
                            gs.billingAssoc = category.groupSection.Billing_Assoc__c;  // SFDC-6942
                            category.gs = gs;
                            
                            if(mapCATsGSs.get(assoc) != null)
                                category.catGSAssign = mapCATsGSs.get(assoc)[0];
                            if(mapBAsGSs.get(assoc) != null)
                                category.baGSAssign = mapBAsGSs.get(assoc)[0];
                            
                            //category.groupNumber = category.groupSection.group_no__c;
                            category.catCharValues = new list<GEMS_Characteristic_Value__c>();
                            if (mapCharVals != null && mapCharVals.size() > 0 && mapCharVals.get(category.cat.id) != null){
                                category.catCharValues = mapCharVals.get(category.cat.id);
                            }
                          
                        }
                        else{
                            //Create new Group Section record
                            GEMS_Group_Section__c groupSection = new GEMS_Group_Section__c();                                       
                            groupSection.Section_Eff_Date__c = asCase.GEMS_Case_Effective_Date__c;
                            groupSection.case__c = caseId;
                            groupSection.account__c = benefitAgreement.ba.account__c; 
                            //SFDC-8445 Default Section number to Category number for new account structures 
                            groupSection.Section_No__c = category.cat.Name;
                            groupSection.IsNew__c = true;
                            string sectionName = asCase.Account.Name;
                            if(sectionName != null && sectionName.length() > 40)
                                sectionName = sectionName.substring(0, 39);
                            groupSection.Section_Description__c = sectionName;     
                            groupSection.Name = benefitAgreement.ba.Name + '-' + category.cat.id;
                            groupSection.Billing_Assoc__c = benefitAgreement.ba.Billing_Assoc__c; // SFDC-6942, populate BA's billing association if a new Group-Section
                            category.groupSection = groupSection;    
                            
                            GEMS_AccountSetup.GroupSection gs = new GEMS_AccountSetup.GroupSection();                            
                            gs.caseId = category.groupSection.Case__c;
                            gs.acctId = category.groupSection.Account__c;
                            gs.gsName = category.groupSection.Name;
                            gs.isNew = category.groupSection.IsNew__c;                            
                            gs.sectionNumber = category.groupSection.Section_No__c;
                            gs.sectionDesc = category.groupSection.Section_Description__c;
                            gs.effDate = category.groupSection.Section_Eff_Date__c; 
                            gs.billingAssoc = category.groupSection.Billing_Assoc__c;   // SFDC-6942                        
                            category.gs = gs;
                            
                            //Create new Category GS Assign record 
                            GEMS_Category_Assignment__c catAssign = new GEMS_Category_Assignment__c();   
                            catAssign.case__c = caseId;
                            catAssign.account__c = benefitAgreement.ba.account__c;
                            catAssign.category__r =  category.cat;   
                            catAssign.category__c =  category.cat.id;
                            catAssign.Group_Section__r = groupSection;   
                            catAssign.IsNew__c  = true ;
                            category.catGSAssign = catAssign;
                            
                            //Create new BA GS Assign record
                            GEMS_BA_Assignment__c baGSAssign = new GEMS_BA_Assignment__c();
                            baGSAssign.case__c = caseId;      
                            baGSAssign.account__c = benefitAgreement.ba.account__c;                                                   
                            baGSAssign.Benefit_Agreement__r = benefitAgreement.ba; 
                            baGSAssign.Benefit_Agreement__c = benefitAgreement.ba.id;  
                            baGSAssign.Group_Section__r = groupSection;
                            baGsAssign.IsNew__c = true;
                            category.baGSAssign = baGSAssign;
                            
                            System.debug('New Category Group Section' + category);
                        }
                        
                        //Build Billing Profiles     
                        if(baCatGS != null && baCatGS.BA_Fund_Type__c == 'PREM' && category.cat.Usage_Billing__c){                                           
                            if(mapBPBAsCats.get(assoc) != null){  
                                if(!Test.isRunningTest()){
                                    
                                    category.billingProfile = mapBPBAsCats.get(assoc)[0];
                                    if(mapCATsBPs.get(assoc) != null)                                                                                        
                                        category.bpCategoryAssign = mapCATsBPs.get(assoc)[0];
                                    if(mapBAsBPs.get(assoc) != null)
                                        category.bpBAAssign = mapBAsBPs.get(assoc)[0];
                                }
                                
                            }
                            else{
                                //Create new Category BP Assign record 
                                GEMS_BP_Category_Association__c catAssign = new GEMS_BP_Category_Association__c();   
                                catAssign.case__c = caseId;    
                                catAssign.case__r = asCase;
                                catAssign.category__r =  category.cat;   
                                catAssign.category__c =  category.cat.id;
                                //catAssign.Billing_Profile__r = billingProfile;   
                                catAssign.IsNew__c  = true ;
                                category.bpCategoryAssign = catAssign;
                                
                                //Create new BA BP Assign record
                                GEMS_BP_BA_Association__c baBPAssign = new GEMS_BP_BA_Association__c();
                                baBPAssign.case__c = caseId;        
                                baBPAssign.case__r = asCase;
                                baBPAssign.Benefit_Agreement__r = benefitAgreement.ba; 
                                baBPAssign.Benefit_Agreement__c = benefitAgreement.ba.id;  
                                //baBPAssign.Billing_Profile__r = billingProfile;
                                baBPAssign.IsNew__c = true;
                                category.bpBAAssign = baBPAssign;
                            }                            
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
        list<GEMS_AccountSetup.StructureWorksheet> reportData = processAccountStructureWS(accountStructure);
        accountStructure.reportData = reportData;
        return accountStructure;
    }
    
    //Save Account Structure
    public string saveAccountStructure(GEMS_AccountSetup accountStructure){
        return saveAccountStructure(accountStructure, false);
    }
    
    
    //Save Account Structure
    // #FIXED remove duplicate code, merge code to saveAccountStructure, check duplicate rows,
    //        check partially completed row, do not write empty or incomplete rows to database
    public string saveAccountStructure(GEMS_AccountSetup accountStructure, boolean isSaveDraft){
        string result;
        try{
            map<string, GEMS_Group_Section__c> mapOfGroupSectionsToInsert = new map<string, GEMS_Group_Section__c>();
            list<GEMS_Group_Section__c> groupSectionsToInsert = new list<GEMS_Group_Section__c>();
            map<Id, GEMS_Group_Section__c> mapOfGroupSectionsToUpdate = new map<Id, GEMS_Group_Section__c>(); 
            list<GEMS_Group_Section__c> groupSectionsToUpdate = new list<GEMS_Group_Section__c>();     
            list<GEMS_Group_Section__c> groupSectionsToUpdate1 = new list<GEMS_Group_Section__c>();
            list<GEMS_Group_Section__c> groupSectionsToUpdate2 = new list<GEMS_Group_Section__c>();
            set<GEMS_Group_Section__c> groupSectionsToUpdate11 = new set<GEMS_Group_Section__c>();
            map<Id,GEMS_Group_Section__c> groupSectionsToUpdate22Map = new map<Id,GEMS_Group_Section__c>();
            
            //list<GEMS_Group_Section__c> gsToDelete = new list<GEMS_Group_Section__c>();
            
            list<GEMS_Group_Section__c> groupSections = new list<GEMS_Group_Section__c>();
            map<string, GEMS_Group_Section__c> mapOfGroupSections = new map<string, GEMS_Group_Section__c>(); 
            list<GEMS_Category_Assignment__c> catGSAssignments = new list<GEMS_Category_Assignment__c>();
            map<string, GEMS_Category_Assignment__c> mapOfCatGSAssignments = new map<string, GEMS_Category_Assignment__c>();
            list<GEMS_BA_Assignment__c> baGSAssignments = new list<GEMS_BA_Assignment__c>();
            map<string, GEMS_BA_Assignment__c> mapOfbaGSAssignments = new map<string, GEMS_BA_Assignment__c>();           
            list<GEMS_BP_Category_Association__c> catBPAssignments = new list<GEMS_BP_Category_Association__c>();
            map<string, GEMS_BP_Category_Association__c> mapOfCatBPAssignments = new map<string, GEMS_BP_Category_Association__c>();           
            list<GEMS_BP_BA_Association__c> baBPAssignments = new list<GEMS_BP_BA_Association__c>();
            map<string, GEMS_BP_BA_Association__c> mapOfbaBPAssignments = new map<string, GEMS_BP_BA_Association__c>();
            
            if(accountStructure != null && accountStructure.benefitAgreements != null){
                for(GEMS_AccountSetup.BenefitAgreement benefitAgreement : accountStructure.benefitAgreements){
                    if(benefitAgreement.categories != null){
                        for(GEMS_AccountSetup.Category category : benefitAgreement.categories){
                            // SFDC-6718. Only GS description update for an existing BA and Cat combination
                            String gsName = category.gs.groupNumber + '-' + category.gs.sectionNumber;
                            System.debug('gsName::'+gsName);
                            System.debug('mapOfSavedGroupSections::'+mapOfSavedGroupSections);
                            GEMS_Group_Section__c gsec = mapOfSavedGroupSections.get(gsName);
                            system.debug('Group Section^^^'+gsec);
                            if(null != gsec && !benefitAgreement.ba.IsNew__c && !category.cat.IsNew__c) { 
                            	boolean yesToUpdate = false;
                                if(gsec.Section_Description__c != category.gs.sectionDesc && category.gs.sectionDesc != accName) {gsec.Section_Description__c = category.gs.sectionDesc; yesToUpdate=true;} // SFDC-6942
                                if(gsec.Billing_Assoc__c != category.gs.billingAssoc) {gsec.Billing_Assoc__c = category.gs.billingAssoc; yesToUpdate=true;} // SFDC-6942, if changed, update this field   
                                if(yesToUpdate && mapOfGroupSectionsToUpdate.get(gsec.id) == null) {groupSectionsToUpdate.add(gsec); mapOfGroupSectionsToUpdate.put(gsec.id, gsec); }  // SFDC-6942                      
                            }
                            // SFDC-6718. End
                            // SFDC-3641: IsUpdated Flag for associated Group Section and Billing Profile is set to true if IsDesUpdate flag for any BA, Category and Group section under it are set to true.  
                            // SFDC-6718: Removed benefitAgreement.ba.IsDescUpdate__c || category.cat.IsDescUpdate__c in the below condition check (earlier added for 3641)                           
                            else if(benefitAgreement.ba.IsNew__c || category.cat.IsNew__c || category.bacat.isNew__c){// SFDC-8523
                                // SFDC-6718. End
                                if(category.gs != null){
                                    System.debug('category.gs '+category.gs);  
                                    
                                    // check if any group section has no group number, section number and section desc
                                    // The groupNumber='None' cannot be accepted, either
                                    if(String.isNotBlank(category.gs.groupNumber) && category.gs.groupNumber != 'None' && String.isNotBlank(category.gs.sectionNumber) && String.isNotBlank(category.gs.sectionDesc) ){
                                        //system.debug('Account Strcuture : ' + accountStructure);
                                        category.gs.gsName = category.gs.groupNumber + '-' + category.gs.sectionNumber;                                    
                                        System.debug('category.gs.gsName '+category.gs.gsName);
                                        System.debug('category.gs.groupNumber '+category.gs.groupNumber);
                                        System.debug('category.gs.sectionNumber '+category.gs.sectionNumber);
                                        System.debug('category.gs.sectionDesc '+category.gs.sectionDesc);
                                        
                                        //Prepare map of group sections - Sept Release                                           
                                        if(mapOfSavedGroupSections.get(category.gs.gsName) != null){  // existing group-section record      
                                            GEMS_Group_Section__c gs = mapOfSavedGroupSections.get(category.gs.gsName);
                                            if(mapOfGroupSectionsToUpdate.get(gs.id) == null){  // add to update existing group-section record
                                                System.debug('Marking isUpdated WITHOUT changing group section name 2');
                                                gs.IsUpdated__c = true;
                                                gs.Name = category.gs.gsName;
                                                if(gs.isNew__c){
                                                    //gs.Section_Description__c = category.gs.sectionDesc;
                                                    gs.SPI_Codes__c = category.gs.spiCodes;
                                                    gs.Alpha_Prefix__c = category.gs.alphaPrefix;
                                                    gs.Par_Plan_Codes__c = category.gs.parPlanCodes;
                                                }
                                                // SFDC-6781 Update GS's description only if it's updated by user
                                                // UI shows Account name in description field by default. Don't treat it as a desc update 
                                                if(gs.Section_Description__c != category.gs.sectionDesc && category.gs.sectionDesc != accName) {
                                                    gs.Section_Description__c = category.gs.sectionDesc;
                                                } // SFDC-6781 end
                                                if(gs.Billing_Assoc__c != category.gs.billingAssoc) gs.Billing_Assoc__c = category.gs.billingAssoc; // SFDC-6942, if changed, update this field                                         
                                                System.debug('Adding to groupSectionsToUpdate '+gs.Name+ ' '+gs.Group_No__c + ' '+gs.Section_No__c+' '+gs);
                                                groupSectionsToUpdate.add(gs); 
                                                mapOfGroupSectionsToUpdate.put(gs.id, gs);
                                            }
                                            if(category.gs.gsId != null && gs.id != category.gs.gsId){
                                                GEMS_Group_Section__c groupSectionToUpdate = mapOfSavedGroupSectionIds.get(category.gs.gsId);
                                                groupSectionToUpdate.Name = groupSectionToUpdate.Group_No__c+'-'+groupSectionToUpdate.Section_No__c;
                                                System.debug('Marking isUpdated AFTER changing group section name 1');
                                                groupSectionToUpdate.IsUpdated__c = true;
                                                System.debug('Set being created, adding groupSectionToUpdate '+groupSectionToUpdate);
                                                System.debug('Set being created, groupSectionToUpdate.IsUpdated__c  '+groupSectionToUpdate.IsUpdated__c );
                                                System.debug('Set being created, groupSectionToUpdate.Section_Description__c  '+groupSectionToUpdate.Section_Description__c + category.gs.sectionDesc);
                                                groupSectionsToUpdate11.add(groupSectionToUpdate);
                                            }
                                        } else {  // new group-section record, not in database
                                            if(mapOfGroupSectionsToInsert.get(category.gs.gsName) == null){
                                                System.debug('category.gs.gsName not found...'+category.gs.gsName);
                                                System.debug('category.gs.groupNumber-category.gs.sectionNumber'+category.gs.groupNumber+' '+category.gs.sectionNumber);
                                                GEMS_Group_Section__c gs = new GEMS_Group_Section__c();
                                                gs.IsNew__c = true;
                                                gs.Case__c = category.gs.caseId;
                                                gs.Account__c = category.gs.acctId;
                                                gs.Name = category.gs.gsName;
                                                gs.Group_No__c = category.gs.groupNumber;
                                                gs.Section_No__c = category.gs.sectionNumber;
                                                gs.Section_Description__c = category.gs.sectionDesc;
                                                gs.SPI_Codes__c = category.gs.spiCodes;
                                                gs.Alpha_Prefix__c = category.gs.alphaPrefix;
                                                gs.Par_Plan_Codes__c = category.gs.parPlanCodes;
                                                gs.Billing_Assoc__c = category.gs.billingAssoc; // SFDC-6942
                                                groupSectionsToInsert.add(gs);
                                                mapOfGroupSectionsToInsert.put(category.gs.gsName, gs);                                                
                                            }
                                            
                                            if(category.gs.gsId != null && mapOfSavedGroupSectionIds.get(category.gs.gsId) != null) {
                                                GEMS_Group_Section__c groupSectionToUpdate = mapOfSavedGroupSectionIds.get(category.gs.gsId);
                                                System.debug('Marking isUpdated AFTER changing group section name 2');
                                                groupSectionToUpdate.Name = groupSectionToUpdate.Group_No__c +'-'+groupSectionToUpdate.Section_No__c; 
                                                groupSectionToUpdate.IsUpdated__c = true;
                                                groupSectionsToUpdate22Map.put(groupSectionToUpdate.Id, groupSectionToUpdate);
                                                System.debug('groupSectionToUpdate by id , groupSectionToUpdate.IsUpdated__c  '+groupSectionToUpdate.IsUpdated__c );
                                                System.debug('groupSectionToUpdate by id , groupSectionToUpdate.Section_Description__c  '+groupSectionToUpdate.Section_Description__c + category.gs.sectionDesc);
                                                System.debug('groupSectionToUpdate by id '+groupSectionToUpdate);
                                            }
                                        }
                                    }
                                    
                                    //Return error if any of the data missing
                                    else if( !isSaveDraft ){
                                        result = 'Please enter Group No, Section No & Section Description details for all BAs.';
                                        return result;
                                    } // partially completed single row for SaveDraft is not allowed
                                    else if( (String.isNotBlank(category.gs.groupNumber) && category.gs.groupNumber != 'None') || String.isNotBlank(category.gs.sectionNumber)){
                                        result = 'To Save Draft, please complete the following row. BA#=' + benefitAgreement.ba.name + 
                                            ', Category#=' + category.cat.name +
                                            ', Group#=' + displayEmptyIfEmpty(category.gs.groupNumber) +
                                            ', Section#=' + displayEmptyIfEmpty(category.gs.sectionNumber) + 
                                            ', Section Description=' + displayEmptyIfEmpty(category.gs.sectionDesc);
                                        return result;
                                    }else if (String.isNotBlank(category.gs.groupNumber) && category.gs.groupNumber != 'None' && String.isNotBlank(category.gs.sectionNumber) && String.isBlank(category.gs.sectionDesc)){
                                        result = 'To Save Draft, please complete the following row. BA#=' + benefitAgreement.ba.name + 
                                            ', Category#=' + category.cat.name +
                                            ', Group#=' + displayEmptyIfEmpty(category.gs.groupNumber) +
                                            ', Section#=' + displayEmptyIfEmpty(category.gs.sectionNumber) + 
                                            ', Section Description=' + displayEmptyIfEmpty(category.gs.sectionDesc);
                                        return result;                                       
                                    }
                                }
                                
                                if(category.catGSAssign != null){ 
                                    category.catGSAssign.Name = category.gs.gsName;
                                    catGSAssignments.add(category.catGSAssign);
                                }                            
                                if(category.baGSAssign != null){ 
                                    category.baGSAssign.Name = category.gs.gsName;
                                    baGSAssignments.add(category.baGSAssign); 
                                }
                                
                                //Billing Profile - Sept Release
                                if(benefitAgreement.ba.BA_Fund_Type__c == 'PREM' && category.cat.Usage_Billing__c){
                                    Id bpId;
                                    string bpName;
                                    if(category.bpBAAssign != null){
                                        
                                        bpId = category.bpBAAssign.Billing_Profile__c;
                                        //bpName = category.bpBAAssign.Billing_Profile__r.Name;
                                        
                                        category.bpBAAssign.Name = bpId;    
                                        category.bpBAAssign.Billing_Profile__c = bpId;
                                        baBPAssignments.add(category.bpBAAssign);
                                    }
                                    if(category.bpCategoryAssign != null){
                                        category.bpCategoryAssign.Name = bpId;
                                        category.bpCategoryAssign.Billing_Profile__c = bpId;
                                        catBPAssignments.add(category.bpCategoryAssign);
                                    }                                
                                }
                            }
                        }
                    }
                }
            }            
            
            system.debug('catGSAssignments before save :' + catGSAssignments);
            system.debug('baGSAssignments before save:' + baGSAssignments);
            
            String duplicatesExist = checkAcctStrDups(accountStructure);
            if(duplicatesExist.length() > 0){
                result = duplicatesExist;
                return result;
            }
            
            Savepoint sp = Database.setSavepoint();
            
            try{
                
                if(!groupSectionsToUpdate.isEmpty()) {
                    System.debug('updating groupsections '+groupSectionsToUpdate);
                    update groupSectionsToUpdate; 
                }
                
                if(!groupSectionsToInsert.isEmpty()) {
                    System.debug('Inserting groupsections '+groupSectionsToInsert);
                    insert groupSectionsToInsert;
                }
                
                groupSectionsToUpdate1 = new list<GEMS_Group_Section__c>(groupSectionsToUpdate11);
                groupSectionsToUpdate2 = new list<GEMS_Group_Section__c>(groupSectionsToUpdate22Map.values());
                
                if(!groupSectionsToUpdate1.isEmpty())
                    update groupSectionsToUpdate1;
                
                if(!groupSectionsToUpdate2.isEmpty())
                    update groupSectionsToUpdate2;
                
                System.debug('groupSectionsToUpdate '+groupSectionsToUpdate);
                System.debug('groupSectionsToInsert '+groupSectionsToInsert);
                
                groupSections.addAll(groupSectionsToUpdate);
                groupSections.addAll(groupSectionsToInsert);
                
                for(GEMS_Group_Section__c gs : groupSections)
                    mapOfGroupSections.put(gs.Name, gs);
                
                system.debug('listOfGroupSections:' + groupSections);
                system.debug('mapOflistOfGroupSection:' + mapOfGroupSections);
                
                if(!mapOfGroupSections.isEmpty()) {
                    for(GEMS_Category_Assignment__c catGSAssign : catGSAssignments) {
                        
                        GEMS_Group_Section__c gs = mapOfGroupSections.get(catGSAssign.Name);
                        if(gs==null)
                            system.debug('gs not found with catGSAssign.Name '+catGSAssign.Name);
                        catGSAssign.Group_section__c = gs!=null?gs.id:null;
                        catGSAssign.Group_section__r = null;
                        //catGSAssign.id = null;
                        
                        GEMS_Category_Assignment__c temp = mapOfCatGSAssignments.get(catGSAssign.Name + string.valueOf(catGSAssign.Category__c));                   
                        if(temp != null && temp.id != null && catGSAssign.id == null){
                            //DO NOTHING
                        }
                        else
                            mapOfCatGSAssignments.put(catGSAssign.Name + string.valueOf(catGSAssign.Category__c),  catGSAssign);
                    }
                    
                    for(GEMS_BA_Assignment__c baGAAssign : baGSAssignments) {
                        GEMS_Group_Section__c gs = mapOfGroupSections.get(baGAAssign.Name);
                        if(gs==null)
                            system.debug('gs not found with baGAAssign.Name '+baGAAssign.Name);
                        
                        baGAAssign.Group_section__c = gs!=null?gs.id:null;
                        baGAAssign.Group_section__r = null;
                        //baGAAssign.id = null;
                        
                        GEMS_BA_Assignment__c temp = mapOfbaGSAssignments.get(baGAAssign.Name + string.valueOf(baGAAssign.Benefit_agreement__c));                   
                        if(temp != null && temp.id != null && baGAAssign.id == null){
                            //DO NOTHING
                        }
                        else                    
                            mapOfbaGSAssignments.put(baGAAssign.Name + string.valueOf(baGAAssign.Benefit_agreement__c), baGAAssign);
                    }
                    
                    //Billing Profile - Sept Release
                    for(GEMS_BP_Category_Association__c catBPAssign : catBPAssignments) {
                        //catBPAssign.id = null;  
                        
                        GEMS_BP_Category_Association__c temp = mapOfCatBPAssignments.get(catBPAssign.Name + string.valueOf(catBPAssign.Category__c));                   
                        if(temp != null && temp.id != null && catBPAssign.id == null){
                            //DO NOTHING
                        }
                        else
                            mapOfCatBPAssignments.put(catBPAssign.Name + string.valueOf(catBPAssign.Category__c),  catBPAssign);
                    }
                    
                    for(GEMS_BP_BA_Association__c baBPAssign : baBPAssignments) {           
                        //baBPAssign.id = null;      
                        
                        GEMS_BP_BA_Association__c temp = mapOfbaBPAssignments.get(baBPAssign.Name + string.valueOf(baBPAssign.Benefit_agreement__c));                   
                        if(temp != null && temp.id != null && baBPAssign.id == null){
                            //DO NOTHING
                        }
                        else
                            mapOfbaBPAssignments.put(baBPAssign.Name + string.valueOf(baBPAssign.Benefit_agreement__c), baBPAssign);
                    }
                    
                    list<GEMS_Category_Assignment__c> catGSAssignmentsToInsert = new list<GEMS_Category_Assignment__c>();
                    list<GEMS_Category_Assignment__c> catGSAssignmentsToUpdate = new list<GEMS_Category_Assignment__c>();
                    list<GEMS_BA_Assignment__c> baGSAssignmentsToInsert = new list<GEMS_BA_Assignment__c>();
                    list<GEMS_BA_Assignment__c> baGSAssignmentsToUpdate = new list<GEMS_BA_Assignment__c>();
                    
                    for(string catGSAssignment : mapOfCatGSAssignments.keySet() ) {
                        GEMS_Category_Assignment__c temp = mapOfCatGSAssignments.get(catGSAssignment);
                        if(temp.id != null)
                            catGSAssignmentsToUpdate.add(temp);
                        else
                            catGSAssignmentsToInsert.add(temp);
                    }
                    
                    for(string baGSAssignment : mapOfbaGSAssignments.keySet() ) {
                        GEMS_BA_Assignment__c temp = mapOfbaGSAssignments.get(baGSAssignment);
                        if(temp.id != null)
                            baGSAssignmentsToUpdate.add(temp);
                        else
                            baGSAssignmentsToInsert.add(temp);                   
                    }
                    
                    //Billing Profile - Sept Release
                    list<GEMS_BP_Category_Association__c> catBPAssignmentsToInsert = new list<GEMS_BP_Category_Association__c>();
                    list<GEMS_BP_Category_Association__c> catBPAssignmentsToUpdate = new list<GEMS_BP_Category_Association__c>();
                    list<GEMS_BP_BA_Association__c> baBPAssignmentsToInsert = new list<GEMS_BP_BA_Association__c>();
                    list<GEMS_BP_BA_Association__c> baBPAssignmentsToUpdate = new list<GEMS_BP_BA_Association__c>();
                    list<GEMS_Billing_Profile__c> bps = new list<GEMS_Billing_Profile__c>();
                    set<Id> bpIds = new set<id>();
                    
                    for(string catBPAssignment : mapOfCatBPAssignments.keySet() ){
                        GEMS_BP_Category_Association__c temp = mapOfCatBPAssignments.get(catBPAssignment);
                        if(temp.id != null)
                            catBPAssignmentsToUpdate.add(temp);
                        else
                            catBPAssignmentsToInsert.add(temp);
                        
                        bpIds.add(temp.Billing_Profile__c);
                    }
                    
                    for(string baBPAssignment : mapOfbaBPAssignments.keySet() ){
                        GEMS_BP_BA_Association__c temp = mapOfbaBPAssignments.get(baBPAssignment);
                        if(temp.id != null)
                            baBPAssignmentsToUpdate.add(temp);
                        else
                            baBPAssignmentsToInsert.add(temp);                    
                        
                        bpIds.add(temp.Billing_Profile__c);
                    }
                    
                    if(catGSAssignmentsToUpdate != null){ 
                        if( isSaveDraft ) catGSAssignmentsToUpdate = removeCategoryEmptyGroupSection(catGSAssignmentsToUpdate);
                        update catGSAssignmentsToUpdate;
                    }
                    if(baGSAssignmentsToUpdate != null){
                        if( isSaveDraft ) baGSAssignmentsToUpdate = removeBAEmptyGroupSection(baGSAssignmentsToUpdate);
                        update baGSAssignmentsToUpdate;
                    }
                    if(catGSAssignmentsToInsert != null){ 
                        if( isSaveDraft ) catGSAssignmentsToInsert = removeCategoryEmptyGroupSection(catGSAssignmentsToInsert);
                        insert catGSAssignmentsToInsert;
                    }
                    if(baGSAssignmentsToInsert != null) {
                        if( isSaveDraft ) baGSAssignmentsToInsert = removeBAEmptyGroupSection(baGSAssignmentsToInsert);                      
                        insert baGSAssignmentsToInsert;
                    }
                    
                    //Billing Profile - Sept Release
                    if(catBPAssignmentsToUpdate != null) 
                        update catBPAssignmentsToUpdate;
                    if(baBPAssignmentsToUpdate != null) 
                        update baBPAssignmentsToUpdate;
                    
                    if(catBPAssignmentsToInsert != null) 
                        insert catBPAssignmentsToInsert;
                    if(baBPAssignmentsToInsert != null) 
                        insert baBPAssignmentsToInsert;
                    
                    
                    bps = [SELECT Id, IsUpdated__c FROM GEMS_Billing_Profile__c WHERE Id IN : bpIds AND IsUpdated__c = false];
                    
                    for(GEMS_Billing_Profile__c bp : bps){
                        
                        bp.IsUpdated__c = true;
                        
                    }
                    if(bps != null)
                        update bps;
                    
                    //if(gsToDelete != null)
                    //delete gsToDelete;
                }
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
    
    //Validate Account Structure
    public static string validateAccountStructure(Id caseId){
        
        list<GEMS_Benefit_Agreement__c> basCatsGSs = getBACategoriesAndGroupSections(caseID);       
        list<GEMS_Group_Section__c> gsBAsCats = getGroupSectionBAsCategories(caseID); 
        list<GEMS_Benefit_Agreement__c> newBas = new list<GEMS_Benefit_Agreement__c>();
        list<GEMS_Category__c> cats = getCategories(caseID);
        set<string> usages = new set<string>();
        string result;
        
        for(GEMS_Category__c cat : cats){                        
            if(cat.Usage_Product__c == true && !usages.contains('Product'))
                usages.add('Product');
            if(cat.Usage_Billing__c == true && !usages.contains('Billing'))
                usages.add('Billing');
            if(cat.Usage_Reporting__c == true && !usages.contains('Reporting'))
                usages.add('Reporting');
            if(cat.Usage_Mailing__c == true && !usages.contains('Mailing'))
                usages.add('Mailing');
        }
        
        for(GEMS_Group_Section__c gs : gsBAsCats){
            set<string> catUsages = new set<string>();
            for(GEMS_Category_Assignment__c catAssign : gs.Category_Assignments__r){
                if(catAssign.Category__r.Usage_Product__c == true && !catUsages.contains('Product'))
                    catUsages.add('Product');
                if(catAssign.Category__r.Usage_Billing__c == true && !catUsages.contains('Billing'))
                    catUsages.add('Billing');
                if(catAssign.Category__r.Usage_Reporting__c == true && !catUsages.contains('Reporting'))
                    catUsages.add('Reporting');
                if(catAssign.Category__r.Usage_Mailing__c == true && !catUsages.contains('Mailing'))
                    catUsages.add('Mailing');
            }  
            
            if(!catUsages.isEmpty() && !catUsages.containsAll(usages)){
                result = 'Please review the Group#' + gs.Group_No__c + ' & ' + 'Section#' + gs.Section_No__c + ' Assignments.';
                return result;
            }
            
            if(gs.GS_Assignments__r != null && gs.GS_Assignments__r.size() > 2){
                result = 'Please review the Group#' + gs.Group_No__c + ' & ' + 'Section#' + gs.Section_No__c + ' Assignments. The Group Section has more than 2 BAs assigned';
                return result;
            }
        }
        
        //  Validate Button Functionality of checking for respective Derivation Type if a Characteristic is selected
        for(GEMS_Category__c cat : cats){
            
            if(!cat.GEMS_Category_Characteristic_Association__r.isEmpty() && cat.Members_Derivation_Type__c  == null){
                result = 'Please review the Category#' + cat.Name + ' and assign appropriate Derived Type';
                return result;
            }
            
            /*if(cat.Members_Derivation_Type__c  != null && cat.Members_Derivation_Type__c == 'CH' && 
!cat.GEMS_Category_Characteristic_Association__r.isEmpty() && cat.GEMS_Category_Characteristic_Association__r.size() > 1){
result = 'Category#' + cat.Name + ': For Derived Type, CH, Category cannot be assigned to multiple Values for a Characteristics.';
return result;
}*/
        }
        
        
        
        for(GEMS_Benefit_Agreement__c ba : basCatsGSs){
            set<string> catUsages = new set<string>();
            for(GEMS_BA_Category_Assignment__c baCat : ba.BA_Category_Assignments__r){
                if(baCat.Category__r.Usage_Product__c == true && !catUsages.contains('Product'))
                    catUsages.add('Product');
                if(baCat.Category__r.Usage_Billing__c == true && !catUsages.contains('Billing'))
                    catUsages.add('Billing');
                if(baCat.Category__r.Usage_Reporting__c == true && !catUsages.contains('Reporting'))
                    catUsages.add('Reporting');
                if(baCat.Category__r.Usage_Mailing__c == true && !catUsages.contains('Mailing'))
                    catUsages.add('Mailing');
            }
            if(!catUsages.containsAll(usages)){
                result = 'Please review the BA#' + ba.Name + ' Category Assignments.';
                return result;
            }
        }
        // vijay 08172016
        
        // converting date to to day
        Case asCase = getAccountStructureCaseDetails(caseID);
        Datetime dt = DateTime.newInstance(asCase.GEMS_Case_Effective_Date__c, Time.newInstance(0, 0, 0, 0));
        String day = String.valueOf(asCase.GEMS_Case_Effective_Date__c.day());
        if((day != '1' && day != '15' && day != '01' ) && asCase.GEMS_Submission_Type__c == 'Renewal'){
            result = 'Please review the Effective Date';
            return result ;            
        }        
        
        //SFDC-9952 Add Product Code
        newBas = [SELECT Id,Name, IsDescUpdate__c, Product__c,Product__r.ProductCode,Product__r.HCSC_State__c, Plan__c,isNew__c,AccountStructureCase__c,AccountStructureCase__r.Plan_State__c,AccountStructureCase__r.HCSC_Division__c,AccountStructureCase__r.GEMS_Case_Effective_Date__c,AccountStructureCase__r.GEMS_Submission_Type__c FROM GEMS_Benefit_Agreement__c  WHERE AccountStructureCase__c = : caseId AND isNew__c = true ];
        for(GEMS_Benefit_Agreement__c newBa : newBas){
            
            if(newBa.Product__c != null){
                
                if(newBa.Product__r.HCSC_State__c != newBa.AccountStructureCase__r.HCSC_Division__c){
                    result = 'THe Product State does not match the Account Structure Case for BA#'+newBa.Name;
                    return result;
                }
                
                if(newBa.Plan__c == null){
                    
                    result = 'Please review the Plan for BA#'+newBa.Name;
                    return result;
                }     
                
            }
            else{
                
                result = 'Please review BA Product for the following BA#'+newBa.Name;
                
            }
            
            
        }
        //vijay 08172016
        
        
        return result;
    }
    
    public static Case getAccountStructureCaseDetails(id caseID){
        
        Case asCase;
        
        list<Case> cases = [SELECT Id, HCSC_Division__c, GEMS_Is_Account_Derivated__c, Account.AccountNumber, Account.External_ID__c, Account.Name, GEMS_Case_Effective_Date__c, GEMS_Submission_Type__c, GEMS_Submission_Sub_Type__c, GEMS_Line_of_Business__c, GEMS_Account_Submission_Info__c, Market_Segment__c, Status, Owner.Name, GEMS_Type__c,                                                            
                            GEMS_Reserved_Group_Numbers__c,CaseNumber , GEMS_Account_Submission_Info__r.Funding_Type_Multiselect__c, Funding_Type_Multiselect__c, GEMS_BAs_Per_Page__c
                            FROM Case
                            WHERE Id = : caseId];
        
        if(!cases.isEmpty())
            asCase = cases[0];
        
        return asCase;
    }
    
    //Get all catgories and Group-Sections assigned to BAs
    //SFDC-9952 Add ProductCode.
    public static list<GEMS_Benefit_Agreement__c> getBACategoriesAndGroupSections(id caseID){
        
        list<GEMS_Benefit_Agreement__c> basCatsGSs =  [SELECT Id, Name, Account__c, Product_Name__c,Plan__c, Plan__r.Name, Product__r.Name, BA_Description__c,Product__r.ProductCode, 
                                                       BA_Fund_Type__c, Schedule__c, Billing_Profile__c, Billing_Assoc__c, ID_Card_Type__c, IsNew__c,
                                                       AccountStructureCase__c, IsCancelled__c,  IsDescUpdate__c, AccountStructureCase__r.Id,
                                                       
                                                       
                                                       (SELECT Id, Name, Case__c, Account__c, Benefit_Agreement__c, Category__c, 
                                                        Category__r.Category_Description__c , Category__r.id, Category__r.Name, Category__r.Account__c,
                                                        Category__r.Case__c, Category__r.Category_Cobra_Code__c, Category__r.Usage_Billing__c, 
                                                        Category__r.Usage_Mailing__c, Category__r.Usage_Product__c, Category__r.Usage_Reporting__c, Category__r.IsNew__c, 
                                                        // SFDC-6718 Added Category__r.IsUpdated__c field
                                                        Category__r.IsCancelled__c,Category__r.IsDescUpdate__c, Category__r.IsUpdated__c
                                                        FROM BA_Category_Assignments__r 
                                                        WHERE Category__r.IsCancelled__c = false AND Category__r.Has_Group_Sections__c = true
                                                        ORDER BY Category__r.Name asc),
                                                       
                                                       (SELECT Id, Name, Case__c, Account__c, Benefit_Agreement__c, Group_Section__c, Group_Section__r.id, 
                                                        Group_Section__r.Name, Group_Section__r.Group_No__c, Group_Section__r.Section_No__c,  Group_Section__r.Account__c,
                                                        Group_Section__r.Section_Description__c, Group_Section__r.Section_Eff_Date__c, Group_Section__r.Section_Can_Date__c,Group_Section__r.IsNew__c,
                                                        Group_Section__r.SPI_Codes__c, Group_Section__r.Par_Plan_Codes__c, Group_Section__r.Alpha_Prefix__c, Group_Section__r.Billing_Assoc__c // SFDC-6942 added Billing_Assoc__c
                                                        FROM BA_Assignments__r),
                                                       
                                                       (SELECT Id, Name, Benefit_Agreement__c, Billing_Profile__c, Billing_Profile__r.id, Billing_Profile__r.Name, 
                                                        Billing_Profile__r.Billing_Profile_Number__c, Billing_Profile__r.Effective_Date__c,  Billing_Profile__r.IsNew__c                                                                    
                                                        FROM BA_Associations__r)
                                                       
                                                       FROM GEMS_Benefit_Agreement__c
                                                       WHERE AccountStructureCase__c = : caseId AND IsCancelled__c = false AND Has_Group_Sections__c = true
                                                       ORDER BY Name ASC];
        
        
        
        
        return basCatsGSs;
    }
    
    //New
    public static map<Id, GEMS_Benefit_Agreement__c> getMapBACategoriesAndGroupSections(id caseID){
        // SFDC-9952 Add Product Code.
        map<Id, GEMS_Benefit_Agreement__c> mapBAsCatsGSs =  new map<Id, GEMS_Benefit_Agreement__c>([SELECT Id, Name, Account__c, Product_Name__c, Plan__c, Plan__r.Name, Product__r.Name, Product__r.ProductCode, BA_Description__c, 
                                                                                                    BA_Fund_Type__c, Schedule__c, Billing_Profile__c, Billing_Assoc__c, ID_Card_Type__c, IsNew__c,
                                                                                                    AccountStructureCase__c, IsCancelled__c,  IsDescUpdate__c, AccountStructureCase__r.Id,
                                                                                                    
                                                                                                    (SELECT Id, Name, isNew__c, Case__c, Account__c, Benefit_Agreement__c, Category__c, 
                                                                                                     Category__r.Category_Description__c , Category__r.id, Category__r.Name, Category__r.Account__c,
                                                                                                     Category__r.Case__c, Category__r.Category_Cobra_Code__c, Category__r.Usage_Billing__c, 
                                                                                                     Category__r.Usage_Mailing__c, Category__r.Usage_Product__c, Category__r.Usage_Reporting__c, Category__r.IsNew__c, 
                                                                                                     Category__r.IsCancelled__c,category__r.IsDescUpdate__c, category__r.IsUpdated__c 
                                                                                                     FROM BA_Category_Assignments__r 
                                                                                                     WHERE Category__r.IsCancelled__c = false AND Category__r.Has_Group_Sections__c = true)
                                                                                                    
                                                                                                    FROM GEMS_Benefit_Agreement__c
                                                                                                    WHERE AccountStructureCase__c = : caseId AND IsCancelled__c = false AND Has_Group_Sections__c = true]);
        
        return mapBAsCatsGSs;
    }
    
    public static map<Id, GEMS_Benefit_Agreement__c> getMapCancelledBA(id caseID){
        // SFDC-9952 Add Product Code.
        map<Id, GEMS_Benefit_Agreement__c> mapBAsCatsGSs =  new map<Id, GEMS_Benefit_Agreement__c>([SELECT Id, Name, Account__c, Product_Name__c, Plan__c, Plan__r.Name, Product__r.Name,Product__r.ProductCode,BA_Description__c, 
                                                                                                    BA_Fund_Type__c, Schedule__c, Billing_Profile__c, Billing_Assoc__c, ID_Card_Type__c, IsNew__c,
                                                                                                    AccountStructureCase__c, IsCancelled__c, Cancel_Date__c, AccountStructureCase__r.Id
                                                                                                    FROM GEMS_Benefit_Agreement__c
                                                                                                    WHERE AccountStructureCase__c = : caseId 
                                                                                                    AND IsCancelled__c = true]);
        
        return mapBAsCatsGSs;
    }
     //SFDC-9952 Add Product Code
    public static list<GEMS_Category__c> getCategoryGroupSections(id caseID){
        
        list<GEMS_Category__c> catsBAsGSs =  [SELECT Id, Name, Case__c, Account__c, Category_Cobra_Code__c, Category_Description__c, 
                                              Usage_Billing__c, Usage_Mailing__c, Usage_Product__c, Usage_Reporting__c,IsNew__c,  IsDescUpdate__c,
                                              
                                              
                                              (SELECT Id, Name, Case__c, Account__c, Benefit_Agreement__c, Category__c, Benefit_Agreement__r.id, 
                                               Benefit_Agreement__r.Name, Benefit_Agreement__r.AccountStructureCase__c, Benefit_Agreement__r.Account__c,
                                               Benefit_Agreement__r.Product_Name__c, Benefit_Agreement__r.Product__r.ProductCode,Benefit_Agreement__r.BA_Description__c, 
                                               Benefit_Agreement__r.BA_Fund_Type__c, Benefit_Agreement__r.Schedule__c, Benefit_Agreement__r.Billing_Profile__c,
                                               Benefit_Agreement__r.ID_Card_Type__c, Benefit_Agreement__r.Dental_Product_Type__c, Benefit_Agreement__r.Copays__c, Benefit_Agreement__r.Prescription_Drug_Type__c , Benefit_Agreement__r.IsNew__c
                                               FROM Category_BA_Assignments__r
                                               WHERE Benefit_Agreement__r.IsCancelled__c = false AND Benefit_Agreement__r.Has_Group_Sections__c = true),
                                              
                                              (SELECT Id, Name, Case__c, Account__c, Category__c, Group_Section__c, Group_Section__r.id, Group_Section__r.Name, 
                                               Group_Section__r.Group_No__c, Group_Section__r.Section_No__c, Group_Section__r.Section_Description__c,
                                               Group_Section__r.Account__c, Group_Section__r.Section_Eff_Date__c, Group_Section__r.Section_Can_Date__c,
                                               Group_Section__r.SPI_Codes__c, Group_Section__r.Par_Plan_Codes__c, Group_Section__r.Alpha_Prefix__c ,  Group_Section__r.IsNew__c, Group_Section__r.Billing_Assoc__c // SFDC-6942 added Billing_Assoc__c
                                               FROM GS_Assignments__r),
                                              
                                              (SELECT Id, Characteristic_Value__c, Characteristic_Value__r.Characteristic__c FROM GEMS_Category_Characteristic_Association__r)
                                              
                                              FROM GEMS_Category__c
                                              WHERE Case__c= : caseId AND Has_Group_Sections__c = true
                                              ORDER BY Name ASC];
        
        return catsBAsGSs;
    }
    
     
    public static list<GEMS_Category__c> getCategories(id caseID){
        list<GEMS_Category__c> cats =  [SELECT Id, Name, Case__c, Account__c, Category_Cobra_Code__c, Category_Description__c, Members_Derivation_Type__c,
                                        Usage_Billing__c, Usage_Mailing__c, Usage_Product__c, Usage_Reporting__c,IsNew__c,  IsDescUpdate__c , IsUpdated__c, 
                                        (SELECT Id, Characteristic_Value__c FROM GEMS_Category_Characteristic_Association__r)                                                    
                                        FROM GEMS_Category__c
                                        WHERE Case__c= : caseId AND IsCancelled__c = false AND Has_Group_Sections__c = true
                                        ORDER BY Name ASC];
        return cats;
    }
    
     //SFDC-9952 Add Product Code
    public static list<GEMS_Group_Section__c> getGroupSectionBAsCategories(id caseID){
        
        list<GEMS_Group_Section__c> gsBAsCats =  [SELECT Id, Name, Case__c, Account__c, Group_No__c, Section_No__c, Section_Description__c, 
                                                  Section_Eff_Date__c, Section_Can_Date__c, SPI_Codes__c, Par_Plan_Codes__c, Alpha_Prefix__c,isNew__c, isUpdated__c,Billing_Assoc__c, // SFDC-6942 added Billing_Assoc__c
                                                  (SELECT id, Case__c, Account__c, Benefit_Agreement__r.AccountStructureCase__c, Benefit_Agreement__r.Account__c, Benefit_Agreement__r.id, Benefit_Agreement__r.Name, Benefit_Agreement__r.BA_Description__c, 
                                                   Benefit_Agreement__r.BA_Fund_Type__c, Benefit_Agreement__r.Product__c, Benefit_Agreement__r.Product__r.ProductCode,Benefit_Agreement__r.Schedule__c, Benefit_Agreement__r.Billing_Profile__c,Benefit_Agreement__r.IsNew__c,
                                                   Benefit_Agreement__r.ID_Card_Type__c, Benefit_Agreement__r.Dental_Product_Type__c, Benefit_Agreement__r.Copays__c, Benefit_Agreement__r.Prescription_Drug_Type__c
                                                   FROM GS_Assignments__r
                                                   WHERE Benefit_Agreement__r.IsCancelled__c = false AND Benefit_Agreement__r.Has_Group_Sections__c = true),
                                                  
                                                  (SELECT id, Case__c, Account__c, Category__r.Case__c, Category__r.Account__c, Category__r.id, Category__r.Name, 
                                                   Category__r.Category_Description__c, Category__r.Usage_Billing__c, Category__r.Usage_Mailing__c, Category__r.Usage_Product__c, 
                                                   Category__r.Usage_Reporting__c, Category__r.IsNew__c, Category__r.IsCancelled__c                                                      
                                                   FROM Category_Assignments__r
                                                   WHERE Category__r.IsCancelled__c = false AND Category__r.Has_Group_Sections__c = true)
                                                  
                                                  FROM GEMS_Group_Section__c
                                                  WHERE Case__c= : caseId
                                                  ORDER BY Name ASC];        
        return gsBAsCats;
    }
    
    //New
    //SFDC-9952 Add Product Code
    public static list<GEMS_Group_Section__c> getMapGroupSectionBAsCategories(id caseID, set<id> baIds){
        
        list<GEMS_Group_Section__c> gsBAsCats =  [SELECT Id, Name, Case__c, Account__c, Group_No__c, Section_No__c, Section_Description__c, 
                                                  Section_Eff_Date__c, Section_Can_Date__c, SPI_Codes__c, Par_Plan_Codes__c, Alpha_Prefix__c,isNew__c, isUpdated__c,Billing_Assoc__c, // SFDC-6942 added Billing_Assoc__c
                                                  (SELECT id, Case__c, Account__c, Benefit_Agreement__r.AccountStructureCase__c, Benefit_Agreement__r.Account__c, Benefit_Agreement__r.id, Benefit_Agreement__r.Name, Benefit_Agreement__r.BA_Description__c, 
                                                   Benefit_Agreement__r.BA_Fund_Type__c, Benefit_Agreement__r.Product__c,Benefit_Agreement__r.Product__r.ProductCode, Benefit_Agreement__r.Schedule__c, Benefit_Agreement__r.Billing_Profile__c,Benefit_Agreement__r.IsNew__c,
                                                   Benefit_Agreement__r.ID_Card_Type__c, Benefit_Agreement__r.Dental_Product_Type__c, Benefit_Agreement__r.Copays__c, Benefit_Agreement__r.Prescription_Drug_Type__c
                                                   FROM GS_Assignments__r WHERE Benefit_Agreement__r.Id IN : baIds),
                                                  //WHERE Benefit_Agreement__r.IsCancelled__c = false AND Benefit_Agreement__r.Has_Group_Sections__c = true AND Benefit_Agreement__r.Id IN : baIds),
                                                  
                                                  (SELECT id, Case__c, Account__c, Category__r.Case__c, Category__r.Account__c, Category__r.id, Category__r.Name, 
                                                   Category__r.Category_Description__c, Category__r.Usage_Billing__c, Category__r.Usage_Mailing__c, Category__r.Usage_Product__c, 
                                                   Category__r.Usage_Reporting__c, Category__r.IsNew__c, Category__r.IsCancelled__c                                                      
                                                   FROM Category_Assignments__r
                                                   WHERE Category__r.IsCancelled__c = false AND Category__r.Has_Group_Sections__c = true)
                                                  
                                                  FROM GEMS_Group_Section__c
                                                  WHERE Case__c= : caseId AND ID IN (SELECT Group_Section__c FROM GEMS_BA_Assignment__c
                                                                                     WHERE Benefit_Agreement__r.IsCancelled__c = false 
                                                                                     AND Benefit_Agreement__r.Has_Group_Sections__c = true 
                                                                                     AND Benefit_Agreement__r.Id IN : baIds)];       
        
        return gsBAsCats;
    }
     //SFDC-9952 Add Product Code
    public static list<GEMS_Billing_Profile__c> getBillingProfileBAsCategories(id caseID){
        
        list<GEMS_Billing_Profile__c> bpBAsCats =  [SELECT Id, Name, Case__c, Account__c, Billing_Profile_Number__c, Effective_Date__c, IsNew__c, 
                                                    
                                                    (SELECT id, Billing_Profile__r.Name, Case__c, Billing_Profile__c, Benefit_Agreement__r.AccountStructureCase__c, Benefit_Agreement__r.Account__c, Benefit_Agreement__r.id, Benefit_Agreement__r.Name, Benefit_Agreement__r.BA_Description__c, 
                                                     Benefit_Agreement__r.BA_Fund_Type__c, Benefit_Agreement__r.Product__c,Benefit_Agreement__r.Product__r.ProductCode, Benefit_Agreement__r.Schedule__c, Benefit_Agreement__r.Billing_Profile__c,
                                                     Benefit_Agreement__r.ID_Card_Type__c, Benefit_Agreement__r.Dental_Product_Type__c, Benefit_Agreement__r.Copays__c, Benefit_Agreement__r.Prescription_Drug_Type__c , Benefit_Agreement__r.IsNew__c
                                                     FROM BP_Associations__r
                                                     WHERE Benefit_Agreement__r.IsCancelled__c = false AND Benefit_Agreement__r.Has_Group_Sections__c = true),
                                                    
                                                    (SELECT id, Billing_Profile__r.Name, Case__c, Billing_Profile__c,Category__r.Case__c, Category__r.Account__c, Category__r.id, Category__r.Name, Category__r.Category_Description__c, Category__r.Usage_Billing__c, Category__r.Usage_Mailing__c, Category__r.Usage_Product__c, Category__r.Usage_Reporting__c , Category__r.IsNew__c                                                        
                                                     FROM BA_BP_Associations__r
                                                     WHERE Category__r.IsCancelled__c = false AND Category__r.Has_Group_Sections__c = true)
                                                    
                                                    FROM GEMS_Billing_Profile__c
                                                    WHERE Case__c= : caseId];
        
        return bpBAsCats;
    }
     //SFDC-9952 Add Product Code
    public static list<GEMS_Billing_Profile__c> getMapBillingProfileBAsCategories(id caseID, set<id> baIds){
        
        list<GEMS_Billing_Profile__c> bpBAsCats =  [SELECT Id, Name, Case__c, Account__c, Billing_Profile_Number__c, Effective_Date__c, IsNew__c, 
                                                    
                                                    (SELECT id, Billing_Profile__r.Name, Case__c, Billing_Profile__c, Benefit_Agreement__r.AccountStructureCase__c, Benefit_Agreement__r.Account__c, Benefit_Agreement__r.id, Benefit_Agreement__r.Name, Benefit_Agreement__r.BA_Description__c, 
                                                     Benefit_Agreement__r.BA_Fund_Type__c, Benefit_Agreement__r.Product__c,Benefit_Agreement__r.Product__r.ProductCode, Benefit_Agreement__r.Schedule__c, Benefit_Agreement__r.Billing_Profile__c,
                                                     Benefit_Agreement__r.ID_Card_Type__c, Benefit_Agreement__r.Dental_Product_Type__c, Benefit_Agreement__r.Copays__c, Benefit_Agreement__r.Prescription_Drug_Type__c , Benefit_Agreement__r.IsNew__c
                                                     FROM BP_Associations__r WHERE Benefit_Agreement__r.Id IN : baIds),
                                                    //WHERE Benefit_Agreement__r.IsCancelled__c = false AND Benefit_Agreement__r.Has_Group_Sections__c = true AND Benefit_Agreement__r.Id IN : baIds),
                                                    
                                                    (SELECT id, Billing_Profile__r.Name, Case__c, Billing_Profile__c,Category__r.Case__c, Category__r.Account__c, Category__r.id, Category__r.Name, Category__r.Category_Description__c, Category__r.Usage_Billing__c, Category__r.Usage_Mailing__c, Category__r.Usage_Product__c, Category__r.Usage_Reporting__c , Category__r.IsNew__c                                                        
                                                     FROM BA_BP_Associations__r
                                                     WHERE Category__r.IsCancelled__c = false AND Category__r.Has_Group_Sections__c = true)
                                                    
                                                    FROM GEMS_Billing_Profile__c
                                                    WHERE Case__c= : caseId AND ID IN (SELECT Billing_Profile__c FROM GEMS_BP_BA_Association__c 
                                                                                       WHERE Benefit_Agreement__r.IsCancelled__c = false 
                                                                                       AND Benefit_Agreement__r.Has_Group_Sections__c = true 
                                                                                       AND Benefit_Agreement__r.Id IN : baIds)];
        
        return bpBAsCats;
    }
    
    //Get all catgories and Group-Sections assigned to BAs
    //SFDC-9952 Add Product Code
    public static list<GEMS_Benefit_Agreement__c> getBACategoriesAndGroupSectionsLimit(id caseID, Integer limitSize1, Integer offsetSize1){
        
        list<GEMS_Benefit_Agreement__c> basCatsGSsLimited =  [SELECT Id, Name, Account__c, Product_Name__c, Plan__r.Name, Product__r.Name, Product__r.ProductCode,BA_Description__c, 
                                                              BA_Fund_Type__c, Schedule__c, Billing_Profile__c, Billing_Assoc__c, ID_Card_Type__c, IsNew__c,
                                                              AccountStructureCase__c, IsCancelled__c,  IsDescUpdate__c, AccountStructureCase__r.Id,
                                                              
                                                              (SELECT Id, Name, Case__c, Account__c, Benefit_Agreement__c, Category__c, 
                                                               Category__r.Category_Description__c , Category__r.id, Category__r.Name, Category__r.Account__c,
                                                               Category__r.Case__c, Category__r.Category_Cobra_Code__c, Category__r.Usage_Billing__c, 
                                                               Category__r.Usage_Mailing__c, Category__r.Usage_Product__c, Category__r.Usage_Reporting__c, Category__r.IsNew__c, 
                                                               Category__r.IsCancelled__c,category__r.IsDescUpdate__c, category__r.isUpdated__c 
                                                               FROM BA_Category_Assignments__r 
                                                               WHERE Category__r.IsCancelled__c = false AND Category__r.Has_Group_Sections__c = true
                                                               ORDER BY Category__r.Name asc),
                                                              
                                                              (SELECT Id, Name, Case__c, Account__c, Benefit_Agreement__c, Group_Section__c, Group_Section__r.id, 
                                                               Group_Section__r.Name, Group_Section__r.Group_No__c, Group_Section__r.Section_No__c,  Group_Section__r.Account__c,
                                                               Group_Section__r.Section_Description__c, Group_Section__r.Section_Eff_Date__c, Group_Section__r.Section_Can_Date__c,Group_Section__r.IsNew__c,
                                                               Group_Section__r.SPI_Codes__c, Group_Section__r.Par_Plan_Codes__c, Group_Section__r.Alpha_Prefix__c, Group_Section__r.Billing_Assoc__c // SFDC-6942 added Billing_Assoc__c
                                                               FROM BA_Assignments__r),
                                                              
                                                              (SELECT Id, Name, Benefit_Agreement__c, Billing_Profile__c, Billing_Profile__r.id, Billing_Profile__r.Name, 
                                                               Billing_Profile__r.Billing_Profile_Number__c, Billing_Profile__r.Effective_Date__c,  Billing_Profile__r.IsNew__c                                                                    
                                                               FROM BA_Associations__r)
                                                              
                                                              FROM GEMS_Benefit_Agreement__c
                                                              WHERE AccountStructureCase__c = : caseId AND IsCancelled__c = false AND Has_Group_Sections__c = true
                                                              ORDER BY Name ASC
                                                              Limit : limitSize1 
                                                              OFFSET : offsetSize1];
        
        return basCatsGSsLimited;
    }
     //SFDC-9952 Add Product Code
    public static map<Id, GEMS_Benefit_Agreement__c> getMapcancelledBALimit(id caseID, Integer limitSize1, Integer offsetSize1){
        
        map<Id, GEMS_Benefit_Agreement__c> mapcancelledBAsLimited =  new map<Id, GEMS_Benefit_Agreement__c>([SELECT Id, Name, Account__c, Product_Name__c, Plan__r.Name, Product__r.Name,Product__r.ProductCode, BA_Description__c, 
                                                                                                             BA_Fund_Type__c, Schedule__c, Billing_Profile__c, Billing_Assoc__c, ID_Card_Type__c, IsNew__c,
                                                                                                             AccountStructureCase__c, IsCancelled__c,  IsDescUpdate__c, Cancel_Date__c, AccountStructureCase__r.Id 
                                                                                                             FROM GEMS_Benefit_Agreement__c
                                                                                                             WHERE AccountStructureCase__c = : caseId AND IsCancelled__c = true 
                                                                                                             ORDER BY Name ASC
                                                                                                             Limit : limitSize1 
                                                                                                             OFFSET : offsetSize1]);
        
        return mapcancelledBAsLimited;
    }
    //New
    //SFDC-9952 Add Product Code
    public static map<Id, GEMS_Benefit_Agreement__c> getMapBACategoriesAndGroupSectionsLimit(id caseID, Integer limitSize1, Integer offsetSize1){
        
        map<Id, GEMS_Benefit_Agreement__c> mapBAsCatsGSsLimited =  new map<Id, GEMS_Benefit_Agreement__c>([SELECT Id, Name, Account__c, Product_Name__c, Plan__r.Name, Product__r.Name,Product__r.ProductCode, BA_Description__c, 
                                                                                                           BA_Fund_Type__c, Schedule__c, Billing_Profile__c, Billing_Assoc__c, ID_Card_Type__c, IsNew__c,
                                                                                                           AccountStructureCase__c, IsCancelled__c,  IsDescUpdate__c, AccountStructureCase__r.Id,
                                                                                                           
                                                                                                           (SELECT Id, Name, isNew__c, Case__c, Account__c, Benefit_Agreement__c, Category__c, 
                                                                                                            Category__r.Category_Description__c , Category__r.id, Category__r.Name, Category__r.Account__c,
                                                                                                            Category__r.Case__c, Category__r.Category_Cobra_Code__c, Category__r.Usage_Billing__c, 
                                                                                                            Category__r.Usage_Mailing__c, Category__r.Usage_Product__c, Category__r.Usage_Reporting__c, Category__r.IsNew__c, 
                                                                                                            Category__r.IsCancelled__c,category__r.IsDescUpdate__c, category__r.IsUpdated__c
                                                                                                            FROM BA_Category_Assignments__r 
                                                                                                            WHERE Category__r.IsCancelled__c = false AND Category__r.Has_Group_Sections__c = true
                                                                                                            ORDER BY Category__r.Name asc),
                                                                                                           
                                                                                                           (SELECT Id, Name, Case__c, Account__c, Benefit_Agreement__c, Group_Section__c, Group_Section__r.id, 
                                                                                                            Group_Section__r.Name, Group_Section__r.Group_No__c, Group_Section__r.Section_No__c,  Group_Section__r.Account__c,
                                                                                                            Group_Section__r.Section_Description__c, Group_Section__r.Section_Eff_Date__c, Group_Section__r.Section_Can_Date__c,Group_Section__r.IsNew__c,
                                                                                                            Group_Section__r.SPI_Codes__c, Group_Section__r.Par_Plan_Codes__c, Group_Section__r.Alpha_Prefix__c, Group_Section__r.Billing_Assoc__c // SFDC-6942 added Billing_Assoc__c
                                                                                                            FROM BA_Assignments__r),
                                                                                                           
                                                                                                           (SELECT Id, Name, Benefit_Agreement__c, Billing_Profile__c, Billing_Profile__r.id, Billing_Profile__r.Name, 
                                                                                                            Billing_Profile__r.Billing_Profile_Number__c, Billing_Profile__r.Effective_Date__c,  Billing_Profile__r.IsNew__c                                                                    
                                                                                                            FROM BA_Associations__r)
                                                                                                           
                                                                                                           FROM GEMS_Benefit_Agreement__c
                                                                                                           WHERE AccountStructureCase__c = : caseId AND IsCancelled__c = false AND Has_Group_Sections__c = true
                                                                                                           ORDER BY Name ASC
                                                                                                           Limit : limitSize1 
                                                                                                           OFFSET : offsetSize1]);
        
        return mapBAsCatsGSsLimited;
    }
      
    public List<SelectOption> getGroupNumbers(string groupNumbers){
        //Get all Group Numbers
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None', '--None--'));
        List<String> listOfGroupNos = new list<String>();
        
        //To get the list of available Group Numbers    
        if (groupNumbers != Null){
            listOfGroupNos = groupNumbers.deleteWhitespace().split(';');
        }
        
        for(String GroupNo : listOfGroupNos) {
            options.add(new SelectOption(GroupNo, GroupNo));
        }   
        
        return options;
        
    }
    
    public static list<GEMS_Characteristic_Value__c> getCharValues(id caseId){
        list<GEMS_Characteristic_Value__c> CharValues = [SELECT Id,Char_Code__c, Characteristic__r.Name, Characteristic__r.Comments__c, Characteristic__r.Effective_Date__c, 
                                                         Characteristic__r.Corp_Characteristic_Code__r.Name,  Characteristic__r.End_Date__c, Characteristic__r.Usage__c, 
                                                         Characteristic__r.Corp_Characteristic_Code__c,Characteristic__r.Id, Characteristic__r.Mandatory__c, Characteristic__r.Other__c , 
                                                         Characteristic__r.Reporting__c, Characteristic__r.Product__c , Characteristic__r.Mailing__c , Characteristic__r.Billing__c, 
                                                         Code__c, Name, (SELECT Id, Category__r.Id FROM GEMS_Cat_Char_Value_Associations__r)
                                                         FROM GEMS_Characteristic_Value__c WHERE Case__c =: caseId];
        return CharValues;    
    }
    
    public static map<Id, list<GEMS_Characteristic_Value__c>> getMapCharValues(id caseId, set<Id> catIds){                
        
        list<GEMS_Characteristic_Value__c> CharValues = [SELECT Id,Char_Code__c, Characteristic__r.Name, Characteristic__r.Comments__c, Characteristic__r.Effective_Date__c, 
                                                         Characteristic__r.Corp_Characteristic_Code__r.Name,  Characteristic__r.End_Date__c, Characteristic__r.Usage__c, 
                                                         Characteristic__r.Corp_Characteristic_Code__c,Characteristic__r.Id, Characteristic__r.Mandatory__c, Characteristic__r.Other__c , 
                                                         Characteristic__r.Reporting__c, Characteristic__r.Product__c , Characteristic__r.Mailing__c , Characteristic__r.Billing__c, 
                                                         Code__c, Name, (SELECT Id, Category__r.Id FROM GEMS_Cat_Char_Value_Associations__r WHERE Category__r.Id IN : catIds)
                                                         FROM GEMS_Characteristic_Value__c 
                                                         WHERE Case__c =: caseId 
                                                         AND ID IN (SELECT Characteristic_Value__c FROM GEMS_Cat_Char_Value_Association__c WHERE Category__r.Id IN : catIds)];
        
        map<Id, list<GEMS_Characteristic_Value__c>> mapCharValues = new  map<Id, list<GEMS_Characteristic_Value__c>>();
        
        for(GEMS_Characteristic_Value__c value : CharValues){
            for (GEMS_Cat_Char_Value_Association__c CatCharValAss : value.GEMS_Cat_Char_Value_Associations__r){
                if(mapCharValues.get(CatCharValAss.Category__c) != null) {
                    list<GEMS_Characteristic_Value__c> values = mapCharValues.get(CatCharValAss.Category__c);
                    values.add(value);
                    mapCharValues.put(CatCharValAss.Category__c, values);
                } 
                else{
                    list<GEMS_Characteristic_Value__c> values = new list<GEMS_Characteristic_Value__c>();
                    values.add(value);
                    mapCharValues.put(CatCharValAss.Category__c, values);
                }
            }
        }
        
        return mapCharValues;    
    }
    
    
    public list<GEMS_Characteristic__c> getCharacts(id CaseId) {
        return [SELECT Id, Characteristic_Code__c FROM GEMS_Characteristic__c WHERE Case__c =:caseId];
    }
    
    // private use for SaveDraft functionality for message displaying
    private String displayEmptyIfEmpty(String s){return String.isBlank(s) ? '  ' : s; }
    
    // private use for SaveDraft functionality to remove GEMS_Category_Assignment__c with empty group section object
    private list<GEMS_Category_Assignment__c> removeCategoryEmptyGroupSection(list<GEMS_Category_Assignment__c> catGSAssignmentsList){
        if(catGSAssignmentsList == null) return null;
        list<GEMS_Category_Assignment__c> tempNewList = new List<GEMS_Category_Assignment__c>();
        for(GEMS_Category_Assignment__c oneCatGSAssignments : catGSAssignmentsList ){
            if(oneCatGSAssignments.Group_Section__c != null){
                tempNewList.add(oneCatGSAssignments);
            }
        }
        return tempNewList;
    }
    
    // private use for SaveDraft functionality to remove GEMS_BA_Assignment__c with empty group section object
    private list<GEMS_BA_Assignment__c> removeBAEmptyGroupSection(list<GEMS_BA_Assignment__c> baGSAssignmentsList){
        if(baGSAssignmentsList == null) return null;
        list<GEMS_BA_Assignment__c> tempNewList = new List<GEMS_BA_Assignment__c>();
        for(GEMS_BA_Assignment__c oneBaGSAssignments : baGSAssignmentsList ){
            if(oneBaGSAssignments.Group_Section__c != null){
                tempNewList.add(oneBaGSAssignments); 
            }
        }
        return tempNewList;
    }         
    
    
    /*public Integer getrenderMe(string fundTypes){
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

}*/    
    
    
    //SFDC-3951 - ADDED HELPER METHOD TO PREVENT ACCOUNT STRUCTURE (BA,CAT,GN,SN) DUPLICATION
    public String checkAcctStrDups(GEMS_AccountSetup accStr) {
        String message = '';
        Set<GEMS_AccountSetup.AccStrUniqueCombo> accStrUniqueComboSet = new Set<GEMS_AccountSetup.AccStrUniqueCombo>();
        integer counter = 0;
        for(GEMS_AccountSetup.BenefitAgreement ba : accStr.benefitAgreements) {
            
            for(GEMS_AccountSetup.Category categoryVal : ba.categories) {
                GEMS_AccountSetup.AccStrUniqueCombo accStrUniqueCombo = new GEMS_AccountSetup.AccStrUniqueCombo();    
                accStrUniqueCombo.BAName = ba.ba.Name;
                accStrUniqueCombo.cat = categoryVal.cat.name;
                accStrUniqueCombo.groupNumber = categoryVal.GS.groupnumber;
                accStrUniqueCombo.sectionNumber = categoryVal.GS.sectionNumber;
                if( !accStrUniqueComboSet.contains(accStrUniqueCombo) || 
                   ((String.isBlank(accStrUniqueCombo.groupNumber) || accStrUniqueCombo.groupNumber == 'None') && String.isBlank(accStrUniqueCombo.sectionNumber))
                  ){//not duplicate or when empty rows
                      accStrUniqueComboSet.add(accStrUniqueCombo);
                      categoryVal.isDuplicate = false;                    
                  } else { 
                      categoryVal.isDuplicate = true;
                      message = '(BA, Category, GroupNumber, GroupSection) Combination must be unique, Duplicates highlighted';
                  }                
            }            
        }
        return message;
    }
    
    
    //SFDC-7859 GEMS: Acct Structure - Redesign of GEMS Account Structure Excel Output
    //Generate Account Structure worksheet included in Generate Account Structure
    public list<GEMS_AccountSetup.StructureWorksheet> processAccountStructureWS(GEMS_AccountSetup accountStructure) {
        list<GEMS_AccountSetup.StructureWorksheet> reportData = new list<GEMS_AccountSetup.StructureWorksheet>();
        list<GEMS_AccountSetup.BenefitAgreement> baList = accountStructure.benefitAgreements;
        Set<String> uniqueSet = new Set<String>();
        Map<String,GEMS_AccountSetup.StructureWorksheet> uniqueReportMap = new Map<String,GEMS_AccountSetup.StructureWorksheet>();
        for(GEMS_AccountSetup.BenefitAgreement ba : baList) {
            String baName = ba.ba.Name;
            String uniqueBAGNSN = baName;
            
            list<GEMS_AccountSetup.Category> catList = ba.categories;
            for(GEMS_AccountSetup.Category cat : catList) {
                String gn = cat.groupSection.Group_No__c;
                String sn = cat.groupSection.Section_No__c;
                String currentCatName = String.isNotBlank(cat.cat.name) ? cat.cat.name : ''; 
                boolean currentCatUsageBilling = cat.cat.Usage_Billing__c;  
                boolean currentCatUsageMailing = cat.cat.Usage_Mailing__c;
                boolean currentCatUsageReporting = cat.cat.Usage_Reporting__c;
                boolean currentCatUsageProduct = cat.cat.Usage_Product__c;
                String currentDescription = String.isNotBlank(cat.cat.Category_Description__c) ? cat.cat.Category_Description__c : '';  
                String currentBillingProfile = String.isNotBlank(cat.bpBAAssign.Billing_Profile__r.Name) ? cat.bpBAAssign.Billing_Profile__r.Name : '';
                uniqueBAGNSN = baName + gn + sn;
                System.debug('uniqueBAGNSN '+uniqueBAGNSN);
               
                if(uniqueSet.contains(uniqueBAGNSN)) {
                    System.debug('Unique uniqueBAGNSN '+uniqueBAGNSN+' Found');
                    GEMS_AccountSetup.StructureWorksheet existingReport = uniqueReportMap.get(uniqueBAGNSN);
                    String appendCat = ',' + currentCatName;
                    String appendDesc = ',' + currentDescription;
                    if(currentCatUsageBilling && currentCatName != '' && !existingReport.catBillingNumber.contains(currentCatName) ) {
                        existingReport.catBillingNumber += String.isNotBlank(existingReport.catBillingNumber)? appendCat:currentCatName;
                        existingReport.catBillingDescription += String.isNotBlank(existingReport.catBillingDescription)? appendDesc : currentDescription;
                    } 
                    if(currentCatUsageMailing && currentCatName != '' && !existingReport.catMailingNumber.contains(currentCatName)) {
                        existingReport.catMailingNumber += String.isNotBlank(existingReport.catMailingNumber)? appendCat:currentCatName;
                        existingReport.catMailingDescription += String.isNotBlank(existingReport.catMailingDescription)? appendDesc : currentDescription;
                    } 
                    if(currentCatUsageReporting && currentCatName != '' && !existingReport.catReportingNumber.contains(currentCatName)) {
                        existingReport.catReportingNumber += String.isNotBlank(existingReport.catReportingNumber)? appendCat:currentCatName;
                        existingReport.catReportingDescription += String.isNotBlank(existingReport.catReportingDescription)? appendDesc : currentDescription;
                    } 
                    if(currentCatUsageProduct && currentCatName != ''  && !existingReport.catProductNumber.contains(currentCatName)) {
                        existingReport.catProductNumber += String.isNotBlank(existingReport.catProductNumber)? appendCat:currentCatName;
                        existingReport.catProductDescription += String.isNotBlank(existingReport.catProductDescription)? appendDesc : currentDescription;
                    } 
                    
                } else {
                    uniqueSet.add(uniqueBAGNSN);
                    GEMS_AccountSetup.StructureWorksheet newReport = new  GEMS_AccountSetup.StructureWorksheet();
                    newReport.baName = ba.ba.Name;
                    newReport.baProduct = ba.ba.Plan__r.Name;
                    newReport.baProductCode = ba.ba.Product__r.ProductCode; //SFDC-9952
                    newReport.baDescription = ba.ba.BA_Description__c;
                    newReport.baFundType = ba.ba.BA_Fund_Type__c;
                    newReport.catBillingNumber = currentCatUsageBilling ? currentCatName:'';
                    newReport.catBillingDescription = currentCatUsageBilling ? currentDescription: '';
                    newReport.catMailingNumber = currentCatUsageMailing ? currentCatName:'';
                    newReport.catMailingDescription = currentCatUsageMailing ? currentDescription: '';
                    newReport.catReportingNumber = currentCatUsageReporting ? currentCatName:'';
                    newReport.catReportingDescription = currentCatUsageReporting ? currentDescription: '';
                    newReport.catProductNumber = currentCatUsageProduct ? currentCatName:'';
                    newReport.catProductDescription = currentCatUsageProduct ? currentDescription: '';
                    newReport.groupNumber = cat.groupSection.Group_No__c;
                    newReport.sectionNumber = cat.groupSection.Section_No__c;
                    newReport.sectionDesc = cat.groupSection.Section_Description__c;
                    newReport.sEffDate = cat.groupSection.Section_Eff_Date__c;
                    newReport.sCanDate = cat.groupSection.Section_Can_Date__c;
                    newReport.billingProfile = cat.bpBAAssign.Billing_Profile__r.Name;
                    newReport.billingAssociation = cat.groupSection.Billing_Assoc__c;  // SFDC-6942
                    newReport.alphaPrefix = cat.groupSection.Alpha_Prefix__c;
                    newReport.idCardType = ba.ba.ID_Card_Type__c;
                    newReport.spiCodes = cat.groupSection.SPI_Codes__c;
                    newReport.parPlanCodes = cat.groupSection.Par_Plan_Codes__c;
                    uniqueReportMap.put(uniqueBAGNSN, newReport);
                }
            }
        }
        
        for(String bagnsn : uniqueSet) {
            reportData.add(uniqueReportMap.get(bagnsn));
        }
       
      
        return reportData;   
    }
    
    
}