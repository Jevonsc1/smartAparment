//
//  renterPayResultController.m
//  SmartApartment
//
//  Created by Trudian on 16/11/14.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "renterPayResultController.h"

@interface renterPayResultController ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet UILabel *resultLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UIButton *clickPopBtn;

@end

@implementation renterPayResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![self.resultType isEqualToString:@"ok"]) {
        self.moneyLab.hidden = YES;
        [self.icon setImage:[UIImage imageNamed:@"IDSureBad"]];
        [self.resultLab setText:@"支付失败！"];
        [self.resultLab setTextColor:[UIColor colorWithRed:229.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1]];
        
    }else{
        self.moneyLab.text = self.money;
        [self.icon setImage:[UIImage imageNamed:@"IDSureOk"]];
        [self.resultLab setText:@"恭喜你，成功支付！"];
        [self.resultLab setTextColor:[UIColor colorWithRed:81.0/255.0 green:170.0/255.0 blue:54.0/255.0 alpha:1]];
    }
    if ([self.inWay isEqualToString:@"net"]) {
        [self.clickPopBtn setTitle:@"返回公寓宽带" forState:UIControlStateNormal];
        self.title = @"订购宽带";
    }else{
        [self.clickPopBtn setTitle:@"返回费用账单" forState:UIControlStateNormal];
    }
}
- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickToHome:(id)sender {
    [PopHome popToController:@"NewMasterHomeController" andVC:self];
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
