/**************************************************************************************
  Apex Class Name     : ProfileDAOTest
  Version             : 1.0
  Function            : This is a test class for ProfileDAO.
  Modification Log    :
* Developer					Date
* ----------------------------------------------------------------------------                 
* Alec Klein				5/25/2016
*************************************************************************************/
@isTest
public class ProfileDAOTest {
	@isTest static void getProfileByNameTest(){
		ProfileDAO.IProfileDAO profileDAOInstance = new ProfileDAO();
		Profile userProfile = profileDAOInstance.getProfileByName('Standard User');
		System.assert(userProfile != null);
		System.assertEquals(userProfile.Name, 'Standard User');
	}

	@isTest static void getProfileByIdTest(){
		ProfileDAO.IProfileDAO profileDAOInstance = new ProfileDAO();
		Profile userProfile1 = profileDAOInstance.getProfileByName('Standard User');
		Profile userProfile2 = profileDAOInstance.getProfileById(userProfile1.Id);
		System.assert(userProfile1 != null);
		System.assert(userProfile2 != null);
		System.assertEquals(userProfile1.Name, userProfile2.Name);
	}
}