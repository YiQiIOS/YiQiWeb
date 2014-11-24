//
//  CustomCell.h
//  YiQiWeb
//
//  Created by Wendy on 14/11/20.
//  Copyright (c) 2014年 Wendy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerticallyAlignedLabel.h"

@interface CustomCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblPublishDate;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *lblUrl;
@end
