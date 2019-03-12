/**************************************************************************************
  Apex Class Name     : OrganizationDAOTest
  Version             : 1.0
  Function            : This is a test class for OrganizationDAO.
  Modification Log    :
* Developer					Date
* ----------------------------------------------------------------------------                 
* Alec Klein				5/23/2016
*************************************************************************************/
@isTest
public class OrganizationDAOTest { 
	@isTest static void isRunningInSandboxTest(){
		OrganizationDAO.IOrganizationDAO organizationDAOInstance = new OrganizationDAO();
		Organization currentOrg = [SELECT Id, IsSandbox FROM Organization LIMIT 1];
		Boolean isSandbox = organizationDAOInstance.isRunningInSandbox();
		System.assertEquals(isSandbox, currentOrg.IsSandbox);
	}

	@isTest static void getCurrentOrganizationIdTest(){
		OrganizationDAO.IOrganizationDAO organizationDAOInstance = new OrganizationDAO();		
		Organization currentOrg = [SELECT Id FROM Organization LIMIT 1];
		Id sandboxId = organizationDAOInstance.getCurrentOrganizationId();
		System.assertEquals(sandboxId, currentOrg.Id);
	}
}