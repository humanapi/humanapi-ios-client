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
    
    NSString *myClientID = @"5ed10aa5099074ffb97f719ceb5bb0ef3c519c42"; //From the Developer Portal
    //URL to send sessionTokenObject (finalize authentication on your server)
    NSString *authURL = @"http://localhost:3000/sessionToken";
    
    
    HumanConnectViewController *hcvc = [[HumanConnectViewController alloc] initWithClientID:myClientID
                                                                        andAuthURL:authURL];
    hcvc.delegate = self;
    [self presentViewController:hcvc animated:YES completion:nil];
    [hcvc startConnectFlowForNewUser:@"texst_dsusss1ser15@hapi.co"];
    
}


/** Connect success handler */
- (void)onConnectSuccess:(NSDictionary *)data
{
    NSLog(@"Connect success!  publicToken=\n %@", data);
    
    //Notify user of success
    //Finish auth flow on your server
    
}


/** Connect failure handler */
- (void)onConnectFailure:(NSString *)error
{
    NSLog(@"Connect failure: %@", error);
}


@end
