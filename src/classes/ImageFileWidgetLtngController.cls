public class ImageFileWidgetLtngController {

    @AuraEnabled
    public static Boolean updateFileName(String contentId, String fileName){
        ContentDocument cd = [SELECT Id, Description, Title FROM ContentDocument WHERE Id = :contentId];
        cd.Description = fileName;
        cd.Title = genTitle(fileName);
        try{
            update cd;
            return true;
        }catch(DmlException e){
            System.debug(e);
            return false;
        }
    }

    private static String genTitle(String fileName){
        if(fileName != null){
            if(fileName.equalsIgnoreCase('custom_hero')){
                return 'Cover Image';
            }
            return 'Service Icon';
        }
        return null;
    }
}