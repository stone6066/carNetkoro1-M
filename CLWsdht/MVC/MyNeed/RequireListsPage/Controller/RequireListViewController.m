//
//  RequireListViewController.m
//  MFSC
//
//  Created by mfwl on 16/4/18.
//  Copyright © 2016年 mfwl. All rights reserved.
//

#import "RequireListViewController.h"
#import "RequireDetailsViewController.h"
#import "RequireListModel.h"
#import "ReleaseRequirementsViewController.h"
#import "UserInfo.h"

#define rowNum (NSInteger)(kScreen_Height / 96 + 1)


@interface RequireListViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSInteger totalNum;
}

@property (strong, nonatomic) IBOutlet UITableView *requireListTableView;
@property (nonatomic, strong) NSMutableArray *modelArr;
@property (nonatomic, strong) NSMutableArray *showModel;
@property (nonatomic, assign) NSInteger times;

@end

@implementation RequireListViewController

- (void)dealloc {
    _requireListTableView.delegate = nil;
    _requireListTableView.dataSource = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"我的需求";
        self.modelArr = [NSMutableArray arrayWithCapacity:0];
        self.showModel = [NSMutableArray arrayWithCapacity:0];
        self.times = 0;
    }
    return self;
}



- (void)viewWillAppear:(BOOL)animated {
    if (self.tabBarController.tabBar.hidden) {
        self.tabBarController.tabBar.hidden = NO;
    }
}




#pragma mark - 上拉刷新
- (void)setHeaderRefresh {
    
    _requireListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _modelArr = [NSMutableArray arrayWithCapacity:0];
        _showModel = [NSMutableArray arrayWithCapacity:0];
        [self dateHandle];
        
        [_requireListTableView.mj_header beginRefreshing];
        [_requireListTableView reloadData];
    }];
}


#pragma mark - 下拉加载
- (void)setFooterRefresh {
    
    _requireListTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _times++;
        NSLog(@"%ld", _times);
        for (NSInteger i = _times * rowNum; i < _modelArr.count; i++) {
            [_showModel addObject:_modelArr[i]];
            if (i ==( (1 + _times) * rowNum) - 1) {
                break;
            }
        }
        [_requireListTableView.mj_footer endRefreshing];
        [_requireListTableView reloadData];
    }];
}


- (void)setTableView {
    self.automaticallyAdjustsScrollViewInsets = YES;
    _requireListTableView.delegate = self;
    _requireListTableView.dataSource = self;
    _requireListTableView.tableFooterView = [[UIView alloc] init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (_showModel.count) {
        case 0:
            return 1;
            break;
            
        default:
            return _showModel.count;
            break;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = nil;
    BaseModel *model = nil;
    switch (_showModel.count) {
        case 0: {
            static NSString *cellName = @"SoyTableViewCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell) {
                cell = [CellFactory creatCellWithClassName:cellName cellModel:model indexPath:indexPath];
            }
        }
            break;
            
        default: {
            model = _showModel[indexPath.row];
            static NSString *cellName = @"RequireListTableViewCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell) {
                cell = [CellFactory creatCellWithClassName:cellName cellModel:model indexPath:indexPath];
            } else  /* 当页面拉动的时候 当cell存在并且最后一个存在 把它进行删除就出来一个独特的cell我们在进行数据配置即可避免 */
            {
                while ([cell.contentView.subviews lastObject] != nil) {
                    [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
                }
            }
        }
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 96;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (_showModel.count) {
        case 0:
            [SVProgressHUD showErrorWithStatus:@"暂无需求"];
            break;
        default: {
            RequireDetailsViewController *detailsVC = [[RequireDetailsViewController alloc] init];
            detailsVC.baseModel = _modelArr[indexPath.row];
            NSLog(@"%@",  detailsVC.baseModel.Url);
            [self.navigationController pushViewController:detailsVC animated:YES];
        }
            break;
    }
    
}

- (void)dateHandle {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"Usr.asmx/GetDemandList"];
    
    NSDictionary *param = @{@"UsrId":ApplicationDelegate.userInfo.user_Id};
    NSDictionary *paramDic = @{
                               @"demandJson":[JYJSON JSONStringWithDictionaryOrArray:param],
                               
                               @"sortJson":@"",
                            
                               @"start":@"0",
                               
                               @"limit":[NSString stringWithFormat:@"%ld", rowNum]
                               };
    
    [ApplicationDelegate.httpManager POST:urlStr parameters:paramDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //http请求状态
        if (task.state == NSURLSessionTaskStateCompleted) {
            
            NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];
            [self datprocessingWith:jsonDic];
            NSString *status = [NSString stringWithFormat:@"%@",jsonDic[@"Success"]];
            if ([status isEqualToString:@"1"]) {
                //成功返回
                totalNum = [[jsonDic objectForKey:@"Total"] integerValue];
                [SVProgressHUD dismiss];
            } else {
                [SVProgressHUD showErrorWithStatus:jsonDic[@"Message"]];
            }
            [_requireListTableView.mj_header endRefreshing];
            
        } else {
            [SVProgressHUD showErrorWithStatus:k_Error_Network];
            [_requireListTableView.mj_header endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        //请求异常
        [_requireListTableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:k_Error_Network];
    }];
}

- (void)datprocessingWith:(NSDictionary *)jsonDic {
    NSDictionary *dicFirst = jsonDic[@"Data"];
    NSArray *dataArr = dicFirst[@"Data"];
 
    for (NSDictionary *dic in dataArr) {
        RequireListModel *model = [RequireListModel modelWithDictionary:dic];
        [_modelArr addObject:model];
    }
    _times = 0;
    for (NSInteger i = _times*rowNum; i < _modelArr.count; i ++) {
        [_showModel addObject:_modelArr[i]];
        if (i == ((1 + _times) * rowNum)-1) {
            break;
        }
    }
       [_requireListTableView reloadData];
}


- (IBAction)sendRequire:(id)sender {
    ReleaseRequirementsViewController *release = [[ReleaseRequirementsViewController alloc] init];
    [self.navigationController pushViewController:release animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self dateHandle];
    [self setTableView];
    [self setFooterRefresh];
    [self setHeaderRefresh];
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
