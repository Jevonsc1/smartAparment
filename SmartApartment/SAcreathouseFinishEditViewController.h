//
//  SAcreathouseFinishEditViewController.h
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/19.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "House.h"

@interface SAcreathouseFinishEditViewController : UIViewController

@property(nonatomic,copy) void (^TDPersonMyDataDetailViewControllerBlock)(House* house);

@property(nonatomic,strong)House* house;

@end
