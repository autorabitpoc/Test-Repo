public class ImageFilesLtngController {

    @AuraEnabled
    public static String getHostUrl(){
        /*if(defaultVersionsStored()){
            return GlobalSettingsHelper.lexOrigin(false);
        }else{
            if(createDefaultImageVersions()){
                return GlobalSettingsHelper.lexOrigin(false);
            }else{
                GlobalSettingsHelper.dealerImageDefaultsSet = false;
            }
        }*/
        return null;
    }


    @AuraEnabled
    public static Map<String, String> getInitialImageData(String recordId){
        /*Map<String, String> returnMap = new Map<String, String>();
        String defaultIcon = 'automatic_icon';
        String defaultHero = 'automatic_hero';
        String customIcon = 'custom_icon';
        String customHero = 'custom_hero';
        //Id apiUserId = getApiUserId();
        Id networkId = getCommunityId();
        Set<Id> customCdlIds = getCdLinkIds(recordId);
        List<ContentVersion> cvList = [SELECT Id, Description, ContentDocumentId FROM ContentVersion WHERE
        NetworkId = :networkId AND ContentDocumentId IN (SELECT Id FROM ContentDocument WHERE
        (Description = :defaultHero OR Description = :defaultIcon) OR
        ((Description = :customIcon OR Description = :customHero) AND Id IN :customCdlIds))];
        System.debug(cvList);
        for(ContentVersion cv : cvList){
            returnMap.put(cv.Description, cv.Id);
        }
        return returnMap;*/
        return null;
    }

    @AuraEnabled
    public static String getContentVersionId(String recordId, String cvTitle){
        System.debug('FINAL recordId = ' + recordId);
        System.debug('FINAL cvTitle = ' + cvTitle);
        Set<Id> cdlIds = getCdLinkIds(recordId);
        System.debug('FINAL cdlIds = ' + cdlIds);
        if(cdlIds != null){
            ContentDocument cdd = getContentDocument(cdlIds, cvTitle);
            if(cdd != null){
                System.debug('FINAL cdd = ' + cdd);
                ContentVersion cv = [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :cdd.Id];
                System.debug('FINAL cv = ' + cv);
                return cv.Id;
            }
        }
        return null;
    }

    @AuraEnabled
    public static ContentVersion updateImageData(String contentId, String recordId, String baseEncodedData){
        try{
            ContentVersion cv = convertImage([SELECT Id, Title, Description FROM ContentDocument WHERE Id = :contentId], baseEncodedData);
            cleanData(cv.ContentDocumentId, recordId, cv.Description);
            createLink(cv.ContentDocumentId, recordId);
            createDistRec(cv.Id, recordId, cv.Title);
            return cv;
        }catch(Exception e){
            System.debug(e);
            return null;
        }
    }

    private static ContentVersion convertImage(ContentDocument cd, String baseEncodedData){
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = EncodingUtil.base64Decode(baseEncodedData);
        cv.Title = cd.Title;
        cv.Description = cd.Description;
        cv.PathOnClient = cd.Description + '.png';
        insert cv;
        ContentVersion cvv = [SELECT Id, Description, ContentDocumentId, ContentLocation, VersionData, Title, PathOnClient FROM ContentVersion WHERE Id = :cv.Id];
        return cvv;
    }

    private static void cleanData(String newContentId, String recordId, String descStr){
        List<ContentDocument> oldCdList = [SELECT Id FROM ContentDocument WHERE Id <> :newContentId AND Description = :descStr];
        System.debug('DEBUGGING oldCdList');
        System.debug(oldCdList);
        if(oldCdList != null && !oldCdList.isEmpty()){
            List<ContentDocumentLink> oldLinkList = [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId IN :oldCdList AND LinkedEntityId = :recordId];
            System.debug('DEBUGGING oldLinkList');
            System.debug(oldLinkList);
            Set<Id> oldCdIds = new Set<Id>();
            for(ContentDocumentLink cdl : oldLinkList){
                oldCdIds.add(cdl.ContentDocumentId);
            }
            List<ContentDocument> cdPurgeList = [SELECT Id FROM ContentDocument WHERE Id IN :oldCdIds];
            System.debug('DEBUGGING cdPurgeList');
            System.debug(cdPurgeList);
            if(cdPurgeList != null && !cdPurgeList.isEmpty()){
                delete cdPurgeList;
                List<ContentDocumentLink> cdlPurgeList = [SELECT Id FROM ContentDocumentLink WHERE ContentDocumentId IN :oldCdIds];
                System.debug('DEBUGGING cdlPurgeList');
                System.debug(cdlPurgeList);
                if(cdlPurgeList != null && !cdlPurgeList.isEmpty()){
                    delete cdlPurgeList;
                }
            }
        }
    }

    private static void createLink(String newCdId, String recordId){
        ContentDocumentLink link = new ContentDocumentLink();
        link.LinkedEntityId = recordId;
        link.ContentDocumentId = newCdId;
        link.ShareType = 'V';
        link.Visibility = 'AllUsers';
        insert link;
    }

    private static void createDistRec(String contentVersionId, String recordId, String title){
        /*system.debug('ImageFilesLtngController:createDistRec: The Title --> ' + title);
        ContentDistribution cd = new ContentDistribution();
        cd.Name = title + '_' + recordId;
        cd.ContentVersionId = contentVersionId;
        insert cd;

        ContentDistribution cdd = [SELECT DistributionPublicUrl FROM ContentDistribution WHERE Id = :cd.Id];
        if(cdd != null && cdd.DistributionPublicUrl != null && cdd.DistributionPublicUrl.length() > 0){
            Account updateAccount = [SELECT Id, CoverImageURL__c, ServiceIconURL__c FROM Account WHERE Id = :recordId];
            if(title.equalsIgnoreCase('Cover Image')){//custom_hero
                system.debug('ImageFilesLtngController:createDistRec: Update the Cover Image URL');
                updateAccount.CoverImageURL__c = cdd.DistributionPublicUrl;
            }else{
                system.debug('ImageFilesLtngController:createDistRec: Update the Service Icon URL');
                updateAccount.ServiceIconURL__c = cdd.DistributionPublicUrl;
            }
            update updateAccount;
        }*/
    }


    private static ContentDocument getContentDocument(Set<Id> cdlIds, String cvTitle){
        try{
            ContentDocument cdd = [SELECT Id FROM ContentDocument WHERE Id IN :cdlIds AND Description = :cvTitle];
            System.debug('getContentDocument - cdd = ' + cdd);
            return cdd;
        }catch (Exception e){
            System.debug('error e = ' + e.getStackTraceString());
            return null;
        }
    }

    private static Set<Id> getCdLinkIds(String recordId){
        List<ContentDocumentLink> linkList = [SELECT Id, ContentDocumentId FROM ContentDocumentLink  WHERE LinkedEntityId = :recordId];
        Set<Id> linkSet = new Set<Id>();
        if(linkList != null && !linkList.isEmpty()){
            for(ContentDocumentLink cdl : linkList){
                linkSet.add(cdl.ContentDocumentId);
            }
        }
        return linkSet;
    }

    private static Boolean defaultVersionsStored(){
        /*if(!GlobalSettingsHelper.dealerImageDefaultsSet){
            GlobalSettingsHelper.dealerImageDefaultsSet = true;
            return false;
        }
        return true;*/
        /*Community_Settings__c settings = [SELECT Id, Default_Versions_Set__c FROM Community_Settings__c];
        System.debug('defaultVersionsStored - settings = ' + settings);
        if(!settings.Default_Versions_Set__c){
            settings.Default_Versions_Set__c = true;
            update settings;
            return false;
        }
        return true;*/
        return true;
    }

    private static Boolean createDefaultImageVersions(){
        List<ContentVersion> insertList = new List<ContentVersion>();
        insertList.add(genVersionRecord('automatic_hero'));
        insertList.add(genVersionRecord('automatic_icon'));
        try{
            insert insertList;
            System.debug('createDefaultImageVersions - insertList = ' + insertList);
            return true;
        }catch (DmlException e){
            System.debug(e.getStackTraceString());
            return false;
        }
    }

    private static Blob getDefaultImgDataBlob(String resourceName){
        try{
            StaticResource sr = [SELECT Body FROM StaticResource WHERE Name = :resourceName];
            System.debug('getDefaultImgDataBlob - sr = ' + sr);
            return sr.Body;
        }catch (QueryException e){
            System.debug(e.getStackTraceString());
            return null;
        }
    }

    private static Id getApiUserId(){
        try{
            User u = [SELECT Id FROM User WHERE ProfileId IN (SELECT Id FROM Profile WHERE Name = 'System Administrator') AND FirstName = 'Automatic' AND LastName = 'Labs'];
            return u.Id;
        }catch (QueryException e){
            System.debug(e.getStackTraceString());
            return null;
        }
    }

    private static Id getCommunityId(){
        /*try{
            Network n = [SELECT Id FROM Network WHERE Name = 'Dealer Enrollment Portal'];
            return n.Id;
        }catch (QueryException e){
            System.debug(e.getStackTraceString());
            return null;
        }*/
        return null;
    }

    private static ContentVersion genVersionRecord(String fileName){
        /*ContentVersion result = new ContentVersion();
        String staticResName = 'default_cover_img';
        if(fileName.equalsIgnoreCase('automatic_hero')){
            result.Title = genTitle(fileName);
        }else{
            staticResName = 'default_service_img';
            result.Title =  genTitle(fileName);
        }
        result.PathOnClient = fileName + '.png';
        result.Description = fileName;
        result.VersionData = getDefaultImgDataBlob(staticResName);
        result.OwnerId = getApiUserId();
        Id networkId = getCommunityId();
        result.NetworkId = networkId;
        result.FirstPublishLocationId = networkId;
        System.debug('genVersionRecord - result = ' + result);
        return result;*/
        return null;
    }

    private static String genTitle(String fileName){
        if(fileName.equalsIgnoreCase('automatic_hero')){
            return 'Cover Image';
        }
        return 'Service Icon';
    }
}