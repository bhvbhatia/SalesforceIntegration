Step1 - get the auth code

authorization url - https://login.salesforce.com/services/oauth2/authorize

https://help.salesforce.com/s/articleView?id=sf.remoteaccess_oauth_tokens_scopes.htm&type=5


https://login.salesforce.com/services/oauth2/authorize?client_id=3MVG9GCMQoQ6rpzR93jXBKKy.9mFs1GwcqW7F4U7QHeltHC72yMT4S29KQVwSJP2MmXn9ILYnqOXxDc31PEON&
redirect_uri=https://chatgpt.com/&response_type=code


recived the code - 
https://chromewebstore.google.com/detail/mortality-death-clock-new/eeedcpdcehnikgkhbobmkjcipjhlbmpn?
code=aPrxp.7fR25AS7PL0BKeKw729vPjY4Fz1WCSqUFaBfk6s6t5NeN1fJgZozQ2Z2_pYB9Uc_DF7w%3D%3D&state=abc12434534

step2 - get the access token 

https://login.salesforce.com/services/oauth2/token

var responseBody = pm.response.json();
console.log(response);
pm.environment.set('access_token',responseBody.access_token );
pm.environment.set('refresh_token',responseBody.refresh_token );
pm.environment.set('scope',responseBody.scope );
pm.environment.set('instance_url',responseBody.instance_url );
pm.environment.set('access_token',responseBody.access_token );
