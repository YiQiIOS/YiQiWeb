//
//  MainView.m
//  YiQiWeb
//
//  Created by BK on 14/11/18.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import "MainView.h"
#import "CollectionsViewController.h"

@interface MainView ()

@end

@implementation MainView{
    Collection *item;
    NSString* netFlag;
    NSURLRequest*errorRequest;
}
@synthesize webview;
-(void)dealloc
{
    UIWebView*webView = (UIWebView*)[self.view viewWithTag:1000];
    webView.delegate = nil;
    webView = nil;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.title = @"亿启酷动";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIColor colorWithRed:1 green:1 blue:1 alpha:1], NSForegroundColorAttributeName,
                                                                   nil];
    
    // Do any additional setup after loading the view from its nib.
    webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height)];
    webview.tag = 1000;
    webview.delegate= self;
    NSURLRequest*request = [[NSURLRequest alloc]initWithURL:[[NSURL alloc] initWithString:@"http://17ll.com"] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:30];
    errorRequest = [[NSURLRequest alloc]initWithURL:[[NSURL alloc] initWithString:@"http://17ll.com"] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:30];
    [webview loadRequest:request];
    [self.view addSubview:webview];
    
    UIButton*btnMore = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 40, 22) backgroundImage:nil title:@"更多" target:self action:@selector(more)];
    [btnMore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnMore.alpha = 0.4;
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:btnMore];
    rightItem.tag = 1100;
    [rightItem setEnabled:NO];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    item = [[Collection alloc] init];
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"pushCollections" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushCollections) name:@"pushCollections" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"pushShare" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushShare:) name:@"pushShare" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"camera" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(camera) name:@"camera" object:nil];
}
//网络变化
-(void)networkChange:(NSNotification*)notification
{
    Reachability*reachability =(Reachability*)[notification object];

//        NSLog(@"%u,%u",[reachability currentReachabilityStatus],[reachability connectionRequired]);

    //生成警示框,网络环境发生变化时弹出
    if ([reachability connectionRequired]==4)
    {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:@"无网络连接，请检查网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        });
    }else
    {
        if (netFlag!=nil&&![netFlag isEqualToString:[NSString stringWithFormat:@"%u",[reachability connectionRequired]]])
        {
            [webview loadRequest:errorRequest];
            UIView*view = (UIView*)[self.view viewWithTag:1003];
            [view removeFromSuperview];
        }
        
    }
    netFlag = [NSString stringWithFormat:@"%u",[reachability connectionRequired]];

}
//扫一扫
-(void)camera
{
    CameraView*camera = [[CameraView alloc]init];
    [self.navigationController pushViewController:camera animated:YES];
}

//收藏界面
-(void)pushCollections
{
    CollectionsViewController *viewController = [[CollectionsViewController alloc] initWithNibName:@"CollectionsViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}
//分享
-(void)pushShare:(NSNotification*)notif
{
    ShareViewController*shareView = [[ShareViewController alloc]init];
    shareView.shareContent = [[notif userInfo]objectForKey:@"shareContent"];
    shareView.shareKind =[[notif userInfo]objectForKey:@"shareKind"];
    
    shareView.imageData = item.imgData;
    [self.navigationController pushViewController:shareView animated:YES];
    
}
//webview加载结束调用的代理
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"%@",webview.request);
    errorRequest = webView.request;
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
    }else
    {
//        self.navigationController.navigationBarHidden = YES;
        self.navigationItem.leftBarButtonItem = nil;
    }
    ReminderView *view = [ReminderView reminderView];
    [view removeFromSuperview];
    
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
//    NSLog(@"%@",item.imgData);
    item.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    item.url = webView.request.URL.absoluteString;
}
//webview加载错误调用的代理
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    ReminderView*view = [ReminderView reminderView];
    [view addSubview:view];
    
}
//webview加载开始调用的代理
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    ReminderView*view = [ReminderView reminderView];
    [self.view addSubview:view];
    
    UIBarButtonItem*moreItem = self.navigationItem.rightBarButtonItem;
    UIButton*btn = (UIButton*)moreItem.customView;
    btn.alpha = 0.4;
    [moreItem setEnabled:NO];
    NSLog(@"====%@",webView.request.URL);
    if (webView.loading)
    {
        self.title = @"";
    }
    
}
//返回按钮触发事件
-(void)back
{
    if (webview.canGoBack)
    {
        [webview goBack];
    }
}
//更多按钮触发事件
-(void)more
{
    ShareSheet*shareView = [ShareSheet shareWeiboView];
    shareView.webview = webview;
    shareView.item = item;
    shareView.imageData = item.imgData;
    //把webview中的键盘回收。
    [webview stringByEvaluatingJavaScriptFromString:@"document.activeElement.blur()"];

    [self.navigationController.view addSubview:shareView];
}
#pragma mark - Navigation Controller Delegate
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    BaseAnimation *animationController;
    SlideAnimation *slideAnimationController = [[SlideAnimation alloc]init];
    animationController = slideAnimationController;
    switch (operation) {
        case UINavigationControllerOperationPush:
            animationController.type = AnimationTypePresent;
            return  animationController;
        case UINavigationControllerOperationPop:
            animationController.type = AnimationTypeDismiss;
            return animationController;
        default: return nil;
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
