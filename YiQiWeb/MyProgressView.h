//
//  MyProgressView.h
//  YiQiWeb
//
//  Created by wendy on 14/11/24.
//  Copyright (c) 2014年 wendy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyProgressView : UIView{
    
    UIActivityIndicatorView* indicator;
    
    UILabel* label;
    
    BOOL visible,blocked;
    
    UIView* maskView;
    
    CGRect rectHud,rectSuper,rectOrigin;//外壳区域、父视图区域
    
    UIView* viewHud;//外壳
    
}

@property (assign) BOOL visible;

-(id)initWithFrame:(CGRect)frame superView:(UIView*)superView;

-(void)show:(BOOL)block;// block:是否阻塞父视图

-(void)hide;

-(void)setMessage:(NSString*)newMsg;

-(void)alignToCenter;

@end