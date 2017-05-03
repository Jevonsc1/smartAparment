//
//  ApertmentRejectController.m
//  SmartApartment
//
//  Created by Trudian on 16/11/30.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "ApertmentRejectController.h"
#import "SAcreditCardCheckVC.h"
@interface ApertmentRejectController ()
@property (weak, nonatomic) IBOutlet UIImageView *authIcon;
@property (weak, nonatomic) IBOutlet UILabel *failLabel;
@property (weak, nonatomic) IBOutlet UILabel *failResult;

@end

@implementation ApertmentRejectController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.failLabel.text = [self.communityDic objectForKey:@"communityAuditSuggestion"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)clickToAuthApartment:(id)sender {
    SAcreditCardCheckVC *vc = [[UIStoryboard storyboardWithName:@"rentHouse" bundle:nil] instantiateViewControllerWithIdentifier:@"SAcreditCardCheckVC"];
    
    vc.apartmentNameString=[self.communityDic objectForKey:@"communityName"];
//
    vc.apartmentAddressString=[self.communityDic objectForKey:@"communityAddress"];
    vc.powerMoneyString=[self.communityDic objectForKey:@"communityElectricUnitPrice"];

    vc.waterMoneyString=[self.communityDic objectForKey:@"communityWaterUnitPrice"];

    vc.keyString=[ModelTool find_UserData].key;
    vc.otherMoneyString=[self.communityDic objectForKey:@"communityOtherChargePrice"];
    vc.otherMoneyDescriptionString=[self.communityDic objectForKey:@"communityOtherChargeDesc"];
    vc.editApart = @"yes";
    vc.comID = [self.communityDic objectForKey:@"communityID"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
