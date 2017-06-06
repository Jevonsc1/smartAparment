//
//  TDConfirmOrderViewController.m
//  SmartApartment
//
//  Created by 刘靖 on 2017/2/24.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "TDConfirmOrderViewController.h"
#import "TDOperationTipsViewController.h"
#import "WXApi.h"
#import <CommonCrypto/CommonDigest.h>
#import <AlipaySDK/AlipaySDK.h>
#import "payView.h"
@interface TDConfirmOrderViewController ()
@property (weak, nonatomic) IBOutlet UILabel *packageNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPricesLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPricesDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *realNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIButton *makeAnAppointmentButton;
@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property (strong, nonatomic) NSString *orderID;
@property (strong, nonatomic) NSString *orderPrice;
@property (assign, nonatomic) BOOL isValidate;
@end

@implementation TDConfirmOrderViewController
{
    //支付窗口
    payView *payview;
    //支付窗口的背景view;
    UIView *backgroundView;
    //商户密钥
    NSString *storeKey;
    //得到的宽带数据--金钱
    
    //展示了支付UI没有
    BOOL hadShowPayUI;
}

- (void)telecomMakeAnAppointment {
    if (!_dictionary) {
        NSLog(@"缺少参数（dictionary）");
        return;
    }
    
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"];
    NSDictionary *dictionary = @{@"key":key,
                                 @"orderID":_orderID,
                                 @"version":@"2.0"};
    
    [WebAPIForBroadband telecomMakeAnAppointment:dictionary callback:^(NSError *err, id response) {
        
        NSString *code = [response objectForKey:@"rcode"];
        if ([code integerValue] == 10000) {
            
            TDOperationTipsViewController *controller = [[TDOperationTipsViewController alloc] init];
            if (!_isValidate) {
                controller.operationTips = MakeAnAppointmentSuccess_Aut;
            }else {
                controller.operationTips = MakeAnAppointmentSuccess;
            }
            
            controller.dictionary = _dictionary;
            [self.navigationController pushViewController:controller animated:YES];
        }else {
            RequestBadByNoNav
        }
    }];
}


- (void)gettelecomMakeAnAppointment {
    if (!_dictionary) {
        NSLog(@"缺少参数（dictionary）");
        return;
    }
    
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"];
    NSDictionary *dictionary = @{@"key":key,
                                 @"orderID":_orderID,
                                 @"version":@"2.0"};

    [WebAPIForBroadband loadTelecomOrderInfo:dictionary callback:^(NSError *err, id response) {
        
        NSString *code = [response objectForKey:@"rcode"];
        if ([code integerValue] == 10000) {
            NSString *orderState = [NSString stringWithFormat:@"%@",[[response objectForKey:@"data"] objectForKey:@"orderState"]];
            //支付成功跳转
            if (orderState.integerValue ==10) {
                   TDOperationTipsViewController *controller = [[TDOperationTipsViewController alloc] init];
                if (!_isValidate) {
                    controller.operationTips = OnlinePaymentSuccess_Aut;
                }else {
                    controller.operationTips = OnlinePaymentSuccess;
                }
                controller.dictionary = _dictionary;
                [self.navigationController pushViewController:controller animated:YES];
            }
            
          
        }else {
            RequestBadByNoNav
        }
    }];
}


- (IBAction)touchUpInside:(UIButton *)button {
    
    if (button == _payButton) {
        //支付功能-调用微信以及支付宝
        [self showPayView];
    }
    
    if (button == _makeAnAppointmentButton) {
        [self telecomMakeAnAppointment];
    }
}

- (void)updateForUI {
    if (_dictionary) {
        _orderID = [_dictionary stringForKey:@"orderID"];
        _orderPrice = [_dictionary stringForKey:@"orderPrices"];
        _isValidate = [_dictionary boolForKey:@"userIsValidate"];
        
        _orderPricesLabel.text = [_dictionary stringForKey:@"orderPrices"];
        [_orderPricesDescriptionLabel setText:[NSString stringWithFormat:@"含%@初装费和%@预存费",[_dictionary RMBForKey:@"telecomInstallationFees"],[_dictionary RMBForKey:@"telecomAdvancedPayment"]]];
        _packageNameLabel.text = [_dictionary stringForKey:@"telecomName"];
        _realNameLabel.text = [_dictionary stringForKey:@"userTrueName"];
        _phoneNumberLabel.text = [_dictionary stringForKey:@"userPhoneNumber"];
        _addressLabel.text = [_dictionary stringForKey:@"userAddress"];
        CGFloat labHeigh = [_addressLabel heightForOffsetWithText:[_dictionary stringForKey:@"userAddress"]];
        _addressLabel.height = 50 + labHeigh;
        _addressView.height += labHeigh+5;
        _tipsLabel.y += labHeigh;
        _payButton.y += labHeigh;
        _makeAnAppointmentButton.y += labHeigh;
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"确认订单信息"];
    
    [_payButton cornerRadius];
    [_makeAnAppointmentButton cornerRadius:7 color:[UIColor colorWithRed:46/255.0 green:125/255.0 blue:225/255.0 alpha:1.0]];
    hadShowPayUI = NO;
}
-(void)viewDidAppear:(BOOL)animated{
     [self updateForUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //[self hiddenLeftBarButtonItem];
    
   
    
    [self initPayView];
    //支付宝支付的成功和失败界面
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(succesPayNet) name:@"NetAlipayOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failPayNet) name:@"NetAlipayFail" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoSuccess) name:@"gotoSuccess" object:nil ];
}
-(void)gotoSuccess{
    if (hadShowPayUI) {
        [self gettelecomMakeAnAppointment];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 初始化支付界面
 */
-(void)initPayView{
    if (!payview) {
        payview = [[NSBundle mainBundle] loadNibNamed:@"charges" owner:self options:nil][0];
        payview.money.text = _orderPrice;
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.width, self.view.height)];
        backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        backgroundView.hidden = YES;
        [payview setFrame:CGRectMake(0,backgroundView.height, self.view.width,  345*ratio)];
        [backgroundView addSubview:payview];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePayView)];
        [backgroundView addGestureRecognizer:tap];
        [payview.wechatBtn addTarget:self action:@selector(wechatPay) forControlEvents:UIControlEventTouchDown];
        [payview.cancelBtn addTarget:self action:@selector(hidePayView) forControlEvents:UIControlEventTouchDown];
        [payview.aliPayBtn addTarget:self action:@selector(alipay) forControlEvents:UIControlEventTouchDown];
        payview.orderIDLabel.text = [NSString stringWithFormat:@"订单编号 %@",_orderID];
        [self.view addSubview:backgroundView];
    }
}
-(void)showPayView{
    backgroundView.hidden = NO;
//    payview.money.text = 
    [UIView animateWithDuration:0.25 animations:^{
        [payview setFrame:CGRectMake(0, self.view.height- 345*ratio, self.view.width,  345*ratio)];
    }];
    hadShowPayUI = YES;
}
-(void)hidePayView{
    [UIView animateWithDuration:0.25 animations:^{
         [payview setFrame:CGRectMake(0, self.view.height, self.view.width, 345*ratio)];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        backgroundView.hidden = YES;
    });
    hadShowPayUI = NO;
}

#pragma mark -m 微信支付
-(void)wechatPay{

//    if (![WXApi isWXAppInstalled]) {
//        [Alert showFail:@"请先安装微信客户端!" View:self.view andTime:1.5 complete:nil];
//        return;
//    }
     [[NSUserDefaults standardUserDefaults] setObject:@"NetMoney" forKey:@"aliPayWay"];
    [WXApi registerApp:@"wx87c82e0d6c1f9052"];
    
    
       NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",self.orderID,@"orderID",@"1.0",@"version", nil];
        [WebAPI payOrderVersion2:dic callback:^(NSError *err, id response) {
            if (!err) {
                NSLog(@"%@",response);
                NSDictionary *dic = [response objectForKey:@"data"] ;
                [self sendPayOrder:[[dic objectForKey:@"weixinPay"] objectForKey:@"mch_id"] andprepay:[[dic objectForKey:@"weixinPay"] objectForKey:@"prepay_id"] andordersn:@"" andAppid:[[dic objectForKey:@"weixinPay"] objectForKey:@"appid"] andkey:[[dic objectForKey:@"weixinPay"] objectForKey:@"key"]];
                
            }else{
                if (err) {
                    [Alert showFail:@"服务器异常！" View:self.navigationController.navigationBar andTime:2 complete:^(BOOL isComplete) {
                        
                    }];
                }else{
                   RequestBad
                }
                
            }
        }];
    
        
    
}

/**
 支付宝支付
 */
-(void)alipay{
    NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",self.orderID,@"orderID",@"1.0",@"version", nil];
     [[NSUserDefaults standardUserDefaults] setObject:@"NetMoney" forKey:@"aliPayWay"];
    [WebAPI payOrderVersion2:dic callback:^(NSError *err, id response) {
        if (!err&&[NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            [[NSUserDefaults standardUserDefaults] setObject:@"NetMoney" forKey:@"aliPayWay"];
            
            NSString *appScheme = @"smart";
            
            NSString *alipay_str = [[[response objectForKey:@"data"] objectForKey:@"aliPay"] objectForKey:@"payURL"];
            [[AlipaySDK defaultService]payOrder:alipay_str fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                if ([NSString stringWithFormat:@"%@",[resultDic objectForKey:@"resultStatus"]].integerValue == 9000) {
                    TDOperationTipsViewController *controller = [[TDOperationTipsViewController alloc] init];
                    if (!_isValidate) {
                        controller.operationTips = OnlinePaymentSuccess_Aut;
                    }else {
                        controller.operationTips = OnlinePaymentSuccess;
                    }
                    
                    controller.dictionary = _dictionary;
                    [self.navigationController pushViewController:controller animated:YES];
                }else{
                    TDOperationTipsViewController *controller = [[TDOperationTipsViewController alloc] init];
                    controller.operationTips = OnlinePaymentFailure;
                    controller.dictionary = _dictionary;
                    [self.navigationController pushViewController:controller animated:YES];
                }
                
            }];
        }else{
            if (err) {
                [Alert showFail:@"服务器异常！" View:self.navigationController.navigationBar andTime:2 complete:^(BOOL isComplete) {
                    
                }];
            }else{
               RequestBad
            }
            
        }
    }];
}

-(void)succesPayNet{
    TDOperationTipsViewController *controller = [[TDOperationTipsViewController alloc] init];
    if (!_isValidate) {
        controller.operationTips = OnlinePaymentSuccess_Aut;
    }else {
        controller.operationTips = OnlinePaymentSuccess;
    }
    
    controller.dictionary = _dictionary;
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)failPayNet{
    TDOperationTipsViewController *controller = [[TDOperationTipsViewController alloc] init];
    controller.operationTips = OnlinePaymentFailure;
    controller.dictionary = _dictionary;
    [self.navigationController pushViewController:controller animated:YES];
}


-(void)sendPayOrder:(NSString *)mchid andprepay:(NSString *)prepayId andordersn:(NSString *)order_sn andAppid:(NSString *)appid andkey:(NSString *)key{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    storeKey = key;
    PayReq *request = [[PayReq alloc]init];
    /** 商家向财付通申请的商家id */
    request.partnerId = mchid;
    /** 预支付订单 */
    request.prepayId= prepayId;
    /** 商家根据财付通文档填写的数据和签名 */
    request.package = @"Sign=WXPay";
    /** 随机串，防重发 */
    request.nonceStr= [self generateTradeNO];
    /** 时间戳，防重发 */
    request.timeStamp= timeString.intValue;
    /** 商家根据微信开放平台文档对数据做的签名 */
    NSString *signKey = [self createMD5SingForPay:appid partnerid:mchid prepayid:prepayId package:request.package noncestr:request.nonceStr timestamp: request.timeStamp];
    request.sign=signKey;
    
    /*! @brief 发送请求到微信，等待微信返回onResp
     *
     * 函数调用后，会切换到微信的界面。第三方应用程序等待微信返回onResp。微信在异步处理完成后一定会调用onResp。支持以下类型
     * SendAuthReq、SendMessageToWXReq、PayReq等。
     * @param req 具体的发送请求，在调用函数后，请自己释放。
     * @return 成功返回YES，失败返回NO。
     */
    [WXApi sendReq: request];
}






//随机字符串生成
- (NSString *)generateTradeNO {
    
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    
    //  srand函数是初始化随机数的种子，为接下来的rand函数调用做准备。
    //  time(0)函数返回某一特定时间的小数值。
    //  这条语句的意思就是初始化随机数种子，time函数是为了提高随机的质量（也就是减少重复）而使用的。
    
    //　srand(time(0)) 就是给这个算法一个启动种子，也就是算法的随机种子数，有这个数以后才可以产生随机数,用1970.1.1至今的秒数，初始化随机数种子。
    //　Srand是种下随机种子数，你每回种下的种子不一样，用Rand得到的随机数就不一样。为了每回种下一个不一样的种子，所以就选用Time(0)，Time(0)是得到当前时时间值（因为每时每刻时间是不一样的了）。
    
    srand(time(0)); // 此行代码有警告:
    
    for (int i = 0; i < kNumber; i++) {
        
        unsigned index = rand() % [sourceStr length];
        
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

//创建发起支付时的sige签名

-(NSString *)createMD5SingForPay:(NSString *)appid_key partnerid:(NSString *)partnerid_key prepayid:(NSString *)prepayid_key package:(NSString *)package_key noncestr:(NSString *)noncestr_key timestamp:(UInt32)timestamp_key{
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject:appid_key forKey:@"appid"];
    [signParams setObject:noncestr_key forKey:@"noncestr"];
    [signParams setObject:package_key forKey:@"package"];
    [signParams setObject:partnerid_key forKey:@"partnerid"];
    [signParams setObject:prepayid_key forKey:@"prepayid"];
    [signParams setObject:[NSString stringWithFormat:@"%u",(unsigned int)timestamp_key] forKey:@"timestamp"];
    
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [signParams allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[signParams objectForKey:categoryId] isEqualToString:@""]
            && ![[signParams objectForKey:categoryId] isEqualToString:@"sign"]
            && ![[signParams objectForKey:categoryId] isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [signParams objectForKey:categoryId]];
        }
    }
    //添加商户密钥key字段
    
    [contentString appendFormat:@"key=%@", storeKey];
    NSString *result = [self md5:contentString];
    
    NSLog(@"result = %@",result);
    return result;
}

// MD5加密算法
-(NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    //加密规则，因为逗比微信没有出微信支付demo，这里加密规则是参照安卓demo来得
    unsigned char result[16]= "0123456789abcdef";
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    //这里的x是小写则产生的md5也是小写，x是大写则md5是大写，这里只能用大写，逗比微信的大小写验证很逗
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


@end
