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
    
    NSString *myClientID = @"659e9bd58ec4ee7fa01bc6b4627cb37e5c13ec21"; //From the Developer Portal
    //URL to send sessionTokenObject (finalize authentication on your server)
    NSString *authURL = @"http://demo1235462.mockable.io/sessionToken";
    
    HumanAPIViewController *hvc = [[HumanAPIViewController alloc] initWithClientID:myClientID
                                                                        andAuthURL:authURL];
    hvc.delegate = self;
    [self presentViewController:hvc animated:YES completion:nil];
    [hvc startConnectFlowForNewUser:@"test_usery"];
    
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
