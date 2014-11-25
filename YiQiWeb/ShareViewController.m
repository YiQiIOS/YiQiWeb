//
//  ShareViewController.m
//  YiQiWeb
//
//  Created by BK on 14/11/19.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import "ShareViewController.h"
#import "AppDelegate.h"
@interface ShareViewController ()

@end

@implementation ShareViewController
@synthesize shareContent,shareKind,imageData,imageUrl;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = [NSString stringWithFormat:@"分享到%@",shareKind];
    UIButton*btnCancel = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 40, 22) backgroundImage:nil title:@"取消" target:self action:@selector(back)];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:btnCancel];
    self.navigationItem.leftBarButtonItem= leftItem;
    
    UIButton*btnShare = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 40, 22) backgroundImage:nil title:@"发送" target:self action:@selector(send)];
    [btnShare setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:btnShare];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    UITextView*textView = [[UITextView alloc]initWithFrame:CGRectMake(5, 80, SCREENWIDTH-10, SCREENHEIGHT-220-64)];
    textView.tag = 1000;
    self.automaticallyAdjustsScrollViewInsets = NO;
    textView.text = shareContent;
    textView.layer.borderWidth = 1;
    textView.delegate = self;
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textView.font = [UIFont systemFontOfSize:17];
    [textView becomeFirstResponder];
    [self.view addSubview:textView];
    
    //测试文字高度
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:textView.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGRect rect = [textView.text boundingRectWithSize:CGSizeMake(textView.frame.size.width-10, textView.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    NSLog(@"%f",rect.size.height);
    textView.frame = CGRectMake(5, 80, SCREENWIDTH-10, rect.size.height+120);
    
    UIImageView*imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, rect.size.height+20, 90, 90)];
    imageView.tag = 1100;
    imageView.image = [UIImage imageWithData:imageData];
    [textView addSubview:imageView];
    
    AppDelegate*appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    permissions = [NSArray arrayWithObjects:
                     kOPEN_PERMISSION_GET_USER_INFO,
                     kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                     kOPEN_PERMISSION_ADD_ALBUM,
                     kOPEN_PERMISSION_ADD_IDOL,
                     kOPEN_PERMISSION_ADD_ONE_BLOG,
                     kOPEN_PERMISSION_ADD_PIC_T,
                     kOPEN_PERMISSION_ADD_SHARE,
                     kOPEN_PERMISSION_ADD_TOPIC,
                     kOPEN_PERMISSION_CHECK_PAGE_FANS,
                     kOPEN_PERMISSION_DEL_IDOL,
                     kOPEN_PERMISSION_DEL_T,
                     kOPEN_PERMISSION_GET_FANSLIST,
                     kOPEN_PERMISSION_GET_IDOLLIST,
                     kOPEN_PERMISSION_GET_INFO,
                     kOPEN_PERMISSION_GET_OTHER_INFO,
                     kOPEN_PERMISSION_GET_REPOST_LIST,
                     kOPEN_PERMISSION_LIST_ALBUM,
                     kOPEN_PERMISSION_UPLOAD_PIC,
                     kOPEN_PERMISSION_GET_VIP_INFO,
                     kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                     kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
                     kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                     nil];
    
    NSString *appid = @"222222";//1103511856
    tencentOAuth = [[TencentOAuth alloc] initWithAppId:appid
                                            andDelegate:appdelegate];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"sendSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back1) name:@"sendSuccess" object:nil];
    
}
-(void)textViewDidChange:(UITextView *)textView
{
    
    UIImageView*image = (UIImageView*)[textView viewWithTag:1100];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:textView.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGRect rect = [textView.text boundingRectWithSize:CGSizeMake(textView.frame.size.width-10, textView.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    textView.frame = CGRectMake(5, 80, SCREENWIDTH-10, rect.size.height+120);
    image.frame = CGRectMake(10, rect.size.height+20, 90, 90);
    
}

//取消返回按钮
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)back1
{
    [JDStatusBarNotification showWithStatus:@"发送成功" dismissAfter:1 styleName:@"JDStatusBarStyleSuccess"];
    [self.navigationController popViewControllerAnimated:YES];
}
//发送按钮
-(void)send
{
    UITextView*textView = (UITextView*)[self.view viewWithTag:1000];
    [textView resignFirstResponder];
    AppDelegate*appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([shareKind isEqualToString:@"新浪微博"])
    {
        NSUserDefaults*user = [NSUserDefaults standardUserDefaults];
        if ([user objectForKey:@"SinaToken"])
        {
            [JDStatusBarNotification showWithStatus:@"正在努力发送中..." styleName:JDStatusBarStyleWarning];
            [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
            NSString *url;
            NSDictionary*params;
            url = @"https://upload.api.weibo.com/2/statuses/upload.json";
            params=@{@"status":shareContent,@"pic":imageData};
            [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"SinaToken"] url:url httpMethod:@"POST" params:params delegate:appdelegate withTag:@"1000"];
        }else
        {
            WBAuthorizeRequest *request = [WBAuthorizeRequest request];
            request.redirectURI = kRedirectURI;
            request.scope = @"all";
            [WeiboSDK sendRequest:request];
        }
    }else if ([shareKind isEqualToString:@"腾讯微博"])
    {
        if ([[WbApi getWbApi]getToken].accessToken)
        {
            [JDStatusBarNotification showWithStatus:@"正在努力发送中..." styleName:JDStatusBarStyleWarning];
            [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
        }
        [[WbApi getWbApi] loginWithDelegate:appdelegate andRootController:appdelegate.window.rootViewController];
    }else if ([shareKind isEqualToString:@"QQ空间"])
    {
        [tencentOAuth authorize:permissions];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
