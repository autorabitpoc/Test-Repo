/**************************************************************************************
* Apex Class Name       : GEMS_BAIdWrapper_TEST
* Version               : 1.0
* Function              : Test class for GEMS_BAIdWrapper
* ------------------------------------------------------------------------------------
* Developer           Date               	Description
* ------------------------------------------------------------------------------------
* Phani Kommareddy 	  09/13/2017			Original Version
*************************************************************************************/
@isTest
public class GEMS_BAIdWrapper_TEST {
    private static testmethod void testMethod1() {
        GEMS_Benefit_Agreement__c ba = new GEMS_Benefit_Agreement__c();
    	GEMS_BAIdWrapper bidw = new GEMS_BAIdWrapper(true,ba);
        System.assertEquals(true,bidw.isSelected);
    }
}