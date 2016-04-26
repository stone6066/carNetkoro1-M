//
//  OrderTableViewCell.m
//  CLWsdht
//
//  Created by koroysta1 on 16/4/12.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "OrderTableViewCell.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"

@implementation OrderTableViewCell


- (void)setOrderWithModel:(GoodModel *)model{
    [_Url sd_setImageWithURL:[NSURL URLWithString:model.Url]];
    [_Name setText:model.Name];
    [_Price setText:[NSString stringWithFormat:@"%@",model.Price]];
    [_Cnt setText:[NSString stringWithFormat:@"X%@",model.Cnt]];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
