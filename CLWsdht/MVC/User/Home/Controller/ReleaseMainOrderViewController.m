//
//  ReleaseMainOrderViewController.m
//  CLWsdht
//
//  Created by koroysta1 on 16/4/25.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "ReleaseMainOrderViewController.h"
#import "AFNetworking.h"//主要用于网络请求方法
#import "UIKit+AFNetworking.h"//里面有异步加载图片的方法
#import "MJExtension.h"
#import "BaseHeader.h"
#import "ReleaseTableViewCell.h"
#import "ReleaseModel.h"


@interface ReleaseMainOrderViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *knockOrderTableView;
@property (nonatomic, copy) NSString *orderNumber;
@property (nonatomic, strong) NSMutableArray *releaseArr;

@end

@implementation ReleaseMainOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"发布维修抢单"];
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBarButtonClicked)];
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
    _orderNumber = [_jpushDict objectForKey:@"msgText"];
    
    
    //判断内容是否为空
    if (_jpushDict != nil) {
        //调用已抢单列表接口
        [self getCompetedOrderUsrGarages];
        //创建tabelview
        _knockOrderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
        _knockOrderTableView.delegate = self;
        _knockOrderTableView.dataSource = self;
        [_knockOrderTableView registerNib:[UINib nibWithNibName:@"ReleaseTableViewCell" bundle:nil] forCellReuseIdentifier:@"releaseCellIdentifer"];
        [self.view addSubview:_knockOrderTableView];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

#pragma mark -- 显示已抢单列表
- (void)getCompetedOrderUsrGarages{
    [SVProgressHUD showWithStatus:k_Status_Load];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"CompetitionOrder.asmx/GetCompetedOrderUsrGarages"];
    NSDictionary *paramDict = @{
                                @"CompetitionOrderId":_uuid,
                                };
    
    
    [ApplicationDelegate.httpManager POST:urlStr
                               parameters:paramDict
                                 progress:^(NSProgress * _Nonnull uploadProgress) {}
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                      //http请求状态
                                      if (task.state == NSURLSessionTaskStateCompleted) {
                                          NSError* error;
                                          NSDictionary* jsonDic = [NSJSONSerialization
                                                                   JSONObjectWithData:responseObject
                                                                   options:kNilOptions
                                                                   error:&error];
                                          if (jsonDic[@"Success"]){
                                              //成功
                                              NSLog(@"------------------%@", jsonDic);
                                              ReleaseModel *releaseModel = [[ReleaseModel alloc] init];
                                              _releaseArr = [releaseModel releaseModelWithDict:jsonDic];
                                              //tableView刷新数据
                                              [_knockOrderTableView reloadData];
                                              [SVProgressHUD showSuccessWithStatus:  k_Success_Load];
                                              
                                          } else {
                                              //失败
                                              [SVProgressHUD showErrorWithStatus:k_Error_WebViewError];
                                              
                                          }
                                          
                                      } else {
                                          [SVProgressHUD showErrorWithStatus:k_Error_Network];
                                      }
                                      
                                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      //请求异常
                                      [SVProgressHUD showErrorWithStatus:k_Error_Network];
                                  }];
    

}

#pragma mark -- 右上角取消按钮的响应事件
- (void)cancelBarButtonClicked{
    [self handleCompetitionOrder];
}
#pragma mark -- 取消发布抢单的接口
- (void)handleCompetitionOrder{
    [SVProgressHUD showWithStatus:k_Status_Load];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"CompetitionOrder.asmx/HandleCompetitionOrder"];
    NSDictionary *paramDict = @{
                                @"CompetitionOrderId":_uuid,
                                @"State":@"2"
                                };
    
    
    [ApplicationDelegate.httpManager POST:urlStr
                               parameters:paramDict
                                 progress:^(NSProgress * _Nonnull uploadProgress) {}
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                      //http请求状态
                                      if (task.state == NSURLSessionTaskStateCompleted) {
                                          NSError* error;
                                          NSDictionary* jsonDic = [NSJSONSerialization
                                                                   JSONObjectWithData:responseObject
                                                                   options:kNilOptions
                                                                   error:&error];
                                          if (jsonDic[@"Success"]) {
                                              //成功
                                              [SVProgressHUD showSuccessWithStatus:  k_Success_Load];
                                              [self.navigationController popViewControllerAnimated:YES];
                                              
                                          } else {
                                              //失败
                                              [SVProgressHUD showErrorWithStatus:k_Error_WebViewError];
                                              
                                          }
                                          
                                      } else {
                                          [SVProgressHUD showErrorWithStatus:k_Error_Network];
                                      }
                                      
                                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      //请求异常
                                      [SVProgressHUD showErrorWithStatus:k_Error_Network];
                                  }];
    

}


#pragma mark -- UITableViewDataSource

/*设置标题头的高度*/
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
/*设置标题尾的高度*/
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}


//返回某个section中rows的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _releaseArr.count;
}


//这个方法是用来创建cell对象，并且给cell设置相关属性的
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置标识符
    static NSString *userStoreCellIdentifer = @"releaseCellIdentifer";
    ReleaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"releaseCellIdentifer"];
    if (cell == nil) {
        cell = [[ReleaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userStoreCellIdentifer];
    }
    [cell setReleaseOrderWithModel:_releaseArr[indexPath.row]];
    
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
