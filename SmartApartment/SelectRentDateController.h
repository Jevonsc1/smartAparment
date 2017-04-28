//
//  SelectRentDateController.h
//  SmartApartment
//
//  Created by Trudian on 16/12/27.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDelegate.h"
@interface SelectRentDateController : UITableViewController
@property(nonatomic,weak)id<MyDelegate> delegate;
@property(nonatomic)NSString *rentTime;
@end
