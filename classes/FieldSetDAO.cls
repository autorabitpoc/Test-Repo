/**************************************************************************************
  Apex Class Name     : FieldSetDAO
  Version             : 1.0
  Function            : This is a DAO for Field Sets.
  Modification Log    :
* Developer					Date
* ----------------------------------------------------------------------------
* Alec Klein				5/26/2016
*************************************************************************************/
public with sharing class FieldSetDAO implements IFieldSetDAO{
	public interface IFieldSetDAO{
		Schema.FieldSet getFieldSetByNameAndSObject(String fieldSetName, String objectName);
		List<String> getFieldSetMemberFieldPaths(Schema.FieldSet fieldSet);
	}

	public Schema.FieldSet getFieldSetByNameAndSObject(String fieldSetName, String objectName){
		Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe(); 
		Schema.SObjectType objectType = globalDescribeMap.get(objectName);
		Schema.DescribeSObjectResult objectResult = objectType.getDescribe();
		Schema.FieldSet fieldSet = objectResult.FieldSets.getMap().get(fieldSetName);
		return fieldSet; 
	}

	public List<String> getFieldSetMemberFieldPaths(Schema.FieldSet fieldSet){
		List<String> fieldPaths = new List<String>();
		for(FieldSetMember fieldSetMember: fieldSet.getFields()){
			fieldPaths.add(fieldSetMember.getFieldPath());
		}
		return fieldPaths;
	}
}