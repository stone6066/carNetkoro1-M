//
//  DetailsTableViewCell.m
//  CLWsdht
//
//  Created by mfwl on 16/4/18.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "DetailsTableViewCell.h"
#import "BaseModel.h"
#import "BaseHeader.h"

#import "RequireListModel.h"



@interface DetailsTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *proName;
@property (strong, nonatomic) IBOutlet UILabel *type;
@property (strong, nonatomic) IBOutlet UILabel *year;
@property (strong, nonatomic) IBOutlet UILabel *from;
@property (strong, nonatomic) IBOutlet UILabel *disp;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *count;
@property (strong, nonatomic) IBOutlet UILabel *endDate;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *phoneNum;
@property (strong, nonatomic) IBOutlet UILabel *descrip;
@property (strong, nonatomic) IBOutlet UIImageView *imgV;

@property (nonatomic, strong) RequireListModel *requireModel;

@end

@implementation DetailsTableViewCell



- (void)setModel:(BaseModel *)model {
    _requireModel = (RequireListModel *)model;
    _title.text = _requireModel.Title;
    _proName.text = _requireModel.ProvincialName;
    _type.text = _requireModel.CarBrandName;
    _year.text = [NSString stringWithFormat:@"%ld", _requireModel.Year];
    _disp.text = [NSString stringWithFormat:@"%ld", _requireModel.Displacement];
    _name.text = _requireModel.PartsUseForName;
    _from.text = _requireModel.Reason;
    _count.text = [NSString stringWithFormat:@"%ld", _requireModel.Cnt];
    _endDate.text = [_requireModel.EndDate substringToIndex:10];
    _address.text = [NSString stringWithFormat:@"%@%@", _requireModel.ProvincialName, _requireModel.CityName];
    _phoneNum.text = [NSString stringWithFormat:@"%ld", _requireModel.Mobile];
    _descrip.text = _requireModel.Description;
    [_imgV sd_setImageWithURL:[NSURL URLWithString:_requireModel.Url]];
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
