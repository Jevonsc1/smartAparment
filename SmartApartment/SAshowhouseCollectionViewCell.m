//
//  SAshowhouseCollectionViewCell.m
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/10.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "SAshowhouseCollectionViewCell.h"
#import "House.h"
#import "BillOrder.h"
//#import "SAhouseInfoModel.h"

//#import "SAhouseRentInfoModel.h"

//#import "MJExtension.h"

//#import "SAChargeModel.h"

//#import "SAChargeInfoModel.h"

//#import "SAhouseChargeInfo.h"

//#import "SAbillInfoModel.h"

//#import "SAwaterBillModel.h"

//#import "SAelectricbillModel.h"

//#import "SArentbillModel.h"

//#import "SAotherBillModel.h"

@interface SAshowhouseCollectionViewCell()

//@property(nonatomic,strong)NSMutableArray *chargeInfoArray;
//
//@property(nonatomic,copy)NSString *keyString;

@end

@implementation SAshowhouseCollectionViewCell{
//    BOOL *hasBBMoney;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //长按手势
    UILongPressGestureRecognizer *longpressGesutre=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongpressGesture:)];
    //长按时间为1秒
    longpressGesutre.minimumPressDuration=1;
    //允许15秒中运动
    longpressGesutre.allowableMovement=15;
    //所需触摸1次
    longpressGesutre.numberOfTouchesRequired=1;
    [self addGestureRecognizer:longpressGesutre];
}

//长按手势监听
- (void)handleLongpressGesture:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {  //第一次触发执行  避免触发多次
        if ([self.delegate respondsToSelector:@selector(deletBtnCell:longPress:)]) {
            [self.delegate deletBtnCell:self longPress:sender];
        }
    }
}

- (void)setModel:(House *)model{
    self.houseNum.text = model.houseNum.stringValue;
    //houseStatus为1代表已出租，为2代表未出租
    if([model.houseStatus.stringValue isEqualToString:EMPTYHOUSE]){
        //优先级1：空置
        NSString *string =@"空置";
        self.loginPeople.attributedText=[self colorString:@"空置" color:TDGRAY2_COLOR range:NSMakeRange(0, string.length)];
        [self.backgroundImageBtn setBackgroundImage:[UIImage imageNamed:@"roomhouse_empty"] forState:UIControlStateNormal];
        return;
    }
    
    //租赁信息
    NSArray *contractArray = model.rentInfo;//合同份数
    NSInteger renterCount = 0;
    if (contractArray.count>0) {
        Rent* tempRent = [[Rent alloc]init];
        for (Rent* rent in contractArray) {
            if ([rent.rentIsDisable isEqual:@0]) {
                tempRent = rent;
                renterCount = rent.renterInfo.count;
            }else{
                tempRent = nil;
            }
        }
        
        NSAttributedString *dateOutTimeString = [self dateOut:tempRent.rentDueTime.stringValue rentTime:nil];
        
        if (tempRent != nil && dateOutTimeString.length>0) {
            //优先级2：到期
            self.loginPeople.attributedText=dateOutTimeString;
            [self.backgroundImageBtn setBackgroundImage:[UIImage imageNamed:@"roomhouse_dateout"] forState:UIControlStateNormal];
            return;
        }
    }
    
    NSArray *billArray = self.billArray;
    CGFloat payMoeny=0.0;
    
    for (House* house in billArray) {
        if ([house.houseNum isEqual:model.houseNum]) {
            //优先级3：orderState为10表示未支付；orderState为20表示已支付
            
            //水费单
            CGFloat totalWaterB =0;
            NSArray *waterAry = house.noPayOrder.waterOrder;
            for (BillOrder* billlOrder in waterAry) {
                if([billlOrder.orderState isEqual:@10]){
                    totalWaterB += billlOrder.orderGoodsAmount.floatValue;
                }
            }
           payMoeny +=totalWaterB;
            //电费单
            totalWaterB = 0;
            NSArray *eletric = house.noPayOrder.electricOrder;
            for (BillOrder* billlOrder in eletric) {
                if([billlOrder.orderState isEqual:@10]){
                    totalWaterB += billlOrder.orderGoodsAmount.floatValue;
                }
            }
            payMoeny +=totalWaterB;
            //租金单
            totalWaterB = 0;
            NSArray *rentAry = house.noPayOrder.rentOrder;
            for (BillOrder* billlOrder in rentAry) {
                if([billlOrder.orderState isEqual:@10]){
                    totalWaterB += billlOrder.orderGoodsAmount.floatValue;
                }
            }
            payMoeny +=totalWaterB;
            
            //其他费用单
            totalWaterB =0;
            NSArray *otherAry = house.noPayOrder.otherOrder;
            for (BillOrder* billlOrder in otherAry) {
                if([billlOrder.orderState isEqual:@10]){
                    totalWaterB += billlOrder.orderGoodsAmount.floatValue;
                }
            }
            payMoeny +=totalWaterB;
        }

    }

    
    if (payMoeny > 0) {
        NSString *string =[NSString stringWithFormat:@"欠费%.2f元",payMoeny];
        self.loginPeople.attributedText = [self colorString:string color:[UIColor redColor] range:NSMakeRange(2, string.length-3)];
        
        [self.backgroundImageBtn setBackgroundImage:[UIImage imageNamed:@"roomhouse_moeny"] forState:UIControlStateNormal];
        return;
    }else if(contractArray.count>0){
        //优先级4：住几个
        NSString *string =[NSString stringWithFormat:@"已入住%lu人",(unsigned long)renterCount];
        self.loginPeople.attributedText = [self colorString:string color:[UIColor redColor] range:NSMakeRange(3, 1)];
        [self.backgroundImageBtn setBackgroundImage:[UIImage imageNamed:@"roomhouse_green"] forState:UIControlStateNormal];
        return;
    }
}

- (NSAttributedString *)dateOut:(NSString*)dueTimeString rentTime:(NSString*)rentTime{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    
    //当前时间
    //NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSDate *bbEndDate = [NSDate dateWithTimeIntervalSince1970:[dueTimeString intValue]];
    
    //到期时间
    NSString *dueTime = [TimeDate timeWithTimeIntervalString:dueTimeString];
    dueTime = [dueTime stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    //相差几天
    NSInteger compareDate = [self bbCompareTwoDateWithBeginDate:currentDate
                                    end:bbEndDate];
    if(compareDate <5){
        
        NSString *string = [dueTime substringFromIndex:4];
        string = [NSString stringWithFormat:@"%@月%@日到期",[string substringToIndex:2],[string substringFromIndex:2]];
        
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:string];
        [attributedStr addAttribute:NSForegroundColorAttributeName
                              value:[UIColor redColor]
                              range:NSMakeRange(0, 6)];
        [attributedStr addAttribute:NSForegroundColorAttributeName
                              value:TDGRAY2_COLOR
                              range:NSMakeRange(6, 2)];
        
        return attributedStr;
    }else{
        return nil;
    }
}

- (NSInteger) bbCompareTwoDateWithBeginDate:(NSDate *)beginDate end:(NSDate *)endDate
{
    //创建日期格式化对象
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    
    //取两个日期对象的时间间隔：
    //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
    NSTimeInterval time=[endDate timeIntervalSinceDate:beginDate];
    
    int days=((int)time)/(3600*24);
    //int hours=((int)time)%(3600*24)/3600;
    //NSString *dateContent=[[NSString alloc] initWithFormat:@"%i天%i小时",days,hours];
    return days;
}

- (NSAttributedString*)colorString:(NSString*)string color:(UIColor*)color range:(NSRange)range{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:string];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:color
                          range:range];
    return attributedStr;
}


@end
