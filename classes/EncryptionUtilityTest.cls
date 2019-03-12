/**************************************************************************************
  Apex Class Name     : EncryptionUtilityTest
  Version             : 1.0
  Function            : This is a test class for EncryptionUtilityTest.
  Modification Log    :
* Developer					Date
* ----------------------------------------------------------------------------
* Alec Klein				6/2/2015
*************************************************************************************/
@isTest(SeeAllData = false)
public class EncryptionUtilityTest {

	@isTest static void getDecryptedMessageTest() {
		String profileId = fflib_IDGenerator.generate(Profile.SObjectType);
		Profile testProfile = new Profile();
		testProfile.Id = profileId;
		testProfile.Name = 'Integration Profile';
		fflib_ApexMocks profMocks = new fflib_ApexMocks();
		ProfileDAO.IProfileDAO profMockDAO = new MockDAOs.ProfileDAOMock(profMocks);
		profMocks.startStubbing();
		profMocks.when(profMockDAO.getProfileByName('Integration Profile')).thenReturn(testProfile);
		profMocks.stopStubbing();

		Encryption_Key__c testKey = new Encryption_Key__c();
		testKey.Name = 'Test Key';
		testKey.Encryption_Key__c = EncodingUtil.base64Encode(Crypto.generateAesKey(256));
		testKey.SetupOwnerId = testProfile.Id;
		fflib_ApexMocks csMocks = new fflib_ApexMocks();
		CustomSettingDAO.ICustomSettingDAO csMockDAO = new MockDAOs.CustomSettingDAOMock(csMocks);
		csMocks.startStubbing();
		csMocks.when(csMockDAO.getEncryptionKeyCSByProfileId(testProfile.Id)).thenReturn(testKey);
		csMocks.stopStubbing();

		EncryptionUtility encryptionUtility = new EncryptionUtility();

		encryptionUtility.profileDAOInstance = profMockDAO;
		encryptionUtility.customSettingDAOInstance = csMockDAO;

		String message = 'Encrypt Me!';
		Blob encryptionKey = EncodingUtil.base64Decode(testKey.Encryption_Key__c);
		Blob encryptedData = Crypto.encryptWithManagedIV('AES256', encryptionKey, Blob.valueOf(message));
		String encryptedMessage = EncodingUtil.base64Encode(encryptedData);
		String decryptedMessage = encryptionUtility.getDecryptedMessage(encryptedMessage);
		System.assert(message != encryptedMessage);
		System.assert(message == decryptedMessage);
	}
}