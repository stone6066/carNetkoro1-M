//
//  StartView.m
//  StartView
//
//  Created by yang on 16/3/19.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "StartView.h"
#import "BaseHeader.h"

#define kSpace 5
#define kStartWidth 20
#define kStartHeight 20

@implementation StartView


- (void)setRating:(NSInteger)rating {
    for (int i = 0;  i < rating; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.width.height.equalTo(@(kStartWidth));
            make.left.equalTo(self).offset((kStartWidth + kSpace) * i);
        }];
        imageView.image = [UIImage imageNamed:@"rating"];
    }
}

@end
