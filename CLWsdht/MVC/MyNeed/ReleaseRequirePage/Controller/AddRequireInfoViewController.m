//
//  AddRequireInfoViewController.m
//  MFSC
//
//  Created by mfwl on 16/4/15.
//  Copyright © 2016年 mfwl. All rights reserved.
//

#import "AddRequireInfoViewController.h"
#import "ReleaseRequireModel.h"
#import "DetailsInfomationViewController.h"
#import "BaseHeader.h"



@interface AddRequireInfoViewController () <UITableViewDataSource, UITableViewDelegate>

#pragma mark tbv
@property (strong, nonatomic) IBOutlet UITableView *carPartsTableView;
@property (strong, nonatomic) IBOutlet UITableView *detailsCarPartsTableView;


#pragma mark title
@property (strong, nonatomic) IBOutlet UILabel *carType;
@property (strong, nonatomic) IBOutlet UILabel *detailsType;


#pragma mark  data
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSMutableArray *partsModelArr;
@property (nonatomic, strong) NSMutableArray *detailsPartsModelArr;

#pragma mark tempModel 
@property (nonatomic, strong) ReleaseRequireModel *partsModel;


@end

@implementation AddRequireInfoViewController

- (void)dealloc {
    _carPartsTableView.delegate = nil;
    _carPartsTableView.dataSource =nil;
    _detailsCarPartsTableView.dataSource = nil;
    _detailsCarPartsTableView.delegate = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"配件选择";
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self setBack];
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
}



#pragma mark handleData
- (void)partsDataHandle {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PartsUseFor" ofType:@"plist"];
    
    self.dataArr = [NSArray arrayWithContentsOfFile:path];
    self.partsModelArr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in _dataArr) {
        ReleaseRequireModel *model = [ReleaseRequireModel modelWithDictionary:dic];
        [_partsModelArr addObject:model];
    }
    [self.carPartsTableView reloadData];

}

#pragma mark 表头
- (void)setTitle {
    _detailsType.text = _detailsCarModel.Name;
    _carType.text = _carModel.Name;
    _carPartsTableView.delegate = self;
    _carPartsTableView.dataSource = self;
    _detailsCarPartsTableView.delegate= self;
    _detailsCarPartsTableView.dataSource = self;
    _detailsCarPartsTableView.tableFooterView = [[UIView alloc] init];
    UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    [_carPartsTableView addGestureRecognizer:swipeGR];
}
- (void)swipeAction:(UISwipeGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (_detailsCarPartsTableView.hidden == NO) {
            _detailsCarPartsTableView.hidden = YES;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_carPartsTableView]) {
        return _partsModelArr.count;
    } else {
        return _detailsPartsModelArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_carPartsTableView]) {
        static NSString *cellIdentifier = @"partsTypeCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellIdentifier];
        }
        ReleaseRequireModel *model = _partsModelArr[indexPath.row];
        cell.textLabel.text = model.Name;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    } else {
        static NSString *cellIdentifier = @"detailsPartsTypeCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellIdentifier];
        }
        ReleaseRequireModel *model =  _detailsPartsModelArr[indexPath.row];
        cell.textLabel.text = model.Name;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
#pragma mark cell click
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([tableView isEqual:_carPartsTableView]) {

        _detailsPartsModelArr = [NSMutableArray arrayWithCapacity:0];
        ReleaseRequireModel *model = _partsModelArr[indexPath.row];
        self.partsModel = model;
        for (NSDictionary *dic in model.T_DicPartsType) {
            ReleaseRequireModel *detailPartsModel = [ReleaseRequireModel modelWithDictionary:dic];
            [_detailsPartsModelArr addObject:detailPartsModel];
        }
        if (_detailsCarPartsTableView.hidden) {
            _detailsCarPartsTableView.hidden = NO;
        }
        [_detailsCarPartsTableView reloadData];
        
    } else {
        DetailsInfomationViewController *details = [[DetailsInfomationViewController alloc] init];
        details.carModel = _carModel;
        details.detailsCarModel = _detailsCarModel;
        details.partsModel = _partsModel;
        details.detailsPartsModel = _detailsPartsModelArr[indexPath.row];
        [self.navigationController pushViewController:details animated:YES];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@ > %@", _carModel.Name, _detailsCarModel.Name]];
    [self partsDataHandle];
    [self setTitle];
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
