//
//  WbApi.m
//  新讯微博
//
//  Created by 3006 on 14-10-23.
//  Copyright (c) 2014年 iBokan. All rights reserved.
//

#import "WbApi.h"

@implementation WbApi

+ (WeiboApi *)getWbApi
{
    static WeiboApi *wbapi;
    if (wbapi == nil)
    {
        wbapi = [[WeiboApi alloc]initWithAppKey:AppKey andSecret:AppSecret andRedirectUri:APPURL andAuthModeFlag:0 andCachePolicy:0];
    }
    return wbapi;
}



@end
