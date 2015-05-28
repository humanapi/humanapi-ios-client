# HumanAPI iOS - Human Connect

## What's Here
- `HumanAPIViewController.[mh]`: browser based UI to launch Human Connect

## How To Use

1. Copy the HumanConnect folder and place it in the base level of your project directory.
2. Run `pod install` in your project directory to install the necessary dependencies
  * 'AFNetworking', '~> 2.2'
  * 'NXOAuth2Client', '~> 1.2.2'
3. Launch HumanConnect Window
```
  HumanAPIViewController *hvc = [[HumanAPIViewController alloc] initWithClientID:myClientID];
  hvc.delegate = self;
  [self presentViewController:hvc animated:YES completion:nil];

```
4. Start flow for new or existing user
```

  // new user
  [hvc startConnectFlowForNewUser:@"test_user5"];
  // existing user
  //[hvc startConnectFlowFor:@"test_user4" andPublicToken:@"..."];
```
5. Implement `onConnectSuccess`

```
  /** Connect success handler */
  - (void)onConnectSuccess:(NSString *)humanId sessionTokenObject:(NSString *)sessionTokenObject
  {
      NSLog(@"Connect success: humanId=%@", humanId);
      NSLog(@"..sessionTokenObject=%@", sessionTokenObject);

      //Finish The Auth Flow

  }
```
To Finish Auth Flow
   1. POST the `sessionTokenObject` as is to your server
   2. Sign it with `clientSecret`
   3. POST signed `sessionTokenObject` from your server to Human API Tokens Endpoint
   (https://user.humanapi.co/v1/connect/publictokens)
   4. Retrieve and store `accessToken` and `publicToken` on your server for use to query user data from Human API

   See the detailed guide here: (http://hub.humanapi.co/v1.0/docs/integrating-human-connect)

6. Implement `onConnectFailure`

```
  /** Connect failure handler */
  - (void)onConnectFailure:(NSString *)error
  {
      NSLog(@"Connect failure: %@", error);
  }
```
This method is called whenever Connect networking fails or the user closes the popup without connecting a data source.
