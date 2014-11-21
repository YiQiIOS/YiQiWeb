//
//  EditViewController.m
//  YiQiWeb
//
//  Created by wendy on 14/11/18.
//  Copyright (c) 2014年 wendy. All rights reserved.
//

#import "EditViewController.h"
#import "SqlServer.h"

@interface EditViewController ()

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"编辑";
    
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(goback)];
    self.navigationItem.leftBarButtonItem = cancelButton;

    SqlServer *sqlDBInstance = [SqlServer sharedInstance];
    [sqlDBInstance openDB];
    NSString *selectedSql = [NSString stringWithFormat:@"SELECT * FROM COLLECTIONINFO WHERE ID = %@",_cId];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(sqlDBInstance.db, [selectedSql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            char *c_title = (char *) sqlite3_column_text(statement, 1);
            self.txtTitle.text = [NSString stringWithUTF8String:c_title];
            
            char *c_url = (char *) sqlite3_column_text(statement, 2);
            self.txtUrl.text = [NSString stringWithUTF8String:c_url];
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(sqlDBInstance.db);
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
    NSString *title = [self.txtTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *url = [self.txtUrl.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (title.length == 0 || url.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"标题和网址都不能为空！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        SqlServer *sqlDBInstance = [SqlServer sharedInstance];
        [sqlDBInstance openDB];
        NSString *updateSql = [NSString stringWithFormat:@"UPDATE COLLECTIONINFO SET TITLE = '%@', URL = '%@' WHERE ID = %@",title,url, _cId];
        [sqlDBInstance exec:updateSql];
        [self.navigationController popViewControllerAnimated:YES];
    }
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

-(void) goback{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
