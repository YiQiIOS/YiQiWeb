//
//  CollectionsViewController.h
//  YiQiWeb
//
//  Created by Wendy on 14/11/20.
//  Copyright (c) 2014年 Wendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableViewList;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;


@end
