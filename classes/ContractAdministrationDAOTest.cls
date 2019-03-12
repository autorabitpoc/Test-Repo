@isTest(SeeAllData = false)
public class ContractAdministrationDAOTest {

	@isTest
	static void contractAdministrationDAOTest() {
		Test.StartTest();

		ContractAdministrationDAO.IContractAdministrationDAO contractAdminDAOInstance = new ContractAdministrationDAO();
		Set<Id> accIds = new Set<Id>();
		Account testAcnt = TestClassUtiltity.CreateAccountRecord('TestAccount');
		accIds.add(testAcnt.id);

		Contract_Administration__c contractAdmin = new Contract_Administration__c(Account__c = testAcnt.id, Status__c = 'Fully Executed', Complexity__c = 'Medium');
		insert contractAdmin;

		List<Contract_Administration__c> contractAdmins = contractAdminDAOInstance.getContractAdminsByGroupAccounts(accIds);

		System.assertEquals( contractAdmins.size(), 1);

		Test.StopTest();
	}
 }