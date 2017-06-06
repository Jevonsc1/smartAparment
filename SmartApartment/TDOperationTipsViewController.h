//
//  TDOperationTipsViewController.h
//  SmartApartment
//
//  Created by 刘靖 on 2017/2/24.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    OnlinePaymentSuccess,           // 在线支付成功
    OnlinePaymentSuccess_Aut,       // 在线支付成功，且需要认证
    OnlinePaymentFailure,           // 在线支付失败
    MakeAnAppointmentSuccess,       // 线下预约成功
    MakeAnAppointmentSuccess_Aut,   // 线下预约成功，且需要认证
    MakeAnAppointmentFailure,       // 线下预约失败
} OperationTips;

@interface TDOperationTipsViewController : UIViewController
@property (strong, nonatomic) NSString *orderID;
@property (strong, nonatomic) NSDictionary *dictionary;
@property (assign, nonatomic) OperationTips operationTips;
@end
