//
//  RequireDetailsViewController.m
//  MFSC
//
//  Created by mfwl on 16/4/18.
//  Copyright © 2016年 mfwl. All rights reserved.
//

#import "RequireDetailsViewController.h"

@interface RequireDetailsViewController () <UITableViewDataSource, UITableViewDelegate>{
    id __block observeroperation;
}

@property (strong, nonatomic) IBOutlet UITableView *detailsTableView;


@end

@implementation RequireDetailsViewController

- (void)dealloc {
    _detailsTableView.delegate = nil;
    _detailsTableView.dataSource = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"需求详情";
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

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}

- (void)setBaseModel:(BaseModel *)baseModel {
    if (_baseModel != baseModel) {
        _baseModel = baseModel;
    }
    [_detailsTableView reloadData];
}
- (void)setTableView {
    _detailsTableView.delegate = self;
    _detailsTableView.dataSource = self;
    [_detailsTableView registerNib:[UINib nibWithNibName:@"DetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailsTableViewCell"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = nil;
    
    
   
    cell = [tableView dequeueReusableCellWithIdentifier:@"DetailsTableViewCell"];
    cell.model = _baseModel;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 505;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    
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
