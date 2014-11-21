//
//  CollectionsViewController.m
//  YiQiWeb
//
//  Created by Wendy on 14/11/20.
//  Copyright (c) 2014年 Wendy. All rights reserved.
//

#import "CollectionsViewController.h"
#import "SqlServer.h"
#import "Collection.h"
#import "CustomCell.h"
#import "EditViewController.h"
#import "GoViewController.h"

@interface CollectionsViewController ()

@end

@implementation CollectionsViewController{
    NSMutableArray *collectionList;
    NSIndexPath *dIndexPath;
    UIWebView *webview;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"收藏列表";
    
    
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(goback)];
    self.navigationItem.leftBarButtonItem = backbutton;
    
    collectionList = [[NSMutableArray alloc] init];
    
    self.tableViewList.tableFooterView = [UIView new];
    
    [self.searchBar setShowsCancelButton:YES animated:YES];
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
            
            char *c_date = (char *) sqlite3_column_text(statement, 3);
            item.publishDate = [NSString stringWithUTF8String:c_date];
            
            int length = sqlite3_column_bytes(statement, 4);
            item.imgData = [NSData dataWithBytes:sqlite3_column_blob(statement, 4) length:length];
            
            [collectionList addObject:item];
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(sqlDbInstance.db);
    [self.tableViewList reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [collectionList count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CustomCell";
    
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil] lastObject];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    Collection *info = [collectionList objectAtIndex:indexPath.row];
    cell.lblTitle.text = info.title;
    cell.lblTitle.font = [UIFont boldSystemFontOfSize:14.0f];
   
    cell.lblUrl.text = info.url;
    cell.lblUrl.numberOfLines = 0;
    cell.lblUrl.font = [UIFont systemFontOfSize:12.0f];
    
    cell.imgView.image=[[UIImage alloc] initWithData:info.imgData];
    
    
    int days = [self getPublishedDays:info.publishDate];
    NSString *message;
    if (days == -1) {
        message = @"今天";
    }
    else if (days == 1){
        message = @"昨天";
    }
    else if (days > 1 && days <= 31 ){
        message = [NSString stringWithFormat:@"%d天前",days];
    }
    else{
        NSRange range = [info.publishDate rangeOfString:@" "];
        message = [info.publishDate substringToIndex:range.location];
    }
    cell.lblPublishDate.text = message;
    cell.lblPublishDate.font = [UIFont systemFontOfSize:12.f];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    //    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    editButton.frame = CGRectMake(0, 0, 30, 25);
    //    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    //    [editButton addTarget:self action:@selector(gotoEditView:) forControlEvents:UIControlEventTouchUpInside];
    //    editButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    //    editButton.tag = indexPath.row;
    //    cell.accessoryView = editButton;
    
    return cell;

}

//获取两个日期相差的天数
-(int) getPublishedDays : (NSString *) inDay{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:inDay];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        return [timeString intValue];
    }
    return -1;

}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [alert show];
        dIndexPath = indexPath;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        Collection *item = [collectionList objectAtIndex:dIndexPath.row];
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM COLLECTIONINFO WHERE ID = %@",item.cId];
        SqlServer *sqlDbInstance = [SqlServer sharedInstance];
        [sqlDbInstance openDB];
        if (sqlite3_exec(sqlDbInstance.db, [deleteSql UTF8String], NULL, NULL, nil) == SQLITE_OK) {
            [collectionList removeObjectAtIndex:dIndexPath.row];
            [self.tableViewList deleteRowsAtIndexPaths:@[dIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        sqlite3_close(sqlDbInstance.db);
    }
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Collection *info = [collectionList objectAtIndex:indexPath.row];
    GoViewController *viewController = [[GoViewController alloc] initWithNibName:@"GoViewController" bundle:nil];
    viewController.cUrl = info.url;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)gotoEditView:(id) sender{
    EditViewController *viewController = [[EditViewController alloc] initWithNibName:@"EditViewController" bundle:nil];
    UIButton *edit = (UIButton *)sender;
    Collection *info = [collectionList objectAtIndex:edit.tag];
    viewController.cId = info.cId;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
    [collectionList removeAllObjects];
    
    SqlServer *sqlServer = [SqlServer sharedInstance];
    [sqlServer openDB];
    sqlite3 *sqlDb = sqlServer.db;
    
    NSString *SQL = [NSString stringWithFormat:@"SELECT * FROM COLLECTIONINFO WHERE TITLE LIKE '%%%@%%'",searchText];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(sqlDb, [SQL UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            Collection *item = [[Collection alloc] init];
            char *c_id = (char *)sqlite3_column_text(statement, 0);
            item.cId = [NSString stringWithUTF8String:c_id];
            
            char *c_title = (char *) sqlite3_column_text(statement, 1);
            item.title = [NSString stringWithUTF8String:c_title];
            
            char *c_url = (char *) sqlite3_column_text(statement, 2);
            item.url = [NSString stringWithUTF8String:c_url];
            
            char *c_date = (char *) sqlite3_column_text(statement, 3);
            item.publishDate = [NSString stringWithUTF8String:c_date];
            
            int length = sqlite3_column_bytes(statement, 4);
            item.imgData = [NSData dataWithBytes:sqlite3_column_blob(statement, 4) length:length];
            
            [collectionList addObject:item];
            
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(sqlDb);
}

#pragma mark -
#pragma mark UISearchBar Delegate Methods
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self filterContentForSearchText:searchText scope:
          [[searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    [self.tableViewList reloadData];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self loadData];
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

//返回按钮事件
-(void) goback{
    [self.navigationController popViewControllerAnimated:YES];
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
