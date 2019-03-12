/**************************************************************************************
  Apex Class Name     : EncryptionUtility
  Version             : 1.0
  Function            : This is a utility for Encryption
  Modification Log    :
* Developer                 Date
* ----------------------------------------------------------------------------
* Alec Klein                5/25/2016
*************************************************************************************/
public class EncryptionUtility implements IEncryptionUtility {
    
    public interface IEncryptionUtility{
        String getDecryptedMessage(String encryptedMessage);
    }

    @TestVisible private ProfileDAO.IProfileDAO profileDAOInstance;
    @TestVisible private CustomSettingDAO.ICustomSettingDAO customSettingDAOInstance;
    
    public EncryptionUtility(){
        this(new ProfileDAO(), new CustomSettingDAO());
    }
    @TestVisible private EncryptionUtility(ProfileDAO.IProfileDAO profileDAOInstance, CustomSettingDAO.ICustomSettingDAO customSettingDAOInstance){
        this.profileDAOInstance = profileDAOInstance;
        this.customSettingDAOInstance = customSettingDAOInstance;
    }

    public String getDecryptedMessage(String encryptedMessage) {
        try {
             system.debug('encryptedMessage -- '+ encryptedMessage);
            Id integrationProfileId = profileDAOInstance.getProfileByName('Integration Profile').Id;
           // system.debug('first one');
            Blob encryptionKey = EncodingUtil.base64Decode(customSettingDAOInstance.getEncryptionKeyCSByProfileId(integrationProfileId).Encryption_Key__c);
           //  system.debug('second one');
            Blob encodedEncryptedBlob = EncodingUtil.base64Decode(encryptedMessage);
             //system.debug('third one');
            Blob decryptedBlob = Crypto.decryptWithManagedIV('AES256', encryptionKey, encodedEncryptedBlob);
           //  system.debug('fourth one');
            return decryptedBlob.toString();
        } catch (Exception e) {
            CreateExceptionLog.insertErrorLog(e, null, null, null, 'Apex Class', 'EncryptionUtility', null, 'EncryptionUtility.getDecryptedMessage()', 'High');
        }
        return encryptedMessage;
    }
    
    public String getEncryptedMessage(String decryptedMessage){
    	
    	Id integrationProfileId = profileDAOInstance.getProfileByName('Integration Profile').Id;
        Blob encryptionKey = EncodingUtil.base64Decode(customSettingDAOInstance.getEncryptionKeyCSByProfileId(integrationProfileId).Encryption_Key__c);
		Blob cipherText = Crypto.encryptWithManagedIV('AES256', encryptionKey, Blob.valueOf(decryptedMessage));
		String encryptedMessage = EncodingUtil.base64Encode(cipherText);
		System.debug('encryptedMessage--'+encryptedMessage);
		return encryptedMessage;
    }
    
    
}