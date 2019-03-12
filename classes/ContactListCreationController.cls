/**************************************************************************************
  Apex Class Name     : ContactListCreationController
  Version             : 1.0
  Function            : This class handles the logic for selecting a specific list of contacts to be exported to a pdf file through Conga Composer
  Modification Log    :
 * Developer                    Date                    Description
 * ----------------------------------------------------------------------------
 *   Nick Serafin/Slalom       05/09/2016                Original Version
 *************************************************************************************/

public with sharing class ContactListCreationController {

	public Id accountId{get;set;} 
	public ContactTeamWrapper accountTeamMemberRecord;
	public ContactTeamNonSFWrapper accountTeamNonSFMemberRecord;
	public List<ContactTeamWrapper> listOfAccountTeamMembers {get;set;}
	public List<ContactTeamNonSFWrapper> listOfAccountTeamNonSFMembers {get;set;}
	public List<AccountTeamMember> accountTeamMemberRecords;
	public List<Account_Team_Non_SF__c> accountTeamMemberNonSFRecords;
	public List<AccountTeamMember> selectedAccountTeamMembers; 
	public List<Account_Team_Non_SF__c> selectedAccountTeamNonSFMembers; 
	public List<String> accountTeamMemberIds {get;set;}
	public List<String> accountTeamNonSFMemberIds {get;set;}
	public String templateId {get;set;}
	public String acccountTeamQueryId {get;set;}
	public String acccountTeamNonSFQueryId {get;set;}
	public String congaUrl {get;set;}
	public String congaDefaultPDF {get;set;}
	public String congaDS7 {get;set;}
	public String defaultPDFLabel {get;set;}
	public String ds7Label {get;set;}

	public ContactListCreationController(ApexPages.StandardController stdController) {

		try{

			accountId = ApexPages.currentPage().getParameters().get('Id');

			Conga_Composer__mdt congaTemplateName = [SELECT template__c FROM Conga_Composer__mdt WHERE DeveloperName = 'template' LIMIT 1];

			String templateName = congaTemplateName.template__c;

			APXTConga4__Conga_Template__c template = [SELECT Id FROM APXTConga4__Conga_Template__c WHERE APXTConga4__Name__c = :templateName LIMIT 1];
			APXTConga4__Conga_Merge_Query__c congaQueryTeam = [SELECT Id FROM APXTConga4__Conga_Merge_Query__c WHERE APXTConga4__Name__c = 'AccountTeam' LIMIT 1];
			APXTConga4__Conga_Merge_Query__c congaQueryTeamNonSF = [SELECT Id FROM APXTConga4__Conga_Merge_Query__c WHERE APXTConga4__Name__c = 'AccountTeamNonSF' LIMIT 1];
  		  
 			templateId = template.Id;		
 			acccountTeamQueryId = congaQueryTeam.Id;		 
 			acccountTeamNonSFQueryId = congaQueryTeamNonSF.Id; 

 			List<Conga_Composer__mdt> congaMetadataType = [SELECT DeveloperName, Url__c FROM Conga_Composer__mdt];

			Map<String, String> congaURlParameters = new Map<String, String>();

			for(Conga_Composer__mdt conga : congaMetadataType){

				congaURlParameters.put(conga.DeveloperName, conga.Url__c);
			}

			congaUrl = congaURlParameters.get('CongaUrl');
			congaDefaultPDF = congaURlParameters.get('DefaultPDF');
			congaDS7 = congaURlParameters.get('DS7');

			for (String label : congaURlParameters.keySet()){

				if(label == 'DefaultPDF'){
					defaultPDFLabel = label;
				} else if (Label == 'DS7'){
					ds7Label = label;
				}
			}

			accountTeamMemberRecords = [SELECT User.Id, User.Name, User.Email, User.Phone, TeamMemberRole FROM AccountTeamMember WHERE AccountId = :accountId ORDER BY User.Name];
			accountTeamMemberNonSFRecords = [SELECT Team_Member_Name__c, Team_Member_Name__r.Name, Team_Member_Name__r.Email, Team_Member_Name__r.Phone, Member_Role__c FROM Account_Team_Non_SF__c WHERE Account_Name__c = :accountId ORDER BY Team_Member_Name__r.Name];

			listOfAccountTeamMembers = new List<ContactTeamWrapper>();
			listOfAccountTeamNonSFMembers = new List<ContactTeamNonSFWrapper>();

			if (!accountTeamMemberRecords.isEmpty()) {

				for (AccountTeamMember accountTeamMember : accountTeamMemberRecords) {

					accountTeamMemberRecord = new ContactTeamWrapper(false, accountTeamMember);
					listOfAccountTeamMembers.add(accountTeamMemberRecord);
				}
			}

			if (!accountTeamMemberNonSFRecords.isEmpty()) {

				for (Account_Team_Non_SF__c accountTeamMemberNonSF : accountTeamMemberNonSFRecords) {

					accountTeamNonSFMemberRecord = new ContactTeamNonSFWrapper(false, accountTeamMemberNonSF);
					listOfAccountTeamNonSFMembers.add(accountTeamNonSFMemberRecord);
				}

			}

		} catch (Exception ex) {
			System.debug('#####' + Label.Error + ex.getMessage() + ex.getStackTraceString());
		}
	}


	public PageReference sendContactsToConga(){

		try{

			selectedAccountTeamMembers = new List<AccountTeamMember>();
			selectedAccountTeamNonSFMembers = new List<Account_Team_Non_SF__c>();

			accountTeamMemberIds = new List<String>();
			accountTeamNonSFMemberIds = new List<String>();

			for (ContactTeamWrapper teamWrapperObject : listOfAccountTeamMembers) {

				if (teamWrapperObject.isSelected == true) {
					selectedAccountTeamMembers.add(teamWrapperObject.accountTeamMemberObj);
				}
			}

			for (ContactTeamNonSFWrapper teamNonSFWrapperObject : listOfAccountTeamNonSFMembers) {

				if (teamNonSFWrapperObject.isSelected == true) {
					selectedAccountTeamNonSFMembers.add(teamNonSFWrapperObject.accountTeamNonSFObj);
				}
			}

			if(selectedAccountTeamMembers.isEmpty() && selectedAccountTeamNonSFMembers.isEmpty()){

				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Contact_List_Creation_No_Contacts_Selected));
				return null;
			}

			if (!selectedAccountTeamMembers.isEmpty()) {

				for(AccountTeamMember accountTeamObj : selectedAccountTeamMembers){
					accountTeamMemberIds.add(accountTeamObj.User.Id);
				}
			}

			if(!selectedAccountTeamNonSFMembers.isEmpty()) {
				
				for(Account_Team_Non_SF__c accountTeamNonSFObj : selectedAccountTeamNonSFMembers){
					accountTeamNonSFMemberIds.add(accountTeamNonSFObj.Team_Member_Name__c);
				}			
			}
			return null;

		} catch (Exception ex) {
			CreateExceptionLog.insertErrorLog(ex, null, null, null, 'Apex Class', 'account', null, 'ContactListCreationController.sendContactsToConga()', 'High');
			return null;
		}
	}

	public PageReference backToAccount(){

		PageReference pageRef = new PageReference('/' + accountId);
		return pageRef;
	}

	public Class ContactTeamWrapper{

		public boolean isSelected {get;set;}
		public AccountTeamMember accountTeamMemberObj {get;set;}

		public ContactTeamWrapper(boolean isSelected, AccountTeamMember accountTeamMemberObj){

			this.isSelected = isSelected;
			this.accountTeamMemberObj = accountTeamMemberObj;
		}
	}

	public Class ContactTeamNonSFWrapper{

		public boolean isSelected {get;set;}
		public Account_Team_Non_SF__c accountTeamNonSFObj {get;set;}

		public ContactTeamNonSFWrapper(boolean isSelected, Account_Team_Non_SF__c accountTeamNonSFObj){

			this.isSelected = isSelected;
			this.accountTeamNonSFObj = accountTeamNonSFObj;
		}
	}
}