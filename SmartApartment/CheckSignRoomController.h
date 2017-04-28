//
//  CheckSignRoomController.h
//  SmartApartment
//
//  Created by Trudian on 16/12/28.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDelegate.h"
@interface CheckSignRoomController : UITableViewController
@property(nonatomic)NSString *houseID;
@property(nonatomic)NSObject<MyDelegate> *delegate;
@property(nonatomic)NSString *apartmentID;
@property(nonatomic)NSString *communityName;
@end
