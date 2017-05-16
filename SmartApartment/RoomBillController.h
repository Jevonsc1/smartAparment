//
//  RoomBillController.h
//  SmartApartment
//
//  Created by Trudian on 16/12/12.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "House.h"
@interface RoomBillController : UITableViewController
@property(nonatomic,strong)House* house;
@property(nonatomic)NSString *mainName;
@property(nonatomic)NSString *wayIn;
@property(nonatomic)NSString *billType;


@property(nonatomic,strong)Renter* renter;


@end
