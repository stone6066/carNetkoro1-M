//
//  ReleaseMainOrderViewController.m
//  CLWsdht
//
//  Created by koroysta1 on 16/4/25.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "ReleaseMainOrderViewController.h"
#import "ReleaseTableViewCell.h"

@interface ReleaseMainOrderViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *knockOrderTableView;

@end

@implementation ReleaseMainOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"发布维修抢单"];
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:nil action:@selector(cancelBarBtnClicked:)];
    [self.navigationItem setRightBarButtonItem:cancelBarBtn];
    
    // 我们喜欢听ChangeTheme的广播
    // 注册成为广播站ChangeTheme频道的听众
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    // 成为听众一旦有广播就来调用self recvBcast:函数
    [nc addObserver:self selector:@selector(recvBcast:) name:@"ChangeTheme" object:nil];
}

// 这个函数是系统自动来调用
// ios系统接收到ChangeTheme广播就会来自动调用
// notify就是广播的所有内容
- (void) recvBcast:(NSNotification *)notify{
    static int index;
    NSLog(@"recv bcast %d", index++);
    // 取得广播内容
    _jpushDict = [notify userInfo];
    if (_jpushDict != nil) {
        _knockOrderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
        _knockOrderTableView.delegate = self;
        _knockOrderTableView.dataSource = self;
        [_knockOrderTableView registerNib:[UINib nibWithNibName:@"ReleaseTableViewCell" bundle:nil] forCellReuseIdentifier:@"releaseCellIdentifer"];
        [self.view addSubview:_knockOrderTableView];
    }
}

#pragma mark -- 左上角取消按钮的响应事件
- (void)cancelBarBtnClicked:(UIBarButtonItem *)btn{
    
}


#pragma mark -- UITableViewDataSource

//返回某个section中rows的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}


//这个方法是用来创建cell对象，并且给cell设置相关属性的
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置标识符
    static NSString *userStoreCellIdentifer = @"releaseCellIdentifer";
    ReleaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"releaseCellIdentifer"];
    if (cell == nil) {
        cell = [[ReleaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userStoreCellIdentifer];
    }
    //[cell setOrderWithModel:GM];
    
    return cell;
}

//返回section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark -- UITableViewDelegate
//返回cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
//选中cell时调起的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //选中cell要做的操作
    
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
