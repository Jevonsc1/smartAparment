//
//  GetKeyCodeController.m
//  SmartApartment
//
//  Created by Trudian on 16/10/31.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "GetKeyCodeController.h"
#import "SetNewPwdController.h"
@interface GetKeyCodeController ()
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *getSMSbtn;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UITextField *smsCode;

@end

@implementation GetKeyCodeController
{
    NSInteger coldTime;
    NSTimer *myTimer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    coldTime = 90;
    self.tipsLabel.hidden = YES;
    self.phoneLabel.hidden = YES;
    myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(coldDown) userInfo:nil repeats:YES];
    self.phoneLabel.text=  [NSString stringWithFormat:@"+86 %@",self.phoneNum];
}
- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [myTimer setFireDate:[NSDate distantPast]];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.phoneNum,@"userPhone", nil];
    [WebAPI sendForgetSMS:dic callback:^(NSError *err, id response) {
        NSString  *status =[response objectForKey:@"rcode"];
        if (!err && status.integerValue == 10000) {
            self.tipsLabel.hidden  = NO;
            self.phoneLabel.hidden = NO;
        }else{
          
            RequestBad
            
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)resendSMS:(id)sender {
    self.getSMSbtn.enabled = NO;
    [myTimer setFireDate:[NSDate distantPast]];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.phoneNum,@"userPhone", nil];
    [WebAPI sendForgetSMS:dic callback:^(NSError *err, id response) {
        NSString  *status =[response objectForKey:@"rcode"];
        if (!err && status.integerValue == 10000) {
            self.tipsLabel.hidden  = NO;
            self.phoneLabel.hidden = NO;
        }else{
           
            RequestBad
        }
    }];
}
-(void)coldDown{
    coldTime --;
    [self.getSMSbtn.titleLabel setText:[NSString stringWithFormat:@"%ld秒后重新获取",(long)coldTime]];
    [self.getSMSbtn setTitle:[NSString stringWithFormat:@"%ld秒后重新获取",(long)coldTime] forState:UIControlStateNormal];
    if (coldTime<=0) {
        [self.getSMSbtn setBackgroundImage:[UIImage imageNamed:@"loginBtnBg"] forState:UIControlStateNormal];
        coldTime = 90;
        [self.getSMSbtn setTitle:@"重新获取" forState:UIControlStateNormal];
        self.getSMSbtn.enabled = YES;
        [myTimer setFireDate:[NSDate distantFuture]];
    }
   
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)clickToNextStep:(id)sender {
    if ([self.smsCode.text isEqualToString:@"请输入验证码"]) {
       
        [Alert showFail:@"请输入验证码" View:self.navigationController.navigationBar andTime:1.5 complete:^(BOOL isComplete) {
        }];
        return;
    }
    SetNewPwdController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"SetNewPwd"];
    vc.smsCode = self.smsCode.text;
    vc.phone = self.phoneNum;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
