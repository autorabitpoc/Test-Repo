global class GEMS_RequestResourceController {
    public GEMS_RequestResourceController () {
    }

    webservice static String updateCaseTeam(String caseID ){
    Database.Saveresult[] sr;
    try{
    Case caseRec = [select id,sub_category__c,gems_account_submission_info__c,GEMS_Assign_Resource__c from case where id =:caseID ];
    GEMS_Request_Resource__mdt Requestresource  = [select Case_Team_Role__c from GEMS_Request_Resource__mdt where Business_Area__c = :caseRec.sub_category__c];
    
    String rolename = Requestresource.Case_Team_Role__c;
    
    System.debug('+++rolename++++ '+rolename);
    caseteamrole reqResourceRole =[select id from caseteamrole where name =:rolename];
    //caseteamrole reqResourceRole =[select id from caseteamrole where name ='FSU Membership Analyst'];
    caseteammember insertCaseTeamMember = new caseteammember(teamroleid = reqResourceRole.id,parentid = caseRec.gems_account_submission_info__c,memberid = caseRec.GEMS_Assign_Resource__c   );
    insert insertCaseTeamMember;
    
    caseRec.status = 'Completed';
    update caseRec;
    }

    catch(exception ex){
        
        System.debug('====exception=='+ex.getMessage());
        return ex.getMessage();
    }
    return 'Resources are requested successfully';
    }
}