//
//  DetailsInfomationViewController.m
//  MFSC
//
//  Created by mfwl on 16/4/15.
//  Copyright © 2016年 mfwl. All rights reserved.
//

#import "DetailsInfomationViewController.h"
#import "ReleaseRequireModel.h"
#import "DetailsBasicInfoCell.h"
#import "DetailsSureCell.h"
#import "BaseHeader.h"




@interface DetailsInfomationViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    id __block observeroption;
    id __block observerSTPnil;
    id __block observerbackRoot;
    ReleaseRequireModel *soyModel;
}

#pragma mark tbv

@property (strong, nonatomic) IBOutlet UITableView *specificRequirementsListTableView;


#pragma mark title
@property (strong, nonatomic) IBOutlet UILabel *carType;
@property (strong, nonatomic) IBOutlet UILabel *detailsCarType;
@property (strong, nonatomic) IBOutlet UILabel *partsType;
@property (strong, nonatomic) IBOutlet UILabel *detailsPartsType;


@property (nonatomic, assign) NSInteger tempNum;

#pragma mark yearData
@property (nonatomic, strong) NSMutableArray *yearArr;


#pragma mark pickerSingle
@property (nonatomic, strong) STPickerSingle *pickerSingle;
@property (nonatomic, strong) STPickerArea *pickerArea;
@property (nonatomic, strong) STPickerDate *pickerDate;


#pragma mark from backv
@property (nonatomic, strong) UIButton *fromBackV;
@property (nonatomic, strong) UIView *backV;
@property (nonatomic, strong) UIButton *oldFac;
@property (nonatomic, strong) UIButton *rightFac;
@property (nonatomic, strong) UIButton *noFac;

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSMutableArray *modelArr;

@end

@implementation DetailsInfomationViewController

- (void)dealloc {
    _specificRequirementsListTableView.delegate = nil;
    _specificRequirementsListTableView.dataSource = nil;
    [_fromBackV removeTarget:self action:@selector(removeFromBackV) forControlEvents:(UIControlEventTouchDragInside)];
}

- (void)removeNoti {
    [kNotiCenter removeObserver:observeroption];
    [kNotiCenter removeObserver:observerSTPnil];
    [kNotiCenter removeObserver:observerbackRoot];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"填写发布信息";
        [self setBack];
        _yearArr = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger i = 1996; i <2017; i++) {
            [_yearArr addObject:@(i)];
        }
        self.automaticallyAdjustsScrollViewInsets = NO;

    }
    return self;
}

- (void)setBack  {
    UIButton *back = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [back setFrame:CGRectMake(0, 0, 20, 20)];
    [back setTintColor:[UIColor orangeColor]];
    [back setImage:[UIImage imageNamed:@"fanhuiy"] forState:(UIControlStateNormal)];
    [back addTarget:self action:@selector(back:) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *item  = [[UIBarButtonItem  alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = item;
}
- (void)back:(UIButton *)back {
    [self backAction];
    [kNotiCenter postNotificationName:@"removeNoti" object:@"detailsCell"];
    [self removeNoti];
}


- (void)viewWillAppear:(BOOL)animated {
    [self noti];
}

- (void)setTitle {
    _carType.text = _carModel.Name;
    _detailsCarType.text = _detailsCarModel.Name;
    _partsType.text = _partsModel.Name;
    _detailsPartsType.text = _detailsPartsModel.Name;
    _specificRequirementsListTableView.delegate = self;
    _specificRequirementsListTableView.dataSource = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = nil;
    BaseModel *model = nil;
    switch (indexPath.section) {
        case 0: {
            static NSString *cellIdentifier = @"DetailsBasicInfoCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            NSString *str = [NSString stringWithFormat:@"求购%@的%@",_carModel.Name, _detailsPartsModel.Name];
            _detailsPartsModel.content = str;
            _detailsPartsModel.CarBrandId = _carModel.Id;
            _detailsPartsModel.CarModelId = _detailsCarModel.Id;
            _detailsPartsModel.PartsUseForId = _partsModel.Id;
            
            model = _detailsPartsModel;
            if (!cell) {
                cell = [CellFactory creatCellWithClassName:cellIdentifier cellModel:model indexPath:indexPath];
            }
        }
            break;
        case 1: {
            static NSString *cellIdentifier = @"DetailsImageTableViewCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
           
            if (!cell) {
                cell = [CellFactory creatCellWithClassName:cellIdentifier cellModel:model indexPath:indexPath];
            }

        }
            break;
            
            
        default: {
            static NSString *cellIdentifier = @"DetailsSureCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [CellFactory creatCellWithClassName:cellIdentifier cellModel:model indexPath:indexPath];
            }
        }
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 360;
            break;
        case 1:
            return 150;
            break;
        default:
            return 60;
            break;
    }
    
}


#pragma mark 通知中心
- (void)noti {
    
   observerbackRoot = [kNotiCenter addObserverForName:@"backRoot" object:@"backRoot" queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
       [kNotiCenter postNotificationName:@"removeNoti" object:@"detailsCell"];
       [self removeNoti];
    }];
   observerSTPnil = [kNotiCenter addObserverForName:@"setSTPnil" object:@"STPnil" queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        if (_pickerDate) {
            _pickerDate = nil;
        }
        if (_pickerArea) {
            _pickerArea = nil;
        }
        if (_pickerSingle) {
            _pickerSingle = nil;
        }
    }];
   observeroption = [kNotiCenter addObserverForName:@"viewoperation" object:@"operation" queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        self.tempNum = [note.userInfo[@"taptag"] integerValue];
        switch (self.tempNum) {
            case 565: 
                
                [self pickerSingle];
                [_pickerSingle show];
                
                break;
                
            case 566: {
#pragma mark choose Fac
                [self fromBackV];
              
            }
                
                break;
                
            case 567:
                [self pickerDate];
                [_pickerDate show];
                break;
                
            case 568:
                [self pickerArea];
                [_pickerArea show];
                break;
            case 569: {
#pragma mark 相机相册
                [self setImagePickerController];
                
            }
                break;
        }
    }];
}

#pragma mark picker sizeload

- (STPickerArea *)pickerArea {
    if (!_pickerArea) {
        _pickerArea = [[STPickerArea alloc] init];
    }
    return _pickerArea;
}
- (STPickerDate *)pickerDate {
    if (!_pickerDate) {
        _pickerDate = [[STPickerDate alloc] init];
    }
    return _pickerDate;
}
- (STPickerSingle *)pickerSingle {
    if (!_pickerSingle) {
        _pickerSingle = [[STPickerSingle alloc] init];
        [_pickerSingle setArrayData:_yearArr];
        [_pickerSingle setTitle:@"请选择出厂年份"];
        [_pickerSingle setTitleUnit:@"年"];
        [_pickerSingle setContentMode:STPickerContentModeBottom];
    }
    return _pickerSingle;
}


#pragma mark dataFac
- (void)dateHandle {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PartsSrc" ofType:@"plist"];
    self.dataArr = [NSArray arrayWithContentsOfFile:path];
    self.modelArr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in _dataArr) {
        ReleaseRequireModel *model = [ReleaseRequireModel modelWithDictionary:dic];
        [_modelArr addObject:model];
    }
}



#pragma mark facbv
- (UIView *)fromBackV {
    if (!_fromBackV) {
        _fromBackV = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_fromBackV setFrame:kScreen_Frame];
        [[ApplicationDelegate window] addSubview:_fromBackV];
        [[ApplicationDelegate window] bringSubviewToFront:_fromBackV];
        _fromBackV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f];
        [_fromBackV addTarget:self action:@selector(removeFromBackV)];
        [UIView animateWithDuration:k_Time_Animation animations:^{
            _fromBackV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
        } completion:^(BOOL finished) {
            [self backV];
        }];
    }
    return _fromBackV;
}

- (UIView *)backV {
    if (!_backV) {
        _backV = [[UIView alloc] init];
        [_fromBackV addSubview:_backV];
        _backV.backgroundColor = [UIColor whiteColor];
        [_backV setFrame:CGRectMake(0, kScreen_Height, kScreen_Width, kScreen_Height * 0.3)];
        [self dateHandle];
        [self rightFac];
        [self noFac];
        [self oldFac];
        UILabel *lb = [[UILabel alloc] init];
        [_backV addSubview:lb];
        lb.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220/255.0 blue:220/255.0 alpha:1.0f];
        lb.text = @"请选择配件出厂源";
        lb.textAlignment = 1;
        lb.font = [UIFont systemFontOfSize:18];
        [lb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(_backV);
            make.height.equalTo(@40);
        }];
        [UIView animateWithDuration:k_Time_Animation animations:^{
            [_backV setFrame:CGRectMake(0, kScreen_Height * 0.7, kScreen_Width, kScreen_Height * 0.3)];
        } completion:^(BOOL finished) {
            
        }];
    }
    return _backV;
}

- (UIButton *)rightFac {
    if (!_rightFac) {
        _rightFac = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_backV addSubview:_rightFac];
        _rightFac.layer.cornerRadius = 5;
        _rightFac.layer.masksToBounds = YES;
        _rightFac.backgroundColor = [UIColor colorWithRed:244 /255.0 green:244/255.0 blue:244/255.0 alpha:1.0f];
        soyModel = _modelArr[1];
        [_rightFac addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_rightFac setTitle:soyModel.Name forState:(UIControlStateNormal)];
        [_rightFac mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_backV);
            make.left.equalTo(_backV).offset(20);
            make.size.mas_equalTo(CGSizeMake(kScreen_Width /4, 40));
            
        }];
    }
    return _rightFac;
}
- (UIButton *)noFac {
    if (!_noFac) {
        _noFac = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_backV addSubview:_noFac];
        _noFac.layer.cornerRadius = 5;
        _noFac.layer.masksToBounds = YES;
        _noFac.backgroundColor = [UIColor colorWithRed:244 /255.0 green:244/255.0 blue:244/255.0 alpha:1.0f];
        soyModel = _modelArr[0];
        [_noFac setTitle:soyModel.Name forState:(UIControlStateNormal)];

        [_noFac addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_noFac mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_backV);
           
            make.size.mas_equalTo(CGSizeMake(kScreen_Width / 4, 40));
            
        }];
    }
    return _noFac;
}
- (UIButton *)oldFac {
    if (!_oldFac) {
        _oldFac = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_backV addSubview:_oldFac];
        _oldFac.layer.cornerRadius = 5;
        _oldFac.layer.masksToBounds = YES;
        _oldFac.backgroundColor = [UIColor colorWithRed:244 /255.0 green:244/255.0 blue:244/255.0 alpha:1.0f];
        soyModel = _modelArr[2];
    
        [_oldFac setTitle:soyModel.Name forState:(UIControlStateNormal)];

        [_oldFac addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_oldFac mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_backV);
            make.right.equalTo(_backV).offset(-20);
            make.size.mas_equalTo(CGSizeMake(kScreen_Width / 4 , 40));
            
        }];
    }
    return _oldFac;
}

- (void)buttonClick:(UIButton *)button {
    for (ReleaseRequireModel *model in _modelArr) {
        if ([model.Name isEqualToString:button.titleLabel.text]) {
            [kNotiCenter postNotificationName:@"sureoperation" object:@"sure" userInfo:@{@"viewtag":@(self.tempNum), @"content":model}];
        }
    }
    [self removeFromBackV];
}

- (void)removeFromBackV {
    [UIView animateWithDuration:k_Time_Animation animations:^{
        _fromBackV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f];
        [UIView animateWithDuration:k_Time_Animation animations:^{
            [_backV setFrame:CGRectMake(0, kScreen_Height, kScreen_Width, kScreen_Height * 0.3)];
        } completion:^(BOOL finished) {
            [_backV removeFromSuperview];
            _backV = nil;
        }];
    } completion:^(BOOL finished) {
        [_fromBackV removeFromSuperview];
        _fromBackV = nil;
        _oldFac = nil;
        _rightFac = nil;
        _noFac = nil;
    }];
}



#pragma  mark datesource
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 1:
            return 28;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = nil;
    if (section == 1) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 28)];
        view.backgroundColor = [UIColor colorWithRed:200 /255.0 green:200 /255.0 blue:200 / 255.0 alpha:1.0f];
        UILabel *lb = [[UILabel alloc] init];
        [view addSubview:lb];
        [lb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(view);
            make.left.equalTo(view).offset(10);
            make.width.equalTo(@(13.6*4));
        }];
        lb.text = @"具体需求";
        lb.font = [UIFont systemFontOfSize:13];
        lb.textColor = [UIColor colorWithRed:160 /255.0 green:160 /255.0 blue:160 / 255.0 alpha:1.0f];
        UILabel *lb1 = [[UILabel alloc] init];
        lb1.text = @"*";
        lb1.font = [UIFont systemFontOfSize:17];
        lb1.textColor = [UIColor redColor];
        
        [view addSubview:lb1];
        [lb1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(view);
            make.left.equalTo(lb.mas_right);
            make.width.equalTo(@17);
        }];
        
    }
    return view;
}


#pragma mark OpenImagePiker

- (void)setImagePickerController {
    //创建UIAlertController是为了让用户去选择照片来源,拍照或者相册.
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:0];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"从相册选取" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action)
                                   {
                                       //这里可以不写代码
                                   }];
    [self presentViewController:alertController animated:YES completion:nil];
    
    //用来判断来源 Xcode中的模拟器是没有拍摄功能的,当用模拟器的时候我们不需要把拍照功能加速
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [alertController addAction:photoAction];
    }
    else
    {
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
    }
}


//这个是选取完照片后要执行的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    //选取裁剪后的图片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    
    [kNotiCenter postNotificationName:@"upImage" object:@"image" userInfo:@{@"image":image}];
}







- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle];
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@ > %@", _partsModel.Name, _detailsPartsModel.Name]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
