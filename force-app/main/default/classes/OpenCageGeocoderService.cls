public with sharing class OpenCageGeocoderService {
    public static void reverseGeoCoding(String accountId){ // argument
        /* Step0 - Get The Latitude and Longitude for given account */
        Account accRecord = [SELECT Id, 
        Location__Latitude__s, Location__Longitude__s 
                            FROM 
                                Account 
                            WHERE 
                                Id =: accountId 
                                AND Location__Latitude__s != null
                                AND Location__Longitude__s != null
                            LIMIT 1
                        ];
        /* Step0.1 - Prepare the Query Params */
        String queryParams = 
        accRecord.Location__Latitude__s+','+accRecord.Location__Longitude__s; 
        // As Per API Document
        System.debug(queryParams);

        // URLEncode of that complete Query parameter
        // EncodingUtil.urlEncode();

        /* Callouts Only */
        /* Step1 - Prepare the Request */
        HttpRequest httpReq = new HttpRequest();
        /* Step1.1 - Set the Endpoint */
        httpReq.setEndPoint(System.Label.OPENCAGE_API_URL+'?key='
            +System.Label.OPENCAGE_API_KEY+'&q='+queryParams+'&pretty=1');
    req.setHeader('Content-Type', 'application/json');
    req.setMethod('GET');

    Http http = new Http();
    try {
      HttpResponse res = http.send(req);
      System.debug('res=> ' + res.getStatus() + '=> ' + res.getBody());
    } catch (System.CalloutException ex) {
      System.debug('System.CalloutException .... ' + ex.getStackTraceString());
    }
  }
}




https://login.salesforce.com/services/oauth2/authorize?client_id=3MVG9GCMQoQ6rpzR93jXBKKy.9spK4VzZQbo6kBxj0fL4ruYrnrRKxy5nbeXfbezGLQRZIOoOKV3eS1cV37lM&redirect_uri=https://chromewebstore.google.com/detail/mortality-death-clock-new/eeedcpdcehnikgkhbobmkjcipjhlbmpn&response_type=code&state=abc12434534