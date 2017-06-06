//
//  renterPayController.m
//  SmartApartment
//
//  Created by Trudian on 16/10/31.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "renterPayController.h"
#import "payView.h"
#import <CommonCrypto/CommonDigest.h>
#import "MBProgressHUD.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "renterPayResultController.h"
@interface renterPayController ()<WXApiDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneMonth;
@property (weak, nonatomic) IBOutlet UILabel *twoMonth;
//四个费用
@property (weak, nonatomic) IBOutlet UILabel *dianAllNum;
@property (weak, nonatomic) IBOutlet UILabel *waterAllNum;
@property (weak, nonatomic) IBOutlet UILabel *rentAllNum;
@property (weak, nonatomic) IBOutlet UILabel *otherAllNum;
//总计
@property (weak, nonatomic) IBOutlet UILabel *allMoney;

//电表读数
@property (weak, nonatomic) IBOutlet UILabel *nowDianRead;
@property (weak, nonatomic) IBOutlet UILabel *evenDianRead;
@property (weak, nonatomic) IBOutlet UILabel *dianXiaoHao;
@property (weak, nonatomic) IBOutlet UILabel *dianUnit;

//水表读数
@property (weak, nonatomic) IBOutlet UILabel *nowWaterRead;
@property (weak, nonatomic) IBOutlet UILabel *evenWaterRead;
@property (weak, nonatomic) IBOutlet UILabel *WaterXiaoHao;
@property (weak, nonatomic) IBOutlet UILabel *WaterUnit;
//租金
@property (weak, nonatomic) IBOutlet UILabel *rentMoney;

//其他费用
@property (weak, nonatomic) IBOutlet UILabel *depositMoney;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewAutoHeight;

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;



@end

@implementation renterPayController
{
    payView *payview;
    NSString *houseID;
      NSString *storeKey;
    UIView *backgroundView;
    NSString *yearAndmonth;
    NSInteger monthIndex;
    
    //账单ID
    NSString *orderID;
    //新的账单ID
    NSString *payBillID;
    
    NSString *myHouseID;
    
      NSInteger nowMonthNum;
     NSString *nowYearMonth;
     NSString *comCreateTime;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    payview = [[NSBundle mainBundle] loadNibNamed:@"charges" owner:self options:nil][0];
    [payview setFrame:CGRectMake(0, self.view.height, self.view.width, 345)];
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(succesPay) name:@"houseAlipayOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failPay) name:@"houseAlipayFail" object:nil];
     NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    int year = [dateComponent year];
    int month = [dateComponent month];
   
    if (self.notifiDay == nil) {
         self.monthLabel.text = [NSString stringWithFormat:@"%d年%d月",year,month];
         yearAndmonth = [[self.monthLabel.text stringByReplacingOccurrencesOfString:@"年" withString:@""] stringByReplacingOccurrencesOfString:@"月" withString:@""];
    }else{
         yearAndmonth = self.notifiDay;
         self.monthLabel.text = [NSString stringWithFormat:@"%d年%d月",year,month];
       
    }
    monthIndex = [yearAndmonth substringFromIndex:4].integerValue;
    
    nowYearMonth = yearAndmonth;
    nowMonthNum = [yearAndmonth substringFromIndex:4].integerValue;
    [self.leftBtn setTitle:[NSString stringWithFormat:@"%ld月",nowMonthNum-1] forState:UIControlStateNormal];
    [self.rightBtn setTitle:[NSString stringWithFormat:@"%ld月",nowMonthNum+1] forState:UIControlStateNormal];
    if (nowMonthNum == 1) {
           [self.leftBtn setTitle:[NSString stringWithFormat:@"12月"] forState:UIControlStateNormal];
    }
    if (nowMonthNum == 12) {
         [self.rightBtn setTitle:[NSString stringWithFormat:@"1月"] forState:UIControlStateNormal];
    }
 
    backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    backgroundView.hidden = YES;
    [self.view addSubview:backgroundView];
    [backgroundView addSubview:payview];
    
    [self.view bringSubviewToFront:self.payBtn];
    [payview.wechatBtn addTarget:self action:@selector(wechatPayRenterPay) forControlEvents:UIControlEventTouchDown];
    [payview.cancelBtn addTarget:self action:@selector(downPayVoew) forControlEvents:UIControlEventTouchDown];
    [payview.aliPayBtn addTarget:self action:@selector(alipayRenterPay) forControlEvents:UIControlEventTouchDown];

    
    

    
}
-(void)viewWillAppear:(BOOL)animated{
    NSDictionary *houseDic = [[NSDictionary alloc] initWithObjectsAndKeys:[ModelTool find_UserData].key,@"key",@"1",@"availableRentRecord",@"2.0",@"version", nil];
    [WebAPI getRentRecordInfo:houseDic callback:^(NSError *err, id response) {
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            NSArray *houseArr = [response objectForKey:@"data"];
            if (houseArr.count != 0) {
                NSDictionary *houseD = houseArr[0];
                myHouseID = [[houseD objectForKey:@"houseInfo"] objectForKey:@"houseID"];
                houseID = myHouseID;
                NSArray *renterArr = [[houseD objectForKey:@"rentInfo"][0] objectForKey:@"renterInfo"];
                NSDictionary *rentDic = [houseD objectForKey:@"rentInfo"][0];
                comCreateTime = [rentDic objectForKey:@"rentTime"];
                for (int i = 0; i < renterArr.count; i++) {
                    NSDictionary *renterDic =renterArr[i];
                    if ([[NSString stringWithFormat:@"%@",[renterDic objectForKey:@"renterPhone"]] isEqualToString:[ModelTool find_UserData].memberPhone]) {
                        
                        if ([NSString stringWithFormat:@"%@",[renterDic objectForKey:@"renterRoleID"]].integerValue == 2) {
                            self.payBtn.hidden  = YES;
                        }else{
                            self.payBtn.hidden = NO;
                        }
                    }
                }
                [self getDataForLabel];
            }
            
        }else{
            if (err) {
                [Alert showFail:@"服务器异常！" View:self.navigationController.navigationBar andTime:2 complete:^(BOOL isComplete) {
                    
                }];
            }
            else{
               RequestBad
            }
        }
        
    }];

}
#pragma mark -m 获取数据
-(void)getDataForLabel{
    NSDictionary *houseDic = [[NSDictionary alloc] initWithObjectsAndKeys:[ModelTool find_UserData].key,@"key",myHouseID,@"houseID",yearAndmonth,@"monthDate", nil];
    
    [WebAPI getHouseBillList:houseDic callback:^(NSError *err, id response) {
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            [self downZhangdan:[response objectForKey:@"data"]];
            
        }
        else{
            if (err) {
                [Alert showFail:@"服务器异常！" View:self.navigationController.navigationBar andTime:2 complete:^(BOOL isComplete) {
                    
                }];
            }
            else{
               RequestBad
            }
        }
    }];
}

#pragma mark -m 返回上一个月
- (IBAction)forwardMonth:(UIButton *)sender {
    NSString *comTime = [TimeDate timeToTimeSp:comCreateTime];
    if (yearAndmonth <=comTime) {
        [Alert showFail:@"前面没有数据了…" View:self.navigationController.navigationBar andTime:3 complete:^(BOOL isComplete) {
            
        }];
        return;
    }
    monthIndex = [yearAndmonth substringFromIndex:4].integerValue;
    monthIndex -- ;
    
    if (monthIndex <1) {
        monthIndex = 12;
      yearAndmonth = [NSString stringWithFormat:@"%ld%ld",[yearAndmonth substringToIndex:4].integerValue -1,[yearAndmonth substringFromIndex:4].integerValue];
    }
    if (monthIndex == 1) {
         [sender setTitle:@"12月" forState:UIControlStateNormal];
    }else{
           [sender setTitle:[NSString stringWithFormat:@"%ld月",monthIndex-1] forState:UIControlStateNormal];
    }
    if (monthIndex !=12) {
       [self.rightBtn setTitle:[NSString stringWithFormat:@"%ld月",monthIndex+1] forState:UIControlStateNormal];
    }else{
        [self.rightBtn setTitle:@"1月" forState:UIControlStateNormal];
    }
    if (monthIndex<10) {
            yearAndmonth = [NSString stringWithFormat:@"%@0%ld",[yearAndmonth substringToIndex:4],(long)monthIndex];
        self.monthLabel.text =[NSString stringWithFormat:@"%@年0%ld月",[yearAndmonth substringToIndex:4],(long)monthIndex];
         self.oneMonth.text = [NSString stringWithFormat:@"%@-0%ld-17",[yearAndmonth substringToIndex:4],(long)monthIndex];
       
    }else{
         yearAndmonth = [NSString stringWithFormat:@"%@%ld",[yearAndmonth substringToIndex:4],(long)monthIndex];
            self.monthLabel.text =[NSString stringWithFormat:@"%@年%ld月",[yearAndmonth substringToIndex:4],(long)monthIndex];
         self.oneMonth.text = [NSString stringWithFormat:@"%@-%ld-17",[yearAndmonth substringToIndex:4],(long)monthIndex];
    }
    if (monthIndex+1 <10) {
        self.twoMonth.text = [NSString stringWithFormat:@"%@-0%ld-17",[yearAndmonth substringToIndex:4],(long)monthIndex+1];
    }
    else{
        self.twoMonth.text = [NSString stringWithFormat:@"%@-%ld-17",[yearAndmonth substringToIndex:4],(long)monthIndex+1];
    }
    
    if ([sender.titleLabel.text isEqualToString:@"12月"]) {
        
        self.oneMonth.text = [NSString stringWithFormat:@"%@-12-17",[yearAndmonth substringToIndex:4]];
        
        self.twoMonth.text = [NSString stringWithFormat:@"%@-01-17",[yearAndmonth substringToIndex:4]];
    }
      yearAndmonth = [[self.monthLabel.text stringByReplacingOccurrencesOfString:@"年" withString:@""] stringByReplacingOccurrencesOfString:@"月" withString:@""];
    [self getDataForLabel];
}
- (IBAction)nextMonth:(UIButton *)sender {
    if([nowYearMonth isEqualToString:yearAndmonth]){
        [Alert showFail:@"后面没有数据了…" View:self.navigationController.navigationBar andTime:3 complete:^(BOOL isComplete) {
            
        }];
        return;
    }
    
    monthIndex = [yearAndmonth substringFromIndex:4].integerValue;
    monthIndex ++ ;
    
    if (monthIndex >12) {
        monthIndex = 1;
           yearAndmonth = [NSString stringWithFormat:@"%ld%ld",[yearAndmonth substringToIndex:4].integerValue +1,[yearAndmonth substringFromIndex:4].integerValue]; 
    }
    if (monthIndex == 12) {
        [sender setTitle:@"1月" forState:UIControlStateNormal];
    }else{
        [sender setTitle:[NSString stringWithFormat:@"%ld月",monthIndex+1] forState:UIControlStateNormal];
    }
    if (monthIndex !=1) {
        [self.leftBtn setTitle:[NSString stringWithFormat:@"%ld月",monthIndex-1] forState:UIControlStateNormal];
    }else{
        [self.leftBtn setTitle:@"12月" forState:UIControlStateNormal];
    }
    
    if (monthIndex<10) {
        yearAndmonth = [NSString stringWithFormat:@"%@0%ld",[yearAndmonth substringToIndex:4],(long)monthIndex];
        self.monthLabel.text =[NSString stringWithFormat:@"%@年0%ld月",[yearAndmonth substringToIndex:4],(long)monthIndex];
        self.oneMonth.text = [NSString stringWithFormat:@"%@-0%ld-17",[yearAndmonth substringToIndex:4],(long)monthIndex];
        
    }else{
        yearAndmonth = [NSString stringWithFormat:@"%@%ld",[yearAndmonth substringToIndex:4],(long)monthIndex];
        self.monthLabel.text =[NSString stringWithFormat:@"%@年%ld月",[yearAndmonth substringToIndex:4],(long)monthIndex];
        self.oneMonth.text = [NSString stringWithFormat:@"%@-%ld-17",[yearAndmonth substringToIndex:4],(long)monthIndex];
    }
    if (monthIndex+1 <10) {
        self.twoMonth.text = [NSString stringWithFormat:@"%@-0%ld-17",[yearAndmonth substringToIndex:4],(long)monthIndex+1];
    }
    else{
        self.twoMonth.text = [NSString stringWithFormat:@"%@-%ld-17",[yearAndmonth substringToIndex:4],(long)monthIndex+1];
    }
    
    if ([sender.titleLabel.text isEqualToString:@"12月"]) {
        
        self.oneMonth.text = [NSString stringWithFormat:@"%@-12-17",[yearAndmonth substringToIndex:4]];
        
        self.twoMonth.text = [NSString stringWithFormat:@"%@-01-17",[yearAndmonth substringToIndex:4]];
    }
      yearAndmonth = [[self.monthLabel.text stringByReplacingOccurrencesOfString:@"年" withString:@""] stringByReplacingOccurrencesOfString:@"月" withString:@""];
    [self getDataForLabel];
}











- (void)onResp:(BaseResp *)resp
{
    renterPayResultController *vc = [[UIStoryboard storyboardWithName:@"Charges" bundle:nil] instantiateViewControllerWithIdentifier:@"renterPayResult"];
    //支付返回结果，实际支付结果需要去微信服务器端查询
    
    switch (resp.errCode) {
        case WXSuccess:
            vc.resultType = @"ok";
            [self.navigationController pushViewController:vc animated:YES];
            NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
            break;
        default:
            vc.resultType = @"no";
            [self.navigationController pushViewController:vc animated:YES];
            NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
            break;
    }
}

#pragma mark -m 微信支付
-(void)wechatPayRenterPay{
//    [Alert showFail:@"微信支付尚未开通！" View:self.navigationController.navigationBar andTime:3 complete:nil];
//    return;
    [WXApi registerApp:@"wx87c82e0d6c1f9052"];

    if (payBillID.length > 0) {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[ModelTool find_UserData].key,@"key",payBillID,@"payBillID", nil];
        [WebAPI payBill:dic callback:^(NSError *err, id response) {
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
    else{
        [Alert showFail:@"暂无账单！" View:self.navigationController.navigationBar andTime:2 complete:^(BOOL isComplete) {
            
        }];

    }
}
#pragma mark -m 支付宝支付
-(void)alipayRenterPay{
    if (payBillID.length>0) {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[ModelTool find_UserData].key,@"key",payBillID,@"payBillID", nil];
        [WebAPI payBill:dic callback:^(NSError *err, id response) {
            if (!err) {
                [[NSUserDefaults standardUserDefaults] setObject:@"houseMoney" forKey:@"aliPayWay"];
                
                NSString *appScheme = @"alisdkdemo";
                NSString *alipay_str = [[[response objectForKey:@"data"] objectForKey:@"aliPay"] objectForKey:@"payURL"];
                [[AlipaySDK defaultService]payOrder:alipay_str fromScheme:appScheme callback:^(NSDictionary *resultDic) {
               
                    
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

    }else{
        [Alert showFail:@"暂无账单！" View:self.navigationController.navigationBar andTime:2 complete:^(BOOL isComplete) {
            
        }];
    }
}
-(void)succesPay{
    renterPayResultController *vc = [[UIStoryboard storyboardWithName:@"Charges" bundle:nil] instantiateViewControllerWithIdentifier:@"renterPayResult"];
    vc.resultType = @"ok"; 
    vc.money = self.allMoney.text;
    vc.inWay = @"renter";
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)failPay{
    renterPayResultController *vc = [[UIStoryboard storyboardWithName:@"Charges" bundle:nil] instantiateViewControllerWithIdentifier:@"renterPayResult"];
    vc.resultType = @"fail";
    vc.inWay = @"renter";
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -m 计算账单
-(void)downZhangdan:(NSDictionary *)billDic{
    NSDictionary *billInfo = [billDic objectForKey:@"recordInfo"];
    NSDictionary *waterBill = [billInfo objectForKey:@"waterRecord"];
    NSDictionary *electricBill = [billInfo objectForKey:@"electricRecord"];
    NSDictionary *otherInfo = [billDic objectForKey:@"billInfo"];
    NSDictionary *rentBill;
    if (otherInfo.count<=0) {
        [Alert showFail:@"该月没有账单!" View:self.navigationController.navigationBar andTime:3 complete:^(BOOL isComplete) {
            
        }];
        return;
    }
    if (otherInfo.count >0) {
       rentBill  = [otherInfo objectForKey:@"rentBill"];
    }
//    NSDictionary *otherBill = [otherInfo objectForKey:@"otherBill"];
    if (rentBill.count > 0) {
         orderID = [rentBill objectForKey:@"orderID"];
    }
    if(electricBill.count >0){
        self.nowDianRead.text = [NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[electricBill objectForKey:@"electricTotalAmount"]].floatValue];
        self.dianAllNum.text =[NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@", [[otherInfo objectForKey:@"electricBill"] objectForKey:@"orderGoodsAmount"]].floatValue];
        self.dianUnit.text = [NSString stringWithFormat:@"%@",[billDic objectForKey:@"houseElectricUnitPrice"]];
        self.dianXiaoHao.text =[NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[electricBill objectForKey:@"electricUseAmount"]].floatValue];
        
        self.evenDianRead.text = [NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[electricBill objectForKey:@"electricTotalAmount"]].doubleValue-self.dianXiaoHao.text.doubleValue];
        
    }else{
        self.nowDianRead.text = @"";
        self.dianAllNum.text =@"";
        self.dianUnit.text = @"";
        self.dianXiaoHao.text =@"";
        
        self.evenDianRead.text = @"";
    }
    if(waterBill.count >0){
        self.nowWaterRead.text =[NSString stringWithFormat:@"%.2f", [NSString stringWithFormat:@"%@",[waterBill objectForKey:@"waterTotalAmount"]].floatValue];
        self.waterAllNum.text =[NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@", [[otherInfo objectForKey:@"waterBill"] objectForKey:@"orderGoodsAmount"]].floatValue];
        self.WaterUnit.text = [NSString stringWithFormat:@"%@",[billDic objectForKey:@"houseWaterUnitPrice"]];
        self.WaterXiaoHao.text =[NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[waterBill objectForKey:@"waterUseAmount"]].floatValue];
        
        self.evenWaterRead.text = [NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[waterBill objectForKey:@"waterTotalAmount"]].doubleValue-self.dianXiaoHao.text.doubleValue];
    }else{
        self.nowWaterRead.text = @"";
        self.waterAllNum.text =@"";
        self.WaterUnit.text = @"";
        self.WaterXiaoHao.text =@"";
        
        self.evenWaterRead.text =@"";
    }
  
    if (otherInfo.count> 0) {
        payBillID = [NSString stringWithFormat:@"%@",[otherInfo objectForKey:@"payBillID"]];
          self.rentMoney.text = [NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[[otherInfo objectForKey:@"rentBill"] objectForKey:@"orderGoodsAmount"]].doubleValue];
        self.otherAllNum.text = [NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[[otherInfo objectForKey:@"otherBill"] objectForKey:@"orderGoodsAmount"]].doubleValue];
    }
    self.allMoney.text = [NSString stringWithFormat:@"%.2f",self.waterAllNum.text.doubleValue + self.dianAllNum.text.doubleValue+self.rentMoney.text.doubleValue+self.otherAllNum.text.doubleValue];
    if ([NSString stringWithFormat:@"%@",[rentBill objectForKey:@"orderState"]].integerValue == 10) {
        [self.payBtn setBackgroundImage:[UIImage imageNamed:@"surebtn"] forState:UIControlStateNormal];
        self.payBtn.userInteractionEnabled = YES;
    }else{
        self.payBtn.userInteractionEnabled = NO;
        [self.payBtn setBackgroundImage:[UIImage imageNamed:@"hadPay_btn"] forState:UIControlStateNormal];
    }
}
-(void)viewDidAppear:(BOOL)animated{
   
    [self.scrollview setFrame:CGRectMake(0, 80, self.view.width, self.view.height)];
     [self.contentView setFrame:CGRectMake(0, 80, self.view.width,600)];
       [self.scrollview setContentSize:CGSizeMake(0, 600)];
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -m 弹出支付窗口
- (IBAction)clickToPay:(id)sender {
    backgroundView.hidden = NO;
        [payview setFrame:CGRectMake(0, self.view.height, self.view.width, 345)];
    [UIView animateWithDuration:0.35 animations:^{
        [payview setFrame:CGRectMake(0, self.view.height-345, self.view.width, 345)];
    }];
}

#pragma mark -m 将支付窗口放下
-(void)downPayVoew{
    [UIView animateWithDuration:0.35 animations:^{
        [payview setFrame:CGRectMake(0, self.view.height, self.view.width, 345)];
        backgroundView.hidden = YES;
    }];
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
