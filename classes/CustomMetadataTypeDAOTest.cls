/**************************************************************************************
  Apex Class Name     : CustomMetadataTypeTest
  Version             : 1.0
  Function            : This is a test class for CustomMetadataType.
  Modification Log    :
* Developer					Date
* ----------------------------------------------------------------------------
* Sana Fatima			6/3/2016
*************************************************************************************/
@isTest
public class CustomMetadataTypeDAOTest { 

	@isTest static void getClientProfileCompletionRateFieldsTest() {
		CustomMetadataTypeDAO.ICustomMetadataTypeDAO customMetadataTypeDAOInstance = new CustomMetadataTypeDAO(); 
		List<CP_Completion_Rate_Fields__mdt> rateFields = customMetadataTypeDAOInstance.getClientProfileCompletionRateFields();
		System.assert( !rateFields.isEmpty() );
	}

	@isTest static void getComplexityScoreFieldsTest() {
		CustomMetadataTypeDAO.ICustomMetadataTypeDAO customMetadataTypeDAOInstance = new CustomMetadataTypeDAO(); 
		List<Complexity_Score_Fields__mdt> complexityScoreFields = customMetadataTypeDAOInstance.getComplexityScoreFields();
		System.assert( !complexityScoreFields.isEmpty() );
	}
	@isTest static void getCustomMetadaTypeDynamicallyTest(){
		CustomMetadataTypeDAO.ICustomMetadataTypeDAO customMetadataTypeDAOInstance = new CustomMetadataTypeDAO();
		Account a = new Account();
		a.Name = 'Slalom Test Account';
		a.HCSC_Division__c = 'IL';
		insert a;
	    Account dynamicMetaData =(Account)customMetadataTypeDAOInstance.getCustomMetadaTypeDynamically('SELECT Id,Name FROM Account');

	    System.assertEquals('Slalom Test Account',dynamicMetaData.Name);
	}
	@isTest static void getCustomDataTypeByNameTest(){
		CustomMetadataTypeDAO.ICustomMetadataTypeDAO customMetadataTypeDAOInstance = new CustomMetadataTypeDAO();
	    List<Callout_Configuration__mdt> metaDataTypeNameList = new List<Callout_Configuration__mdt>();
	    metaDataTypeNameList.add(customMetadataTypeDAOInstance.getCustomMetadaTypeByName('BlueSTAR_Meab139_TEST'));
	    System.assert(!metaDataTypeNameList.isEmpty());

	}

}