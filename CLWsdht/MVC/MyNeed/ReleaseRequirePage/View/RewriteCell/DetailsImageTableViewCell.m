//
//  DetailsImageTableViewCell.m
//  CLWsdht
//
//  Created by 关宇琼 on 16/4/16.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "DetailsImageTableViewCell.h"
#import "BaseHeader.h"
#import "PlaceHolderTextView.h"


@interface DetailsImageTableViewCell () <UITextViewDelegate> {
    id __block observeroperation;
    id __block observerupImage;
    id __block removeNoti;
}

@property (strong, nonatomic) PlaceHolderTextView *detailsTV;

@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UIButton *chooseImg;

@end


@implementation DetailsImageTableViewCell

- (void)removeNoti {
    [kNotiCenter removeObserver:observerupImage];
    [kNotiCenter removeObserver:observeroperation];
    [kNotiCenter removeObserver:removeNoti];
}


- (IBAction)addImageCenter:(UIButton *)sender {
    [kNotiCenter postNotificationName:@"viewoperation" object:@"operation" userInfo:@{@"taptag":@(sender.tag)}];
    [self.detailsTV resignFirstResponder];
}


- (PlaceHolderTextView *)detailsTV {
    if (!_detailsTV) {
        _detailsTV = [[PlaceHolderTextView alloc] init];
        _detailsTV.backgroundColor = [UIColor colorWithRed: 240 / 255.0  green:240 / 255.0 blue:240 /255.0 alpha:1.0f];
        _detailsTV.tag = 571;
        self.detailsTV.layer.cornerRadius = 20;
        self.detailsTV.layer.masksToBounds = YES;
        self.detailsTV.delegate = self;
        _detailsTV.font = [UIFont systemFontOfSize:13];
        _detailsTV.layer.cornerRadius = 15;
        _detailsTV.layer.masksToBounds = YES;
        [self.contentView addSubview:_detailsTV];
        _detailsTV.placeholder = @"请您添加具体描述";
        [_detailsTV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(8);
            make.left.equalTo(self.contentView).offset(8);
            make.right.equalTo(_chooseImg.mas_left).offset(-8);
            make.bottom.equalTo(self.contentView).offset(-8);
        }];
    }
    return _detailsTV;
}



- (void)noti {
    WS(weakSelf);
    removeNoti = [kNotiCenter addObserverForName:@"removeNoti" object:@"detailsCell" queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [self removeNoti];
    }];
    observerupImage = [kNotiCenter addObserverForName:@"upImage" object:@"image" queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        weakSelf.img.image = note.userInfo[@"image"];
        [kNotiCenter postNotificationName:@"sureoperation" object:@"sure" userInfo:@{@"viewtag":@(weakSelf.img.tag),@"content":note.userInfo[@"image"]}];
    }];
    observeroperation = [kNotiCenter addObserverForName:@"sureoperation" object:@"sure" queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        switch ([note.userInfo[@"viewtag"] integerValue]) {
            case 570:
                [kNotiCenter postNotificationName:@"sureoperation" object:@"sure" userInfo:@{@"viewtag":@(weakSelf.detailsTV.tag),@"content":self.detailsTV.text}];
                break;
        }
    }];
}








- (void)textViewDidEndEditing:(UITextView *)textView {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)awakeFromNib {
    [self noti];
    [self detailsTV];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
