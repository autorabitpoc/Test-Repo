public class SGR_BengOppFinal implements Queueable, Database.AllowsCallouts{
    private Opportunity oppty;
    private List<Opportunity> newOppRecs;
    public SGR_BengOppFinal(List<Opportunity> opps){
        this.newOppRecs = opps;
        oppty = newOppRecs[0];
        newOppRecs.remove(0);
    }
    
    public void execute(QueueableContext qc){
        //Process the first opportunity from the list and call the webservice.
        SGR_Beng_XML_Response Response = Sgr_Beng_Request.SendRequest(oppty.id, 'FINAL','');
        //Submit this queueable job again with list that excludes the first in the opportunity list.
        if(newOppRecs.size()>0){
            SGR_BengOppFinal OppFinal = new SGR_BengOppFinal(newOppRecs);
            if(!test.isRunningTest()){
            	ID jobId = System.enqueueJob(OppFinal);
            }
        }
    }
}