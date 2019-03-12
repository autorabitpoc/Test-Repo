//Create Hierarchy  
public class hierarchy{  
  
    //List of items to be displayed in hierarchy  
    public List<hierarchyItem> hierarchyItemList {get;set;}  
      
    //map of all  hierarchy records related to for a account for which we are showing hierarchy  
    private Map<Id , Case> mapHierarchy = new Map<Id , Case>();  
      
    //Hierarchy Index, used to determine spaces before the name starts  
    private static Integer hirarchyIndex = 0;  
      
    //name of account for which hierarchy is created  
    public String CaseCategory {get;set;}  
      
    public hierarchy()  
    {  
        if(ApexPages.currentPage().getParameters().get('caseid') != null)  
        {  
            ID caseid = ApexPages.currentPage().getParameters().get('caseid');  
             
            CaseCategory = [Select Type From Case where id =: caseid].Type;  
            //Get all hierarchy records related to account  
            mapHierarchy = new Map<Id , Case>([Select Type , ParentId  From Case Where GEMS_Account_Submission_Info__c =: caseid]);  
              
             
              
            List<Hierarchy> listParentHierarchy = new List<Hierarchy>();  
            hierarchyItemList = new List<hierarchyItem>();  
              
            for(Case h : mapHierarchy.values())  
                {  
                    if(h.ParentId  == null)  
                    {  
                        hierarchyItemList.add(new hierarchyItem( h.Type , 0));  
                        mapHierarchy.remove(h.id);  
                        hierarchyItemList = getChildHierarchy(h.id , hierarchyItemList);  
                    }  
                      
                }  
        }  
    }  
  
    //Method to get child records  
    private List<hierarchyItem> getChildHierarchy(Id parentId , List<hierarchyItem> currentHierarchyItemList)  
    {  
        hirarchyIndex = hirarchyIndex + 1;  
        for(Case h : mapHierarchy.values())  
            {  
                if(h.ParentId == parentId)  
                    {  
                        hierarchyItemList.add(new hierarchyItem( h.Type , hirarchyIndex));  
                        mapHierarchy.remove(h.id);  
                        //Get child records of child  
                        hierarchyItemList = getChildHierarchy(h.id , hierarchyItemList);  
                    }  
                  
            }  
        hirarchyIndex = hirarchyIndex - 1;      
        return currentHierarchyItemList;      
    }      
      
    //Inner class for maintaing hierarchy items  
    public class hierarchyItem{  
          
        public String itemValue{get;set;}   
        public String hirarchyIndexNo{get;set;}  
        public hierarchyItem(String itemValue , Integer hirarchyIndexNo)  
            {  
                String spaceCount = '';  
                for(integer i = 0 ; i < hirarchyIndexNo ; i++)  
                    spaceCount = spaceCount  + '&nbsp;&nbsp;';  
                      
                this.itemValue = spaceCount + itemValue;  
            }  
    }  
  
}