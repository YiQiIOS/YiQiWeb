//
//  AppDelegate.h
//  YiQiWeb
//
//  Created by Mac on 14-11-14.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainView.h"
#import "WeiboSDK.h"
#import "WeiboApi.h"
#import "WbApi.h"
#import "JDStatusBarNotification.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/sdkdef.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <AVFoundation/AVFoundation.h>
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIWebViewDelegate,WeiboSDKDelegate,WeiboAuthDelegate,WeiboRequestDelegate,WBHttpRequestDelegate,TencentSessionDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)NSString*shareKind;
@property(strong,nonatomic)NSString*shareContent;
@property(strong,nonatomic)NSString*shareUrl;
@property(strong,nonatomic)NSString*imageUrl;
@property(strong,nonatomic)NSData*imageData;
@property(strong,nonatomic)Reachability*reachability;

@end
