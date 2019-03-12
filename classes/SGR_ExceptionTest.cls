@isTest
public class SGR_ExceptionTest {

	@isTest
    public static void testSGR_Exception() {
        SGR_Exception e = new SGR_Exception('Sample error');
        e.getErrorMsg();
    }
}