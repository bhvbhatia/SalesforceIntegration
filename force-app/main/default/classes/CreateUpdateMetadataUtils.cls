public class CreateUpdateMetadataUtils implements Metadata.DeployCallback {
  public void handleResult(
    Metadata.DeployResult result,
    Metadata.DeployCallbackContext context
  ) {
    if (result.status == Metadata.DeployStatus.SUCCEEDED) {
      System.debug('Success=> ' + result);
    } else {
      System.debug('fail=> ' + result);
    }
  }

  public static void createUpdateMetadata(
    String fullName,
    String label,
    Map<String, Object> fieldWithValuesMap
  ) {
    // STEP1 - create custom metadata object from metadata namespace
    Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
    customMetadata.fullName = fullName;
    customMetadata.label = label;

    for (String key : fieldWithValuesMap.keySet()) {
      //step2 - create custommetadatavalue
      Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();

      customField.field = key;
      customField.value = fieldWithValuesMap.get(key);

      customMetadata.values.add(customField);
    }
    //step3 - create the deploContainer object
    Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();

    mdContainer.addMetadata(customMetadata);

    // step 4 - deploy the metadata

    Id jobId = Metadata.Operations.enqueueDeployment(
      mdContainer,
      new CreateUpdateMetadataUtils()
    );
  }
}
