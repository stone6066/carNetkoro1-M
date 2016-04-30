//
//  HomeVC.m
//  CLW
//
//  Created by majinyu on 16/1/9.
//  Copyright © 2016年 cn.com.cucsi. All rights reserved.
//

#import "HomeVC.h"
#import "LoginViewController.h"//登陆页面
#import "CityListVC.h"//城市选择
#import "AddressGroupJSONModel.h"//地址model
#import "AddressJSONModel.h"//地址model
#import "MyOrderViewController.h"//我的订单VC
#import "CeShiViewController.h"
#import "CarDemandViewController.h"


@interface HomeVC (){
    
    NSString *userSeletedCity;//用户选择的城市(默认用户当前位置所在城市)
    NSString *userSeletedCityID;//用户选择的城市ID(默认用户当前位置所在城市)
    
}


//当前在线商家数量
@property (weak, nonatomic) IBOutlet UILabel *repairCarOnlineNumber;
//我要修车
@property (weak, nonatomic) IBOutlet UIButton *myCase;

//我要买件
@property (weak, nonatomic) IBOutlet UIButton *needer;

//我的订单
@property (weak, nonatomic) IBOutlet UIButton *myOrder;

//我的需求
@property (weak, nonatomic) IBOutlet UIButton *myNeed;

@end

@implementation HomeVC

#pragma mark - Life Cycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //设置圆角
    _myCase.layer.masksToBounds = YES;
    _myCase.layer.cornerRadius = 8;
    
    _needer.layer.masksToBounds = YES;
    _needer.layer.cornerRadius = 8;

    _myOrder.layer.masksToBounds = YES;
    _myOrder.layer.cornerRadius = 8;

    _myNeed.layer.masksToBounds = YES;
    _myNeed.layer.cornerRadius = 8;

    
    [self initData];
    
    [self initUI];
    
    [self std_regsNotification];
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.tabBarController.tabBar.hidden) {
        self.tabBarController.tabBar.hidden = NO;
    }
    //加载首页数据信息
    
    userSeletedCity = ApplicationDelegate.currentCity;
    userSeletedCityID = ApplicationDelegate.currentCityID;
    [self initRightButtonItemWithCityName:userSeletedCity];
    
    if (!ApplicationDelegate.isLogin) {
       // 显示登录页面
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        LoginViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:NO];
        self.hidesBottomBarWhenPushed = NO;
    } else {
        //加载首页数据信息
        
        userSeletedCity = ApplicationDelegate.currentCity;
        userSeletedCityID = ApplicationDelegate.currentCityID;
        [self initRightButtonItemWithCityName:userSeletedCity];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}


- (void)execute:(NSNotification *)notification {
    if([notification.name isEqualToString:k_Notification_CityBtnName_Home] ){
        userSeletedCity=ApplicationDelegate.currentCity;
        userSeletedCityID = ApplicationDelegate.currentCityID;
        UIButton *btn = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
        [btn setTitle:userSeletedCity forState:UIControlStateNormal];
        btn.titleLabel.text = userSeletedCity;
        
    }
}
-(void)std_regsNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(execute:)
                                                 name:k_Notification_CityBtnName_Home
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectCity:)
                                                 name:k_Notification_CitySelect_Home
                                               object:nil];
}

- (void)selectCity:(NSNotification *)notification {
    if([notification.name isEqualToString:k_Notification_CitySelect_Home] ){
        [self seleteCityAction];
        
    }
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:k_Notification_UpdateUserAddressInfo_Home
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:k_Notification_CitySelect_Home
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:k_Notification_CityBtnName_Home
                                                  object:nil];
}

#pragma mark - Data & UI
//数据
-(void)initData
{
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserSeletdCity:)
                                                 name:k_Notification_UpdateUserAddressInfo_Home
                                               object:nil];
    
    
}
//页面
-(void)initUI
{
    
}

#pragma mark - Notification Method
/**
 *  更新用户选择信息
 *
 *  @param noti
 */
- (void)updateUserSeletdCity:(NSNotification *) noti
{
    AddressJSONModel *address = noti.object;
    
    userSeletedCity = address.city_name;
    userSeletedCityID = address.city_id;
    ApplicationDelegate.currentCity=userSeletedCity;
    ApplicationDelegate.currentCityID=userSeletedCityID;
    [ApplicationDelegate std_saveCityName:userSeletedCity];
    UIButton *btn = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    [btn setTitle:userSeletedCity forState:UIControlStateNormal];
    btn.titleLabel.text = userSeletedCity;
}

#pragma mark - Target & Action

#pragma mark - Functions Custom

/**
 *   初始化右上角按钮
 */
- (void)initRightButtonItemWithCityName:(NSString *)cityName
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, 44)];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn setTitle:cityName forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(seleteCityAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

/**
 *  选择城市的方法
 */
- (void) seleteCityAction
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    CityListVC *vc = [sb instantiateViewControllerWithIdentifier:@"CityListVC"];
    vc.vcType = 2;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{}];
    
}

#pragma mark -我要买车
- (IBAction)myCaseBtn:(UIButton *)sender {
    CarDemandViewController *carDemand = [[CarDemandViewController alloc] init];
    [self.navigationController pushViewController:carDemand animated:YES];

    
}

#pragma mark -我要买件
- (IBAction)neederBtn:(UIButton *)sender {
}

#pragma mark -- 我的订单
- (IBAction)myOrder:(UIButton *)sender {
    UIBarButtonItem *backIetm = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backIetm;
    backIetm.title =@"返回";
    [self.navigationController.navigationBar setTintColor:[UIColor orangeColor]];
    [self setHidesBottomBarWhenPushed:YES];
    MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
    [self.navigationController pushViewController:myOrderVC animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

#pragma mark -- 我的需求
- (IBAction)myNeed:(UIButton *)sender {

}

#pragma mark - Networking


@end
