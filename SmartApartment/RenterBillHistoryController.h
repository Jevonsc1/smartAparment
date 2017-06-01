//
//  RenterBillHistoryController.h
//  SmartApartment
//
//  Created by Trudian on 17/1/2.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDelegateDic.h"
@interface RenterBillHistoryController : UITableViewController
@property(nonatomic,strong)NSArray *billArr;//已经通过paybilltime排序的
@property(nonatomic,weak)NSObject<MyDelegateDic> *delegate;
@end
