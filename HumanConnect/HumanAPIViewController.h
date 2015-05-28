//
//  HumanAPIViewController.h
//  HumanAPIDemo
//
//  Created by Yuri Subach on 05/06/14.
//  Copyright (c) 2014 Yuri Subach. All rights reserved.
//

#import <UIKit/UIKit.h>

/** Flow type definition */
typedef NS_ENUM(NSInteger, HumanAPIFlowType) {
    FlowTypeAuthorize,
    FlowTypeConnect
};

/** Notifications (callbacks) specification */
@protocol HumanAPINotifications <NSObject>
@optional
- (void)onConnectSuccess:(NSString *)humanId sessionTokenObject:(NSString *)sessionTokenObject;
- (void)onConnectFailure:(NSString *)error;
@end

/**
 * HumanAPI UI component
 */
@interface HumanAPIViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, weak) id <HumanAPINotifications> delegate;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIWebView *popupWebView;
@property NSString *clientID;
@property HumanAPIFlowType flowType;
@property CGFloat keyboardFixer;

- (id)initWithClientID:(NSString *)cliendID;
- (void)startConnectFlowForNewUser:(NSString *)userId;
- (void)startConnectFlowFor:(NSString *)userId andPublicToken:(NSString *)publicToken;

@end
