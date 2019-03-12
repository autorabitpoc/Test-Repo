/**************************************************************************************
  Apex Class Name     : GroupDAO
  Version             : 1.0
  Function            : This is a Group DAO class for accessing the Group Object
  Modification Log    :
* Developer                 Date
* ----------------------------------------------------------------------------
* Alec Klein              6/21/2016
*************************************************************************************/
public with sharing class GroupDAO implements IGroupDAO {

    public interface IGroupDAO {
		List<Group> getQueuesUsingNames(Set<String> queueNames);
	}

	public List<Group> getQueuesUsingNames(Set<String> queueNames){
		return [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name IN :queueNames];
	}
}