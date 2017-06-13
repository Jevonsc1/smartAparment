//
//  CheckSignRoomController.h
//  SmartApartment
//
//  Created by Trudian on 16/12/28.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDelegate.h"
#import "Community.h"
@interface CheckSignRoomController : UITableViewController

@property(nonatomic)NSObject<MyDelegate> *delegate;


@property(nonatomic,strong)House* house;
@property(nonatomic,strong)Community* community;
@end
