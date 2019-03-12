@RestResource(urlMapping='/createRate/*')
global with sharing class QuoteRequestWebServiceHelper {
	
    // private final static String heronIntName='Integration Heron';
     private final static String heronCallOut='HeronCallOut';
    
    /**
    **  This method is invoked by the clicking on the button 'Send To Heron' from the Quote Request page.
    **  This method is used to make callout to Heron with the Quote request input data.
    **/
    @auraEnabled
    global static String CreateGetRateWSCallout(String quoteReqId){

       // DTOQuoteRateRTResponse res=new DTOQuoteRateRTResponse();
         DTOStatus calloutStatus=new DTOStatus();
         String result=null;
        system.debug('quote req Id::: '+quoteReqId);
        
        Quote_Request_Summary__c updateReq=null;

        list<Quote_Request_Summary__c> quoteReq=[select id, Opportunity_Name__c,Account_Executive2_Name__c,Account_Executive1_Name__c,HCSC_Division__c,Account_Name_tx__c,Account_Number__c,Account_Sales_Executive1__c,Account_Sales_Executive2__c,Request_Description__c,Request_Effective_Date__c,Sales_Type__c, lastModifiedDate from Quote_Request_Summary__c where id=:quoteReqId];
       
        try{
        
          DTOQuoteRateRequest reqDTO=new DTOQuoteRateRequest();
          if(quoteReq!=null && !quoteReq.isEmpty()){
                updateReq=quoteReq[0];

                reqDTO.HCSCDivision=quoteReq[0].HCSC_Division__c;
                reqDTO.quoteReqId=quoteReq[0].id;
                reqDTO.opportunityName=quoteReq[0].Opportunity_Name__c;
                reqDTO.accountName=quoteReq[0].Account_Name_tx__c;
                // reqDTO.accountNumber=quoteReq[0].Account_Number__c;
            
                String accountNumber=quoteReq[0].Account_Number__c;
                if(accountNumber!=null && accountNumber.length()>2){
                    reqDTO.accountNumber= accountNumber.substring(2);
                  //reqDTO.accountNumber=accountNumber;
                   system.debug(' account number: '+reqDTO.accountNumber);
                }
                reqDTO.salesRep=quoteReq[0].Account_Executive1_Name__c;//Account_Sales_Executive1__c;
                if(reqDTO.salesRep==null){
                    reqDTO.salesRep=quoteReq[0].Account_Executive2_Name__c;//Account_Sales_Executive2__c;
                }
            
                reqDTO.quoteReqDesc=quoteReq[0].Request_Description__c;
                reqDTO.rateEffectiveDate=quoteReq[0].Request_Effective_Date__c;
                reqDTO.lastModifiedDate=quoteReq[0].lastModifiedDate;
                reqDTO.requestType=quoteReq[0].Sales_Type__c;
            
             
               //  res=APIQuoteRateUtility.CreateGetRateCallout(reqDTO);
                 APICallOutRestWSUtility callOutUtil=new APICallOutRestWSUtility(heronCallOut);
                 calloutStatus=callOutUtil.CreateGetRageHeronCallout(reqDTO);

                if(calloutStatus!=null){

                  if(calloutStatus.statusCode=='201'){
                     updateReq.status__c='Sent';
                     updateReq.Intergration_Status__c='Sent Rate Request To Heron'; 
                     updateReq.Integration_Error_Message__c=null;
                  }else{
                      updateReq.Intergration_Status__c='Failed.';
                      updateReq.Integration_Error_Message__c=calloutStatus.errorMessage;
                      result='Failed';
                  }
                   updateReq.Integration_Response_Message__c=calloutStatus.statusMessage;//response;
                   updateReq.Submitted_Date_Time__c=system.now();
               
               //  update updateReq;
             }
           
                system.debug('1st call out response::: '+calloutStatus);
            
         }
       
       }catch(Exception e) {
          system.debug('exception: '+e);
          result='Failed';
          if(updateReq!=null){
            updateReq.Submitted_Date_Time__c=system.now();
            updateReq.Intergration_Status__c='Failed.';
            updateReq.Integration_Response_Message__c='System Exception! Please contact System Administrator.';
            updateReq.Integration_Error_Message__c=e.getMessage();
          }

       }finally{

           try{
              if (updateReq!=null){
                update updateReq;

              }

            }catch(System.DMLException dmle){
               system.debug('update quote request dml exception: '+dmle);
            }
       }
        return result;
}
    
  @HttpPost
  /**
  ** This is Webservice for outboundcallcall by heron to return the qoute rate output data for the first call.
  **
  ***/ 
    global static DTOQuoteRateResponseStatus CreateQuoteRateData(DTOQuoteRateResponse heronCustomerData){//String customerName,  String blueStarAccountNumber,String corpEntCd,String salesforceQuoteRequestId,DTOHeronOpportunityData heronOpportunityData){//DTOQuoteRateResponse responseData
        
        
        //list<Exhibit_Association__c> assList=new list<Exhibit_Association__c>();
        list<Quote_Response_Association__c> associationList=new list<Quote_Response_Association__c>();
        list<Quote_Premium_Rates__c> premDataUpdateList=new list<Quote_Premium_Rates__c>();
        list<Quote_Request_Summary__c> updateReqsList=new list<Quote_Request_Summary__c>();
      //  list<Quote_Rate_by_Tier__c> rateByTierList=new list<Quote_Rate_by_Tier__c>();
        
        Quote_Request_Summary__c  quoteReq=new Quote_Request_Summary__c();
        
        Quote_Response__c quoteResponse=new Quote_Response__c();
         integer lostsize=0;
         integer updateSize=0;
         
        DTOQuoteRateResponseStatus statusObj=new DTOQuoteRateResponseStatus();
        
        system.debug('you are calling create QuoteRate REsponse::::' +heronCustomerData);
       
        try{
    
        if(heronCustomerData!=null){
            system.debug('QuoteRate REsponse::::' +heronCustomerData.heronOpportunityData);
            quoteResponse.Heron_Customer_Name__c=heronCustomerData.customerName;
            quoteResponse.Blue_Star_Account_Number__c=heronCustomerData.blueStarAccountNumber;
            quoteResponse.CorpEntCd__c=heronCustomerData.corpEntCd;
            
            String reqQuoteId=heronCustomerData.salesforceQuoteRequestId;
            
            list<Quote_Request_Summary__c> quoteReqs=[select id, name,Quote_Name__c from Quote_Request_Summary__c where id =: reqQuoteId];
          
            if(quoteReqs!=null && quoteReqs.size()>0){
                quoteReq=quoteReqs[0];
            }else{
                system.debug('can not find the quote req data base on the quote req id:'+reqQuoteId);
                throw new CreateQuoteCustomSettingsException('Salesforce Quote Id:'+reqQuoteId+' Not Found from Salesforce!');
            }
            
            if(heronCustomerData.heronOpportunityData!=null){
                DTOHeronOpportunityData opp=heronCustomerData.heronOpportunityData;
                string adminSign='';
                list<Quote_Response__c> existingResponse =[select id, name, Version_Status__c,Coverage_Type__c,Admin_Fee_Types__c,ResponseToRequest__c from Quote_Response__c where ResponseToRequest__c =:reqQuoteId and  Version_Status__c=:opp.versionStatus and Coverage_Type__c=:opp.coverageType];
            
                if(existingResponse!=null && !existingResponse.isEmpty()){
                  deleteExistingAssoData(existingResponse[0]);
                    quoteResponse=existingResponse[0]; //update from the current one
                }
                
                //start capture new response information
                 quoteResponse.name='Heron Rate for '+quoteReq.name;
                 quoteResponse.Heron_Opportunity_Number__c=String.valueOf(opp.opportunityId);
                 quoteResponse.Heron_Opportunity_Name__c=opp.opportunityName;
                 quoteResponse.Underwriter_Id__c=opp.underwriterId;
                 quoteResponse.Underwriter_Name__c=opp.underwriterName;
                 quoteResponse.Coverage_Type__c=opp.coverageType;
                 quoteResponse.Business_Type__c=opp.businessType;
                 quoteResponse.Funding_Type__c=opp.funding;
                 quoteResponse.Rating_Method__c=opp.ratingMethod;
                 if(opp.singleFamilyInd.equalsIgnoreCase('true')){
                    quoteResponse.Single_Family_Indicator__c='YES';
                 }else{
                    quoteResponse.Single_Family_Indicator__c='NO';//opp.singleFamilyInd;
                 }
                 quoteResponse.Version_Status__c=opp.versionStatus;
                 if(quoteResponse.ResponseToRequest__c ==null){
                   quoteResponse.ResponseToRequest__c=quoteReq.id;
                 }
                 quoteResponse.ResponseToQuote__c=quoteReq.Quote_Name__c;
                 quoteResponse.Admin_Fee_Types__c=opp.adminFeeType;
                 if( quoteResponse.Admin_Fee_Types__c!=null && quoteResponse.Admin_Fee_Types__c.equalsIgnoreCase('Per Capita')){
                    adminSign='$';
                 }else {
                    adminSign='%';
                 }
                 upsert quoteResponse;//
                 
                 //if funding type is ASO/COST/MPP, then is capita otherwise is permium
                
              if(opp.HeronAssociationData!=null && !opp.HeronAssociationData.isEmpty()){
                     
                    integer counter=0;
                    Date todayDt=system.today();
                    string acceSign=null;
                 for(DTOHeronAssociationData asso:opp.HeronAssociationData ){
                       counter++;
                       acceSign='';
                       Quote_Response_Association__c assObj=new Quote_Response_Association__c();
                       assObj.assoRecordIdentifier__c=quoteResponse.id+string.valueOf(todayDt)+asso.associationName+counter;
                       assObj.Name=asso.associationName;
                       assObj.Association_Product__c=asso.associationProduct;
                       assObj.run_type__c=asso.runType;
                       assObj.funding_type__c=opp.funding;
                       assObj.Rate_Effective_Date__c=asso.effectiveDate;
                       assObj.Rate_End_Date__c=asso.endDate;
                       assObj.Projected_Enrollment__c=asso.projectedEnrollment;
                       
                       if(opp.singleFamilyInd!=null && opp.singleFamilyInd.EqualsIgnoreCase('true')){
                              assObj.Projected_Enrollment_Family__c=asso.projectedEnrollmentFamily;
                              assObj.Projected_Enrollment_Single__c=asso.projectedEnrollmentSingle;
                       } else{
                           assObj.Projected_Enrollment__c=asso.projectedEnrollment;
                        }

                        assObj.ASL_Fee_Type__c=asso.aslFeeType;
                        assObj.Access_Fee_Types__c=asso.accessFeeType;
                        
                        if(asso.aslAttachment!=null){
                         assObj.Aggregate_Stop_Loss_Level__c=asso.aslAttachment*100;
                        }
                        assObj.Individual_Stop_Loss_Level__c=asso.islAttachment;
                        assObj.Proposed_Rx_Formulary__c=asso.proposedRxFormulary;
                        assObj.Proposed_Rx_Network__c=asso.proposedRxNetwork;
                        assObj.Proposed_Rx_Pricing__c=asso.proposedRxPricing;
                        if(assObj.Access_Fee_Types__c!=null && assObj.Access_Fee_Types__c.equalsIgnoreCase('Pct_of_ADP')){
                            acceSign='%';
                        }else if(assObj.Access_Fee_Types__c!=null && assObj.Access_Fee_Types__c.equalsIgnoreCase('Per_Capita')){
                            acceSign='$';
                        }
                       system.debug('funding:::: '+quoteResponse.Funding_Type__c);    
           
                   if(quoteResponse.Funding_Type__c.EqualsIgnoreCase('ASO') ||quoteResponse.Funding_Type__c.equalsIgnoreCase('COST')
                      ||quoteResponse.Funding_Type__c.equalsIgnoreCase('MPP')){
                  
                    
                       if(asso!=null && asso.HeronPerCapitaData!=null){
                           system.debug('getting per capita data:'+asso.HeronPerCapitaData);  
                           
                           DTOHeronPerCapitaData cap=asso.HeronPerCapitaData;
                           
                           DTOHeronRates rate=new  DTOHeronRates();
                           list<DTOHeronRatesByTier> rateByTier=new list<DTOHeronRatesByTier>();
                           DTOHeronRates finalUwRate=new DTOHeronRates();
                           list<DTOHeronRatesByTier> finalUwRateByTier=new list<DTOHeronRatesByTier>(); 
                           DTOHeronRates initialReq=new DTOHeronRates();
                           list<DTOheronRatesByTier> initialReqByTier=new list<DTOHeronRatesByTier>();
                                
                                 //final rate
                          if(quoteResponse.Version_Status__c!=null && quoteResponse.Version_Status__c.equalsIgnoreCase('FNL UWTNG REQ')){
                                
                                    rate=cap.soldRates;
                                    rateByTier=cap.soldRatesByTier; 
                                    finalUwRateByTier=cap.finalUnderwritingRequestedRatesByTier; 
                                    finalUwRate=cap.finalUnderwritingRequestedRates;
                                
                                   // initialReqByTier=cap.initialRequestedRatesByTier;
                                   // initialReq=cap.initialRequestedRates;
                                    
                               assObj.RecordTypeId=Schema.SObjectType.Quote_Response_Association__c.getRecordTypeInfosByName().get('Final-Sold Single-Family').getRecordTypeId();
            
                                if(rate!= null){//sold rate
                       
                               //   assObj.illAccessFee_sold__c=rate.ilAccessFee;
                               
                                 if(acceSign!=null && acceSign!=''){
                                    if(acceSign=='%'){
                                     assObj.Illinois_Access_Fee_sold__c=getDemcialFixed(rate.ilAccessFee+acceSign,false);
                                    }else{ //$
                                        
                                         assObj.Illinois_Access_Fee_sold__c=getDemcialFixed(acceSign+rate.ilAccessFee,false);
                                    }
                                 }
                                 
                                 if(rate.hcscAccessFeesPct!=null){
                                  assObj.HCSC_Access_Fee_Percent_sold__c=rate.hcscAccessFeesPct*100;
                                 }
                                  
                                  if(rate.nonHcscAccessFeesPct!=null){
                                   assObj.Non_HCSC_Access_Fee_Percent_sold__c=rate.nonHcscAccessFeesPct*100;
                                  }
                                  assobj.NonStandard_Srvc_OneTime_Charge_sold__c=rate.nonStdSvcOneTimeCharge;
                        
                                  assObj.Commission_sold__c=rate.commission;
                                  assObj.Allocated_Taxes_and_Fee_PCPM_sold__c=rate.allocatedTaxesAndFeePcpm;
                                  assObj.PhysicianServiceFees_Family_sold__c=rate.physicianServiceFeeFamily;
                                  assObj.PhysicianServiceFees_Single_Sold__c=rate.physicianServiceFeeSingle;
                                  assObj.HMOManagedCareFee_sold__c=rate.hMOManagedCareFee;
                                //  assObj.Projected_IL_ADP_sold__c=rate.ilAverageDiscountPercent;
                                  assObj.AHP_fee_sold__c=rate.aHPFee;
                                  if(rate.sharedSavingsPct!=null){
                                  assObj.Shared_Savings_Percent_Sold__c=rate.sharedSavingsPct*100;
                                  }
                                  if(rate.sharedSavingsPctInNetwork!=null){
                                  assObj.Shared_Savings_Percent_In_Network_sold__c=rate.sharedSavingsPctInNetwork*100;
                                  }
                                  
                                  if(rate.sharedSavingsPctOutNetwork!=null){
                                   assObj.Shared_Savings_Pct_Out_Network_sold__c=rate.sharedSavingsPctOutNetwork*100;
                                  }
                                  assObj.Annual_Aggregate_Cap_sold__c=rate.annualAggregateCap;
                                  assObj.Claim_level_Cap_sold__c=rate.claimLevelCap;
                                  
                                  if(rate.guaranteeDiscountPercent!=null){
                                   assObj.Guarantee_Discount_Percent_sold__c=rate.guaranteeDiscountPercent*100;
                                  }
                                  assObj.Total_Fixed_Cost_sold__c=rate.totalFixedCost;
                                  assObj.Blue_Care_Connection_sold__c=rate.blueCareConnection;
                                  
                                  
                                } 
                                
                               if(rateByTier!=null && !rateByTier.isEmpty()){  //sold rate by tier
                                    system.debug('size of RateByTier::::'+rateByTier.size());
                                    for(DTOHeronRatesByTier tier: rateByTier){
                             
                                        if(tier.tierClass!=null && tier.tierClass.equalsIgnoreCase('COMP')){
                                          assObj.RecordTypeId=Schema.SObjectType.Quote_Response_Association__c.getRecordTypeInfosByName().get('Final-Sold Composite').getRecordTypeId();
                                          if(adminSign=='%'){
                                            assObj.Admin_Fee_ByTier_TXT_Comp_sold__c=getDemcialFixed(''+tier.administrativeFee+adminSign,true);
                                          }else{
                                             assObj.Admin_Fee_ByTier_TXT_Comp_sold__c=getDemcialFixed(adminSign+tier.administrativeFee,false);
                                          }
                                          assObj.RxAdministrative_Fee_By_Tier_Sold_C__c=tier.drugAdministrativeFee;
                                          assObj.RxRebate_Credit_ByTier_sold_C__c=tier.drugRebateCredit;
                                          assObj.Individual_StopLoss_Fee_By_Tier_sold_C__c=tier.islFee;
                                          assObj.AggregateStop_Loss_Fee_by_Tier_sold_C__c=tier.aslFee;
                                          assObj.Non_Standard_SVC_Fee_sold_C__c=tier.nonStdSvcFee;
                                          assObj.Average_Claim_Value_ByTier_sold_C__c=tier.averageClaimValue;
                                          assObj.Run_Off_Claim_Liability_ByTier_sold_C__c=tier.runOffClaimLiability;
                                          assObj.Run_Off_AdministrationByTier_sold__c=tier.runOffAdministration;
                                          assObj.Tier_Class__c=tier.tierClass;
                                        }else if(tier.tierClass!=null && tier.tierClass.equalsIgnoreCase('Single')){
                                        
                                        //     assObj.RecordTypeId=Schema.SObjectType.Quote_Response_Association__c.getRecordTypeInfosByName().get('Final-Sold Single-Family').getRecordTypeId();
                                              if(adminSign=='%'){
                                                assObj.Administration_Fee_ByTier_sold_Single__c=getDemcialFixed(''+tier.administrativeFee+adminSign,true);
                                             }else{
                                                assObj.Administration_Fee_ByTier_sold_Single__c=getDemcialFixed(adminSign+tier.administrativeFee,false);
                                            }
                                            assObj.Rx_Admin_Fee_ByTier_Single_sold__c=tier.drugAdministrativeFee;
                                            assObj.Rx_Rebate_Credit_ByTier_Single_sold__c=tier.drugRebateCredit;
                                            assObj.ISL_Fee_ByTier_sold_Single__c=tier.islFee;
                                            assObj.ASL_Fee_ByTier_sold_single__c=tier.aslFee;
                                            assObj.Non_Standard_SVC_Fee_ByTier_sold_single__c=tier.nonStdSvcFee;
                                            assObj.Average_Claim_Value_ByTier_sold_Singl__c=tier.averageClaimValue;
                                            assObj.Run_Off_Claim_Libty_ByTier_Single_sold__c=tier.runOffClaimLiability;
                                            assObj.Run_Off_Admin_ByTier_Single_sold__c=tier.runOffAdministration;
                                            assObj.Tier_Class__c=tier.tierClass;
                                       }else{
                                       //    assObj.RecordTypeId=Schema.SObjectType.Quote_Response_Association__c.getRecordTypeInfosByName().get('Final-Sold Single-Family').getRecordTypeId();
                                              
                                          if(adminSign=='%'){
                                            assObj.Administration_Fee_ByTier_TX_sold__c=getDemcialFixed(tier.administrativeFee+adminSign,true);
                                          }else {
                                              assObj.Administration_Fee_ByTier_TX_sold__c=getDemcialFixed(adminSign+tier.administrativeFee,false);
                                            
                                          }
                                          assObj.Rx_Administrative_Fee_sold__c=tier.drugAdministrativeFee;
                                          assObj.Rx_Rebate_Credit_by_Tier_sold__c=tier.drugRebateCredit;
                                          assObj.Individual_StopLoss_fee_byTier_sold__c=tier.islFee;
                                          assObj.AggregateStopLoss_byTier_sold__c=tier.aslFee;
                                          assObj.Non_Standard_Service_Fee_by_Tier_sold__c =tier.nonStdSvcFee;
                                          assObj.Average_Claim_Value_by_Tier_sold__c=tier.averageClaimValue;
                                          assObj.Run_Off_Claim_Liability_by_Tier_sold__c=tier.runOffClaimLiability;
                                          assObj.Run_Off_AdministrationByTier_sold__c=tier.runOffAdministration;
                                          assObj.Tier_Class__c=tier.tierClass;
                                         
                                       }
                                      
                                    }
                                        system.debug('sold ByTierClass:::::::'+assObj.Tier_Class__c);
                              }//end of soldRateBy
                                    
                          //    }
                             if(finalUwRate!=null){ //final rate
                                 // assObj.illAccessFee_final__c=acceSign+finalUwRate.ilAccessFee;
                                 
                                 if(acceSign!=null && acceSign!=''){
                                     if(acceSign=='%'){
                                        assObj.Illinois_Access_Fee_final__c=getDemcialFixed(finalUwRate.ilAccessFee+acceSign,false);
                                    }else{
                                         assObj.Illinois_Access_Fee_final__c=getDemcialFixed(acceSign+finalUwRate.ilAccessFee,false);
                                    }
                                 }
                                 if(finalUwRate.hcscAccessFeesPct!=null){
                                  assObj.HCSC_Access_Fee_Percent_final__c=finalUwRate.hcscAccessFeesPct *100;
                                  }
                                  
                                  if(finalUwRate.nonHcscAccessFeesPct!=null){
                                  assObj.Non_HCSC_Access_Fee_Percent_final__c=finalUwRate.nonHcscAccessFeesPct*100;
                                  }
                                  assobj.NonStandard_Srvc_OneTime_Charge_final__c=finalUwRate.nonStdSvcOneTimeCharge;
                              
                                  assObj.commission_final__c=finalUwRate.commission;
                                  assObj.Allocated_Taxes_and_Fee_PCPM_final__c=finalUwRate.allocatedTaxesAndFeePcpm;
                                  assObj.PhysicianServiceFees_Family_final__c=finalUwRate.physicianServiceFeeFamily;
                                  assObj.PhysicianServiceFees_Single_final__c=finalUwRate.physicianServiceFeeSingle;
                                  assObj.HMOManagedCareFee_final__c=finalUwRate.hMOManagedCareFee;
                                 // assObj.Projected_IL_ADP_final__c=finalUwRate.ilAverageDiscountPercent;
                                  assObj.AHP_fee_final__c=finalUwRate.aHPFee;
                                  
                                  if(finalUwRate.sharedSavingsPct!=null){
                                  assObj.Shared_Savings_Percent_final__c=finalUwRate.sharedSavingsPct*100;
                                  }
                                  if(finalUwRate.sharedSavingsPctInNetwork!=null){
                                  assObj.Shared_Savings_Percent_In_Network_final__c=finalUwRate.sharedSavingsPctInNetwork*100;
                                  }
                                  
                                  if(finalUwRate.sharedSavingsPctOutNetwork!=null){
                                  assObj.Shared_Savings_Pct_Out_Network_final__c=finalUwRate.sharedSavingsPctOutNetwork*100;
                                  }
                                  assObj.Annual_Aggregate_Cap_final__c=finalUwRate.annualAggregateCap;
                                  assObj.Claim_level_Cap_final__c=finalUwRate.claimLevelCap;
                                  
                                  if(finalUwRate.guaranteeDiscountPercent!=null){
                                  assObj.Guarantee_Discount_Percent_final__c=finalUwRate.guaranteeDiscountPercent*100;
                                  }
                                  assObj.Total_Fixed_Cost_final__c=finalUwRate.totalFixedCost;
                                  assObj.Blue_Care_Connection_final__c=finalUWRate.blueCareConnection;

                                //   assObj.AdministrationFee_final__c= finalUwRateByTier.administrativeFee;
                               }
                               
                           //    assObj.RecordTypeId=Schema.SObjectType.Quote_Response_Association__c.getRecordTypeInfosByName().get('Final-Sold Single-Family').getRecordTypeId();
                               
                                if(finalUwRateByTier!=null && !finalUWRateByTier.isEmpty()){
                                  system.debug('size of finalUWRateByTier:::'+finalUWRateByTier.size());
                                  for(DTOHeronRatesByTier tier: finalUwRateByTier){
                                 
                                      if(tier.tierClass!=null && tier.tierClass.equalsIgnoreCase('COMP')){
                                          assObj.RecordTypeId=Schema.SObjectType.Quote_Response_Association__c.getRecordTypeInfosByName().get('Final-Sold Composite').getRecordTypeId();
                                        
                                          if(adminSign=='%'){
                                            assObj.Admin_Fee_ByTier_TX_Comp_final__c=getDemcialFixed(tier.administrativeFee+adminSign,true);
                                          }else{
                                            assObj.Admin_Fee_ByTier_TX_Comp_final__c=getDemcialFixed(adminSign+tier.administrativeFee,false);
                                            
                                          }
                                          assObj.Rx_Administrative_Fee_ByTier_final_C__c=tier.drugAdministrativeFee;
                                          assObj.Rx_Rebate_Credit_By_Tier_final_C__c=tier.drugRebateCredit;
                                          assObj.Individual_StopLoss_Fee_ByTier_final_C__c=tier.islFee;
                                          assObj.Aggregate_Stop_Loss_Fee_By_Tier_final_C__c=tier.aslFee;
                                          assObj.Non_Standard_SVC_Fee_ByTier_final_C__c=tier.nonStdSvcFee;
                                          assObj.Average_Claim_Value_ByTier_final_C__c=tier.averageClaimValue;
                                          assObj.Run_Off_Claim_Liability_ByTier_final_C__c=tier.runOffClaimLiability;
                                          assObj.Run_Off_Administration_ByTier_final_C__c=tier.runOffAdministration;
                                          assObj.Tier_Class__c=tier.tierClass;
                                          
                                       }else if(tier.tierClass!=null && tier.tierClass.equalsIgnoreCase('Single')){
                                        //   assObj.RecordTypeId=Schema.SObjectType.Quote_Response_Association__c.getRecordTypeInfosByName().get('Final-Sold Single-Family').getRecordTypeId();
                                              
                                          if(adminSign=='%'){
                                             assObj.Administration_Fee_ByTier_final_Single__c=getDemcialFixed(tier.administrativeFee+adminSign,true);
                                          }else{
                                             assObj.Administration_Fee_ByTier_final_Single__c=getDemcialFixed(adminSign+tier.administrativeFee,false);
                                            
                                          }
                                          assObj.Rx_Admin_Fee_ByTier_Single_final__c=tier.drugAdministrativeFee;
                                          assObj.Rx_Rebate_Credit_ByTier_Single_final__c=tier.drugRebateCredit;
                                          assObj.ISL_Fee_ByTier_final_Single__c=tier.islFee;
                                          assObj.ASL_Fee_ByTier_final_Single__c=tier.aslFee;
                                          assObj.Non_Standard_SVC_Fee_ByTier_final_Single__c =tier.nonStdSvcFee;
                                          assObj.Average_Claim_Value_ByTier_final_Single__c=tier.averageClaimValue;
                                          assObj.Run_Off_Claim_Libty_ByTier_Single_final__c=tier.runOffClaimLiability;
                                          assObj.Run_Off_Admin_ByTier_Single_final__c=tier.runOffAdministration;
                                          assObj.Tier_Class__c=tier.tierClass;
                                          
                                       }else{
                                       //    assObj.RecordTypeId=Schema.SObjectType.Quote_Response_Association__c.getRecordTypeInfosByName().get('Final-Sold Single-Family').getRecordTypeId();
                                          
                                          if(adminSign=='%'){
                                             assObj.Administration_Fee_ByTier_TX_final__c=getDemcialFixed(tier.administrativeFee+adminSign,true);
                                          }else{
                                             assObj.Administration_Fee_ByTier_TX_final__c=getDemcialFixed(adminSign+tier.administrativeFee,false);
            
                                          }
                                          assObj.Rx_Administrative_Fee_ByTier_final__c=tier.drugAdministrativeFee;
                                          assObj.Rx_Rebate_Credit_by_Tier_final__c=tier.drugRebateCredit;
                                          assObj.IndividualStopLoss_by_tier_final__c=tier.islFee;
                                          assObj.AggregateStopLoss_byTier_final__c=tier.aslFee;
                                          assObj.Non_Standard_Service_Fee_by_Tier_final__c =tier.nonStdSvcFee;
                                          assObj.Average_Claim_Value_by_Tier_final__c=tier.averageClaimValue;
                                          assObj.Run_Off_Claim_Liability_by_Tier_final__c=tier.runOffClaimLiability;
                                          assObj.Run_Off_Administration_by_Tier_final__c=tier.runOffAdministration;
                                          assObj.Tier_Class__c=tier.tierClass;
                                    }
                                       system.debug('final ByTierClass:::::::'+assObj.Tier_Class__c);       
                                }
                            }
                        }else{
                              //cap initial rate-
                         //  if(cap!=null){
                              initialReqByTier=cap.initialRequestedRatesByTier;
                              initialReq=cap.initialRequestedRates;
                           //   }
                             system.debug('initial Req data::::'+initialReq);
                             system.debug(' initialReqByTier::::'+initialReqByTier);
                             
                              assObj.RecordTypeId=Schema.SObjectType.Quote_Response_Association__c.getRecordTypeInfosByName().get('Initial Single-Family').getRecordTypeId();
                                    
                                if(initialReq!=null){
                                    
                                  if(acceSign!=null && acceSign!=''){
                                     if(accesign=='%'){
                                            assObj.Illinois_Access_Fee_initial__c=getDemcialFixed(initialReq.ilAccessFee+acceSign,false);
                                        }else{
                                            assObj.Illinois_Access_Fee_initial__c=getDemcialFixed(acceSign+initialReq.ilAccessFee,false);
                                        
                                     }
                                  }
                                  if(initialReq.hcscAccessFeesPct !=null){
                                  assObj.HCSC_Access_Fee_Percent_initial__c=initialReq.hcscAccessFeesPct *100;
                                  }
                                  if(initialReq.nonHcscAccessFeesPct!=null){
                                   assObj.Non_HCSC_Access_Fee_Percent_initial__c=initialReq.nonHcscAccessFeesPct*100;
                                  }
                                  assobj.NonStandard_Srvc_OneTime_Charge_initial__c=initialReq.nonStdSvcOneTimeCharge;
                               //   assObj.Commission_pct_initial__c=initialReq.commission;
                                  assObj.Commission_initial__c=initialReq.commission;
                                  assObj.Allocated_Taxes_and_Fee_PCPM_initial__c=initialReq.allocatedTaxesAndFeePcpm;
                                  assObj.PhysicianServiceFees_Family_initial__c=initialReq.physicianServiceFeeFamily;
                                  assObj.PhysicianServiceFees_Single_initial__c=initialReq.physicianServiceFeeSingle;
                                  assObj.HMOManagedCareFee_initial__c=initialReq.hMOManagedCareFee;
                                 // assObj.Projected_IL_ADP_initial__c=initialReq.ilAverageDiscountPercent;
                                  assObj.AHP_fee_initial__c=initialReq.aHPFee;
                                  
                                  if(initialReq.sharedSavingsPct!=null){
                                   assObj.Shared_Savings_Percent_initial__c=initialReq.sharedSavingsPct*100;
                                  }
                                  
                                  if(initialReq.sharedSavingsPctInNetwork!=null){
                                  assObj.Shared_Savings_Pct_In_Network_initial__c=initialReq.sharedSavingsPctInNetwork *100;
                                  }
                                  
                                  if(initialReq.sharedSavingsPctOutNetwork!=null ){
                                    assObj.Shared_Savings_Pct_Out_Network_initial__c=initialReq.sharedSavingsPctOutNetwork *100;
                                  }
                                  assObj.Annual_Aggregate_Cap_initial__c=initialReq.annualAggregateCap;
                                  assObj.Claim_level_Cap_initial__c=initialReq.claimLevelCap;
                                  
                                  if(initialReq.guaranteeDiscountPercent!=null){
                                    assObj.Guarantee_Discount_Percent_initial__c=initialReq.guaranteeDiscountPercent*100;
                                  }
                                  assObj.Total_Fixed_Cost_Initial__c=initialReq.totalFixedCost;
                                  assObj.Blue_Care_Connection_initial__c=initialReq.blueCareConnection;

                                   // assObj.AdministrationFee_initial__c=initialReqByTier.administrativeFee;
                                } 
                                if(initialReqByTier!=null && !initialReqByTier.isEmpty()){
                                 system.debug('size of initialReqByTier:::'+initialReqByTier.size());
                                 for(DTOHeronRatesByTier tier: initialReqByTier){
                                       //DTOHeronRatesByTier tier =initialReqByTier[i];
                                 
                                       if(tier.tierClass!=null && tier.tierClass.equalsIgnoreCase('COMP')){
                                          assObj.RecordTypeId=Schema.SObjectType.Quote_Response_Association__c.getRecordTypeInfosByName().get('Initial Composite').getRecordTypeId();
                                          if(adminSign=='%'){
                                               assObj.Admin_Fee_ByTier_TX_Comp_Initial__c=getDemcialFixed(tier.administrativeFee+adminSign,true);
                                          }else{
                                               assObj.Admin_Fee_ByTier_TX_Comp_Initial__c=getDemcialFixed(adminSign+tier.administrativeFee,false);
                                            
                                          }
                                          assObj.Rx_Administrative_Fee_By_Tier_Initial_C__c=tier.drugAdministrativeFee;
                                          assObj.Rx_Rebate_Credit_By_Tier_initial_C__c=tier.drugRebateCredit;
                                          assObj.Individual_StopLoss_Fee_ByTier_initial_C__c=tier.islFee;
                                          assObj.AggregateStop_Loss_Fee_ByTier_initial_C__c=tier.aslFee;
                                          assObj.Non_Standard_SVC_Fee_ByTier_initial_C__c=tier.nonStdSvcFee;
                                          assObj.Average_Claim_Value_ByTier_Initial_C__c=tier.averageClaimValue;
                                          assObj.Run_Off_Claim_Liability_ByTier_initial_C__c=tier.runOffClaimLiability;
                                          assObj.Run_Off_AdministrationByTier_initial_C__c=tier.runOffAdministration;
                                          assObj.Tier_Class__c=tier.tierClass;
                                       }else if(tier.tierClass!=null && tier.tierClass.equalsIgnoreCase('Single')){
                                      //    assObj.RecordTypeId=Schema.SObjectType.Quote_Response_Association__c.getRecordTypeInfosByName().get('Initial Single-Family').getRecordTypeId();
                                          
                                          if(adminSign=='%'){
                                            assObj.Administration_Fee_ByTier_initial_Single__c=getDemcialFixed(tier.administrativeFee+adminSign,true);
                                          }else{
                                              assObj.Administration_Fee_ByTier_initial_Single__c=getDemcialFixed(adminSign+tier.administrativeFee, false);
                                            
                                          }
                                          assObj.Rx_Admin_Fee_ByTier_initial_Single__c=tier.drugAdministrativeFee;
                                          assObj.Rx_Rebate_Credit_ByTier_initial_Single__c=tier.drugRebateCredit;
                                          assObj.ISL_Fee_ByTier_initial_Single__c=tier.islFee;
                                          assObj.ASL_Fee_ByTier_initial_Single__c=tier.aslFee;
                                          assObj.Non_Std_SVC_Fee_ByTier_initial_Single__c =tier.nonStdSvcFee;
                                          assObj.Ave_Claim_Value_ByTier_initial_Single__c=tier.averageClaimValue;
                                          assObj.RunOff_Claim_Libty_ByTier_initial_Single__c=tier.runOffClaimLiability;
                                          assObj.Run_Off_Admin_ByTier_initial_Single__c=tier.runOffAdministration;
                                          assObj.Tier_Class__c=tier.tierClass;
                                          
                                       }else{
                                       //   assObj.RecordTypeId=Schema.SObjectType.Quote_Response_Association__c.getRecordTypeInfosByName().get('Initial Single-Family').getRecordTypeId();
                                          
                                          if(adminSign=='%'){
                                            assObj.Administration_Fee_ByTier_TX_initial__c=getDemcialFixed(tier.administrativeFee+adminSign,true);
                                          }else{
                                              assObj.Administration_Fee_ByTier_TX_initial__c=getDemcialFixed(adminSign+tier.administrativeFee,false);
                                            
                                          }
                                          assObj.Rx_Administrative_Fee_initial__c=tier.drugAdministrativeFee;
                                          assObj.Rx_Rebate_Credit_by_Tier_initial__c=tier.drugRebateCredit;
                                          assObj.IndividualStopLoss_by_tier_initial__c=tier.islFee;
                                          assObj.AggregateStopLoss_byTier_initial__c=tier.aslFee;
                                          assObj.Non_Standard_Service_Fee_by_Tier_initial__c =tier.nonStdSvcFee;
                                          assObj.Average_Claim_Value_by_Tier_initial__c=tier.averageClaimValue;
                                          assObj.Run_Off_Claim_Liability_by_Tier_initial__c=tier.runOffClaimLiability;
                                          assObj.Run_Off_Administration_by_Tier_initial__c=tier.runOffAdministration;
                                          assObj.Tier_Class__c=tier.tierClass;
                                       }
                                       system.debug('Initial ByTierClass:::::::'+assObj.Tier_Class__c);
                                  }
                              }

                         }//else is initial
                     }//end of cap
               
                 
                  } else {//Premium Data
                  
                    assObj.RecordTypeId=Schema.SObjectType.Quote_Response_Association__c.getRecordTypeInfosByName().get('Premium').getRecordTypeId();
                 
                    if(asso.HeronPremiumData!=null){
                        system.debug('getting premium:'+asso.HeronPremiumData);
                        DTOHeronPremiumData prem=asso.HeronPremiumData;
                       
                       // assObj.RecordTypeId=Schema.SObjectType.Quote_Response_Association__c.getRecordTypeInfosByName().get('Premium').getRecordTypeId();
                        system.debug('record typid: '+ assObj.RecordTypeId);
                        list<DTOHeronPremiumRates> premRateSold=null;//prem.heronSoldPremiumRates;
                        list<DTOHeronPremiumRates> premRateFinal=null;//prem.finalRequestedPremiumRates;
                        list<DTOHeronPremiumRates> premRateInitial=null;//prem.initialRequestedPremiumRates;
                        Quote_Premium_Rates__c premData=null;//new Quote_Premium_Rates__c();
                       
                       if(quoteResponse.Version_Status__c!=null && quoteResponse.Version_Status__c.equalsIgnoreCase('FNL UWTNG REQ')){
                        premRateSold=prem.heronSoldPremiumRates;
                        premRateFinal=prem.finalRequestedPremiumRates;
                        if(premRateSold!=null && !premRateSold.isEmpty()){

                          for(DTOHeronPremiumRates rate:premRateSold){
                            
                            Heron_PremRate_Tier_Mapping__c tierMapping=Heron_PremRate_Tier_Mapping__c.getInstance(rate.tier);
                            
                             premData=new Quote_Premium_Rates__c();
                             premData.RecordTypeId=Schema.SObjectType.Quote_Premium_Rates__c.getRecordTypeInfosByName().get('Premium').getRecordTypeId();
                             
                             premData.Rate_Tier__c=prem.rateTier;
                             premData.Sold_Premium__c=prem.soldPremium;
                             premData.Initial_Requested_Premium__c =prem.initialRequestedPremium;
                             premData.Final_Requested_Premium__c=prem.finalRequestedPremium;
                             premData.Rate_Version__c='Sold';
                             premData.Projected_Rates_sold__c=rate.projectedRates;
                             premData.Contract_Count_sold__c=rate.contractCount;
                     
                            if(tierMapping!=null){
                                //premData.Tier__c=tierMapping.Heron_Tier__c;
                                premData.Tier_sold__c=tierMapping.Heron_Tier__c;
                                premData.Tier_Order_sold__c=tierMapping.order__c;
                            }
                             premData.AssoRecordIdentifier__c=assObj.assoRecordIdentifier__c;
                             premData.Quote_Response_Association__c=assObj.id;
                             premData.name=premData.Tier_sold__c;//premData.Rate_Tier__c;//'Premium Rate '+rate.tier+' '+ premData.Rate_Version__c;
                            
                             premDataUpdateList.add(premData);
                         } 
                        } 
                        if(premRateFinal!=null && !premRateFinal.isEmpty()){
                            for(DTOHeronPremiumRates rate: premRateFinal){
                             Heron_PremRate_Tier_Mapping__c tierMapping=Heron_PremRate_Tier_Mapping__c.getInstance(rate.tier);
                             
                             premData=new Quote_Premium_Rates__c();
                             premData.RecordTypeId=Schema.SObjectType.Quote_Premium_Rates__c.getRecordTypeInfosByName().get('Premium').getRecordTypeId();
                             
                             premData.Rate_Tier__c=prem.rateTier;
                             premData.Sold_Premium__c=prem.soldPremium;
                             premData.Initial_Requested_Premium__c =prem.initialRequestedPremium;
                             premData.Final_Requested_Premium__c=prem.finalRequestedPremium;
                            
                             premData.Rate_Version__c='Final';
                            // premData.Contract_Count__c=rate.contractCount;
                           //  premData.Projected_Rates__c=rate.projectedRates;
                             premData.Projected_Rates_final__c=rate.projectedRates;
                             premData.Contract_Count_final__c=rate.contractCount;
                          
                             if(tierMapping!=null){
                            //  premData.Tier__c=tierMapping.Heron_Tier__c;
                                premData.Tier_Final__c=tierMapping.Heron_Tier__c;
                              premData.Tier_Order_final__c=tierMapping.order__c;
                            }
                             premData.AssoRecordIdentifier__c=assObj.assoRecordIdentifier__c;
                             premData.Quote_Response_Association__c=assObj.id;
                             premData.name=premData.Tier_Final__c;//premData.Rate_Tier__c;
                             
                             premDataUpdateList.add(premData);
                           }
                        }
                       }else{
                        
                        premRateInitial=prem.initialRequestedPremiumRates;
                        if(premRateInitial!=null && !premRateInitial.isEmpty()){

                          assObj.RecordTypeId=Schema.SObjectType.Quote_Response_Association__c.getRecordTypeInfosByName().get('Premium-initial').getRecordTypeId();
                          
                          for(DTOHeronPremiumRates rate: premRateInitial){
                             Heron_PremRate_Tier_Mapping__c tierMapping=Heron_PremRate_Tier_Mapping__c.getInstance(rate.tier);
                            
                             premData=new Quote_Premium_Rates__c();
                             
                             premData.RecordTypeId=Schema.SObjectType.Quote_Premium_Rates__c.getRecordTypeInfosByName().get('Premium-Initial').getRecordTypeId();
                             
                           //  premData.Projected_Conventional_Equivalent_Premiu__c=prem.projectedConventionalEquivalentPremium;
                            // premData.Projected_CE_Equivalent_Premium_current__c=prem.projectedConventionalEquivalentPremiumAtCurrentRates;
                             premData.Rate_Tier__c=prem.rateTier;
                            // premData.Sold_Premium__c=prem.soldPremium;
                             premData.Initial_Requested_Premium__c =prem.initialRequestedPremium;
                            // premData.Final_Requested_Premium__c=prem.finalRequestedPremium;
                             premData.Rate_Version__c='Initial';
                             premData.Projected_Rates_initial__c=rate.projectedRates;
                             premData.Contract_Count_initial__c=rate.contractCount;
                           
                            if(tierMapping!=null){
                            //  premData.Tier__c=tierMapping.Heron_Tier__c;
                                premData.Tier_Initial__c=tierMapping.Heron_Tier__c;
                                premData.Tier_Order_initial__c=tierMapping.order__c;
                            }
                             premData.AssoRecordIdentifier__c=assObj.assoRecordIdentifier__c;
                             premData.Quote_Response_Association__c=assObj.id;
                             premData.name=premData.Tier_Initial__c;//premData.Rate_Tier__c;//'Premium Rate '+rate.tier+' '+ premData.Rate_Version__c;
                              
                             premDataUpdateList.add(premData);
                           }

                        }   
                     }
                     
                  } //end of premium
               }//end of else
                  assObj.AssociatedToQuoteResponse__c=quoteResponse.id;
                  assObj.AssociationToQuoteRequest__c=quoteReq.id;
                  associationList.add(assObj);    
                             
              }// end of association after for loop
                    
            if(associationList!=null && !associationList.isEmpty()){
                insert associationList;
             }
                         
            if( premDataUpdateList!=null && ! premDataUpdateList.isEmpty()){
                    
               InsertHeronPremiumData(premDataUpdateList,quoteReq.id,quoteResponse.id); 
            }
                      
           //update quote request record
                 
           list<Quote> updateQuoteList=[select id, status from Quote where id=:quoteReq.Quote_Name__c];

           Quote updateQuote=new Quote();
           if(updateQuoteList!=null && !updateQuoteList.isEmpty()){
               updateQuote=updateQuoteList[0];
            }
        
         if(quoteResponse.Version_Status__c!=null && quoteResponse.Version_Status__c.equalsIgnoreCase('FNL UWTNG REQ')){
              quoteReq.Intergration_Status__c='Received Final Rate';
              quoteReq.Status__c=System.Label.Quote_Request_Status_Received_Final;//'Received Final';
              quoteReq.Integration_Error_Message__c=null;
              
           //   updateQuote.Status='Pending for Approval';
                    
           }else{
               quoteReq.Status__c=System.Label.Quote_Request_Status_Received_Initial;//'Received Initial';
               quoteReq.Intergration_Status__c='Received Initial Rate';
               quoteReq.Integration_Error_Message__c=null;
               updateQuote.Status='In Process';//update the Quote status
           }
           update updateQuote;
            
           statusObj.statusCode='Ok';
           statusObj.statusMessage='Successfully Received Rate Data from Heron service.';
           quoteReq.Integration_Response_Message__c=statusObj.statusMessage;
           quoteReq.Integration_Error_Message__c=null;
        
        }// end of opp
       } 
            
      }else{
            statusObj.statusCode='Empty Request';
            statusObj.statusMessage='Received Empty Heron Data';
            //return resStatus;
           // throw new Exception ('Received NO Data From Heron Request!');
      } 
    
   }catch (Exception e){
        system.debug('CreateQuoteRateResponse web service exception::'+e+' line:'+e.getLineNumber());
        statusObj.statusCode='Exception';
        statusObj.statusMessage='Salesforece Service Exception, please contact your System Administrator.';
        quoteReq.Integration_Error_Message__c=e.getMessage();
        CreateExceptionLog.insertErrorLog(e, null,null,null,'ApexClass', 'Inbound Call from Heron',null,'QuoteRequestWebServiceHelper.CreateQuoteRateData','high');        
    }
    
    try{
          quoteReq.Received_DateTime__c=system.now();
          quoteReq.Integration_Response_Message__c=statusObj.statusMessage;
          updateReqsList.add(quoteReq);
          update updateReqsList;
          
      }catch (System.DMLException e){
        system.debug(' update quote result exception:'+e+' at line: '+e.GetlineNumber());
       CreateExceptionLog.insertErrorLog(e, null,null,null,'ApexClass', 'update QuoteReq status error',null,'QuoteRequestWebServiceHelper.CreateQuoteRateData','high');        

    }
     return statusObj;//'Successfully';
        
  }


  /*
  * this method is to add the Assocation record id back to it's Heron Premium data.
  */
  @TestVisible
    private static void  InsertHeronPremiumData(list<Quote_Premium_Rates__c> heronPremiumList, Id quoteReqId, Id quoteResponseId){

      Map<string, Id> assoIdMap=new Map<string, Id>();
      
      try{
        list<Quote_Response_Association__c> associationList =[select id,assoRecordIdentifier__c,AssociationToQuoteRequest__c,AssociatedToQuoteResponse__c from Quote_Response_Association__c where AssociationToQuoteRequest__c=:quoteReqId AND AssociatedToQuoteResponse__c=:quoteResponseId];
       
         if(associationList!=null && !associationList.isEmpty()){
          for(Quote_Response_Association__c assoData: associationList){
            assoIdMap.put(assoData.assoRecordIdentifier__c, assoData.id);
          }
        }

        list<Quote_Premium_Rates__c> premiumDataList=new list<Quote_Premium_Rates__c>();

        if(heronPremiumList!=null && !heronPremiumList.isEmpty()){
            for( Quote_Premium_Rates__c prem: heronPremiumList){
               if (assoIdMap.containsKey(prem.AssoRecordIdentifier__c)){
                    if(prem.Rate_Version__c.equalsIgnoreCase('Sold')){
                         prem.Quote_Association_sold__c=assoIdMap.get(prem.AssoRecordIdentifier__c);
                    }else if(prem.Rate_Version__c.equalsIgnoreCase('Final')){
                      prem.Quote_Response_Association__c=assoIdMap.get(prem.AssoRecordIdentifier__c);
                    }else{
                         prem.Quote_Association_Initial__c=assoIdMap.get(prem.AssoRecordIdentifier__c);
                    }
                    premiumDataList.add(prem);
                }
             
           }
          
           if(premiumDataList!=null && !premiumDataList.isEmpty()){
              insert premiumDataList;
           }

        }

       }catch (Exception e){
         system.debug('Insert Heron Premium Data Exception: '+e);
         CreateExceptionLog.insertErrorLog(e, null,null,null,'ApexClass', 'InBound Heron WebService Call',null,'QuoteRequestWebServiceHelper.InsertHeronPremiumData','high');

       }
    }
    
    /**
    **  Delete the assocation record from the reponse
    **/
    @TestVisible
    private static void deleteExistingAssoData(Quote_Response__c alreadyExisting){
      
      try{
        if (alreadyExisting!=null){
          //delete all listed premium if there is any
          
          list<Quote_Premium_Rates__c> premiumList=[select id,Quote_Association_sold__c,Quote_Response_Association__c,  Quote_Association_Initial__c from Quote_Premium_Rates__c where (Quote_Association_sold__c=:alreadyExisting.id OR Quote_Response_Association__c =:alreadyExisting.id OR Quote_Association_Initial__c=:alreadyExisting.id)];  
            
            if(premiumList!=null && !premiumList.isEmpty()){
                delete premiumList;
            }
            
          list<Quote_Response_Association__c> assoList=[select id from Quote_Response_Association__c where AssociatedToQuoteResponse__c=:alreadyExisting.id];
            if(assoList!=null && !assoList.isEmpty()){ 
              delete assoList;
            }
              
        }
      }catch(Exception e){
        CreateExceptionLog.insertErrorLog(e, null,null,null,'ApexClass', 'Delete DML',null,'QuoteRequestWebServiceHelper.deleteExistingAssoData','high');
        system.debug('Exception: '+e);
      } 
    }

/**
** This method is formate the incoming percentage str data with % and change the percentage value with one decimal place when oneDecimalPla is true
**/
 @TestVisible 
 private static String getDemcialFixed(String pctData,boolean oneDecimalPl){
  //  string newdata=null;
    //only keep 1 decimal point
    decimal newPct=0;
    decimal newFee=0;
    
    try{
        if(pctData!=null){
            
            if(pctData.endswith('%')){
            
               newPct=decimal.valueOf(pctData.remove('%')); // remove '%' char'//pctData.substring(1, pctData.length()-1));
               newPct=newPct*100;
        
           // newPct.setScale(1,System.RoundingMode.CEILING);
              if(oneDecimalPl){
                newFee=newPct.setScale(1);
              }else{
                newFee=newPct.setScale(2);
              }
              system.debug('new pct::::'+newFee);
        
              return newFee+'%';
        //syste.debug('new percentage value after cutted 2nd decimal: '+newData);
           // return newData;
           
           }else if(pctData.startswith('$')){
             newPct=decimal.valueOf(pctData.remove('$')); //remove '$'
             newFee=newPct.setScale(2);
       
             return '$'+newFee;
       
          }
          
      }else{
            pctData='';//if null, return blank
      }
    
       return pctData;
        
    }catch (exception e){
        system.debug('Invalid decimial data:'+pctData+ ' exception::::'+e);
        return '';
    }
 }
 
 public class CreateQuoteCustomSettingsException extends Exception {}
  
  @auraEnabled
  public static  Quote_Request_Summary__c  getCurrentQuoteRequest (String quoteReqId){
        
      Quote_Request_Summary__c   quoteReq=new Quote_Request_Summary__c();
      try{
        if(quoteReqId!=null){
            quoteReq=[select id,Request_Effective_Date__c,Sales_Type__c,Account_Name_tx__c,Account_Number__c, Status__c,Request_Description__c from Quote_Request_Summary__c where id=:quoteReqId limit 1];
            
        }
      }catch(Exception e){
          system.debug('exception:::'+e);
      }
        return quoteReq;
    }
}