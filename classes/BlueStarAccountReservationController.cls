/**************************************************************************************
  Apex Class Name     : BlueStarAccountReservationController
  Version             : 1.0
  Function            : This is a controller class for handling the blus star Account Reservation functionality
  Modification Log    :

*************************************************************************************/
public with sharing class BlueStarAccountReservationController {

    public List<ProductGroupNumberWrapper> prodGrpWrapperList {get; set;}
    public  String username;
    public  String password;
    public  string endpoint;
    public Id accountid {get; set;}
    public String HCSC_Division {get; set;}
    Map<String, String> productPrefix ;
    public boolean showPopup {get; set;}
    public boolean noTable {get; set;}
    public boolean displayError {get; set;}
    public boolean hasEditAccess {get; set;}
    @TestVisible private CustomSettingDAO.ICustomSettingDAO customSettingDAOInstance;

    public BlueStarAccountReservationController(ApexPages.StandardController controller) {
        this(controller, new CustomSettingDAO());
    }

    @TestVisible private BlueStarAccountReservationController(ApexPages.StandardController controller, CustomSettingDAO.ICustomSettingDAO customSettingDAOInstance) {
        this.customSettingDAOInstance = customSettingDAOInstance;
        if (!Test.isRunningTest()) {
            controller.addFields(new List<String> {'Id', 'HCSC_Division__c', 'Time_Sent__c', 'External_Id__c', 'Integration_Status__c', 'Effective_Date__c'});
        }
        try {
            Account accountRecord = (Account) controller.getRecord();
            UserRecordAccess userAccess = [SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId = :UserInfo.getUserId() AND RecordId = :accountRecord.Id limit 1][0];
            if (userAccess.HasEditAccess) {
                hasEditAccess = true;
                HCSC_Division = accountRecord.HCSC_Division__c;
                String timeSentGap = System.Label.Integration_Time_out;
                accountid = accountRecord.Id;
                if ((accountRecord.Time_Sent__c == Null || (DateTime.now().getTime() - accountRecord.Time_Sent__c.getTime() > Integer.valueOf(timeSentGap) * 60 * 1000 && accountRecord.Integration_Status__c == 'Sent') || accountRecord.Integration_Status__c == 'Failure') && accountRecord.External_Id__c == NULL && accountRecord.Effective_Date__c != NULL) {
                    productPrefix = new Map<String, String>();
                    showPopup = false;
                    noTable = false;
                    displayError = false;
                    prodGrpWrapperList = new List<ProductGroupNumberWrapper>();
                    displayProdGrpWrapperList();
                } else {
                    displayError = true;
                    if (accountRecord.Time_Sent__c != NULL && (DateTime.now().getTime() - accountRecord.Time_Sent__c.getTime() < Integer.valueOf(timeSentGap) * 60 * 1000) && accountRecord.External_Id__c == NULL && accountRecord.Integration_Status__c == 'Sent') {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR, System.Label.BlueStar_Time_Error_Message));
                    } else if (accountRecord.External_Id__c != NULL) {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR, System.Label.BlueStarAccountReservationMsg8));
                    } else if (accountRecord.Effective_Date__c == NULL) {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR, System.Label.BlueStarAccountReservationMsg9));
                    }
                }
            } else {
                displayError = true;
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.InsufficientError));
            }
        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Unexpected error occured. Please contact system administrator '));
        }
    }

    public void displayProdGrpWrapperList() {
        try {
            Map<String, Blue_star_Account_Products__c> mapStatus = Blue_star_Account_Products__c.getAll();
            List<String> orderedList = new List<String>();
            orderedList.addAll(mapStatus.keyset());
            orderedList.sort();
            for (String order : orderedList) {
                prodGrpWrapperList.add(new ProductGroupNumberWrapper('00', mapStatus.get(order).Product_Name__c, mapStatus.get(order).Prefix__c, mapStatus.get(order).Display_Prefix__c));
                productPrefix.put(mapStatus.get(order).Product_Name__c , mapStatus.get(order).Prefix__c);
            }
        } catch (Exception e) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.Info, e.getMessage());
            ApexPages.addMessage(errMsg);
        }
    }

    public void setShowPopup() {
        Integer countOfNumbers = 0;
        Boolean flag = false;
        String countLimit = System.Label.BlueStar_Total_Count_Limit;
        for (ProductGroupNumberWrapper pnw : prodGrpWrapperList) {
            if (pnw.selected != '00' ) {
                flag = true;
                noTable = true;
                countOfNumbers += Integer.valueOf(pnw.selected);
            }
        }
        if (countOfNumbers > Integer.valueOf(countLimit)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR, System.Label.BlueStar_Count_Limit_Error_Message + ' ' + System.Label.BlueStar_Total_Count_Limit));
            showPopup = false;
        } else {
            showPopup = true;
        }
    }

    public void closePopUp() {
        showPopup = false;
        noTable = false;
    }
    public void reserveAcctCallout() {
        String body = '';
        List<String> fieldAPInames = new List<String>();
        String query;
        EncryptionUtility encryptionUtility = new EncryptionUtility();
        Map<String, String> prefixGroupNo = new Map<String, String>();
        try {
            Username_Password__c blueSTAR = customSettingDAOInstance.getUsernamePasswordCSByName(ConstantsController.blueSTARName);
            username = blueSTAR.Username__c;
            password = encryptionUtility.getDecryptedMessage(blueSTAR.Password__c);
            endpoint = blueSTAR.EndPoinUrl__c;

            for (ProductGroupNumberWrapper prdpref : prodGrpWrapperList ) {
                if (productPrefix.get(prdpref.entry) != NULL ) {
                    if (prefixGroupNo.get(productPrefix.get(prdpref.entry)) == NULL) {
                        prefixGroupNo.put(productPrefix.get(prdpref.entry), prdpref.selected);
                    } else {
                        Integer sum = Integer.valueof(prefixGroupNo.get(productPrefix.get(prdpref.entry)) ) + Integer.valueof(prdpref.selected) ;
                        prefixGroupNo.put(productPrefix.get(prdpref.entry), String.valueOf(sum) );
                    }
                }
            }
            Map<String, BLue_star_callout_fields__c> BLue_star_callout_fields = BLue_star_callout_fields__c.getAll();
            for (String cs : BLue_star_callout_fields.keyset()) {
                fieldAPInames.add(BLue_star_callout_fields.get(cs).Account_API_Name__c);
            }

            query = 'SELECT ';
            for (String api : fieldAPInames) {
                query = query + api + ',' ;
            }
            query = query.removeEnd(',');
            query = query + ' FROM Account WHERE id = \'' + accountid + '\'';
            List<Account> accounts = (List<Account>)Database.query(query);
            accounts[0].Integration_Status__c = 'Sent';
            accounts[0].Time_Sent__c = System.now();
            accounts[0].Integration_Action__c = 'Create';
            List<Database.SaveResult> Results = Database.update(accounts);
            CreateExceptionLog.insertErrorLog(NULL, Results, NULL, accounts, 'Apex Class', 'Account', '', 'BlueStarAccountReservationController', 'High');

            body = NULL;
            body = '<sObject xsi:type="sf:Account" xmlns:sf="urn:sobject.enterprise.soap.sforce.com">' ;
            for (String api : fieldAPInames) {
                if (accounts[0].get(api) != NULL  && ( accounts[0].get(api) instanceof String)) {
                    body = body + '<sf:' + api + '>' + ((String)accounts[0].get(api)).escapeXml() + '</sf:' + api + '>';
                } else  if (accounts[0].get(api) == NULL  ) {
                    body = body + '<sf:' + api + '>' + '' + '</sf:' + api + '>';
                } else {
                    body = body + '<sf:' + api + '>' + accounts[0].get(api) + '</sf:' + api + '>';
                }
            }

            for (String pref : prefixGroupNo.keyset()) {
                body = body + '<sf:' + pref + '>' + prefixGroupNo.get(pref) + '</sf:' + pref + '>';
            }

            body = body + '</sObject>';
            if (!Test.isRunningTest() && ConstantsController.shouldCBSRCalloutProcess) {
                CalloutHelperclass.SendCallout(body , username , password , endpoint);
                ConstantsController.shouldCBSRCalloutProcess = false;
            }
        } catch (Exception ex) {
            CreateExceptionLog.insertErrorLog(ex, NULL, NULL, NULL, 'Apex Class', 'Account', NULL, 'BlueStarAccountReservationController.reserveAcctCallout()', 'High');
        }
    }

    public class ProductGroupNumberWrapper {
        public String  selected          {get; set;}
        public String  entry             {get; set;}
        public String  prefix            {get; set;}
        public String  displayPrefix     {get; set;}
        public ProductGroupNumberWrapper(String selected, String entry, String prefix, String displayPrefix) {
            this.selected      = selected;
            this.entry         = entry;
            this.prefix        = prefix;
            this.displayPrefix = displayPrefix;
        }
        public List<SelectOption> getGroupNos() {
            List<SelectOption> options = new List<SelectOption>();
            Integer x = Integer.valueof(Label.Bluestar_Group_Number_Limit);
            for (Integer i = 0; i < x; i++) {
                if (i < 10) {
                    options.add(new SelectOption('0' + i, '0' + i));
                } else {
                    options.add(new SelectOption('' + i, '' + i));
                }
            }
            return options;
        }
    }
}