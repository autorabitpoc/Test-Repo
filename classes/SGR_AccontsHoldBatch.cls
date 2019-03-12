global class SGR_AccontsHoldBatch implements Database.Batchable<Sobject> {
    
    global Database.QueryLocator start( Database.BatchableContext BC ){
        
        String Accquery = 'select id,Status__c,hold_end_date__c from account where '
            +'(Status__c = \'Underwriter hold\' AND hold_end_date__c != null AND RecordType.name = \'Group Account\') ';
        
        System.debug('***********'+Accquery);
        return Database.getQueryLocator(Accquery);
        
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        
        try{ 
            list<account> accs = new list<account>(); 
            list<account> fAccs = new List<account>();
            
            System.debug('Executing first line of exe method');
            for(sobject s:scope){
                Account recrds=new Account();
                recrds=(Account)s;
                accs.add(recrds);
                System.debug('**********Account LIST**************'+accs);  
            }
            
            for(account a:accs){
                
                system.debug('********************hold date******'+a.hold_end_date__c.format());
                system.debug('********************date.today()***'+date.today().format());
                if(date.valueof(a.hold_end_date__c) == date.today()){
                    system.debug('********************hold date******'+date.valueof(a.hold_end_date__c));
                    system.debug('********************date.today()***'+date.today());
                    a.Status__c = 'Active';
                    fAccs.add(a);
                }
                
                if(a.hold_end_date__c.format() == date.today().format()){
                    system.debug('********************hold date******'+date.valueof(a.hold_end_date__c));
                    system.debug('********************date.today()***'+date.today());
                    a.Status__c = 'Active';
                    fAccs.add(a);
                }
                
                
                
            }
            update fAccs;
        }
        
        catch(Exception e){
            system.debug('Exception Occured***********************'+e.getStackTraceString());
        }  
    }
    
    
    
    global void finish(Database.BatchableContext BC){
        
    }
}