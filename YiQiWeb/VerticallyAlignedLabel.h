//
//  VerticallyAlignedLabel.h
//  YiQiWeb
//
//  Created by wendy on 14/11/21.
//  Copyright (c) 2014年 wendy. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum VerticalAlignment {
    VerticalAlignmentTop,
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface VerticallyAlignedLabel : UILabel {
@private
    VerticalAlignment verticalAlignment_;
}

@property (nonatomic, assign) VerticalAlignment verticalAlignment;

@end