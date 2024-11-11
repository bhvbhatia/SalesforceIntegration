public with sharing class PS_SalesforceTokenUtils {
  public PageReference getAuthCode() {
    /*
            TODO: Get the Custom Metadata Record
        */

    Salesforce_Config__mdt config = Salesforce_Config__mdt.getInstance(
      System.Label.PS_SalesforceTokenLabel
    ); // Use Custom Label
    if (config != null) {
      String orgUrl = config.Environment__c == 'Production'
        ? 'https://login.salesforce.com'
        : 'https://test.salesforce.com';

      System.System.debug(orgUrl);

      String redirect_uri =
        System.URL.getOrgDomainURL().toExternalForm() +
        '/apex/' +
        config.PageName__c;
      System.System.debug(redirect_uri);

      String authorizeUrl =
        orgUrl +
        config.auth_url__c +
        '?client_id=' +
        config.client_id__c +
        '&redirect_uri=' +
        redirect_uri +
        '&response_type=code';
      System.System.debug(authorizeUrl);

      return new PageReference(authorizeUrl);
    } else {
      return null;
    }
  }

  public void getAccessToken() {
    String code = ApexPages.currentPage().getParameters().get('code');

    Salesforce_Config__mdt config = Salesforce_Config__mdt.getInstance(
      System.Label.PS_SalesforceTokenLabel
    ); // Use Custom Label
    if (config != null) {
      String orgUrl = config.Environment__c == 'Production'
        ? 'https://login.salesforce.com'
        : 'https://test.salesforce.com';
      String tokenUrl = orgUrl + config.token_url__c;
      String redirect_uri =
        System.URL.getOrgDomainURL().toExternalForm() +
        '/apex/' +
        config.PageName__c;
      String requestBody =
        'code=' +
        code +
        '&grant_type=authorization_code&client_id=' +
        config.client_id__c +
        '&client_secret=' +
        config.client_secret__c +
        '&redirect_uri=' +
        redirect_uri;
      HttpRequest httpReq = new HttpRequest();
      httpReq.setEndpoint(tokenUrl);
      httpReq.setMethod('POST');
      httpReq.setBody(requestBody);
      httpReq.setHeader('Content-Type', 'application/x-www-form-urlencoded');
      httpReq.setHeader('Accept', 'application/json');

      Http http = new Http();
      try {
        HttpResponse res = http.send(httpReq);
        if (res.getStatusCode() == 200) {
          PS_SalesforceTokenWrapper wrapper = (PS_SalesforceTokenWrapper) System.JSON.deserialize(
            res.getBody(),
            PS_SalesforceTokenWrapper.class
          );

          /*
                       TODO: Deploy the Custom Metadata
                       ! How to to Deploy
                       Metadata is a NameSpace
                           CustomMetadata - Class
                           CustomMetadataValue - Class
                           Operations - Class
                           DeployCallback - Interface
                   */

          String fullname =
            'Salesforce_Config.' + System.Label.PS_SalesforceTokenLabel;
          String label = System.Label.PS_SalesforceTokenLabel;
          Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
          fieldWithValuesMap.put('access_token__c', wrapper.access_token);
          //fieldWithValuesMap.put('expires_in__c',wrapper.);
          fieldWithValuesMap.put(
            'expires_in_time__c',
            System.now().addHours(2)
          );
          fieldWithValuesMap.put('instance_url__c', wrapper.instance_url);
          fieldWithValuesMap.put('refresh_token__c', wrapper.refresh_token);
          fieldWithValuesMap.put('scope__c', wrapper.scope);
          fieldWithValuesMap.put('client_id__c', config.client_id__c);
          fieldWithValuesMap.put('client_secret__c', config.client_secret__c);

          CreateUpdateMetadataUtils.createUpdateMetadata(
            fullName,
            label,
            fieldWithValuesMap
          );
          ApexPages.addmessage(
            new ApexPages.message(ApexPages.severity.CONFIRM, 'Successfull!')
          );
          // Success
        } else {
          // 400
          System.debug('ERROR \n ' + res.getBody());
          ApexPages.addmessage(
            new ApexPages.message(ApexPages.severity.ERROR, res.getBody())
          );
          // error
        }
      } catch (System.CalloutException ex) {
        ApexPages.addmessage(
          new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage())
        );
      }
    }
  }

  public static Boolean isValid(Salesforce_Config__mdt config) {
    Boolean isValid = true;
    if (config.expires_in_time__c < System.now()) {
      isValid = false;
    }
    return isValid;
  }

  public static Map<String, Object> refreshToken(
    salesforce_Config__mdt config
  ) {
    String orgUrl = config.Environment__c == 'Production'
      ? 'https://login.salesforce.com'
      : 'https://test.salesforce.com';
    String tokenUrl = orgUrl + config.token_Url__c;

    String requestBody =
      'grant_type=refresh_token&client_id=' +
      config.client_id__c +
      '&client_secret=' +
      config.client_secret__c +
      '&refresh_token=' +
      config.refresh_token__c;

    HttpRequest req = PS_CalloutUtils.prepareRequest(
      tokenUrl,
      'POST',
      requestBody,
      'application/json',
      'application/x-www-form-urlencoded'
    );
    Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
    try {
      HttpResponse httpRes = (new Http()).send(req);
      if (httpRes.getStatusCode() == 200 || httpRes.getStatusCode() == 201) {
        PS_SalesforceTokenWrapper wrapper = (PS_SalesforceTokenWrapper) System.JSON.deserialize(
          httpRes.getBody(),
          PS_SalesforceTokenWrapper.class
        );
        fieldWithValuesMap.put('access_token__c', wrapper.access_token);
        fieldWithValuesMap.put('expires_in_time__c', System.now().addHours(2));
        //CreateUpdateMetadataUtils.createUpdateMetadata(fullName, label, fieldWithValuesMap);
      } else {
      }
    } catch (System.CalloutException ex) {
    }

    return fieldWithValuesMap;
  }
}
