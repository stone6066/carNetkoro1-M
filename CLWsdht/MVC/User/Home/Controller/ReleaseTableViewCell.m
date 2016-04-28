//
//  ReleaseTableViewCell.m
//  CLWsdht
//
//  Created by koroysta1 on 16/4/25.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "ReleaseTableViewCell.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "ReleaseMainOrderViewController.h"


@implementation ReleaseTableViewCell

- (void)setReleaseOrderWithModel:(ReleaseModel *)model{
    [_Url sd_setImageWithURL:[NSURL URLWithString:model.Url]];
    [_UsrGarageName setText:model.UsrGarageName];
    [_PartsUseFor setText:model.PartsUseFor];
    [_Province setText:model.Province];
    [_CityName setText:model.CityName];
    [_FuturePrice setText:[NSString stringWithFormat:@"¥%@",model.FuturePrice]];
    [_Address setText:model.Address];
    _rModel = model;
}

- (void)awakeFromNib {
    // Initialization code
}

//确认选择按钮的响应事件
- (IBAction)okButtonClicked:(UIButton *)sender {
    ReleaseMainOrderViewController *releaseMainVC = [[ReleaseMainOrderViewController alloc] init];
    [releaseMainVC confirmBtn:_rModel];
}

//进店看看按钮的响应事件
- (IBAction)comeStoreBtn:(UIButton *)sender {
    ReleaseMainOrderViewController *releaseMVC = [[ReleaseMainOrderViewController alloc] init];
    [releaseMVC comeStoreBtn:_rModel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
