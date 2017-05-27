//
//  communityDetailController.h
//  SmartApartment
//
//  Created by Trudian on 17/1/20.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Community.h"
@interface communityDetailController : UITableViewController
@property(nonatomic)Community *model;
@property(nonatomic)CGFloat tagHeight;
@end
