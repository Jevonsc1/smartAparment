//
//  SignRoomOKController.h
//  SmartApartment
//
//  Created by Trudian on 16/12/28.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignRoomOKController : UITableViewController
@property(nonatomic)NSDictionary *roomDic;
@property(nonatomic)NSString *mainRenter;
@property(nonatomic)NSString *rentTime;
@property(nonatomic)NSInteger renterStatus;
@property(nonatomic)NSDictionary *renterDic;
@property(nonatomic)NSString *communityName;
@end
