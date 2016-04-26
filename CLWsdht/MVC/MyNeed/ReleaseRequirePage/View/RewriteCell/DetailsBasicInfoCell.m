//
//  DetailsBasicInfoCell.m
//  MFSC
//
//  Created by mfwl on 16/4/15.
//  Copyright © 2016年 mfwl. All rights reserved.
//

#import "DetailsBasicInfoCell.h"
#import "BaseModel.h"
#import "BaseHeader.h"
#import "ReleaseRequireModel.h"
#import "UserInfo.h"

@interface DetailsBasicInfoCell () {
    id __block observeroperation;
    id __block removeNoti;
    BOOL addressState;
    BOOL chooseYearState;
    BOOL endDateState;
    BOOL fromState;
    
}

@property (strong, nonatomic) IBOutlet UILabel *titleLb;
@property (strong, nonatomic) IBOutlet UILabel *chooseYear;
@property (strong, nonatomic) IBOutlet UILabel *fromLb;
@property (strong, nonatomic) IBOutlet UILabel *dateLb;
@property (strong, nonatomic) IBOutlet UILabel *addressLb;


@property (strong, nonatomic) IBOutlet UITextField *displacementTF;
@property (strong, nonatomic) IBOutlet UITextField *countNumTF;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumTF;

@property (nonatomic, copy) NSString *conut;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *disp;


@property (strong, nonatomic) IBOutlet UILabel *partsName;


@property (strong, nonatomic) IBOutlet UIView *yearBV;

@property (strong, nonatomic) IBOutlet UIView *from;

@property (strong, nonatomic) IBOutlet UIView *date;
@property (strong, nonatomic) IBOutlet UIView *address;


@property (nonatomic, copy) NSString *CityId;
@property (nonatomic, copy) NSString *ProvincialId;



@property (nonatomic, strong) NSMutableDictionary *dataDic;

@property (nonatomic, strong) BaseModel *tempModel;
@property (nonatomic, copy) NSString *tempDescription;

@property (nonatomic, strong) UIImage *tempImg;
@property (nonatomic, copy) NSString *tempId;


@end

@implementation DetailsBasicInfoCell





- (void)setModel:(BaseModel *)model {
    [super model];
    _titleLb.text = model.content;
    _partsName.text = model.Name;
    
    _tempModel = model;
  
}

- (void)setYearBV {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    UITapGestureRecognizer *tapo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    UITapGestureRecognizer *tapt = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    UITapGestureRecognizer *tapth = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_yearBV addGestureRecognizer:tap];
    [_from addGestureRecognizer:tapo];
    [_date addGestureRecognizer:tapt];
    [_address addGestureRecognizer:tapth];
}
- (void)tap:(UITapGestureRecognizer *)tap {
    [kNotiCenter postNotificationName:@"viewoperation" object:@"operation" userInfo:@{@"taptag":@(tap.view.tag)}];
}


/* 获取本地时间 */
- (NSString *)getNowTime {
    NSDate *senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    locationString = [NSString stringWithFormat:@"%@ 00:00:00", [locationString substringToIndex:11]];
    return locationString;
}

/* 计算消息时间距离当前时差 */
- (BOOL)getTimeDifferentWith:(NSString *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; /* ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制 */
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    /* 设置时区,这个对于时间的处理有时很重要 */
    NSDate *dateModel = [formatter dateFromString:date]; /* 按照格式设置传入的date时间 */
    NSDate *dateNow = [formatter dateFromString:[self getNowTime]];/* 按照格式设置本地时间 */
    NSString *timeModel = [NSString stringWithFormat:@"%ld", (long)[dateModel timeIntervalSince1970]];/* 计算传入时间的时间戳 */
    NSString *timeNow = [NSString stringWithFormat:@"%ld", (long)[dateNow timeIntervalSince1970]];/* 计算当前时间的时间戳 */
  
    NSInteger time = ([timeModel integerValue] - [timeNow integerValue]);/* 计算时差 */
    if (time >= 86400) {
        _dateLb.text = [date substringToIndex:9];
        return YES;
    } else {
        [SVProgressHUD showInfoWithStatus:@"至截止日期不能少于一天"];
        return NO;
    }
}


- (void)noti {
    
   removeNoti = [kNotiCenter addObserverForName:@"removeNoti" object:@"detailsCell" queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [self removeNoti];
    }];
    
   observeroperation = [kNotiCenter addObserverForName:@"sureoperation" object:@"sure" queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        switch ([note.userInfo[@"viewtag"] integerValue]) {
            case 565: {
                _chooseYear.text = [note.userInfo[@"content"] stringValue];
                
                chooseYearState = YES;
            }
                break;
                
            case 566: {
                ReleaseRequireModel *model = note.userInfo[@"content"];
                _fromLb.text = model.Name;
                fromState = YES;
            }
                break;
                
            case 567:
                endDateState = [self getTimeDifferentWith:[NSString stringWithFormat:@"%@ 00:00:00" ,note.userInfo[@"content"]]];
                
                break;
                
            case 568:
                _addressLb.text = note.userInfo[@"content"];
                _CityId = note.userInfo[@"CityId"];
                _ProvincialId = note.userInfo[@"ProvincialId"];
                addressState = YES;
                break;
            case 570:
                [self delayOperation];
                break;
                
            case 571:
                _tempDescription = note.userInfo[@"content"];
                break;
                
            case 572:
                _tempImg = note.userInfo[@"content"];
                break;
        }
    }];
}




#pragma mark  GCD 延时操作
- (void)delayOperation {
    double delayInSeconds = 1.0;
    WS(weakSelf);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf delayMethod]; });
}

- (void)delayMethod {
    
    [self postInfo];
}




- (void)setTextField {
    _phone = _phoneNumTF.text = ApplicationDelegate.userInfo.Mobile;
    
    [_phoneNumTF addTarget:self action:@selector(change:) forControlEvents:(UIControlEventEditingChanged)];
    [_displacementTF addTarget:self action:@selector(change:) forControlEvents:(UIControlEventEditingChanged)];
    [_countNumTF addTarget:self action:@selector(change:) forControlEvents:(UIControlEventEditingChanged)];
}

- (void)change:(UITextField *)tf {
    if (tf == _countNumTF) {
        
            _conut = tf.text;

    }
    if (tf == _displacementTF) {
        
           _disp = tf.text;
        
    }
    if (tf == _phoneNumTF) {
      
            _phone = tf.text;

    }
}



/**
 *  获取我的店铺列表信息接口数据
 */
- (void)postInfo
{
  
    if (_conut.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"数量不能为空"];
        return;
    } else if (_phone.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"联系电话不能为空"];
       return;
    } else if (_disp.length == 0) {
       [SVProgressHUD showInfoWithStatus:@"排量不能为空"];
       return;
   } else if (addressState == NO) {
       [SVProgressHUD showInfoWithStatus:@"所在地不能为空"];
       return;
   } else if (endDateState == NO) {
       [SVProgressHUD showInfoWithStatus:@"截止日期不能为空"];
       return;
   } else if (chooseYearState == NO) {
       [SVProgressHUD showInfoWithStatus:@"出厂年份不能为空"];
       return;
   } else if (fromState == NO) {
        [SVProgressHUD showInfoWithStatus:@"配件来源不能为空"];
       return;
   } else {
        _tempId = [MJYUtils mjy_uuid];
        [_dataDic setObject:_conut forKey:@"Cnt"];
        [_dataDic setObject:_disp forKey:@"Displacement"];
        [_dataDic setObject:_phone forKey:ApplicationDelegate.userInfo.Mobile];
        [_dataDic setObject:_chooseYear.text forKey:@"Year"];
        [_dataDic setObject:_CityId forKey:@"CityId"];
        [_dataDic setObject:_ProvincialId forKey:@"ProvincialId"];
        [_dataDic setObject:_dateLb.text forKey:@"EndDate"];
        [_dataDic setObject:_tempDescription forKey:@"Description"];
        [_dataDic setObject:_tempId forKey:@"Id"];
        [_dataDic setObject:ApplicationDelegate.userInfo.user_Id forKey:@"UsrId"];
        [_dataDic setObject:_tempModel.content forKey:@"Title"];
        [_dataDic setObject:_tempModel.CarBrandId forKey:@"CarBrandId"];
        [_dataDic setObject:_tempModel.CarModelId forKey:@"CarModelId"];
        [_dataDic setObject:_tempModel.PartsUseForId forKey:@"PartsUseForId"];
        [_dataDic setObject:_tempModel.Id forKey:@"PartsTypeId"];
        [_dataDic setObject:@"" forKey:@"RespondId"];
        
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"Usr.asmx/AddDemand"];
        
        NSString *paramStr = [JYJSON JSONStringWithDictionaryOrArray:_dataDic];
        NSDictionary *paramDic = @{@"demandJson":paramStr};
        
        [ApplicationDelegate.httpManager POST:urlStr parameters:paramDic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //http请求状态
            if (task.state == NSURLSessionTaskStateCompleted) {
                
                NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];
                NSString *status = [NSString stringWithFormat:@"%@",jsonDic[@"Success"]];
                if ([status isEqualToString:@"1"]) {
                    //成功返回
                    if (_tempImg) {
                        NSData *imageData = UIImageJPEGRepresentation(_tempImg, 0.5);
                        [self postImg:imageData];
                    } else {
                        [self removeNoti];
                        [kNotiCenter postNotificationName:@"backRoot" object:@"backRoot"];
                    }
                  
                } else {
                    [SVProgressHUD showErrorWithStatus:jsonDic[@"Message"]];
                }
                
            } else {
                [SVProgressHUD showErrorWithStatus:k_Error_Network];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            //请求异常
            [SVProgressHUD showErrorWithStatus:k_Error_Network];
        }];
    }
}

- (void)removeNoti {
    _displacementTF.delegate = nil;
    _countNumTF.delegate = nil;
    _phoneNumTF.delegate = nil;
    [kNotiCenter removeObserver:observeroperation];
    [kNotiCenter removeObserver:removeNoti];
}

- (void)postImg:(NSData *)imageData {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:[MJYUtils mjy_uuid] forKey:@"dataId"];
    [dic setObject:_tempId forKey:@"Id"];
    [dic setObject:@(YES) forKey:@"isFirst"];
    [dic setObject:@(YES) forKey:@"isSingle"];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"Post/AddImg.aspx"];
    NSDictionary *paramDic = dic;
    [ApplicationDelegate.httpManager POST:urlStr parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"123" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];
        NSString *status = [NSString stringWithFormat:@"%@",jsonDic[@"Success"]];
        if ([status isEqualToString:@"1"]) {
            //成功返回
            [self removeNoti];
            [kNotiCenter postNotificationName:@"backRoot" object:@"backRoot"];
        } else {
            
            [SVProgressHUD showErrorWithStatus:jsonDic[@"Message"]];
        }

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error.debugDescription);
    }];
}



- (void)setParamBvState {
    addressState = NO;
    chooseYearState = NO;
    endDateState = NO;
    fromState = NO;
}



- (void)awakeFromNib {
    [self setYearBV];
    [self setParamBvState];
    [self noti];
    [self setTextField];
   
    _dataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
