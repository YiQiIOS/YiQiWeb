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
@interface KZJShareSheet : UIView<WeiboAuthDelegate,WeiboRequestDelegate>
@property(strong,nonatomic)UIWebView*webview;
+(KZJShareSheet*)shareWeiboView;
+(UIView*)shareCardView;
@end
