//
//  AppDelegate.m
//  YiQiWeb
//
//  Created by Mac on 14-11-14.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize shareKind,shareContent,shareUrl;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NSThread sleepForTimeInterval:1.0];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    MainView*mainView = [[MainView alloc]init];
    UINavigationController*nav_mainView = [[UINavigationController alloc]initWithRootViewController:mainView];
    self.window.rootViewController = nav_mainView;
    [self.window makeKeyAndVisible];
    
    NSUserDefaults*user = [NSUserDefaults standardUserDefaults];
//    if([user objectForKey:@"TencentToken"])
//    {
//        NSLog(@"313244");
//        
//        [[WeiboApi alloc]loginWithAccesstoken:[user objectForKey:@"TencentToken"] andOpenId:[user objectForKey:@"TencentOpenID"] andExpires:1000 andRefreshToken:nil andDelegate:self];
//    }
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"shareKind" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareKind:) name:@"shareKind" object:nil];
    return YES;
}
-(void)shareKind:(NSNotification*)notif
{
    NSDictionary*dict = [notif userInfo];
    shareKind = [dict objectForKey:@"shareKind"];
    shareUrl = [dict objectForKey:@"url"];
//    NSLog(@"%@",shareKind);
}
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"2132213233434");
    if ([shareKind isEqualToString:@"新浪"])
    {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
        return [[WbApi getWbApi]handleOpenURL:url];
    return YES;
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"213233234525434");
    if ([shareKind isEqualToString:@"新浪"])
    {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    return YES;
        return [[WbApi getWbApi]handleOpenURL:url];
}
//下面三个方法为新浪回调方法
-(void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}
-(void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    NSLog(@"21323434");
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess )
        {
            [[NSUserDefaults standardUserDefaults]setObject:@"已登陆" forKey:@"新浪登陆状态"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            NSUserDefaults*user = [NSUserDefaults standardUserDefaults];
            [user setObject:[(WBAuthorizeResponse *)response accessToken] forKey:@"SinaToken"];
            [user setObject:[(WBAuthorizeResponse *)response userID] forKey:@"SinaUserID"];
            [user synchronize];
//            NSLog(@"%@",[(WBAuthorizeResponse *)response userID]);
            
            
            [JDStatusBarNotification showWithStatus:@"正在努力发送中..." styleName:JDStatusBarStyleWarning];
            [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
            NSString *url;
            NSDictionary*params;
//            if (message.length>0  && imageArr.count>1)
//            {
//                url = @"https://upload.api.weibo.com/2/statuses/upload.json";
//                params=[NSDictionary dictionaryWithObjectsAndKeys:message,@"status",[imageArr objectAtIndex:0],@"pic",[NSString stringWithFormat:@"%d",visible],@"visible",nil];
//            }
//            else if(message.length>0)
//            {
                url = @"https://api.weibo.com/2/statuses/update.json";
            NSLog(@"%@",shareUrl);
                params=[NSDictionary dictionaryWithObjectsAndKeys:shareUrl,@"status",nil];
//            }
            
            
            [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:url httpMethod:@"POST" params:params delegate:self withTag:@"1000"];
        }
    }
}
-(void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
//    NSLog(@"%@",result);
    if ([request.tag isEqualToString:@"1000"])
    {
        [JDStatusBarNotification showWithStatus:@"发送成功" dismissAfter:1 styleName:@"JDStatusBarStyleSuccess"];
    }
}
-(void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{
    if ([request.tag isEqualToString:@"1000"])
    {
        [JDStatusBarNotification showWithStatus:@"发送失败" dismissAfter:1 styleName:@"JDStatusBarStyleSuccess"];
    }
}


//下面方法为腾讯微博回调方法
-(void)DidAuthFinished:(WeiboApi *)wbobj
{
    NSLog(@"2423");
    [JDStatusBarNotification showWithStatus:@"正在努力发送中..." styleName:JDStatusBarStyleWarning];
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"已登陆" forKey:@"腾讯登陆状态"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
//    NSUserDefaults*user = [NSUserDefaults standardUserDefaults];
//    [user setObject:wbapi.accessToken forKey:@"TencentToken"];
//    [user setObject:wbapi.openid forKey:@"TencentOpenID"];
//    [user synchronize];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"json",@"format",shareUrl, @"content",nil];
    [wbobj requestWithParams:params apiName:@"t/add" httpMethod:@"POST" delegate:self];
    
}
-(void)didReceiveRawData:(NSData *)data reqNo:(int)reqno
{
    NSLog(@"2132");
    [JDStatusBarNotification showWithStatus:@"发送成功" dismissAfter:1 styleName:@"JDStatusBarStyleSuccess"];
    
//    [[WbApi getWbApi]ref:self];
}

-(void)didFailWithError:(NSError *)error reqNo:(int)reqno
{
    NSLog(@"%@",error);
}

//-(void)DidAut
//{
//    [[NSUserDefaults standardUserDefaults]setObject:@"已登陆" forKey:@"腾讯登陆状态"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//    
////    NSUserDefaults*user = [NSUserDefaults standardUserDefaults];
////    [user setObject:wbapi.accessToken forKey:@"TencentToken"];
////    [user setObject:wbapi.openid forKey:@"TencentOpenID"];
////    [user synchronize];
//}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"YiQiWeb" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"YiQiWeb.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}




@end
