//
//  EditViewController.m
//  YiQiWeb
//
//  Created by wendy on 14/11/18.
//  Copyright (c) 2014年 wendy. All rights reserved.
//

#import "EditViewController.h"
#import "SqlServer.h"
#import "Collection.h"
#import "MyProgressView.h"

@interface EditViewController ()

@end

@implementation EditViewController{
    Collection *item;
    BOOL isFlag;
    BOOL isOk;
    MyProgressView *indicator;
    UIBarButtonItem *editButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"添加收藏";
    
    
    editButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(done)];
    editButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = editButton;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goback)];
    cancelButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = cancelButton;

//    SqlServer *sqlDBInstance = [SqlServer sharedInstance];
//    [sqlDBInstance openDB];
//    NSString *selectedSql = [NSString stringWithFormat:@"SELECT * FROM COLLECTIONINFO WHERE ID = %@",_cId];
//    sqlite3_stmt *statement;
//    if (sqlite3_prepare_v2(sqlDBInstance.db, [selectedSql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
//        if (sqlite3_step(statement) == SQLITE_ROW) {
//            char *c_title = (char *) sqlite3_column_text(statement, 1);
//            self.txtTitle.text = [NSString stringWithUTF8String:c_title];
//            
//            char *c_url = (char *) sqlite3_column_text(statement, 2);
//            self.txtUrl.text = [NSString stringWithUTF8String:c_url];
//        }
//        sqlite3_finalize(statement);
//    }
//    sqlite3_close(sqlDBInstance.db);
    
    item = [[Collection alloc] init];
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


- (IBAction)done{
    editButton.enabled = NO;
    item.title = [self.txtTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *url = [self.txtUrl.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (url.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入网址！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        NSRange rang = [url rangeOfString:@"http://"];
        if (rang.length == 0) {
            url = [NSString stringWithFormat:@"http://%@",url];
        }

        if ([self isReguex:url]) {
            UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height)];
            webView.delegate = self;
            NSURLRequest*request = [[NSURLRequest alloc]initWithURL:[[NSURL alloc] initWithString:url] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:10];
            [webView loadRequest:request];
            
            
            [self.view addSubview:webView];
            webView.hidden = YES;
            isFlag = NO;
            indicator = [[MyProgressView alloc]initWithFrame:CGRectMake(0, 0, 120, 120) superView:self.view];
            [indicator alignToCenter];
            [indicator setMessage:@"处理中..."];
            if (indicator.visible == NO) {
                [indicator show:YES];
            }

            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入的网址格式有误！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            editButton.enabled = YES;
        }
        
        
//        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(BOOL) isReguex:(NSString *)url{
    //用正则表达式匹配url
    NSError *error;
    NSString *regulaStr = @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:url options:0 range:NSMakeRange(0, [url length])];
    
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        item.url = [url substringWithRange:match.range];
        return true;
    }
    return false;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [indicator show:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入有效的网址！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    isOk = NO;
    [indicator hide];
    editButton.enabled = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [indicator hide];
    editButton.enabled = YES;
    if (!isFlag) {
        if (item.title.length == 0) {
            item.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        }
        NSLog(@"%@",item.title);
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
//            //如果网页没有图片，就截图
//            CGRect r = [UIScreen mainScreen].applicationFrame;
//            r.origin.y = r.origin.y + 44 ;
//            UIGraphicsBeginImageContext(self.view.frame.size);
//            CGContextRef context = UIGraphicsGetCurrentContext();
//            CGContextSaveGState(context);
//            UIRectClip(r);
//            [self.view.layer renderInContext:context];
//            UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
//            item.imgData = UIImageJPEGRepresentation(theImage,1.0);
//            UIGraphicsEndImageContext();
        }
        //     NSLog(@"imageData=%@",item.imgData);
        NSString *message;
        if (item.title.length > 0) {
            item.url = webView.request.URL.absoluteString;
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
                    isOk = NO;
                }
                else
                {
                    message = @"收藏成功！";
                    isOk = YES;
                }
                sqlite3_finalize(statement);
                sqlite3_close(sqlDbInstance.db);
            }
            else
            {
                message = @"已收藏！";
                isOk = NO;
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            isFlag = YES;
            
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if (isOk) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
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


- (IBAction)title_DidEndOnExit:(id)sender {
    [self.txtUrl becomeFirstResponder];
}

- (IBAction)url_DidEndOnExit:(id)sender {
    [self.txtUrl resignFirstResponder];
    [self done];
}

- (IBAction)touchView:(id)sender {
    [self.txtTitle resignFirstResponder];
    [self.txtUrl resignFirstResponder];
}

//返回按钮事件
-(void) goback{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
