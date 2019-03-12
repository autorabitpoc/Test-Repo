@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    //SGR_GSPS_ProductGroupResponseWrapper  wra = new SGR_GSPS_ProductGroupResponseWrapper();
    // wra.statusCode = '200';
    // wra.statusMessage='zxfd';
    // wra.errorMessage='dfv';
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
     	
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[{"name":"Health/Dental/Life","productGroupCode":"QHP_NM_HDL","productGroupType":["Health","Vision","Dental","Life"],"division":"NM","effectiveDate":"2014-01-01","endDate":"9999-12-31","marketSegment":"SG","fundingType":"PREM","lineOfBusiness":"HDL"},{"name":"Health/Dental","productGroupCode":"QHP_NM_HD","productGroupType":["Health","Vision","Dental"],"division":"NM","effectiveDate":"2014-01-01","endDate":"9999-12-31","marketSegment":"SG","fundingType":"PREM","lineOfBusiness":"HD"},{"name":"Health","productGroupCode":"QHP_NM_H","productGroupType":["Health","Vision"],"division":"NM","effectiveDate":"2014-01-01","endDate":"9999-12-31","marketSegment":"SG","fundingType":"PREM","lineOfBusiness":"H"},{"name":"Dental","productGroupCode":"QHP_NM_D","productGroupType":["Dental"],"division":"NM","effectiveDate":"2014-01-01","endDate":"9999-12-31","marketSegment":"SG","fundingType":"PREM","lineOfBusiness":"D"},{"name":"Life","productGroupCode":"QHP_NM_L","productGroupType":["Life"],"division":"NM","effectiveDate":"2014-01-01","endDate":"9999-12-31","marketSegment":"SG","fundingType":"PREM","lineOfBusiness":"L"},{"name":"Dental/Life","productGroupCode":"QHP_NM_DL","productGroupType":["Dental","Life"],"division":"NM","effectiveDate":"2014-01-01","endDate":"9999-12-31","marketSegment":"SG","fundingType":"PREM","lineOfBusiness":"DL"}]');
        res.setStatusCode(200);
        return res;
    }
}