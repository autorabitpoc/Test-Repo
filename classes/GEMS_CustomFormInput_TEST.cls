/**************************************************************************************
* Apex Class Name       : GEMS_CustomFormInput_TEST
* Version               : 1.0
* Function              : Test GEMS_CustomFormInput Helper Class
* Modification Log      :
* Developer           Date               	Description
* ------------------------------------------------------------------------------------
* Phani Kommareddy 	  09/13/2017			Original Version 
*************************************************************************************/

@isTest
public class GEMS_CustomFormInput_TEST {
    private static testmethod void GEMS_CustomFormInput_Test1() {
        Id formId;
        String assignmentType = 'Benefit Agreement';
        String baCaseNums = '0001';
        String gsCaseNums = '1234-1563';
        List<GEMS_IDCompare> idCompareList = new List<GEMS_IDCompare>();
        GEMS_CustomFormInput cfi = new GEMS_CustomFormInput(formId,assignmentType,baCaseNums,gsCaseNums,idCompareList);
        System.assertEquals(baCaseNums,cfi.baCaseNums);
        
    }
}