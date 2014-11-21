//
//  CollectionListViewController.m
//  YiQiWeb
//
//  Created by wendy on 14/11/18.
//  Copyright (c) 2014年 wendy. All rights reserved.
//

#import "CollectionListViewController.h"
#import "SqlServer.h"
#import "Collection.h"
#import "EditViewController.h"
#import "KZJShareSheet.h"

@interface CollectionListViewController ()

@end

@implementation CollectionListViewController{
    NSMutableArray *collectionList;
    UIWebView *webview;
    Collection *collection;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    collectionList = [[NSMutableArray alloc] init];
    
    self.navigationItem.title = @"收藏列表";
    
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goback)];
    self.navigationItem.leftBarButtonItem = backbutton;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}


//加载数据
-(void) loadData{
    [collectionList removeAllObjects];
    SqlServer *sqlDbInstance = [SqlServer sharedInstance];
    [sqlDbInstance openDB];
    NSString *selectAllSql = @"SELECT * FROM COLLECTIONINFO";
    sqlite3_stmt *statement;

    if (sqlite3_prepare_v2(sqlDbInstance.db, [selectAllSql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            Collection *item = [[Collection alloc] init];
            char *c_id = (char *)sqlite3_column_text(statement, 0);
            item.cId = [NSString stringWithUTF8String:c_id];
            
            char *c_title = (char *) sqlite3_column_text(statement, 1);
            item.title = [NSString stringWithUTF8String:c_title];
            
            char *c_url = (char *) sqlite3_column_text(statement, 2);
            item.url = [NSString stringWithUTF8String:c_url];
            
            [collectionList addObject:item];
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(sqlDbInstance.db);
    [self.tableViewList reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return collectionList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CELLINDENTIFIER = @"CollectionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLINDENTIFIER];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELLINDENTIFIER];
    }
    
    Collection *info = [collectionList objectAtIndex:indexPath.row];
    cell.textLabel.text = info.title;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.detailTextLabel.text = info.url;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    editButton.frame = CGRectMake(0, 0, 100, 25);
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(gotoEditView:) forControlEvents:UIControlEventTouchUpInside];
    editButton.tag = indexPath.row;
    cell.accessoryView = editButton;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Collection *item = [collectionList objectAtIndex:indexPath.row];
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM COLLECTIONINFO WHERE ID = %@",item.cId];
        SqlServer *sqlDbInstance = [SqlServer sharedInstance];
        [sqlDbInstance openDB];
        if (sqlite3_exec(sqlDbInstance.db, [deleteSql UTF8String], NULL, NULL, nil) == SQLITE_OK) {
            [collectionList removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        sqlite3_close(sqlDbInstance.db);
    }
}



#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Collection *info = [collectionList objectAtIndex:indexPath.row];
    webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height)];
    NSURLRequest  *request = [[NSURLRequest alloc]initWithURL:[[NSURL alloc] initWithString:info.url] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:30];
    webview.tag = 1000;
    webview.delegate = self;
    [webview loadRequest:request];
    [self.view addSubview:webview];
    UIBarButtonItem *morebutton = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStyleBordered target:self action:@selector(more)];
    self.navigationItem.rightBarButtonItem = morebutton;
}

-(void)gotoEditView:(id) sender{
    EditViewController *viewController = [[EditViewController alloc] initWithNibName:@"EditViewController" bundle:nil];
    UIButton *edit = (UIButton *)sender;
    Collection *info = [collectionList objectAtIndex:edit.tag];
    viewController.cId = info.cId;
    [self.navigationController pushViewController:viewController animated:YES];
}

//返回按钮事件
-(void) goback{
    [self.navigationController popViewControllerAnimated:YES];
}

//更多按钮事件
-(void) more{
    KZJShareSheet*shareView = [KZJShareSheet shareWeiboView];
    UIWebView*webView = (UIWebView*)[self.view viewWithTag:1000];
    shareView.webview = webView;
//    shareView.item = item;
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.navigationController.view addSubview:shareView];
}

//webview加载结束调用的代理
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
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
    
    collection.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    collection.url = webView.request.URL.absoluteString;
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
