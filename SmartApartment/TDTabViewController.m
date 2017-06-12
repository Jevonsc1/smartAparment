//
//  HCHTabViewController.m
//  HuiChengHang
//
//  Created by ZhengJevons on 15/12/21.
//  Copyright © 2015年 ZhengJevons. All rights reserved.
//

#import "TDTabViewController.h"
#import "MyTabBar.h"
#import "LoginViewController.h"
#import "NewMasterHomeController.h"
#import "FBBLECentralManager.h"
#import "TDBLENodeTool.h"
#define MyColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface TDTabViewController () <MyTabBarDelegate,FBBLECentralManagerDelegate>
@property(nonatomic,strong)MyTabBar* myTabBar;
@property(nonatomic,strong)UserData* userdata;

@end

@implementation TDTabViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTabBar];
    [self setup];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.userdata = [ModelTool find_UserData];
    if ([self.userdata.key isEqualToString:@""] || !self.userdata.key || [self.userdata.memberType isEqualToString:@"notype"]) {
        UINavigationController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNav"];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

-(void)setupTabBar{

    MyTabBar *selfBar = [[MyTabBar alloc]init];
    selfBar.delegate = self;
    selfBar.myTabBarDelegate = self;
    [self setValue:selfBar forKey:@"tabBar"];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:MyColor(148, 148, 148),NSForegroundColorAttributeName, nil] forState:UIControlStateNormal] ;
    
    [[UITabBarItem appearance] setTitleTextAttributes:                                                         [NSDictionary dictionaryWithObjectsAndKeys:MyColor(46, 132, 244),NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];

}

-(void)tabbarWithMiddleButtonClick:(MyTabBar *)tabBar{
    [FBBLECentralManager shareInsatance].delegate = self;
    tabBar.middleButton.selected = YES;
    [[FBBLECentralManager shareInsatance] startScanWithButton:tabBar.middleButton];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
}
-(void)setup{

    
    
    UINavigationController *vc = [[UIStoryboard storyboardWithName:@"UserHome" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeNv"];
  
    [self setupController:vc title:nil image:[UIImage imageNamed:@"tab1"] selectedImage:[UIImage imageNamed:@"tab1_select"]];

    UINavigationController *vc2 = [[UIStoryboard storyboardWithName:@"UserHome" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonNv"];
   
    
    [self setupController:vc2 title:nil image:[UIImage imageNamed:@"tab2"] selectedImage:[UIImage imageNamed:@"tab2_select"]];

}



-(void)setupController:(UIViewController*)viewController title:(NSString*)title image:(UIImage*) image selectedImage:(UIImage*)selectedImage{
    [self addChildViewController:viewController];
    
    UITabBarItem* item = [[UITabBarItem alloc]initWithTitle:title image:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    item.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
    viewController.tabBarItem = item;
    
}



-(void)fbBleCentralManagerDelegateUploadDoorRecord:(NSString *)localID{
    [[TDBLENodeTool manager]uploadDoorData:localID];
}

-(void)fbBleCentralManagerDelegateActivateRedbag{
    //开门成功展示红包
}


@end
