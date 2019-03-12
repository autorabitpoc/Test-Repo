/**************************************************************************************
  Apex Class Name     : PermissionSetAssignmentDAOTest
  Version             : 1.0
  Function            : This is a test class for PermissionSetAssignmentDAO.
  Modification Log    :
* Developer					Date
* ----------------------------------------------------------------------------
* Alec Klein				6/3/2016
*************************************************************************************/
@isTest(SeeAllData = false)
public class PermissionSetAssignmentDAOTest {

	@isTest static void insertPermissionSetAssignmentListTest() {
		Profile p = [SELECT Id FROM Profile LIMIT 1];
		User u = TestClassUtiltity.CreateUserRecord(p.id, 'TestUsername@RandomDomain.com', 'TestLastName', 'Email@RandomDomain.com');
		System.runAs(u) {
			PermissionSet ps = new PermissionSet(Name = 'TestPS', Label = 'Test Permission Set');
			insert ps;

			PermissionSetAssignmentDAO.IPermissionSetAssignmentDAO permissionSetAssignmentDAOInstance = new PermissionSetAssignmentDAO();
			PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = u.Id, PermissionSetId = ps.Id);
			permissionSetAssignmentDAOInstance.insertPermissionSetAssignmentList(new List<PermissionSetAssignment> {psa});
			System.assert([SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = : u.Id AND PermissionSetId = : ps.Id].size() == 1);
		}
	}

	@isTest static void deletePermissionSetAssignmentListTest() {
		Profile p = [SELECT Id FROM Profile LIMIT 1];
		User u = TestClassUtiltity.CreateUserRecord(p.id, 'TestUsername@RandomDomain.com', 'TestLastName', 'Email@RandomDomain.com');
		System.runAs(u) {
			PermissionSet ps = new PermissionSet(Name = 'TestPS', Label = 'Test Permission Set');
			insert ps;

			PermissionSetAssignmentDAO.IPermissionSetAssignmentDAO permissionSetAssignmentDAOInstance = new PermissionSetAssignmentDAO();
			PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = u.Id, PermissionSetId = ps.Id);
			insert psa;
			System.assert([SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = : u.Id AND PermissionSetId = : ps.Id].size() == 1);
			permissionSetAssignmentDAOInstance.deletePermissionSetAssignmentList(new List<PermissionSetAssignment> {psa});
			System.assert([SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = : u.Id AND PermissionSetId = : ps.Id].size() == 0);
		}
	}

	@isTest static void getSUAndSPPermissionSetAssignmentListTest() {
		String superUserLabel = System.Label.Super_User_Permissions;
		String strategicPlanLabel = System.Label.PermissionSetCanApproveStrategicPlans;
		Map<String, PermissionSet> permissionSetMap	= new Map<String, PermissionSet>();
		for (PermissionSet ps : [SELECT Id, Name FROM PermissionSet WHERE Name = : superUserLabel OR Name = : strategicPlanLabel LIMIT 2]) {
			permissionSetMap.put(ps.Name, ps);
		}
		PermissionSet superUserPS = permissionSetMap.get(superUserLabel);
		PermissionSet strategicPlanPS = permissionSetMap.get(strategicPlanLabel);
		Profile p = [SELECT Id FROM Profile LIMIT 1];
		User superUserRec = TestClassUtiltity.CreateUserRecord(p.id, 'TestUsernameSuperUser@RandomDomain.com', 'TestLastName', 'EmailSuperUser@RandomDomain.com');
		User strategicPlanUserRec = TestClassUtiltity.CreateUserRecord(p.id, 'TestUsernameStrategicPlan@RandomDomain.com', 'TestLastName', 'EmailStrategicPlan@RandomDomain.com');
		PermissionSetAssignment psaSU = new PermissionSetAssignment(AssigneeId = superUserRec.Id, PermissionSetId = superUserPS.Id);
		PermissionSetAssignment psaSP = new PermissionSetAssignment(AssigneeId = strategicPlanUserRec.Id, PermissionSetId = strategicPlanPS.Id);
		insert new List<PermissionSetAssignment> {psaSU, psaSP};
		Set<Id> superUserIds = new Set<Id> {superUserRec.Id};
		Set<Id> strategicPlanUserIds = new Set<Id> {strategicPlanUserRec.Id};
		PermissionSetAssignmentDAO.IPermissionSetAssignmentDAO permissionSetAssignmentDAOInstance = new PermissionSetAssignmentDAO();
		List<PermissionSetAssignment> psaDAOList = permissionSetAssignmentDAOInstance.getSUAndSPPermissionSetAssignmentList(superUserPS.Id, strategicPlanPS.Id, superUserIds, strategicPlanUserIds);
		List<PermissionSetAssignment> psaList = [SELECT Id, PermissionSetId FROM PermissionSetAssignment WHERE
		                                        (PermissionSetId = : superUserPS.Id AND AssigneeId IN :superUserIds) OR
		                                        (PermissionSetId = : strategicPlanPS.Id AND AssigneeId IN :strategicPlanUserIds)
		                                        LIMIT :Limits.getLimitQueryRows() - Limits.getQueryRows()];
		System.assertEquals(psaDAOList.size(), psaList.size());
		for (Integer i = 0; i < psaDAOList.size(); i++) {
			System.assertEquals(psaDAOList[i], psaList[i]);
		}
	}
}