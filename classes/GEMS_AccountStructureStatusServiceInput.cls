global without sharing class GEMS_AccountStructureStatusServiceInput {
    
    webService string status;
    webService string acctNbr;
    webService string accountStructureCaseID;
    webService string requestUID;
    webService string corpEntCd;
    webService string message;
    webService ErrorData errorData;
    
    global class ErrorData{
        webService string acctErrorMessage;
        webService string acctAddrErrorMessage;
        webService string benAgmtErrorMessage;
        webService string catErrorMessage;
        webService string grpSectErrorMessage;
        webService string billProfErrorMessage;
        webService string einInfoErrorMessage;
    }
    
}