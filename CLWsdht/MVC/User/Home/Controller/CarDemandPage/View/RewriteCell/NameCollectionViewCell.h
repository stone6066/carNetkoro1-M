//
//  NameCollectionViewCell.h
//  CLWsdht
//
//  Created by 关宇琼 on 16/4/27.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PartsClassModel;
@class CarClassModel;

@interface NameCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) CarClassModel *carModel;
@property (nonatomic, strong) PartsClassModel *partModel;

@end
