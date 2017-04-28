//
//  ForgetPwdController.m
//  SmartApartment
//
//  Created by Trudian on 16/11/21.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "ForgetPwdController.h"
#import<CommonCrypto/CommonDigest.h>
@interface ForgetPwdController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *keyCode;

@property (weak, nonatomic) IBOutlet UITextField *heiheihei;

@property (weak, nonatomic) IBOutlet UIButton *keyCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *pwdAgain;


@property (weak, nonatomic) IBOutlet UILabel *safeLevel;
@property (weak, nonatomic) IBOutlet UIView *blockOne;
@property (weak, nonatomic) IBOutlet UIView *blockTwo;
@property (weak, nonatomic) IBOutlet UIView *blockThree;
@property (weak, nonatomic) IBOutlet UILabel *blockLabel;
@end

@implementation ForgetPwdController
{
    int coldTime;
    NSTimer *myTimer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    coldTime = 90;
    self.phoneText.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    
//    [self.keyCodeBtn.layer setBorderWidth:1];
    [self.keyCodeBtn.layer setMasksToBounds:YES];
    self.keyCodeBtn.layer.cornerRadius = 5;
    self.heiheihei.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickToSure:(id)sender {
    if (self.phoneText.text.length != 11) {
       [ Alert showFail:@"请填写正确的手机号码！" View:self.navigationController.navigationBar andTime:1.5 complete:^(BOOL isComplete) {
        }];
        return;
    }
    
    if (self.keyCode.text.length <6) {
        [ Alert showFail:@"请填写正确的验证码！" View:self.navigationController.navigationBar andTime:1.5 complete:^(BOOL isComplete) {
        }];
        return;
    }
    if(self.heiheihei.text.length <6||self.heiheihei.text.length>12){
        [Alert showFail:@"密码需要大于5位并小于12位数！" View:self.navigationController.navigationBar andTime:1.5 complete:^(BOOL isComplete) {
        }];
        return;
    }
    if(self.pwdAgain.text.length <6||self.pwdAgain.text.length>12){
        [Alert showFail:@"密码需要大于5位并小于12位数！" View:self.navigationController.navigationBar andTime:1.5 complete:^(BOOL isComplete) {
        }];
        return;
    }
    if (![self.heiheihei.text isEqualToString:self.pwdAgain.text]) {
        
        [Alert showFail:@"两次密码不相同！" View:self.navigationController.navigationBar andTime:1.5 complete:^(BOOL isComplete) {
        }];
        return;
    }
    NSString *md5Pwd = [self md5:self.pwdAgain.text];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:md5Pwd,@"newPassword",self.phoneText.text,@"userPhone",self.keyCode.text,@"smsCode", nil];
    [WebAPI forgetPassword:dic callback:^(NSError *err, id response) {
        NSString  *status =[response objectForKey:@"rcode"];
        if (!err && status.integerValue == 10000) {
            [Alert showSucces:@"新密码设置成功！" View:self.navigationController.navigationBar andTime:1.0f complete:^(BOOL isComplete) {
                NSArray * ctrlArray = self.navigationController.viewControllers;
                for (UIViewController *ctrl in ctrlArray) {
                    if ([NSStringFromClass(ctrl.class) isEqualToString:@"LoginViewController"]) {
                        [self.navigationController popToViewController:ctrl animated:YES];
                    }
                }
            }];
        }
        else{
            
            NSString *string =[response objectForKey:@"rmsg"];
            if (string.length>0) {
                [Alert showFail:string View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
            }else{
                [Alert showFail:@"请求数据超时，请稍后再试" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
            }
        }
    }];
    
}

-(void)coldDown{
    coldTime --;
    [self.keyCodeBtn.titleLabel setText:[NSString stringWithFormat:@"%ld",(long)coldTime]];
    [self.keyCodeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)coldTime] forState:UIControlStateNormal];
    [self.keyCodeBtn setBackgroundColor:[UIColor lightGrayColor]];
    [self.keyCodeBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    if (coldTime<=0) {
        [self.keyCodeBtn setBackgroundImage:[UIImage imageNamed:@"loginBtnBg"] forState:UIControlStateNormal];
        coldTime = 90;
        [self.keyCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        self.keyCodeBtn.userInteractionEnabled = YES;
        [myTimer setFireDate:[NSDate distantFuture]];
    }
    
}
- (IBAction)sendSms:(id)sender {
    if (self.phoneText.text.length != 11) {
           [Alert showFail:@"请填写正确的手机号码！" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
        return;
    }
    self.keyCodeBtn.userInteractionEnabled = NO;
    [myTimer setFireDate:[NSDate distantPast]];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.phoneText.text,@"userPhone", nil];
    [WebAPI sendForgetSMS:dic callback:^(NSError *err, id response) {
        NSString  *status =[response objectForKey:@"rcode"];
        if (!err && status.integerValue == 10000) {
             myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(coldDown) userInfo:nil repeats:YES];
            [myTimer setFireDate:[NSDate distantPast]];
        }else{
            
           RequestBad
        }
        self.keyCodeBtn.userInteractionEnabled = YES;
    }];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.tag == 1) {
        
        [self.tableView reloadData];
        
        self.safeLevel.hidden = NO;
        self.blockOne.hidden = NO;
        self.blockTwo.hidden = NO;
        self.blockThree.hidden = NO;
        self.blockLabel.hidden = NO;
        NSString *pwdLevel = [self judgePasswordStrength:textField.text];
        switch (pwdLevel.integerValue) {
            case 0:
                self.blockOne.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1];
                self.blockLabel.text = @"低";
                self.blockLabel.textColor =[UIColor colorWithRed:229.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1];
                break;
            case 1:
                self.blockOne.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:163.0/255.0 blue:72.0/255.0 alpha:1];
                self.blockTwo.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:163.0/255.0 blue:72.0/255.0 alpha:1];
                self.blockLabel.text = @"中";
                self.blockLabel.textColor = [UIColor colorWithRed:210.0/255.0 green:160.0/255.0 blue:26.0/255.0 alpha:1];
                break;
            case 2:
                self.blockOne.backgroundColor = [UIColor colorWithRed:126.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1];
                self.blockTwo.backgroundColor =  [UIColor colorWithRed:126.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1];
                self.blockThree.backgroundColor = [UIColor colorWithRed:126.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1];
                self.blockLabel.text = @"高";
                self.blockLabel.textColor = [UIColor colorWithRed:65.0/255.0 green:117.0/255.0 blue:5.0/255.0 alpha:1];
                break;
            default:
                break;
        }
        
    }
    
}


- (BOOL) judgeRange:(NSArray*) _termArray Password:(NSString*) _password
{
    NSRange range;
    BOOL result =NO;
    for(int i=0; i<[_termArray count]; i++)
    {
        range = [_password rangeOfString:[_termArray objectAtIndex:i]];
        if(range.location != NSNotFound)
        {
            result =YES;
        }
    }
    return result;
}

//条件
- (NSString*) judgePasswordStrength:(NSString*) _password
{
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    
    NSArray* termArray1 = [[NSArray alloc] initWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil];
    NSArray* termArray2 = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil];
    NSArray* termArray3 = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    NSArray* termArray4 = [[NSArray alloc] initWithObjects:@"~",@"`",@"@",@"#",@"$",@"%",@"^",@"&",@"*",@"(",@")",@"-",@"_",@"+",@"=",@"{",@"}",@"[",@"]",@"|",@":",@";",@"“",@"'",@"‘",@"<",@",",@".",@">",@"?",@"/",@"、", nil];
    NSString* result1 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray1 Password:_password]];
    NSString* result2 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray2 Password:_password]];
    NSString* result3 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray3 Password:_password]];
    NSString* result4 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray4 Password:_password]];
    
    [resultArray addObject:[NSString stringWithFormat:@"%@",result1]];
    [resultArray addObject:[NSString stringWithFormat:@"%@",result2]];
    [resultArray addObject:[NSString stringWithFormat:@"%@",result3]];
    [resultArray addObject:[NSString stringWithFormat:@"%@",result4]];
    int intResult=0;
    for (int j=0; j<[resultArray count]; j++)
    {
        if ([[resultArray objectAtIndex:j] isEqualToString:@"1"])
        {
            intResult++;
        }
    }
    NSString* resultString = [[NSString alloc] init];
    if (intResult < 2)
    {
        resultString = @"0";
    }
    else if (intResult == 2&&[_password length]>=6)
    {
        resultString = @"1";
    }
    if (intResult > 2&&[_password length]>=6)
    {
        resultString = @"2";
    }
    return resultString;
}

- (NSString *)md5:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
