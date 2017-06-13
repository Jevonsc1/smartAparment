//
//  SignRoomOKController.h
//  SmartApartment
//
//  Created by Trudian on 16/12/28.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Community.h"
@interface SignRoomOKController : UITableViewController
@property(nonatomic,strong)House *house;
@property(nonatomic,strong)Community* community;
@property(nonatomic,copy)NSString *mainRenter;
@property(nonatomic,copy)NSString *rentTime;
@property(nonatomic,assign)NSInteger renterStatus;
@property(nonatomic,strong)NSDictionary *renterDic;
@end
