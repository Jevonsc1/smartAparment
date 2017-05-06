//
//  RenterAccessMsgController.h
//  SmartApartment
//
//  Created by Trudian on 17/2/15.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Renter.h"
@interface RenterAccessMsgController : UITableViewController

//租客信息
@property(nonatomic,strong)Renter* renter;
@property(nonatomic,assign)NSInteger payDayNum;

@end
