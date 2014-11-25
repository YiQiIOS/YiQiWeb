//
//  ReminderView.m
//  YiQiWeb
//
//  Created by BK on 14/11/24.
//  Copyright (c) 2014年 BK. All rights reserved.
//

#import "ReminderView.h"

@implementation ReminderView
+(ReminderView *)reminderView
{
    static ReminderView*view;
    if (view==nil)
    {
        view = [[ReminderView alloc]initWithFrame:CGRectMake(0, 0, 100, 80)];
        view.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2);
        view.backgroundColor = [UIColor blackColor];
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        view.alpha = 0.7;
        
        UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        label.center =CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2+20);
        label.text = @"loading";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = [UIColor whiteColor];
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        [view addSubview:label];
        
        UIActivityIndicatorView*indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.center = CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2-20);
        [indicator startAnimating];
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [view addSubview:indicator];
        
    }
    return view;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
