//
//  ReleaseRequireModel.h
//  MFSC
//
//  Created by mfwl on 16/4/15.
//  Copyright © 2016年 mfwl. All rights reserved.
//

#import "BaseModel.h"

@interface ReleaseRequireModel : BaseModel



@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *CarBrandId;
@property (nonatomic, copy) NSString *CarModelId;
@property (nonatomic, copy) NSString *PartsUseForId;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSArray *T_DicCarModel; /* 车辆详细类型 */
@property (nonatomic, strong) NSArray *T_DicPartsType; /* 配件详细类型 */
@property (nonatomic, strong) NSArray *T_DicCity;



@end
