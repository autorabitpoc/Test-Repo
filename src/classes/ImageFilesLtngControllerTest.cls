@IsTest
private class ImageFilesLtngControllerTest{

    @IsTest
    static String testGetHostUrl(){
        Test.startTest();
        String testStr = ImageFilesLtngController.getHostUrl();
        Test.stopTest();
        System.assertNotEquals(null, testStr);
    }
}