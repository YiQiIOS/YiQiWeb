//
//  KZJShareSheet.m
//  DayDayWeibo
//
//  Created by bk on 14-10-23.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "ShareSheet.h"

@implementation ShareSheet
@synthesize webview,item,imageData;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//自定义弹出框
+(ShareSheet*)shareWeiboView
{
    ShareSheet*view1 = nil;
    
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    if (view1==nil)
    {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.906, 0.906, 0.906, 1 });
        CGColorRef colorref1 = CGColorCreate(colorSpace,(CGFloat[]){ 0.447, 0.473, 0.518, 1 });
        
        view1 =[[ShareSheet alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 380)];
//        view.layer.cornerRadius = 8;
        view.tag=1000;
        
        view.layer.backgroundColor = colorref;
        NSArray*titleArray = [NSArray arrayWithObjects:@"微信好友",@"朋友圈",@"QQ空间",@"腾讯微博",@"新浪微博",@"查看收藏",@"收藏",@"复制链接", nil];
        UILabel*title = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 100, 25)];
        title.text = @"分享";
        [view addSubview:title];
        UILabel*title1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 210, 100, 25)];
        title1.text = @"其他";
        [view addSubview:title1];
        UILabel*line = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, SCREENWIDTH-40, 3)];
        line.backgroundColor = [UIColor lightGrayColor];
        [view addSubview:line];
        
        UILabel*line1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 240, SCREENWIDTH-40, 3)];
        line1.backgroundColor = [UIColor lightGrayColor];
        [view addSubview:line1];
        
        for (int i =0; i<[titleArray count]; i++)
        {
            UIButton*btn;
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            if (i<=4)
            {
                btn.frame = CGRectMake((SCREENWIDTH-260)/2+i%3*100, 55+(int)(i/3)*80, 55, 55);
            }else
            {
                btn.frame = CGRectMake((SCREENWIDTH-260)/2+(i-5)*100, 255, 55, 55);
            }
            btn.tag = 1000+i;
            if (i==4)
            {
                [btn setImage:[UIImage redraw:[UIImage imageNamed:@"more_weibo@2x"] Frame:CGRectMake(0, 0, 55, 55)] forState:UIControlStateNormal];
//                [btn setImage:[UIImage imageNamed:@"more_weibo@2x"] forState:UIControlStateHighlighted];
            }else if (i==3)
            {
                [btn setImage:[UIImage redraw:[UIImage imageNamed:@"icon_default@2x"] Frame:CGRectMake(0, 0, 55, 55)] forState:UIControlStateNormal];
//                [btn setImage:[UIImage imageNamed:@"more_weixin_highlighted@2x"] forState:UIControlStateHighlighted];
            }else if (i==0)
            {
                [btn setImage:[UIImage redraw:[UIImage imageNamed:@"Action_Share@2x"] Frame:CGRectMake(0, 0, 55, 55)] forState:UIControlStateNormal];
//                [btn setImage:[UIImage imageNamed:@"more_circlefriends_highlighted@2x"] forState:UIControlStateHighlighted];
            }else if (i==1)
            {
                [btn setImage:[UIImage redraw:[UIImage imageNamed:@"Action_Moments@2x"] Frame:CGRectMake(0, 0, 55, 55)] forState:UIControlStateNormal];
//                [btn setImage:[UIImage imageNamed:@"icon_default@2x"] forState:UIControlStateHighlighted];
            }
            else if (i==2)
            {
                [btn setImage:[UIImage redraw:[UIImage imageNamed:@"QzoneShare"] Frame:CGRectMake(0, 0, 55, 55)] forState:UIControlStateNormal];
//                [btn setImage:[UIImage imageNamed:@"more_icon_collection1@2x"] forState:UIControlStateHighlighted];
            }else if (i==5)
            {
                [btn setImage:[UIImage redraw:[UIImage imageNamed:@"MoreMyFavorites@2x"] Frame:CGRectMake(0, 0, 55, 55)] forState:UIControlStateNormal];
                //                [btn setImage:[UIImage imageNamed:@"more_icon_collection1@2x"] forState:UIControlStateHighlighted];
            }else if (i==6)
            {
                [btn setImage:[UIImage redraw:[UIImage imageNamed:@"Action_MyFavAdd@2x"] Frame:CGRectMake(0, 0, 55, 55)] forState:UIControlStateNormal];
                //                [btn setImage:[UIImage imageNamed:@"more_icon_collection2@2x"] forState:UIControlStateHighlighted];
                //                [btn setBackgroundImage:[UIImage redraw:[UIImage imageNamed:@"Action_MyFavAdd@2x"] Frame:CGRectMake(0, 0, 150, 150)] forState:UIControlStateNormal];
            }else if (i==7)
            {
                [btn setImage:[UIImage redraw:[UIImage imageNamed:@"Action_Copy@2x"] Frame:CGRectMake(0, 0, 55, 55)] forState:UIControlStateNormal];
//                [btn setImage:[UIImage imageNamed:@"more_icon_link@2x"] forState:UIControlStateHighlighted];
            }
            btn.layer.cornerRadius = 8;
            btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btn.layer.borderWidth = 1;
            btn.layer.masksToBounds = YES;
            [btn addTarget:view1.superview action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            
            UILabel*titleLabel;
            if (i<5)
            {
                 titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREENWIDTH-260)/2+i%3*100, 95+(int)(i/3)*80, 55, 50)];
            }else
            {
                 titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREENWIDTH-260)/2+(i-5)*100, 300, 55, 50)];
            }
            title.numberOfLines = 0;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.text = titleArray[i];
            titleLabel.tag = 1100+i;
            titleLabel.font = [UIFont systemFontOfSize:11];
            [view addSubview:titleLabel];
        }
        UIButton*cancel  =[UIButton buttonWithType:UIButtonTypeCustom];
        cancel.frame = CGRectMake(20, view.frame.size.height-37, SCREENWIDTH-40, 33);
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        
        cancel.layer.backgroundColor = colorref1;
        CGColorRelease(colorref1);
        cancel.layer.cornerRadius = 5;
        
        cancel.titleLabel.textAlignment = NSTextAlignmentCenter;
        [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancel addTarget:view1.superview action:@selector(cancel1) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:cancel];
        
        UIView*view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        view2.backgroundColor= [UIColor blackColor];
        view2.alpha = 0.5;
        UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:view1 action:@selector(cancel1)];
        [view2 addGestureRecognizer:tap];
        
        [view1 addSubview:view2];
        
        
//        UILabel*line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, view.frame.size.height-40, SCREENWIDTH-10, 3)];
//        
//        line1.layer.backgroundColor = colorref;
        CGColorSpaceRelease(colorSpace);
        CGColorRelease(colorref);
//        [view addSubview:line1];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];

        [view1 addSubview:view];
        [UIView commitAnimations];
        //定义uiview动画
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.5];//动画运行时间
        view.frame = CGRectMake(0, SCREENHEIGHT-380, SCREENWIDTH, 380);//结束的位置
        [UIView commitAnimations];//提交动画
    }
    view1.tag = 999;
    return view1;
}
-(void)cancel1
{
    UIView*view = [self viewWithTag:1000];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];//动画运行时间
    view.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 380);//结束的位置
    [UIView commitAnimations];//提交动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
    
}
-(void)btnAction:(UIButton*)btn
{
    
    [webview stringByEvaluatingJavaScriptFromString:@"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function getFirstImage() { "
     "var imgs = document.getElementsByTagName('img');"
     " return imgs[0].src;"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    NSString *imgUrl = [webview stringByEvaluatingJavaScriptFromString:@"getFirstImage();"];
    
    UILabel*label = (UILabel*)[self viewWithTag:btn.tag+100];
    NSNotification *notification = [NSNotification notificationWithName:@"shareKind" object:self userInfo:@{@"shareUrl":webview.request.URL,@"imageUrl":imgUrl,@"imageData":imageData,@"shareKind":label.text,@"content":[NSString stringWithFormat:@"%@%@",[webview stringByEvaluatingJavaScriptFromString:@"document.title"],webview.request.URL],}];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    
//    AppDelegate*appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([label.text isEqualToString:@"新浪微博"])
    {

        [[NSNotificationCenter defaultCenter]postNotificationName:@"pushShare" object:nil userInfo:@{@"shareKind":label.text,@"shareContent":[NSString stringWithFormat:@"%@%@",[webview stringByEvaluatingJavaScriptFromString:@"document.title"],webview.request.URL]}];

    }else if ([label.text isEqualToString:@"腾讯微博"])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"pushShare" object:nil userInfo:@{@"shareKind":label.text,@"shareContent":[NSString stringWithFormat:@"%@%@",[webview stringByEvaluatingJavaScriptFromString:@"document.title"],webview.request.URL]}];
    }else if ([label.text isEqualToString:@"微信好友"])
    {
        
    }else if ([label.text isEqualToString:@"朋友圈"])
    {
        
    }else if ([label.text isEqualToString:@"QQ空间"])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"pushShare" object:nil userInfo:@{@"shareKind":label.text,@"shareContent":[NSString stringWithFormat:@"%@%@",[webview stringByEvaluatingJavaScriptFromString:@"document.title"],webview.request.URL]}];
    }else if ([label.text isEqualToString:@"收藏"])
    {
        NSString *message;
        if (item==nil)
        {
            item = [[Collection alloc]init];
        }
        //        NSLog(@"%@",item.title);
        if (![self isExistsUrl:item.url]) {
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            item.publishDate = [dateFormat stringFromDate:[NSDate date]];
            NSString *insertSql = @"INSERT INTO COLLECTIONINFO(TITLE,URL,IMAGEDATA,COLLECTIONDATE) VALUES(?,?,?,?)";
            SqlServer *sqlDbInstance = [SqlServer sharedInstance];
            [sqlDbInstance openDB];
            
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(sqlDbInstance.db, [insertSql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                sqlite3_bind_text(statement, 1, [item.title UTF8String], -1, NULL);
                sqlite3_bind_text(statement, 2, [item.url UTF8String], -1, NULL);
                sqlite3_bind_blob(statement, 3, [item.imgData bytes], [item.imgData length], NULL);
                sqlite3_bind_text(statement, 4, [item.publishDate UTF8String], -1, NULL);
            }
            
            if (sqlite3_step(statement) == SQLITE_ERROR) {
                message = @"收藏失败！";
            }
            else
            {
                message = @"收藏成功！";
            }
            sqlite3_finalize(statement);
            sqlite3_close(sqlDbInstance.db);
        }
        else
        {
            message = @"已收藏！";
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else if ([label.text isEqualToString:@"查看收藏"])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"pushCollections" object:nil];
    }else if ([label.text isEqualToString:@"复制链接"])
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [NSString stringWithFormat:@"%@",webview.request.URL];
//        NSLog(@"%@",pasteboard.string);
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"复制链接成功。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
    [self cancel1];
}
#pragma 判断是否存在url
-(BOOL) isExistsUrl:(NSString *) url{
    SqlServer *sqlDbInstance = [SqlServer sharedInstance];
    [sqlDbInstance openDB];
    sqlite3_stmt *statement;
    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM COLLECTIONINFO WHERE URL = '%@'",item.url];
    if (sqlite3_prepare_v2(sqlDbInstance.db, [selectSql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            sqlite3_finalize(statement);
            sqlite3_close(sqlDbInstance.db);
            return YES;
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(sqlDbInstance.db);
    return false;
}


+(UIView*)shareCardView
{
    UIView*view;
    return view;
}
@end
