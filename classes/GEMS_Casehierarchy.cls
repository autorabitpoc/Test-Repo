//Create Hierarchy  
public class GEMS_Casehierarchy{  
  
    //List of items to be displayed in hierarchy  
    public List<hierarchyItem> hierarchyItemList {get;set;}  
      
    //map of a ll  hierarchy records related to for a account for which we are showing hierarchy  
    @TestVisible private Map<Id , Case> mapHierarchy = new Map<Id , Case>();  
      
    //Hierarchy Index, used to determine spaces before the name starts  
   @TestVisible private static Integer hirarchyIndex = 0;  
      
    //Case Category for which hierarchy is created  
    public String CaseCategory {get;set;}  
      
    public GEMS_Casehierarchy()  
    {  
        try {
        if(ApexPages.currentPage().getParameters().get('caseid') != null)  
            {  
                ID caseid = ApexPages.currentPage().getParameters().get('caseid');  
                 
                CaseCategory = [Select Type From Case where id =: caseid].Type;  
                //Get all hierarchy records related to account  
                mapHierarchy = new Map<Id , Case>([Select Type ,Status,Owner.Name, ParentId  From Case Where GEMS_Account_Submission_Info__c =: caseid OR id = :caseid]);  
                  
                 
                  
                List<Hierarchy> listParentHierarchy = new List<Hierarchy>();  
                hierarchyItemList = new List<hierarchyItem>();  
                  
                for(Case h : mapHierarchy.values())  
                    {  
                        if(h.ParentId  == null)  
                        {  
                            hierarchyItemList.add(new hierarchyItem( h.Type ,h.Status,h.Owner.Name, 0));  
                            mapHierarchy.remove(h.id);  
                            hierarchyItemList = getChildHierarchy(h.id , hierarchyItemList);  
                        }  
                          
                    }  
            } 
        } 
        catch(Exception ex) {
        System.debug('=====Exception======'+ex);
        }
    }  
  
    //Method to get child records  
       @TestVisible private List<hierarchyItem> getChildHierarchy(Id parentId , List<hierarchyItem> currentHierarchyItemList)  
    {  
        hirarchyIndex = hirarchyIndex + 1;  
        try {
        for(Case h : mapHierarchy.values())  
            {  
                if(h.ParentId == parentId)  
                    {  
                        hierarchyItemList.add(new hierarchyItem( h.Type , h.Status,h.Owner.Name,hirarchyIndex));  
                        mapHierarchy.remove(h.id);  
                        //Get child records of child  
                        hierarchyItemList = getChildHierarchy(h.id , hierarchyItemList);  
                    }  
                  
            }  
        hirarchyIndex = hirarchyIndex - 1; 
        }     
        catch(Exception ex) {
             GEMS_CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'Case', null, 'GEMS_Casehierarchy.getChildHierarchy','High'); 
             return null;
        }
        return currentHierarchyItemList;      
    }      
      
    //Inner class for maintaing hierarchy items  
    public class hierarchyItem{  
          
        public String category{get;set;}   
        public String status{get;set;}
        public String owner{get;set;}
        public String daysopen{get;set;}                
        public String hirarchyIndexNo{get;set;}  
        public hierarchyItem(String category,String status, String owner, Integer hirarchyIndexNo)  
            {  
                String spaceCount = '';  
                for(integer i = 0 ; i < hirarchyIndexNo ; i++)  
                    spaceCount = spaceCount  + '&nbsp;&nbsp;';  
                      
                this.category = spaceCount + category;  
                this.status= status;  
                this.owner= owner;                                  
            }  
    }  
  
}