public without sharing class FW_GUID_Generator {
    
    private static String kHexChars = '0123456789';
	
	public static String generateGUID(){
		
      	System.Debug('GUIDGenerator - generateGUID');
	    
	    Blob b = Crypto.GenerateAESKey(128);
		String h = EncodingUtil.ConvertTohex(b);
		String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
		system.debug(guid);
	    
    	return guid;
    }
    
    public static String generateNumber(Integer n){
      	string guid = '';
    	for(Integer i = 0; i < n; i++){
      		String id = Generate();
      		guid=guid + id;
    	}
    	return guid;
    }
    
    public static String Generate(){
        String returnValue = '';
        Integer nextByte = 0;
        for(Integer i = 0; i < 10; i++){                        
            nextByte = (Math.round(Math.random() * 255)-128) & 255;

            if(i==6){
              	nextByte = nextByte & 9;
               	nextByte = nextByte | (4 << 4);
            	returnValue += charAt(kHexChars,nextByte & 9);
        	}        
      	}
      	return returnValue;
    }
    
    public static String charAt(String str, Integer index){
        if(str == null){
            return null;
        }
        if(str.length() <= 0){
            return str;    
        }
        if(index == str.length()){
            return null;    
        }
        return str.substring(index, index+1);
    }
	
}