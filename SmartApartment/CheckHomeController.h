//
//  CheckHomeController.h
//  SmartApartment
//
//  Created by Trudian on 16/12/9.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Community.h"
@interface CheckHomeController : UITableViewController

@property(nonatomic,strong)NSArray<Community*>* communityArray;
@end
