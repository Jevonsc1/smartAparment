//
//  MasterBankController.h
//  SmartApartment
//
//  Created by Trudian on 16/10/31.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface MasterBankController : UIViewController
@property(nonatomic)NSString *resumeMoney;//待结算金额
@property(nonatomic,strong)User* masterUser;
@end
