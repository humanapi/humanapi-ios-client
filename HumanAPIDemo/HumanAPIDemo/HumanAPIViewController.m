//
//  HumanAPIViewController.m
//  HumanAPIDemo
//
//  Created by Yuri Subach on 05/06/14.
//  Copyright (c) 2014 Yuri Subach. All rights reserved.
//

#import "HumanAPIViewController.h"
#import "NXOAuth2.h"
#import "AFNetworking.h"

@implementation HumanAPIViewController

NSString *HumanAPIAuthURL  = @"https://user.humanapi.co/oauth/authorize";
NSString *HumanAPITokenURL = @"https://user.humanapi.co/oauth/token";
NSString *redirectURL = @"https://oauth/";

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 54, 320, 480 - 54)];
    self.myWebView.backgroundColor = [UIColor whiteColor];
    self.myWebView.scalesPageToFit = YES;
    self.myWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                       UIViewAutoresizingFlexibleHeight);
    self.myWebView.delegate = self;
    [self.view addSubview:self.myWebView];

    UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 54)];
    //do something like background color, title, etc you self
    /*[navbar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    navbar.shadowImage = [UIImage new];*/
    navbar.backgroundColor = [UIColor whiteColor];
    //navbar.translucent = YES;
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = @"Human API";
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                    target:self
                                    action:@selector(onClickCancel)];
    navItem.rightBarButtonItem = doneButton;
    navbar.items = @[ navItem ];
    [self.view addSubview:navbar];
}

- (void)onClickCancel
{
    [self fireAuthorizeFailureWithError:@"cancelled by user"];
    [self dismiss];
}

- (void)dismiss {
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}

- (void)fireAuthorizeSuccessWithToken:(NSString *)accessToken
{
    id<HumanAPINotifications> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(onAuthorizeSuccess:)]) {
        [delegate onAuthorizeSuccess:accessToken];
    }
}

- (void)fireAuthorizeFailureWithError:(NSString *)error
{
    id<HumanAPINotifications> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(onAuthorizeFailure:)]) {
        [delegate onAuthorizeFailure:error];
    }
}

- (void)startAuthorizeFlowWithClientID:(NSString *)cliendID
                       andClientSecret:(NSString *)clientSecret;
{
    self.clientID = cliendID;
    self.clientSecret = clientSecret;
    
    [[NXOAuth2AccountStore sharedStore] setClientID:cliendID
                                             secret:clientSecret
                                   authorizationURL:[NSURL URLWithString:HumanAPIAuthURL]
                                           tokenURL:[NSURL URLWithString:HumanAPITokenURL]
                                        redirectURL:[NSURL URLWithString:redirectURL]
                                     forAccountType:@"HumanAPI"];
    
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"HumanAPI"
                                   withPreparedAuthorizationURLHandler:^(NSURL *preparedURL) {
                                       NSLog(@"Open URL: %@", preparedURL);
                                       [self.myWebView loadRequest:
                                        [NSURLRequest requestWithURL:preparedURL]];
                                   }];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *reqStr = request.URL.absoluteString;
    NSLog(@"req = %@", reqStr);
    if ([reqStr hasPrefix:redirectURL]) {
        NSLog(@"found redirectURL!");
        [self processAuthCodeFrom:request.URL];
        return NO;
    }
    return YES;
}

- (void)processAuthCodeFrom:(NSURL *)url
{
    NSDictionary *params = [self parseQueryString:[url query]];
    NSString *code = [params objectForKey:@"code"];
    if (code == nil) {
        NSLog(@"ERROR: `code` not found in request");
        [self dismiss];
        [self fireAuthorizeFailureWithError:@"`code` not found in request"];
        return;
    }
    NSLog(@"found code = %@", code);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"client_id": self.clientID,
                                 @"client_secret": self.clientSecret,
                                 @"code": code};
    [manager POST:HumanAPITokenURL parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              //NSLog(@"JSON: %@", responseObject);
              NSDictionary *res = (NSDictionary *)responseObject;
              NSLog(@"access_token = %@", res[@"access_token"]);
              [self dismiss];
              [self fireAuthorizeSuccessWithToken:res[@"access_token"]];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [self dismiss];
              [self fireAuthorizeFailureWithError:@"error while requesting `access_token`"];
          }];
}

- (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}

- (void)startConnectFlow
{
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations
{
	//	Only allow rotation to portrait
	return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
	//	Force to portrait
	return UIInterfaceOrientationPortrait;
}

@end
