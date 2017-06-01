//
//  AccountBookController.m
//  SmartApartment
//
//  Created by Trudian on 17/1/9.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "AccountBookController.h"
#import "AllAccountController.h"
#import "ApartmentBillController.h"
#import "GetRoomListController.h"
@interface AccountBookController ()
@property (weak, nonatomic) IBOutlet UILabel *waitPay;
@property (weak, nonatomic) IBOutlet UILabel *hadPay;
@property (weak, nonatomic) IBOutlet UILabel *overTime;


@end

@implementation AccountBookController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}
-(void)viewWillAppear:(BOOL)animated{
    
     self.navigationController.navigationBar.hidden = YES;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key", nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //获取账本的金额
    [WebAPI getAccountBook:dic callback:^(NSError *err, id response) {
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            NSDictionary *dataDic = [response objectForKey:@"data"];
            self.waitPay.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"dueInTotal"]];
            self.hadPay.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"incomeTotal"]];
            self.overTime.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"overTimeTotal"]];
        }else{
            RequestBad
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//点击进入历史账单
- (IBAction)clickToHistory:(id)sender {
    GetRoomListController *vc = [[UIStoryboard storyboardWithName:@"AccountBook" bundle:nil] instantiateViewControllerWithIdentifier:@"GetRoomList"];
    self.navigationController.navigationBar.hidden = NO;
    vc.wayIn = @"Account";
    vc.apartmentArr = self.communityArray;
    [self.navigationController pushViewController:vc animated:YES];
}

//点击进入待缴账本
- (IBAction)clickToWaitPay:(id)sender {
    self.navigationController.navigationBar.hidden = NO;
    AllAccountController *vc = [[UIStoryboard storyboardWithName:@"AccountBook" bundle:nil] instantiateViewControllerWithIdentifier:@"AllAccount"];
    vc.wayIn = @"waitPay";
    [self.navigationController pushViewController:vc animated:YES];
}

//点击进入已收账单
- (IBAction)clickToHavePay:(id)sender {
    self.navigationController.navigationBar.hidden = NO;
    AllAccountController *vc = [[UIStoryboard storyboardWithName:@"AccountBook" bundle:nil] instantiateViewControllerWithIdentifier:@"AllAccount"];
    vc.wayIn = @"hadPay";
    [self.navigationController pushViewController:vc animated:YES];
}

//点击进入当前账单
- (IBAction)clickToNowBill:(id)sender {
    self.navigationController.navigationBar.hidden = NO;
    ApartmentBillController *vc = [[UIStoryboard storyboardWithName:@"ApartmentBill" bundle:nil] instantiateViewControllerWithIdentifier:@"ApartmentBill"];
    [self.navigationController pushViewController:vc animated:YES];
    [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"formNotif"];    
    
}

//点击进入逾期缴费的账本
- (IBAction)clickToOverTimePay:(id)sender {
    self.navigationController.navigationBar.hidden = NO;
    AllAccountController *vc = [[UIStoryboard storyboardWithName:@"AccountBook" bundle:nil] instantiateViewControllerWithIdentifier:@"AllAccount"];
    vc.wayIn = @"overTime";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickToAccoutRoom:(id)sender {
    [MBProgressHUD showMessage:@"功能暂未开放，敬请期待!"];
}
- (IBAction)clickToBook:(id)sender {
    [MBProgressHUD showMessage:@"功能暂未开放，敬请期待!"];
}

- (IBAction)clickToWaterDian:(id)sender {
    [MBProgressHUD showMessage:@"功能暂未开放，敬请期待!"];
}




@end
