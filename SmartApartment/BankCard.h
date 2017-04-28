//
//  BankCard.h
//  SmartApartment
//
//  Created by Jevons on 2017/4/25.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankCard : NSObject
@property(nonatomic,copy)NSString* bankAccountName;
@property(nonatomic,copy)NSString* bankAddTime;
@property(nonatomic,copy)NSString* bankAddr;
@property(nonatomic,copy)NSString* bankName;
@property(nonatomic,copy)NSString* bankNum;
@property(nonatomic,strong)NSNumber* bankStatus;


@end
