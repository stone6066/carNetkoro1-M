//
//  ReleaseMainOrderViewController.h
//  CLWsdht
//
//  Created by koroysta1 on 16/4/25.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>
#import "ReleaseModel.h"

@interface ReleaseMainOrderViewController : UIViewController

@property (nonatomic, strong) NSDictionary *jpushDict;
@property (nonatomic, copy) NSString *uuid;

- (void)confirmBtn:(ReleaseModel *)rModel;
- (void)comeStoreBtn:(ReleaseModel *)cModel;

@end
