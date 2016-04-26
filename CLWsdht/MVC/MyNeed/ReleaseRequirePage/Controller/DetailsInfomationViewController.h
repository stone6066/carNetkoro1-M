//
//  DetailsInfomationViewController.h
//  MFSC
//
//  Created by mfwl on 16/4/15.
//  Copyright © 2016年 mfwl. All rights reserved.
//

#import "BaseViewController.h"

@class ReleaseRequireModel;

@interface DetailsInfomationViewController : BaseViewController

@property (nonatomic, strong) ReleaseRequireModel *carModel;
@property (nonatomic, strong) ReleaseRequireModel *detailsCarModel;
@property (nonatomic, strong) ReleaseRequireModel *partsModel;
@property (nonatomic, strong) ReleaseRequireModel *detailsPartsModel;

@end
