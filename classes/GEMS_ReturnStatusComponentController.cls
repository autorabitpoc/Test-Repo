/**************************************************************************************
  Apex Class Name     : GEMS_ReturnStatusComponentController
  Version             : 1.0
  Function            : Utility Class to update the Return Status for the Form SBC/BB.
                      : If any other object need to use Return Reason Object please refer this class to add and one more else if in the constructor and save status method.
  Modification Log    :
* Developer           :Date              Description
* ----------------------------------------------------------------------------                 
* Gokul Bharati        08/21/2017            Original Version
*************************************************************************************/
public class GEMS_ReturnStatusComponentController
{
    public GEMS_ReturnStatusComponentController() {
        objectId=ApexPages.currentPage().getParameters().get('Id');
        objectName=string.valueOf(objectId.getsObjectType());
        if(objectName == 'GEMS_SBC_BB_Form__c'){
          recordTypeId = Schema.SObjectType.GEMS_Return_Reason__c.getRecordTypeInfosByName().get('GEMS Form Return Reason').getRecordTypeId(); 
          returnreasonRec = new GEMS_Return_Reason__c(recordTypeId =recordTypeId);
          statusPickList = getMyOptions(); 
          returnReasonList = [SELECT ID, Name,SBC_BB_Form__c,Process_Name__c, GEMS_Type__c, GEMS_Sub_Type__c, Return_Reason__c, GEMS_Comments__c FROM GEMS_Return_Reason__c where SBC_BB_Form__c=: objectId]; 
        }
    }
    
    public string recordTypeId{get;set;}
    public List<GEMS_Return_Reason__c> returnReasonList{get;set;}
    public List<SelectOption> statusPickList{get;set;}
    public GEMS_Return_Reason__c returnreasonRec{set;get;}
    public Boolean displayReturnReason{get;set;}
    public String selectedStatus{get;set;}
    public Id objectId{get;set;}
    public string objectName{get;set;}
    
    
    public List<SelectOption> getMyOptions()
    {    
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--Select--'));
        options.add(new SelectOption('Return', 'Return'));      
        return options;
    }
    
    public void addRow()
    {
        returnReasonList.add(returnreasonRec);
        if(objectName == 'GEMS_SBC_BB_Form__c'){       
           returnreasonRec = new GEMS_Return_Reason__c(SBC_BB_Form__c= objectId,recordTypeId =recordTypeId);
        }
    }
    
    public void showReturnReasonBlock()
    {
        if(selectedStatus == 'Return')
        {
            displayReturnReason = true;        
        }
        else if(selectedStatus == 'Routed In Error') 
        {
            displayReturnReason = false;
        }
        else
        {
            displayReturnReason = false;
        }     
        System.debug('-----called---');
    }
    
    public pagereference saveStatus() 
    {
        List<GEMS_Return_Reason__c> returnReasonsToBeInserted = new List<GEMS_Return_Reason__c>();
        try{
            if(objectId!= null )
            {
                for(GEMS_Return_Reason__c rejectReason : returnReasonList)
                {
                    if(rejectReason.id == null) 
                    {
                        GEMS_Return_Reason__c rrr = new GEMS_Return_Reason__c(GEMS_Sub_Type__c = rejectReason.GEMS_Sub_Type__c,Process_Name__c = rejectReason.Process_Name__c,GEMS_Type__c = rejectReason.GEMS_Type__c,Return_Reason__c = rejectReason.Return_Reason__c, SBC_BB_Form__c=objectId);    
                        returnReasonsToBeInserted .add(rrr);
                    }
                }
                
                if(returnReasonsToBeInserted .isEmpty())
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please add Return Reasons when Return is selected'));
                }
                
                else if(!returnReasonsToBeInserted.isEmpty()) 
                {
                    insert returnReasonsToBeInserted;
                    
                    if(objectName == 'GEMS_SBC_BB_Form__c'){
                        GEMS_SBC_BB_Form__c sbcbb= [select id,form_status__c,ownerId,Submitter__c from GEMS_SBC_BB_Form__c where id =:objectId];
                    
                        if(selectedStatus =='Return') 
                        {
                            sbcbb.form_status__c='Return';
                            sbcbb.Returned_User_ID__c=sbcbb.OwnerId;
                            sbcbb.OwnerId=sbcbb.Submitter__c;    
                            update sbcbb;
                        }
                    }
                }           
            }
        }
        catch(Exception ex){
          CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_ReturnStatusComponentController.saveStatus()','High');              
        }   
        System.debug('----End saveStatusMethod-----');
        if(returnReasonsToBeInserted.isEmpty())
        {
            return null;
        }
        else if(!returnReasonsToBeInserted.isEmpty())
        {
            return new Pagereference('/'+objectId);
        }
        return null;
    }
    
    public void setSelectedStatus() 
    {
        
    }
    
    public pagereference cancel()
    {
        return new Pagereference('/'+objectId);
    }
}