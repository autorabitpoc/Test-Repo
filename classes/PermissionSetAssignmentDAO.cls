/**************************************************************************************
  Apex Class Name     : PermissionSetAssignmentDAO
  Version             : 1.0
  Function            : This is a DAO for PermissionSetAssignments
  Modification Log    :
* Developer					Date
* ----------------------------------------------------------------------------
* Alec Klein				6/2/2016
*************************************************************************************/
public class PermissionSetAssignmentDAO implements IPermissionSetAssignmentDAO {
	public interface IPermissionSetAssignmentDAO {
		void insertPermissionSetAssignmentList(List<PermissionSetAssignment> permissionSetAssignments);
		void deletePermissionSetAssignmentList(List<PermissionSetAssignment> permissionSetAssignments);
		List<PermissionSetAssignment> getSUAndSPPermissionSetAssignmentList(Id superUserPSId, Id strategicPlanPSId, Set<Id> superUserIds, Set<Id> strategicPlanUserIds);
	}

	public void insertPermissionSetAssignmentList(List<PermissionSetAssignment> permissionSetAssignments) {
		insert permissionSetAssignments;
	}

	public void deletePermissionSetAssignmentList(List<PermissionSetAssignment> permissionSetAssignments) {
		delete permissionSetAssignments;
	}

	public List<PermissionSetAssignment> getSUAndSPPermissionSetAssignmentList(Id superUserPSId, Id strategicPlanPSId, Set<Id> superUserIds, Set<Id> strategicPlanUserIds) {
		return [SELECT Id, PermissionSetId FROM PermissionSetAssignment WHERE
		        (PermissionSetId = : superUserPSId AND AssigneeId IN :superUserIds) OR
		        (PermissionSetId = : strategicPlanPSId AND AssigneeId IN :strategicPlanUserIds)
		        LIMIT :Limits.getLimitQueryRows() - Limits.getQueryRows()];
	}
}