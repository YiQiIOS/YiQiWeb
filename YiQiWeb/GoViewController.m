//
//  GoViewController.m
//  YiQiWeb
//
//  Created by Wendy on 14/11/21.
//  Copyright (c) 2014年 Wendy. All rights reserved.
//

#import "GoViewController.h"
#import "ShareSheet.h"
#import "ShareViewController.h"

@interface GoViewController ()

@end

@implementation GoViewController{
    Collection *item;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIButton*btnback = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 40, 22) backgroundImage:nil title:@"返回" target:self action:@selector(back)];
    [btnback setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:btnback];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIWebView*webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height)];
    webview.tag = 1000;
    webview.delegate= self;
    NSURLRequest*request = [[NSURLRequest alloc]initWithURL:[[NSURL alloc] initWithString:self.cUrl] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:30];
    [webview loadRequest:request];
    [self.view addSubview:webview];
    
    UIButton*btnMore = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 40, 22) backgroundImage:nil title:@"更多" target:self action:@selector(more)];
    [btnMore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnMore.alpha = 0.4;
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:btnMore];
    rightItem.tag = 1100;
    [rightItem setEnabled:NO];
    self.navigationItem.rightBarButtonItem= rightItem;
}

//webview加载结束调用的代理
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    UIBarButtonItem*moreItem = self.navigationItem.rightBarButtonItem;
    UIButton*btn = (UIButton*)moreItem.customView;
    btn.alpha = 1;
    [moreItem setEnabled:YES];
    //    NSLog(@"1213");
    if (webView.canGoBack)
    {
        //        NSLog(@"1213323");
        UIButton*btnback = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 40, 22) backgroundImage:nil title:@"返回" target:self action:@selector(back)];
        [btnback setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:btnback];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    UIActivityIndicatorView*indicator = (UIActivityIndicatorView*)[self.view viewWithTag:1001];
    [indicator stopAnimating];
    UILabel*label = (UILabel*)[self.view viewWithTag:1002];
    [label removeFromSuperview];
    
    //显示标题
    [webView stringByEvaluatingJavaScriptFromString:@"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function getTitle() { "
     "var field = document.getElementsByTagName('p');"
     "for (var i=0;i <field.length; i++) { if (field[i].className =='top_title'){ return field[i].innerHTML;}};"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    NSString *showTitle = [webView stringByEvaluatingJavaScriptFromString:@"getTitle();"];
    if (showTitle.length == 0) {
        showTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    self.navigationItem.title = showTitle;
    [webView stringByEvaluatingJavaScriptFromString:@"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function getFirstImage() { "
     "var imgs = document.getElementsByTagName('img');"
     " return imgs[0].src;"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    NSString *imgUrl = [webView stringByEvaluatingJavaScriptFromString:@"getFirstImage();"];
    if (imgUrl.length > 0) {
        //获取网页中第一张image
        item.imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
    }
    else{
         //如果网页没有图片，就截图
        
        CGRect r = [UIScreen mainScreen].applicationFrame;
        r.origin.y = r.origin.y + 44 ;
        UIGraphicsBeginImageContext(self.view.frame.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        UIRectClip(r);
        [self.view.layer renderInContext:context];
        UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
        item.imgData = UIImageJPEGRepresentation(theImage,1.0);
        UIGraphicsEndImageContext();
        
    }
    
    item.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    item.url = webView.request.URL.absoluteString;
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
    UIBarButtonItem*moreItem = self.navigationItem.rightBarButtonItem;
    UIButton*btn = (UIButton*)moreItem.customView;
    btn.alpha = 0.4;
    [moreItem setEnabled:NO];
    self.title =@"";
    
}
//返回按钮触发事件
-(void)back
{
    NSLog(@"31");
    UIWebView*webView = (UIWebView*)[self.view viewWithTag:1000];
    if (webView.canGoBack)
    {
        [webView goBack];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//更多按钮触发事件
-(void)more
{
    ShareSheet*shareView = [ShareSheet shareWeiboView];
    UIWebView*webView = (UIWebView*)[self.view viewWithTag:1000];
    shareView.webview = webView;
    shareView.item = item;
    [self.navigationController.view addSubview:shareView];
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
