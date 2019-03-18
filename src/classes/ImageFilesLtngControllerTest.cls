@IsTest
private class ImageFilesLtngControllerTest{

    @IsTest
    static void testGetHostUrl(){
        Test.startTest();
        String testStr = ImageFilesLtngController.getHostUrl();
        Test.stopTest();
        System.assertNotEquals(null, testStr);
    }
}