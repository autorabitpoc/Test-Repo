/**************************************************************************************
  Apex Class Name     : UserDAOTest
  Version             : 1.0
  Function            : This is a test class for UserDAO.
  Modification Log    :
* Developer					Date
* ----------------------------------------------------------------------------
* Alec Klein				6/8/2016
* Nathan Shuyler SFDC-7931 02/23/2018 - Added Test Method testgetUserByIdMethod
*************************************************************************************/
@isTest(SeeAllData = false)
public class UserDAOTest {

	@isTest static void getUsersWithEmployeeNumberTest() {
		Profile p = [SELECT Id FROM Profile LIMIT 1];
		User u = new User(Alias = 'test', Email = 'uniqueUsername@testemail.com', EmailEncodingKey = 'UTF-8', LastName = 'Last Name', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'uniqueUsername@testemail.com');
		insert u;
		Set<String> userIds = new Set<String>();
		userIds.add(u.Id);

		UserDAO.IUserDAO userDAOInstance = new UserDAO();
		List<User> testUserList = userDAOInstance.getUsersWithEmployeeNumber(userIds);
		System.assert(testUserList.size() == 1);
	}
    
    @isTest static void testcreateUserMethod(){
        Profile p = [SELECT Id FROM Profile LIMIT 1];
        UserDAO.IUserDAO userDAOInstance = new UserDAO();
        User u = userDAOInstance.createUser(p.Id,'AUserName','ALastName','uniqueUsername@testemail.com');
        System.assert(u.ProfileId == p.Id);
        System.assert(u.Username =='AUserName');
        System.assert(u.LastName =='ALastName');        
    }
    
    @isTest static void testgetUserIdByProfileNameMethod(){
        UserDAO.IUserDAO userDAOInstance = new UserDAO();
        Id uID = userDAOInstance.getUserIdByProfileName('System Administrator');        
        User u2 =[SELECT Id, Profile.Name FROM User WHERE Id = :uID LIMIT 1];               
        System.assert(u2.Profile.Name == 'System Administrator');      
    }
    
    @isTest static void testgetCurrentUserMethod(){
        String u1Id = UserInfo.getUserId();
        User u1 = [SELECT Name from User WHERE Id = :u1Id LIMIT 1];
        UserDAO.IUserDAO userDAOInstance = new UserDAO();
        User u2 = userDAOInstance.getCurrentUser();
        System.assert(u1.Name == u2.Name);        
    }
    
    @isTest static void testgetUserByNameMethod(){
        Profile p = [SELECT Id FROM Profile LIMIT 1];
		User u = new User(IsActive=true, Alias = 'test', Email = 'uniqueUsername@testemail.com', EmailEncodingKey = 'UTF-8', FirstName = 'FirstName', LastName = 'LastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'uniqueUsername@testemail.com');
		insert u;
        UserDAO.IUserDAO userDAOInstance = new UserDAO();
        User u2 = userDAOInstance.getUserByName('FirstName LastName');
        System.assert(u2.Name == 'FirstName LastName');
        User u3 = userDAOInstance.getUserByName('NotFound Name');
        System.assertEquals(u3, null);
    }
    
    // SFDC-7931 - Begin //
    @isTest static void testgetUserByIdMethod(){
        Profile p = [SELECT Id FROM Profile LIMIT 1];
		User u = new User(IsActive=true, Alias = 'test', Email = 'uniqueUsername@testemail.com', EmailEncodingKey = 'UTF-8', FirstName = 'FirstName', LastName = 'LastName', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'uniqueUsername@testemail.com');
		insert u;
        UserDAO userDAOInstance = new UserDAO();
        Id AnID = u.Id;
        User u2 = userDAOInstance.getUserByID(AnID);
        System.assert(u2.Name == 'FirstName LastName');
    }
    // SFDC-7931 - End   // 
    
    @isTest static void testgetRequesterForTicketDistroMethod(){
        Account a = TestClassUtiltity.CreateAccountRecord('TheBigAccount');
        Contact c = TestClassUtiltity.CreateContactRecord(a.Id,'ContactFirst','ContactLast',null); 
        UserDAO.IUserDAO userDAOInstance = new UserDAO();
        Contact c2 = userDAOInstance.getRequesterForTicketDistro(c.Id);
        System.assert(c2.FirstName=='ContactFirst');
        System.assert(c2.LastName=='ContactLast');
    }
    
    @isTest static void testgetContactCostCenterForTicketDistroMethod(){
        Account a = TestClassUtiltity.CreateAccountRecord('TheBigAccount');
        Contact c = TestClassUtiltity.CreateContactRecord(a.Id,'ContactFirst','ContactLast',null); 
        c.Cost_Center__c = 'MyCostCenter';
        c.Email = 'Contact@testemail.com';
        upsert c;
        Set<Id> ASetOfIDs = new Set<Id>();
        ASetOfIDs.add(c.Id);       
        UserDAO.IUserDAO userDAOInstance = new UserDAO();
        List<Contact> AListOfContacts = userDAOInstance.getContactCostCenterForTicketDistro(ASetOfIDs);
        System.assert(AListOfContacts[0].Cost_Center__c == 'MyCostCenter');
        System.assert(AListOfContacts[0].Email == 'Contact@testemail.com');        
    }
    
}