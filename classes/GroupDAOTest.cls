/**************************************************************************************
  Apex Class Name     : GroupDAOTest
  Version             : 1.0
  Function            : This is a test class for GroupDAO.
  Modification Log    :
* Developer					Date
* ----------------------------------------------------------------------------                 
* Alec Klein				6/21/2016
*************************************************************************************/
@isTest(SeeAllData=false)
public class GroupDAOTest {
	@isTest static void getQueuesByNamesTest(){
		GroupDAO.IGroupDAO groupDAOInstance = new GroupDAO();
		Set<String> queueNames = new Set<String>();
		List<Group> groupRecords = [SELECT Id, Name FROM Group WHERE Type = 'Queue' LIMIT 5];
		for(Group g: groupRecords){
			queueNames.add(g.Name);
		}
		List<Group> daoGroupRecords = groupDAOInstance.getQueuesUsingNames(queueNames);
		System.assertEquals(groupRecords, daoGroupRecords);
	}
}