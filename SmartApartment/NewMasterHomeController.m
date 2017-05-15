//
//  NewMasterHomeController.m
//  SmartApartment
//
//  Created by Trudian on 16/10/25.
//  Copyright © 2016年 Trudian. All rights reserved.
//  首页判断

#import "NewMasterHomeController.h"
//#import "IDMsgUploadController.h"
#import "LoginViewController.h"
#import "GetRoomListController.h"
#import "SAapartmentViewController.h"
//#import "WifiHomeController.h"
//#import "renterListController.h"
//#import "roomRentersController.h"
//#import "renterPayController.h"
//#import "MasterPayController.h"
//#import "renterRoomController.h"
//#import "ApertmantController.h"
//#import "CheckMessageController.h"
//#import "DoorOpenController.h"
//#import "SelectIDMsgController.h"

//#import "MasterSelfController.h"
//#import "MasterIDPassController.h"
//#import "RenterIDPassController.h"
//#import "IDSureResultController.h"
//#import "SAapartmentViewController.h"
//#import "PayWifiController.h"

//#import <CoreBluetooth/CoreBluetooth.h>
//#import "SAaddApartmentTableviewController.h"
//#import "AccountBookController.h"
//#import "YKLoopView.h"
//#import "NeedRentRoomController.h"
//#import "RenterBillController.h"
#import "AccessListController.h"

#import "EntryRecordController.h"
//#import "FBBLECentralManager.h"//蓝牙
//#import "TDBLENodeTool.h"//上传蓝牙记录
//--------二期类-------------//
//#import "CheckHomeController.h"
//#import "ApartmentBillController.h"

//#import "TDBroadbandViewController.h"
//#import "TDOrderInfoViewController.h"
//#import "TDOrderFinishedViewController.h"
//#import "TDPricingPackageListViewController.h"
//#import "TDMyDoorCardListViewController.h"

#import "Community.h"
#import "YYModel.h"
#define viewHeight  125*ratio
@interface NewMasterHomeController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneTitleAutoLead;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollAutoHeight;
@property (weak, nonatomic) IBOutlet UIView *oneView;

//@property(nonatomic,strong)FBBLECentralManager *bleCentralManager;

@property (nonatomic,strong)UIAlertController *alertController;//提示蓝牙没打开

@property (weak, nonatomic) IBOutlet UIView *sixView;
//第一个view的autoheight
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneViewAutoHeight;

@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *masterView;
@property (weak, nonatomic) IBOutlet UIView *renterView;

@property(nonatomic,strong)NSMutableArray *communityArr;
@end

@implementation NewMasterHomeController
{
    //用户身份
    NSString *appUser;
    //是否第一次注册
    BOOL isFirstRegist;
    
}
-(NSMutableArray *)communityArr{
    if (!_communityArr) {
        _communityArr = [NSMutableArray array];
    }
    return _communityArr;
}

-(void)viewDidAppear:(BOOL)animated{
    
    self.scrollview.scrollEnabled = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏的颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0/255.0 green:98.0/255.0 blue:191.0/255.0 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController setNavigationBarHidden:YES];
    //添加一个黑色view在状态栏中
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
    [navView setBackgroundColor: [UIColor blackColor]];
    [self.navigationController.navigationBar addSubview:navView];
    [self.oneViewAutoHeight setConstant:(self.view.height - self.bannerView.height -49)/3];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowBLMessage:) name:@"ShowBLMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HideBLMessage:) name:@"HideBLMessage" object:nil];
    [self initBannerScroll];
    //添加跳转到宽带的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickToTDOrder) name:@"gotoNetWork" object:nil];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self initUIShow];
    //上传蓝牙开门记录
//    [[TDBLENodeTool manager]uploadDoorDataFromDB];
    //首页：开启蓝牙服务
//    [self initBLEManager];
}

-(void)initUIShow{
    //根据 MemberType隐藏或显示租客屋主界面
    if ([[ModelTool find_UserData].memberType isEqualToString:@"master"]) {
        self.masterView.hidden= NO;
        self.renterView.hidden= YES;
    }else {
        self.masterView.hidden= YES;
        self.renterView.hidden= NO;
    }
    [ self.oneViewAutoHeight setConstant:viewHeight];
    if (![[ModelTool find_UserData].memberType isEqualToString:@"agency"]) {
        if ([[ModelTool find_UserData].memberType isEqualToString:@"notype"]&&[ModelTool find_UserData].boStatus == 0 && [ModelTool find_UserData].renterStatus.integerValue == 0) {
            isFirstRegist = true;
        }else{
            isFirstRegist = false;
            if ([[ModelTool find_UserData].memberType isEqualToString:@"master"]) {
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[ModelTool find_UserData].key,@"key",@"9999",@"pageSize", nil];
                [WebAPI getCommunityInfoList:dic callback:^(NSError *err, id response) {
                    
                    if(!err && [response intForKey:@"rcode"] == 10000){
                        NSArray* comArr = [response objectForKey:@"data"];
                        int index = 0;
                        [self.communityArr removeAllObjects];
                        for (NSDictionary* dic in comArr ) {
                            Community* community = [Community yy_modelWithDictionary:dic];
                            if (index == 0) {
                                [[NSUserDefaults standardUserDefaults] setObject:community.communityID forKey:@"comID"];
                            }
                            index++;
                            [self.communityArr addObject:community];
                        }
                    }
                }];
            }
        }
    }
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.tabBarController.tabBar.hidden = NO;
    [self.scrollAutoHeight setConstant:self.view.frame.size.height+64];
    
    
    
}




-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO] ;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-------------------------------二期修改-------------------------------//
//创建scrollivew
-(void)initBannerScroll{
    NSLog(@"创建滚动栏");

    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner"]];
    [image setFrame:CGRectMake(0, 0, self.view.width, self.bannerView.height *ratio)];
    [self.bannerView addSubview:image];
}
//- (void)loopViewDidSelectedImage:(YKLoopView *)loopView index:(int)index{
//    NSLog(@"%d",index);
//}

//点击公寓抄表
- (IBAction)ClickToCheckRead:(id)sender {
    
    if ([[ModelTool find_UserData].memberType isEqualToString:@"master"]) {
        self.tabBarController.tabBar.hidden = YES;
//        CheckHomeController *vc = [[UIStoryboard storyboardWithName:@"CheckRead" bundle:nil] instantiateViewControllerWithIdentifier:@"CheckHome"];
//        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
    }
}
//点击公寓账单
- (IBAction)ClickToApartmentBill:(id)sender {
    self.tabBarController.tabBar.hidden = YES;
    
    if ([[ModelTool find_UserData].memberType isEqualToString:@"master"]) {
        
//        ApartmentBillController *vc = [[UIStoryboard storyboardWithName:@"ApartmentBill" bundle:nil] instantiateViewControllerWithIdentifier:@"ApartmentBill"];
//        [self.navigationController pushViewController:vc animated:YES];
//        [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"formNotif"];
//        
        
    }else if([[ModelTool find_UserData].memberType isEqualToString:@"renter"] ){
        
        
//        RenterBillController *vc = [[UIStoryboard storyboardWithName:@"RenterBill" bundle:  nil] instantiateViewControllerWithIdentifier:@"RenterBill"];
//        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}
//点击我的公寓
- (IBAction)ClickToApartment:(id)sender {
    self.tabBarController.tabBar.hidden = YES;
    if ([[ModelTool find_UserData].memberType isEqualToString:@"master"] ) {
        SAapartmentViewController *vc = [[UIStoryboard storyboardWithName:@"rentHouse" bundle:nil] instantiateViewControllerWithIdentifier:@"Apertmant1"];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
//        renterRoomController *vc = [[UIStoryboard storyboardWithName:@"homeMessage" bundle:nil] instantiateViewControllerWithIdentifier:@"renterRoom"];
//        [self.navigationController pushViewController:vc animated:YES];
    }
}
//点击在线签约
- (IBAction)clickToSign:(id)sender {
    if ([[ModelTool find_UserData].memberType isEqualToString:@"master"]) {
        GetRoomListController *vc = [[UIStoryboard storyboardWithName:@"SignRoom" bundle:nil] instantiateViewControllerWithIdentifier:@"GetRoomList"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
    }
}

//租客列表
- (IBAction)ClickToRenterList:(id)sender {
    self.tabBarController.tabBar.hidden = YES;
    if ( [[ModelTool find_UserData].memberType isEqualToString:@"master"]) {
        //        if ([ModelTool find_UserData].boStatus == 30) {
        //            renterListController *vc = [[UIStoryboard storyboardWithName:@"renterManager" bundle:nil] instantiateViewControllerWithIdentifier:@"renterList"];
        //            [self.navigationController pushViewController:vc animated:YES];
        //        }else if ([ModelTool find_UserData].boStatus == 20){
        //            [self FailToIDSure];
        //        }else{
        //            [self WaittoIDSure];
        //        }
        //
        //-----------------跳转到新的租客门禁-------------//
        AccessListController *vc = [[UIStoryboard storyboardWithName:@"AccessControl" bundle:nil] instantiateViewControllerWithIdentifier:@"AccessList"];
        vc.communityArray = self.communityArr;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //        if ([ModelTool find_UserData].renterStatus.integerValue == 30) {
//        roomRentersController *vc = [[UIStoryboard storyboardWithName:@"renterManager" bundle:nil] instantiateViewControllerWithIdentifier:@"roomRenters"];
//        vc.inWay = @"byRenter";
//        [self.navigationController pushViewController:vc animated:YES];
        //        }else if ([ModelTool find_UserData].renterStatus.integerValue == 20){
        //            [self FailToIDSure];
        //        }else{
        //            [self WaittoIDSure];
        //        }
    }
    
}

-(void)WaittoIDSure{
//    IDSureResultController *vc = [[UIStoryboard storyboardWithName:@"Authentication" bundle:nil] instantiateViewControllerWithIdentifier:@"IDSureResult"];
//    vc.resultType = @"wait";
//    [self.navigationController pushViewController:vc animated:YES];
}
-(void)FailToIDSure{
//    IDSureResultController *vc =[[UIStoryboard storyboardWithName:@"Authentication" bundle:nil] instantiateViewControllerWithIdentifier:@"IDSureResult"];
//    vc.resultType = @"fail";
//    [self.navigationController pushViewController:vc animated:YES];
}

/**
 公寓宽带
 
 @param sender UIButton
 */
- (IBAction)clickToNetWork:(id)sender {
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"];
    NSDictionary *dictionary = @{@"key":key,
                                 @"version":@"2.0"};
    [self.view showHUD];
    [WebAPIForBroadband loadTelecomOrderInfo:dictionary callback:^(NSError *err, id response) {
        
        NSString *code = [response objectForKey:@"rcode"];
        if ([code integerValue] == 10000) {
            NSDictionary *result = [response objectForKey:@"data"];
            //NSLog(@"%@",result);
            
            if ([result count] > 0) {
                if ([result intForKey:@"orderState"] == 20) {
//                    TDOrderFinishedViewController *controller = [[TDOrderFinishedViewController alloc] init];
//                    controller.dictionary = result;
//                    [self.navigationController pushViewController:controller animated:YES];
                }else if ([result intForKey:@"orderState"] == 0 || [result intForKey:@"orderState"] == 10) {
//                    TDOrderInfoViewController *controller = [[TDOrderInfoViewController alloc] init];
//                    controller.dictionary = result;
//                    [self.navigationController pushViewController:controller animated:YES];
                }else {
//                    TDPricingPackageListViewController *controller = [[TDPricingPackageListViewController alloc] init];
//                    [self.navigationController pushViewController:controller animated:YES];
                }
            }else {
//                TDBroadbandViewController *controller = [[TDBroadbandViewController alloc] init];
//                [self.navigationController pushViewController:controller animated:YES];
            }
            [self.tabBarController.tabBar setHidden:YES];
        }else {
            RequestBadByNoNav
        }
        [self.view hideHUD];
    }];
}

/**
 我的门卡
 
 @param sender UIButton
 */
- (IBAction)clickToMyICCard:(id)sender {
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",@"2.0",@"version", nil];
    
    [self.view showHUD];
    [WebAPI getRentRecordInfo:dic callback:^(NSError *err, id response) {
        
        if (err) {
            NSLog(@"%@",err.domain);
            [self.view updateHUDWithText:err.domain];
            return ;
        }
        
        if ([[response objectForKey:@"rcode"] integerValue] != 10000 ) {
            NSLog(@"%@",[response objectForKey:@"rmsg"]);
            [self.view updateHUDWithText:[response objectForKey:@"rmsg"]];
            return;
        }
        
        NSArray *result = [response arrayForKey:@"data"];
        NSDictionary *rentInfo = [result dictionaryAtIndex:0];
        NSArray *rentInfos = [rentInfo arrayForKey:@"rentInfo"];
        NSDictionary *renterInfo = [rentInfos dictionaryAtIndex:0];
        NSArray *renterInfos = [renterInfo arrayForKey:@"renterInfo"];
        NSDictionary *dict = [renterInfos dictionaryAtIndex:0];
        NSString *houseID = [dict stringForKey:@"houseID"];
        if (!houseID || [houseID isEqualToString:@""]) {
            renterInfo = [rentInfos dictionaryAtIndex:1];
            renterInfos = [renterInfo arrayForKey:@"renterInfo"];
            dict = [renterInfos dictionaryAtIndex:0];
            houseID = [dict stringForKey:@"houseID"];
        }
        if (![houseID isEqualToString:@""]) {
//            TDMyDoorCardListViewController *controller = [[TDMyDoorCardListViewController alloc] init];
//            controller.houseID = houseID;
//            [self.navigationController pushViewController:controller animated:YES];
//            [self.tabBarController.tabBar setHidden:YES];
        }
        [self.view hideHUD];
    }];
}

-(void)clickToTDOrder{
//    TDOrderFinishedViewController *controller = [[TDOrderFinishedViewController alloc] init];
//    controller.wayIn = @"network_noti";
//    [self.navigationController pushViewController:controller animated:YES];
}
//跳转到我要租房模块
- (IBAction)clickToRentRoom:(id)sender {
//    NeedRentRoomController *vc = [[UIStoryboard storyboardWithName:@"SearchRoom" bundle:nil] instantiateViewControllerWithIdentifier:@"NeedRentRoom"];
//    self.tabBarController.tabBar.hidden = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}
//跳转到我的账本
- (IBAction)clickToAccountBook:(id)sender {
//    AccountBookController *vc = [[UIStoryboard storyboardWithName:@"AccountBook" bundle:nil] instantiateViewControllerWithIdentifier:@"AccountBook"];
//    self.tabBarController.tabBar.hidden = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//    
}
//跳转到出入记录
- (IBAction)clickToEntryRecord:(id)sender {
    EntryRecordController *vc = [[UIStoryboard storyboardWithName:@"EntryRecord" bundle:nil] instantiateViewControllerWithIdentifier:@"EntryRecord"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.communityArray = self.communityArr;
    [self.navigationController pushViewController:vc animated:YES];
}
//跳转到门禁管理
//- (IBAction)clickToAccessManager:(id)sender {
//    AccessListController *vc = [[UIStoryboard storyboardWithName:@"AccessControl" bundle:nil] instantiateViewControllerWithIdentifier:@"AccessList"];
//    self.tabBarController.tabBar.hidden = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//}


///蓝牙提示信息
-(void)ShowBLMessage:(NSString *)info{
    dispatch_async(dispatch_get_main_queue(), ^{
//        [XHToast showTopWithText:info duration:1.5];
    });
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//        [SVProgressHUD dismiss];
    });
}
-(void)HideBLMessage:(NSNotification *)info{
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        [XHToast showBottomWithText:info.object duration:1.5];
    });
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//        [SVProgressHUD dismiss];
    });
}


@end
