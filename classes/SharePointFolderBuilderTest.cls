@isTest
private class SharePointFolderBuilderTest{
    @isTest static void buildAccountFolderNameTest(){
        ConstantsController.prospectAccNum = '000000';
        String prospectAccNum = ConstantsController.prospectAccNum;
        Integer prospectNumLength = prospectAccNum.length();

        String acctName1 = 'AccntNm50ChrctrsLngBCDFGHJKLMNPQRSTVWXYZ_123456789';
        String acctName2 = 'AccntNm19ChrctrsLng';
        String acctName3 = 'AccntNm50ChrctrsLngBCDFGHJKLMNPQRSTVWXYZ_123456789';
        String acctName4 = 'NrmlNm';

        Integer maxLength = 50;

        String acctNum1 = null;
        String acctNum2 = null;
        String acctNum3 = '000000';
        String acctNum4 = '123456';
        
        //acctNum = null, name_prospectAcctNum.length > 50
        String test1 = SharePointFolderBuilder.buildAccountFolderName(acctName1, acctNum1);
        System.assertEquals(null, acctNum1);
        System.assertEquals(maxLength, acctName1.length());
        System.assertEquals(maxLength, test1.length());
        System.assertEquals('_'+prospectAccNum, test1.substring(test1.length()-7, test1.length()));
        System.assertEquals('AccntNm50ChrctrsLngBCDFGHJKLMNPQRSTVWXYZ_12', test1.substring(0, test1.length()-7));

        //acctNum = null, name_prospectAcctNum.length < 50
        String test2 = SharePointFolderBuilder.buildAccountFolderName(acctName2, acctNum2);
        System.assertEquals(null, acctNum2);
        System.assertEquals(19, acctName2.length());
        System.assertEquals(26, test2.length());
        System.assertEquals('_'+prospectAccNum, test2.substring(test2.length()-7, test2.length()));
        System.assertEquals(acctName2, test2.substring(0, test2.length()-7));

        //formattedName_acctNum.length > 50
        String test3 = SharePointFolderBuilder.buildAccountFolderName(acctName3, acctNum3);
        System.assertNotEquals(null, acctNum3);
        System.assertEquals(maxLength, acctName3.length());
        System.assertEquals(maxLength, test3.length());
        System.assertEquals('_'+acctNum3, test3.substring(test3.length()-7, test3.length()));
        System.assertEquals('AccntNm50ChrctrsLngBCDFGHJKLMNPQRSTVWXYZ_12', test3.substring(0, test3.length()-7));

        //else
        String test4 = SharePointFolderBuilder.buildAccountFolderName(acctName4, acctNum4);
        System.assertNotEquals(null, acctNum4);
        System.assertEquals(6, acctName4.length());
        System.assertEquals(acctName4.length()+1+acctNum4.length(), test4.length());
        System.assertEquals('_'+acctNum4, test4.substring(test4.length()-7, test4.length()));
        System.assertEquals('NrmlNm', test4.substring(0, test4.length()-7));
    }

    @isTest static void buildOpportunityFolderNameTest(){
        String length50 = '';
        for(Integer i = 0; i<51; i++){
            length50+='Z';
        }
        String oppName1 = length50;
        String oppName2 = 'OppNmTst';
        Integer maxLength = 50;

        String test1 = SharePointFolderBuilder.buildOpportunityFolderName(oppName1);
        System.assertEquals(maxLength, test1.length());
        String test2 = SharePointFolderBuilder.buildOpportunityFolderName(oppName2);
        System.assertEquals(oppName2, test2);
    }

    @isTest static void buildCaseFolderNameTest(){
        System.assertEquals(null, SharePointFolderBuilder.buildCaseFolderName());
    }

    @isTest static void removeVowelsTest(){
        String testStr1 = 'AQuickBrownDoge';
        String testStr2 = 'Fast-Moving,Smart,AndBrownDoge';
        String testStr3 = 'AE';
        //if length > 2 remove vowels after 2nd
        //optional, add nonalphanum string
        //else return

        //len>2, standard
        String test1 = SharePointFolderBuilder.removeVowels(testStr1);
        System.assertEquals('AQckBrwnDg', test1);

        String test2 = SharePointFolderBuilder.removeVowels(testStr2);
        System.assertEquals('FastMvngSmrtndBrwnDg', test2);

        String test3 = SharePointFolderBuilder.removeVowels(testStr3);
        System.assertEquals('AE', test3);
    }

    @isTest static void buildOpportunityFolderPathTest(){
        String acctNum = '000000';
        Account testAcc = new Account(Name='TestAcct', External_Id__c=acctNum, HCSC_Division__c='IL');
        insert testAcc;
        Map<Id, Account> accMap = new Map<Id, Account>();
        accMap.put(testAcc.Id, testAcc);

        String test1 = SharePointFolderBuilder.buildOpportunityFolderPath('TestOpp', testAcc.Id, accMap);
        System.assertEquals('Testcct_000000/Testpp', test1);
    }

    @isTest static void buildCaseFolderPathTest(){
        String acctNum = '000000';
        String caseNum = '123456789';
        Account testAcc = new Account(Name='TestAcct', External_Id__c=acctNum, HCSC_Division__c='IL');
        insert testAcc;
        Opportunity testOpp = new Opportunity(Name='TestOpp', AccountId=testAcc.Id, RFI_RFP_Received_Date__c=System.Today());
        testOpp.StageName = 'RFI Received';
        testOpp.Probability = 10;
        testOpp.CloseDate = System.Today();
        insert testOpp;
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>(); 
        oppMap.put(testOpp.Id, testOpp);
        Map<Id, Account> accMap = new Map<Id, Account>();
        accMap.put(testAcc.Id, testAcc);

        String test1 = SharePointFolderBuilder.buildCaseFolderPath(caseNum, testOpp.Id, oppMap, accMap);
        System.assertEquals('Testcct_000000/Testpp/123456789', test1);
    }
    
    @isTest static void buildAcctMaintCaseFolderPathTest(){
        Integer currentYear = System.Today().year();
        String acctNum = '000000';
        String caseNum = '456789123';
        Account testAcc = new Account(Name='TestAcctMaint', External_Id__c=acctNum, HCSC_Division__c='IL');
        insert testAcc;                

        String test1 = SharePointFolderBuilder.buildAcctMaintCaseFolderPath(caseNum, testAcc.Name, acctNum);        
        System.assertEquals(currentYear + '/TestcctMnt_000000/Maintenance456789123', test1);
    }       

     @isTest static void buildAcctMaintAcctFolderPathTest(){
        Integer currentYear = System.Today().year();
        String acctNum = '123456';        
        Account testAcc = new Account(Name='TestAcctMaint', External_Id__c=acctNum, HCSC_Division__c='IL');
        insert testAcc;                

        String test1 = SharePointFolderBuilder.buildAcctMaintAcctFolderPath(testAcc.Name, acctNum);        
        System.assertEquals(currentYear + '/TestcctMnt_123456', test1);
    }
    
    @isTest static void buildYearFolderPathTest(){
        
        String test1 = SharePointFolderBuilder.buildYearFolderPath();        
        System.debug('currentyear - ' +test1);
    }
    
    @isTest static void buildQuoteRqFolderPath(){
        String test1 = SharePointFolderBuilder.buildQuoteRqFolderPath('MyQR', 'MyQ', 'MyOpp','MyAcct', '12345');
        System.debug('test1: ' + test1);
        Integer currentYear = System.Today().year();
        String assert1 = String.valueOf(currentYear);
        assert1 = assert1 + '/Mycct_12345/Mypp/MyQ/MyQR';
        System.debug('assert1: ' + assert1);
        System.assertEquals(assert1, test1);        
    }    
    
    @isTest static void buildQuoteRqQuoteFolderPath(){
        String test1 = SharePointFolderBuilder.buildQuoteRqQuoteFolderPath('MyQ', 'MyOpp','MyAcct', '12345');
        System.debug('test1: ' + test1);
        Integer currentYear = System.Today().year();
        String assert1 = String.valueOf(currentYear);
        assert1 = assert1 + '/Mycct_12345/Mypp/MyQ';
        System.debug('assert1: ' + assert1);
        System.assertEquals(assert1, test1);        
    }
    
    
    @isTest static void buildQuoteRqOppFolderPath(){
        String test1 = SharePointFolderBuilder.buildQuoteRqOppFolderPath('MyOpp','MyAcct', '12345');
        System.debug('test1: ' + test1);
        Integer currentYear = System.Today().year();
        String assert1 = String.valueOf(currentYear);
        assert1 = assert1 + '/Mycct_12345/Mypp';
        System.debug('assert1: ' + assert1);
        System.assertEquals(assert1, test1);        
    }
        
    @isTest static void buildQuoteRqAcctFolderPath(){
        String test1 = SharePointFolderBuilder.buildQuoteRqAcctFolderPath('MyAcct', '12345');
        System.debug('test1: ' + test1);
        Integer currentYear = System.Today().year();
        String assert1 = String.valueOf(currentYear);
        assert1 = assert1 + '/Mycct_12345';
        System.debug('assert1: ' + assert1);
        System.assertEquals(assert1, test1);        
    }   
    
}