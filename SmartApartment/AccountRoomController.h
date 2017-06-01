//
//  AccountRoomController.h
//  SmartApartment
//
//  Created by Trudian on 17/1/9.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDelegate.h"
#import "House.h"
@interface AccountRoomController : UIViewController
@property(nonatomic,strong)House *house;
@property(nonatomic)NSObject<MyDelegate> *delegate;

@end
