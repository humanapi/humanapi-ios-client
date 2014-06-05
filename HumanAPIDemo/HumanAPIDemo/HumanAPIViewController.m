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

@interface HumanAPIViewController ()

@end

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
    self.myWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
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
                                    action:@selector(dismiss)];
    navItem.rightBarButtonItem = doneButton;
    navbar.items = @[ navItem ];
    [self.view addSubview:navbar];
}

- (void)dismiss {
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
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
    //[self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://yurisubach.com"]]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    NSString *reqStr = url.absoluteString;
    NSLog(@"req = %@", reqStr);
    if ([reqStr hasPrefix:redirectURL]) {
        NSLog(@"found redirectURL!");
        NSDictionary *params = [self parseQueryString:[url query]];
        NSString *code = [params objectForKey:@"code"];
        if (code == nil) {
            NSLog(@"ERROR: `code` not found in request");
            return NO;
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
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
              }];
        
        /*NSString *redir = [NSString stringWithFormat:@"%@?%@", redirectURL, url.query];
        [[NXOAuth2AccountStore sharedStore] handleRedirectURL:[NSURL URLWithString:redir]];
        */
         
        /*
        NXOAuth2Account *account = [[NXOAuth2AccountStore sharedStore]
                                    accountWithIdentifier:@"HumanAPI"];
        [NXOAuth2Request performMethod:@"POST"
                            onResource:[NSURL URLWithString:HumanAPITokenURL]
                       usingParameters:@{@"code":code, @"grant_type":@"authorization_code"}
                           withAccount:account
                   sendProgressHandler:^(unsigned long long bytesSend, unsigned long long bytesTotal) {
                   }
                       responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error){
                           NSString* respStr = [NSString stringWithUTF8String:[responseData bytes]];
                           NSLog(@"response = %@", respStr);
                       }];
        */
        return NO;
    }
    return YES;
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

@end
