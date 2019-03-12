/**************************************************************************************
* Apex Class Name       : GEMS_IDCompare_TEST
* Version               : 1.0
* Function              : Test GEMS_IDCompare Helper Class
* Modification Log      :
* Developer           Date               	Description
* ------------------------------------------------------------------------------------
* Phani Kommareddy 	  09/13/2017			Original Version 
*************************************************************************************/

@isTest
public class GEMS_IDCompare_TEST {
    private static testmethod void testMethod1() {
        Id formId;
        String applicableBAs = '0001';
        String applicableGSs = '1234-1563';
        String assignmentType = 'Benefit Agreement';
        GEMS_IDCompare idCompare = new GEMS_IDCompare(formId,applicableBAs,applicableGSs,assignmentType);
        System.assertEquals(applicableBAs,idCompare.applicableBAs);
    }
}