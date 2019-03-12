/**************************************************************************************
* Apex Class Name       : GEMS_GSIdWrapper_TEST
* Version               : 1.0
* Function              : Test class for GEMS_GSIdWrapper
* ------------------------------------------------------------------------------------
* Developer           Date               	Description
* ------------------------------------------------------------------------------------
* Phani Kommareddy 	  09/13/2017			Original Version
*************************************************************************************/
@isTest
public class GEMS_GSIdWrapper_TEST {
    private static testmethod void testMethod1() {
        GEMS_Group_Section__c gs = new GEMS_Group_Section__c();
    	GEMS_GSIdWrapper gidW = new GEMS_GSIdWrapper(true,gs);
        System.assertEquals(true,gidW.isSelected);
    }
}