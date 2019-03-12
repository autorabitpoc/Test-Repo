@isTest(SeeAllData=false) 
public class LGNA_EIN_ConfirmTest {

    private static testmethod void TestEINConfirmController(){
        test.startTest();
        Account accRec = new Account();
        id rec =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group Account').getRecordTypeId(); 
        accRec.RecordTypeId = rec;
        accRec.Name = 'TestAccountForEIN';
        accRec.Group_Number__c= 'B06093';
        accRec.external_id__c= 'B06093';
        accRec.BillingStreet ='Testing';
        accRec.BillingCity='Houston';
        accRec.BillingState='TX';
        accRec.BillingPostalCode='77077';
        accRec.status__c = 'Active';
        accRec.Market_Segment__c = 'Tmp';
        accRec.AccountNumber = '01245678';                
        accRec.Effective_Date__c = system.today();
        accRec.HCSC_Division__c = 'TX';
        accRec.COBRA_Administration_Type__c = 'HCSC';
        insert accRec;
        //Following can be removed if we are facing soql 101 error. This helps with coverage of very few lines.
        LGNA_EIN_ConfirmControllerApx.returnEIN(accRec.Id);
        //LGNA_EIN_TransmitServiceHelper.sendEIN(accRec.Id);

        
        /*GEMS_Address__c addrRec1 = new GEMS_Address__c();
        addrRec1.Account__c = accRec.Id;
        addrRec1.Street2__c = 'Street1';
        addrRec1.City__c = 'City1';
        addrRec1.State__c = 'TX';
        addrRec1.Zip_Code__c = '77077';
        addrRec1.Contact_Name__c = 'Test1 Name';
        addrRec1.Contact_Email__c = 'test1@gmail.com';
        addrRec1.Contact_Phone__c = '1231231234';
        addrRec1.Usage__c = 'Billing';
        insert addrRec1;
        
        GEMS_Address__c addrRec2 = new GEMS_Address__c();
        addrRec2.Account__c = accRec.Id;
        addrRec2.Street2__c = 'Street2';
        addrRec2.City__c = 'City2';
        addrRec2.State__c = 'TX';
        addrRec2.Zip_Code__c = '77077';
        addrRec2.Contact_Name__c = 'Test2 Name';
        addrRec2.Contact_Email__c = 'test2@gmail.com';
        addrRec2.Contact_Phone__c = '1231231235';
        addrRec2.Usage__c = 'Primary';
        insert addrRec2;*/
        
        EIN__c einRec1 = new EIN__C();
        einRec1.Name = '565656565';
        einRec1.Account__c = accRec.id;
        einRec1.Effective_Date__c = system.today();
        einRec1.Location_Name__c = 'Test1';
        //Bharath0626
        einRec1.Street11__c = 'Street1';
        einRec1.Street21__c = 'Street1';
        einRec1.City1__c = 'City1';
        einRec1.State1__c = 'TX';
        einRec1.Zip_Code1__c = '77077';
        einRec1.County_Code1__c = 123;
        einRec1.Country1__c = 'US';        
        insert einRec1; 
        

        
		EIN__c einRec2 = new EIN__C();
        einRec2.Name = '232323232';
        einRec2.Account__c = accRec.id;
        einRec2.Effective_Date__c = system.today();
        einRec2.Location_Name__c = 'Test2';
        einRec2.Primary__c = true;
        einRec2.Street11__c = 'Street1';
        einRec2.Street21__c = 'Street1';
        einRec2.City1__c = 'City1';
        einRec2.State1__c = 'TX';
        einRec2.Zip_Code1__c = '77077';
        einRec2.County_Code1__c = 123;
       einRec2.Country1__c = 'US';        
        insert einRec2;               
        
        LGNA_EIN_ConfirmControllerApx.returnEIN(accRec.Id);
        LGNA_EIN_ConfirmControllerApx.sentEIN(accRec.Id);
        LGNA_EIN_ConfirmControllerApx.sendProgress(accRec.Id);
        LGNA_EIN_ConfirmControllerApx.transmitEIN(accRec.Id);
        LGNA_EIN_ConfirmControllerApx.returnEIN(null);
        LGNA_EIN_ConfirmControllerApx.sentEIN(null);
        LGNA_EIN_ConfirmControllerApx.sendProgress(null);   

		EIN__c einRec3 = new EIN__C();
        einRec3.Name = '676767676';
        einRec3.Account__c = accRec.id;
        einRec3.Effective_Date__c = system.today();
        einRec3.Location_Name__c = 'Test2';
        einRec3.Street11__c = 'Street1';
        einRec3.Street21__c = 'Street1';
        einRec3.City1__c = 'City1';
        einRec3.State1__c = 'TX';
        einRec3.Zip_Code1__c = '77077';
        einRec3.County_Code1__c = 123;
        einRec3.Country1__c = 'US';        
        insert einRec3;               

        einRec3.Bluestar_Transfer_Status__c = '';
        einRec3.change_reason__c = '';
        upsert einRec3;
        einRec3.Effective_Date__c = system.today() + 1;
        einRec3.Change_Reason__c = 'CHG';        
        upsert einRec3;
        LGNA_EIN_ConfirmControllerApx.transmitEIN(accRec.Id);

        EIN__c einRec4 = new EIN__C();
        einRec4.Name = '676767678';
        einRec4.Account__c = accRec.id;
        einRec4.Effective_Date__c = system.today();
        einRec4.Location_Name__c = 'Test2';
        einRec4.Street11__c = 'Street1';
        einRec4.Street21__c = 'Street1';
        einRec4.City1__c = 'City1';
        einRec4.State1__c = 'TX';
        einRec4.Zip_Code1__c = '77077';
        einRec4.County_Code1__c = 123;
        einRec4.Country1__c = 'US';  
        einRec4.EIN_Sequence_Number__c = 123;
        insert einRec4;        
        LGNA_EIN_TransmitServiceHelper.sendNewAcctEIN(accRec.Id);
        
        List<string> einList = new List<string>();
        einList.add('565656565');
        einList.add('676767676');
        einRec2.Bluestar_Transfer_Status__c = 'Wait BS Confirm';
        upsert einRec2;
        LGNA_EIN_TransmitServiceHelper.processResponse(accRec.Id,einList);
        
        einRec4.Bluestar_Transfer_Status__c = 'Wait BS Confirm';
        einRec3.Bluestar_Transfer_Status__c = 'Wait BS Confirm';
        LGNA_EIN_TransmitServiceHelper.resetEINs(accRec.Id);
        
        GEMS_AccountStructureCreateServiceInput testInput = new GEMS_AccountStructureCreateServiceInput();
        GEMS_AccountStructureCreateServiceInput.AccountEin einInput = new GEMS_AccountStructureCreateServiceInput.AccountEin();
        List<GEMS_AccountStructureCreateServiceInput.AccountEin> einInputList = new List<GEMS_AccountStructureCreateServiceInput.AccountEin>();
        einInput.einNbr = '565656565';
        einInput.einEffDt = system.today();
        einInput.einSeqNbr = 1234;
        einInputList.add(einInput);
        einInput.einNbr = '676767678';
        einInput.einEffDt = system.today();
        einInput.einSeqNbr = 1234;
        einInputList.add(einInput);
        einInput.einNbr = '676767678';
        einInput.einEffDt = system.today() + 1;
        einInput.einSeqNbr = 1235;
        einInputList.add(einInput);        
        testInput.acctEin = einInputList;
        testInput.status = 'S';
        GEMS_AccountStructureCreateServiceOutput testOutput = LGNA_EIN_TransmitServiceHelper.updateEIN(testInput, accRec.Id);
        testInput.status = 'E';
        testOutput = LGNA_EIN_TransmitServiceHelper.updateEIN(testInput, accRec.Id);
        testInput.acctEin.clear();
        testInput.status = 'S';
        testOutput = LGNA_EIN_TransmitServiceHelper.updateEIN(testInput, accRec.Id);        

        EIN__c einRec5 = new EIN__C();
        einRec5.Name = '676767679';
        einRec5.Account__c = accRec.id;
        einRec5.Effective_Date__c = system.today();
        einRec5.Location_Name__c = 'Test2';
        einRec5.Street11__c = 'Street1';
        einRec5.City1__c = 'City1';
        einRec5.State1__c = 'TX';
        einRec5.Zip_Code1__c = '77077';
        einRec5.Country1__c = 'US';  
        einRec5.EIN_Sequence_Number__c = 123;
        insert einRec5;     
        //accRec.Market_Segment__c = null;
        //upsert accRec;
        LGNA_EIN_TransmitServiceHelper.sendNewAcctEIN(accRec.Id);
        
        //einRec2.Bluestar_Transfer_Status__c = '';
        //einRec2.change_reason__c = '';
        //upsert einRec2;        
        
        //einRec2.Bluestar_Transfer_Status__c = 'Due for Transfer';
        //einRec2.Effective_Date__c = system.today() + 1;
        //einRec2.Change_Reason__c = 'CHG';
        //einRec2.Location_Name__c = 'Test21';
        //upsert einRec2;
        //LGNA_EIN_ConfirmControllerApx.transmitEIN(accRec.Id);

        test.stopTest();
    }    
    
}