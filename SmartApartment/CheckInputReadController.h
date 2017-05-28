//
//  CheckInputReadController.h
//  SmartApartment
//
//  Created by Trudian on 16/12/10.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Community.h"
@interface CheckInputReadController : UIViewController
//点击电费还是水费进入的
@property(nonatomic)NSString *wayIn;

@property(nonatomic,strong)Community* community;
@end
