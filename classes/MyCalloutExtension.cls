public with sharing class MyCalloutExtension
{
    final ApexPages.StandardController controller;
    public MyCalloutExtension(ApexPages.StandardController controller)
    {
        this.controller = controller;
    }
    public PageReference makeCallout()
    {

      Http httpProtocol = new Http();
        // Create HTTP request to send.
        HttpRequest request = new HttpRequest();
        // Set the endpoint URL.
        String endpoint = 'https://docsample.herokuapp.com/jsonSample';
        request.setEndPoint(endpoint);
        // Set the HTTP verb to GET.
        request.setMethod('GET');
        // Send the HTTP request and get the response.
        // The response is in JSON format.
        HttpResponse response = httpProtocol.send(request);
        System.debug(response.getBody());
        /* The JSON response returned is the following:
        String s = '{"invoiceList":[' +
        '{"totalPrice":5.5,"statementDate":"2011-10-04T16:58:54.858Z","lineItems":[' +
            '{"UnitPrice":1.0,"Quantity":5.0,"ProductName":"Pencil"},' +
            '{"UnitPrice":0.5,"Quantity":1.0,"ProductName":"Eraser"}],' +
                '"invoiceNumber":1},' +
        '{"totalPrice":11.5,"statementDate":"2011-10-04T16:58:54.858Z","lineItems":[' +
            '{"UnitPrice":6.0,"Quantity":1.0,"ProductName":"Notebook"},' +
            '{"UnitPrice":2.5,"Quantity":1.0,"ProductName":"Ruler"},' +
            '{"UnitPrice":1.5,"Quantity":2.0,"ProductName":"Pen"}],"invoiceNumber":2}' +
        ']}'; 
        */

        // Parse JSON response to get all the totalPrice field values.
        JSONParser parser = JSON.createParser(response.getBody());
        String grandTotal = '';
		List<Opportunity> opp=new List<Opportunity>();
		List<Opportunity> soqlopp=[select id,name,Account_Market_Segment__c from opportunity where id=:ApexPages.currentPage().getParameters().get('id') ];
		
		
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'ProductName')) {
                // Get the value.
                parser.nextToken();
                // Compute the grand total price for all invoices.
                grandTotal = parser.getText();
                    System.debug('grandtotal'+grandTotal);
				soqlopp[0].Account_Market_Segment__c=grandTotal;
				update soqlopp;
				
            }
        }
        system.debug('Grand total=' + grandTotal);
         return controller.view();
    }
}