public class EncryptionController {
    public String encryptionOutput {get;set;}
	public String decryptionOutput {get;set;}
    public String encryptedMessage {get;set;}
	public String unencryptedMessage {get;set;}
    public Blob encryptionKey;
	public Encryption_Key__c key;
	public Profile p;
	public ProfileDAO.IProfileDAO profileDAOInstance {get;set;}

    public EncryptionController(){
		this(new ProfileDAO());
    }

    private EncryptionController(ProfileDAO.IProfileDAO profileDAO){
    	this.profileDAOInstance = profileDAO;
		p = profileDAOInstance.getProfileByName('Integration Profile');
    	key = Encryption_Key__c.getInstance(p.id);
        encryptedMessage = '';
		unencryptedMessage = '';
        encryptionKey = EncodingUtil.base64Decode(key.Encryption_Key__c);
    }
    
    public void encryptMessage(){
        Blob cipherText = Crypto.encryptWithManagedIV('AES256', encryptionKey, Blob.valueOf(unencryptedMessage));
		encryptionOutput = encryptedMessage = EncodingUtil.base64Encode(cipherText);
    }
    
    public void decryptMessage(){
        Blob encodedEncryptedBlob = EncodingUtil.base64Decode(encryptedMessage);
		Blob decryptedBlob = Crypto.decryptWithManagedIV('AES256', encryptionKey, encodedEncryptedBlob);
		decryptionOutput = decryptedBlob.toString();
    }

	public void generateNewAESKey(){
		Blob newEncryptionKey = Crypto.generateAesKey(256);
		List<Username_Password__c> credentials = new List<Username_Password__c>();
		credentials.add(Username_Password__c.getInstance('Bluestar'));
		credentials.add(Username_Password__c.getInstance('BlueSTARUpdAddrService'));
		credentials.add(Username_Password__c.getInstance('Sandbox'));
		for(Username_Password__c cred: credentials){
			Blob encodedEncryptedBlob = EncodingUtil.base64Decode(cred.Password__c);
			Blob decryptedBlob = Crypto.decryptWithManagedIV('AES256', encryptionKey, encodedEncryptedBlob);
			String decryptedMessage = decryptedBlob.toString();
			Blob reEncryptedBlob = Crypto.encryptWithManagedIV('AES256', newEncryptionKey, Blob.valueOf(decryptedMessage));
			String reEncryptedMessage = EncodingUtil.base64Encode(reEncryptedBlob);
			cred.Password__c = reEncryptedMessage;
		}
		key.Encryption_Key__c = EncodingUtil.base64Encode(newEncryptionKey);
		update key;
		update credentials;
		encryptionKey = EncodingUtil.base64Decode(key.Encryption_Key__c);
	}

	public String getDecryptedMessage(String encryptedMessage){
        encryptionKey = EncodingUtil.base64Decode(Encryption_Key__c.getInstance(p.id).Encryption_Key__c);
		Blob encodedEncryptedBlob = EncodingUtil.base64Decode(encryptedMessage);
		Blob decryptedBlob = Crypto.decryptWithManagedIV('AES256', encryptionKey, encodedEncryptedBlob);
		return decryptedBlob.toString();
	}
}