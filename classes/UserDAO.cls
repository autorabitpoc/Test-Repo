/**************************************************************************************
  Apex Class Name     : UserDAO
  Version             : 1.0
  Function            : This is a User DAO class for accessing the User object.
  Modification Log    :
* Developer                 Date
* ----------------------------------------------------------------------------
* Alec Klein                6/8/2016
* Nathan Shuyler SFDC-7931 02/23/2018 - Added Function that Checks a Users Active Status
                                         when an Id is provided
*************************************************************************************/
public class UserDAO implements IUserDAO {

    public interface IUserDAO {
        User createUser(Id profileId, String username, String lastName, String email);
        Id getUserIdByProfileName(String name);
        List<User> getUsersWithEmployeeNumber(Set<String> userIds);
        User getCurrentUser();
        User getUserByName(String userName);
        //User getRequesterForTicketDistro(Id requesterId);
        Contact getRequesterForTicketDistro(Id requesterId);
        
        //List<User> getCostCenterForTicketDistro(Set<Id> userIds);
        List<Contact> getContactCostCenterForTicketDistro(Set<Id> contactIds);
    }

    public User createUser(Id profileId, String username, String lastName, String email) {
        return new User(Alias = 'test', Email = email, EmailEncodingKey = 'UTF-8', LastName = lastName, LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = profileId, TimeZoneSidKey = 'America/Los_Angeles', UserName = username);
    }

    public Id getUserIdByProfileName(String name) {
        return [SELECT Id FROM User WHERE Profile.Name = : name LIMIT 1].Id;
    }

    public List<User> getUsersWithEmployeeNumber(Set<String> userIds) {
        return [SELECT Id, EmployeeNumber FROM User WHERE Id IN :userIds];
    }

    public User getCurrentUser(){
        return [SELECT Id, Name,profile.Name,profileId, Lan_Id__c from User where Id = :UserInfo.getUserId()];
    }
    
    public User getUserByName(String userName){        
        list<User> usr=[SELECT Id,name,email,ProfileId,IsActive FROM User WHERE name=:userName and IsActive=true limit 1];
        system.debug('user from getuserbyName:;;;'+usr+'-->'+userName+'<--');
        if(!usr.isEmpty()){
            return usr[0];
        }else{
            return null;             
        }         
    }
    
    /*** SFDC-7931 Begin ***/
    public User getUserByID(Id UserID){
        List<User> usr = [SELECT 
                          Id,name,email,ProfileId,IsActive
                          FROM User 
                          WHERE Id=:UserID 
                          AND IsActive=true 
                          LIMIT 1];
        system.debug('User from getUserByID: ' + usr + ' '+ UserID);
        if(!usr.isEmpty()){
            return usr[0];
        }else{
            return null;
        } 
    }
    /*** SFDC-7931 End ***/

    /*public User getRequesterForTicketDistro(Id requesterId){
        return [SELECT FirstName, LastName FROM User WHERE Id = :requesterId LIMIT 1];
    }*/
    
    public Contact getRequesterForTicketDistro(Id requesterId){
        return  [SELECT Id, FirstName, LastName FROM Contact WHERE Id = :requesterId LIMIT 1];//[SELECT FirstName, LastName FROM User WHERE Id = :requesterId LIMIT 1];
    }
     
     

/*  public List<User> getCostCenterForTicketDistro(Set<Id> userIds){
        return [SELECT Id, Cost_Center__c, Email FROM User WHERE Id IN :userIds];
    }*/
    
    public List<Contact> getContactCostCenterForTicketDistro(Set<Id> contactIds){
        return [SELECT Id, Cost_Center__c, Email FROM Contact WHERE Id IN :contactIds];
    }
}