public class GEMS_CaseTriggerAccountStructureHandler {
    
    public static void getContactFromAccount(List<Case> listOfCases){
        
        Map<ID,Schema.RecordTypeInfo> rt_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();

        for(Case c : listOfCases){
            
          if(rt_map.get(c.recordTypeID).getName().containsIgnoreCase('GEMS Account Structure')){
              
              Case ThisCase = [SELECT Id, AccountId FROM Case WHERE Id =:c.Id];
              
              //Pulling Contact From Account
              List<Contact> listOfContacts = [SELECT Id, Type__c FROM Contact WHERE Account.Id =: ThisCase.AccountId];
              Integer sizeOfList = listOfContacts.size();
              if(sizeOfList>0){
                  if (sizeOfList==1){
                      if(listOfContacts[0].Type__c == 'Billing' || listOfContacts[0].Type__c == 'Mailing' || listOfContacts[0].Type__c == 'Primary'){
                         ThisCase.ContactId = listOfContacts[0].Id; 
                      }
                  }
                  else{
                      Integer flag = 0;
                      for(Contact Con : listOfContacts){
                          if (Con.Type__c == 'Billing'){
                            ThisCase.ContactId = Con.Id;
                            flag = 1;
                            break;
                          }
                      }
                      if (flag!=1){
                          for(Contact Con : listOfContacts){
                            if (Con.Type__c == 'Primary'){
                                ThisCase.ContactId = Con.Id;
                                flag = 1;
                                break;
                            }
                          }
                      }
                      if (flag!=1){
                          for(Contact Con : listOfContacts){
                            if (Con.Type__c == 'Mailing'){
                                ThisCase.ContactId = Con.Id;
                                flag = 1;
                                break;
                            }
                          }
                      }
                  }
                  update ThisCase;
              }
          }
       
        }               
    }
    public static void CreateBA_GS_Cat_Assignments(List<Case> listOfCases){

    Map<ID,Schema.RecordTypeInfo> rt_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();
    List<Opportunity_Product__c> OppPro;
    Plan__c OppPlan;
    List<GEMS_Benefit_Agreement__c> BAs;
    List<GEMS_Category__c> Cats;
    List<GEMS_Group_Section__c> GrpSections;
    List<Group_Section__c> CRM_GrpSections = new List<Group_Section__c>();
    List<Benefit_Agreement__c> CRM_BAs = new List<Benefit_Agreement__c>();
    list<BA_GS_Assignment__c> CRM_BA_GrpSections;
    list<GEMS_BA_Assignment__c> BA_GrpSections;
    Account Act;
        
        for(Case c : listOfCases){
            
          if(rt_map.get(c.recordTypeID).getName().containsIgnoreCase('GEMS Account Structure')){
              
              Case ThisCase = [SELECT Id, AccountId,
                               (SELECT Id, Name FROM GEMS_Benefit_Agreements__r),
                               (SELECT Id, Name FROM GEMS_Categories__r),
                               (SELECT Id, Name FROM Group_Sections__r)
                               FROM Case WHERE Id =:c.Id];
              

              if (c.GEMS_Submission_Type__c == 'New Account'){
                  
                  //Benefit Agreements
                  If (c.OpportunityID__c != null){
                      BAs = ThisCase.GEMS_Benefit_Agreements__r;
                      System.debug('Benefit Agreement is '+BAs);
                      if (BAs.size()==0){
                          // SFDC-5071. Added Effective_Date__c field
                          OppPro = [SELECT Id, Name, Effective_Date__c, Product__r.Id, Funding_Type__c FROM Opportunity_Product__c WHERE Opportunity_Name__c =: c.OpportunityId__c];
                         
                          System.debug('opp product is '+OppPro);  
                          
                          Integer count = 1;
                          for (Opportunity_Product__c Pro : OppPro ){
                                  GEMS_Benefit_Agreement__c BA = new GEMS_Benefit_Agreement__c();
                                  BA.Account__c = c.AccountId;
                                  BA.AccountStructureCase__c = c.Id;
                                  BA.Product__c = Pro.Product__r.Id;                              
                                  BA.BA_Fund_Type__c = Pro.Funding_Type__c;
                                  // SFDC-5071. Set Opportunity's effective date to BA's effective date
                                  BA.Effective_Date__c = Pro.Effective_Date__c;
                              if (Count > 99){ 
                                  BA.Name = '0' + count;
                              }
                              else if (Count > 9){
                                  BA.Name = '00' + count;
                              }
                              else{
                                  BA.Name = '000' + count;
                              }
                                  
                                  BAs.add(BA);
                              count = count +1;
                                   }
                             insert BAs;
                            }
                      
                        }
                  /*
                  //Categories
                  Cats = ThisCase.GEMS_Categories__r;
                                      if (Cats.size()==0 && c.GEMS_Enter_number_of_categories__c!= Null){
                          Integer NumberOfCategories = Integer.valueOf(c.GEMS_Enter_number_of_categories__c);
                          Integer count = 1;
                          while (count <=  NumberOfCategories){
                                  GEMS_Category__c Cat = new GEMS_Category__c();
                                  Cat.Account__c = c.AccountId;
                                  Cat.Case__c = c.Id;
                              if (Count > 99){
                                  Cat.Name = '0' + count;
                              }
                              else if (Count > 9){
                                  Cat.Name = '00' + count;
                              }
                              else{
                                  Cat.Name = '000' + count;
                              }
                                  
                                  Cats.add(Cat);
                              count = count +1;
                                   }
                             insert Cats;
                            }
                  
                  //Group Sections
                  GrpSections = ThisCase.Group_Sections__r;
                  if (GrpSections.size()==0 && c.GEMS_Enter_the_number_of_Group_Sections__c != Null){
                          Integer NumberOfGroupSections = Integer.valueOf(c.GEMS_Enter_the_number_of_Group_Sections__c);
                          Integer count = 1;
                          while (count <=  NumberOfGroupSections){
                                  GEMS_Group_Section__c GrpSection = new GEMS_Group_Section__c();
                                  GrpSection.Account__c = c.AccountId;
                                  GrpSection.Case__c = c.Id;
                              if (Count > 99){
                                  GrpSection.Section_No__c = '0' + count;
                              }
                              else if (Count > 9){
                                  GrpSection.Section_No__c = '00' + count;
                              }
                              else{
                                  GrpSection.Section_No__c = '000' + count;
                              }
                                  
                                  GrpSections.add(GrpSection);
                              count = count +1;
                          }
                             insert GrpSections;
                  }
              */

              }
              /*
              else if (c.GEMS_Submission_Type__c == 'Renewal') {
                  Act = [SELECT Name, 
                         (SELECT Id, Name, Funding_Type__c, Plan__c, Product__r.Id, Description__c, Product_Category__c, 
                          Effective_Date__c FROM Benefit_Agreements__r),
                         (SELECT Id, Name, Group_Number__c, Section_Number__c, Effective_Date__c  FROM Group_Sections__r)
                         FROM Account WHERE Id =: ThisCase.AccountId];
                  Date CurrentDay = Date.TODAY(); 
                  
                  //Benefit Agreements
                  try{       
                      for (Benefit_Agreement__c CRM_BA : Act.Benefit_Agreements__r ){
                      if(CRM_BA.Effective_Date__c != Null){
                      Date EffectiveDate = Date.valueOf(CRM_BA.Effective_Date__c);
                      If(EffectiveDate.year() == CurrentDay.year()-1){
                          CRM_BAs.add(CRM_BA);
                      }
                          
                      }

                  }      
                  //CRM_BAs = Act.Benefit_Agreements__r;
                  System.debug('BAs from CRM - ' + CRM_BAs);
                  BAs = new list<GEMS_Benefit_Agreement__c>();
                  if (CRM_BAs != Null && !CRM_BAs.isEmpty()){
                      for (Benefit_Agreement__c CRM_BA : CRM_BAs ){
                          GEMS_Benefit_Agreement__c BA = new GEMS_Benefit_Agreement__c();
                          BA.AccountStructureCase__c = ThisCase.Id;
                          BA.Account__c = Act.Id;
                          BA.BA_Description__c = CRM_BA.Description__c;
                          BA.BA_Fund_Type__c = CRM_BA.Funding_Type__c ;
                          BA.Plan__c = CRM_BA.Plan__c ;
                          BA.Product__c = CRM_BA.Product__r.Id ;
                          BA.Name = CRM_BA.Name;
                          BAs.add(BA);
                      }
                      System.debug('New BAs - ' + BAs);
                      insert BAs;
                  }
                  
                  }
                  catch(Exception ex){
                      CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'opportunity', null, 'AddOpportunityProductsController.removeRow()','High'); 
                  }

                  try{
                       //Group Sections
                  for (Group_Section__c CRM_GS : Act.Group_Sections__r ){
                      if (CRM_GS.Effective_Date__c != Null){
                      Date EffectiveDate = Date.valueOf(CRM_GS.Effective_Date__c);
                      If(EffectiveDate.year() == CurrentDay.year()-1){
                          CRM_GrpSections.add(CRM_GS);
                      }
                          
                      }

                  }  
                  //CRM_GrpSections = Act.Group_Sections__r;
                  System.debug('Group Sections from CRM - ' + CRM_GrpSections);
                  GrpSections = new list <GEMS_Group_Section__c>();
                  if (CRM_GrpSections != Null && !CRM_GrpSections.isEmpty()){
                      for(Group_Section__c CRM_GS : CRM_GrpSections){
                          GEMS_Group_Section__c GS = new GEMS_Group_Section__c();
                          GS.Case__c = ThisCase.Id;
                          GS.Account__c = Act.Id;
                          GS.Group_No__c = CRM_GS.Group_Number__c;
                          GS.Section_No__c = CRM_GS.Section_Number__c;
                          GrpSections.add(GS);
                      }
                      System.debug('New Gorup Sections - ' + GrpSections);
                      insert GrpSections;
                  }
                  
                  }
                  catch(Exception ex){
                      CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'opportunity', null, 'AddOpportunityProductsController.removeRow()','High'); 
                  }

                  try{//Group Section - BA Assignment
                  CRM_BA_GrpSections = [SELECT Id, Name FROM BA_GS_Assignment__c WHERE Group_Section__c IN : CRM_GrpSections];
                  BA_GrpSections = new list<GEMS_BA_Assignment__c>();
                  if (CRM_BA_GrpSections != Null){
                      for(BA_GS_Assignment__c CRM_BA_GS : CRM_BA_GrpSections){
                          GEMS_BA_Assignment__c BA_GS = new GEMS_BA_Assignment__c();
                          BA_GS.Case__c = ThisCase.Id;
                          BA_GS.Account__c = Act.Id;
                          //BA_GS.Benefit_Agreement__c = [SELECT Id FROM GEMS_Benefit_Agreement__c WHERE Name =:  ];
                          //BA_GS.Group_Section__c = [];
                          BA_GrpSections.add(BA_GS);
                      }
                      insert BA_GrpSections;
                  }
           
                      
                  }
                  catch(Exception ex){
                      CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'opportunity', null, 'GEMS_CaseTriggerAccountStructureHandler.removeRow()','High'); 
                  }
                  
              }
              */
          }
    }
}
}