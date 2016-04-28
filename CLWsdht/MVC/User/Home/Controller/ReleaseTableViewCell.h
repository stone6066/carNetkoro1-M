//
//  ReleaseTableViewCell.h
//  CLWsdht
//
//  Created by koroysta1 on 16/4/25.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReleaseModel.h"

@interface ReleaseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Url;
@property (weak, nonatomic) IBOutlet UILabel *UsrGarageName;
@property (weak, nonatomic) IBOutlet UILabel *PartsUseFor;
@property (weak, nonatomic) IBOutlet UILabel *FuturePrice;
@property (weak, nonatomic) IBOutlet UILabel *Province;
@property (weak, nonatomic) IBOutlet UILabel *CityName;
@property (weak, nonatomic) IBOutlet UILabel *Address;

@property (nonatomic, strong) ReleaseModel *rModel;

- (void)setReleaseOrderWithModel:(ReleaseModel *)model;

@end
