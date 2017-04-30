//
//  SignRoomOKController.m
//  SmartApartment
//
//  Created by Trudian on 16/12/28.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "SignRoomOKController.h"
#import "CheckSignRoomController.h"
#import "NewAddRenterController.h"
@interface SignRoomOKController ()
@property (weak, nonatomic) IBOutlet UILabel *roomAddress;
@property (weak, nonatomic) IBOutlet UILabel *renterName;
@property (weak, nonatomic) IBOutlet UILabel *rentTimeLabel;

@end

@implementation SignRoomOKController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.roomAddress.text = [NSString stringWithFormat:@"%@ %@房",self.communityName,self.house.houseNum];
    self.renterName.text = self.mainRenter;
    self.rentTimeLabel.text = self.rentTime;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationItem setHidesBackButton:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)checkDetail:(id)sender {
    CheckSignRoomController *vc = [[UIStoryboard storyboardWithName:@"SignRoom" bundle:nil] instantiateViewControllerWithIdentifier:@"CheckSignRoom"];
    vc.houseID = self.house.houseID.stringValue;
    vc.communityName = self.communityName;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 跳转添加租客界面

 */
- (IBAction)clickToAddRenter:(id)sender {
    NewAddRenterController *vc = [[UIStoryboard storyboardWithName:@"SignRoom" bundle:nil] instantiateViewControllerWithIdentifier:@"NewAddRenter"];
    vc.house = self.house;
    [self.navigationController pushViewController:vc animated:YES];
    
}

/**
 返回到首页

 */
- (IBAction)clickToHomePage:(id)sender {
    [PopHome popToController:@"NewMasterHomeController" andVC:self];
}

/**
 查看租客列表

 */
- (IBAction)clickToRoomList:(id)sender {
    CommunityRelation* communityRelation = self.house.communityRelationInfo[0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getApartmentList" object:communityRelation.houseCommunityID];
    [PopHome popToController:@"GetRoomListController" andVC:self];
}

@end
