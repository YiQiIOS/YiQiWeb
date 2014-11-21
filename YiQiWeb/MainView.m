//
//  MainView.m
//  YiQiWeb
//
//  Created by BK on 14/11/18.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import "MainView.h"

@interface MainView ()

@end

@implementation MainView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIWebView*webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height)];
    webview.tag = 1000;
    webview.delegate= self;
    NSURLRequest*request = [[NSURLRequest alloc]initWithURL:[[NSURL alloc] initWithString:@"http://17ll.com"] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:30];
    [webview loadRequest:request];
    
    [self.view addSubview:webview];
    
    

    UIButton*btnMore = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 40, 22) backgroundImage:nil title:@"更多" target:self action:@selector(more)];
    [btnMore setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:btnMore];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    
    
    
}
//webview加载结束调用的代理
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"1213");
    if (webView.canGoBack)
    {
        NSLog(@"1213323");
        UIButton*btnback = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 40, 22) backgroundImage:nil title:@"返回" target:self action:@selector(back)];
        [btnback setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:btnback];
        self.navigationItem.leftBarButtonItem = leftItem;
    }else
    {
//        self.navigationController.navigationBarHidden = YES;
        self.navigationItem.leftBarButtonItem = nil;
    }
    UIActivityIndicatorView*indicator = (UIActivityIndicatorView*)[self.view viewWithTag:1001];
    [indicator stopAnimating];
    UILabel*label = (UILabel*)[self.view viewWithTag:1002];
    [label removeFromSuperview];
}
//webview加载错误调用的代理
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"页面加载失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}
//webview加载开始调用的代理
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    UIActivityIndicatorView*indicator = (UIActivityIndicatorView*)[self.view viewWithTag:1001];
    if (indicator==nil)
    {
        indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
        [indicator startAnimating];
        indicator.tag =1001;
        [self.view addSubview:indicator];
    }else
    {
        [indicator startAnimating];
    }
    
    UILabel*label = (UILabel*)[self.view viewWithTag:1002];
    if (label==nil)
    {
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        label.tag = 1002;
        label.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2+30);
        label.text = @"页面加载中...";
        label.textColor = [UIColor blackColor];
        [self.view addSubview:label];
    }else
    {
        [self.view addSubview:label];
    }
    
}
//返回按钮触发事件
-(void)back
{
    UIWebView*webView = (UIWebView*)[self.view viewWithTag:1000];
    if (webView.canGoBack)
    {
        [webView goBack];
    }
}
//更多按钮触发事件
-(void)more
{
    KZJShareSheet*shareView = [KZJShareSheet shareWeiboView];
    UIWebView*webView = (UIWebView*)[self.view viewWithTag:1000];
    shareView.webview = webView;
    [self.view addSubview:shareView];
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
