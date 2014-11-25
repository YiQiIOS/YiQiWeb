//
//  ShareViewController.h
//  YiQiWeb
//
//  Created by BK on 14/11/19.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Redraw.h"
#import "JDStatusBarNotification.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/sdkdef.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <AVFoundation/AVFoundation.h>
@interface ShareViewController : UIViewController<UITextViewDelegate>
{
    TencentOAuth* tencentOAuth;
    NSArray* permissions;
}
@property(strong,nonatomic)NSString*shareContent;
@property(strong,nonatomic)NSString*shareKind;
@property(strong,nonatomic)NSData*imageData;
@property(strong,nonatomic)NSString*imageUrl;
@end
