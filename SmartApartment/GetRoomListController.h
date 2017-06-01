//
//  GetRoomListController.h
//  SmartApartment
//
//  Created by Trudian on 16/12/27.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Community.h"
@interface GetRoomListController : UITableViewController
@property(nonatomic)NSString *wayIn;

@property(strong,nonatomic)NSArray<Community *> *apartmentArr;
@end
