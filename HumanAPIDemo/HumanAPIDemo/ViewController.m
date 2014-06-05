//
//  ViewController.m
//  HumanAPIDemo
//
//  Created by Yuri Subach on 13/05/14.
//  Copyright (c) 2014 Yuri Subach. All rights reserved.
//

#import "ViewController.h"
#import "GTMOAuth2ViewControllerTouch.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(onClick:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Authorize" forState:UIControlStateNormal];
    button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [self.view addSubview:button];
}

- (void)onClick:(UIButton*)button
{
    NSLog(@"Auth started");
    GTMOAuth2Authentication *auth = [self HumanAPIAuth];
    NSURL *authURL = [NSURL URLWithString:@"https://user.humanapi.co/oauth/authorize"];
    
    // Display the authentication view
    GTMOAuth2ViewControllerTouch *viewController;
    viewController = [[GTMOAuth2ViewControllerTouch alloc] initWithAuthentication:auth
                                                                 authorizationURL:authURL
                                                                 keychainItemName:kKeychainItemName
                                                                         delegate:self
                                                                 finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    /*
    GTMOAuth2ViewControllerTouch *viewController;
    viewController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:scope
                                                                 clientID:kMyClientID
                                                             clientSecret:kMyClientSecret
                                                         keychainItemName:kKeychainItemName
                                                                 delegate:self
                                                         finishedSelector:@selector(viewController:finishedWithAuth:error:)];
     */
    [self presentViewController:viewController animated:YES completion:nil];
}

static NSString *const kKeychainItemName = @"HumanAPI OAuth2";
NSString *kMyClientID = @"9bac0e053f486619c0795015c99477b49b229961";     // pre-assigned by service
NSString *kMyClientSecret = @"b20f0c6cb300e7f6cfef2bb240d3f48481094efe"; // pre-assigned by service

- (GTMOAuth2Authentication *)HumanAPIAuth {
    
    NSURL *tokenURL = [NSURL URLWithString:@"https://user.humanapi.co/oauth/token"];
    
    // We'll make up an arbitrary redirectURI.  The controller will watch for
    // the server to redirect the web view to this URI, but this URI will not be
    // loaded, so it need not be for any actual web page.
    NSString *redirectURI = @"https://oauth/";
    
    GTMOAuth2Authentication *auth;
    auth = [GTMOAuth2Authentication authenticationWithServiceProvider:@"HumanAPI"
                                                             tokenURL:tokenURL
                                                          redirectURI:redirectURI
                                                             clientID:kMyClientID
                                                         clientSecret:kMyClientSecret];
    // Specify token type
    auth.tokenType = @"Bearer";
    //auth.authorizationTokenKey = @"access_token";
    
    // Specify the appropriate scope string, if any, according to the service's API documentation
    auth.scope = @"";

    return auth;
}

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error
{
    if (error != nil) {
        // Authentication failed
        NSLog(@"Auth failed");
    } else {
        // Authentication succeeded
        NSLog(@"Auth succeeded");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
