//
//  HumanConnectViewController.h
//  Copyright (c) 2016 Human API. All rights reserved.
//  Version 1.1
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
- (void)onConnectSuccess:(NSString *)publicToken;
- (void)onConnectFailure:(NSString *)error;
@end

/**
 * HumanAPI UI component
 */
@interface HumanConnectViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, weak) id <HumanAPINotifications> delegate;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIWebView *popupWebView;
@property NSString *clientID;
@property NSString *authURL;
@property NSDictionary *options;
@property HumanAPIFlowType flowType;
@property CGFloat keyboardFixer;

- (id)initWithClientID:(NSString *)cliendID andAuthURL:(NSString *)authURL;
- (void)startConnectFlowForNewUser:(NSString *)userId;
- (void)startConnectFlowFor:(NSString *)userId andPublicToken:(NSString *)publicToken;

@end
