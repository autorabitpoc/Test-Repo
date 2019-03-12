/**************************************************************************************
* Apex Class Name       : GEMS_BAIdWrapper
* Version               : 1.0
* Function              : This Class is a wrapper for BA information for Custom/prospective/supression id cards
* Modification Log      :
* Developer           Date                  Description
* ------------------------------------------------------------------------------------
* Malathi.K           02/05/2018            SFDC-8118 Added GroupNo
*************************************************************************************/
public class GEMS_BAIdWrapper{
    public boolean isSelected {get; set;}
    public GEMS_Benefit_Agreement__c ba{get; set;}
    public String groupNo{get; set;}
    public GEMS_BAIdWrapper (boolean isSelected, GEMS_Benefit_Agreement__c ba){
        this.isSelected = isSelected;
        this.ba= ba;           
    }
    public GEMS_BAIdWrapper(boolean isSelected, GEMS_Benefit_Agreement__c ba, String groupNo){
        this.isSelected = isSelected;
        this.ba= ba;
        this.groupNo = groupNo;           
    }             
}