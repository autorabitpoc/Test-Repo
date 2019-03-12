/**************************************************************************************
  Apex Class Name     : OrganizationDAO
  Version             : 1.0
  Function            : This is a DAO for Organizations
  Modification Log    :
* Developer					Date
* ----------------------------------------------------------------------------
* Alec Klein				6/1/2016
*************************************************************************************/
public with sharing class OrganizationDAO implements IOrganizationDAO{ 
	public interface IOrganizationDAO{
		Boolean isRunningInSandbox();
		Id getCurrentOrganizationId();
	}

	public Boolean isRunningInSandbox(){
		return [SELECT Id, IsSandbox FROM Organization LIMIT 1].IsSandbox;
	}

	public Id getCurrentOrganizationId(){
		return UserInfo.getOrganizationId();
	}
}