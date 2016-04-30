//
//  RequireListModel.h
//  CLWsdht
//
//  Created by mfwl on 16/4/18.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "BaseModel.h"

@interface RequireListModel : BaseModel

@property (nonatomic, copy) NSString *AddDate;
@property (nonatomic, copy) NSString *CarBrandId;
@property (nonatomic, copy) NSString *CarBrandName;
@property (nonatomic, copy) NSString *CarModelId;
@property (nonatomic, copy) NSString *CarModelName;

@property (nonatomic ,copy) NSString *CityId;
@property (nonatomic ,copy) NSString *CityName;
@property (nonatomic ,assign) NSInteger Cnt;
@property (nonatomic ,copy) NSString *Description;
@property (nonatomic ,assign) NSInteger *Enable;
@property (nonatomic ,copy) NSString *EndDate;
@property (nonatomic ,copy) NSString *Id;
@property (nonatomic ,copy)  NSString *Img;
@property (nonatomic ,copy) NSString *PartsTypeId;
@property (nonatomic ,copy) NSString *PartsUseForId;
@property (nonatomic ,copy) NSString *PartsUseForName;

@property (nonatomic ,copy) NSString *ProvincialId;
@property (nonatomic ,assign) NSInteger Displacement;
@property (nonatomic ,copy) NSString *ProvincialName;
@property (nonatomic ,copy) NSString *Reason;
@property (nonatomic ,copy) NSString *RespondId;
@property (nonatomic ,assign) NSInteger State;
@property (nonatomic ,copy) NSString *Title;

@property (nonatomic ,copy) NSString *Url;
@property (nonatomic ,assign) NSInteger Year;
@property (nonatomic ,copy) NSString *UsrName;
@property (nonatomic ,assign) NSInteger Views;
@property (nonatomic ,copy) NSString *UsrId;
@property (nonatomic ,assign) NSInteger Mobile;

@end
