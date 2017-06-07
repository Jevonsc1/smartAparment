//
//  ChangeKeyController.m
//  SmartApartment
//
//  Created by Trudian on 16/10/31.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "ChangeKeyController.h"
#import<CommonCrypto/CommonDigest.h>
@interface ChangeKeyController ()
@property (weak, nonatomic) IBOutlet UIButton *keycodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *keycodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *onePwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *twoPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *threePwdTextField;


@end

@implementation ChangeKeyController
{
    NSTimer *myTimer;
    int coldTime ;
    UserData *homeUser;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    coldTime = 90;
    homeUser = [ModelTool find_UserData];
    myTimer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(coldDown) userInfo:nil repeats:YES];
}
- (IBAction)clickToGetCode:(id)sender {
    [myTimer setFireDate:[NSDate distantPast]];

    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:homeUser.key,@"key", nil];
    [WebAPI sendResetKeyCode:dic callback:^(NSError *err, id response) {
        NSString  *status =[response objectForKey:@"rcode"];
        self.keycodeBtn.userInteractionEnabled = NO;
        if (!err && status.integerValue == 10000) {
            [Alert showSucces:@"验证码已发送" View:self.navigationController.navigationBar andTime:2.0f complete:^(BOOL isComplete) {}];
            [myTimer setFireDate:[NSDate distantPast]];
        }else{
            self.keycodeBtn.userInteractionEnabled = YES;
            if (err) {
                
                [Alert showFail:@"服务器异常！" View:self.navigationController.navigationBar andTime:1.5 complete:^(BOOL isComplete) {
                }];
            }else{
              
                RequestBad
            }
        }
    }];
}
//倒计时
-(void)coldDown{
    coldTime --;
    self.keycodeBtn.titleLabel.text =[NSString stringWithFormat:@"%d秒",coldTime];
    [self.keycodeBtn setTitle:[NSString stringWithFormat:@"%d秒",coldTime] forState:UIControlStateNormal];
    if(coldTime <= 0 ){
        [self.keycodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        coldTime = 90;
        self.keycodeBtn.enabled = YES;
        [myTimer setFireDate:[NSDate distantFuture]];
    }
}
- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -m 修改密码
- (IBAction)clickToResetPwd:(UIButton *)sender {
    if (![self.twoPwdTextField.text isEqualToString:self.threePwdTextField.text]) {
       
        [Alert showFail:@"两次密码不相同！"  View:self.navigationController.navigationBar andTime:1.5 complete:^(BOOL isComplete) {
        }];
        return;
    }
    if (self.twoPwdTextField.text.length<6||self.threePwdTextField.text.length>12 ) {
      
        [Alert showFail:@"密码长度需要大于5位并且小于13位数！"  View:self.navigationController.navigationBar andTime:1.5 complete:^(BOOL isComplete) {
        }];
        return;
    }
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:homeUser.key,@"key",[self md5:self.onePwdTextField.text],@"oldPassword",self.keycodeTextField.text,@"smsCode",[self md5:self.threePwdTextField.text],@"newPassword",nil];
    sender.enabled = NO;
    [WebAPI userChangePassword:dic callback:^(NSError *err, id response) {
        NSString  *status =[response objectForKey:@"rcode"];
        if (!err && status.integerValue == 10000) {
            [Alert showSucces:@"密码修改成功!" View:self.view andTime:2.0f complete:^(BOOL isComplete) {
                homeUser.password = self.threePwdTextField.text;
                NSArray * ctrlArray = self.navigationController.viewControllers;
                for (UIViewController *ctrl in ctrlArray) {
                    if ([NSStringFromClass(ctrl.class) isEqualToString:@"SelectPersonController"]) {
                        [self.navigationController popToViewController:ctrl animated:YES];
                    }
                }
            }];
        }else{
            if (err) {
                
                [Alert showFail:@"服务器异常！" View:self.navigationController.navigationBar andTime:1.5 complete:^(BOOL isComplete) {
                }];
            }else{
              
                RequestBad
            }
        }
        
        sender.enabled = YES;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;
}
- (NSString *)md5:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end
