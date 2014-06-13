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
NSString *HumanAPIConnectTokensURL = @"https://user.humanapi.co/v1/connect/tokens";

/** Initialization of the instance */
- (id)initWithClientID:(NSString *)cliendID andClientSecret:(NSString *)clientSecret
{
    self = [super init];
    self.clientID = cliendID;
    self.clientSecret = clientSecret;
    return self;
}

/** Initialization of the UI */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // UIWebView init
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 54, 320, 480 - 54)];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scalesPageToFit = YES;
    self.webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                       UIViewAutoresizingFlexibleHeight);
    self.webView.delegate = self;
    [self.view addSubview:self.webView];

    // Navigation bar
    UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 54)];
    navbar.backgroundColor = [UIColor whiteColor];
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

/** Cancel click handler */
- (void)onClickCancel
{
    if (self.flowType == FlowTypeConnect) {
        [self fireConnectFailureWithError:@"cancelled by user"];
    } else {
        [self fireAuthorizeFailureWithError:@"cancelled by user"];
    }
    [self dismiss];
}

/** Disable entire UI */
- (void)dismiss {
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}

/** UIWebView request handler, used for catching specific URLs */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *reqStr = request.URL.absoluteString;
    NSLog(@"req = %@ : %d", reqStr, navigationType);
    if ([reqStr hasPrefix:redirectURL]) {
        [self processAuthCodeFrom:request.URL];
        return NO;
    } else if ([reqStr hasPrefix:@"https://connect-token"]) {
        [self processConnectTokenFrom:request.URL];
        return NO;
    } else if ([reqStr hasPrefix:@"https://connect-closed"]) {
        [self fireConnectFailureWithError:@"closed by user"];
        [self dismiss];
        return NO;
    }
    return YES;
}

/**
 * Authorize flow entry point
 */
- (void)startAuthorizeFlow
{
    self.flowType = FlowTypeAuthorize;
    [[NXOAuth2AccountStore sharedStore] setClientID:self.clientID
                                             secret:self.clientSecret
                                   authorizationURL:[NSURL URLWithString:HumanAPIAuthURL]
                                           tokenURL:[NSURL URLWithString:HumanAPITokenURL]
                                        redirectURL:[NSURL URLWithString:redirectURL]
                                     forAccountType:@"HumanAPI"];
    
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"HumanAPI"
                                   withPreparedAuthorizationURLHandler:^(NSURL *preparedURL) {
                                       NSLog(@"Open URL: %@", preparedURL);
                                       [self.webView loadRequest:
                                        [NSURLRequest requestWithURL:preparedURL]];
                                   }];
}

/** Process data returned from JS on authorize flow */
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
    NSDictionary *postData = @{@"client_id": self.clientID,
                               @"client_secret": self.clientSecret,
                               @"code": code};
    [manager POST:HumanAPITokenURL parameters:postData
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

/** Calls authorize success method in delegate */
- (void)fireAuthorizeSuccessWithToken:(NSString *)accessToken
{
    id<HumanAPINotifications> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(onAuthorizeSuccess:)]) {
        [delegate onAuthorizeSuccess:accessToken];
    }
}

/** Calls authorize failure method in delegate */
- (void)fireAuthorizeFailureWithError:(NSString *)error
{
    id<HumanAPINotifications> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(onAuthorizeFailure:)]) {
        [delegate onAuthorizeFailure:error];
    }
}

/**
 * Connect flow entry point (without user)
 */
- (void)startConnectFlow
{
    [self startConnectFlowFor:nil];
}

/**
 * Connect flow entry point for specific `userId`
 */
- (void)startConnectFlowFor:(NSString *)userId
{
    self.flowType = FlowTypeConnect;
    NSString *html = [NSString stringWithFormat:@"<html> \n"
                      "<body onload=\" \n"
                      "HumanConnect.open({ \n"
                      "    iframe: true, \n"
                      "    clientId: '%@', \n"
                      "    clientUserId: '%@', \n"
                      "    _baseURL: 'https://connect.humanapi.co', \n"
                      //"    _baseURL: 'http://localhost:4000', \n"
                      "    finish: function(err, obj) { \n"
                      "        window.location = 'https://connect-token?' + \n"
                      "            'sessionToken=' + obj.sessionToken + \n"
                      "            '&humanId=' + obj.humanId; \n"
                      "    }, \n"
                      "    close: function() { \n"
                      "        window.location = 'https://connect-closed'; \n"
                      "    } \n"
                      "}); \n"
                      "\"> \n"
                      "<script src='https://connect.humanapi.co/connect.js'></script> \n"
                      //"<script src='http://localhost:4000/connect.js'></script> \n"
                      "</body></html>", self.clientID, userId];
    [self.webView loadHTMLString:html baseURL:nil];
}

/** Process data returned from JS on connect flow */
- (void)processConnectTokenFrom:(NSURL *)url
{
    NSDictionary *params = [self parseQueryString:[url query]];
    NSString *humanId = [params objectForKey:@"humanId"];
    if (humanId == nil || [humanId length] == 0) {
        NSLog(@"ERROR: `humanId` not found in request");
        [self dismiss];
        [self fireConnectFailureWithError:@"`humanId` not found in request"];
        return;
    }
    NSString *sessionToken = [params objectForKey:@"sessionToken"];
    if (sessionToken == nil || [sessionToken length] == 0) {
        NSLog(@"ERROR: `sessionToken` not found in request");
        [self dismiss];
        [self fireConnectFailureWithError:@"`sessionToken` not found in request"];
        return;
    }
    NSLog(@"found humanId=%@, sessionToken=%@", humanId, sessionToken);

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *postData = @{@"clientId": self.clientID,
                               @"clientSecret": self.clientSecret,
                               @"humanId": humanId,
                               @"sessionToken": sessionToken};
    [manager POST:HumanAPIConnectTokensURL parameters:postData
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              //NSLog(@"JSON: %@", responseObject);
              NSDictionary *res = (NSDictionary *)responseObject;
              NSLog(@"accessToken = %@", res[@"accessToken"]);
              [self dismiss];
              [self fireConnectSuccessWithData:res];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [self dismiss];
              [self fireConnectFailureWithError:@"error while requesting connect `accessToken`"];
          }];
}

/** Calls connect success method in delegate */
- (void)fireConnectSuccessWithData:(NSDictionary *)data
{
    id<HumanAPINotifications> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(onConnectSuccess:accessToken:publicToken:)]) {
        [delegate onConnectSuccess:data[@"humanId"] accessToken:data[@"accessToken"]
                       publicToken:data[@"publicToken"]];
    }
}

/** Calls connect failure method in delegate */
- (void)fireConnectFailureWithError:(NSString *)error
{
    id<HumanAPINotifications> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(onConnectFailure:)]) {
        [delegate onConnectFailure:error];
    }
}

/** Extract parameters from the `query` string */
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
