//
//  SAcreathouseFinishEditViewController.h
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/19.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAcreathouseFinishEditViewController : UIViewController

@property(nonatomic,copy) void (^TDPersonMyDataDetailViewControllerBlock)(NSString *rentMoeny ,NSString *depositMoeny);

@property(nonatomic,copy)NSString *depositMoneyString;

@property(nonatomic,copy)NSString *rentMoneyString;

@property(nonatomic,copy)NSString *homeNum;

@end
