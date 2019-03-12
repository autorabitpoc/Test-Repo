public class SGR_Exception extends Exception {
	String errorMsg;
	public void SGR_Exception(String errorMsg) {
		this.errorMsg = errorMsg;
	}
    public String getErrorMsg(){return this.errorMsg;}
}