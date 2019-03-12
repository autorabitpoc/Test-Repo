public class CaseSubmitButtonController {
    private final Case caseObj,caseObj1;
    public string errorMessage {get;set;}
  
    public CaseSubmitButtonController(ApexPages.StandardController stdController) {
        this.caseObj1 = (Case)stdController.getRecord();
        system.debug(caseObj1+'case +++++');
      this.caseObj=[select Status,Medical_Service__c,Prescription_Drug_Service_1000__c,Dental_Service_1000__c,Medical_Management_1000__c,Dental_Guarantees__c,Financial__c,Medical_Guarantees__c,Subject,Prescription_Drug_Guarantees__c,X1000_Optional_Services_PG__c,Benefit_Value_Advisor_ROI__c,Blue_Care_Connection__c,BCC_Elite__c,BCC_Elite_Staffing_Ratio__c,
                      Mercer_Health_Advantage__c,Bypass_Validation__c,Total_Requested_Proposals__c,LGNA_WorkingDays__c,
                      Legal_Name__c,CountLOBRecords__c ,Request_Type_Radius_Page__c,Request_Type_GeoAccess__c,
                      Request_Type_Provider_Counts__c,Standard_Medical_Access_Criteria__c,Provider_Groups__c,
                      NI_Return_Date__c,Business_Justification__c,OwnerId,Record_update_counter__c,Owner_Name__c,
                      Mail_Date_Due_Date__c,Requested_Effective_Date__c,Package_Type__c,Additional_Comments__c,
                      HCSC_Division__c,of_Binders_for_Proposal__c,of_Binders_for_Requestor__c,Delivery_Arrangements__c,Mailing_Street_Address__c,
                      Mailing_City__c,Mailing_State__c,Mailing_Zip__c,Requestor_Name__c,Proposed_Account_Executive__c,
                      FSU_Location__c,Group_Type__c,Current_Carrier__c,Consulting_Firm__c,Total_Contracts_Number__c,RecordTypeId,
                      Network_Designation__c
                      from case where Id=:caseObj1.Id];
    }
    
    
    
    public void CaseSubmitFunction(){
        string recordTypeName = Schema.SObjectType.Case.getRecordTypeInfosById().get(caseObj1.RecordTypeId).getName();
        if(recordTypeName == 'Performance Guarantee'){
            // call the submit button for PG Case. 
            caseSubmitPgRequest();
        }
        if(recordTypeName == 'Network Information'){
            // call the submit Network Information button for Case.
             //system.debug('inside submit if'); 
            caseSubmitNI();
            //system.debug('network'+caseSubmitNI());
            
        }
        if(recordTypeName == 'Private Exchange - Blue Directions' || recordTypeName =='Private Exchange - External'){
            // call the submit Network Information button for Case.
            // system.debug('submit if'); 
            caseSubmitPEBDorPEE();
            //system.debug('PE'+caseSubmitPEBDorPEE());
            
        }
        if(recordTypeName == 'Proposal'){
            ProposalTypeSubmit();
        }
    }
 
    public void CaseSubmitFunctionAddNI(){
        string recordTypeName = Schema.SObjectType.Case.getRecordTypeInfosById().get(caseObj1.RecordTypeId).getName();
        if(recordTypeName == 'Network Information'){
            // call the Add/Edit Proposal NI Type button for case .
             //system.debug('inside submit CaseSubmitFunctionAddNI'); 
            caseSubmitAddorEditNItype();
            //system.debug('network'+caseSubmitAddorEditNItype());
            
        }
    }
    
    public PageReference caseSubmitPgRequest(){
        if(caseObj.Medical_Guarantees__c ==null && caseObj.X1000_Optional_Services_PG__c == null && caseObj.Prescription_Drug_Guarantees__c ==false && caseObj.Dental_Guarantees__c ==false && caseObj.Financial__c == false && caseObj.Benefit_Value_Advisor_ROI__c == false && caseObj.Blue_Care_Connection__c == null && caseObj.BCC_Elite__c == null && caseObj.BCC_Elite_Staffing_Ratio__c == null && caseObj.Mercer_Health_Advantage__c == null){ 
            errorMessage ='Please provide at least one Requested Performance Guarantees data before submitting the performance guarantee case';
        }
        else if 
            (caseObj.Status =='In Progress'  || caseObj.Status=='Internal HCSC SME Review' || caseObj.Status=='Reviewed by SMEs' || caseObj.Status=='Internal HCSC UW Review' || caseObj.Status=='Reviewed by UW' || caseObj.Status=='Withdrawn' || caseObj.Status=='Approved' || caseObj.Status=='Denied'){ 
                system.debug('inside else');
                errorMessage='Performance Guarantee requests can only be submitted when the status is one of the following: new/Submitted/Sent Back for More Info. ';
            }
        
        if(errorMessage == null || errorMessage ==''){
            Group grp;
            if (caseObj.Status!=null && (caseObj.Status=='new' || caseObj.Status=='Inprogress' || caseObj.Status=='Sent Back for More Info')){
                grp =[SELECT Id FROM Group WHERE Name = 'PG Team' and Type = 'Queue' LIMIT 1];
                caseObj.OwnerId=grp.Id;
                caseObj.Id=caseObj1.Id;
                caseObj.Status='Submitted';
                update caseObj;
            }
            PageReference casePage = new PageReference('/'+caseObj.Id);
            system.debug('after at line 70 update'+casePage);
        }
        return null;
    }
    
    public PageReference caseSubmitNI(){
    Boolean passValidation = true;
    system.debug('test inside NI');
        if(caseObj.Total_Requested_Proposals__c == 0 || caseObj.Legal_Name__c == null ){ 
            errorMessage = 'Please fill out the required fields and add Proposal/NI types prior to submission.'; 
             system.debug('suajtha');
            passValidation = false; 
        } 
        if (passValidation == true && caseObj.Request_Type_GeoAccess__c != 0 && caseObj.Standard_Medical_Access_Criteria__c == null ){ 
            errorMessage = 'Standard Medical Access Criteria is required for request type: GeoAccess'; 
            system.debug('inside suajtha');
            passValidation = false; 
        } 
        
        if ( passValidation == true && caseObj.Request_Type_Radius_Page__c != 0 && caseObj.Standard_Medical_Access_Criteria__c == null ){ 
            errorMessage = 'Standard Medical Access Criteria is required for request type: Radius Page'; 
            passValidation = false; 
        } 
        if ( passValidation == true && caseObj.Request_Type_GeoAccess__c != 0 && caseObj.Provider_Groups__c == null ){ 
            errorMessage = 'Provider Groups is required for request type: GeoAccess'; 
            passValidation = false; 
        }
        if (passValidation == true && caseObj.Request_Type_Radius_Page__c != 0 && caseObj.Provider_Groups__c == null){ 
        errorMessage = 'Provider Groups is required for request type: Radius Page'; 
        passValidation = false; 
        } 
        if (passValidation == true && caseObj.Request_Type_Provider_Counts__c != 0 && caseObj.Provider_Groups__c == null){ 
            errorMessage = 'Provider Groups is required for request type: Provider Counts'; 
            passValidation = false; 
        }
        if(passValidation == true && caseObj.Status == 'Assigned'){
        system.debug('else if null update'); 
        Group grp;
        grp=[SELECT Id FROM Group WHERE Name = 'Network Information' and Type = 'Queue' LIMIT 1]; 
        string owner18Id =  grp.id;
        
        if(owner18Id.contains(caseObj.OwnerId)){ 
            errorMessage = 'Error! This case has already been submitted.'; 
            passValidation = false; 
        } 
       }        

        Decimal WorkingDays;
        Date dueDate =null;
        Date todayDate;
        if(passValidation == true && caseObj.NI_Return_Date__c != null && (caseObj.Business_Justification__c== null)){ 
            //system.debug('inside date valida-----');
            dueDate=caseObj.NI_Return_Date__c; 
           // system.debug('dueDate-----'+dueDate);
            todayDate = Date.today(); 
            WorkingDays=caseObj.LGNA_WorkingDays__c;
            //system.debug('test date-------'+WorkingDays);

            if(dueDate >= todayDate){ 
                system.debug('inside to and due date----');
 
                if(WorkingDays< 4){
                    system.debug('inside calhour if---');  //due date is within 4 days 96 hour 
                    errorMessage = 'Please Provide Business Justification. It is required for turnaround time less than 4 days.'; 
                    passValidation = false;    
                } 
            } /*else { 
            system.debug('inside calhour else---'); 
            errorMessage = 'Invalid NI Return Date, please provide future NI Return Date.'; 
            passValidation = false; 
            } */
        }
        if(errorMessage == null || errorMessage ==''){ 
        system.debug('erro not null update'+caseObj.Bypass_Validation__c);
            Group grp;
            grp=[SELECT Id FROM Group WHERE Name = 'Network Information' and Type = 'Queue' LIMIT 1]; 
            caseObj.OwnerId =grp.Id; 
            caseObj.Id = caseObj.Id; 
            caseObj.Status = 'Assigned'; 
           //caseObj.Bypass_Validation__c=true;
            caseObj.Record_update_counter__c = 1;
           system.debug('erro not'+caseObj.Bypass_Validation__c);
           //caseObj.Record_update_counter__c = caseObj.Record_update_counter__c++; 
            update caseObj; 
            return null;
        }  
        return null;
    }
    public PageReference caseSubmitPEBDorPEE(){
    system.debug('test suajtha');
    if(caseObj.CountLOBRecords__c == 0){
     errorMessage= 'You cannot change the Status to Submitted or Assigned if there are no related Blue Directions Product records filled out'; 
     }else {
     //caseObj.Record_update_counter__c = caseObj.Record_update_counter__c + 1; 
     caseObj.Status = 'Submitted';
     update caseObj;
     //system.debug('Update suajtha'+caseObj.Status);
     //system.debug('Update suajtha'+caseObj.Record_update_counter__c);
     }
     return null;
    }
    
     public PageReference caseSubmitAddorEditNItype(){
       set<Id> sId = new set<Id>();
        Group membersId= new Group();
        string recordTypeName = Schema.SObjectType.Case.getRecordTypeInfosById().get(caseObj1.RecordTypeId).getName();
        //System.debug('test Add');
        Id loggedinuser = UserInfo.getUserId();
        //system.debug('today'+loggedinuser);
        membersId=[SELECT (SELECT UserOrGroupId,GroupId,Id FROM GroupMembers) FROM Group where DeveloperName = 'Network_Information']; 
        //system.debug('membersId today'+membersId);
   
        for(GroupMember gm:membersId.GroupMembers){
        //System.debug('insdie for');
        sId.add(gm.UserOrGroupId);
        //System.debug('insdie for'+sId.add(gm.UserOrGroupId));
        System.debug('insdie logged in user'+sId.contains(loggedinuser));
        }
        
        if(recordTypeName == 'Network Information' && caseObj.Status == 'Assigned' &&
            caseObj.Owner_Name__c == 'Network Information' && sId.contains(loggedinuser) == false){
            system.debug('Add or edit if');
            errorMessage ='Only team members can make updates to a case assigned to the team.';
        } else 
        if(recordTypeName == 'Network Information' && caseObj.Status == 'Assigned' &&
            caseObj.Owner_Name__c != 'Network Information' && sId.contains(loggedinuser) == false){
           system.debug('edit if');
            errorMessage ='Only team members can make updates to an assigned case.';
        } else
         {
          system.debug('Add or edit else');
        }
       return null;
    }
     public PageReference ProposalTypeSubmit(){
        Group GroupId= new Group();
        if((caseObj.Mail_Date_Due_Date__c != null)
           && (caseObj.Requested_Effective_Date__c != null) 
           && (caseObj.HCSC_Division__c != null) 
           && (caseObj.of_Binders_for_Proposal__c != null) 
           && (caseObj.of_Binders_for_Requestor__c != null) 
           && (caseObj.Delivery_Arrangements__c != null) 
           && (caseObj.Mailing_Street_Address__c != null) 
           && (caseObj.Mailing_City__c != null) 
           && (caseObj.Mailing_State__c != null) 
           && (caseObj.Mailing_Zip__c != null) 
           && (caseObj.Requestor_Name__c != null) 
           && (caseObj.Proposed_Account_Executive__c != null) 
           && (caseObj.FSU_Location__c != null) 
           && (caseObj.Group_Type__c != null) 
           && (caseObj.Current_Carrier__c != null) 
           && (caseObj.Consulting_Firm__c != null) 
           && (caseObj.Total_Contracts_Number__c != null) 
           && (caseObj.Package_Type__c != null) 
           && (caseObj.Network_Designation__c != null) 
           && (caseObj.Status != null) 
           && (caseObj.Additional_Comments__c != null) 
           
          ) {
              GroupId = [SELECT id,DeveloperName FROM Group where DeveloperName = 'Proposal_Delivery_Unit' LIMIT 1];
              caseObj.OwnerId = GroupId.Id;
              caseObj.Status = 'Assigned';
              caseObj.Record_update_counter__c = + 1; 
              update caseObj;
              PageReference casePage = new PageReference('/'+caseObj.Id);
          }
        else{
            errorMessage= 'Please edit the record and make sure all required fields have data!'; 
        }
        return null;
    }
}