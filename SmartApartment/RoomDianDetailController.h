//
//  RoomDianDetailController.h
//  SmartApartment
//
//  Created by Trudian on 16/12/12.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomDianDetailController : UITableViewController
@property(nonatomic)NSInteger wayIn; //1--电费详情  2--水费详情
@property(nonatomic)NSString *houseID;
@property(nonatomic)NSString *monthDate;
@end
