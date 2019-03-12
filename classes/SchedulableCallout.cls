global class SchedulableCallout implements Schedulable {
    
    public String username;
    public String password;
    public String body;
    public String endpoint;
    public String certificate;
    public String organizationId;
    public List<SObject> sobjects;
    public IQueueable apexJob;
    public String classType;

    public SchedulableCallout(List<SObject> sobjects, String username, String password, 
                                                String body, String endpoint, String certificate, 
                                                                    String organizationId, String type){
        this.sobjects = sobjects;
        this.username = username;
        this.password = password;
        this.body = body;
        this.endpoint = endpoint;
        this.certificate = certificate;
        this.organizationId = organizationId;
        this.classType = type.trim();
    }

    global void execute(SchedulableContext ctx) {
        Type t = Type.forName(classType);
        IQueueable apexJob = (IQueueable)t.newInstance();
        apexJob.setSObject(sobjects);
        System.enqueueJob(apexJob);
    }  
}