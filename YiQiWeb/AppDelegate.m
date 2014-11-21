//
//  AppDelegate.m
//  YiQiWeb
//
//  Created by Mac on 14-11-14.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"
#import "SqlServer.h"
@implementation AppDelegate

@synthesize shareKind,shareContent,imageData,shareUrl,imageUrl;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    
//    [NSThread sleepForTimeInterval:1.0];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    MainView*mainView = [[MainView alloc]init];
    UINavigationController*nav_mainView = [[UINavigationController alloc]initWithRootViewController:mainView];
    self.window.rootViewController = nav_mainView;
    [self.window makeKeyAndVisible];
    
    SqlServer *sqlDbInstance = [SqlServer sharedInstance];
    [sqlDbInstance openDB];
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS COLLECTIONINFO(ID INTEGER PRIMARY KEY AUTOINCREMENT,TITLE TEXT,URL TEXT,COLLECTIONDATE TEXT,IMAGEDATA BLOB) ";
    [sqlDbInstance exec:sqlCreateTable];
    
    int cacheSizeMemory = 4*1024*1024; // 4MB
    int cacheSizeDisk = 32*1024*1024; // 32MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"shareKind" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareKind:) name:@"shareKind" object:nil];
    return YES;
}
-(void)shareKind:(NSNotification*)notif
{
    NSDictionary*dict = [notif userInfo];
    shareKind = [dict objectForKey:@"shareKind"];
    shareContent = [dict objectForKey:@"content"];
    imageData = [dict objectForKey:@"imageData"];
    shareUrl = [NSString stringWithFormat:@"%@",[dict objectForKey:@"shareUrl"]];
    imageUrl = [dict objectForKey:@"imageUrl"];
    NSLog(@"%@",shareContent);
}

//程序回调返回
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"2132213233434");
    if ([shareKind isEqualToString:@"新浪微博"])
    {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }else if ([shareKind isEqualToString:@"QQ空间"])
    {
        return [TencentOAuth HandleOpenURL:url];
    }
    return [[WbApi getWbApi]handleOpenURL:url];
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"213233234525434");
    if ([shareKind isEqualToString:@"新浪微博"])
    {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }else if ([shareKind isEqualToString:@"QQ空间"])
    {
        return [TencentOAuth HandleOpenURL:url];
    }
    return [[WbApi getWbApi]handleOpenURL:url];
}
//QQ代理
-(void)tencentDidLogout
{
    
}
-(void)tencentDidLogin
{
    [JDStatusBarNotification showWithStatus:@"正在努力发送中..." styleName:JDStatusBarStyleWarning];
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
    NSLog(@"2313");
    NSString *utf8String = shareUrl;
    NSMutableString*title = [[NSMutableString alloc]initWithString:shareContent];
    NSRange range = NSMakeRange(shareContent.length-shareUrl.length, shareUrl.length);
    [title deleteCharactersInRange:range];
    NSString *description = shareContent;
    NSLog(@"%@%@",shareUrl,imageUrl);
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:utf8String]
                                title:title
                                description:description
                                previewImageURL:[NSURL URLWithString:imageUrl]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qzone
    NSLog(@"%d",[QQApiInterface SendReqToQZone:req]);
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"sendSuccess" object:nil];
    
}
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    
}
-(void)tencentDidNotNetWork
{
    
}
-(BOOL)onTencentReq:(TencentApiReq *)req
{
    return YES;
}
-(BOOL)onTencentResp:(TencentApiResp *)resp
{
    return YES;
}
//下面三个方法为新浪回调方法
//收到微博的请求
-(void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}
//微博响应请求返回方法
-(void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
//    NSLog(@"21323434");
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
            
            [JDStatusBarNotification showWithStatus:@"正在努力发送中..." styleName:JDStatusBarStyleWarning];
            [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
            NSString *url;
            NSDictionary*params;

            url = @"https://upload.api.weibo.com/2/statuses/upload.json";
//            NSLog(@"%@",shareContent);
            params=@{@"status":shareContent,@"pic":imageData};
            
            [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"SinaToken"] url:url httpMethod:@"POST" params:params delegate:self withTag:@"1000"];
        }
    }
}
//请求返回数据加载完毕
-(void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
//    NSLog(@"%@",result);
    if ([request.tag isEqualToString:@"1000"])
    {
//        [JDStatusBarNotification showWithStatus:@"发送成功" dismissAfter:1 styleName:@"JDStatusBarStyleSuccess"];

        [[NSNotificationCenter defaultCenter]postNotificationName:@"sendSuccess" object:nil];
    }
}
//请求返回失败
-(void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{
    if ([request.tag isEqualToString:@"1000"])
    {
        [JDStatusBarNotification showWithStatus:@"发送失败" dismissAfter:1 styleName:@"JDStatusBarStyleSuccess"];
    }
}


//下面方法为腾讯微博回调方法
-(void)DidAuthFinished:(WeiboApiObject *)wbobj
{
    [JDStatusBarNotification showWithStatus:@"正在努力发送中..." styleName:JDStatusBarStyleWarning];
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"已登陆" forKey:@"腾讯登陆状态"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    UIImage*image = [UIImage imageWithData:imageData];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"json",@"format",shareContent, @"content",image,@"pic",nil];
    [[WbApi getWbApi] requestWithParams:params apiName:@"t/add_pic" httpMethod:@"POST" delegate:self];
    
}
//腾讯微博请求数据返回方法
-(void)didReceiveRawData:(NSData *)data reqNo:(int)reqno
{
//    [JDStatusBarNotification showWithStatus:@"发送成功" dismissAfter:1 styleName:@"JDStatusBarStyleSuccess"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"sendSuccess" object:nil];
}
//腾讯微博错误返回方法
-(void)didFailWithError:(NSError *)error reqNo:(int)reqno
{
    NSLog(@"%@",error);
}
//应用收到内存警告时执行的方法。
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

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
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}




@end
