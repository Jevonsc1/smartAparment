//
//  AccountRoomController.h
//  SmartApartment
//
//  Created by Trudian on 17/1/9.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDelegate.h"
@interface AccountRoomController : UIViewController
@property(nonatomic)NSString *houseID;
@property(nonatomic)NSObject<MyDelegate> *delegate;
@property(nonatomic)NSString *apartmentID;
@property(nonatomic)NSString *communityName;
@property(nonatomic)NSString *houseNum;
@property(nonatomic)NSDictionary *rentInfo;
@end
