//
//  RequireListTableViewCell.m
//  MFSC
//
//  Created by mfwl on 16/4/18.
//  Copyright © 2016年 mfwl. All rights reserved.
//

#import "RequireListTableViewCell.h"
#import "BaseHeader.h"
#import "BaseModel.h"

@interface RequireListTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *type;
@property (strong, nonatomic) IBOutlet UILabel *detailsType;
@property (strong, nonatomic) IBOutlet UIImageView *signImgV;
@property (strong, nonatomic) IBOutlet UILabel *province;
@property (strong, nonatomic) IBOutlet UILabel *count;
@property (strong, nonatomic) IBOutlet UILabel *other;

@end


@implementation RequireListTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    [_title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(10);
        make.height.equalTo(@20);
        make.right.equalTo(_type.mas_left).offset(-10);
    }];
    _other.layer.cornerRadius = 4;
    _other.layer.masksToBounds = YES;
    [_other mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(_other.text.length * 13 + 5, 20));
    }];
    [_type mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(_other.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(_type.text.length * 13 + 5, 20));
    }];
    [_detailsType mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(_title.mas_bottom).offset(8);
        make.height.equalTo(@20);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    [_signImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.equalTo(self.detailsType.mas_bottom).offset(8);
        make.left.equalTo(self.contentView).offset(10);
    }];
    [_province mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(_province.text.length * 13 + 5, 20));
        make.top.equalTo(self.detailsType.mas_bottom).offset(8);
        make.left.equalTo(self.signImgV.mas_right);
    }];
    [_count mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailsType.mas_bottom).offset(8);
        make.size.mas_equalTo(CGSizeMake(_count.text.length * 13, 20));
        make.right.equalTo(self.contentView).offset(-10);
    }];
}


- (void)setModel:(BaseModel *)model {
    [super model];
    _count.text = [NSString stringWithFormat:@"数量%ld", model.Cnt];
    _title.text = model.Title;
    _type.text = model.CarBrandName;
    _other.text = @"待选";
    _detailsType.text = model.CarModelName;
    _province.text = model.ProvincialName;
//    NSLog(@"%@",model.Mobile);
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
