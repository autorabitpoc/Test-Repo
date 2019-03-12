public class SGR_URE_AgeRateshelperData {
	public String newAccessToken;// temporarly hold the newAccessToken if current access token is expired. doing this is to avoid update until the end of the loop. 
    public DateTime lastTokenUpdateDateTime;
    public SGR_URE_GetRatingsResponse resObj;
   
    
    public SGR_URE_AgeRateshelperData(){
        this.newAccessToken=null;
        this.lastTokenUpdateDateTime=null;
        this.resObj = new SGR_URE_GetRatingsResponse();
        
	}
}