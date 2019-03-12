public class SGRCensusWidgetLtngController {

    /*public static SGR_OpportunityActiveBAWrapper getCoverageTypesList(Id oppId){
        Set<String> coverageTypeset = new Set<String>();
        SGR_OpportunityActiveBAWrapper returnWrapper = new SGR_OpportunityActiveBAWrapper();
        for(SGR_Opportunity_Plan_Rate__c planRate : [
                SELECT Id, Opportunity__r.HCSC_Division__c, Coverage_Type__c
                FROM SGR_Opportunity_Plan_Rate__c
                WHERE Group_Section__r.Benefit_Agreement_Cancel_Date__c > TODAY AND Opportunity__c = :oppId]){
            returnWrapper.division = planRate.Opportunity__r.HCSC_Division__c;
            coverageTypeset.add(planRate.Coverage_Type__c);
        }
        returnWrapper.coverageList = new List<String>(coverageTypeset);
        return returnWrapper;
    }*/

    @AuraEnabled
    public static Map<String, Boolean> getEditCapabilitiesMap(Id oppId){
        Map<String, Boolean> returnMap = new Map<String, Boolean>();
        returnMap.put('Health', false);
        returnMap.put('Dental', false);
        returnMap.put('Vision', false);
        User currentUser = SGR_TriggerRenewal.getloggedinuserinfo();
        if(currentUser.Profile.Name == 'System Administrator' || currentUser.Profile.Name == 'SGR Actuary User' ||
                currentUser.Profile.Name == 'SGR UW User'){
            Opportunity opp = [
                    SELECT Id, Rating_Status__c, HCSC_Division__c
                    FROM Opportunity
                    WHERE Id = :oppId];
            if(opp.Rating_Status__c == 'Sold' || opp.Rating_Status__c == 'Underwriting-Released' ||
                    opp.Rating_Status__c == 'Marketing Release' || opp.Rating_Status__c == 'Finalized' ||
                    opp.Rating_Status__c == 'Closed'){
                returnMap.put('Health', true);
                returnMap.put('Dental', true);
                returnMap.put('Vision', true);
            }else{
                returnMap.put('Health', false);
                returnMap.put('Dental', false);
                returnMap.put('Vision', true);
            }
        }else{
            returnMap.put('Health', true);
            returnMap.put('Dental', true);
            returnMap.put('Vision', true);
        }
        return appendTabCapabilities(returnMap, oppId);
    }

    @AuraEnabled
    public static Opportunity getOpportunity(Id oppId){
        List<Opportunity> oppList = [
                SELECT Id, Rating_Status__c, CurrentUserProfileName__c, Renewal_Date__c, HCSC_Division__c
                FROM Opportunity
                WHERE Id = :oppId];
        return (oppList.isEmpty() ? null : oppList[0]);
    }

    @AuraEnabled
    public static List<SGR_Opportunity_Census__c> getCensusListForOpportunity(Id oppId){
        if(cleanData(oppId)){
            List<SGR_Opportunity_Census__c> returnList = getAllCensusRecords(oppId);
            return (returnList.isEmpty() ? null : returnList);
        }
        return null;
    }

    @AuraEnabled
    public static List<SGR_Country_State_Mapping__c> getStateList(){
        return [SELECT Name, State_Code__c FROM SGR_Country_State_Mapping__c ORDER BY State_Code__c];
    }

    @AuraEnabled
    public static List<SGRPlanInfoWrapper> fetchAllPlanData(Id oppId){
        List<SGRPlanInfoWrapper> returnList = new List<SGRPlanInfoWrapper>();
        for(SGR_Opportunity_Benefit_Agreement__c oppBenAgree : [SELECT Id, Marketing_Plan_ID_13__c, Line_of_Business__c, (SELECT Id, Opportunity_Group_Section__c FROM Opportunity_BA_GS_Assignments__r) FROM SGR_Opportunity_Benefit_Agreement__c WHERE Opportunity__c = :oppId]){
            if(oppBenAgree.Marketing_Plan_ID_13__c != null && oppBenAgree.Marketing_Plan_ID_13__c.length() > 0){
                SGRPlanInfoWrapper tempWrapper = new SGRPlanInfoWrapper();
                tempWrapper.planId = oppBenAgree.Marketing_Plan_ID_13__c;
                tempWrapper.planType = oppBenAgree.Line_of_Business__c;
                Set<Id> baGsIds = new Set<Id>();
                for(Opportunity_BA_GS_Assignment__c baGsOpp : oppBenAgree.Opportunity_BA_GS_Assignments__r){
                    baGsIds.add(baGsOpp.Id);
                }
                if(!baGsIds.isEmpty()){
                    tempWrapper.groupInfoList = [SELECT Id, Opportunity_Group_Number__c, Opportunity_Group_Section_Number__c FROM SGR_Opportunity_Group_Section__c WHERE Id IN (SELECT Opportunity_Group_Section__c FROM Opportunity_BA_GS_Assignment__c WHERE Id IN :baGsIds)];
                }
                returnList.add(tempWrapper);
            }
        }
        return returnList;
    }

    @AuraEnabled
    public static Boolean isDeleteDisabled(Opportunity opty){
        String sRatingStatus = opty.Rating_Status__c;
        User currentUser = SGR_TriggerRenewal.getloggedinuserinfo();
        System.debug('++++currentUser--'+currentUser);
        if(currentUser.Profile.Name == 'System Administrator' || currentUser.Profile.Name == 'SGR Actuary User' || currentUser.Profile.Name == 'SGR UW User'){
            if(sRatingStatus == 'Sold' || sRatingStatus == 'Underwriting-Released' || sRatingStatus == 'Marketing Release' || sRatingStatus == 'Finalized' || sRatingStatus == 'Closed'){
                return true;
            }
            return false;
        }
        return true;
    }

    @AuraEnabled
    public static Boolean saveCensus(SGR_Opportunity_Census__c subOppCensus, SGR_Opportunity_Census__c depOppCensus, List<SGR_Opportunity_Census__c> allOppCensusList, Opportunity oppRecord, String tabId){
        if(depOppCensus != null){
            if(depOppCensus.Id != null){
                Database.SaveResult sr = Database.update(depOppCensus);
                return sr.isSuccess();
            }else{
                return insertOppCensusDependant(allOppCensusList, depOppCensus, subOppCensus, oppRecord, tabId);
            }
        }else if(subOppCensus.Id != null){
            Database.SaveResult sr = Database.update(subOppCensus);
            return sr.isSuccess();
        }
        return insertOppCensusSubscriber(subOppCensus, oppRecord, tabId);
    }

    public static Boolean deleteCensus(List<SGR_Opportunity_Census__c> censusDeleteList, List<SGR_Opportunity_Census__c> allOppCensusList, String tabId){
        List<SGR_Opportunity_Census__c> updateList = new List<SGR_Opportunity_Census__c>();
        List<SGR_Opportunity_Census__c> deleteList = new List<SGR_Opportunity_Census__c>();
        List<SGR_Opportunity_Census__c> depOnlyList = new List<SGR_Opportunity_Census__c>();
        for(SGR_Opportunity_Census__c oppCensus : censusDeleteList){
            if(oppCensus.Relationship__c != null){
                if(oppCensus.Relationship__c.equalsIgnoreCase('subscriber')){
                    List<SGR_Opportunity_Census__c> tempDepList = extractDependants(allOppCensusList, oppCensus);
                    if(tabId == 'health'){
                        if(oppCensus.Dental_Plan_ID__c == null || oppCensus.Dental_Plan_ID__c.length() == 0){
                            deleteList.add(oppCensus);
                            if(tempDepList != null && !tempDepList.isEmpty()){
                                deleteList.addAll(tempDepList);
                            }
                        }else{
                            oppCensus.Health_Plan_ID__c = '';
                            oppCensus.Vision_Plan_ID__c = '';
                            if(tempDepList != null && !tempDepList.isEmpty()){
                                List<SGR_Opportunity_Census__c> tierUpdateList = new List<SGR_Opportunity_Census__c>();
                                for(SGR_Opportunity_Census__c tempDepCensus : tempDepList){
                                    tempDepCensus.Health_Plan_ID__c = '';
                                    tempDepCensus.Vision_Plan_ID__c = '';
                                    tierUpdateList.add(tempDepCensus);
                                    updateList.add(tempDepCensus);
                                }
                                updateList.add(genTierUpdate(tierUpdateList, oppCensus));
                            }else{
                                updateList.add(oppCensus);
                            }
                        }
                    }else{
                        if(oppCensus.Health_Plan_ID__c == null || oppCensus.Health_Plan_ID__c.length() == 0){
                            deleteList.add(oppCensus);
                            if(tempDepList != null && !tempDepList.isEmpty()){
                                deleteList.addAll(tempDepList);
                            }
                        }else{
                            oppCensus.Dental_Plan_ID__c = '';
                            if(tempDepList != null && !tempDepList.isEmpty()){
                                List<SGR_Opportunity_Census__c> tierUpdateList = new List<SGR_Opportunity_Census__c>();
                                for(SGR_Opportunity_Census__c tempDepCensus : tempDepList){
                                    tempDepCensus.Dental_Plan_ID__c = '';
                                    tierUpdateList.add(tempDepCensus);
                                    updateList.add(tempDepCensus);
                                }
                                updateList.add(genTierUpdate(tierUpdateList, oppCensus));
                            }else{
                                updateList.add(oppCensus);
                            }
                        }
                    }
                }else{
                    depOnlyList.add(oppCensus);
                }
            }
        }
        if(!depOnlyList.isEmpty()){
            for(SGR_Opportunity_Census__c oppCensus: depOnlyList){
                if(!censusInList(deleteList, oppCensus) && !censusInList(updateList, oppCensus)){
                    if(tabId == 'health'){
                        if(oppCensus.Dental_Plan_ID__c == null || oppCensus.Dental_Plan_ID__c.length() == 0){
                            deleteList.add(oppCensus);
                        }else{
                            oppCensus.Health_Plan_ID__c = '';
                            oppCensus.Vision_Plan_ID__c = '';
                            updateList.add(oppCensus);
                        }
                    }else{
                        if(oppCensus.Health_Plan_ID__c == null || oppCensus.Health_Plan_ID__c.length() == 0){
                            deleteList.add(oppCensus);
                        }else{
                            oppCensus.Dental_Plan_ID__c = '';
                            updateList.add(oppCensus);
                        }
                    }
                }
            }
        }
        if(!deleteList.isEmpty()){
            try{
                delete deleteList;
            }catch(DmlException e){
                return false;
            }
        }
        return true;
    }


    @AuraEnabled
    public static Map<String, string> deleteOptyCensus(list<ID> optyCensusIds, string planType){
        planType = planType.toLowerCase();
        Map<String, string> value = new Map<String, string>();
        try{
            List<SGR_Opportunity_Census__c> delCensus = new List<SGR_Opportunity_Census__c>();
            List<SGR_Opportunity_Census__c> updCensus = new List<SGR_Opportunity_Census__c>();
            List<SGR_Opportunity_Census__c> SubscriberCensus = new List<SGR_Opportunity_Census__c>();
            Set<String> subscriberNums = new Set<String>();
            Set<String> subscriberOnly = new Set<String>();
            String optyId;
            Boolean deleteFlag = true;
            system.debug('++++optyCensusIds--'+optyCensusIds);
            value.put('Warning', System.label.Sgr_Select_Dependent);
            List<SGR_Opportunity_Census__c> lstOptyCensus = [select id, name, Relationship__c,Subscriber_Number1__c, opportunity__r.Id,Health_Plan_ID__c,Vision_Plan_ID__c,Dental_Plan_ID__c from SGR_Opportunity_Census__c where id IN :optyCensusIds];
            if(lstOptyCensus.size() > 0){
                system.debug('++++optyCensusIds.size--'+optyCensusIds.size());
                optyId = lstOptyCensus[0].opportunity__r.Id;
                for(SGR_Opportunity_Census__c optyCen : lstOptyCensus){
                    if(optyCen.Relationship__c != 'Subscriber'){
                        system.debug('++++optyCen.Subscriber_Number1__c--'+optyCen.Subscriber_Number1__c);
                        subscriberNums.add(optyCen.Subscriber_Number1__c);
                        deleteFlag = true;
                        if(subscriberNums.size() > 1){
                            system.debug('subscriberNums--'+subscriberNums);
                            value = new Map<String, string>();
                            value.put('Error', System.label.Sgr_Dependents_belonging_to_same_subscriber);
                            deleteFlag = false;
                            break;
                        }
                    }
                    else{
                        subscriberOnly.add(optyCen.Subscriber_number1__c);
                        system.debug('++++subscriberOnly--'+subscriberOnly);
                        deleteFlag = true;
                    }
                }
                if(deleteFlag){
                    if(subscriberOnly.size()==0){
                        for(SGR_Opportunity_Census__c census: lstOptyCensus){
                            if(planType == 'health' && (census.Dental_Plan_ID__c == null || census.Dental_Plan_ID__c == '')){

                                delCensus.add(census);
                                system.debug('++++delCensus--'+delCensus);
                            }
                            else if(planType == 'health' && (census.Dental_Plan_ID__c != null && census.Dental_Plan_ID__c != '')){
                                system.debug('++++census.Dental_Plan_ID__c'+census.Dental_Plan_ID__c);
                                census.Health_Plan_ID__c = '';
                                census.Vision_Plan_ID__c = '';
                                updCensus.add(census);
                                //updateSubscriberTier(subscriberNums, 'H');
                            }else if(planType == 'dental' && (census.Health_Plan_ID__c == null || census.Health_Plan_ID__c == '') && (census.Vision_Plan_ID__c == null || census.Vision_Plan_ID__c == ''))
                                delCensus.add(census);
                            else{
                                census.Dental_Plan_ID__c = '';
                                updCensus.add(census);
                                //updateSubscriberTier(subscriberNums, 'D');
                            }
                        }
                    }
                    else{
                        SubscriberCensus = [select id, name, Relationship__c,Subscriber_Number1__c, opportunity__r.Id,Health_Plan_ID__c,Vision_Plan_ID__c,Dental_Plan_ID__c from SGR_Opportunity_Census__c where Subscriber_Number1__c IN :subscriberOnly];//opportunity__r.Id = optyId
                        subscriberNums.clear();
                        for(SGR_Opportunity_Census__c census: SubscriberCensus){
                            if(planType == 'health' &&  (census.Dental_Plan_ID__c == '' || census.Dental_Plan_ID__c == null)){
                                delCensus.add(census);
                            }
                            else if(planType == 'health' &&  (census.Dental_Plan_ID__c != '' && census.Dental_Plan_ID__c != null)){
                                census.Health_Plan_ID__c = '';
                                census.Vision_Plan_ID__c = '';
                                updCensus.add(census);
                                subscriberNums.add(census.Subscriber_Number1__c);
                            }
                            else if(planType == 'dental' && (census.Health_Plan_ID__c == '' || census.Health_Plan_ID__c == null) && (census.Vision_Plan_ID__c == '' || census.Vision_Plan_ID__c == null))
                                delCensus.add(census);
                            else {
                                census.Dental_Plan_ID__c = '';
                                updCensus.add(census);
                                subscriberNums.add(census.Subscriber_Number1__c);
                            }
                        }
                    }
                    if(delCensus.size()>0){
                        system.debug('++++delCensus.size()'+delCensus.size());
                        delete delCensus;
                    }
                    if(updCensus.size()>0){
                        system.debug('++++updCensus.size()'+updCensus.size());
                        update updCensus;

                    }
                    if(planType == 'Health'){
                        system.debug('++++planType'+planType);
                        updateSubscriberTier(subscriberNums, 'H',optyId);
                    }
                    else{
                        system.debug('++++planType'+planType);
                        updateSubscriberTier(subscriberNums, 'D',optyId);
                    }

                    value = new Map<String, string>();
                    value.put('Success', System.label.Sgr_deleted_successful);
                    Opportunity opty = [select Id, Rating_Status__c  from Opportunity where Id = :optyId];
                    if(opty.Rating_Status__c != 'Pended'){
                        opty.Rating_Status__c = 'Pended';
                        update opty;
                    }
                }
            }
        }
        catch(Exception e){
            system.debug('Error--'+e.getLineNumber()+'--'+e.getMessage());
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'SGR_Opportunity_Census__c', null, 'Sgr_displayCensus.deleteHealthDependents', 'High');
        }
        return value;
    }

    private static Boolean censusInList(List<SGR_Opportunity_Census__c> oppCensusList, SGR_Opportunity_Census__c testCensus){
        for(SGR_Opportunity_Census__c oppCensus : oppCensusList){
            if(oppCensus.Id != null && testCensus.Id != null){
                if(oppCensus.Id == testCensus.Id){
                    return true;
                }
            }else{
                return false;
            }
        }
        return false;
    }

    private static List<SGR_Opportunity_Census__c> extractDependants(List<SGR_Opportunity_Census__c> oppCensusList, SGR_Opportunity_Census__c parentCensus){
        List<SGR_Opportunity_Census__c> returnList = new List<SGR_Opportunity_Census__c>();
        for(SGR_Opportunity_Census__c oppCensus : oppCensusList){
            if(oppCensus.Subscriber_Number__c != null && parentCensus.Subscriber_Number__c != null && oppCensus.Subscriber_Number__c == parentCensus.Subscriber_Number__c){
                if(oppCensus.Relationship__c != null && !oppCensus.Relationship__c.equalsIgnoreCase('subscriber')){
                    returnList.add(oppCensus);
                }
            }
        }
        return returnList;
    }

    private static SGR_Opportunity_Census__c extractParent(List<SGR_Opportunity_Census__c> oppCensusList, SGR_Opportunity_Census__c depCensus){
        for(SGR_Opportunity_Census__c oppCensus : oppCensusList){
            if(oppCensus.Subscriber_Number__c != null && depCensus.Subscriber_Number__c != null && oppCensus.Subscriber_Number__c == depCensus.Subscriber_Number__c){
                if(oppCensus.Relationship__c != null && oppCensus.Relationship__c.equalsIgnoreCase('subscriber')){
                    return oppCensus;
                }
            }
        }
        return null;
    }

    private static void updateSubscriberTier(Set<String> subscriberNums, String coverageType,Id optyId){
        List<SGR_Opportunity_Census__c> optySubCensus = [Select Relationship__c, Health_Tier__c, Vision_Tier__c, Dental_Tier__c, Health_plan_id__c, Vision_plan_id__c, Dental_plan_id__c from SGR_Opportunity_Census__c where Subscriber_Number1__c IN : subscriberNums and Relationship__c = 'Subscriber' AND Opportunity__c = :optyId];
        Object childCount = 0;
        Object spouseCount = 0;
        Object domesticPartnerCount = 0;
        integer cCount=0, sCount=0, dpCount=0;
        String coverageTier='';
        AggregateResult[] groupedResults;
        if(coverageType == 'H'){
            system.debug('++++coverageType--'+coverageType);
            groupedResults
                    = [SELECT Relationship__c, COUNT(id)
            FROM SGR_Opportunity_Census__c
            where Subscriber_Number1__c IN : subscriberNums
            AND Health_Plan_Id__c != null AND Opportunity__c = :optyId
            GROUP BY Relationship__c];
        }
        if(coverageType == 'D'){
            system.debug('++++coverageType--'+coverageType);
            groupedResults
                    = [SELECT Relationship__c, COUNT(id)
            FROM SGR_Opportunity_Census__c
            where Subscriber_Number1__c IN : subscriberNums
            AND Dental_Plan_Id__c != null AND Opportunity__c = :optyId
            GROUP BY Relationship__c];
        }
        for (AggregateResult ar : groupedResults)  {
            if(ar.get('Relationship__c') == 'Child')
                cCount = integer.valueof(ar.get('expr0'));
            else if(ar.get('Relationship__c') == 'Spouse')
                sCount = integer.valueof(ar.get('expr0'));
            else if(ar.get('Relationship__c') == 'Domestic Partner')
                dpCount = integer.valueof(ar.get('expr0'));
        }
        system.debug('===cCount'+cCount);
        system.debug('===sCount'+sCount);
        system.debug('===dpCount'+dpCount);
        //Identify the proper coverage tier based on the aggregated counts
        if((cCount == 0 || cCount == null) && (sCount == 0 || sCount == null) && (dpCount == 0 || dpCount == null))
            coverageTier = 'EO';
        else if(cCount > 0 && (sCount > 0 || dpCount > 0))
            coverageTier = 'EF';
        else if((cCount == 0 || cCount == null) && (sCount > 0 || dpCount > 0))
            coverageTier = 'ES';
        else if(cCount > 0 && ((sCount == 0 || sCount == null) && (dpCount == 0 || dpCount == null)))
            coverageTier = 'EC';
        system.debug('++++coverageTier--'+coverageTier);
        //Perform the update on Health, Dental and Vision tiers accordingly
        system.debug('++++optySubCensus--'+optySubCensus[0]);
        if(optySubCensus.size() > 0){
            SGR_Opportunity_Census__c optyCensus = optySubCensus[0];
            if(coverageType == 'H'){
                optyCensus.Health_Tier__c = coverageTier;
                if(optyCensus.Vision_plan_id__c !=  null){
                    optyCensus.Vision_Tier__c = coverageTier;
                    //coverageTier = '';
                }
            }
            if(optyCensus.Dental_plan_id__c !=  null && coverageType == 'D'){
                optyCensus.Dental_Tier__c = coverageTier;
                //coverageTier = '';
            }
            update optyCensus;
        }
    }

    private static Boolean insertOppCensusSubscriber(SGR_Opportunity_Census__c oppCensus, Opportunity oppRecord, String tabId){
        setOppStatusPending(oppRecord.Id);
        if(tabId.toLowerCase() == 'health'){
            oppCensus.Health_Tier__c = 'EO';
            oppCensus.Vision_Tier__c = 'EO';
            if((oppCensus.Age_New__c >= 19 && oppRecord.HCSC_Division__c == 'MT') || oppRecord.HCSC_Division__c == 'NM'){
                if(oppCensus.Health_Plan_ID__c != null && oppCensus.Health_Group_Number__c != null && oppCensus.Health_Group_Section__c != null){
                    oppCensus.Vision_Plan_ID__c = oppCensus.Health_Plan_ID__c;
                    oppCensus.Vision_Group_Number__c = oppCensus.Health_Group_Number__c;
                    oppCensus.Vision_Group_Section__c = oppCensus.Health_Group_Section__c;
                }
            }
        }
        if(tabId == 'Dental'){
            oppCensus.Dental_Tier__c = 'EO';
        }
        oppCensus.Relationship__c = 'Subscriber';
        oppCensus.Membership_Number__c = 1;
        oppCensus.Subscriber_Number__c = Datetime.now().getTime();
        //saveCensusRecord
        //saveOppCensus
        Database.SaveResult sr = Database.insert(oppCensus);
        return sr.isSuccess();
    }

    private static Boolean insertOppCensusDependant(List<SGR_Opportunity_Census__c> allOppCensusList, SGR_Opportunity_Census__c depOppCensus, SGR_Opportunity_Census__c parentOppCensus, Opportunity oppRecord, String tabId){
        setOppStatusPending(oppRecord.Id);
        depOppCensus.Backend_Created__c = parentOppCensus.Backend_Created__c;
        depOppCensus.Subscriber_Number__c = parentOppCensus.Subscriber_Number__c;
        List<SGR_Opportunity_Census__c> dependantList = getDependantRecords(allOppCensusList, parentOppCensus);
        if(dependantList != null && !dependantList.isEmpty()){
            depOppCensus.Membership_Number__c = dependantList.size() + 1;
        }else{
            depOppCensus.Membership_Number__c = 1;
        }
        Database.SaveResult sr = Database.insert(depOppCensus);
        if(sr.isSuccess()){
            dependantList.add(depOppCensus);
            return updateTier(dependantList, parentOppCensus);
        }
        return true;
    }

    private static Boolean updateTier(List<SGR_Opportunity_Census__c> dependantList, SGR_Opportunity_Census__c parentCensus){
        Map<String, Integer> childMap = new Map<String, Integer>();
        Map<String, Integer> spouseMap = new Map<String, Integer>();
        for(SGR_Opportunity_Census__c depCensus : dependantList){
            if(depCensus.Health_Plan_ID__c != null){
                Integer count = 0;
                if(depCensus.Relationship__c == 'Child'){
                    if(childMap.containsKey('health')){
                        count = childMap.get('health');
                    }
                    count++;
                    childMap.put('health', count);
                }else{
                    if(spouseMap.containsKey('health')){
                        count = spouseMap.get('health');
                    }
                    count++;
                    spouseMap.put('health', count);
                }
            }
            //
            if(depCensus.Dental_Plan_ID__c != null){
                Integer count = 0;
                if(depCensus.Relationship__c == 'Child'){
                    if(childMap.containsKey('dental')){
                        count = childMap.get('dental');
                    }
                    count++;
                    childMap.put('dental', count);
                }else{
                    if(spouseMap.containsKey('dental')){
                        count = spouseMap.get('dental');
                    }
                    count++;
                    spouseMap.put('dental', count);
                }
            }
            //
            if(depCensus.Vision_Plan_ID__c != null){
                Integer count = 0;
                if(depCensus.Relationship__c == 'Child'){
                    if(childMap.containsKey('vision')){
                        count = childMap.get('vision');
                    }
                    count++;
                    childMap.put('vision', count);
                }else{
                    if(spouseMap.containsKey('vision')){
                        count = spouseMap.get('vision');
                    }
                    count++;
                    spouseMap.put('vision', count);
                }
            }
        }
        SGR_Opportunity_Census__c updatedCensus = genTierUpdate(dependantList, parentCensus);
        Boolean runUpdate = false;
        if(parentCensus.Health_Tier__c != updatedCensus.Health_Tier__c){
            runUpdate = true;
        }
        if(parentCensus.Dental_Tier__c != updatedCensus.Dental_Tier__c){
            runUpdate = true;
        }
        if(parentCensus.Vision_Tier__c != updatedCensus.Vision_Tier__c){
            runUpdate = true;
        }
        if(runUpdate){
            Database.SaveResult sr = Database.update(updatedCensus);
            return sr.isSuccess();
        }
        return true;
    }

    private static SGR_Opportunity_Census__c genTierUpdate(List<SGR_Opportunity_Census__c> dependantList, SGR_Opportunity_Census__c parentCensus){
        Map<String, Integer> childMap = new Map<String, Integer>();
        Map<String, Integer> spouseMap = new Map<String, Integer>();
        for(SGR_Opportunity_Census__c depCensus : dependantList){
            if(depCensus.Health_Plan_ID__c != null){
                Integer count = 0;
                if(depCensus.Relationship__c == 'Child'){
                    if(childMap.containsKey('health')){
                        count = childMap.get('health');
                    }
                    count++;
                    childMap.put('health', count);
                }else{
                    if(spouseMap.containsKey('health')){
                        count = spouseMap.get('health');
                    }
                    count++;
                    spouseMap.put('health', count);
                }
            }
            //
            if(depCensus.Dental_Plan_ID__c != null){
                Integer count = 0;
                if(depCensus.Relationship__c == 'Child'){
                    if(childMap.containsKey('dental')){
                        count = childMap.get('dental');
                    }
                    count++;
                    childMap.put('dental', count);
                }else{
                    if(spouseMap.containsKey('dental')){
                        count = spouseMap.get('dental');
                    }
                    count++;
                    spouseMap.put('dental', count);
                }
            }
            //
            if(depCensus.Vision_Plan_ID__c != null){
                Integer count = 0;
                if(depCensus.Relationship__c == 'Child'){
                    if(childMap.containsKey('vision')){
                        count = childMap.get('vision');
                    }
                    count++;
                    childMap.put('vision', count);
                }else{
                    if(spouseMap.containsKey('vision')){
                        count = spouseMap.get('vision');
                    }
                    count++;
                    spouseMap.put('vision', count);
                }
            }
        }

        /*parentCensus.Health_Tier__c = parseTierMap(childMap, spouseMap, 'health');
        parentCensus.Dental_Tier__c = parseTierMap(childMap, spouseMap, 'dental');
        parentCensus.Vision_Tier__c = parseTierMap(childMap, spouseMap, 'vision');*/
        String hTier = parseTierMap(childMap, spouseMap, 'health');
        String dTier = parseTierMap(childMap, spouseMap, 'dental');
        String vTier = parseTierMap(childMap, spouseMap, 'vision');
        if(parentCensus.Health_Tier__c != null && parentCensus.Health_Tier__c != hTier){
            parentCensus.Health_Tier__c = hTier;
        }
        if(parentCensus.Dental_Tier__c != null && parentCensus.Dental_Tier__c != dTier){
            parentCensus.Dental_Tier__c = dTier;
        }
        if(parentCensus.Vision_Tier__c != null && parentCensus.Vision_Tier__c != vTier){
            parentCensus.Vision_Tier__c = vTier;
        }
        return parentCensus;
    }

    private static String parseTierMap(Map<String, Integer> childMap, Map<String, Integer> spouseMap, String key){
        Integer childCount = (childMap.containsKey(key) ? childMap.get(key) : 0);
        Integer spouseCount = (spouseMap.containsKey(key) ? spouseMap.get(key) : 0);
        if(childCount > 0){
            if(spouseCount > 0){
                return 'EF';
            }
            return 'EC';
        }else if(spouseCount > 0){
            return 'ES';
        }
        return 'EO';
    }

    private static Map<String, Boolean> appendTabCapabilities(Map<String, Boolean> returnMap, Id oppId){
        returnMap.put('hTab', false);
        returnMap.put('dTab', false);
        returnMap.put('vTab', false);
        for(SGR_Opportunity_Benefit_Agreement__c oppBa : [SELECT Id, Line_of_Business__c, Opportunity__r.HCSC_Division__c FROM SGR_Opportunity_Benefit_Agreement__c WHERE Status__c = 'Active' AND Opportunity__c = :oppId]){
            if(oppBa.Line_of_Business__c != null){
                returnMap.put(getTabKey(oppBa.Line_of_Business__c), parseLob(oppBa));
            }
        }
        return returnMap;
    }

    private static Boolean parseLob(SGR_Opportunity_Benefit_Agreement__c oppBa){
        if(oppBa.Line_of_Business__c != 'V'){
            return true;
        }else if(oppBa.Opportunity__r.HCSC_Division__c == 'MT' || oppBa.Opportunity__r.HCSC_Division__c == 'NM'){
            return true;
        }
        return false;
    }

    private static String getTabKey(String lob){
        return lob.toLowerCase() + 'Tab';
    }

    private static void setOppStatusPending(Id oppId){
        Opportunity skeletonKey = new Opportunity();
        skeletonKey.Id = oppId;
        skeletonKey.Rating_Status__c = 'Pended';
        try{
            update skeletonKey;
        }catch (DmlException e){
            System.debug('Opportunity update exception = ' + e);
        }
    }

    private static List<SGR_Opportunity_Census__c> getDependantRecords(List<SGR_Opportunity_Census__c> oppCensusList, SGR_Opportunity_Census__c parentCensus){
        List<SGR_Opportunity_Census__c> returnList = new List<SGR_Opportunity_Census__c>();
        for(SGR_Opportunity_Census__c oppCensus : oppCensusList){
            if(oppCensus.Relationship__c != 'Subscriber' && oppCensus.Opportunity__c == parentCensus.Opportunity__c && oppCensus.Subscriber_Number__c == parentCensus.Subscriber_Number__c){
                returnList.add(oppCensus);
            }
        }
        return returnList;
    }

    private static Boolean cleanData(Id oppId){
        List<SGR_Opportunity_Census__c> fullOrderedList = getAllCensusRecords(oppId);
        if(fullOrderedList != null && !fullOrderedList.isEmpty()){
            Date renewalDate = getRenewalEffectiveDate(oppId);
            List<SGR_Opportunity_Census__c> updateList = new List<SGR_Opportunity_Census__c>();
            Integer subRowNum = 0;
            Integer depRowNum = 0;
            for(SGR_Opportunity_Census__c oppCensusRecord : fullOrderedList){
                Boolean needsUpdate = false;
                if(oppCensusRecord.Relationship__c == 'Subscriber'){
                    subRowNum++;
                    depRowNum = 0;
                    String key = subRowNum + '.0';
                    if(oppCensusRecord.Row__c == null || oppCensusRecord.Row__c != key){
                        oppCensusRecord.Row__c = key;
                        needsUpdate = true;
                    }
                }else{
                    depRowNum++;
                    String key = subRowNum + '.' + depRowNum;
                    if(oppCensusRecord.Row__c == null || oppCensusRecord.Row__c != key){
                        oppCensusRecord.Row__c = key;
                        needsUpdate = true;
                    }
                }
                if(renewalDate != null && oppCensusRecord.Date_of_Birth__c != null){
                    Datetime renewalDatetime = Datetime.newInstanceGmt(renewalDate, Time.newInstance(0, 0, 0, 0));
                    Datetime dobDatetime = Datetime.newInstanceGmt(oppCensusRecord.Date_of_Birth__c, Time.newInstance(0, 0, 0, 0));
                    Integer age = calcAge(renewalDatetime.getTime(), dobDatetime.getTime());
                    if(oppCensusRecord.Age_New__c == null || oppCensusRecord.Age_New__c != age){
                        oppCensusRecord.Age_New__c = age;
                        needsUpdate = true;
                    }
                }
                if(needsUpdate){
                    updateList.add(oppCensusRecord);
                }
            }
            if(!updateList.isEmpty()){
                update updateList;
            }
        }
        return true;
    }

    private static Integer calcAge(Long renewalMillis, Long dobMillies){
        Long diffMillies = renewalMillis - dobMillies;
        Datetime diffDate = Datetime.newInstance(diffMillies);
        Integer yearVal = diffDate.yearGmt();
        return yearVal - 1970;
    }

    private static Date getRenewalEffectiveDate(Id oppId){
        Opportunity opp = [SELECT Id, Renewal_Date__c FROM Opportunity WHERE Id = :oppId];
        return (opp != null && opp.Renewal_Date__c != null ? opp.Renewal_Date__c : null);
    }

    private static List<SGR_Opportunity_Census__c> getAllCensusRecords(Id oppId){
        return [SELECT Id, SGR_DentalIsChecked__c, SGR_HealthIsChecked__c, SGR_VisionIsChecked__c, CensusId__c, Name,
                        Date_of_Birth__c, Gender__c, Retiree__c, State_Continuation__c, CreatedDate,
                        Created_Date_only__c, CreatedBy.Name, LastModifiedDate, Last_Modify_Date_Only__c,
                        LastModifiedBy.Name, LastModifiedById, Age__c, LastViewedDate, LastReferencedDate,
                        Opportunity__c, Subscriber_Number__c, COBRA__c, Membership_Number__c, Age_New__c,Last_Name__c,
                        First_Name__c, Member_Effective_Date__c, Member_Cancel_Date__c, Relationship__c, Zip_Code__c,
                        Medicare_Primary__c, Tobacco_Use__c, Tobacco_Y_N__c, Plan_Name__c, Group_Number__c,
                        Member_Benefit_Effective_Date__c, Member_Benefit_Cancel_Date__c,
                        Total_Number_of_Health_Subscribers__c, Row__c, Health_Plan_ID__c, Dental_Tier__c,
                        Dental_Plan_ID__c, Vision_Comp__c, Dental_comp__c, Health_Comp__c, Relationship_Code__c,
                        Member_Characteristic_Type__c, Acc_Census_External_Id__c, State__c, Health_Tier__c,
                        Vision_Tier__c, Vision_Plan_ID__c, Employee_Status_Code__c, Account__c, Group_Section_Number__c,
                        Dental_Coverage__c, Vision_Coverage__c, Health_Coverage__c, Group_Section_Number__r.Name,
                        Member_Rates__c, Composite_Rates__c, Opportunity__r.Rating_Status__c,
                        Opportunity__r.HCSC_Division__c, Opportunity__r.Account.Domestic_Partner__c,
                        Opportunity__r.Renewal_Date__c, Opportunity_Group_Section__r.Opportunity_Group_Section_Number__c,
                        Health_Group_Number__c, Dental_Group_Number__c, Vision_Group_Number__c,
                        Health_Group_Section__c, Dental_Group_Section__c, Vision_Group_Section__c
                FROM SGR_Opportunity_Census__c
                WHERE Opportunity__c=:oppId AND (Health_Plan_ID__c != NULL OR Dental_Plan_ID__c != NULL OR Vision_Plan_ID__c != NULL)
                ORDER BY Subscriber_Number__c, Membership_Number__c
                LIMIT  1000];
    }
}