global class SGRCensusWrapper implements Comparable{

    public SGR_Opportunity_Census__c oppCensus;

    public SGRCensusWrapper(SGR_Opportunity_Census__c oppCensus){
        this.oppCensus = oppCensus;
    }


    global Integer compareTo(Object obj) {
        SGRCensusWrapper compareWrapper = (SGRCensusWrapper)obj;
        if(oppCensus.Subscriber_Number__c != null){
            if(compareWrapper.oppCensus.Subscriber_Number__c != null){
                if(oppCensus.Subscriber_Number__c == compareWrapper.oppCensus.Subscriber_Number__c){
                    if(oppCensus.Membership_Number__c != null){
                        if(compareWrapper.oppCensus.Membership_Number__c != null){
                            return Integer.valueOf(oppCensus.Membership_Number__c - compareWrapper.oppCensus.Membership_Number__c);
                        }
                        return -1;
                    }
                    return (compareWrapper.oppCensus.Membership_Number__c != null ? 1 : 0);
                }
                return Integer.valueOf(oppCensus.Subscriber_Number__c - compareWrapper.oppCensus.Subscriber_Number__c);
            }
            return -1;
        }
        return (compareWrapper.oppCensus.Subscriber_Number__c != null ? 1 : 0);
    }
}