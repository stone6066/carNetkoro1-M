//
//  DetailsSureCell.m
//  MFSC
//
//  Created by mfwl on 16/4/15.
//  Copyright © 2016年 mfwl. All rights reserved.
//

#import "DetailsSureCell.h"
#import "BaseHeader.h"


@interface DetailsSureCell ()
@property (strong, nonatomic) IBOutlet UIButton *send;

@end

@implementation DetailsSureCell

- (IBAction)sendNoti:(UIButton *)sender {
    [kNotiCenter postNotificationName:@"sureoperation" object:@"sure" userInfo:@{@"viewtag":@(sender.tag)}];
    
}


- (void)awakeFromNib {
    // Initialization code
    self.send.layer.cornerRadius = 10;
    self.send.layer.masksToBounds = YES;
   
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
