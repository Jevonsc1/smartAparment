//
//  SAMastermoneyCell.m
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/17.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "SAMastermoneyCell.h"

@implementation SAMastermoneyCell

-(void)setModel:(SAMastermoeny *)model{
    
    self.money.text=model.lgAvAmount;
    if ([model.lgAvAmount hasPrefix:@"-"]) {
        self.money.textColor=[UIColor colorWithRed:229.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1];
    }else{
        self.money.textColor=[UIColor colorWithRed:81.0/255.0 green:170.0/255.0 blue:54.0/255.0 alpha:1];
    }
    
    if ([model.lgType isEqualToString:@"order_pay"]) {
        self.moneyName.text=@"下单支付预存款";
    }
    
    if ([model.lgType isEqualToString:@"order_freeze"]) {
        self.moneyName.text=@"下单冻结预存款";
    }
    
    if ([model.lgType isEqualToString:@"order_cancel"]) {
        self.moneyName.text=@"取消订单解冻预存款";
    }
    
    if ([model.lgType isEqualToString:@"order_comb_pay"]) {
        self.moneyName.text=@"下单支付被冻结的预存款";
    }
    
    if ([model.lgType isEqualToString:@"recharge"]) {
        self.moneyName.text=@"充值";
    }
    
    if ([model.lgType isEqualToString:@"cash_apply"]) {
        self.moneyName.text=@"申请提现冻结预存款";
    }
    
    if ([model.lgType isEqualToString:@",cash_pay"]) {
        self.moneyName.text=@"提现成功";
    }
    
    if ([model.lgType isEqualToString:@"cash_del"]) {
        self.moneyName.text=@"取消提现申请";
    }
    
    if ([model.lgType isEqualToString:@"refund"]) {
        self.moneyName.text=@"退款";
    }
    self.moneyTime.text=[TimeDate timeDetailWithTimeIntervalString:model.lgAddTime];
    self.masterName.text=model.buyerName;
}

- (void)setModelNew:(SAMastermoneyNew *)modelNew{
    self.money.text=modelNew.pdCashAmount;
    
    if ([modelNew.pdCashAudingStatus isEqualToString:@"1"]) {
        self.moneyName.text=@"待审核";
    }
    
    if ([modelNew.pdCashAudingStatus isEqualToString:@"2"]) {
        self.moneyName.text=@"通过";
    }
    
    if ([modelNew.pdCashAudingStatus isEqualToString:@"3"]) {
        self.moneyName.text=@"取消驳回解冻预存款";
    }
    
    self.moneyTime.text=[TimeDate timeDetailWithTimeIntervalString:modelNew.pdCashAddTime];
    self.masterName.text=modelNew.pdCashBankUser;
}


@end
