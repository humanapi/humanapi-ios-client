# HumanAPI iOS - Human Connect

## What's Here
- `HumanConnectViewController.[mh]`: browser based UI to launch Human Connect

## How To Use

1. Copy the `HumanConnect` folder and place it in the base level of your project directory.
2. Install necessary dependencies via CocoaPods
  * Add the following to your Podfile (or [create a new one](https://guides.cocoapods.org/using/the-podfile.html))
    * `pod 'AFNetworking', '~> 2.2'`
    * `pod 'NXOAuth2Client', '~> 1.2.2'`
  * Run `pod install` in you project directory
3. In your ViewController.h file
  * `#import "HumanConnectViewController.h"`
  * Add `<HumanAPINotifications>` protocol to ViewController
  e.g. `@interface ViewController : UIViewController  <HumanAPINotifications>`

4. Launch Human Connect Window
  ```objectivec
    NSString *myClientID = @"<YOUR_CLIENTID>"; //From the Developer Portal
    //URL to send sessionTokenObject (finalize authentication on your server)
    NSString *authURL = @"https://yourdomain.com/endpoint/to/send/sessionTokenObject";

    HumanConnectViewController *hcvc = [[HumanConnectViewController alloc] initWithClientID:myClientID
                                                                        andAuthURL:authURL];
    hcvc.delegate = self;
    [self presentViewController:hcvc animated:YES completion:nil];

  ```
5. Start flow for new or existing user
  ```objectivec
  //If you have a publicToken for the user, supply it to Human Connect on launch
  //'localUser' refers to the current logged in user w/ email and publicToken
  if(localUser.publicToken !=nil){
    //existing HumanAPI User
    [hcvc startConnectFlowFor:localUser.email andPublicToken:localUser.publicToken];
  }else{
    // new Human API user
    [hcvc startConnectFlowForNewUser:locaUser.email];
  }
  ```
6. Finish authentication flow on your server
   * Receive sessionTokenObject to previously specified `authURL`
   * Sign it with `clientSecret`
   * POST signed `sessionTokenObject` from your server to Human API Tokens Endpoint
   `https://user.humanapi.co/v1/connect/publictokens`
   * Retrieve and store `accessToken` and `publicToken` on your server for use to query user data from Human API
   * Return status `200 OK` with payload containing `publicToken` to store on device
   ```
   {
     publicToken: "2767d6oea95f4c3db8e8f3d0a1238302"
   }
   ```

   See the detailed guide here: (http://hub.humanapi.co/v1.0/docs/integrating-human-connect)

7. Implement `onConnectSuccess` & `onConnectFailure` callbacks
  ```objectivec
    /** Connect success handler */
    - (void)onConnectSuccess:(NSString *)publictoken
    {
        NSLog(@"Connect success!  publicToken=%@", publicToken);

        //Notify user of success
        //Store publicToken with user model for subsequent HumanConnect launches

    }

    /** Connect failure handler */
    - (void)onConnectFailure:(NSString *)error
    {
        NSLog(@"Connect failure: %@", error);
        //Called whenever Connect networking fails or the user closes the popup
        //without connecting a data source.

    }
  ```
