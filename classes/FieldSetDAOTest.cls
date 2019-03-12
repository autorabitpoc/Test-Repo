/**************************************************************************************
  Apex Class Name     : FieldSetDAOTest
  Version             : 1.0
  Function            : This is a test class for FieldSetDAO.
  Modification Log    :
* Developer					Date
* ----------------------------------------------------------------------------
* Alec Klein				6/1/2016
*************************************************************************************/
@isTest(SeeAllData=true)
public class FieldSetDAOTest { 
	@isTest static void getFieldSetByNameAndSObjectTest(){
		String sObjectType = 'Contact';
		String fieldSetName = 'BlueSTAR_Contact_Primary_Required_Fields';
		FieldSetDAO.IFieldSetDAO fieldSetDAOInstance = new FieldSetDAO();
		Schema.FieldSet contactPrimaryFieldSet = fieldSetDAOInstance.getFieldSetByNameAndSObject(fieldSetName, sObjectType);
		System.assert(contactPrimaryFieldSet.getFields().size() > 0);
	}

	@isTest static void getFieldSetMemberFieldPathsTest(){
		Schema.FieldSet contactPrimaryFieldSet = Schema.SObjectType.Contact.fieldSets.getMap().get('BlueSTAR_Contact_Primary_Required_Fields');
		FieldSetDAO.IFieldSetDAO fieldSetDAOInstance = new FieldSetDAO();
		List<String> contactPrimaryList = fieldSetDAOInstance.getFieldSetMemberFieldPaths(contactPrimaryFieldSet);
		System.assert(contactPrimaryList.size() > 0);
	}
}