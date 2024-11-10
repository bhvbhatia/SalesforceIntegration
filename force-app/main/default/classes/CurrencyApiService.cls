public with sharing class CurrencyApiService {
  public static void getExchange() {
    Http http = new Http();
    // Step1 - Prepare tthe request
    HttpRequest req = new HttpRequest();
    //step1.1 - set end point
    req.setEndpoint('https://open.er-api.com/v6/latest/USD');
    req.setMethod('GET'); // GET, POST , PUT , PATCH , DELETE
    // Step1.2 - Set the headers
    req.setHeader('Content-Type', 'application/json');
    req.setHeader('Accept', 'application/json');
    try {
      HttpResponse res = http.send(req);
      System.debug('res=> ' + res.getStatus() + '=> ' + res.getBody());
    } catch (System.CalloutException ex) {
      System.debug('System.CalloutException .... ' + ex.getStackTraceString());
    }
  }
}
