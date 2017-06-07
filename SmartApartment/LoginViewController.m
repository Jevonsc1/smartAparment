//
//  LoginViewController.m
//  SmartApartment
//
//  Created by Trudian on 16/10/25.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "LoginViewController.h"
#import "SelectIDMsgController.h"

#import "RegFirstController.h"

#import "MBProgressHUD.h"

#import "JPUSHService.h"
#import "ForgetPwdController.h"
#import "UMMobClick/MobClick.h"
#import "ResetKeyController.h"

#import "AgencyTabbarController.h"
@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPwd;
@property (weak, nonatomic) IBOutlet UIButton *getNumBtn;
@property (weak, nonatomic) IBOutlet UILabel *wornText;
@property (weak, nonatomic) IBOutlet UIButton *remPwd;
@property (weak, nonatomic) IBOutlet UIImageView *loginViewBg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewAutoHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameBtnAutoLead;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneBtnAutoLead;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *AllLoginViewAutoHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameTextLead;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userPwdTop;
//@property (nonatomic,strong)FBBLECentralManager *bleCentralManager;

@property (strong, nonatomic) NSDictionary *userDic;

@property(nonatomic,strong)UserData* userData;

@property(nonatomic,assign)BOOL isAccount;
@end
//156，183，217
@implementation LoginViewController
{
    NSString *tempName;
    NSString *tempPwd;

    //定时器
    NSTimer *timer;
    //计时
    int coldTime;


}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    //设置默认是账号登录
    _isAccount = true;
    coldTime = 90;
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO];
}
-(void)viewWillAppear:(BOOL)animated{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self initViewAndSet];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -m 初始化
-(void)initViewAndSet{
  
    self.getNumBtn.hidden = YES;
    //设置导航栏的颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.0/255.0 green:101.0/255.0 blue:192.0/255.0 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController setNavigationBarHidden:YES];
    //添加一个黑色view在状态栏中
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
    [navView setBackgroundColor: [UIColor blackColor]];
    [self.navigationController.navigationBar addSubview:navView];

//    [self.userPwdAutoLead setConstant:60.0/320.0*self.view.frame.size.width ];
    [self.userNameBtnAutoLead setConstant:35.0/320.0*self.view.frame.size.width];
    [self.phoneBtnAutoLead setConstant:35.0/320.0*self.view.frame.size.width ];
    [self.loginViewAutoHeight setConstant:104.0/320.0*self.view.frame.size.width ];
    [self.AllLoginViewAutoHeight setConstant:169.0/320.0*self.view.frame.size.width];
    
    if(SCREEN_WIDTH < 350){
        
    }else if(SCREEN_WIDTH > 350 && SCREEN_WIDTH <400){
        self.userPwdTop.constant = 32;
        self.userNameTop.constant = -23;
        self.userNameTextLead.constant = 75;
    }else{
        self.userNameTop.constant = -27;
        self.userPwdTop.constant = 35;
        self.userNameTextLead.constant = 80;
    }
    
    //设置代理
    self.userName.delegate = self;
    self.userPwd.delegate = self;
    self.userName.tintColor = [UIColor whiteColor];
    self.userPwd.tintColor = [UIColor whiteColor];
    //修改输入框的默认文字的颜色
  
    
   self.userData = [ModelTool find_UserData];
    if (self.userData != nil) {
        self.userName.textColor = [UIColor whiteColor];
        self.userPwd.textColor = [UIColor whiteColor];
        self.userName.text = self.userData.memberPhone;
        
        if (self.userData.password.length > 0) {
              [self.remPwd setBackgroundImage:[UIImage imageNamed:@"btnOk"] forState:UIControlStateNormal];
            self.remPwd.tag = 2;
            self.userPwd.text = self.userData.password;
        }else{
            self.userPwd.text = @"";
            [self.remPwd setBackgroundImage:[UIImage imageNamed:@"btnNoOk"] forState:UIControlStateNormal];
            self.remPwd.tag = 1;
        }
        if (self.userData.password == nil) {
            NSString *pwdText = @"请输入密码";
            NSMutableAttributedString *placeholder1 = [[NSMutableAttributedString alloc]initWithString:pwdText];
            [placeholder1 addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithRed:188.0/255.0 green:208.0/255.0 blue:232.0/255.0 alpha:1]
                                 range:NSMakeRange(0, pwdText.length)];
            
            self.userPwd.attributedPlaceholder = placeholder1;
            NSString *pwdText1 = @"请输入手机号码";
            NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:pwdText1];
            [placeholder addAttribute:NSForegroundColorAttributeName
                                value:[UIColor colorWithRed:188.0/255.0 green:208.0/255.0 blue:232.0/255.0 alpha:1]
                                range:NSMakeRange(0, pwdText1.length)];
            
            self.userName.attributedPlaceholder = placeholder;
        }
    }
 
   
}
#pragma mark -m textField的代理方法
-(void)textFieldDidBeginEditing:(UITextField *)textField{
   
 
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
   }
#pragma mark -m 账号登录
- (IBAction)userLogin:(UIButton *)sender {
    [self.loginViewBg setImage:[UIImage imageNamed:@"loginView"]];
    self.userPwd.text = tempPwd;
    _isAccount = true;
    self.getNumBtn.hidden = YES;
    self.userPwd.secureTextEntry = YES;
    NSString *pwdText = @"请输入密码";
    NSMutableAttributedString *placeholder1 = [[NSMutableAttributedString alloc]initWithString:pwdText];
    [placeholder1 addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithRed:188.0/255.0 green:208.0/255.0 blue:232.0/255.0 alpha:1]
                         range:NSMakeRange(0, pwdText.length)];
    
    self.userPwd.attributedPlaceholder = placeholder1;
    NSString *pwdText1 = @"请输入手机号码";
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:pwdText1];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:[UIColor colorWithRed:188.0/255.0 green:208.0/255.0 blue:232.0/255.0 alpha:1]
                        range:NSMakeRange(0, pwdText1.length)];
    
    self.userName.attributedPlaceholder = placeholder;
  }
#pragma mark -m 手机登录
- (IBAction)phoneLogin:(id)sender {
    [self.loginViewBg setImage:[UIImage imageNamed:@"loginView2"]];
    _isAccount = false;
    self.getNumBtn.hidden = NO;
    tempPwd = self.userPwd.text;
    self.userPwd.text = @"";
    self.userPwd.secureTextEntry = NO;
    NSString *pwdText = @"请输入验证码";
    NSMutableAttributedString *placeholder1 = [[NSMutableAttributedString alloc]initWithString:pwdText];
    [placeholder1 addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithRed:188.0/255.0 green:208.0/255.0 blue:232.0/255.0 alpha:1]
                         range:NSMakeRange(0, pwdText.length)];
    
    self.userPwd.attributedPlaceholder = placeholder1;
    NSString *pwdText1 = @"请输入手机号码";
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:pwdText1];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:[UIColor colorWithRed:188.0/255.0 green:208.0/255.0 blue:232.0/255.0 alpha:1]
                        range:NSMakeRange(0, pwdText1.length)];
    
    self.userName.attributedPlaceholder = placeholder;
}
#pragma mark -m 收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark -m 清除用户输入账号

- (IBAction)forgetPwd:(id)sender {
     [[NSUserDefaults standardUserDefaults] setObject:self.userName.text forKey:@"phone"];
    ForgetPwdController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"ForgetPwd"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark -m 手机登录获取验证码
- (IBAction)getUserKey:(id)sender {
    
    if (![AppTool checkPhoneNumInput:self.userName.text]) {
        
        self.wornText.text = @"请输入正确的手机号码！";
      
        return;
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(coldDown) userInfo:nil repeats:YES];
//    [timer setFireDate:[NSDate distantPast]];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.userName.text,@"userPhone", nil];
    
    [WebAPI userPhoneGetCodeLogin:dic callback:^(NSError *err, id response) {
        NSString  *status =[response objectForKey:@"rcode"];
        if (!err && status.integerValue == 10000) {
            self.getNumBtn.userInteractionEnabled = NO;
        }
        else{
            [self.getNumBtn setTitle:@"重新获取" forState:UIControlStateNormal];
            coldTime = 90;
            self.getNumBtn.userInteractionEnabled = YES;
            [timer invalidate];
            timer = nil;
            if (err) {
                self.wornText.text = @"网络异常，请检查网络！";
            }
            self.wornText.text = [response objectForKey:@"rmsg"];
        }
    }];
    
}
//倒计时
-(void)coldDown{
    coldTime --;
    self.getNumBtn.titleLabel.text =[NSString stringWithFormat:@"%d秒",coldTime];
    [self.getNumBtn setTitle:[NSString stringWithFormat:@"%d秒",coldTime] forState:UIControlStateNormal];
    if(coldTime <= 0 ){
        [self.getNumBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        coldTime = 90;
        self.getNumBtn.userInteractionEnabled = YES;
//        [timer setFireDate:[NSDate distantFuture]];
        [timer invalidate];
        timer = nil;
    }
}

#pragma mark -m 记住密码
- (IBAction)writeDownPwd:(UIButton *)sender {
    if (sender.tag == 1) {
          [self.remPwd setBackgroundImage:[UIImage imageNamed:@"btnOk"] forState:UIControlStateNormal];
        sender.tag = 2;
    }else{
        [self.remPwd setBackgroundImage:[UIImage imageNamed:@"btnNoOk"] forState:UIControlStateNormal];
        sender.tag = 1;
    }
}
#pragma mark -m 登录
- (IBAction)loginClick:(id)sender {
    //手机登录
   
//    if ([self checkPhoneNumInput:self.userName.text]) {
//        self.wornText.text = @"请输入正确的手机号码！";
//        return;
//    }
    if (self.userName.text.length<11 || self.userName.text.length > 11) {
        self.wornText.text = @"请输入正确的手机号码！";
        return;
    }
    
    if (!_isAccount) {
        if (self.userPwd.text.length == 0 || [self.userPwd.text isEqualToString:@""]) {
          
          self.wornText.text = @"请输入验证码";
            return;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   
        NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:self.userName.text,@"userPhone",self.userPwd.text,@"smsCode", nil];

        [WebAPI userPhoneLogin:dic callback:^(NSError *err, id response) {
            
            NSString  *status =[response objectForKey:@"rcode"];
            if (!err && status.integerValue == 10000) {
                _userDic = [response objectForKey:@"data"];
                
                
                
                NSString *isVirtual = [NSString stringWithFormat:@"%@",[_userDic objectForKey:@"memberIsVirtual"]];
                
                if (isVirtual.integerValue == 1) {
                    
                    ResetKeyController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"ResetKey"];
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self.navigationController pushViewController:vc animated:YES];
                    return;
                }
                
                [self dealData:_userDic];
                
             
            }else{
                if(err){
                    self.wornText.text = @"网络异常，请检查网络！";
                }else{
                    NSString *result = [NSString stringWithFormat:@"%@",[response objectForKey:@"rmsg"]];
                    self.wornText.text = result;
                }
               
            }
         
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    else{//账号登录
        if ([self.userPwd.text isEqualToString:@"请输入密码"]) {
            self.wornText.text = @"请输入密码";
            return;
        }
         NSString *keyCode = [AppTool md5:self.userPwd.text];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.userName.text,@"userPhone",keyCode,@"userPassword",@"2.0",@"version", nil];
         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [WebAPI userAccountLogin:dic callback:^(NSError *err, id response) {
            NSString  *status =[response objectForKey:@"rcode"];
            if (!err && status.integerValue == 10000) {
                _userDic = [response objectForKey:@"data"];
                
                [self dealData:_userDic];
                
            }else{
                if(err){
                    self.wornText.text = @"网络异常，请检查网络！";
                }else{
                    if ([NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 30002 &&[NSString stringWithFormat:@"%@",[[response objectForKey:@"data"] objectForKey:@"memberIsVirtual"]].integerValue == 1 ) {
                         self.wornText.text =@"此账号为虚拟账号，请使用手机验证码登录！";
                        
                    }else{
                    NSString *result = [NSString stringWithFormat:@"%@",[response objectForKey:@"rmsg"]];
                    self.wornText.text = result;
                    }
                }
            }
             [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
    }
  


}


-(void)dealData:(NSDictionary*)dic{
    [[NSUserDefaults standardUserDefaults] setObject:self.userName.text forKey:@"phone"];
    
    NSArray *acInfo = [dic objectForKey:@"acInfo"];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:@"acInfo.data"];
    // 归档
    if ([acInfo isKindOfClass:[NSNull class]]) {
        acInfo= [[NSArray alloc] init];
    }
    [NSKeyedArchiver archiveRootObject:acInfo toFile:filePath];
    
    
    [JPUSHService setAlias:[dic objectForKey:@"memberAPPID"] callbackSelector:@selector(result) object:self];
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"key"] forKey:@"userKey"];
    NSDictionary *agent_dic = [dic objectForKey:@"agent"];
    
    [self saveUserMsg];
    if (agent_dic.count >0) {
        [self saveAgencyMsg];
            AgencyTabbarController *vc = [[UIStoryboard storyboardWithName:@"Agency" bundle:nil] instantiateViewControllerWithIdentifier:@"AgencyTabbar"];
            NSDictionary *agentDic = [agent_dic objectForKey:@"agent"];
            NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
            NSString *filePath = [path stringByAppendingPathComponent:@"agent.data"];
        
                            // 归档
            [NSKeyedArchiver archiveRootObject:agentDic toFile:filePath];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self presentViewController:vc animated:YES completion:nil];
        
            return ;
    }
    
    //没有选择屋主或者选择租客---第一次登录
    NSDictionary *boDic = [dic objectForKey:@"bo"];
    NSDictionary *renterDic = [dic objectForKey:@"renter"];
    NSLog(@"33::33::%@---%@",boDic,renterDic);
    if (boDic==nil && renterDic==nil) {
        
        SelectIDMsgController *vc = [[UIStoryboard storyboardWithName:@"Authentication" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectIDMsg"];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    //bb保存门口机ID
    NSArray *localIDs = [dic arrayForKey:@"acInfo"];
    if ([localIDs count] > 0) {
        NSMutableArray *localIDArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in localIDs) {
            [localIDArray addObject:[dict stringForKey:@"acAPPID"]];
        }
        [localIDArray writeToFile:USEFUL_DOOR_NODE_PATH atomically:YES];
    }else{
        [AppTool wlClearCachePath:USEFUL_DOOR_NODE_PATH];
    }
    
    [self getTem];
}


#pragma mark -m 保存代理商信息
-(void)saveAgencyMsg{
    if (!_userDic) {
        return;
    }
    
    self.userData.memberNickName = [_userDic objectForKey:@"memberNickName"];
    self.userData.memberPhone = [_userDic objectForKey:@"memberPhone"];
    self.userData.member_sex = [NSString stringWithFormat:@"%@",[_userDic objectForKey:@"memberSex"]].intValue;
    self.userData.memberAvatar = [_userDic objectForKey:@"memberAvatar"];
    self.userData.memberRegistTime = [NSString stringWithFormat:@"%@",[_userDic objectForKey:@"memberRegistTime"]];
    self.userData.memberAvailablePD = [NSString stringWithFormat:@"%@",[_userDic objectForKey:@"memberAvailablePD"]].floatValue;
    self.userData.memberFreezePD = [NSString stringWithFormat:@"%@",[_userDic objectForKey:@"memberFreezePD"]].floatValue;
    self.userData.memberIsDisable = [NSString stringWithFormat:@"%@",[_userDic objectForKey:@"memberIsDisable"] ].intValue;
    [[NSUserDefaults standardUserDefaults] setObject:self.userName.text forKey:@"phone"];
    self.userData.memberType = @"agency";
    self.userData.trueName = [[_userDic objectForKey:@"agent"] objectForKey:@"agentName"];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}
#pragma mark -m 保存用户信息
-(void) saveUserMsg{
    if (!_userDic) {
        return;
    }
    
    self.userData.memberNickName = [_userDic objectForKey:@"memberNickName"];
    self.userData.memberPhone = [_userDic objectForKey:@"memberPhone"];
    self.userData.member_sex = [NSString stringWithFormat:@"%@",[_userDic objectForKey:@"memberSex"]].intValue;
    self.userData.memberAvatar = [_userDic objectForKey:@"memberAvatar"];
    self.userData.memberRegistTime = [NSString stringWithFormat:@"%@",[_userDic objectForKey:@"memberRegistTime"]];
    self.userData.memberAvailablePD = [NSString stringWithFormat:@"%@",[_userDic objectForKey:@"memberAvailablePD"]].floatValue;
    self.userData.memberFreezePD = [NSString stringWithFormat:@"%@",[_userDic objectForKey:@"memberFreezePD"]].floatValue;
    self.userData.memberIsDisable = [NSString stringWithFormat:@"%@",[_userDic objectForKey:@"memberIsDisable"] ].intValue;
    [[NSUserDefaults standardUserDefaults] setObject:self.userName.text forKey:@"phone"];
    self.userData.key = [_userDic objectForKey:@"key"];
    NSLog(@"============%@",self.userData.key);
    [[NSUserDefaults standardUserDefaults] setObject:self.userData.key forKey:@"userKey"];
    NSDictionary *masterDic = [_userDic objectForKey:@"bo"];
    NSDictionary *renterDic = [_userDic objectForKey:@"renter"];
    if (self.remPwd.tag == 2) {
        if (_isAccount) {
            self.userData.password = self.userPwd.text;
        }else{
            self.userData.password = @"";
        }
    }else{
        self.userData.password = @"";
    }
    if(masterDic.count>0){
        self.userData.memberType = @"master";
        [MobClick profileSignInWithPUID:[NSString stringWithFormat:@"%@",[_userDic objectForKey:@"memberID"]]];
        self.userData.trueName = [masterDic objectForKey:@"boTrueName"];
        self.userData.boStatus = [NSString stringWithFormat:@"%@",[masterDic objectForKey:@"boStatus"]].intValue;
        self.userData.idCardNum = [NSString stringWithFormat:@"%@",[masterDic objectForKey:@"boIDCardNum"]];
        if (self.userData.boStatus == 30) {
            self.userData.idStatus = @"已认证";
        }else if(self.userData.boStatus == 10){
            self.userData.idStatus = @"审核中";
        }else{
            self.userData.idStatus = @"被驳回";
        }
    }
    else if(renterDic.count > 0){
        self.userData.memberType = @"renter";
        NSNumber* rentID = [[_userDic objectForKey:@"renter"] objectForKey:@"renterID"];        
        [[NSUserDefaults standardUserDefaults] setObject:rentID.stringValue forKey:@"renterID"];
        self.userData.renterID = rentID.stringValue;
        self.userData.trueName = [renterDic objectForKey:@"renterTrueName"];
        self.userData.renterStatus = [NSString stringWithFormat:@"%@",[renterDic objectForKey:@"renterStatus"]];
        NSDictionary *rentRecordInfo = [_userDic objectForKey:@"rentRecordInfo"];
        if (rentRecordInfo.count > 0) {
            self.userData.renterAddress = [rentRecordInfo objectForKey:@"renterAddress"];
        }else{
            self.userData.renterAddress = @"";
        }
        
        self.userData.idCardNum = [NSString stringWithFormat:@"%@",[renterDic objectForKey:@"renterIDCardNum"]];
        if (self.userData.renterStatus.integerValue == 30) {
            self.userData.idStatus = @"已认证";
        }else if(self.userData.renterStatus.integerValue == 10){
            self.userData.idStatus = @"审核中";
        }else{
            self.userData.idStatus = @"被驳回";
        }
    }else{
        self.userData.memberType = @"notype";
        
        self.userData.idStatus = @"未认证";
        self.userData.renterStatus = @"0";
        self.userData.boStatus  = 0;
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}
#pragma mark -m 注册
- (IBAction)registerClick:(id)sender {
  
}

-(void)getTem{
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.userData.key,@"key", nil];
    [WebAPI getCurrentTelecomInfo:dic callback:^(NSError *err, id response) {
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            NSArray *wifiArr = [response objectForKey:@"data"];
            if (wifiArr.count>0&&wifiArr != nil) {
                
                NSString *telStates = [[response objectForKey:@"data"][0] objectForKey:@"telecomStatus"];
                NSString *telOrder = [[[response objectForKey:@"data"][0] objectForKey:@"order"] objectForKey:@"orderState"];
                if (telStates.integerValue == 0&& telOrder.integerValue == 10 ) {
                    self.userData.isOpenNet = @"no";
                }else if (telStates.integerValue == 0 && telOrder.integerValue == 20){
                    self.userData.isOpenNet = @"wait";
                }
                else{
                    self.userData.isOpenNet = @"yes";
                    
                }
                
            }else{
                self.userData.isOpenNet = @"no";
                
            }
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }else{
            if (err) {
                [Alert showFail:@"网络异常，请检查网络！" View:self.navigationController.navigationBar andTime:1 complete:^(BOOL isComplete) {
                    
                }];
            }else{
               RequestBad 
            }
            
        }
          [self dismissViewControllerAnimated:YES completion:nil];
    }];



}

- (void)initBLEManager{
//    self.bleCentralManager = [FBBLECentralManager shareInsatance];
//    [UIApplication sharedApplication].applicationSupportsShakeToEdit = NO;
//    [self.bleCentralManager startCentralManagerService];
}




@end
