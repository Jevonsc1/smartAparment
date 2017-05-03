//
//  SAcreditCardCheckVC.h
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/8.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "BBImagebaseVC.h"

@interface SAcreditCardCheckVC : BBImagebaseVC

@property(nonatomic,copy)NSString *apartmentNameString;
@property(nonatomic,copy)NSString *apartmentAddressString;
@property(nonatomic,copy)NSString *powerMoneyString;
@property(nonatomic,copy)NSString *waterMoneyString;
@property(nonatomic,copy)NSString *keyString;
@property(nonatomic,copy)NSString *fixIDStringString;
@property(nonatomic,copy)NSString *otherMoneyString;
@property(nonatomic,copy)NSString *otherMoneyDescriptionString;

//编辑还是新增
@property(nonatomic)NSString *editApart;
@property(nonatomic)NSString *comID;
@end
