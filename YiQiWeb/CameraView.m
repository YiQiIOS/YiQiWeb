//
//  CameraView.m
//  YiQiWeb
//
//  Created by BK on 14/11/25.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import "CameraView.h"
#import "ReminderView.h"
@interface CameraView ()

@end

@implementation CameraView
-(void)dealloc
{
    UIWebView*webView = (UIWebView*)[self.view viewWithTag:1000];
    webView.delegate = nil;
    webView = nil;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor  = [UIColor grayColor];
    self.title = @"扫一扫";
    
    UIButton*btnCancel = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 40, 22) backgroundImage:nil title:@"返回" target:self action:@selector(backAction)];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:btnCancel];
    self.navigationItem.leftBarButtonItem= leftItem;
    
    UIButton*btnCamera = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 40, 22) backgroundImage:nil title:@"相册" target:self action:@selector(cameraAction)];
    [btnCamera setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:btnCamera];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 100, SCREENWIDTH-20, SCREENWIDTH-20)];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(50, 110, SCREENWIDTH-100, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
}
//调用相册
-(void)cameraAction
{
    [_session stopRunning];
    
    ZBarReaderController *reader = [ZBarReaderController new];
    reader.allowsEditing = NO;
    reader.showsHelpOnFail = NO;
    reader.readerDelegate = self;
    reader.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:reader animated:YES completion:nil];
}
//打开相册之后选择方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString*mediaType=[info valueForKey:UIImagePickerControllerMediaType];
    if ([mediaType hasSuffix:@"image"]) {//如果有image后缀
        id image=[info valueForKey:ZBarReaderControllerResults];//当前图片
        //将选择图片存至相册
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        ZBarSymbol*symbol = nil;
        for(symbol in image)
            break;
        NSLog(@"===%@",symbol.data);
        webUrl = symbol.data;
//        NSLog(@"%@",image);
        if ([webUrl hasPrefix:@"http"])
        {
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"您确定前往%@吗？",webUrl] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            [alert show];
        }else
        {
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",webUrl] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            [alert show];
        }
        
        [self dismissViewControllerAnimated:YES completion:^{
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            [_session startRunning];
        }];//弹出相册界面
    }
}
//alerview代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        [_session stopRunning];
        UIWebView*webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64)];
        webview.delegate = self;
        webview.tag = 1000;
        NSURLRequest*request = [[NSURLRequest alloc]initWithURL:[[NSURL alloc] initWithString:webUrl] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:30];
        [webview loadRequest:request];
        [self.view addSubview:webview];
    }else
    {
        [_session startRunning];
    }
}
//webview代理
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"加载失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
    [alert show];
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    ReminderView*view = [ReminderView reminderView];
    [self.view addSubview:view];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
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
    
    ReminderView*view = [ReminderView reminderView];
    [view removeFromSuperview];
}
//扫描动画
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(50, 110+2*num, SCREENWIDTH-100, 2);
        if (2*num == SCREENWIDTH-40) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(50, 110+2*num, SCREENWIDTH-100, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
}
//返回按钮
-(void)backAction
{
    UIWebView*webView = (UIWebView*)[self.view viewWithTag:1000];
    if (webView.canGoBack)
    {
        [webView goBack];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupCamera];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_session stopRunning];
}
- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    NSError*error = nil; 
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (error)
    {
        NSLog(@"没摄像头%@",error);
        return;
    }
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    //     条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code];

    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =CGRectMake(20,110,SCREENWIDTH-40,SCREENWIDTH-40);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    
    
    // Start
    [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    NSLog(@"42");
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    NSLog(@"%@",stringValue);
    [self.navigationController popViewControllerAnimated:YES];
    [timer invalidate];
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
