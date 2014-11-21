//
//  KZJShareSheet.h
//  DayDayWeibo
//
//  Created by bk on 14-10-23.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "WeiboSDK.h"
#import "WeiboApi.h"
#import "AppDelegate.h"
#import "WbApi.h"
#import "Collection.h"

#import "SqlServer.h"
@interface ShareSheet : UIView<WeiboAuthDelegate,WeiboRequestDelegate>

@property(strong,nonatomic)UIWebView*webview;
@property(strong,nonatomic)Collection*item;
@property(strong,nonatomic)NSData*imageData;
+(ShareSheet*)shareWeiboView;
+(UIView*)shareCardView;
@end
