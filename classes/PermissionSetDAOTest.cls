/**************************************************************************************
  Apex Class Name     : PermissionSetDAOTest
  Version             : 1.0
  Function            : This is a test class for PermissionSetDAO.
  Modification Log    :
* Developer					Date
* ----------------------------------------------------------------------------                 
* Alec Klein				6/3/2016
*************************************************************************************/
@isTest(SeeAllData=false)
public class PermissionSetDAOTest{
	@isTest static void getSUAndSPPermissionSetListTest(){
		PermissionSetDAO.IPermissionSetDAO permissionSetDAOInstance = new PermissionSetDAO();
		List<PermissionSet> psDAOList = permissionSetDAOInstance.getSUAndSPPermissionSetList();
		List<PermissionSet> psList = [SELECT Id, Name FROM PermissionSet WHERE Name =: System.Label.Super_User_Permissions OR Name =: System.Label.PermissionSetCanApproveStrategicPlans LIMIT 2];
		System.assertEquals(psDAOList.get(0).Name, psList.get(0).Name);
		System.assertEquals(psDAOList.get(1).Name, psList.get(1).Name);
		System.assert(psDAOList.size() == 2);
		System.assert(psList.size() == 2);
	}
}