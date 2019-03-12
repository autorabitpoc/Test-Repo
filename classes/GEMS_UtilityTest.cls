/**************************************************************************************
  Apex Class Name     : GEMS_UtilityTest
  Function            : This test class is to test methods in GEMS_Utility that are not tested in any other test classes
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
*   Luke Chen             07/23/2017                createTask method is not tested in other test classes so added here
*************************************************************************************/
@isTest
    private class GEMS_UtilityTest{
	
	private static testmethod void testCreateTask(){
		Task t = GEMS_Utility.createTask('In Progress', null, null, 'Pharmacy Scope Code', 'Normal', System.Now(), null, 'Pharmacy Scope Code Owner');
		System.assertEquals('In Progress', t.status);
	}
	
}