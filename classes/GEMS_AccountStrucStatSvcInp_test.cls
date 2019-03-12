@isTest
public class GEMS_AccountStrucStatSvcInp_test {

 private static testmethod void GEMS_AccountStructureStatusServiceInput() {
 
        /* ErrorData errDat = new ErrorData();
        errDat.acctErrorMessage = 'Test Message';
        errDat.acctAddrErrorMessage = 'Test Message';
        errDat.benAgmtErrorMessage = 'Test Message';
        errDat.catErrorMessage = 'Test Message';
        errDat.grpSectErrorMessage = 'Test Message';
        errDat.billProfErrorMessage = 'Test Message';
        insert errDat;*/
        
        

        Test.startTest();
        GEMS_AccountStructureStatusServiceInput accSvcInp = new GEMS_AccountStructureStatusServiceInput();
        GEMS_AccountStructureStatusServiceInput.ErrorData accStruct = new GEMS_AccountStructureStatusServiceInput.ErrorData();
        accSvcInp.status = 'Test Completed';
        
        accStruct.acctErrorMessage = 'Test Message';
        accStruct.acctAddrErrorMessage = 'Test Message';
        accStruct.benAgmtErrorMessage = 'Test Message';
        accStruct.catErrorMessage = 'Test Message';
        accStruct.grpSectErrorMessage = 'Test Message';
        accStruct.billProfErrorMessage = 'Test Message';
        Test.stopTest();              
   
   }

  
  
  }