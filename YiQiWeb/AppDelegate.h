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
@interface AppDelegate : UIResponder <UIApplicationDelegate,UIWebViewDelegate,WeiboSDKDelegate,WeiboAuthDelegate,WeiboRequestDelegate,WBHttpRequestDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)NSString*shareKind;
@property(strong,nonatomic)NSString*shareUrl;
@property(strong,nonatomic)NSString*shareContent;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
