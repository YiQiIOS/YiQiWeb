//
//  KZJShareSheet.m
//  DayDayWeibo
//
//  Created by bk on 14-10-23.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJShareSheet.h"

@implementation KZJShareSheet
@synthesize webview;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(KZJShareSheet*)shareWeiboView
{
    static KZJShareSheet*view1 = nil;
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    if (view1==nil)
    {
        view1 =[[KZJShareSheet alloc]initWithFrame:CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT-20)];
        
        NSLog(@"%f",SCREENWIDTH);
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(5, SCREENHEIGHT-220-20, SCREENWIDTH-10, 220)];
        view.layer.cornerRadius = 8;
        view.backgroundColor= [UIColor whiteColor];
        NSArray*titleArray = [NSArray arrayWithObjects:@"新浪",@"腾讯微博",@"微信好友",@"朋友圈",@"查看收藏",@"收藏",@"复制链接", nil];
        UILabel*title = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 100, 25)];
        title.text = @"分享到";
        [view addSubview:title];
        for (int i =0; i<[titleArray count]; i++)
        {
            UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
            if (i<4)
            {
                btn.frame = CGRectMake(10+i*80, 40, 44, 44);
            }else
            {
                btn.frame = CGRectMake(10+(i-4)*80, 120, 44, 44);
            }
            
            btn.tag = 1000+i;
            if (i==0) {
                [btn setImage:[UIImage imageNamed:@"more_weibo@2x"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"more_weibo@2x"] forState:UIControlStateHighlighted];
            }else if (i==2)
            {
                [btn setImage:[UIImage imageNamed:@"more_weixin@2x"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"more_weixin_highlighted@2x"] forState:UIControlStateHighlighted];
            }else if (i==3)
            {
                [btn setImage:[UIImage imageNamed:@"more_circlefriends@2x"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"more_circlefriends_highlighted@2x"] forState:UIControlStateHighlighted];
            }else if (i==1)
            {
                [btn setImage:[UIImage imageNamed:@"icon_default@2x"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"icon_default@2x"] forState:UIControlStateHighlighted];
            }else if (i==5)
            {
                [btn setImage:[UIImage imageNamed:@"more_icon_collection@2x 17"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"more_icon_collection@2x 17"] forState:UIControlStateHighlighted];
            }
            else if (i==4)
            {
                [btn setImage:[UIImage imageNamed:@"more_icon_collection1@2x"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"more_icon_collection1@2x"] forState:UIControlStateHighlighted];
            }else if (i==6)
            {
                [btn setImage:[UIImage imageNamed:@"more_icon_link@2x"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"more_icon_link@2x"] forState:UIControlStateHighlighted];
            }
            [btn addTarget:view1.superview action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            UILabel*titleLabel;
            if (i<4)
            {
                titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+i*80, 85, 44, 25)];
            }else
            {
                titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+(i-4)*80, 165, 44, 25)];
            }
            
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.text = titleArray[i];
            titleLabel.tag = 1100+i;
            titleLabel.font = [UIFont systemFontOfSize:11];
            [view addSubview:titleLabel];
        }
        
        UILabel*line = [[UILabel alloc]initWithFrame:CGRectMake(0, 110, SCREENWIDTH-10, 1)];
        line.backgroundColor = [UIColor grayColor];
        [view addSubview:line];
        
        UIButton*cancel  =[UIButton buttonWithType:UIButtonTypeCustom];
        cancel.frame = CGRectMake(0, 190, SCREENWIDTH, 30);
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancel addTarget:view1.superview action:@selector(cancel1) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:cancel];
        
        UIView*view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        view2.backgroundColor= [UIColor blackColor];
        view2.alpha = 0.5;
        UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:view1 action:@selector(cancel1)];
        [view2 addGestureRecognizer:tap];
        
        [view1 addSubview:view2];
        [view1 addSubview:view];
        
        UILabel*line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 190, SCREENWIDTH-10, 3)];
        line1.backgroundColor = [UIColor lightGrayColor];
        [view addSubview:line1];
        
        [WbApi getWbApi];
    }
    view1.tag = 999;
    return view1;
}
-(void)cancel1
{
    [self removeFromSuperview];
}

-(void)btnAction:(UIButton*)btn
{
    UILabel*label = (UILabel*)[self viewWithTag:btn.tag+100];
    NSNotification *notification = [NSNotification notificationWithName:@"shareKind" object:self userInfo:@{@"shareKind":label.text,@"url":[NSString stringWithFormat:@"%@",webview.request.URL],}];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    
    AppDelegate*appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([label.text isEqualToString:@"新浪"])
    {
        NSUserDefaults*user = [NSUserDefaults standardUserDefaults];
        if ([user objectForKey:@"SinaToken"])
        {
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
            params=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",webview.request.URL],@"status",nil];
            //            }
            
            [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"SinaToken"] url:url httpMethod:@"POST" params:params delegate:appdelegate withTag:@"1000"];
        }else
        {
            WBAuthorizeRequest *request = [WBAuthorizeRequest request];
            request.redirectURI = kRedirectURI;
            request.scope = @"all";
            [WeiboSDK sendRequest:request];
        }
    }else if ([label.text isEqualToString:@"腾讯微博"])
    {
        NSUserDefaults*user = [NSUserDefaults standardUserDefaults];
        if ([user objectForKey:@"TencentToken"])
        {
//            if ([[WbApi getWbApi]isAuthValid])
//            {
//                NSLog(@"dadsfdgth");
//            }
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"json",@"format",
                                                                                      [NSString stringWithFormat:@"%@89",webview.request.URL], @"content",
                                                                                      nil];
            [[WbApi getWbApi] requestWithParams:params apiName:@"t/add" httpMethod:@"POST" delegate:appdelegate];
            [JDStatusBarNotification showWithStatus:@"正在努力发送中..." styleName:JDStatusBarStyleWarning];
            [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];

        }else
        {
            [[WbApi getWbApi] loginWithDelegate:appdelegate andRootController:appdelegate.window.rootViewController];
            
        }
    
    }else if ([label.text isEqualToString:@"微信好友"])
    {
        
    }else if ([label.text isEqualToString:@"朋友圈"])
    {
        
    }else if ([label.text isEqualToString:@"收藏"])
    {
        
    }else if ([label.text isEqualToString:@"查看收藏"])
    {
        
    }else if ([label.text isEqualToString:@"复制链接"])
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [NSString stringWithFormat:@"%@",webview.request.URL];
        NSLog(@"%@",pasteboard.string);
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"复制链接成功。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
    [self cancel1];
}
//下面方法为腾讯微博回调方法
-(void)DidAuthFinished:(WeiboApi *)wbobj
{
    [JDStatusBarNotification showWithStatus:@"正在努力发送中..." styleName:JDStatusBarStyleWarning];
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"已登陆" forKey:@"腾讯登陆状态"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
//    NSUserDefaults*user = [NSUserDefaults standardUserDefaults];
//    [user setObject:wbobj forKey:@"TencentToken"];
//    [user setObject:wbobj.openid forKey:@"TencentOpenID"];
//    [user synchronize];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"json",@"format",[NSString stringWithFormat:@"%@",webview.request.URL], @"content",nil];
    [wbobj requestWithParams:params apiName:@"t/add" httpMethod:@"POST" delegate:self];
    
}
-(void)didReceiveRawData:(NSData *)data reqNo:(int)reqno
{
//        NSLog(@"2132");
    [JDStatusBarNotification showWithStatus:@"发送成功" dismissAfter:1 styleName:@"JDStatusBarStyleSuccess"];
}

-(void)didFailWithError:(NSError *)error reqNo:(int)reqno
{
    NSLog(@"%@",error);
}
+(UIView*)shareCardView
{
    UIView*view;
    return view;
}
@end
