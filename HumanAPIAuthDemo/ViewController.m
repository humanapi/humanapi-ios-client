//
//  ViewController.m
//  HumanAPIAuthDemo
//
//  Created by Michael Lapointe on 5/28/15.
//  Copyright (c) 2015 Human API. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)launchHumanConnect:(id)sender {
    
    NSString *myClientID = @"<Your-Client-ID>"; //From the Developer Portal
    //URL to send sessionTokenObject (finalize authentication on your server)
    NSString *authURL = @"http://localhost:3000/sessionToken";
    
    
    HumanConnectViewController *hcvc = [[HumanConnectViewController alloc] initWithClientID:myClientID
                                                                        andAuthURL:authURL];
    hcvc.delegate = self;
    [self presentViewController:hcvc animated:YES completion:nil];
    
    //For demo purposes -- with local user accounts, use code below instead
    [hcvc startConnectFlowForNewUser:@"testing@hapi.co"];
    
    //If you have a publicToken for the user, supply it to Human Connect on launch
    //localUser refers to the current logged in user w/ email and publicToken
//    if(localUser.publicToken !=nil){
//        //existing HumanAPI User
//        [hcvc startConnectFlowFor:localUser.email andPublicToken:localUser.publicToken];
//    }else{
//        // new Human API user
//        [hcvc startConnectFlowForNewUser:locaUser.email];
//    }
    
}


/** Connect success handler */
- (void)onConnectSuccess:(NSDictionary *)data
{
    NSLog(@"Connect success!  publicToken=\n %@", data);
    
    //Notify user of success
    //Save publicToken with local user for subsequent Human Connect launches
    
}


/** Connect failure handler */
- (void)onConnectFailure:(NSString *)error
{
    NSLog(@"Connect failure: %@", error);
}


@end
