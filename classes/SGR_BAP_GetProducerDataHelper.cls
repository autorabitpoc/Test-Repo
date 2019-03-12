//*************************************************************************************
// Name             : SGR_BAP_GetProducerDataHelper.cls
// Description      : This class contains the logic to process response.
// Created By       : Akbar Hussain Salisabgari 
// Created Date     : 12/28/2018
// 
// ************************Version Updates********************************************
// Date             Developer           Description
// -----------------------------------------------------------------------------------
// 12/28/2018       Akbar             SFDC-15963->BAP Webservice 
// ************************************************************************************
public class SGR_BAP_GetProducerDataHelper {
    
    public static SGR_BAP_GetProducerDataResponse generateBAPProducerData(SGR_BAP_GetProducerDataRequest req){
        
        Integer pageSize=2000;
        Integer pageNumber=1;
        String warnMSG=null;
            
        Set<Id> grpAccIds=new Set<Id>();
        List<Account> producerAccList = new List<Account>();
        List<Producer_Group_Association__c> producerGrpAccList = new List<Producer_Group_Association__c>();
        Map<Id, Producer_Group_Association__c> producerGrpAccMap=new Map<Id,Producer_Group_Association__c>();
        Map<Id, Opportunity> oppGrpAccMap=new Map<Id,Opportunity>();
        List<Opportunity> oppList = new List<Opportunity>();
        
        SGR_BAP_GetProducerDataResponse.ProducerData producerDataForResponse;
        List<SGR_BAP_GetProducerDataResponse.ProducerData> producerDataForResponseList=new List<SGR_BAP_GetProducerDataResponse.ProducerData>();
        
        SGR_BAP_GetProducerDataResponse res = new SGR_BAP_GetProducerDataResponse();
        
        FW_Service_Status_Log__c serLog = new FW_Service_Status_Log__c();
        serLog.Name = 'BAP Webservice';
        serLog.StartTime__c = System.now(); 
        
            serLog.RequestBody__c = String.valueOf(req);
                if(req!=null ){  
                        if(req.pageNumber>0){            
                        	pageNumber = req.pageNumber;
                       }
                		if(req.pageSize>0){
                        	pageSize = req.pageSize;
                	}   
                    Integer offSetRecs = (pageNumber-1)*pageSize;
                    res.pageNumber = pageNumber;
                    res.pageSize = pageSize;
                    
                if(String.isNotBlank(req.producerNumber)){
                    String producerNumber =req.producerNumber;
                    res.producerNumber = req.producerNumber;
                    String query = 'SELECT id, Name,Type,Producer_Number__c,RecordType.Name FROM Account WHERE RecordType.Name = \'Producer Account\' AND Type IN(\'Producer\',\'General Agent\',\'Sub Producer\') AND Producer_Number__c = :producerNumber';
                    if(String.isNotBlank(req.producerName)){
                        String producerName = '\'%'+ req.producerName +'%\'';
                        query = query +' AND Name Like'+ producerName;
                    }
                    producerAccList = Database.query(query);
                    //Akbar - 29th Jan E2E fixes - added query to get no of account recs based on producer no
                    res.totalRecords =[SELECT count() FROM Producer_Group_Association__c WHERE Producer_Number__c=:producerNumber AND ( End_Date__c=null OR End_Date__c >Today)];
                    
                    if(producerAccList!=null && producerAccList.size()>0){
                        String id = producerAccList[0].id;
                        
                        String grpAccQuery = 'SELECT Id, Name,Group_Account__c,Group_Account__r.Name, Group_Number__c, Producer_Account__c, Producer_Number__c, Producer_Organization__c, Producer_Type__c, RecordType.Name FROM Producer_Group_Association__c WHERE Producer_Account__c = :id AND Producer_Type__c IN(\'Producer\',\'General Agent\',\'Sub Producer\')';
                        //Akbar - E2E fixes start - commented below if-else condition and added new logic to compare eff date with first and last day of eff date.
                        warnMSG=null;
                        try{
                        	//MM-YYYYY
                        if(req.effectiveDate!=null){
                        	String[] effDtInput=req.effectiveDate.split('/');
                        	
                            if(effDtInput==null || effDtInput.size()==0){//mm/YYYY
                            	effDtInput=req.effectiveDate.split('-');
                            }
                        	if(effDtInput!=null && effDtInput.size()>=2){
                        	     integer mm=Integer.valueOf(effDtInput[0]);
                        	     integer yyyy=Integer.valueOf(effDtInput[1]);
                         	 	Date effectiveDate=Date.newInstance(yyyy,mm,1);
                           	
                           		Date firstDayOfMonth = effectiveDate.toStartOfMonth();//Date.valueOf(req.effectiveDate).toStartOfMonth();
                            	Date lastDayOfMonth = firstDayOfMonth.addDays(Date.daysInMonth(firstDayOfMonth.year(), firstDayOfMonth.month()) - 1);
                             
                                grpAccQuery = grpAccQuery + ' AND Effective_Date__c>=:firstDayOfMonth AND Effective_Date__c<=:lastDayOfMonth';
                       
                        	}
                        	
                         }
                        }catch(Exception e){
                            
                            warnMSG='Invalid Input Effective Date, please check date formate. Search proceeded without matching Input Effective Date.';
                        }
                        grpAccQuery = grpAccQuery + ' AND (End_Date__c = NULL OR END_Date__c>Today)';
                       //Akbar - E2E fixes end
                        if(String.isNotBlank(req.accountName)){
                            String accountName = '\'%'+ req.accountName +'%\'';
                            grpAccQuery = grpAccQuery + ' AND Group_Account__r.Name LIKE' + accountName;
                        }
                        if(String.isNotBlank(req.accountNumber)){
                            String accountNumber = '\'%'+ req.accountNumber +'%\'';
                            grpAccQuery = grpAccQuery + ' AND Group_Account__r.External_Id__c LIKE' + accountNumber;
                        }
                                           
                        producerGrpAccList = Database.query(grpAccQuery);
                        
                        if(producerGrpAccList !=null && producerGrpAccList.size()>0){
                           for(Producer_Group_Association__c producerGrpAsso: producerGrpAccList){
                                 grpAccIds.add(producerGrpAsso.Group_Account__c);
                                 producerGrpAccMap.put(producerGrpAsso.Group_Account__c, producerGrpAsso);
                           }
                           
                           oppList=[SELECT Id, Name, Renewal_Date__c,AccountId,Renewal_Upload_DateTime__c FROM Opportunity WHERE AccountId in:grpAccIds AND Renewal_Date__c >=Today LIMIT :pageSize OFFSET :offSetRecs];
                           
                           if(oppList!=null && oppList.size()>0){
                                for( Opportunity opp:oppList){
                                    oppGrpAccMap.put(opp.accountId, opp);
          
                                }
                            }
                            if(producerGrpAccMap!=null){

                               for(Id grpAccId: producerGrpAccMap.keySet()){
                                   producerDataForResponse=new SGR_BAP_GetProducerDataResponse.ProducerData();
                                   
                                   producerDataForResponse.producerType=producerAccList[0].Type;
                                   if(String.isNotBlank(producerAccList[0].Type) && producerAccList[0].Type.equalsIgnoreCase('General Agent')){
                                      producerDataForResponse.generalAgentName=producerAccList[0].Name;
                                   }
                                   else{ 
                                    producerDataForResponse.producerName=producerAccList[0].Name;
                                  } 
                                   Producer_Group_Association__c  asso=producerGrpAccMap.get(grpAccId);
                                   ProducerDataForResponse.accountNumber=asso.Group_Number__c;
                                   producerDataForResponse.accountName=asso.Group_Account__r.Name;
                             
                                  Opportunity opp=oppGrpAccMap.get(asso.Group_Account__c);

                                  if(opp!=null){
                                     producerDataForResponse.renewalDate=String.valueOf(opp.Renewal_Date__c);
                                     producerDataForResponse.postedDate=String.valueOf(opp.Renewal_Upload_DateTime__c);
                                 }
                                  
                                  producerDataForResponselist.add(producerDataForResponse);
                                      
                               }
                              
                                serLog.Status__c ='Request Process Sucessfully.';
                                serLog.ErrorCode__c = 'Success';
                                res.status = 'Success';
                                res.message = 'Request Process Sucessfully.';
                                if(warnMSG!=null){
                                    res.message=res.message+' WARNING: '+warnMSG;
                                }
                                res.producerData = producerDataForResponselist;
                                
                            }
                        }else{
                            serLog.Status__c ='Request process failed.';
                            serLog.ErrorDescription__c = 'No Group Account found with Producer Number:'+req.producerNumber;
                            serLog.ErrorCode__c = 'Failed';
                            res.status = 'Failed';
                            res.message = 'Request process failed.';
                            res.failureReason = 'No Group Account found with Producer Number:'+req.producerNumber;
                        }
                    }else{
                        serLog.Status__c ='Request process failed';
                        serLog.ErrorDescription__c = 'No Producer  found  with Producer Number :'+req.producerNumber;
                        serLog.ErrorCode__c = 'Failed';
                        res.status = 'Failed';
                        res.message = 'Request process failed';
                        res.failureReason = 'No Producer  found  with Producer Number :'+req.producerNumber;
                    }
                    
                    
                }else{
                    serLog.Status__c ='Request process failed';
                    serLog.ErrorDescription__c = 'Producer Number is not provided from  request.';
                    serLog.ErrorCode__c = 'Failed';
                    res.status = 'Failed';
                    res.message = 'Request process failed';
                    res.failureReason = 'Producer Number is not provided from  request.';
                }

                
    }else{
                serLog.Status__c ='Request process failed';
                serLog.ErrorDescription__c = 'Received request is empty.';
                serLog.ErrorCode__c = 'Failed';
                res.status = 'Failed';
                res.message = 'Request process failed';
                res.failureReason = 'Received request is empty.';
            }
    
            
        serLog.ResponseBody__c = String.valueOf(res);
        if(serLog!=null){
            insert serLog;
        }
        return res;
    }
}