//
//  RoomBillController.m
//  SmartApartment
//
//  Created by Trudian on 16/12/12.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "RoomBillController.h"
#import "RoomDianDetailController.h"
#import "RoomBillWaitController.h"
@interface RoomBillController ()
@property (weak, nonatomic) IBOutlet UIButton *payBillBtn;
@property (weak, nonatomic) IBOutlet UILabel *apartmentNameLab;
@property (weak, nonatomic) IBOutlet UILabel *rentTime;
@property (weak, nonatomic) IBOutlet UILabel *mainRenter;
@property (weak, nonatomic) IBOutlet UILabel *rentMoney;
@property (weak, nonatomic) IBOutlet UILabel *payRentTime;
@property (weak, nonatomic) IBOutlet UILabel *rememberTime;
@property (weak, nonatomic) IBOutlet UILabel *roomMoney;
@property (weak, nonatomic) IBOutlet UILabel *repairMoney;
@property (weak, nonatomic) IBOutlet UILabel *lightMoney;
@property (weak, nonatomic) IBOutlet UILabel *electricMoney;
@property (weak, nonatomic) IBOutlet UILabel *waterMoney;
@property (weak, nonatomic) IBOutlet UILabel *gasMoney;
@property (weak, nonatomic) IBOutlet UILabel *preNotPay;
@property (weak, nonatomic) IBOutlet UILabel *fixedPay;
@property (weak, nonatomic) IBOutlet UILabel *notFixedPay;
@property (weak, nonatomic) IBOutlet UILabel *allMoneyPay;
@property (weak, nonatomic) IBOutlet UILabel *waitToPay;
@property (weak, nonatomic) IBOutlet UILabel *payStatus;
@property (weak, nonatomic) IBOutlet UIImageView *payIcon;
@property (weak, nonatomic) IBOutlet UILabel *otherPay;
@property (weak, nonatomic) IBOutlet UILabel *doorLabel;
@property (weak, nonatomic) IBOutlet UIButton *doorBtn;
@property (weak, nonatomic) IBOutlet UIImageView *doorIcon;

@end

@implementation RoomBillController
{
    NSString *waterMoney1;
    NSString *eletrictMoney;
    NSString *acEnable;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.wayIn isEqualToString:@"hadPay"]) {
        [self GetHadPayRoomBill];
    }else{
        [self GetRoomBill];
    }
    
    
}

-(void)GetHadPayRoomBill{
    NSLog(@"%@",self.roomDic);
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMM"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",[NSString stringWithFormat:@"%@",[self.roomDic objectForKey:@"houseID"]],@"houseID",dateString,@"monthDate" ,nil];
    [WebAPI getHouseAvailableBill:dic callback:^(NSError *err, id response) {
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            NSArray *dataArr = [response objectForKey:@"data"];
            if (dataArr.count >0) {
                NSDictionary *dataDic = dataArr[0];
                NSDictionary *rentInfo = [dataDic objectForKey:@"rentInfo"][0];
                NSDictionary *billInfo = [dataDic objectForKey:@"billInfo"];
                 NSArray *goodsInfo = [billInfo objectForKey:@"goodsInfo"];
                self.roomDic = dataDic;
              
                @try {
                    self.title = [NSString stringWithFormat:@"%@房",[dataDic objectForKey:@"houseNum"]];
                    NSArray *comArr = [dataDic objectForKey:@"communityInfo"];
                    NSDictionary *comDic = comArr[0];
                    self.apartmentNameLab.text =[comDic  objectForKey:@"communityName"];
                    self.rentTime.text = [NSString stringWithFormat:@"%@至%@",[TimeDate timeWithTimeIntervalString:[[self.roomDic objectForKey:@"rentInfo"][0]  objectForKey:@"rentTime"]],[TimeDate timeWithTimeIntervalString:[[self.roomDic objectForKey:@"rentInfo"][0]  objectForKey:@"rentDueTime"]]];
                    NSString *outPayTime = [[self.rentTime.text substringToIndex:10] substringFromIndex:8];
                    NSLog(@"%@",outPayTime);
                    self.mainRenter.text = self.mainName;
                    self.rentMoney.text = [NSString stringWithFormat:@"%@元",[rentInfo objectForKey:@"rentDeposit"]];
                    //        self.payRentTime.text = [TimeDate timeWithTimeIntervalString:[[self.roomDic objectForKey:@"billInfo"] objectForKey:@"payBillTime"]];
//                    NSString *days = [[self.roomDic objectForKey:@"rentInfo"][0] objectForKey:@"rentRecordGraceDays"];
                    self.payRentTime.text =[NSString stringWithFormat:@"%@号",outPayTime];
                    self.rememberTime.text = [NSString stringWithFormat:@"%@至%@",[[self.roomDic objectForKey:@"billInfo"] objectForKey:@"billStartDate"],[[self.roomDic objectForKey:@"billInfo"] objectForKey:@"billEndDate"]];
                    self.repairMoney.text = [NSString stringWithFormat:@"0元"];
                    self.lightMoney.text = [NSString stringWithFormat:@"0元"];
                    [goodsInfo enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSDictionary *dic = obj;
                        //电费
                        if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"goodsID"]].integerValue == 2 ) {
                            self.electricMoney.text =[NSString stringWithFormat:@"%@", [dic RMBForKey:@"goodsPrice"]];
                            eletrictMoney = [NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[dic objectForKey:@"goodsPrice"]].floatValue];
                        }
                        //租金
                        if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"goodsID"]].integerValue == 3) {
                            self.roomMoney.text =[NSString stringWithFormat:@"%@", [dic RMBForKey:@"goodsPrice"]];
                        }
                        //水费
                        if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"goodsID"]].integerValue == 1) {
                            self.waterMoney.text =[NSString stringWithFormat:@"%@", [dic RMBForKey:@"goodsPrice"]];
                             waterMoney1 = [NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[dic objectForKey:@"goodsPrice"]].floatValue];
                            
                        }
                        //上期未缴
                        if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"goodsID"]].integerValue == 5) {
                            self.preNotPay.text =[NSString stringWithFormat:@"%@", [dic RMBForKey:@"goodsPrice"]];
                        }
                        if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"goodsID"]].integerValue == 4) {
                            self.otherPay.text=[NSString stringWithFormat:@"%@", [dic RMBForKey:@"goodsPrice"]];
                        }
                        
                    }];
                    
                    //固定费用--暂未加入维修基金以及楼梯灯费
                    self.fixedPay.text = [NSString stringWithFormat:@"%@",[billInfo RMBForKey:@"payBillFixedCostInfo"]];
                    //非固定费用
                    NSString *rmb =  [NSString stringWithFormat:@"%.2f",waterMoney1.floatValue+eletrictMoney.floatValue];
                    if ([rmb hasSuffix:@".00"]) {
                        rmb = [rmb stringByReplacingOccurrencesOfString:@".00" withString:@""];
                    }
                    self.notFixedPay.text = [NSString stringWithFormat:@"%@元",rmb];
                    //总费用
                    NSString *rmb1 =  [NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[billInfo objectForKey:@"payBillFixedCostInfo"]].floatValue +[NSString stringWithFormat:@"%@",[billInfo objectForKey:@"payBillVariableCostInfo"]].floatValue ];
                    if ([rmb1 hasSuffix:@".00"]) {
                        rmb1 = [rmb1 stringByReplacingOccurrencesOfString:@".00" withString:@""];
                    }
                    self.allMoneyPay.text =[NSString stringWithFormat:@"%@元",rmb1 ];
                    //待缴费用
                    NSString *rmb2 =   [NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[billInfo objectForKey:@"payBillNotPay"]].floatValue + [NSString stringWithFormat:@"%@",[billInfo objectForKey:@"payBillFreezingPay"]].floatValue];
                    if ([rmb2 hasSuffix:@".00"]) {
                        rmb2 = [rmb2 stringByReplacingOccurrencesOfString:@".00" withString:@""];
                    }
                    self.waitToPay.text = [NSString stringWithFormat:@"%@元",rmb2];
//
                    NSInteger payBillStatus = [NSString stringWithFormat:@"%@",[billInfo objectForKey:@"payBillStatus"]].integerValue;
                    if (payBillStatus == 0) {
                        [self.payBillBtn setImage:[UIImage imageNamed:@"room_bill_icon14"] forState:UIControlStateNormal];
                        [self.payIcon setImage:[UIImage imageNamed:@"room_bill_icon13"]];
                        self.payStatus.text = @"费用未缴清";
                        self.payBillBtn.tag = 1;
                    }else{
                        [self.payBillBtn setImage:[UIImage imageNamed:@"room_bill_icon14_1"] forState:UIControlStateNormal];
                        [self.payIcon setImage:[UIImage imageNamed:@"room_bill_icon13_1"]];
                        self.payStatus.text = @"费用已缴清";
                        self.payBillBtn.tag = 2;
                    }
                    
                    
                } @catch (NSException *exception) {
                    [Alert showFail:@"部分数据等待后台给出" View:self.navigationController.navigationBar andTime:3 complete:nil];
                }
                
            }
        }else{
            RequestBad
        }
    }];
}
//房间账单
-(void)GetRoomBill{
    NSDictionary *rentInfo = [self.roomDic objectForKey:@"rentInfo"][0] ;
    NSDictionary *billInfo = [self.roomDic objectForKey:@"billInfo"];
    NSArray *goodsInfo = [billInfo objectForKey:@"goodsInfo"];
    @try {
        if ([self.billType isEqualToString:@"欠费"]) {
            self.doorLabel.textColor = MainRed;
        }
        self.title = [NSString stringWithFormat:@"%@房",[self.roomDic objectForKey:@"houseNum"]];
        self.apartmentNameLab.text = self.aparmentName;
        self.rentTime.text = [NSString stringWithFormat:@"%@至%@",[TimeDate timeWithTimeIntervalString:[[self.roomDic objectForKey:@"rentInfo"][0]  objectForKey:@"rentTime"]],[TimeDate timeWithTimeIntervalString:[[self.roomDic objectForKey:@"rentInfo"][0]  objectForKey:@"rentDueTime"]]];
        self.mainRenter.text = self.mainName;
        self.rentMoney.text = [NSString stringWithFormat:@"%@",[rentInfo RMBForKey:@"rentDeposit"]];
        //        self.payRentTime.text = [TimeDate timeWithTimeIntervalString:[[self.roomDic objectForKey:@"billInfo"] objectForKey:@"payBillTime"]];
//        NSString *days = [[self.roomDic objectForKey:@"rentInfo"][0] objectForKey:@"rentRecordGraceDays"];
        self.payRentTime.text = [self dateStringAfterlocalDateForYear:0 Month:0 Day:0 Hour:0 Minute:0 Second:0 andDate:[[self.roomDic objectForKey:@"billInfo"] objectForKey:@"payBillTime"]];
        self.rememberTime.text = [NSString stringWithFormat:@"%@至%@",[[self.roomDic objectForKey:@"billInfo"] objectForKey:@"billStartDate"],[[self.roomDic objectForKey:@"billInfo"] objectForKey:@"billEndDate"]];
        self.repairMoney.text = [NSString stringWithFormat:@"0元"];
        self.lightMoney.text = [NSString stringWithFormat:@"0元"];
        [goodsInfo enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            //电费
            if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"goodsID"]].integerValue == 2 ) {
                self.electricMoney.text =[NSString stringWithFormat:@"%@", [dic RMBForKey:@"goodsPrice"]];
                eletrictMoney = [NSString stringWithFormat:@"%@",[dic RMBForKey:@"goodsPrice"]];
            }
            //租金
            if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"goodsID"]].integerValue == 3) {
                self.roomMoney.text =[dic RMBForKey:@"goodsPrice"];
            }
            //水费
            if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"goodsID"]].integerValue == 1) {
                self.waterMoney.text =[dic RMBForKey:@"goodsPrice"];
                waterMoney1 = [NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[dic objectForKey:@"goodsPrice"]].floatValue];
            }
            //上期未缴
            if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"goodsID"]].integerValue == 5) {
                self.preNotPay.text =[dic RMBForKey:@"goodsPrice"];
            }
            if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"goodsID"]].integerValue == 4) {
                self.otherPay.text=[dic RMBForKey:@"goodsPrice"];
            }
            
        }];
        
        //固定费用--暂未加入维修基金以及楼梯灯费
        self.fixedPay.text =[billInfo RMBForKey:@"payBillFixedCostInfo"];
        //非固定费用
        NSString *rmb4 =[NSString stringWithFormat:@"%.2f",waterMoney1.floatValue+eletrictMoney.floatValue];
        if ([rmb4 hasSuffix:@".00"]) {
            rmb4 = [rmb4 stringByReplacingOccurrencesOfString:@".00" withString:@""];
        }
        self.notFixedPay.text = [NSString stringWithFormat:@"%@元",rmb4];
        //总费用
        NSString *rmb =[NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[billInfo objectForKey:@"payBillFixedCostInfo"]].floatValue +[NSString stringWithFormat:@"%@",[billInfo objectForKey:@"payBillVariableCostInfo"]].floatValue ];
        if ([rmb hasSuffix:@".00"]) {
            rmb = [rmb stringByReplacingOccurrencesOfString:@".00" withString:@""];
        }
        self.allMoneyPay.text =[NSString stringWithFormat:@"%@元",rmb];
        //待缴费用
        NSString *rmb1 =[NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[billInfo objectForKey:@"payBillNotPay"]].floatValue+[NSString stringWithFormat:@"%@",[billInfo objectForKey:@"payBillFreezingPay"]].floatValue];
        if ([rmb1 hasSuffix:@".00"]) {
            rmb1 = [rmb1 stringByReplacingOccurrencesOfString:@".00" withString:@""];
        }
        self.waitToPay.text =[NSString stringWithFormat:@"%@元",rmb1];

        NSInteger payBillStatus = [NSString stringWithFormat:@"%@",[billInfo objectForKey:@"payBillStatus"]].integerValue;
        if (payBillStatus == 0) {
            [self.payBillBtn setImage:[UIImage imageNamed:@"room_bill_icon14"] forState:UIControlStateNormal];
            [self.payIcon setImage:[UIImage imageNamed:@"room_bill_icon13"]];
            self.payStatus.text = @"费用未缴清";
            self.payBillBtn.tag = 1;
        }else{
            [self.payBillBtn setImage:[UIImage imageNamed:@"room_bill_icon14_1"] forState:UIControlStateNormal];
            [self.payIcon setImage:[UIImage imageNamed:@"room_bill_icon13_1"]];
            self.payStatus.text = @"费用已缴清";
            self.payBillBtn.tag = 2;
        }
        
        
    } @catch (NSException *exception) {
        [Alert showFail:@"部分数据等待后台给出" View:self.navigationController.navigationBar andTime:3 complete:nil];
    }
    

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }else if (section==1){
        return 3;
    }else if (section == 2){
        return 2;
    }else if (section==3){
        return 5;
    }else{
        if ([self.billType isEqualToString:@"欠费"]) {
            return 2;
        }else{
            return 1;
        }
    }
}
- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickToEnableDoor:(UIButton *)sender {
    UIAlertController *ac ;
    if (acEnable.integerValue == 1) {
        ac=   [UIAlertController alertControllerWithTitle:@"提示" message:@"\n请确定是否禁用该用户门禁" preferredStyle:UIAlertControllerStyleAlert];
    }else{
        ac =[UIAlertController alertControllerWithTitle:@"提示" message:@"\n请确定是否解除该用户门禁" preferredStyle:UIAlertControllerStyleAlert];
    }
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *oneDic ;
        if (acEnable.integerValue == 1) {
            oneDic  = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"ban",[self.roomDic objectForKey:@"houseID"],@"houseID",[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key" ,nil];
        }else{
            oneDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"ban",[self.roomDic objectForKey:@"houseID"],@"houseID",[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key" ,nil];
        }
        [WebAPI operateHouseAC:oneDic callback:^(NSError *err, id response) {
            if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
                if (sender.tag ==1) {
                    sender.tag = 2;
                    CATransition *transition = [CATransition animation];
                    transition.duration = 0.5;
                    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                    transition.type = kCATransitionFade;
                    
                    [self.doorBtn.imageView.layer addAnimation:transition forKey:@"a"];
                    [self.doorBtn setImage:[UIImage imageNamed:@"room_bill_icon14_1"] forState:UIControlStateNormal];
                    [self.doorIcon setImage:[UIImage imageNamed:@"room_bill_icon13_1"]];
                    self.doorLabel.text = @"门禁已启用";
                    self.doorLabel.textColor = MainGreen;
                    if (![self.wayIn isEqualToString:@"hadPay"]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"getRoomData" object:nil];
                    }else{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"getApartmentIDS" object:nil];
                    }
                    acEnable = @"1";
                }else{
                    acEnable = @"2";
                    sender.tag = 1;
                    CATransition *transition = [CATransition animation];
                    transition.duration = 0.5;
                    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                    transition.type = kCATransitionFade;
                    
                    [self.doorBtn.imageView.layer addAnimation:transition forKey:@"a"];
                    [self.doorBtn setImage:[UIImage imageNamed:@"room_bill_icon14"] forState:UIControlStateNormal];
                    [self.doorIcon setImage:[UIImage imageNamed:@"room_bill_icon13"]];
                    self.doorLabel.text = @"门禁已禁用";
                    self.doorLabel.textColor = MainRed;
                    if (![self.wayIn isEqualToString:@"hadPay"]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"getRoomData" object:nil];
                    }else{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"getApartmentIDS" object:nil];
                    }
                }
                
            }else{
                
                RequestBad
            }
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [ac addAction:cancel];
    [ac addAction:sure];
    [self presentViewController:ac animated:YES completion:nil];
}
//点击最后一行--费用缴清的按钮
- (IBAction)clickPayBill:(UIButton *)sender {
    if (sender.tag == 1) {
                   UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"\n是否设为已缴状态" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSDictionary   *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",[[self.roomDic objectForKey:@"billInfo"] objectForKey:@"payBillID"],@"payBillID",@"0",@"payBillAmount",[NSString stringWithFormat:@"%@",[[self.roomDic objectForKey:@"billInfo"] objectForKey:@"payBillNotPay"]],@"payBillCharges", nil];
            [WebAPI editHousePayBill:dic callback:^(NSError *err, id response) {
                if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
                
                    sender.tag = 2;
                    CATransition *transition = [CATransition animation];
                    transition.duration = 0.5;
                    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                    transition.type = kCATransitionFade;
                    self.waitToPay.text = @"0元";
                    [self.payBillBtn.imageView.layer addAnimation:transition forKey:@"a"];
                    [self.payBillBtn setImage:[UIImage imageNamed:@"room_bill_icon14_1"] forState:UIControlStateNormal];
                    [self.payIcon setImage:[UIImage imageNamed:@"room_bill_icon13_1"]];
                    self.payStatus.text = @"费用已缴清";
                    if (![self.wayIn isEqualToString:@"hadPay"]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"getRoomData" object:nil];
                    }else{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"getApartmentIDS" object:nil];
                    }
                    [Alert showFail:@"调整成功！" View:self.navigationController.navigationBar andTime:1 complete:^(BOOL isComplete) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }else{
                    RequestBad
                }
            }];

            
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [ac dismissViewControllerAnimated:YES completion:nil];
        }];
        [ac addAction:ok];
        [ac addAction:cancel];
        
        [self presentViewController:ac animated:YES completion:nil];
       

    }else{
        
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"\n是否设为未缴状态" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            NSDictionary *billInfo = [self.roomDic objectForKey:@"billInfo"];
            if ([NSString stringWithFormat:@"%@",[billInfo objectForKey:@"payBillCanUnpaid"]].integerValue == 1) {
                NSDictionary   *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",[[self.roomDic objectForKey:@"billInfo"] objectForKey:@"payBillID"],@"payBillID",nil];
                [WebAPI setHousePayBillUnpaid:dic callback:^(NSError *err, id response) {
                    if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
                        
                        sender.tag = 1;
                        CATransition *transition = [CATransition animation];
                        transition.duration = 0.5;
                        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                        transition.type = kCATransitionFade;
                        [self.payBillBtn.imageView.layer addAnimation:transition forKey:@"a"];
                        [self.payBillBtn setImage:[UIImage imageNamed:@"room_bill_icon14"] forState:UIControlStateNormal];
                        self.payStatus.text = @"费用未缴清";
                        [self.payIcon setImage:[UIImage imageNamed:@"room_bill_icon13"]];
                        if (![self.wayIn isEqualToString:@"hadPay"]) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"getRoomData" object:nil];
                        }else{
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"getApartmentIDS" object:nil];
                        }
                        [ Alert showFail:@"设置账单未缴状态成功！" View:self.navigationController.navigationBar andTime:1 complete:^(BOOL isComplete) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                        
                        
                    }else{
                        RequestBad
                    }
                }];
            }
            else{
                [Alert showFail:@"无法设置为未缴状态!" View:self.navigationController.navigationBar andTime:3 complete:nil];
            }
            

            
            
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [ac dismissViewControllerAnimated:YES completion:nil];
        }];
        [ac addAction:ok];
        [ac addAction:cancel];
        
        [self presentViewController:ac animated:YES completion:nil];
        

    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2 && indexPath.row == 0) {
        RoomDianDetailController *vc = [[UIStoryboard storyboardWithName:@"ApartmentBill" bundle:nil] instantiateViewControllerWithIdentifier:@"RoomDianDetail"];
        vc.wayIn = 1;
        vc.houseID = [NSString stringWithFormat:@"%@",[self.roomDic objectForKey:@"houseID"]];
        NSString *monthDate  =[[self.roomDic objectForKey:@"billInfo"] objectForKey:@"billEndDate"];
        monthDate = [monthDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
        monthDate = [monthDate substringToIndex:monthDate.length -2];
        vc.monthDate = monthDate;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 2 && indexPath.row == 1){
        RoomDianDetailController *vc = [[UIStoryboard storyboardWithName:@"ApartmentBill" bundle:nil] instantiateViewControllerWithIdentifier:@"RoomDianDetail"];
        vc.wayIn = 2;
        vc.houseID = [NSString stringWithFormat:@"%@",[self.roomDic objectForKey:@"houseID"]];
        NSString *monthDate  =[[self.roomDic objectForKey:@"billInfo"] objectForKey:@"billEndDate"];
        monthDate = [monthDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
        monthDate = [monthDate substringToIndex:monthDate.length -2];
        vc.monthDate = monthDate;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.section == 3 && indexPath.row == 4){
        RoomBillWaitController *vc = [[UIStoryboard storyboardWithName:@"ApartmentBill" bundle:nil] instantiateViewControllerWithIdentifier:@"RoomBillWait"];
        NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [path stringByAppendingPathComponent:@"roomDic.data"];
        // 归档
        [NSKeyedArchiver archiveRootObject:self.roomDic toFile:filePath];
        [[NSUserDefaults standardUserDefaults] setObject:self.allMoneyPay.text forKey:@"allMoneyPay"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32*ratio;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 32*ratio)];
    view.backgroundColor = TDRGB(245.0,245.0, 245.0);
    //长条
    
    UIView *smallView = [[UIView alloc]initWithFrame:CGRectMake(18 *ratio, 0, 7 *ratio, 17*ratio)];
    
    
    //文字
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width/2, 32*ratio)];
    label.text = @"电表";
    label.font = [UIFont systemFontOfSize:14*ratio];
    label.textColor = TDRGB(136.0, 136.0, 136.0);
    //边线
    UIView *oneline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1)];
    oneline.backgroundColor = TDRGB(223, 223, 223);
    UIView *twoline = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1, self.view.width, 1)];
    twoline.backgroundColor = TDRGB(223, 223, 223);
    
  
    
    if (section == 0) {
        label.text = @"房屋信息";
        smallView.backgroundColor = MainBlue;
    }else if(section == 1){
        label.text = @"固定费用明细";
        smallView.backgroundColor = MainRed;
    }else if(section == 2){
        label.text = @"非固定费用明细";
        smallView.backgroundColor = MainGreen;
    }else if(section == 3){
        label.text = @"费用合计";
        smallView.backgroundColor = MainBlue;
    }else if(section == 4){
        label.text = @"操作";
        smallView.backgroundColor = MainRed;
    }

    
    //添加控件
    [view addSubview:oneline];
    [view addSubview:twoline];
    [view addSubview:smallView];
    [view addSubview:label];
    smallView.centerY = view.centerY;
    label.centerY = view.centerY;
    label.x = smallView.x+smallView.width+8;
    
    return view;
}
- (NSString *)dateStringAfterlocalDateForYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day Hour:(NSInteger)hour Minute:(NSInteger)minute Second:(NSInteger)second andDate:( NSString *)date
{
    // 当前日期
    NSDate *localDate =[NSDate dateWithTimeIntervalSince1970:[date doubleValue]]; // 为伦敦时间
    // 在当前日期时间加上 时间：格里高利历
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponent = [[NSDateComponents alloc]init];
    
    [offsetComponent setYear:year ];  // 设置开始时间为当前时间的前x年
    [offsetComponent setMonth:month];
    [offsetComponent setDay:day];
    [offsetComponent setHour:(hour+8)]; // 中国时区为正八区，未处理为本地，所以+8
    [offsetComponent setMinute:minute];
    [offsetComponent setSecond:second];
    
    // 当前时间后若干时间
    NSDate *minDate = [gregorian dateByAddingComponents:offsetComponent toDate:localDate options:0];
    
    NSString *dateString = [NSString stringWithFormat:@"%@",minDate];
    dateString = [dateString substringToIndex:10];
    NSArray *arr = [dateString componentsSeparatedByString:@"-"];
    dateString = arr[2];
    return [NSString stringWithFormat:@"%ld号",(long)[dateString integerValue]];
}
@end
