//
//  CeShiViewController.m
//  CLWsdht
//
//  Created by koroysta1 on 16/4/21.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "CeShiViewController.h"
#import "AFNetworking.h"//主要用于网络请求方法
#import "UIKit+AFNetworking.h"//里面有异步加载图片的方法
#import "MJExtension.h"
#import "BaseHeader.h"
#import "ReleaseMainOrderViewController.h"



@interface CeShiViewController ()

@end

@implementation CeShiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 150, 50)];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitle:@"发布抢单" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:4];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    // Do any additional setup after loading the view.
}



- (void)button:(UIButton *)btn{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

    [self setHidesBottomBarWhenPushed:YES];
    UIBarButtonItem *backIetm = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backIetm;
    backIetm.title =@"返回";
    backIetm.tintColor = [UIColor orangeColor];

    [SVProgressHUD showWithStatus:k_Status_Load];
    NSString *uuid = [MJYUtils mjy_uuid];
    ReleaseMainOrderViewController *releaseVC = [[ReleaseMainOrderViewController alloc] init];
    releaseVC.uuid = uuid;
    [self.navigationController pushViewController:releaseVC animated:YES];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"CompetitionOrder.asmx/AddCompetitionOrder"];
    NSDictionary *competitionOrderJson = @{
                                      @"CarModelId":@"c3eb4c54-9695-4e8a-9c9f-63270aa2bdff",
                                      @"UsrId":@"2864185e-bccd-4a83-9ffb-df637757e3c3",
                                      @"CarBrandId":@"be943212-d793-4809-9633-0346e3391c95",
                                      @"Id":uuid
                                      };
    NSError *error;
    NSData *competitionOrdersJsonData = [NSJSONSerialization dataWithJSONObject:competitionOrderJson options:NSJSONWritingPrettyPrinted error:&error];
    NSString *competitionOrdersJsonDataJsonString = [[NSString alloc] initWithData:competitionOrdersJsonData encoding:NSUTF8StringEncoding];
    
    NSArray *partsIdsJson = @[
                          @"eebd768a-8755-4b20-97c5-0267a45f6de6"
                          ];
    NSData *partsIdsJsonData = [NSJSONSerialization dataWithJSONObject:partsIdsJson options:NSJSONWritingPrettyPrinted error:&error];
    NSString *partsIdsJsonDataJsonString = [[NSString alloc] initWithData:partsIdsJsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *paramDict = @{
                                @"CompetitionOrderJson":competitionOrdersJsonDataJsonString,
                                @"PartsIds":partsIdsJsonDataJsonString
                                };
    NSLog(@"dic = %@", paramDict);
    
    
    [ApplicationDelegate.httpManager POST:urlStr
                               parameters:paramDict
                                 progress:^(NSProgress * _Nonnull uploadProgress) {}
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                      //http请求状态
                                      if (task.state == NSURLSessionTaskStateCompleted) {
                                          //            NSDictionary *jsonDic = [JYJSON dictionaryOrArrayWithJSONSData:responseObject];
                                          NSError* error;
                                          NSDictionary* jsonDic = [NSJSONSerialization
                                                                   JSONObjectWithData:responseObject
                                                                   options:kNilOptions
                                                                   error:&error];
                                          if (jsonDic[@"Success"]) {
                                              //成功
                                              NSLog(@"1111111111111%@",jsonDic);
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
