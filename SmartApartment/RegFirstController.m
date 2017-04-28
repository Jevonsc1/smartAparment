//
//  RegFirstController.m
//  SmartApartment
//
//  Created by Trudian on 16/10/25.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "RegFirstController.h"
#import<CommonCrypto/CommonDigest.h>
#import "JPUSHService.h"
//#import "SelectIDMsgController.h"
@interface RegFirstController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *keyCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstPwdTextField;
@property (weak, nonatomic) IBOutlet UITableViewCell *nickCell;

@property (weak, nonatomic) IBOutlet UILabel *safeLevel;

@property (weak, nonatomic) IBOutlet UILabel *blockLabel;

@property (weak, nonatomic) IBOutlet UITableViewCell *pwdCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *twoPwdCell;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threePwdAutoTrail;

@property (strong, nonatomic) IBOutlet UIImageView *oneImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blockLabelAutoTrail;


@end

@implementation RegFirstController
{
    NSTimer *timer;
    int timeCount;
    //验证码
    NSString *keyCode;
    
    BOOL editPwd;
    
    UIImageView *twoImage;
    UIImageView *threeImage;
    UserData *userData;
    NSDictionary *userDic;
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    timeCount = 60;
//    self.firstPwdTextField.delegate = self;
    editPwd = NO;
    self.oneImage =  [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20*ratio, 20*ratio)];
    twoImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.oneImage.x, self.oneImage.y, 20*ratio, 20*ratio)];
    threeImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.oneImage.x, self.oneImage.y, 20*ratio, 20*ratio)];
  
    threeImage.hidden =YES;
    twoImage.hidden = YES;
    self.oneImage.hidden = YES;
    [self.nickCell addSubview:self.oneImage];
    [self.pwdCell addSubview:twoImage];
    [self.twoPwdCell addSubview:threeImage];
    [self.firstPwdTextField addTarget:self  action:@selector(changeValue)  forControlEvents:UIControlEventEditingChanged];
    [self.pwdTextField addTarget:self action:@selector(twoChangeValue) forControlEvents:UIControlEventEditingChanged];
   
}
-(void)changeValue {

    
        if (self.firstPwdTextField.text.length == 0) {
            twoImage.hidden = YES;
            [self.blockLabelAutoTrail setConstant:-7];
            self.safeLevel.hidden = YES;
            
            self.blockLabel.hidden = YES;
        }
    
}

-(void)twoChangeValue {
    if (self.pwdTextField.text.length == 0) {
        threeImage.hidden = YES;
        self.threePwdAutoTrail.constant = 8;
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 1) {
        self.oneImage.hidden = NO;
        self.oneImage.frame = CGRectMake(self.view.width - 5-20*ratio, 50*ratio /2 -20*ratio/2, 20*ratio, 20*ratio);
        if (textField.text.length<=10&&textField.text.length>0 ) {
            
            [self.oneImage setImage:[UIImage imageNamed:@"right_icon"]];
        }
        else{
            [self.oneImage setImage:[UIImage imageNamed:@"noAc"]];
        }
    }
  
    if(textField.tag == 3){
         threeImage.hidden = NO;
           threeImage.frame = CGRectMake(self.view.width - 5-20*ratio, 50*ratio /2 -20*ratio/2, 20*ratio, 20*ratio);
        self.threePwdAutoTrail.constant = 32;
        if ([self.firstPwdTextField.text isEqualToString:self.pwdTextField.text]) {
            if (self.pwdTextField.text.length <6||self.pwdTextField.text.length>12) {
                [threeImage setImage:[UIImage imageNamed:@"noAc"]];
            }else{
                [threeImage setImage:[UIImage imageNamed:@"right_icon"]];
            }
        }else{
              [threeImage setImage:[UIImage imageNamed:@"noAc"]];
        }
    }
    if (textField.tag == 2) {
        if (textField.text.length == 0) {
            twoImage.hidden = YES;
             [self.blockLabelAutoTrail setConstant:-7];
            self.safeLevel.hidden = YES;
            
            self.blockLabel.hidden = YES;
        }else{
            twoImage.hidden = NO;
            twoImage.frame = CGRectMake(self.view.width - 5-20*ratio, 50*ratio /2 -20*ratio/2, 20*ratio, 20*ratio);
            
            if (self.firstPwdTextField.text.length <6||self.firstPwdTextField.text.length>12) {
                [twoImage setImage:[UIImage imageNamed:@"noAc"]];
                
            }else{
                [twoImage setImage:[UIImage imageNamed:@"right_icon"]];
                [self.blockLabelAutoTrail setConstant:18];
                NSLog(@"%f",self.blockLabelAutoTrail.constant);
                self.safeLevel.hidden = NO;
               
                self.blockLabel.hidden = NO;
                NSString *pwdLevel = [self judgePasswordStrength:textField.text];
                switch (pwdLevel.integerValue) {
                    case 0:

                        self.blockLabel.text = @"低";
                        self.blockLabel.textColor =[UIColor colorWithRed:229.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1];
                        break;
                    case 1:

                        self.blockLabel.text = @"中";
                        self.blockLabel.textColor = [UIColor colorWithRed:210.0/255.0 green:160.0/255.0 blue:26.0/255.0 alpha:1];
                        break;
                    case 2:
                        self.blockLabel.text = @"高";
                        self.blockLabel.textColor = [UIColor colorWithRed:65.0/255.0 green:117.0/255.0 blue:5.0/255.0 alpha:1];
                        break;
                    default:
                        break;
                }
                
            }

        }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
        return 50*ratio;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickToPop:(id)sender {
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 5;
}
#pragma mark -m 确认注册
- (IBAction)sureRegister:(id)sender {
    if (self.nickNameTextField.text.length <= 0) {
      
        [Alert showFail:@"请填写昵称！" View:self.navigationController.navigationBar andTime:2 complete:^(BOOL isComplete) {
        }];
        return;
    }
   
    if (self.nickNameTextField.text.length > 10) {
        
        [Alert showFail:@"昵称不可超过10个字符！" View:self.navigationController.navigationBar andTime:2 complete:^(BOOL isComplete) {
        }];
        return;
    }
    
    if (self.firstPwdTextField.text.length <= 0) {
      
        [Alert showFail:@"请填写密码!" View:self.navigationController.navigationBar andTime:2 complete:^(BOOL isComplete) {
        }];
        return;
    }
    if (self.firstPwdTextField.text.length <6||self.firstPwdTextField.text.length>12) {
        
        [Alert showFail:@"密码长度需要大于5位并且小于13位数！" View:self.navigationController.navigationBar andTime:1.5 complete:^(BOOL isComplete) {
        }];
        return;
    }
    
    if (self.pwdTextField.text.length <= 0) {
       
        [Alert showFail:@"请填写第二次密码！"  View:self.navigationController.navigationBar andTime:2 complete:^(BOOL isComplete) {
        }];
        return;
    }
    if (![self.firstPwdTextField.text isEqualToString:self.pwdTextField.text]) {
        
        
        [Alert showFail:@"两次密码不一致，请检查!" View:self.navigationController.navigationBar andTime:1.5 complete:^(BOOL isComplete) {
        }];
        return;
    }
    if (self.phoneTextField.text.length <= 0) {
      
        [Alert showFail:@"请填写手机号码!" View:self.navigationController.navigationBar andTime:2 complete:^(BOOL isComplete) {
        }];
        return;
    }
    if ([self.keyCodeTextField.text isEqualToString:@""] ) {
       
        [Alert showFail:@"请填写验证码!" View:self.navigationController.navigationBar andTime:2 complete:^(BOOL isComplete) {
        }];
        return;
    }

  
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.keyCodeTextField.text,@"smsCode",self.phoneTextField.text,@"userPhone",self.nickNameTextField.text ,@"userNickName",[self md5:self.pwdTextField.text],@"userPassword",nil];
    [WebAPI registerUser:dic callback:^(NSError *err, id response) {
        NSString  *status =[response objectForKey:@"rcode"];
        if (!err && status.integerValue == 10000) {
            [self.getCodeBtn setEnabled:NO];
            [Alert showSucces:@"注册成功,请登录！" View:self.navigationController.navigationBar andTime:2.0f complete:^(BOOL isComplete) {
                NSDictionary *userDic1 =[[NSDictionary alloc] initWithObjectsAndKeys:self.phoneTextField.text,@"userPhone",[self md5:self.pwdTextField.text],@"userPassword", nil];
                [WebAPI userAccountLogin:userDic1 callback:^(NSError *err, id response) {
                    NSString  *status =[response objectForKey:@"rcode"];
                    if (!err && status.integerValue == 10000) {
                        [[NSUserDefaults standardUserDefaults] setObject:self.phoneTextField.text forKey:@"phone"];
                         userData = [AppTool find_UserData];
                        
                        userDic = [response objectForKey:@"data"];
                        
                        [JPUSHService setAlias:[userDic objectForKey:@"memberAPPID"] callbackSelector:nil object:self];
                        [self saveUserMsg];
                        
//                        [self getTem];
                        self.navigationController.navigationBar.hidden = YES;
//                        SelectIDMsgController *vc = [[UIStoryboard storyboardWithName:@"Authentication" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectIDMsg"];
//                        [self.navigationController pushViewController:vc animated:YES];
                   
                        
                    }else{
                        if(err){
                            [Alert showFail:@"服务器异常！" View:self.navigationController.navigationBar andTime:1.5 complete:^(BOOL isComplete) {
                            }];
                        }else{
                           RequestBad
                        }
                        
                    }
                }];
                
                
            }];
        }else{
            [self.getCodeBtn setEnabled:YES];
            if (err) {
                [Alert showFail:@"服务器异常！" View:self.navigationController.navigationBar andTime:1.5 complete:^(BOOL isComplete) {
                }];

                
            }else if(status.integerValue == 300222){
                
                
                [Alert showFail:@"该号码已被注册!" View:self.navigationController.navigationBar andTime:1.5 complete:^(BOOL isComplete) {
                }];
            }else{
                RequestBad
                
            }
           
        }
    }];
    
}
#pragma mark -m 获取验证码
- (IBAction)getKeyCode:(id)sender {
    if (self.phoneTextField.text.length != 11) {
       
        [Alert showFail:@"请填写手机号码!" View:self.navigationController.navigationBar andTime:1.5 complete:^(BOOL isComplete) {
        }];
        return;
        
    }
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.phoneTextField.text,@"userPhone", nil];
        [WebAPI registerSendCode:dic callback:^(NSError *err, id response) {
        
            NSString  *status =[response objectForKey:@"rcode"];
            if (!err && status.integerValue == 10000) {
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(coldDown) userInfo:nil repeats:YES];
            [self.getCodeBtn setBackgroundColor:[UIColor lightGrayColor]];
            [self.getCodeBtn setBackgroundImage:nil forState:UIControlStateNormal];
            [timer setFireDate:[NSDate distantPast]];
                self.getCodeBtn.userInteractionEnabled = NO;
            }
            else{
            
                RequestBad
                [self.getCodeBtn setEnabled:YES];
            }
    }];
}


#pragma mark -m 倒计时
-(void)coldDown{
    timeCount --;
    [self.getCodeBtn.titleLabel setText:[NSString stringWithFormat:@"%d秒后获取",timeCount]];
    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%d秒后获取",timeCount] forState:UIControlStateNormal];
    if(timeCount <=0){
        timeCount = 60;
        self.getCodeBtn.userInteractionEnabled = YES;
        [self.getCodeBtn setBackgroundImage:[UIImage imageNamed:@"loginBtnBg"] forState:UIControlStateNormal];
        [self.getCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        [timer setFireDate:[NSDate distantFuture]];
    }
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
#pragma mark -m 保存用户信息
-(void) saveUserMsg{
    userData.memberNickName = [userDic objectForKey:@"memberNickName"];
    userData.memberPhone = [userDic objectForKey:@"memberPhone"];
    userData.member_sex = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"memberSex"]].intValue;
    userData.memberAvatar = [userDic objectForKey:@"memberAvatar"];
    userData.memberRegistTime = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"memberRegistTime"]];
    userData.memberAvailablePD = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"memberAvailablePD"]].floatValue;
    userData.memberFreezePD = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"memberFreezePD"]].floatValue;
    userData.memberIsDisable = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"memberIsDisable"] ].intValue;
    [[NSUserDefaults standardUserDefaults] setObject:self.phoneTextField.text forKey:@"phone"];
    userData.key = [userDic objectForKey:@"key"];
    NSLog(@"============%@",userData.key);
    [[NSUserDefaults standardUserDefaults] setObject:userData.key forKey:@"userKey"];
    NSDictionary *masterDic = [userDic objectForKey:@"bo"];
    NSDictionary *renterDic = [userDic objectForKey:@"renter"];
   
        userData.password = self.pwdTextField.text;
    
    if(masterDic.count>0){
        userData.memberType = @"master";
        
        userData.trueName = [masterDic objectForKey:@"boTrueName"];
        userData.boStatus = [NSString stringWithFormat:@"%@",[masterDic objectForKey:@"boStatus"]].intValue;
        userData.idCardNum = [NSString stringWithFormat:@"%@",[masterDic objectForKey:@"boIDCardNum"]];
        if (userData.boStatus == 30) {
            userData.idStatus = @"已认证";
        }else if(userData.boStatus == 10){
            userData.idStatus = @"审核中";
        }else{
            userData.idStatus = @"被驳回";
        }
    }
    else if(renterDic.count > 0){
        userData.memberType = @"renter";
        
        userData.trueName = [renterDic objectForKey:@"renterTrueName"];
        userData.renterStatus = [NSString stringWithFormat:@"%@",[renterDic objectForKey:@"renterStatus"]];
        userData.idCardNum = [NSString stringWithFormat:@"%@",[renterDic objectForKey:@"renterIDCardNum"]];
        if (userData.renterStatus.integerValue == 30) {
            userData.idStatus = @"已认证";
        }else if(userData.renterStatus.integerValue == 10){
            userData.idStatus = @"审核中";
        }else{
            userData.idStatus = @"被驳回";
        }
    }else{
        userData.memberType = @"notype";
        
        userData.idStatus = @"未认证";
        userData.renterStatus = @"0";
        userData.boStatus  = 0;
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

-(void)getTem{
    NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:userData.key,@"key",@"1",@"availableRentRecord",@"2.0",@"version", nil];
    [WebAPI getRentRecordInfo:dic1 callback:^(NSError *err, id response) {
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            NSArray *arr = [response objectForKey:@"data"];
            if (arr.count > 0) {
                NSString *   rentRecordId = [[arr[0] objectForKey:@"houseInfo"] objectForKey:@"houseID"];
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:userData.key,@"key",rentRecordId,@"houseID", nil];
                [WebAPI getCurrentTelecomInfo:dic callback:^(NSError *err, id response) {
                    if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
                        NSArray *wifiArr = [response objectForKey:@"data"];
                        if (wifiArr.count>0&&wifiArr != nil) {
                            
                            NSString *telStates = [[response objectForKey:@"data"][0] objectForKey:@"telecomStatus"];
                            NSString *telOrder = [[[response objectForKey:@"data"][0] objectForKey:@"order"] objectForKey:@"orderState"];
                            if (telStates.integerValue == 0&& telOrder.integerValue == 10 ) {
                                userData.isOpenNet = @"no";
                            }else if (telStates.integerValue == 0 && telOrder.integerValue == 20){
                                userData.isOpenNet = @"wait";
                            }
                            else{
                                userData.isOpenNet = @"yes";
                                [[NSUserDefaults standardUserDefaults] setObject:rentRecordId forKey:@"rentRecordId"];
                            }
                            
                            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                        }
                        
                    }else{
                        if (err) {
                            [Alert showFail:@"网络异常，请检查网络！" View:self.navigationController.navigationBar andTime:1 complete:^(BOOL isComplete) {
                                
                            }];
                        }else{
                            RequestBad
                        }
                        
                    }
                
                }];
            }
        }
        else{
            if (![userData.memberType isEqualToString:@"master"] ) {
               RequestBad             }
            
        }
      
    }];
    
}

@end
