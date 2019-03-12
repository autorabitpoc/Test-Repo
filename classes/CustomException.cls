public class CustomException extends Exception {

    public CustomException( Exception e, string exceptionmessage, string sourceClass){

        system.debug('Exception from '+sourceClass+' :******' + e);
    }

    public CustomException( string exceptionmessage, string sourceClass){

    }
}