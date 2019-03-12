/**************************************************************************************
* Apex Class Name       : GEMS_IDCompare
* Version               : 1.0
* Function              : Comparision object that would be used for transforming data for the id card forms
* Modification Log      :
* Developer           Date               	Description
* ------------------------------------------------------------------------------------
* Phani Kommareddy 	  09/13/2017			Original Version 
*************************************************************************************/
public class GEMS_IDCompare {
	public ID formId{get;set;}
    public String applicableBAs{get;set;}
    public String applicableGSs{get;set;}
    public String assignmentType{get;set;}
    
    public GEMS_IDCompare(ID formId, String applicableBAs, String applicableGSs, String assignmentType) {
        this.formId = formId;
        this.applicableBAs = applicableBAs;
        this.applicableGSs = applicableGSs;
        this.assignmentType = assignmentType;
    }
}