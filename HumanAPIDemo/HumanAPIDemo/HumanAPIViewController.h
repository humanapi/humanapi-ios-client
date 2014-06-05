//
//  HumanAPIViewController.h
//  HumanAPIDemo
//
//  Created by Yuri Subach on 05/06/14.
//  Copyright (c) 2014 Yuri Subach. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HumanAPINotifications <NSObject>
@optional
- (void)onAuthorizeSuccess:(NSString *)accessToken;
- (void)onAuthorizeFailure:(NSString *)error;
@end


@interface HumanAPIViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, weak) id <HumanAPINotifications> delegate;
@property (nonatomic, retain) UIWebView *myWebView;
@property NSString *clientID;
@property NSString *clientSecret;

- (void)startAuthorizeFlowWithClientID:(NSString *)cliendID
                       andClientSecret:(NSString *)clientSecret;
- (void)startConnectFlow;

@end
