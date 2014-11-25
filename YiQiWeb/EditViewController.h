//
//  EditViewController.h
//  YiQiWeb
//
//  Created by wendy on 14/11/18.
//  Copyright (c) 2014年 wendy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditViewController : UIViewController<UIWebViewDelegate,UIAlertViewDelegate>

@property (nonatomic, copy) NSString *cId;

@property (strong, nonatomic) IBOutlet UITextField *txtTitle;
@property (strong, nonatomic) IBOutlet UITextField *txtUrl;

- (IBAction)done;
- (IBAction)title_DidEndOnExit:(id)sender;
- (IBAction)url_DidEndOnExit:(id)sender;
- (IBAction)touchView:(id)sender;
@end
