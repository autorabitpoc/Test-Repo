public with sharing class GEMS_GenerateAccountStructureController {
    
    public list<GEMS_BA_Assignment__c> GS_BA_Associations{get; set;}
    public list<GEMS_Category_Assignment__c> GS_Cat_Associations{get; set;}
    public Id caseId;
    public list<Integer> listOfCount = new list<Integer>();
    public Set<Id> GSSet = new Set<Id>();
    public Set<Id> GS_Cat_Set = new Set<Id>();
    public Integer size;
    public Integer count;
    public Integer index;
    public list<list<Id>> listOfCategories = new list<list<Id>>();
    public list<Id> CategoriesThisGS;
    public list<Id> Combination;
    public list<list<Id>> listOfAllCombinations = new list<list<Id>>();
    public list<Id> BAThisGS;
    public list<list<Id>> listofBAs = new list<list<Id>>();
    public list<GEMS_Group_Section__c> AllGroupSections = new list<GEMS_Group_Section__c>();
    public list<GEMS_Category__c> AllCategories= new list<GEMS_Category__c>();
    public list<GEMS_Benefit_Agreement__c> AllBenefitAgreements = new list<GEMS_Benefit_Agreement__c>();
    public list<GEMS_Group_Section__c> FinalGroupSections;
    public list<GEMS_Benefit_Agreement__c> FinalBenefitAgreements;
    public list<GEMS_Category__c> FinalCategories;
    public Map<Id, GEMS_Group_Section__c> GSMap = new Map<Id,GEMS_Group_Section__c>();
    public Map<Id, GEMS_Category__c> CatMap = new Map<Id,GEMS_Category__c>();
    public Map<Id, GEMS_Benefit_Agreement__c> BAMap = new Map<Id,GEMS_Benefit_Agreement__c>();
    public Id GS;
    
    
    public GEMS_GenerateAccountStructureController() {
       try{
        caseId = ApexPages.currentPage().getParameters().get('caseId');
        GS_BA_Associations = getGS_BA_Associations();
        GS_Cat_Associations = getGS_Cat_Associations();
        CalculateAssociations();
        GetlistofAllCombinations();
        System.debug('size of list' + listOfAllCombinations.size() );
        System.debug('All combinations'+listOfAllCombinations);
        GetAllObjects();
        System.debug('ALL BAs Are ' + AllBenefitAgreements);
        System.debug('Map of BAs is '+BAMap);
        System.debug('Final BA is '+FinalBenefitAgreements);
        System.debug('Final Cat is '+FinalCategories);
        System.debug('Final GS is '+FinalGroupSections);
       } catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'GEMS_Benefit_Agreement__c', null, 'GEMS_GenerateAccountStructureController()','High');              
      }
        
    }
    
    public PageReference GenerateDocument(){
    return new PageReference('/apex/GEMSAccountStructureDocument');
    }
    
    public PageReference NavigateBack(){
    return new PageReference('/'+caseId);
    }
    
    public void GetAllObjects(){
        try {
            AllGroupSections = [SELECT Id, Name, Group_no__c, Section_Description__c, Section_No__c FROM GEMS_Group_Section__c WHERE Case__c =: caseId ORDER BY Section_No__c ASC];
            AllCategories = [SELECT Id, Name, Category_Description__c, Usage_Billing__c, Usage_Mailing__c, Usage_Product__c, Usage_Reporting__c FROM GEMS_Category__c WHERE Case__c =: caseId ORDER BY Name ASC];
            AllBenefitAgreements = [SELECT Id, Name, product__r.name, BA_Fund_Type__c, BA_Description__c FROM GEMS_Benefit_Agreement__c WHERE AccountStructureCase__c =: caseId ORDER BY Name ASC];

        for(GEMS_Benefit_Agreement__c BA: AllBenefitAgreements){
            BAMap.put(BA.Id, BA);
        }
                for(GEMS_Category__c Cat: AllCategories){
            CatMap.put(Cat.Id, Cat);
        }
                for(GEMS_Group_Section__c GS: AllGroupSections){
            GSMap.put(GS.Id, GS);
        }
       }catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'GEMS_Benefit_Agreement__c', null, 'GEMS_GenerateAccountStructureController.getAllObjects()','High');              
      }
    }
    
    public List<Integer> iter {
    get {
    list<Integer> iter = new list<Integer>();
    count = 0;
    while (count<listOfAllCombinations.size()){
        iter.add(count);
        count= count + 1;
        }
        return iter;
    }
    set;
}

    public List<GEMS_Benefit_Agreement__c> getFinalBenefitAgreements() {
        FinalBenefitAgreements = new list<GEMS_Benefit_Agreement__c>(); 
       try {  
        for(list<Id> Combination : listOfAllCombinations){   
             FinalBenefitAgreements.add(BAMap.get(Combination[2]));
        }
       }catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'GEMS_Benefit_Agreement__c', null, 'GEMS_GenerateAccountStructureController.getFinalBenefitAgreements()','High');              
      }
        return FinalBenefitAgreements;
    }
    
        public List<GEMS_Category__c> getFinalCategories() {
            FinalCategories = new list<GEMS_Category__c>();
            try {   
                 for(list<Id> Combination : listOfAllCombinations){   
             
             FinalCategories.add(CatMap.get(Combination[1]));
             
        }
        } catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'GEMS_Benefit_Agreement__c', null, 'GEMS_GenerateAccountStructureController.getFinalCategories()','High');              
      }
            return FinalCategories;
    }
    
        public List<GEMS_Group_Section__c> getFinalGroupSections(){
         FinalGroupSections = new list<GEMS_Group_Section__c>();
         try {   
                 for(list<Id> Combination : listOfAllCombinations){   
             FinalGroupSections.add(GSMap.get(Combination[0]));
            }
        }catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'GEMS_Benefit_Agreement__c', null, 'GEMS_GenerateAccountStructureController.getFinalGroupSections()','High');              
        }
            return FinalGroupSections;
    }


    public list<list<Id>> GetlistofAllCombinations(){
        count = 0;
        /*
        list<Id> listofGS = new list<Id>();
        for (Id GS: GSSet){
        listofGS.add(GS);
        }
        for(list<Id> BAs: listOfBAs){
        list<Id> Cats = new list<Id>();
        Cats = listofCategories.get(count);
        GS = listofGS.get(count);
        for (Id BA: BAs){
        for(Id Cat: Cats){
                               Combination = new list<Id>{GS,Cat,BA}; 
                        listOfAllCombinations.add(Combination);   
        }
        }
        count = count +1;
        }
        */
       try {
        for(Id GS: GSSet) {
            list<Id> Cats = new list<Id>();
            Cats = listofCategories.get(count);
            list<Id> BAs = new list<Id>();
            BAs = listOfBAs.get(count);
            for (Id Cat:Cats){
                for(Id BA: BAs){
                        Combination = new list<Id>{GS,Cat,BA}; 
                        listOfAllCombinations.add(Combination);                      
                    }
            }

            count = count +1;
        }
       }catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'GEMS_Benefit_Agreement__c', null, 'GEMS_GenerateAccountStructureController.GetlistofAllCombinations()','High');              
       }
        return listofAllCombinations;
    }
    
    public void CalculateAssociations(){
        index = 0;
        size = 0;
        BAThisGS = new list<Id>();
       try {
        for (GEMS_Category_Assignment__c GS_Cat: GS_Cat_Associations){
        GS_Cat_Set.add(GS_Cat.Group_Section__c);
        }
        for (GEMS_BA_Assignment__c GS_BA: GS_BA_Associations){
            System.debug('line 159');
            count = 0;
            size = size +1;
            CategoriesThisGS = new list<Id>();
            if ((GS_Cat_Set.contains(GS_BA.Group_Section__c))==True){
                System.debug('line 165');
                if((GSSet.contains(GS_BA.Group_Section__c))==False) {
                    System.debug('line 157');
                    GSSet.add(GS_BA.Group_Section__c);
                    if (BAThisGS.size() > 0){
                        System.debug('line 170');
                        listOfBAs.add(BAThisGS);
                        BAThisGS = new list<Id>();
                        BAThisGS.add(GS_BA.Benefit_Agreement__c);
                    }
                    else{
                        BAThisGS.add(GS_BA.Benefit_Agreement__c);
                    }
                    for (GEMS_Category_Assignment__c GS_Cat: GS_Cat_Associations){
                        if (GS_BA.Group_Section__c == GS_Cat.Group_Section__c ){
                            System.debug('line 181');
                            //listOfCategories.add(index, GS_Cat.Category__c);
                            System.debug('Index is ' + index);
                            CategoriesThisGS.add(GS_Cat.Category__c);
                            count = count +1;
                        }
                    }
                    
                    if (count != Null && count >= 1){
                        try{
                            System.debug('line 191');
                            System.debug('BA per GS is '+BAThisGS);
                            listOfCount.add(count);
                            index = index + 1;
                            listOfCategories.add(CategoriesThisGS);
                        }
                        catch(Exception e){
                            System.debug('still getting a null pointer exception');
                        }
                    }
                }
                else {
                    if (size == GS_BA_Associations.size()){
                        System.debug('line 204');
                        BAThisGS.add(GS_BA.Benefit_Agreement__c);
                        listOfBAs.add(BAThisGS);
                    }
                    else {
                        System.debug('line 209');
                        BAThisGS.add(GS_BA.Benefit_Agreement__c); 
                    }
                }
            }
            else {
                System.debug('line 217');
                listOfBAs.add(BAThisGS);
            }
        }
        System.debug('list of counts is '+ listOfCount);
        System.debug('set of Group sections ' + GSSet);
        System.debug('list of Categories is '+ listOfCategories);
        System.debug('list of BAs is '+ listOfBAs);
        System.debug('size is '+size);
        System.debug('BA per GS is '+BAThisGs);
       }catch(Exception ex){
            CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'GEMS_Benefit_Agreement__c', null, 'GEMS_GenerateAccountStructureController.CalculateAssociations()','High');              
      }
        
    }
    
    public list <GEMS_BA_Assignment__c> getGS_BA_Associations(){
        
        return [SELECT Id, Name, Benefit_Agreement__c, Group_Section__c FROM GEMS_BA_Assignment__c WHERE Case__c =: caseId];
    }
    
    public list<GEMS_Category_Assignment__c> getGS_Cat_Associations(){
        return [SELECT Id, Name, Category__c, Group_Section__c FROM GEMS_Category_Assignment__c WHERE Case__c =: caseId];
    }
}