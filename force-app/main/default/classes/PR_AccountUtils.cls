public with sharing class PR_AccountUtils {
  public static void createAccount(String name, String rating) {
    Salesforce_Config__mdt config = Salesforce_Config__mdt.getInstance(
      System.Label.PS_SalesforceTokenLabel
    );
    if (config != null) {
      Boolean isValid = PS_SalesforceTokenUtils.isValid(config);
      Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
      String accessToken = config.access_token__c;

      if (!isValid) {
        fieldWithValuesMap = PS_SalesforceTokenUtils.refreshToken(config);
        accessToken = (String) fieldWithValuesMap.get('access_token__c');
      }
      String endpoint =
        config.instance_url__c + '/services/data/v60.0/sobjects/Account';
      String requestBody =
        '{' +
        '    "Name": "' +
        name +
        '",' +
        '    "Rating": "' +
        rating +
        '",' +
        '    "Phone": "9876543210",' +
        '    "Industry": "Education",' +
        '    "Active__c": "Yes"' +
        '}';

      HttpRequest httpReq = PS_CalloutUtils.prepareRequest(
        endpoint,
        'POST',
        requestBody,
        'application/json',
        'application/json'
      );
      httpReq.setHeader('Authorization', 'Bearer ' + config.access_token__c);
      try {
        HttpResponse httpRes = (new Http()).send(httpReq);
        if (httpRes.getStatusCode() == 200 || httpRes.getStatusCode() == 201) {
          System.debug('Success \n ' + httpRes.getBody());
        } else {
          System.debug('ERROR \n ' + httpRes.getBody());
        }
      } catch (System.CalloutException ex) {
        //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage() ));
      }

      if (fieldWithValuesMap.size() > 0) {
        String fullName =
          'salesforce_Config.' + System.Label.PS_SalesforceTokenLabel;
        String label = System.Label.PS_SalesforceTokenLabel;
        CreateUpdateMetadataUtils.createUpdateMetadata(
          fullName,
          label,
          fieldWithValuesMap
        );
      }
    }
  }
}
