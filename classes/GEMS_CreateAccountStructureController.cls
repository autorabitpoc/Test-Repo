public class GEMS_CreateAccountStructureController {
    
    public GEMS_AccountStructure accStr {get; set;}
    public string saveResult {get; set;}
    
    public list<String> ListGroupNosTrial {
    get
    {
     list<String>ListGroupNosTrial = new list<String>();
    return ListGroupNosTrial;}
    set;}
    public String GroupNoTrial {get; set;}
    
    public PageReference saveGroupNos(){
        ListGroupNosTrial.add(GroupNoTrial);
        System.debug('List of Group Nos. is '+ ListGroupNosTrial);
        return Null;
    }
    
    public Id caseId {get; set;}
    GEMS_AccountStructureHelper helper = new GEMS_AccountStructureHelper();

    public GEMS_CreateAccountStructureController(ApexPages.StandardSetController controller) {

        caseId = ApexPages.currentPage().getParameters().get('caseId');      
        System.debug('CaseId====>'+caseId);        
        if(caseId != null)
            accStr = helper.getAccountStructure(caseId);
    }
    
 
    public PageReference saveAccountStructure(){
        saveResult = helper.saveAccountStructure(accStr);
        if(saveResult != null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, saveResult));
            return Null;
        }
        else
        return new PageReference('/apex/GEMSGenerateAccountStructure?caseId='+caseId);//Or got to 'View Account Structure page'
    }
    
    public PageReference GenerateDocument(){
        return new PageReference('/apex/GEMSAccountStructureDocument');
    }
    
    public PageReference DownloadPDF(){
        return new PageReference('/apex/GEMSAccountStructureTreePDF?caseId='+caseId);
    }
   
    public PageReference gotoCase() {
            return new PageReference('/'+caseId);
    }

}