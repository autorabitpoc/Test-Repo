/***********************************************************************************************************
* Apex Class Name     : SharePointFolderBuilder
* Version             : 1.0
* Function            : Class builds the Sharepoint folder name and folder paths for Salesforce objects
*						(Account, Opportunity, and Case) ensuring that each folder name is less than or
*						equal to 50 characters and stripped of vowels after the initial 2 characters.
* Modification Log    :
* Developer				Date			Description
* ----------------------------------------------------------------------------
* Sana Fatima/Slalom					Initial version creation
* Malathi Kethireddy	09/22/17		SFDC-5096 - build Account Maintenance SharePoint folders
* Zachary Campbell		12/22/17		SFDC-4784 - build Quote Request SharePoint folders
***********************************************************************************************************/
public class SharePointFolderBuilder {

    public static String prospectAccountNumber = ConstantsController.prospectAccNum;

    //builds SharePoint foldername for Accounts based off of Account name and number
    public static String buildAccountFolderName(String acctName, String acctNum) {

        String accFolderName;
        String formattedAccountName = removeVowels(acctName);

        if ( acctNum == null && (formattedAccountName + '_' + prospectAccountNumber).length() > 50 ) {
            accFolderName = formattedAccountName.left(50 - (prospectAccountNumber + 1).length() )
                            + '_' + prospectAccountNumber;
        } else if (acctNum == null && (formattedAccountName + '_' + prospectAccountNumber).length() < 50) {
            accFolderName = formattedAccountName + '_' + prospectAccountNumber;
        } else if ( (formattedAccountName + '_' + acctNum ).length() > 50 ) {
            accFolderName = formattedAccountName.left(50 - (acctNum + 1).length() )
                            + '_' + acctNum;
        } else {
            accFolderName = formattedAccountName + '_' + acctNum;
        }
        return accFolderName;
    }

    //builds SharePoint foldername for Opportunities
    public static String buildOpportunityFolderName(String oppName) {

        String oppFolderName;
        String formattedOppName = removeVowels(oppName);

        if ( formattedOppName.length() > 50) {
            oppFolderName = formattedOppName.left(50);
        } else {
            oppFolderName = formattedOppName;
        }
        return oppFolderName.replaceAll('\\s+$', '');
    }


    public static String buildCaseFolderName() {
        //Case folder names are currently CaseNumber,
        //should they be record type name instead for readability?
        return null;
    }

    //builds SharePoint folderpath for Opportunity based on parent account
    public static String buildOpportunityFolderPath(String oppName, Id accId, Map<Id, Account> accMap) {

        String oppFolderName = buildOpportunityFolderName(oppName);
        Account acc = accMap.get( accId );
        String accFolderName = buildAccountFolderName( acc.Name, acc.External_Id__c );
        return accFolderName + '/' + oppFolderName;
    }

    //builds SharePoint folderpath for case based on parent opportunity and it's parent account
    public static String buildCaseFolderPath(String CaseNumber, Id oppId, Map<Id, Opportunity> oppMap, Map<Id, Account> accMap) {

        String caseFolderName = caseNumber;
        Opportunity opp = oppMap.get(oppId);
        String folderPath = buildOpportunityFolderPath( opp.Name, opp.AccountId, accMap );
        system.debug('folderPath: '+folderPath);
        return folderPath + '/' + caseFolderName;
    }
    
   //SFDC-4784 - Build Quote Request folder path.
    public static String buildQuoteRqFolderPath(String quoteRqName, String quoteName, String OppName, String acctName, String acctNum) {

        String quoteRqFolderName = buildOpportunityFolderName( quoteRqName );
        String quoteFolderName = buildOpportunityFolderName( quoteName );
        String oppFolderName = buildOpportunityFolderName( oppName );        
        String accFolderName = buildAccountFolderName( acctName, acctNum );
        return buildYearFolderPath() + '/' + accFolderName + '/' + oppFolderName + '/' + quoteFolderName + '/' + quoteRqFolderName;
    }    
    
   //SFDC-4784 - Build Quote Request Quote folder path.
    public static String buildQuoteRqQuoteFolderPath(String quoteName, String OppName, String acctName, String acctNum) {

        String quoteFolderName = buildOpportunityFolderName( QuoteName );
        String oppFolderName = buildOpportunityFolderName( OppName );        
        String accFolderName = buildAccountFolderName( acctName, acctNum );
        return buildYearFolderPath() + '/' + accFolderName + '/' + oppFolderName + '/' + quoteFolderName;
    }
    
   //SFDC-4784 - Build Quote Request Opportunity folder path.
    public static String buildQuoteRqOppFolderPath(String oppName, String acctName, String acctNum) {

        String oppFolderName = buildOpportunityFolderName( OppName );
        String accFolderName = buildAccountFolderName( acctName, acctNum );
        return buildYearFolderPath() + '/' + accFolderName + '/' + oppFolderName ;
    }
   
    //SFDC-4784 - Build Quote Request Account folder path.
    public static String buildQuoteRqAcctFolderPath(String acctName, String acctNum) {        
                
        String accFolderName = buildAccountFolderName( acctName, acctNum );
        return buildYearFolderPath() + '/' + accFolderName  ;
    }

   // SFDC-5096 - Malathi.K - Build Account Maintenance Case folder path.
    public static String buildAcctMaintCaseFolderPath(String caseNumber, String acctName, String acctNum) {

        String caseFolderName = 'Maintenance' + caseNumber;
        String accFolderName = buildAccountFolderName( acctName, acctNum );
        return buildYearFolderPath() + '/' + accFolderName + '/' + caseFolderName ;
    }
   
   // SFDC-5096 - Malathi.K - Build Account Maintenance Account folder path.
    public static String buildAcctMaintAcctFolderPath(String acctName, String acctNum) {        
                
        String accFolderName = buildAccountFolderName( acctName, acctNum );
        return buildYearFolderPath() + '/' + accFolderName  ;
    }
    
   // SFDC-5096 - Malathi.K - Account Maintenance
   //Builds SharePoint folderpath for Current Year
    public static String buildYearFolderPath() {

        Integer currentYear = System.Today().year();
        String yearPath = String.valueof(currentYear);               
		return yearPath;
    }

    //Vowels stripped after first two characters
    public static String removeVowels( String strng ) {

        String s = strng.replaceAll('[^A-z0-9 ]', '');
        if ( s.length() > 2 ) {
            String firstTwoChar = s.left( 2 );
            String stringEnd = s.removeStart( firstTwoChar );
            String stringEndMinusVowels = stringEnd.replaceAll('[aeiouAEIOU]', '');
            return firstTwoChar + stringEndMinusVowels;
        } else {
            return s;
        }
        return null;
    }
}