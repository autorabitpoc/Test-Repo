//*************************************************************************************
// Name             : SGR_GSPS_GetAvailablePlanServiceHelper.cls
// Description      : Callout for Get All Available Plans GSPS Service
// Created By       : Shankar
// Created Date     : 10/29/2018
// 
// ************************Version Updates********************************************
// Date             Developer           Description
// -----------------------------------------------------------------------------------
// 10/29/2018   Shankar     SFDC 14001, SFDC-14002 Initial version
// 11/10/2018	Luke Chen	SFDC-14006 SGR - GSPS : Get Mapped Plans - Build Response Post processing code
// 11/12/2018	Shankar		SFDC-14813 Changes to reflect data model updates
// 11/14/2018   Luke Chen	SFDC-14978 SGR - GSPS : Get All Available Plans - Post Processing : Update code to Plan__c Object
// 11/14/2018	Shankar		SFDC-14813 Changes to log integration status log upon completion
// 11/15/2018	Shankar		SFDC-14813 Plan external ID changes
// 11/15/2018	Shankar		SFDC-14813 Changes to log integration status log upon completion
// 11/15/2018	Mei Chen	SFDC-15014 Integration log changes
// 11/16/2018	Shankar		SFDC-14813 Some more data schema changes
// 11/16/2018	Shankar		SFDC-14813 Changes to Name field in plan group to ensure uniqueness across network
// 11/25/2018	Mei Chen	SFDC-14003 Changes to accomodate batch functionality
// 11/27/2018	Shankar		SFDC-14813 Set Plan__c.Marketing_Plan_Number__c with name from GSPS
// 11/28/2018	Shankar		SFDC-14813 Changes to insert Plan_Fips_Map records
// 11/30/2018   Mei Chen	SFDC-14003 & 15385 updated the code to buldified the data after all calls per fips code
// 12/10/2018   Mei Chen    SFDC-15488 updated code to catpure mapped Plan.
// 1/11/2019    Mei Chen    update code to add effectivedata mmddyyyy as part of key for Plan FiPS Map table
// ************************************************************************************
public class SGR_GSPS_GetAvailablePlanServiceHelper { 
    private static Id gspsProduct2TypeId =Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('HCSC_Non_BlueStar_Product').getRecordTypeId();// HCSC_Non_BlueStar_Product;
    private final static String getAllPlanCallout='GSPS_AllPlanCallOut';
    private static Integration_Log_Switcher__c allPlanLog=Integration_Log_Switcher__c.getInstance('GSPS All Plan Service');
    private static list<FW_Service_Status_Log__c> intLoglist=new list<FW_Service_Status_Log__c>();
    private static list<SGR_Note__c> allBHNotes=new list<SGR_Note__c>();
    private static boolean updateAccessToken=false;
    private static string newAccessToken=null;
    private static APIJwtOAuthUtility oAuthUtil;
    private static Date effDateAtRun=null;
    
    /**
**@ Mei Chen
** This method is called from the getAvailablePlanFortedBatch
**/
    
    public static String callGetAvailablePlansService (String fipsCode,  Date effectiveDate, String stateCode, 
                                                       String marketSegment, String fundingType, String clientId, Integer version)
    {
        
        effDateAtRun=effectiveDate;
        String callOutResult='Success';
        system.debug('effDateAtRun:::'+effDateAtRun);     
        list<Product2> allProdList=new list<Product2>();
        list<Plan__c> allPlansList=new list<Plan__c>();
        list<Benefit_Header_Detail__c> allBFHDetailList=new  list<Benefit_Header_Detail__c>();
        list<Benefit_Header__c> allBFHeadersList=new  list<Benefit_Header__c>();
        list<SGR_Note_Detail__c> allNoteDetailList=new list<SGR_Note_Detail__c>();
        list<SGR_Note__c>allNotesList=new list<SGR_Note__c>();
        list<SGR_Plan_FIPS_Map__c> allPlanFipsList=new list<SGR_Plan_FIPS_Map__c> ();
        list<Plan_Note_Association__c> allPlanNoteAssignList=new list<Plan_Note_Association__c>();
        list<Benefit_Header_Detail_Association__c> allBHDAssignList=new list<Benefit_Header_Detail_Association__c>();
        list<Benefit_Header_Association__c>allBenefitHeaderAssoList=new list<Benefit_Header_Association__c>();
        list<Product_Note_Detail_Association__c> allProdNoteDetailAssoList=new list<Product_Note_Detail_Association__c>();
        
        
        String newAccessToken=null;
        DateTime lastTokenUpdateDateTime=null;
        list<FW_Service_Status_Log__c> intLogsList=new list<FW_Service_Status_Log__c>();
        
        Map<String, product2> allProdMap=new Map<String, product2>();
        Map<String, plan__c>allPlanMap=new Map<String, Plan__c>();
        Map<String,Benefit_Header_Detail_Association__c> allBHDAssignMap=new Map<String,Benefit_Header_Detail_Association__c>();
        Map<String,Plan_Note_Association__c> allPlanNoteAssignMap=new Map<String, Plan_Note_Association__c>();
        
        try{
            SGR_GSPS_GetAvailablePlanUpdateData allPlanData=new SGR_GSPS_GetAvailablePlanUpdateData();
            integer ct=0;
            
            list<SGR_Product_Group__c> productGroupList=[select id,SGR_Product_Group_Code__c from SGR_Product_Group__c  where SGR_Division__c=:stateCode];
            
            Map<String, SGR_Product_Group__c> prodGroupIdMap=new Map<String,SGR_Product_Group__c>();
            
            if(productGroupList!=null && !productGroupList.isEmpty()){
                for(SGR_Product_Group__c spg: productGroupList )
                {
                    prodGroupIdMap.put(spg.SGR_Product_Group_Code__c, spg);
                }
            }
            
            for(SGR_Product_Group__c prodGroupData:prodGroupIdMap.values()){
                
                system.debug('call WS with prod Group Code::'+prodGroupData.SGR_Product_Group_Code__c+ 'id =>'+prodGroupData.id);
                
                if(prodGroupData!=NULL && prodGroupData.SGR_Product_Group_Code__c!=null && (prodGroupData.SGR_Product_Group_Code__c.endsWith('HDL') || prodGroupData.SGR_Product_Group_Code__c.endsWith('IN_HDL'))){
                    allPlanData = getAvailablePlans( newAccessToken, 
                                                    lastTokenUpdateDateTime,
                                                    prodGroupData.SGR_Product_Group_Code__c,
                                                    prodGroupData.Id, 
                                                    effectiveDate,
                                                    stateCode,
                                                    marketSegment,
                                                    fundingType,
                                                    clientId,
                                                    fipsCode,//list of fipscode
                                                    version);
                    
                    system.debug('result with fipsCode:::'+fipsCode+'->'+allPlanData);
                    
                    if(allPlanData!=null){
                        newAccessToken=allPlanData.newAccessToken;
                        lastTokenUpdateDateTime=allPlanData.lastTokenUpdateDateTime;
                        system.debug('new access token from previous call:'+newAccessToken);
                        //add each Prod datas to list
                        
                        if(allPlanData.allProductList!=null && !allPlanData.allProductList.isEmpty()){
                            allProdList.addAll(allPlanData.allProductList);
                            
                        }
                        
                        if(allPlanData.allPlanList!=null && !allPlanData.allPlanList.isEmpty()){
                            
                            for(Plan__c plan:allPlanData.allPlanList){
                                
                                plan.Product_Group__c=prodGroupData.Id;
                                plan.Product_Group_Codes__c=prodGroupData.SGR_Product_Group_Code__c;
                                allPlanMap.put(plan.Marketing_Plan_Number__c, plan);//  use map to remember whole list of prods for insert plan
                            }
                            
                        }
                        if(allPlanData.allBHDAssignList!=null && !allPlanData.allBHDAssignList.isEmpty()){
                            allBHDAssignList.addAll(allPlanData.allBHDAssignList);
                        }
                        
                        if(allPlanData.allPlanNoteAssignList!=null && !allPlanData.allPlanNoteAssignList.isEmpty() ){
                            allPlanNoteAssignList.addAll(allPlanData.allPlanNoteAssignList);
                        }
                        
                        
                        if(allPlanData.allPlanFipsList!=null && !allPlanData.allPlanFipsList.isEmpty()){
                            allPlanFipsList.addAll(allPlanData.allPlanFipsList);
                        }
                        if(allPlanData.allBenefitHeaderDetailList!=null && !allPlanData.allBenefitHeaderDetailList.isEmpty()){
                            allBFHDetailList.addAll(allPlanData.allBenefitHeaderDetailList);
                        }
                        if(allPlanData.allNoteList!=null && !allPlanData.allNoteList.isEmpty()){
                            allNotesList.addAll(allPlanData.allNoteList);
                        }
                        if(allPlanData.allBenefitHeaderList !=null && !allPlanData.allBenefitHeaderList.isEmpty()){
                            allBFHeadersList.addAll(allPlanData.allBenefitHeaderList);
                            system.debug('allBFHeadersList from product group '+prodGroupData.SGR_Product_Group_Code__c+' is ' +allBFHeadersList.size());
                        }
                        if(allPlanData.allNoteDetailList!=null && !allPlanData.allNoteDetailList.isEmpty() ){
                            allNoteDetailList.addAll(allPlanData.allNoteDetailList);
                        }
                        
                        if(allPlanData.allBenefitHeaderAssoList!=null && !allPlanData.allBenefitHeaderAssoList.isEmpty()){
                            allBenefitHeaderAssoList.addAll(allPlanData.allBenefitHeaderAssoList);
                        }
                        
                        if(allPlanData.allProductNoteDetailAssoList!=null && !allPlanData.allProductNoteDetailAssoList.isEmpty()){
                            allProdNoteDetailAssoList.addAll(allPlanData.allProductNoteDetailAssoList);
                        }
                        
                        if(allPlanData.allInteLogList!=null && !allPlanData.allInteLogList.isEmpty()){
                            intLogsList.addAll(allPlanData.allInteLogList);
                        }                                                
                    }                      
                }//end IF                
            }//END FOR
            
            //find duplicate prod           
            if(allProdList!=null && !allProdList.isEmpty()){                
                for(Product2 prod:allProdList){
                    system.debug('prod Id--->'+prod.id+' external id: '+prod.External_Id__c);
                    allProdMap.put(prod.External_Id__c, prod);// use map to remember whole list of prods for insert plan
                }                
            }
            
            if(allProdMap!=null && !allProdMap.isEmpty()){
                allProdList=allProdMap.values(); //refresh list without duplicated data  
            }
            
            //find duplicate plan
            
            if(allPlanMap!=null && !allPlanMap.isEmpty()){
                allPlansList=allPlanMap.values();
            }
            
            //remove duplicate  bhd assig
            
            if(allBHDAssignList!=null && !allBHDAssignList.isEmpty()){
                for(Benefit_Header_Detail_Association__c ass:allBHDAssignList){
                    allBHDAssignMap.put(ass.name, ass);
                }
            }
            
            if(allBHDAssignMap!=null && !allBHDAssignMap.isEmpty()){
                allBHDAssignList=allBHDAssignMap.values();
            }
            
            // remove duplicate plan note assign
            if(allPlanNoteAssignList!=null && !allPlanNoteAssignList.isEmpty()){
                
                for(Plan_Note_Association__c pAss: allPlanNoteAssignList){
                    allPlanNoteAssignMap.put(pAss.name, pAss);
                }
            }
            if(allPlanNoteAssignMap!=null && !allPlanNoteAssignMap.isEmpty()){
                allPlanNoteAssignList=allPlanNoteAssignMap.values();
            }
            
            system.debug('allNotesList:::'+allNotesList.size());
            callOutResult=savePlanData(allProdList,
                                       allPlansList,
                                       allBFHDetailList,
                                       allBFHeadersList,
                                       allNotesList,
                                       allNoteDetailList,
                                       allPlanNoteAssignList,
                                       allBHDAssignList,
                                       allBenefitHeaderAssoList,
                                       allProdNoteDetailAssoList,
                                       allPlanFipsList);
            
            
        }catch (Exception e){
            
            system.debug('CallGetAvailableplan service error:'+e.getLineNumber()+' :'+e);
            callOutResult='failed: '+e.getMessage();
        }finally{
            //update the jwtTokenCustomSetting with new token 
            if(newAccessToken!=null && oAuthUtil!=null){
                oAuthUtil.UpdateToken(newAccessToken);
            }
            
            //insert integration log
            if(intLogsList!=null && !intLogsList.isEmpty()){
                try{
                    Database.SaveResult [] resultsLog = Database.insert(intLogsList, false);
                }catch (Exception e){
                    system.debug('exception threw during integration log insertion :::'+e);
                }
                
            }
        }
        return callOutResult;
    }
    
    /*
* this is method is to save the plan data from getPlan and getMappedPlan services
*/
    public static String savePlanData( list<Product2> allProdList,
                                      list<Plan__c> allPlansList,
                                      list<Benefit_Header_Detail__c> allBFHDetailList,
                                      list<Benefit_Header__c> allBFHeadersList,
                                      list<SGR_Note__c>allNotesList,
                                      list<SGR_Note_Detail__c>allNoteDetails,
                                      list<Plan_Note_Association__c> allPlanNoteAssignment,
                                      list<Benefit_Header_Detail_Association__c> allBHDAssignment,
                                      list<Benefit_Header_Association__c> allBenefitHeaderAsso,
                                      list<Product_Note_Detail_Association__c> allNoteDetailAsso,
                                      list<SGR_Plan_FIPS_Map__c> allPlanFipsList){
                                          String result='Success';
                                          Map<String, product2> allProdMap=new Map<String, product2>();
                                          Map<String, plan__c> allPlanMap=new Map<String, Plan__c>();
                                          
                                          try{
                                              
                                              system.debug('allProdList---->'+allProdList);                                              
                                              
                                              //ready to upSert
                                              if(allProdList!=null && !allProdList.isEmpty()){
                                                  
                                                  system.debug('number of prodlist to upSert: '+allProdList.size());
                                                  
                                                  for(Product2 prod:allProdList){
                                                      allProdMap.put(prod.External_ID__c, prod);
                                                  }
                                                  Schema.SObjectField prodExtId = Product2.Fields.External_ID__c;   
                                                  
                                                  Database.upSertResult [] resultsProd = Database.upsert(allProdList, prodExtId,false);   
                                                  set<Id>savedProdIds=new set<Id>();
                                                  
                                                  for (DataBase.upSertResult sr: resultsProd){
                                                      if(sr.isSuccess()){
                                                          System.debug('Successfully inserted product ID: ' + sr.getId());
                                                          savedProdIds.add(sr.getId());
                                                      }else{
                                                          for(Database.Error err : sr.getErrors()) {
                                                              System.debug('error has occurred.' + err.getStatusCode() + ': ' + err.getMessage());                    
                                                              System.debug('fields that affected this error: ' + err.getFields());
                                                          }
                                                      }
                                                  }
                                                  
                                                  System.debug('all plan list----->'+allPlansList);
                                                  //below query to retreive prod with Id
                                                  list<Product2> existingProds=[select id, External_ID__c, name, HCSC_State__c, Product_Type__c from Product2 where External_ID__c in :allProdMap.keySet()];
                                                  
                                                  Map<String,Id> prodToRefer=new Map<String, Id>();
                                                  
                                                  if(existingProds!=null && !existingProds.isEmpty()){
                                                      
                                                      for(Product2 prod:existingProds){
                                                          system.debug('existing prod after upSert -> external Id: '+prod.External_Id__c+' id:'+ prod.Id);
                                                          prodToRefer.put(prod.External_Id__c, prod.Id);
                                                      }
                                                  }
                                                  if(allPlansList!=null && !allPlansList.isEmpty()){
                                                      system.debug('number of plans to upSert:'+allPlansList.size());
                                                      
                                                      list<Plan__c> plansToUpSert=new list<Plan__c>();
                                                      
                                                      Map<String,Plan__c> allPlansMap=new Map<String, Plan__c>();
                                                      for(Plan__c pl:allPlansList){
                                                          system.debug('plan name::'+pl.Product_Name__c+' division:'+pl.Division__c);
                                                          
                                                          pl.Product__c=prodToRefer.get(pl.Product_Name__c+pl.Division__c+'SG');//assign the product reference
                                                          pl.Level_2_Product__c=prodToRefer.get(pl.Level_2_Product_Name__c+pl.Division__c+'SG');
                                                          pl.Level_1_Product__c=prodToRefer.get(pl.Level_1_Product_Name__c+pl.Division__c+'SG');
                                                          
                                                          system.debug( 'product to refer: '+pl.Product__c+' from plan :'+pl.name+' plan id: '+pl.id);
                                                          plansToUpSert.add(pl);//add to update list
                                                          
                                                          system.debug(' upSert -->plan marketing plan id::'+pl.Marketing_Plan_Number__c);
                                                          allPlansMap.put(pl.Marketing_Plan_Number__c,pl); 
                                                           }
                                                      
                                                       list<Plan__c> existingPlans=[select id,name, Level_1_Product__c,	Level_2_Product__c,Marketing_Plan_Number__c,Mapped_Plan_Name__c, MappedPlan__c,FipsCodes__c, Product_Group_Codes__c from Plan__c where Marketing_Plan_Number__c in:allPlansMap.keySet() ];
                                                      system.debug('existing plans:;;'+existingPlans);
                                                      if(existingPlans!=null && !existingPlans.isEmpty()){
                                                          
                                                          for(plan__c p: existingPlans){
                                                              plan__c upDatePlan=allPlansMap.get(p.Marketing_Plan_Number__c);
                                                              
                                                              if(p.FipsCodes__c!=null && p.FipsCodes__c!=''){
                                                                  if(upDatePlan!=null && updatePlan.FipsCodes__c!=null && !p.FipsCodes__c.contains(upDatePlan.FipsCodes__c)){
                                                                      upDatePlan.FipsCodes__c=p.FipsCodes__c+';'+upDatePlan.FipsCodes__c;//append the new fips code to current one
                                                                      system.debug('fipsCodes for '+p.Marketing_Plan_Number__c+' is '+upDatePlan.FipsCodes__c);
                                                                      }
                                                              }
                                                              if(p.Product_Group_Codes__c!=null && p.Product_Group_Codes__c!=''){
                                                                  if(updatePlan!=null && updatePlan.Product_Group_Codes__c!=null && !p.Product_Group_Codes__c.contains(updatePlan.Product_Group_Codes__c)){
                                                                      updatePlan.Product_Group_Codes__c=p.Product_Group_Codes__c+';'+updatePlan.Product_Group_Codes__c;
                                                                  }
                                                              }
                                                              allPlansMap.put(p.Marketing_Plan_Number__c, upDatePlan);
                                                          }
                                                      } 
                                                      system.debug('allPlans Map::::'+allPlanMap);
                                                      
                                                      Database.UpsertResult [] results = Database.Upsert(plansToUpSert,plan__c.field.name, false); 
                                                      
                                                      for (DataBase.UpsertResult sr: results){
                                                          if(sr.isSuccess()){
                                                              if(sr.isCreated()){
                                                                  System.debug('Successfully inserted plan ID: ' + sr.getId());
                                                              }else{
                                                                  System.debug('Successfully update plan ID: ' + sr.getId());
                                                                  
                                                              }
                                                              
                                                          }else{
                                                              for(Database.Error err : sr.getErrors()) {
                                                                  System.debug('error has occurred.' + err.getStatusCode() + ': ' + err.getMessage());                    
                                                                  System.debug('fields that affected this error: ' + err.getFields());
                                                                  
                                                              }
                                                          }
                                                      }
                                                      
                                                      list<Plan__c> existingPlansNew=[select id,name, Marketing_Plan_Number__c, Mapped_Plan_Name__c , MappedPlan__c, FipsCodes__c, Product_Group_Codes__c from Plan__c where Marketing_Plan_Number__c in:allPlansMap.keySet() ];
                                                      
                                                      system.debug('existingPlans:::'+existingPlansNew.size());
                                                      system.debug('allplan Marketing Id for benefit Header detail::'+allPlansMap.keySet());
                                                      
                                                      Map<String,Id> plansToReferMap=new Map<String, Id>();
                                                      
                                                      if(existingPlansNew!=null && !existingPlansNew.isEmpty()){
                                                          for(Plan__c pn:existingPlansNew){
                                                              system.debug('plan marketing_plan id:::'+pn.Marketing_Plan_Number__c+' plan id:'+pn.Id);
                                                              plansToReferMap.put(pn.Marketing_Plan_Number__c, pn.Id);
                                                          }
                                                          
                                                          list<Plan__c> updateMappedPlan=new list<Plan__c>();
                                                          for(Plan__c updatePlan: existingPlansNew){
                                                              if(updatePlan!=null && updatePlan.Mapped_Plan_Name__c!=null){
                                                                  
                                                                  updatePlan.MappedPlan__c=plansToReferMap.get(updatePlan.Mapped_Plan_Name__c);
                                                                  system.debug('updatePlan id: '+updatePlan.id+' has mapped '+updatePlan.MappedPlan__c);
                                                                  updateMappedPlan.add(updatePlan);
                                                              }
                                                          }
                                                          if(updateMappedPlan!=null && !updateMappedPlan.isEmpty()){
                                                              try{
                                                                  update updateMappedPlan;
                                                              }catch (System.dmlException e){
                                                                  system.debug(' exception from update Mapped plan:::'+e);
                                                              }
                                                          }
                                                      }
                                                      
                                                      //insert benefit Header----
                                                      list<Benefit_Header__c> bHeaderToUpSert=new list<Benefit_Header__c>();
                                                      Map<String,Benefit_Header__c> bhMap=new Map<String, Benefit_Header__c>();
                                                      system.debug('allBFHeadersList....'+allBFHeadersList);
                                                      
                                                      if(allBFHeadersList!=null && !allBFHeadersList.isEmpty()){
                                                          
                                                          for(Benefit_Header__c bh:allBFHeadersList){
                                                             bhMap.put(bh.name, bh);
                                                          }
                                                          bHeaderToUpSert=bhMap.values();
                                                          system.debug(' benefit Header::'+bHeaderToUpSert);
                                                          Database.upsertResult [] resultsNotes = Database.upsert(bHeaderToUpSert,Benefit_Header__c.name, false);
                                                          
                                                          for (DataBase.upsertResult sr: resultsNotes ){
                                                              if(sr.isSuccess()){
                                                                  if(sr.isCreated()){
                                                                      System.debug('Successfully inserted header benefit ID: ' + sr.getId());
                                                                      
                                                                  }else{
                                                                      System.debug('Successfully update header benefit ID: ' + sr.getId());
                                                                  }
                                                              }else{
                                                                  for(Database.Error err : sr.getErrors()) {
                                                                      System.debug('error has occurred.' + err.getStatusCode() + ': ' + err.getMessage());                    
                                                                      System.debug('fields that affected this error: ' + err.getFields());
                                                                      
                                                                  }
                                                              }
                                                          }
                                                          
                                                      }
                                                      //insert Benefit Header Detail
                                                      system.debug('allBFHDetailList===>>>>'+allBFHDetailList);
                                                      Map<String,Benefit_Header_Detail__c> bhdMap=new Map<String, Benefit_Header_Detail__c>();
                                                      
                                                      if(allBFHDetailList!=null && !allBFHDetailList.isEmpty()){
                                                          
                                                          list<Benefit_Header_Detail__c> BHDtoUpSert=new list<Benefit_Header_Detail__c>();
                                                          
                                                          
                                                          for(Benefit_Header_Detail__c bhd: allBFHDetailList){
                                                              bhdMap.put(bhd.name, bhd);
                                                              
                                                          }
                                                          BHDtoUpSert=bhdMap.values();
                                                          
                                                          system.debug('number of benefit header detail to UpSert==>'+BHDtoUpSert.size());
                                                          Database.upSertResult [] resultsBF = Database.upsert(BHDtoUpSert,Benefit_Header_Detail__c.field.name, false); 
                                                          
                                                          for (DataBase.upsertResult sr: resultsBF ){
                                                              if(sr.isSuccess()){
                                                                  System.debug('Successfully inserted benefit header detail D: ' + sr.getId());
                                                                  if(sr.isCreated()){
                                                                      System.debug('Successfully inserted header detail ID: ' + sr.getId());
                                                                      
                                                                  }else{
                                                                      System.debug('Successfully update header detail ID: ' + sr.getId());
                                                                  }
                                                              }else{
                                                                  for(Database.Error err : sr.getErrors()) {
                                                                      System.debug('error has occurred.' + err.getStatusCode() + ': ' + err.getMessage());                    
                                                                      System.debug('fields that affected this error: ' + err.getFields());
                                                                      
                                                                  }
                                                              }
                                                          }
                                                      }     
                                                      
                                                      
                                                      //insert notes
                                                      
                                                      list<Benefit_Header__c> existingHeader=[select id, name,Benefit_Header_Name__c from Benefit_Header__c where name in:bhMap.keySet()];
                                                      Map<String, Id>headerIdMap=new Map<String, Id>();
                                                      
                                                      if(existingHeader!=null && !existingHeader.isEmpty()){
                                                          for(Benefit_Header__c bh:existingHeader){
                                                              headerIdMap.put(bh.name, bh.Id);
                                                          }
                                                      }
                                                      system.debug('all notes::'+allNotesList);
                                                      Map<String,SGR_Note__c > noteMap=new Map<String, SGR_Note__c>();
                                                      
                                                      if(allNotesList!=null && !allNotesList.isEmpty()){
                                                          
                                                          list<SGR_Note__c> notesToUpSert=new list<SGR_Note__c>();
                                                          
                                                          for(SGR_Note__c nt:allNotesList){
                                                              if(nt.Key__c!=null){
                                                                  nt.Benefit_Header__c=headerIdMap.get(nt.Key__c);
                                                              }
                                                              noteMap.put(nt.name, nt);
                                                             }
                                                          notesToUpSert=noteMap.values();
                                                          Database.upsertResult [] resultsNotes = Database.upsert(notesToUpSert,SGR_Note__c.field.name, false);
                                                          
                                                          for (DataBase.upsertResult sr: resultsNotes ){
                                                              if(sr.isSuccess()){
                                                                  if(sr.isCreated()){
                                                                      System.debug('Successfully inserted plan Note ID: ' + sr.getId());
                                                                      
                                                                  }else{
                                                                      System.debug('Successfully update plan Note ID: ' + sr.getId());
                                                                  }
                                                                  
                                                              }else{
                                                                  for(Database.Error err : sr.getErrors()) {
                                                                      System.debug('error has occurred.' + err.getStatusCode() + ': ' + err.getMessage());                    
                                                                      System.debug('fields that affected this error: ' + err.getFields());
                                                                      
                                                                  }
                                                              }
                                                          }
                                                      }
                                                      //insert benefit header Assocation
                                                      list<Benefit_Header_Association__c> bhAssoToUpSert=new list<Benefit_Header_Association__c>();
                                                      Map<String, Benefit_Header_Association__c> bhAssoFindDupMap=new Map<String, Benefit_Header_Association__c>();
                                                      
                                                      if(allBenefitHeaderAsso!=null && !allBenefitHeaderAsso.isEmpty()){
                                                          
                                                          for(Benefit_Header_Association__c bha: allBenefitHeaderAsso){
                                                              bha.Benefit_Header__c=headerIdMap.get(bha.Mapped_Benefit_Header_Id__c);
                                                              bha.Product__c=ProdToRefer.get(bha.Mapped_Product_Key__c);
                                                              bhAssoFindDupMap.put(bha.name, bha);
                                                          }
                                                          
                                                          if(bhAssoFindDupMap!=null && !bhAssoFindDupMap.isEmpty()){
                                                              bhAssoToUpSert=bhAssoFindDupMap.values();
                                                          }
                                                          
                                                          
                                                          Database.upsertResult [] resultsBHA = Database.upsert(bhAssoToUpSert,Benefit_Header_Association__c.field.name, false);
                                                          
                                                          for (DataBase.upsertResult sr: resultsBHA ){
                                                              if(sr.isSuccess()){
                                                                  if(sr.isCreated()){
                                                                      System.debug('Successfully inserted Benefit_Header_Association__c ID: ' + sr.getId());
                                                                      
                                                                  }else{
                                                                      System.debug('Successfully update Benefit_Header_Association__c ID: ' + sr.getId());
                                                                      
                                                                  }
                                                                  
                                                              }else{
                                                                  for(Database.Error err : sr.getErrors()) {
                                                                      System.debug('error has occurred.' + err.getStatusCode() + ': ' + err.getMessage());                    
                                                                      System.debug('fields that affected this error: ' + err.getFields());
                                                                      
                                                                  }
                                                              }
                                                          }
                                                      }
                                                      
                                                      
                                                      //to insert Benefit Header Note here
                                                      
                                                      //---inset note detail
                                                      list<SGR_Note_Detail__c>noteDetailtoUpSert=new list<SGR_Note_Detail__c>();
                                                      Map<String,SGR_Note_Detail__c> noteDetailMap=new Map<String, SGR_Note_Detail__c>();
                                                      if(allNoteDetails!=null && !allNoteDetails.isEmpty()){
                                                          for(SGR_Note_Detail__c nd:allNoteDetails){
                                                             noteDetailMap.put(nd.name, nd);
                                                          }
                                                          noteDetailtoUpSert=noteDetailMap.values();
                                                          
                                                          Database.upsertResult [] resultsNotes = Database.upsert(noteDetailtoUpSert,SGR_Note_Detail__c.field.name, false);
                                                          
                                                          for (DataBase.upsertResult sr: resultsNotes ){
                                                              if(sr.isSuccess()){
                                                                  System.debug('Successfully inserted/update notes detail: ' + sr.getId());
                                                                  if(sr.isCreated()){
                                                                      System.debug('Successfully inserted notes detail ID: ' + sr.getId());
                                                                  }else{
                                                                      System.debug('Successfully update notes detail ID: ' + sr.getId());
                                                                      
                                                                  }
                                                              }else{
                                                                  for(Database.Error err : sr.getErrors()) {
                                                                      System.debug('error has occurred.' + err.getStatusCode() + ': ' + err.getMessage());                    
                                                                      System.debug('fields that affected this error: ' + err.getFields());
                                                                      
                                                                  }
                                                              }
                                                          }
                                                      }
                                                      
                                                      //insert the plan note detail association 
                                                      list<Product_Note_Detail_Association__c> noteDetailAssoToUpSert=new list<Product_Note_Detail_Association__c>();	
                                                      list<SGR_Note_Detail__c> existingNoteDetail=[select id,name from SGR_Note_Detail__c where name in :noteDetailMap.keySet()];
                                                      Map<String,Product_Note_Detail_Association__c> noteDetailAssoMap=new Map<String, Product_Note_Detail_Association__c>();
                                                      Map<String, Id> existingNoteDetailMap=new Map<String, Id>();
                                                      
                                                      if(allNoteDetailAsso!=null && !allNoteDetailAsso.isEmpty()){
                                                         if(existingNoteDetail !=null && !existingNoteDetail.isEmpty()){
                                                              for(SGR_Note_Detail__c nd:existingNoteDetail){
                                                                  existingNoteDetailMap.put(nd.name, nd.id);
                                                              }
                                                          }
                                                          
                                                          for(Product_Note_Detail_Association__c asso:allNoteDetailAsso){
                                                              asso.Plan_Note_Detail__c=existingNoteDetailMap.get(asso.Mapped_Note_Detail_Id__c);
                                                              asso.Product__c=ProdToRefer.get(asso.Mapped_Product_Key__c);
                                                              noteDetailAssoMap.put(asso.name, asso);
                                                          }
                                                          
                                                          if(noteDetailAssoMap!=null && !noteDetailAssoMap.isEmpty()){
                                                              noteDetailAssoToUpSert=noteDetailAssoMap.values();
                                                          }
                                                          
                                                          Database.upSertResult [] resultsAsso = Database.upSert(noteDetailAssoToUpSert,Product_Note_Detail_Association__c.field.name, false);
                                                          
                                                          for (DataBase.UpsertResult sr: resultsAsso  ){
                                                              if(sr.isSuccess()){
                                                                  if(sr.isCreated()){
                                                                      System.debug('Successfully inserted product note detail assocation ID: ' + sr.getId());
                                                                  }else{
                                                                      System.debug('Successfully update product note detail assocation ID: ' + sr.getId());
                                                                      
                                                                  }
                                                              }else{
                                                                  for(Database.Error err : sr.getErrors()) {
                                                                      System.debug('error has occurred.' + err.getStatusCode() + ': ' + err.getMessage());                    
                                                                      System.debug('fields that affected this error: ' + err.getFields());
                                                                      
                                                                  }
                                                              }
                                                          }
                                                      }
                                                      
                                                      
                                                      //insert assingment
                                                      system.debug('bhd key set:'+bhdMap.keySet());
                                                      list<Benefit_Header_Detail__c> existingBHD=[select id, name, Benefit_Header_Detail_Name__c, value__c from Benefit_Header_Detail__c where name in:bhdMap.keySet() ];
                                                      Map<String, Id> detailToRefer=new Map<String,Id>();
                                                      
                                                      if(existingBHD!=null && !existingBHD.isEmpty() ){
                                                          for(Benefit_Header_Detail__c  d:existingBHD){
                                                              detailToRefer.put(d.name, d.Id);
                                                          }
                                                      }
                                                      
                                                      list<Benefit_Header_Detail_Association__c>bhdAssigmentToUpSert=new list<Benefit_Header_Detail_Association__c>();
                                                      if(allBHDAssignment!=null && !allBHDAssignment.isEmpty()){
                                                          for(Benefit_Header_Detail_Association__c assi:allBHDAssignment){
                                                              assi.Plan__c=plansToReferMap.get(assi.Mapped_Plan_Marketing_Id__c);
                                                              assi.Benefit_Header_Detail__c=detailToRefer.get(assi.Mapped_BHD_Id__c);
                                                              bhdAssigmentToUpSert.add(assi);
                                                          }
                                                          
                                                          
                                                          Database.upSertResult [] resultsAssi = Database.upSert(bhdAssigmentToUpSert,Benefit_Header_Detail_Association__c.field.name, false);
                                                          for (DataBase.UpsertResult sr: resultsAssi ){
                                                              if(sr.isSuccess()){
                                                                  if(sr.isCreated()){
                                                                      System.debug('Successfully inserted Benefit_Header_Detail_Association ID: ' + sr.getId());
                                                                  }else{
                                                                      System.debug('Successfully update Benefit_Header_Detail_Association ID: ' + sr.getId());
                                                                      
                                                                  }
                                                              }else{
                                                                  for(Database.Error err : sr.getErrors()) {
                                                                      System.debug('error has occurred.' + err.getStatusCode() + ': ' + err.getMessage());                    
                                                                      System.debug('fields that affected this error: ' + err.getFields());
                                                                      
                                                                  }
                                                              }
                                                          }
                                                          
                                                      }
                                                      //insert Plan_Note_Association__c
                                                      
                                                      if(allPlanNoteAssignment!=null && !allPlanNoteAssignment.isEmpty()){
                                                          
                                                          list<SGR_Note__c> existingPlanNote=[select id, name, Benefit_Header__c,Key__c, Symbol__c from SGR_Note__c where name in:noteMap.keySet()];
                                                          
                                                        Map<String, Id> noteIdMap=new Map<String, Id>();
                                                          
                                                          if(existingPlanNote!=null && !existingPlanNote.isEmpty()){
                                                              for(SGR_Note__c note:existingPlanNote){
                                                                  noteIdMap.put(note.name, note.Id);
                                                              }
                                                          }
                                                          
                                                          list<Plan_Note_Association__c> noteAssignmentToUpSert=new list<Plan_Note_Association__c>();
                                                          
                                                          
                                                          for(Plan_Note_Association__c pa:allPlanNoteAssignment){
                                                              pa.Plan__c=plansToReferMap.get(pa.Mapped_Plan_Marketing_Id__c);
                                                              pa.Plan_Note__c=noteIdMap.get(pa.Mapped_Note_Id__c);
                                                              system.debug(' note assignmen plan Id: '+pa.Plan__c+' plan note:'+pa.Plan_Note__c);
                                                              noteAssignmentToUpSert.add(pa);
                                                          }
                                                          
                                                          Database.upSertResult []  noteAssUpserResult = Database.upSert(noteAssignmentToUpSert,Plan_Note_Association__c.field.name, false);
                                                          for (DataBase.UpsertResult sr: noteAssUpserResult ){
                                                              if(sr.isSuccess()){
                                                                  if(sr.isCreated()){
                                                                      System.debug('Successfully inserted Plan_Note_Association__c ID: ' + sr.getId());
                                                                  }else{
                                                                      System.debug('Successfully update Plan_Note_Association__c ID: ' + sr.getId());
                                                                      
                                                                  }
                                                              }else{
                                                                  for(Database.Error err : sr.getErrors()) {
                                                                      System.debug('error has occurred.' + err.getStatusCode() + ': ' + err.getMessage());                    
                                                                      System.debug('fields that affected this error: ' + err.getFields());
                                                                      
                                                                  }
                                                              }
                                                          }
                                                          
                                                      }
                                                      
                                                      //insert plan fips map
                                                      list<SGR_Plan_FIPS_Map__c> planFipsToUpSert=new list<SGR_Plan_FIPS_Map__c>();
                                                      system.debug('original allPlanFipsList:::'+allPlanFipsList);
                                                      
                                                      Map<String,SGR_Plan_FIPS_Map__c> dupFilterMap=new Map<String,SGR_Plan_FIPS_Map__c>();
                                                      
                                                      if(allPlanFipsList!=null && !allPlanFipsList.isEmpty()){
                                                          system.debug('# of PlanFipsToUpsert before filter duplicated-->'+allPlanFipsList.size());
                                                          
                                                          
                                                          for(SGR_Plan_FIPS_Map__c planFips:allPlanFipsList ){
                                                              dupFilterMap.put(planFips.name, planFips);
                                                           }
                                                          
                                                          planFipsToUpSert=dupFilterMap.values();//list of plan fips map after filtered out any duplicated by the name
                                                          
                                                          if(planFipsToUpSert!=null && !planFipsToUpsert.isEmpty()){
                                                              for(SGR_Plan_FIPS_Map__c mpPlan:planFipsToUpsert){
                                                                  mpPlan.plan__c=plansToReferMap.get(mpPlan.SGR_Plan_Id__c);
                                                              }
                                                              
                                                              system.debug('# of PlanFipsToUpsert -->'+planFipsToUpSert.size()+' plan__c [0]:;;;'+planFipsToUpSert[0].plan__c);
                                                          }
                                                          
                                                          system.debug('planFipsList to Insert:::'+planFipsToUpSert);
                                                          
                                                          Database.upSertResult [] resultsFips = Database.upSert(planFipsToUpSert,SGR_Plan_FIPS_Map__c.field.name, false);
                                                          
                                                          for (DataBase.UpsertResult sr: resultsFips ){
                                                              if(sr.isSuccess()){
                                                                  if(sr.isCreated()){
                                                                      System.debug('Successfully inserted plan FIPS Map ID: ' + sr.getId());
                                                                  }else{
                                                                      System.debug('Successfully update plan FIPS Map ID: ' + sr.getId());
                                                                      
                                                                  }
                                                                  
                                                              }else{
                                                                  for(Database.Error err : sr.getErrors()) {
                                                                      System.debug('error has occurred.' + err.getStatusCode() + ': ' + err.getMessage());                    
                                                                      System.debug('fields that affected this error: ' + err.getFields());
                                                                      
                                                                  }
                                                              }
                                                          }
                                                      }
                                                      
                                                      
                                                  }//end of planlist
                                                  
                                              }//end of product list
                                          }catch(System.dmlException dmlException){
                                              system.debug('insert integration log error::'+dmlException);
                                              result='failed: '+dmlException.getMessage();
                                              
                                          } catch (Exception e){
                                              
                                              system.debug('CallGetAvailableplan service error:'+e.getLineNumber()+' :'+e);
                                              result='failed: '+e.getMessage();
                                          }
                                          return result;
                                      }
    
    
    /*
** this method is invoked to call the get plan service at one time.
**
*/       
    public static  SGR_GSPS_GetAvailablePlanUpdateData getAvailablePlans(String newAccessToken,DateTime lastTokenUpdateDateTime,
                                                                         String productGroupCd, 
                                                                         Id prodGroupId, 
                                                                         Date effectiveDate,
                                                                         String division, 
                                                                         String marketSegment,
                                                                         String fundingType, 
                                                                         String clientId, 
                                                                         String fipsCode, 
                                                                         Integer version) {
                                                                             
                                                                             SGR_GSPS_GetAvailablePlanUpdateData allPlanData=new SGR_GSPS_GetAvailablePlanUpdateData();                                           	
                                                                             
                                                                             String result = 'S';
                                                                             
                                                                             SGR_GSPS_GetAvailablePlanServiceRequest req = new SGR_GSPS_GetAvailablePlanServiceRequest();        
                                                                             req.productGroupCd = productGroupCd;
                                                                             req.effectiveDate = effectiveDate;
                                                                             req.division = division;
                                                                             req.marketSegment = marketSegment;
                                                                             req.fundingType = fundingType;          
                                                                             req.clientId = clientId;
                                                                             req.version = version;
                                                                             req.fipsCode=fipsCode;
                                                                             SGR_GSPS_GetAvailablePlanServiceResponse response = new SGR_GSPS_GetAvailablePlanServiceResponse();
                                                                             
                                                                             try {
                                                                                 
                                                                                 APICallOutRestWSUtility callOutUtil = new APICallOutRestWSUtility(getAllPlanCallout);
                                                                                 oAuthUtil=callOutUtil.oAuthUtil;
                                                                                 if(newAccessToken!=null && lastTokenUpdateDateTime!=null){
                                                                                     system.debug('get new access token from previous call-->'+newAccessToken);
                                                                                     callOutUtil.newAccessToken=newAccessToken;// will get updated from callout if this token is expired
                                                                                     callOutUtil.lastTokenUpdateDateTime=lastTokenUpdateDateTime;//will get updated from callout is this token is expired
                                                                                 }
                                                                                 response = callOutUtil.invokeGetAllAvailablePlanService(req);
                                                                                 
                                                                                 system.debug('response::::'+response);
                                                                                 if ( response == null || response.planGroups == null || response.planGroups.isEmpty()) {
                                                                                     allPlanData=null;
                                                                                     result='F'; // SFDC-14006, do not find any plans, do nothing
                                                                                 }else{
                                                                                     
                                                                                     allPlanData= processAllPlanResponseData(response, prodGroupId, fipsCode, division, marketSegment, fundingType, effectiveDate);
                                                                                     system.debug('capture new accessToken from callout:'+callOutUtil.newAccessToken);
                                                                                     allPlanData.newAccessToken=callOutUtil.newAccessToken;
                                                                                     allPlanData.lastTokenUpdateDateTime=callOutUtil.lastTokenUpdateDateTime;
                                                                                     
                                                                                 }
                                                                                 
                                                                             } catch (Exception e) {
                                                                                 system.debug(' All AvailablePlan Service Exception at '+e.getLineNumber()+'-->'+e);
                                                                                 result =e.getMessage();
                                                                                 response.statusCode='F';
                                                                                 allPlanData=null;
                                                                                 
                                                                             }finally{
                                                                                 
                                                                                 
                                                                                 if(allPlanLog!=null && allPlanLog.Integration_Log__c){
                                                                                     FW_Service_Status_Log__c intLog=new FW_Service_Status_Log__c();
                                                                                     if(response==null){
                                                                                         
                                                                                         intLog=Utility.getIntegrationLog('GetAllAvailablePlanService',
                                                                                                                          null, 
                                                                                                                          'Failed',
                                                                                                                          result,
                                                                                                                          system.now(), 
                                                                                                                          system.now(), 
                                                                                                                          null, 
                                                                                                                          null);
                                                                                     }else{
                                                                                         intLog=Utility.getIntegrationLog('GetAllAvailablePlanService',
                                                                                                                          null, 
                                                                                                                          response.statusCode,
                                                                                                                          response.errorMessage, 
                                                                                                                          response.execStart, 
                                                                                                                          response.execEnd, 
                                                                                                                          response.reqBody, 
                                                                                                                          response.respBody);
                                                                                     }
                                                                                     if(allPlanData==null){
                                                                                         allPlanData=new SGR_GSPS_GetAvailablePlanUpdateData();
                                                                                     }
                                                                                     allPlanData.allInteLogList.add(intLog);
                                                                                 }      
                                                                                 
                                                                             }
                                                                             return allPlanData;
                                                                             
                                                                         }
    /**
*  This method is to process all plan data from ws response and stored into response wrapper classes.
**  // SFDC-14006 - Split the functionality to new method for reusability   
**/
    
    public static SGR_GSPS_GetAvailablePlanUpdateData processAllPlanResponseData(SGR_GSPS_GetAvailablePlanServiceResponse response, Id prodGroupId, String fipsCode, String division, String marketSegment, String fundingType, Date rateEffDate){
        
        list<Product2> productList=new list<Product2>();
        list<Plan__c> allPlans=new list<Plan__c>();
        list<Benefit_Header_Detail__c> allBFHDetail=new  list<Benefit_Header_Detail__c>();
        list<Benefit_Header__c> allBFHeaders=new  list<Benefit_Header__c>();
        list<SGR_Note_Detail__c>allNoteDetails=new list<SGR_Note_Detail__c>();
        list<SGR_Plan_FIPS_Map__c> planFipsList=new list<SGR_Plan_FIPS_Map__c>();
        list<Plan_Note_Association__c> planNoteAssigList=new list<Plan_Note_Association__c>();
        list<Benefit_Header_Detail_Association__c> bhdAssigList=new list<Benefit_Header_Detail_Association__c>();
        list<Benefit_Header_Association__c>headerAssoList=new list<Benefit_Header_Association__c>();
        list<Product_Note_Detail_Association__c>noteDetailAsso=new list<Product_Note_Detail_Association__c>();
        
        list<SGR_Note__c>allNotes=new list<SGR_Note__c>();
        allBHNotes=new list<SGR_Note__c>();
        
        Map<String, product2>findDuplicateProdMap=new Map<String, product2>();
        if(response!=null){
            
            if(response.planGroups!=null){
                
                for(SGR_GSPS_GetAvailablePlanServiceResponse.GSPS_PlanGroup pg1: response.planGroups){
                    Product2 prod1=new Product2();
                    
                    prod1.recordTypeId = gspsProduct2TypeId;
                    prod1.Name = pg1.Name;//product name
                    prod1.Simplified_Product__c=pg1.code;
                    if(pg1.productType!=null){
                        prod1.Description=pg1.productType.description;
                        prod1.Product_Type__c=pg1.productType.code;
                    }else{
                        prod1.Product_Type__c = 'Other';
                    }
                    prod1.Product_Indicator__c='SG';
                    prod1.IsActive = true;
                    prod1.HCSC_State__c = division;
                    prod1.External_ID__c=pg1.Name+division+'SG';
                    
                    if(!findDuplicateProdMap.containsKey(pg1.Name+division+'SG')){
                        findDuplicateProdMap.put(pg1.Name+division+'SG', prod1);
                        productList.add(prod1);
                    }
                    
                    if(pg1!=null){
                        system.debug('benefitHeaders:::'+pg1.benefitHeaders);
                    }
                    if(pg1!=null && pg1.benefitHeaders!=null){
                        system.debug('benefitHeaders size:::'+pg1.benefitHeaders.size());
                        system.debug('before add allBH notes:::->'+allBHNotes.size());
                        allBFHeaders.addAll(processAllBenefitHeaders(pg1.benefitHeaders,prod1)); 
                        headerAssoList.addAll(processAllBenefitHeadersAssociation(allBFHeaders, prod1)); 
                        
                        system.debug('allBFHeaders size:'+allBFHeaders.size()+' |  after added allBH notes:::->'+allBHNotes.size());
                        
                    }				
                    if(pg1!=null && pg1.noteDetails !=null){
                        allNoteDetails.addAll(processNoteDetails(pg1.noteDetails, prod1));
                        noteDetailAsso.addAll(processNoteDetailsAssociation(allNoteDetails, prod1));
                        
                    }		
                    if(pg1!=null && pg1.subPlanGroups!=null ){
                        
                        for(SGR_GSPS_GetAvailablePlanServiceResponse.GSPS_PlanGroup pg2: pg1.subPlanGroups){
                            Product2 prod2=new Product2();
                            prod2.recordTypeId = gspsProduct2TypeId;
                            prod2.Simplified_Product__c=pg2.code;
                            
                            prod2.Name = pg2.Name;
                            
                            if(pg2.productType!=null){
                                prod2.Description=pg2.productType.description;
                                prod2.Product_Type__c=pg2.productType.code;
                            }else{
                                prod2.Product_Type__c = 'Other';
                            }
                            prod2.Product_Indicator__c='SG';
                            prod2.IsActive = true;
                            prod2.HCSC_State__c = division;
                            prod2.External_ID__c=pg2.Name+division+'SG';
                            
                            if(!findDuplicateProdMap.containsKey(pg2.Name+division+'SG')){
                                findDuplicateProdMap.put(pg2.Name+division+'SG', prod2);
                                productList.add(prod2);
                            }
                            
                            if(pg2!=null && pg2.benefitHeaders!=null){
                                allBFHeaders.addAll(processAllBenefitHeaders(pg2.benefitHeaders,prod2));
                                headerAssoList.addAll(processAllBenefitHeadersAssociation(allBFHeaders, prod2)); 
                            }
                            
                            if(pg2!=null && pg2.noteDetails !=null){
                                allNoteDetails.addAll(processNoteDetails(pg2.noteDetails, prod2));
                                noteDetailAsso.addAll(processNoteDetailsAssociation(allNoteDetails, prod2));
                                
                            }
                            if(pg2!=null && pg2.subPlanGroups!=null){
                                
                                for(SGR_GSPS_GetAvailablePlanServiceResponse.GSPS_PlanGroup pg3: pg2.subPlanGroups){
                                    Product2 prod3=new Product2();
                                    prod3.Simplified_Product__c=pg3.code;
                                    prod3.recordTypeId = gspsProduct2TypeId;
                                    prod3.Name = pg3.Name;
                                    if(pg3.productType!=null){
                                        prod3.Description=pg3.productType.description;
                                        prod3.Product_Type__c=pg3.productType.code;
                                    }else{
                                        prod3.Product_Type__c = 'Other';
                                    }
                                    prod3.Product_Indicator__c='SG';
                                    prod3.IsActive = true;
                                    prod3.HCSC_State__c = division;
                                    prod3.External_ID__c=pg3.Name+division+'SG';
                                    
                                    if(!findDuplicateProdMap.containsKey(pg3.Name+division+'SG')){
                                        findDuplicateProdMap.put(pg3.Name+division+'SG',prod3);
                                        productList.add(prod3);
                                    }
                                    
                                    if(pg3!=null && pg3.plans!=null){
                                        
                                        for(SGR_GSPS_GetAvailablePlanServiceResponse.GSPS_Plan p: pg3.plans){
                                            Plan__c planData=processAllPlans(p,prodGroupId,findDuplicateProdMap.get(pg3.name+division+'SG'), 
                                                                             findDuplicateProdMap.get(pg2.name+division+'SG'),
                                                                             findDuplicateProdMap.get(pg1.name+division+'SG'), 
                                                                             pg3.lineOfBusiness, pg3.startDate,pg3.endDate, 
                                                                             pg1.sortOrder,pg2.sortOrder);
                                            
                                            planData.FipsCodes__c=fipsCode;
                                            
                                            if(p!=null && p.benefitHeaderDetails!=null ){
                                                allBFHDetail.addAll(processBenefitHeaderDetails(p.benefitHeaderDetails, planData));
                                                bhdAssigList.addAll(processBenefitHeaderDetailsAssignment(allBFHDetail, planData));
                                            }
                                            if(p!=null && p.notes!=null){
                                                allNotes.addAll(processNotes(p.notes,null));
                                                planNoteAssigList.addAll(processPlanNoteAssignment(allNotes, planData));
                                            }
                                            
                                            allPlans.add(planData);
                                        }   
                                        
                                        //processPlan
                                    }
                                }
                                
                            }else if(pg2!=null && pg2.plans!=null){
                                for(SGR_GSPS_GetAvailablePlanServiceResponse.GSPS_Plan p2: pg2.plans){
                                    //processplan
                                    Plan__c planData=processAllPlans(p2,prodGroupId,
                                                                     findDuplicateProdMap.get(pg2.name+division+'SG'),
                                                                     findDuplicateProdMap.get(pg1.name+division+'SG'),null,
                                                                     pg2.lineOfBusiness, pg2.startDate, pg2.endDate, pg1.sortOrder, null);
                                    
                                    if(p2!=null && p2.benefitHeaderDetails!=null ){
                                        allBFHDetail.addAll(processBenefitHeaderDetails(p2.benefitHeaderDetails, planData));
                                        bhdAssigList.addAll(processBenefitHeaderDetailsAssignment(allBFHDetail, planData));
                                    }
                                    
                                    if(p2!=null && p2.notes!=null){
                                        allNotes.addAll(processNotes(p2.notes,null));
                                        planNoteAssigList.addAll(processPlanNoteAssignment(allNotes, planData));
                                    }
                                    
                                    allPlans.add(planData);				
                                }
                            }
                        }
                        
                    }else if(pg1!=null && pg1.plans!=null){//this scenario mostly wont happen
                        
                        for(SGR_GSPS_GetAvailablePlanServiceResponse.GSPS_Plan p1: pg1.plans){
                            //processplan
                            Plan__c planData=processAllPlans(p1,prodGroupId, 
                                                             findDuplicateProdMap.get(pg1.name+division+'SG'), 
                                                             null,null, 
                                                             pg1.lineOfBusiness, pg1.startDate, pg1.endDate, null, null);
                            
                            if(p1!=null && p1.benefitHeaderDetails!=null ){
                                allBFHDetail.addAll(processBenefitHeaderDetails(p1.benefitHeaderDetails, planData));
                                bhdAssigList.addAll(processBenefitHeaderDetailsAssignment(allBFHDetail, planData));
                            }
                            
                            if(p1!=null && p1.notes!=null){
                                allNotes.addAll(processNotes(p1.notes, null));
                                planNoteAssigList.addAll(processPlanNoteAssignment(allNotes, planData));
                            }
                            
                            allPlans.add(planData);			        				
                        }
                        
                    }
                    
                }
                
            }
        }    	 
        
        SGR_GSPS_GetAvailablePlanUpdateData allData=new SGR_GSPS_GetAvailablePlanUpdateData();
        
        system.debug('product to insert::'+productList);
        if(productList!=null && !productList.isEmpty())	{
            allData.allProductList=productList;
            system.debug('plans to insert: '+allPlans);
            
            if(allPlans!=null && !allPlans.isEmpty()){
                allData.allPlanList=allPlans;
                allData.allPlanFipsList = processPlanFipsRecs(allPlans,fipsCode,division, marketSegment, fundingType,rateEffDate);
                
                system.debug('benefit Header detail to insert:'+allBFHDetail);
                
                if(allBFHDetail!=null && !allBFHDetail.isEmpty()){
                    
                    allData.allBenefitHeaderDetailList=allBFHDetail;
                    
                }     
                system.debug('all notes::'+allNotes);
                if(allNotes!=null && !allNotes.isEmpty()){
                    allData.allNoteList=allNotes;
                    
                }
            }
            if( allBFHeaders!=null && !allBFHeaders.isEmpty()){
                allData.allBenefitHeaderList=allBFHeaders;
                system.debug('alldata. allbenefitHeader List::'+allData.allBenefitHeaderList.size()+ ' has benefit header note:'+allBHNotes);
                if(allBHNotes!=null && !allBHNotes.isEmpty()){
                    allData.allNoteList.addAll(allBHNotes);
                    allBHNotes=null;
                }
            }
            
            
            if(allNoteDetails!=null && !allNoteDetails.isEmpty()){
                system.debug('allnote details::'+allNoteDetails.size());
                allData.allNoteDetailList=allNoteDetails;
            }
            
            if(bhdAssigList!=null && !bhdAssigList.isEmpty()){
                system.debug('bhdAssigList size;;;'+bhdAssigList.size());
                
                allData.allBHDAssignList=bhdAssigList;
            }
            if(planNoteAssigList!=null && !planNoteAssigList.isEmpty()){
                system.debug('planNoteAssigList size;;;'+planNoteAssigList.size());
                allData.allPlanNoteAssignList=planNoteAssigList;
            }
            
            if(headerAssoList!=null && !headerAssoList.isEmpty()){
                system.debug('benefit header assocationlist: '+headerAssoList.size());
                allData.allBenefitHeaderAssoList=headerAssoList;
            }
            
            if(noteDetailAsso!=null && !noteDetailAsso.isEmpty()){
                system.debug('note detail association::'+noteDetailAsso.size());
                allData.allProductNoteDetailAssoList=noteDetailAsso;
            }
            
        }
        
        return allData;
    }
    
   /**
**@author Mei Chen
**/
    public static Plan__c processAllPlans(SGR_GSPS_GetAvailablePlanServiceResponse.GSPS_Plan p, String parentPGId,  Product2 prod3, Product2 prod2, Product2 prod1, String LoB ,
                                          String startDate, String endDate, String level1SortOrder, String level2SortOrder) {
                                              if (p==null){
                                                  return null;
                                              }
                                              Plan__c plan = new Plan__c();
                                              plan.Name = p.planName;
                                              plan.Marketing_Plan_Number__c =p.planName;
                                              plan.Mapped_Plan_Name__c=p.mappedPlanName;//capture mapped plan if there is one
                                              plan.MappedPlan__c=null;//  id is null until is saved to db
                                              plan.Plan_Sales_ID__c = p.planSalesId;
                                              plan.Description__c = p.description;
                                              plan.Long_Description__c = p.longDescription;
                                              plan.Short_Description__c = p.shortDescription;
                                              plan.Effective_Date__c = Utility.parseDate(p.effectiveDate);
                                              plan.Expiry_Date__c = Utility.parseDate(p.endDate);
                                              plan.Retired_Date__c =Utility.parseDate(p.retiredDate);
                                              plan.Division__c = p.division;
                                              plan.Network__c = p.network;
                                              plan.Channel__c = p.channel;
                                              plan.End_Date__c=Utility.parseDate(p.endDate);
                                              
                                              system.debug('is has:::'+p.isHsa);
                                              
                                              if(p.isHsa==null){
                                                  plan.Is_HSA__c =false;//p.isHsa;
                                              }else{
                                                  plan.Is_HSA__c=p.isHsa;
                                              }
                                              
                                              system.debug('p.isAllCopay--->'+p.isAllCopay);
                                              if(p.isAllCopay==null){
                                                  plan.Is_All_Copay__c =false;
                                              }else{
                                                  plan.Is_All_Copay__c=p.isAllCopay;
                                              }
                                              plan.Sort_Order__c = Integer.valueOf(p.sortOrder);
                                              String hsaContribution = p.hsacontribution;
                                              plan.HSA_Contribution__c = (hsaContribution != null && hsaContribution.isNumeric())?Decimal.valueOf(p.hsacontribution):0.0;
                                              plan.Plan_Level__c = p.planLevel; //metallic
                                              if(prod3!=null){
                                                  plan.Product__c=prod3.Id;//level3 produc. the Id isnot availble at this point, will be updated later
                                                  plan.Product_Name__c=prod3.name;
                                              }
                                              if(prod1!=null){
                                                  plan.Level_1_Product_Name__c=prod1.name;
                                              }
                                              if(prod2!=null){
                                                  plan.Level_2_Product_Name__c=prod2.name;
                                              }
                                              if(prod1!=null){
                                                  plan.Plan_Group_Level1__c=prod1.id;
                                              }
                                              if(prod2!=null){
                                                  plan.Plan_Group_Level2__c=prod2.id;
                                              }
                                              plan.Line_Of_Business__c=LoB;
                                              plan.Plan_Group_End_Date__c=Utility.parseDate(endDate);
                                              plan.Plan_Group_Start_Date__c=Utility.parseDate(startDate);
                                              
                                              if(level1SortOrder!=null){
                                                  plan.Level_1_Sort_Order__c=Integer.valueOf(level1SortOrder);
                                              }
                                              if(level2SortOrder!=null){
                                                  plan.Level2_Sort_Order__c=Integer.valueOf(level2SortOrder);
                                              }
                                              return plan;                
                                          }
    
    public static List<Benefit_Header__c> processBenefitHeaders(List<SGR_GSPS_GetAvailablePlanServiceResponse.GSPS_BenefitHeader> benefitHeaders, Product2 pg) {
        if(null == benefitHeaders || null == pg) return new List<Benefit_Header__c>();
        List<Benefit_Header__c> bhToInsert = new List<Benefit_Header__c>();        
        for (SGR_GSPS_GetAvailablePlanServiceResponse.GSPS_BenefitHeader bh: benefitHeaders) {
            Benefit_Header__c bHeader = new Benefit_Header__c();
            bHeader.Benefit_Header_Name__c = bh.name; //TODO: Need to find source field 
            bHeader.name=String.valueOf(bh.id);    
            bHeader.Sort_Order__c = bh.sortOrder; 
            bhToInsert.add(bHeader);
        }                       
        
        return bhToInsert;                          
    }  
    
    public static List<SGR_Note_Detail__c> processNoteDetails(List<SGR_GSPS_GetAvailablePlanServiceResponse.GSPS_NoteDetail> noteDetails, Product2 pg) {
        if(null == noteDetails || null == pg) return new List<SGR_Note_Detail__c>();
        List<SGR_Note_Detail__c> noteDetailsToInsert = new List<SGR_Note_Detail__c>();
        for (SGR_GSPS_GetAvailablePlanServiceResponse.GSPS_NoteDetail nD: noteDetails) {
            SGR_Note_Detail__c noteDetail = new SGR_Note_Detail__c();               
            noteDetail.name=String.valueOf(nD.id);      
            noteDetail.Type__c = nD.type;
            noteDetail.Text__c = nD.text;
            noteDetail.Symbol__c = nD.symbol;            
            noteDetailsToInsert.add(noteDetail);
        }           
        
        return noteDetailsToInsert;                         
    } 
    
    public static List<Benefit_Header_Detail__c> processBenefitHeaderDetails(List<SGR_GSPS_GetAvailablePlanServiceResponse.GSPS_BenefitHeaderDetail> benefitHeaderDetails, Plan__c plan) {
        if(null == benefitHeaderDetails || null == plan) return new List<Benefit_Header_Detail__c>();
        
        List<Benefit_Header_Detail__c> bhDToInsert = new List<Benefit_Header_Detail__c>();
        system.debug('plan market plan id to benefhit header detail: '+plan.Marketing_Plan_Number__c);
        
        for (SGR_GSPS_GetAvailablePlanServiceResponse.GSPS_BenefitHeaderDetail bhd: benefitHeaderDetails) {
            Benefit_Header_Detail__c bhDetail = new Benefit_Header_Detail__c();
            bhDetail.name=String.valueOf(bhd.id);
            bhDetail.Benefit_Header_Detail_Name__c=bhd.name;
            bhDetail.Value__c = bhd.value;                          
            bhDToInsert.add(bhDetail);
        }                   
        
        return bhDToInsert;                         
    } 
    
    public static List<SGR_Note__c> processNotes(List<SGR_GSPS_GetAvailablePlanServiceResponse.GSPS_Note> notes, Benefit_Header__c bheader) {
        
        List<SGR_Note__c> notesToInsert = new List<SGR_Note__c>();
        system.debug('proces notes:::'+notes+' from benefit header? +'+bHeader);
        for (SGR_GSPS_GetAvailablePlanServiceResponse.GSPS_Note note: notes) {
            SGR_Note__c n = new SGR_Note__c();
            n.name = String.valueOf(note.id);//id
            n.Symbol__c = note.symbol;
            
            if (bHeader!=null){   
                n.Key__c =bHeader.name ;
                system.debug(' note from benefit header: '+bHeader.name);
            }
            
            notesToInsert.add(n);
        }                   
        system.debug('number of note to insert::'+notesToInsert.size());
        return notesToInsert;                           
    } 
    
    public static List<SGR_Plan_FIPS_Map__c> processPlanFipsRecs(List<Plan__c> plans, String fipsCode, String division, String marketSegment, String fundingType, Date rateEffDate) {
        List<SGR_Plan_FIPS_Map__c> planFipsToInsert = new List<SGR_Plan_FIPS_Map__c>();	
        
        String effDtStr=getEffDateMonYearStr(rateEffDate);
        
        for (Plan__c p: plans) {
            planFipsToInsert.add(new SGR_Plan_FIPS_Map__c(
                Name =p.Marketing_Plan_Number__c+fipsCode + division+effDtStr,
                SGR_Plan_Id__c =p.Marketing_Plan_Number__c, //p.id
                FIPS_Code__c = fipsCode,
                Corporate_Entity_Code__c = division + '1',
                Market_Segment__c = marketSegment,
                Funding_Type__c = fundingType,
                Effective_Date__c = rateEffDate,
                Division__c = division
            ));									
        }
        system.debug('number of planfipsToInsert '+planFipsToInsert+' for FipsCode: '+fipsCode+' and StateCode:'+division);
        return planFipsToInsert;
    }
    
    private static String convertPgExtId(String name, String code, String lob, Date d, String division){
        return name + lob + (d == null ? '0/0/0' : d.format()) + division;
    }
    
    /*
**@author Mei Chen
*/
    public static List<Benefit_Header__c> processAllBenefitHeaders(List<SGR_GSPS_GetAvailablePlanServiceResponse.GSPS_BenefitHeader> benefitHeaders,Product2 prod){//Id productGrpId) {
        
        if(null == benefitHeaders) return new List<Benefit_Header__c>();
        list<SGR_Note__c> bhNoteList=new list<SGR_Note__c>();//allBHNotes
        list<Benefit_Header__c> bhToInsert = new List<Benefit_Header__c>();   
        for (SGR_GSPS_GetAvailablePlanServiceResponse.GSPS_BenefitHeader bh: benefitHeaders) {
            Benefit_Header__c bHeader = new Benefit_Header__c();
            bHeader.name=String.valueOf(bh.id);
            bHeader.Benefit_Header_Name__c = bh.name;  
            bHeader.Sort_Order__c = bh.sortOrder;        
            bhToInsert.add(bHeader);
            if(bh.notes!=null){
                if(allBHNotes==null){
                    allBHNotes=new list<SGR_Note__c>();
                }
                bhNoteList=processNotes(bh.notes, bHeader);
                allBHNotes.addAll(bhNoteList);
                system.debug('benefit Header Notes::::'+allBHNotes.size()+' bhNoteList-->'+bhNoteList);
                
            }
            
        }     
        system.debug(' Number fo Benefit Header recevied ws for prod '+prod.External_Id__c+' is-->'+bhToInsert.size());
        return bhToInsert;                          
    }
    
    /**
** Mei Chen
**  Benefit_Header_Detail_Association__c is conjunction object of plan__c and Benefit_Header_Detail__c
**/
    public static list<Benefit_Header_Detail_Association__c> processBenefitHeaderDetailsAssignment(list<Benefit_Header_Detail__c>benefitDetails, plan__c plan){
        list<Benefit_Header_Detail_Association__c> assignmentList=new list<Benefit_Header_Detail_Association__c>();
        Map<String,Benefit_Header_Detail_Association__c> findDupMap=new Map<String, Benefit_Header_Detail_Association__c>();
        system.debug('processBenefitHeaderDetailsAssignment effDateAtRun;;;;'+effDateAtRun);
        
        if(plan!=null && benefitDetails!=null && !benefitDetails.isEmpty()){
            for(Benefit_Header_Detail__c bd:benefitDetails){
                Benefit_Header_Detail_Association__c newAssi=new Benefit_Header_Detail_Association__c();
                newAssi.name=bd.name+plan.Marketing_Plan_Number__c+getEffDateMonYearStr(effDateAtRun);
                newAssi.Effective_Date__c=effDateAtRun;
                newAssi.Mapped_Plan_Marketing_Id__c=plan.Marketing_Plan_Number__c;
                newAssi.Mapped_BHD_Id__c=bd.name;
                findDupMap.put(newAssi.name, newAssi);
            }
            
            if(findDupMap!=null && !findDupMap.isEmpty()){
                assignmentList=findDupMap.values();
            }
        }
        
        return assignmentList;
    }
    
    /**
** Mei Chen
** Plan_Note_Association__c is conjun object of plan__c and SGR_Note__c
*/
    public static list<Plan_Note_Association__c> processPlanNoteAssignment (list<SGR_Note__c> noteList, Plan__c plan){
        list<Plan_Note_Association__c> assignmentList=new list<Plan_Note_Association__c>();
        Map<String,Plan_Note_Association__c> findDupMap=new Map<String, Plan_Note_Association__c>();
        system.debug('processPlanNoteAssignment effDateAtRun;;;;'+effDateAtRun);
        
        if(plan!=null && noteList!=null && !noteList.isEmpty()){
            for(SGR_Note__c nt:noteList){
                
                Plan_Note_Association__c newAssi=new Plan_Note_Association__c();
                newAssi.name=nt.name+plan.Marketing_Plan_Number__c+getEffDateMonYearStr(effDateAtRun);
                newAssi.Effective_Date__c=effDateAtRun;
                newAssi.Mapped_Plan_Marketing_Id__c=plan.Marketing_Plan_Number__c;
                newAssi.Mapped_Note_Id__c=nt.name;
                findDupMap.put(newAssi.name, newAssi);
            }
            
            if(findDupMap!=null && !findDupMap.isEmpty()){
                assignmentList=findDupMap.values();
            }
        }
        return assignmentList;
    }
    
    /**
** Mei Chen
**/  
    
    public static list<Benefit_Header_Association__c> processAllBenefitHeadersAssociation(list<Benefit_Header__c> benefitHeaders, Product2 prod){
        
        list<Benefit_Header_Association__c>  assoList=new list<Benefit_Header_Association__c>();
        Map<String,Benefit_Header_Association__c> findDupMap=new Map<String,Benefit_Header_Association__c>();
        system.debug('processAllBenefitHeadersAssociation effDateAtRun;;;;'+effDateAtRun);
        
        if(prod!=null && benefitHeaders!=null && !benefitHeaders.isEmpty()){
            
            for(Benefit_Header__c bh:benefitHeaders){
                
                Benefit_Header_Association__c newAssi=new Benefit_Header_Association__c();
                newAssi.name=bh.name+prod.External_Id__c+getEffDateMonYearStr(effDateAtRun);
                newAssi.Effective_Date__c=effDateAtRun;
                newAssi.Mapped_Product_Key__c=prod.External_Id__c;
                newAssi.Mapped_Benefit_Header_Id__c=bh.name;
                findDupMap.put(newAssi.name, newAssi);
            }
            
            if(findDupMap!=null && !findDupMap.isEmpty()){
                assoList=findDupMap.values();
            }
        }
        return assoList;
        
    }
    /**
**Mei Chen
*/
    public static list<	Product_Note_Detail_Association__c> processNoteDetailsAssociation(list<SGR_Note_Detail__c> noteDetailList, Product2 prod){
        
        list<	Product_Note_Detail_Association__c>  assoList=new list<	Product_Note_Detail_Association__c>();
        Map<String,Product_Note_Detail_Association__c > findDupMap=new Map<String, Product_Note_Detail_Association__c>();
        system.debug('processNoteDetailsAssociation effDateAtRun;;;;'+effDateAtRun);
        
        if(prod!=null && noteDetailList!=null && !noteDetailList.isEmpty()){
            for(SGR_Note_Detail__c nt:noteDetailList){
                
                Product_Note_Detail_Association__c newAssi=new Product_Note_Detail_Association__c();
                newAssi.name=nt.name+prod.External_Id__c+getEffDateMonYearStr(effDateAtRun);
                newAssi.Effective_Date__c=effDateAtRun;
                newAssi.Mapped_Product_Key__c=prod.External_Id__c;
                newAssi.Mapped_Note_Detail_Id__c=nt.name;
                findDupMap.put(newAssi.name, newAssi);
            }
            
            if(findDupMap!=null && !findDupMap.isEmpty()){
                assoList=findDupMap.values();
            }
        }
        return assoList;
        
    }
    
    @TestVisible
    private static String getEffDateMonYearStr(Date effDate){
        
        if(effDate==null){
            effDate=system.today();
        }
        String dateStr=String.valueOf(effDate.month())+String.valueOf(effDate.year());
        return dateStr;
    }
}