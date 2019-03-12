/**************************************************************************************
  Apex Class Name     : PermissionSetDAO
  Version             : 1.0
  Function            : This is a DAO for PermissionSets
  Modification Log    :
* Developer					Date
* ----------------------------------------------------------------------------
* Alec Klein				6/2/2016
*************************************************************************************/
public with sharing class PermissionSetDAO implements IPermissionSetDAO{ 
	public interface IPermissionSetDAO{
		List<PermissionSet> getSUAndSPPermissionSetList();
	}

	public List<PermissionSet> getSUAndSPPermissionSetList(){
		String superUserLabel = System.Label.Super_User_Permissions;
		String strategicPlanLabel = System.Label.PermissionSetCanApproveStrategicPlans;
		return [SELECT Id, Name, PermissionsModifyAllData FROM PermissionSet WHERE Name =: superUserLabel OR Name =: strategicPlanLabel LIMIT 2];
	}
}