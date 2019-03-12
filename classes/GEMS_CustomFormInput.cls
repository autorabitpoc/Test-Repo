/**************************************************************************************
* Apex Class Name       : GEMS_CustomFormInput
* Version               : 1.0
* Function              : Helper Class for comparisions with old and new BA and GS selections
* Modification Log      :
* Developer           Date               	Description
* ------------------------------------------------------------------------------------
* Phani Kommareddy 	  09/13/2017			Original Version 
*************************************************************************************/

public class GEMS_CustomFormInput {
    public ID formId{get;set;}
    public String assignmentType{get;set;}
    public String baCaseNums{get;set;}
    public String gsCaseNums{get;set;}
    public List<GEMS_IDCompare> idCompareList{get;set;}
    
    public GEMS_CustomFormInput(ID formId,String assignmentType,String baCaseNums,String gsCaseNums,List<GEMS_IDCompare> idCompareList) {
        this.formId = formId;
        this.assignmentType = assignmentType;
        this.baCaseNums = baCaseNums;
        this.gsCaseNums = gsCaseNums;
        this.idCompareList = idCompareList;
    }
    
}