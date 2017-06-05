//
//  RenterBillController.m
//  SmartApartment
//
//  Created by Trudian on 16/12/30.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "RenterBillController.h"
#import "RenterBillCell.h"
#import "WXApi.h"
#import <CommonCrypto/CommonDigest.h>
#import <AlipaySDK/AlipaySDK.h>
#import "renterPayResultController.h"
#import "RenterBillHistoryController.h"
#import "payView.h"
#import "MyDelegateDic.h"
#import "RoomDianDetailController.h"
#import "House.h"
#import "Bill.h"
#define textGray cell.cellContent.textColor = TDRGB(139, 139, 139);
#define textDark cell.cellContent.textColor = TDRGB(51, 51, 51);

@interface RenterBillController ()<WXApiDelegate,MyDelegateDic>
@property (weak, nonatomic) IBOutlet UIButton *payBrn;
@property(nonatomic,strong)House* house;
@property(nonatomic,strong)NSMutableArray* billArray;
@property(nonatomic,strong)Bill* curBill;

@property(nonatomic,strong)Good* waterGood;
@property(nonatomic,strong)Good* roomMoneyGood;
@property(nonatomic,strong)Good* otherGood;
@property(nonatomic,strong)Good* preNotPayGood;
@property(nonatomic,strong)Good* masterEditGood;
@property(nonatomic,strong)Good* electrictGood;

@property(nonatomic,copy)NSString *currentDate;
@end

@implementation RenterBillController
{
    
    
    NSString *storeKey;
    UIView *backgroundView;
    payView *payview;
    
    UIView *bgView;
}

-(NSMutableArray *)billArray{
    if (!_billArray) {
        _billArray = [NSMutableArray array];
    }
    return _billArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSDictionary *oneDic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",@"1",@"availableRentRecord",@"2.0",@"version", nil];
    [WebAPI getRentRecordInfo:oneDic callback:^(NSError *err, id response) {
        if (!err && [response intForKey:@"rcode"] == 10000) {
         
            NSArray *rentInfoArr = [response objectForKey:@"data"];
            if (rentInfoArr.count <=0) {
                [Alert showFail:@"您没有租赁信息！" View:self.navigationController.navigationBar andTime:1 complete:nil];
                return ;
            }
     
            NSDictionary *allDic = [response objectForKey:@"data"][0];
            NSMutableDictionary* houseDic = [[allDic objectForKey:@"houseInfo"] mutableCopy];
            houseDic[@"rentInfo"] = [allDic objectForKey:@"rentInfo"];
            
            self.house = [House yy_modelWithDictionary:houseDic];

            if (self.house.rentInfo.count >0) {
                Rent* rent = self.house.rentInfo[0];
                NSString *renterID = [NSString stringWithFormat:@"%@",[ModelTool find_UserData].renterID];
                
                for (Renter* renter in rent.renterInfo) {
                    if ([renterID isEqualToString:renter.renterID.stringValue]) {
                        if ([renter.renterRoleID isEqual:@1]) {
                            self.payBrn.userInteractionEnabled = YES;
                            break;
                        }else{
                            [self.payBrn setBackgroundImage:nil forState:UIControlStateNormal];
                            self.payBrn.layer.cornerRadius = 7;
                            self.payBrn.backgroundColor = TDRGB(153, 153, 153);
                            self.payBrn.userInteractionEnabled = NO;
                        }
                    }
                }
                
                 [self getBillListWith:rent.rentRecordID.stringValue];
                
            }
           
        }else{
            RequestBad
        }
    }];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(succesPay) name:@"houseAlipayOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failPay) name:@"houseAlipayFail" object:nil];
    [[NSUserDefaults standardUserDefaults] setObject:@"houseMoney" forKey:@"aliPayWay"];
    
   

}
//没有账单的情况下，创建没有数据的界面
-(void)initNodataView{
    bgView= [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.view.width, self.view.height)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 150*ratio, 186*ratio)];
    iconView.centerX = bgView.centerX;
    [iconView setImage:[UIImage imageNamed:@"nodata"]];
    [bgView addSubview:iconView];
    [self.navigationController.navigationBar addSubview:bgView];
}



//获取账单记录
-(void)getBillListWith:(NSString*)rentRecordID{
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",rentRecordID,@"rentRecordID", nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebAPI getRentRecordAvailabelBillList:dic callback:^(NSError *err, id response) {
        if (!err && [response intForKey:@"rcode"] == 10000) {
            
            NSArray* array = [response objectForKey:@"data"];
            if (array.count <= 0) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showMessage:@"当前没有账单！"];
                [self initNodataView];
                return ;
            }
            
            [self.billArray removeAllObjects];
            for (NSDictionary* dic in array) {
                Bill* bill = [Bill yy_modelWithDictionary:dic];
                [self.billArray addObject:bill];
            }
            
            self.curBill = [self.billArray lastObject];
            self.currentDate = self.curBill.payBillTime;
            [self setupByBill];
           
      
           
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView reloadData];
        }else{
            RequestBad
        }
    }];
}

-(void)setupByBill{
    
    NSString* time = [TimeDate timeToTimeSp: self.curBill.payBillTime];
    NSString *year = [time substringToIndex:4];
    NSString *month = [time substringFromIndex:4];
    self.title = [NSString stringWithFormat:@"%@年%@月",year,month];
    
    NSArray *goodsArr = self.curBill.goodsInfo;
    for (Good* obj in goodsArr) {
        NSString  *goodID = obj.goodsID;
        if (goodID.integerValue == 1) {
            self.waterGood = obj;
        }
        if (goodID.integerValue == 2) {
            self.electrictGood = obj;
        }
        if (goodID.integerValue == 3) {
            self.roomMoneyGood = obj;
        }
        if (goodID.integerValue == 4) {
            self.otherGood = obj;
        }
        if (goodID.integerValue == 5) {
            self.preNotPayGood = obj;
        }
        if (goodID.integerValue == 6) {
            self.masterEditGood = obj;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2 && indexPath.row == 0) {
        RoomDianDetailController *vc = [[UIStoryboard storyboardWithName:@"ApartmentBill" bundle:nil] instantiateViewControllerWithIdentifier:@"RoomDianDetail"];
        vc.wayIn = 1;
        vc.houseID = self.house.houseID.stringValue;
        vc.monthDate = [TimeDate timeToTimeSp:self.curBill.payBillTime];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 2 && indexPath.row == 1){
        RoomDianDetailController *vc = [[UIStoryboard storyboardWithName:@"ApartmentBill" bundle:nil] instantiateViewControllerWithIdentifier:@"RoomDianDetail"];
        vc.wayIn = 2;
        vc.houseID = self.house.houseID.stringValue;
        vc.monthDate = [TimeDate timeToTimeSp:self.curBill.payBillTime];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RenterBillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RenterBillCell"];
    if ((indexPath.section == 0 && indexPath.row == 0) ||(indexPath.section == 5 && indexPath.row == 0)) {
        [cell.cellIcon setImage:[UIImage imageNamed:@"room_bill_icon11"]];
       cell.cellName.text = @"账单金额";
        
        if (self.curBill) {
            cell.cellContent.text = [NSString stringWithFormat:@"%@元",self.curBill.payBillTotalPay];

        }
           
            
        cell.cellContent.font = [UIFont systemFontOfSize:20 *ratio];
        cell.cellContent.textColor = TDRGB(229, 89, 89);
        
        
        [cell.AnchorRatio setConstant:-11];
        return cell;
    }
    else if (indexPath.section == 1 && indexPath.row == 0){
        [cell.cellIcon setImage:[UIImage imageNamed:@"room_bill_icon6"]];
        cell.cellName.text  = @"记账周期";
        textGray
        cell.cellName.font = [UIFont systemFontOfSize:16*ratio];
         if (self.curBill) {
             cell.cellContent.text = [NSString stringWithFormat:@"%@至%@",self.curBill.billStartDate,self.curBill.billEndDate];
         }
        cell.cellContent.textColor = TDRGB(139, 139, 139);
        cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
         [cell.AnchorRatio setConstant:-11];
    }else if (indexPath.section == 1 && indexPath.row == 1){
        [cell.cellIcon setImage:[UIImage imageNamed:@"room_bill_icon8"]];
        cell.cellName.text = @"房租";
         if (self.curBill) {
        cell.cellContent.text = [NSString stringWithFormat:@"%@元",self.roomMoneyGood.goodsPrice];
        textGray
         }
        [cell.AnchorRatio setConstant:-11];
    }else if (indexPath.section == 1&&indexPath.row == 2){
        [cell.cellIcon setImage:[UIImage imageNamed:@"room_bill_icon7"]];
        cell.cellName.text = @"其他费用";
         if (self.curBill) {
        cell.cellContent.text = [NSString stringWithFormat:@"%@元",self.otherGood.goodsPrice];
        textGray
         }
        [cell.AnchorRatio setConstant:-11];
    }else if (indexPath.section == 2 && indexPath.row == 0){
        [cell.cellIcon setImage:[UIImage imageNamed:@"renter_bill_dian"]];
        cell.cellName.text = @"电费";
         if (self.electrictGood) {
        textGray
        cell.cellContent.text = [NSString stringWithFormat:@"%@元",self.electrictGood.goodsPrice];
         }else{
             cell.cellContent.text = @"0 元";
         }
        [cell.AnchorRatio setConstant:0];
        [cell.cellIconRatio setConstant:-3];
    }
    else if (indexPath.section == 2 && indexPath.row == 1){
        [cell.cellIcon setImage:[UIImage imageNamed:@"check_water_icon"]];
        cell.cellName.text = @"水费";
         if (self.waterGood) {
        textGray
        cell.cellContent.text = [NSString stringWithFormat:@"%@元",self.waterGood.goodsPrice];
         }else{
              cell.cellContent.text = @"0 元";
         }
        [cell.AnchorRatio setConstant:0];
        [cell.cellIconRatio setConstant:-1];
    }
    else if (indexPath.section == 3 && indexPath.row == 0){
        [cell.cellIcon setImage:[UIImage imageNamed:@"room_bill_nopay"]];
        cell.cellName.text = @"上期未缴";
         if (self.preNotPayGood) {
        cell.cellContent.text = [NSString stringWithFormat:@"%@元",self.preNotPayGood.goodsPrice];
        textDark
         }else{
               cell.cellContent.text = @"0 元";
         }
        [cell.AnchorRatio setConstant:-11];
        [cell.cellIconRatio setConstant:0];
        
    }
    else if (indexPath.section == 3 && indexPath.row == 1){
        [cell.cellIcon setImage:[UIImage imageNamed:@"room_bill_wait2"]];
        cell.cellName.text = @"房主调整费用";
         if (self.masterEditGood) {
        cell.cellContent.text = [NSString stringWithFormat:@"%@元",self.masterEditGood.goodsPrice];
        textDark
         }else{
               cell.cellContent.text = @"0 元";
         }
        [cell.AnchorRatio setConstant:-11];
        [cell.cellIconRatio setConstant:0];
        
    }
    else if (indexPath.section == 4 && indexPath.row == 0){
        [cell.cellIcon setImage:[UIImage imageNamed:@"room_bill_icon9"]];
        cell.cellName.text = @"固定费用合计";
         if (self.curBill) {
        cell.cellContent.text = [NSString stringWithFormat:@"%@元",self.roomMoneyGood.goodsPrice];
        textDark
        }
        [cell.AnchorRatio setConstant:-11];
        [cell.cellIconRatio setConstant:0];
        
    }
    else if (indexPath.section == 4 && indexPath.row == 1){
        [cell.cellIcon setImage:[UIImage imageNamed:@"room_bill_icon10"]];
        cell.cellName.text = @"非固定费用合计";
         if (self.curBill) {
        cell.cellContent.text =[NSString stringWithFormat:@"%.2f元",self.electrictGood.goodsPrice.floatValue+self.waterGood.goodsPrice.floatValue];
        textDark
         }
        [cell.AnchorRatio setConstant:-11];
        [cell.cellIconRatio setConstant:0];
        
    }
    else if (indexPath.section == 4 && indexPath.row == 2){
        [cell.cellIcon setImage:[UIImage imageNamed:@"room_bill_icon10"]];
        cell.cellName.text = @"其他费用合计";
         if (self.curBill) {
        cell.cellContent.text = [NSString stringWithFormat:@"%.2f元",self.masterEditGood.goodsPrice.floatValue+self.preNotPayGood.goodsPrice.floatValue];
        textDark
         }
        [cell.AnchorRatio setConstant:-11];
        [cell.cellIconRatio setConstant:0];
        
    }else{
        [cell.cellIcon setImage:[UIImage imageNamed:@"room_bill_icon12"]];
        cell.cellName.text = @"待缴费用";
        [cell.AnchorRatio setConstant:-11];
        cell.cellName.textColor = TDRGB(229, 89, 89);
        if (self.curBill) {
            
            if (self.curBill.payBillStatus.integerValue == 0) {
                
                cell.cellContent.text =[NSString stringWithFormat:@"%.2f元", self.curBill.payBillNotPay.floatValue+self.curBill.payBillFreezingPay.floatValue];
                cell.cellContent.font = [UIFont systemFontOfSize:20 *ratio];
                cell.cellContent.textColor = TDRGB(229, 89, 89);
                self.payBrn.hidden = NO;
                
            }else{
                cell.cellContent.text = @"已缴清";
                cell.cellContent.textColor =MainGreen;
                self.payBrn.userInteractionEnabled = NO;
                self.payBrn.hidden = YES;
                [self.payBrn setBackgroundImage:nil forState:UIControlStateNormal];
                [self.payBrn setBackgroundColor:[UIColor lightGrayColor]];
            }
            payview.money.text = self.curBill.payBillNotPay;
        }
    }
   
    return cell;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 6;
}

-(void)passValueForBill:(Bill *)value{
    self.curBill = value;
    [self setupByBill];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return  1;
    }
    else if (section == 1){
        return 3;
    }else if (section == 2){
        return 2;
    }else if (section == 3){
        return 2;
    }else if (section == 4){
        return 3;
    }else{
        if ([self.curBill.payBillTime isEqualToString:self.currentDate]) {
            return 2;
        }else{
            return 1;
        }
        
        
       
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32*ratio;
}
//定义sectionHeader的样式
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 32*ratio)];
    view.backgroundColor = TDRGB(245.0,245.0, 245.0);
    //长条
    UIView *smallView = [[UIView alloc]initWithFrame:CGRectMake(17, 0, 7 *ratio, 17*ratio)];
    if (section % 3 == 0) {
        smallView.backgroundColor = MainBlue;
    }else if(section %3 == 1){
        smallView.backgroundColor = MainRed;
    }else{
        smallView.backgroundColor = MainGreen;
    }
    
    //文字
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width/2, 32*ratio)];
    
    label.font = [UIFont systemFontOfSize:14 *ratio];
    label.textColor = TDRGB(136.0, 136.0, 136.0);
    if (section == 0) {
        label.text = @"账单金额";
    }else if (section == 1){
        label.text = @"固定费用明细";
    }else if(section == 2){
        label.text = @"非固定费用明细";
    }else if (section == 3){
        label.text = @"其他费用明细";
    }else if (section == 4){
        label.text = @"费用合计";
    }else{
        label.text = @"账单金额";
    }
    //边线
    UIView *oneline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1)];
    oneline.backgroundColor = TDRGB(223, 223, 223);
    UIView *twoline = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1, self.view.width, 1)];
    twoline.backgroundColor = TDRGB(223, 223, 223);
    
    
    
    //添加控件
    [view addSubview:oneline];
    [view addSubview:twoline];
    [view addSubview:smallView];
    [view addSubview:label];
    smallView.centerY = view.centerY;
    label.centerY = view.centerY;
    label.x = smallView.x + smallView.width+8;
    
    return view;
}
- (IBAction)clickToPop:(id)sender {
    [bgView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickToHistory:(id)sender {
    RenterBillHistoryController *vc = [[UIStoryboard storyboardWithName:@"RenterBill" bundle:nil] instantiateViewControllerWithIdentifier:@"RenterBillHistory"];
    vc.billArr = self.billArray;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
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
-(void)wechatPayBill{
    //    [Alert showFail:@"微信支付尚未开通！" View:self.navigationController.navigationBar andTime:3 complete:nil];
    //    return;
    [WXApi registerApp:@"wx87c82e0d6c1f9052"];
    
    if (self.curBill.payBillID.length > 0) {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",self.curBill.payBillID,@"payBillID", nil];
        [WebAPI payBill:dic callback:^(NSError *err, id response) {
            if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
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
-(void)alipayBill{
    if (self.curBill.payBillID.length>0) {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",self.curBill.payBillID,@"payBillID", nil];
        [WebAPI payBill:dic callback:^(NSError *err, id response) {
            if (!err&&[NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
                [[NSUserDefaults standardUserDefaults] setObject:@"houseMoney" forKey:@"aliPayWay"];
                
                NSString *appScheme = @"smart";
            
                NSString *alipay_str = [[[response objectForKey:@"data"] objectForKey:@"aliPay"] objectForKey:@"payURL"];
                [[AlipaySDK defaultService]payOrder:alipay_str fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    if ([NSString stringWithFormat:@"%@",[resultDic objectForKey:@"resultStatus"]].integerValue == 9000) {
                        [self succesPay];
                    }else{
                        [self failPay];
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
        
    }else{
        [Alert showFail:@"暂无账单！" View:self.navigationController.navigationBar andTime:2 complete:^(BOOL isComplete) {
            
        }];
    }
}
-(void)succesPay{
    renterPayResultController *vc = [[UIStoryboard storyboardWithName:@"Charges" bundle:nil] instantiateViewControllerWithIdentifier:@"renterPayResult"];
    vc.resultType = @"ok";
    vc.money = @"";
    vc.inWay = @"renter";
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)failPay{
    renterPayResultController *vc = [[UIStoryboard storyboardWithName:@"Charges" bundle:nil] instantiateViewControllerWithIdentifier:@"renterPayResult"];
    vc.resultType = @"fail";
    vc.inWay = @"renter";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -m 弹出支付窗口
- (IBAction)clickToPay:(UIButton *)sender {
    payview = [[NSBundle mainBundle] loadNibNamed:@"charges" owner:self options:nil][0];
    
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.contentOffset.y, self.view.width, self.view.height)];
    backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    backgroundView.hidden = YES;
    [payview setFrame:CGRectMake(0,backgroundView.height, self.view.width,  345*ratio)];
    [backgroundView addSubview:payview];
    [self.tableView insertSubview:backgroundView atIndex:9999];
    backgroundView.hidden = NO;
    self.tableView.scrollEnabled = NO;
    payview.money.text = self.curBill.payBillTotalPay;
    
    payview.orderIDLabel.text = [NSString stringWithFormat:@"订单编号: %@",self.curBill.payBillID];
    [payview.wechatBtn addTarget:self action:@selector(wechatPayBill) forControlEvents:UIControlEventTouchDown];
    [payview.cancelBtn addTarget:self action:@selector(downPayView) forControlEvents:UIControlEventTouchDown];
    [payview.aliPayBtn addTarget:self action:@selector(alipayBill) forControlEvents:UIControlEventTouchDown];
    [payview setFrame:CGRectMake(0, self.view.height, self.view.width, 345*ratio)];
        [UIView animateWithDuration:0.35 animations:^{
            [payview setFrame:CGRectMake(0, self.view.height- 345*ratio, self.view.width,  345*ratio)];
        }];
    
}

#pragma mark -m 将支付窗口放下
-(void)downPayView{
    
    [UIView animateWithDuration:0.5 animations:^{
        [payview setFrame:CGRectMake(0, self.view.height, self.view.width, 345*ratio)];
    }];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
    self.tableView.scrollEnabled =YES;
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        backgroundView.hidden = YES;
        [backgroundView removeFromSuperview];
    });
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
