//
//  SAcreathouseFinishVC.h
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/9.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Community.h"
@interface SAcreathouseFinishVC : UIViewController
@property(nonatomic,strong)Community* community;
@property(nonatomic,strong)NSMutableDictionary *houseDict;
@property(nonatomic,strong)NSMutableArray *houseArray;
@property(nonatomic,copy)NSString *rentMoneyString;
@property(nonatomic,copy)NSString *depostiMoneyString;
@end
