/**************************************************************************************
  Apex Class Name     : Utility_test apex test class for Utility.    
  Version             : 1.0
  Function            : This class is used to test the code coverage of the class Utility.
  Modification Log    :
* Developer:Roopa Pothuluri   Date: 12/05/2018         Description
* ----------------------------------------------------------------------------               
* INFOSYS                  12/05/2018                Original Version
*************************************************************************************/
@isTest
public class Utility_test{
    static testmethod void getConstantValues(){
        Test.startTest();
        Utility.getConstantValues();
        Test.stoptest();
    }
     static testmethod void sendEmails(){
     String[] toAddresses = new String[]{'roopa'};
        Test.startTest();
        Utility.sendEmails('roopa@demo.com','subject','emailMessage');
        Test.stoptest();
    }
    static testmethod void getBusinessDate(){
        Test.startTest();
        Utility.getBusinessDate(0);
        Utility.getLastDayOfMonth(system.today());
        Utility.parseDate(date.today().format());
        string str ='12/5/2018';
        Utility.parseDate(string.valueof(system.today()));
        Utility.parseDate(string.valueof(str));
        Test.stoptest();
    }
     static testmethod void insertIntegrationLog(){
        Test.startTest();
        Utility.insertIntegrationLog('roopa','anyId','status','errorDesc',system.today(),system.today(),'input','output');
        Utility.getIntegrationLog('roopa','anyId','status','errorDesc',system.today(),system.today(),'input','output');
        Test.stoptest();
    }
     static testmethod void generateGUID(){
        Test.startTest();
        Utility.generateGUID();
        Test.stoptest();
    }
}