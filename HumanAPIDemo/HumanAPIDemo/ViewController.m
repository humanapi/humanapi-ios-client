//
//  ViewController.m
//  HumanAPIDemo
//
//  Created by Yuri Subach on 13/05/14.
//  Copyright (c) 2014 Yuri Subach. All rights reserved.
//

#import "ViewController.h"
#import "HumanAPIViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Authorize button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(onClickAuthorize:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Authorize" forState:UIControlStateNormal];
    button.frame = CGRectMake(80.0, 130.0, 160.0, 40.0);
    [self.view addSubview:button];

    // Connect button
    UIButton *conbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [conbtn addTarget:self
               action:@selector(onClickConnect:)
     forControlEvents:UIControlEventTouchUpInside];
    [conbtn setTitle:@"Connect Health Data" forState:UIControlStateNormal];
    conbtn.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [self.view addSubview:conbtn];
}

/* Developemnt instance app */
//NSString *myClientID = @"9bac0e053f486619c0795015c99477b49b229961";

/* Production app test data : pre-assigned by service */
NSString *myClientID = @"9bac0e053f486619c0795015c99477b49b229961";
NSString *myClientSecret = @"b20f0c6cb300e7f6cfef2bb240d3f48481094efe";

/** Authorize click handler */
- (void)onClickAuthorize:(UIButton*)button
{
    NSLog(@"Authorize started");
    HumanAPIViewController *hvc = [[HumanAPIViewController alloc] initWithClientID:myClientID
                                                                   andClientSecret:myClientSecret];
    hvc.delegate = self;
    [self presentViewController:hvc animated:YES completion:nil];
    [hvc startAuthorizeFlow];
}

/** Authorize success callback */
- (void)onAuthorizeSuccess:(NSString *)accessToken
{
    NSLog(@"Authorize success: %@", accessToken);
}

/** Authorize failure callback */
- (void)onAuthorizeFailure:(NSString *)error
{
    NSLog(@"Authorize failure: %@", error);
}

/** Connect click handler */
- (void)onClickConnect:(UIButton*)button
{
    NSLog(@"Connect started");
    HumanAPIViewController *hvc = [[HumanAPIViewController alloc] initWithClientID:myClientID
                                                                   andClientSecret:myClientSecret];
    hvc.delegate = self;
    [self presentViewController:hvc animated:YES completion:nil];
    [hvc startConnectFlow];
}

/** Connect success handler */
- (void)onConnectSuccess:(NSString *)humanId accessToken:(NSString *)accessToken
             publicToken:(NSString *)publicToken
{
    NSLog(@"Connect success: humanId=%@", humanId);
    NSLog(@"..accessToken=%@", accessToken);
    NSLog(@"..publicToken=%@", publicToken);
}

/** Connect failure handler */
- (void)onConnectFailure:(NSString *)error
{
    NSLog(@"Connect failure: %@", error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
