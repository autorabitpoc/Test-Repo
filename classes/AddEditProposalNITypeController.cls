/**************************************************************************************
Apex Class Name     : AddEditProposalNITypeController
Version             : 1.0
Function            : This class handles the logic to choose the proposal/NI type and # of each type requested.
Created By          : Al-Que Quiachon 6/8/2016
*************************************************************************************/

public class AddEditProposalNITypeController {
    public Case cases;
    public Request_Type__c srtc;
    public proposalNIWrapper del;
    public List<Request_Type__c> delRequestTypeList {get; set;}
    public List<Request_Type__c> requestTypeList {get; set;}
    public List<proposalNIWrapper> proposalNIWrappers {get; set;}
    public RequestTypeDAO rtdao {get; set;}
    public List<PROPOSAL_NI_TYPE__mdt> currentRT {get; set;}
    public List<Request_Type__c> currentRTs {get; set;}
    
    public AddEditProposalNITypeController(ApexPages.StandardController controller) {
        
        rtdao = new RequestTypeDAO();
        cases = (Case)controller.getRecord();
        requestTypeList = new List<Request_Type__c>();
        delRequestTypeList = new List<Request_Type__c>();
        proposalNIWrappers = new List<proposalNIWrapper>();
        currentRTs = rtdao.getRequestTypes(cases.id);
        currentRT = rtdao.getRequestType(cases.id);
        Decimal Requested;
        for (PROPOSAL_NI_TYPE__mdt rt : currentRT) {
            Requested = null;
            for(Request_Type__c rts: currentRTs){
                if(rts.Proposal_NI_Type__c == rt.Proposal_NI_Type__c){
                    Requested = rts.number_of_requests__c;
                    proposalNIWrappers.add(new ProposalNIWrapper(Requested, rt, 0));
                    break;
                }
            }
        }
        for (PROPOSAL_NI_TYPE__mdt rtm : currentRT) {
            Requested = null;
            boolean rtmexists = false;
            for(Request_Type__c rts: currentRTs){
                if(rts.Proposal_NI_Type__c == rtm.Proposal_NI_Type__c){
                    rtmexists = true;
                    break;
                }
            }
            if(!rtmexists){
                proposalNIWrappers.add(new ProposalNIWrapper(Requested, rtm, 0));                
            }
        }
    }
    public PageReference save() {
        for (ProposalNIWrapper wrapper : proposalNIWrappers) {
            boolean sRequest = false;
            boolean sExists = false;
            Request_Type__c rta = new Request_Type__c();
            Request_Type__c rtd = new Request_Type__c();
            if (wrapper.Requested != 0) {
                if(currentRTs.size() > 0){
                    for(Request_Type__c rts : currentRTs){
                        if(wrapper.requestTypeObj.Proposal_NI_Type__c == rts.Proposal_NI_Type__c){
                            if(wrapper.Requested != rts.number_of_requests__c){
                                rta.Id = rts.Id;
                                sExists = true;
                            }
                            else{
                                sRequest = true;
                            }
                            break;
                        }
                    }
                }
                if(sRequest == false){
                    if(sExists == false){
                        rta.Case__c = cases.id;
                        rta.Proposal_NI_Type__c = wrapper.requestTypeObj.Proposal_NI_Type__c;
                    }
                    rta.number_of_requests__c = wrapper.Requested;
                    requestTypeList.add(rta);
                }
            }
        }
        for (ProposalNIWrapper wrapper : proposalNIWrappers) {
            Request_Type__c rta = new Request_Type__c();
            Request_Type__c rtd = new Request_Type__c();
            if (wrapper.Requested == 0) {
                for(Request_Type__c srts : currentRTs){
                    if(wrapper.requestTypeObj.Proposal_NI_Type__c == srts.Proposal_NI_Type__c){
                        rtd.Id = srts.Id;
                        delRequestTypeList.add(rtd);
                        break;
                    }
                }
            }
        }
        if(requestTypeList.size()>0){rtdao.upsertRequestType(requestTypeList);}
        if(delRequestTypeList.size()>0){rtdao.deleteRequestType(delRequestTypeList);}
        //PageReference newurl=new PageReference('/'+cases.id);
        PageReference newurl = new ApexPages.StandardController(cases).view();
        newurl.setRedirect(true);
        //return (new ApexPages.StandardController(cases)).view();
        return newurl;
    }
    /**
* @Class:ProposalNIWrapper()
* @description: A wrapper class to keep track of proposals/NI.
*/
    public class ProposalNIWrapper {
        public Decimal Requested  { get; set; }
        public PROPOSAL_NI_TYPE__mdt requestTypeObj { get; set;}
        public Integer numberRequested { get; set;}
        
        public ProposalNIWrapper(Decimal Requested, PROPOSAL_NI_TYPE__mdt requestTypeObj, Integer numberRequested) {
            this.Requested = Requested;
            this.requestTypeObj = requestTypeObj;
            this.numberRequested = numberRequested;
        }
    }
}