//
//  TDPerfectOrderViewController.m
//  SmartApartment
//
//  Created by 刘靖 on 2017/2/24.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "TDPerfectOrderViewController.h"
#import "TDConfirmOrderViewController.h"

@interface TDPerfectOrderViewController ()
@property (weak, nonatomic) IBOutlet UITextField *realNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation TDPerfectOrderViewController

- (void)submitApplyTelecom {
    
    if (_addressTextView.text.length <5) {
        [Alert showFail:@"地址不得小于5个字" View:self.view andTime:1.5 complete:nil];
        return;
    }
    if (_addressTextView.text.length >35) {
        [Alert showFail:@"地址不得大于35个字" View:self.view andTime:1.5 complete:nil];
        return;
    }
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"];
    NSDictionary *dictionary = @{@"key":key,
                                 @"telecomID":_telecomID,
                                 @"telecomAdvancedPayment":_telecomAdvancedPayment,
                                 @"telecomInstallationFees":_telecomInstallationFees,
                                 @"userTrueName":[_realNameTextField text],
                                 @"userAddress":[_addressTextView text],
                                 @"userPhoneNumber":[_phoneNumberTextField text],
                                 @"version":@"2.0"};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebAPIForBroadband submitApplyTelecom:dictionary callback:^(NSError *err, id response) {
        NSString *code = [response objectForKey:@"rcode"];
        if ([code integerValue] == 10000) {
            NSDictionary *result = [response objectForKey:@"data"];
            [self reloadData:result];
        }else {
            RequestBadByNoNav
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)reloadData:(NSDictionary *)dictionary {
    if (dictionary) {
        UserData *userData = [ModelTool find_UserData];
        if (userData) {
            userData.trueName = [dictionary stringForKey:@"userTrueName"];
            userData.memberPhone = [dictionary stringForKey:@"userPhoneNumber"];
            userData.renterAddress = [dictionary stringForKey:@"userAddress"];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }
        
        TDConfirmOrderViewController *controller = [[TDConfirmOrderViewController alloc] init];
        controller.dictionary = dictionary;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (IBAction)touchUpInside:(UIButton *)button {
    
    if (button == _submitButton) {
        
        if ([[_realNameTextField text] isEqualToString:@""]) {
            [Alert showFail:@"请填写真实姓名!" View:self.view andTime:1.5 complete:nil];
            return;
        }
        if ([[_phoneNumberTextField text] isEqualToString:@""]) {
             [Alert showFail:@"请填写手机号码!" View:self.view andTime:1.5 complete:nil];
            return;
        }
        if ([[_addressTextView text] isEqualToString:@""]) {
             [Alert showFail:@"请填写安装地址!" View:self.view andTime:1.5 complete:nil];
            return;
        }
        
        [self submitApplyTelecom];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"完善订单信息"];
    
//    [_addressTextField setFont:[UIFont systemFontOfSize:13]];
//    [_addressTextField setMinimumFontSize:4];
//    [_addressTextField setAdjustsFontSizeToFitWidth:YES];

    [_submitButton cornerRadius];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UserData *userData = [ModelTool find_UserData];
    if (userData) {
        [_realNameTextField setText:userData.trueName];
        [_phoneNumberTextField setText:userData.memberPhone];
        [_addressTextView setText:userData.renterAddress];
    }
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
