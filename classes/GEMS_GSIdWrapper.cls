/**************************************************************************************
* Apex Class Name       : GEMS_GSIdWrapper
* Version               : 1.0
* Function              : This Class is a wrapper for Group Section information for Custom/prospective/supression id cards
* ------------------------------------------------------------------------------------
* Developer           Date               	Description
* ------------------------------------------------------------------------------------
* Phani Kommareddy 	  09/13/2017			Original Version
*************************************************************************************/
public class GEMS_GSIdWrapper{
    public boolean isSelected {get; set;}
    public GEMS_Group_Section__c gs{get; set;}
    public GEMS_GSIdWrapper (boolean isSelected, GEMS_Group_Section__c gs){
        this.isSelected = isSelected;
        this.gs= gs;           
    }         
}