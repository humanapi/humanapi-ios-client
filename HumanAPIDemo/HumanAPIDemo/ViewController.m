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
	// Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(onClickAuthorize:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Authorize" forState:UIControlStateNormal];
    button.frame = CGRectMake(80.0, 130.0, 160.0, 40.0);
    [self.view addSubview:button];

    UIButton *conbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [conbtn addTarget:self
               action:@selector(onClickConnect:)
     forControlEvents:UIControlEventTouchUpInside];
    [conbtn setTitle:@"Connect" forState:UIControlStateNormal];
    conbtn.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [self.view addSubview:conbtn];
}

NSString *myClientID = @"9bac0e053f486619c0795015c99477b49b229961";     // pre-assigned by service
NSString *myClientSecret = @"b20f0c6cb300e7f6cfef2bb240d3f48481094efe"; // pre-assigned by service

- (void)onClickAuthorize:(UIButton*)button
{
    NSLog(@"Authorize started");
    
    HumanAPIViewController *hvc = [[HumanAPIViewController alloc] init];
    hvc.delegate = self;
    [self presentViewController:hvc animated:YES completion:nil];
    [hvc startAuthorizeFlowWithClientID:myClientID andClientSecret:myClientSecret];
}

- (void)onAuthorizeSuccess:(NSString *)accessToken
{
    NSLog(@"Authorize success: %@", accessToken);
}

- (void)onAuthorizeFailure:(NSString *)error
{
    NSLog(@"Authorize failure: %@", error);
}

- (void)onClickConnect:(UIButton*)button
{
    NSLog(@"Connect started");

    HumanAPIViewController *hvc = [[HumanAPIViewController alloc] init];
    hvc.delegate = self;
    [self presentViewController:hvc animated:YES completion:nil];
    [hvc startConnectFlow];
}
 
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
