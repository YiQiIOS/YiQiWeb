//
//  MainView.h
//  YiQiWeb
//
//  Created by BK on 14/11/18.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Redraw.h"
#import "ShareSheet.h"
#import "ShareViewController.h"
#import "BaseAnimation.h"
#import "SlideAnimation.h"
#import "ReminderView.h"
#import "CameraView.h"
@interface MainView : UIViewController<UIWebViewDelegate,UIActionSheetDelegate,UIViewControllerTransitioningDelegate,UINavigationControllerDelegate>
{
    int time;
}
@property(strong,nonatomic)UIWebView*webview;

@end
