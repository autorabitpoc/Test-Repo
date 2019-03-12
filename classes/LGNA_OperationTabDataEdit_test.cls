@isTest
private class LGNA_OperationTabDataEdit_test {
    
    public class JSON2Apex {
        public String label;
        public String value;	               
    }
        
    static testMethod void Test_getselectOptions() {
        
        Account AnAccount = new Account();
        
        String aJSONString = '';
        
        //Delivered Salesforce Picklist Field, It should return values
        String AFieldOnAccount = 'AccountSource';        
        
        aJSONString = LGNA_OperationTabDataEdit.getselectOptions(AnAccount,AFieldOnAccount);
        
        System.debug('aJSONString Returned: ' + aJSONString);
        
        //Deserialize the JSON to ensure it returned appropriate values
        List<JSON2Apex> obj = new List<JSON2Apex>();
        
        obj = (List<JSON2Apex>) System.JSON.deserialize(aJSONString, List<JSON2Apex>.class);
        
        System.debug('JSON2Apex: ' + obj);
        
        //A List greater than zero indicates a good result
        System.assert(obj.size()>0,'No Picklist Values were returned!');  
        
        //Rakesh
        LGNA_OperationTabDataEdit.getFieldAccess();
    }    
}