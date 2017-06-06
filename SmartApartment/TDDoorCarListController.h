//
//  TDDoorCarListController.h
//  SmartApartment
//
//  Created by Jevons on 2017/5/4.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TDDoorCarListController : UIViewController

@property (strong, nonatomic) NSString *houseID;

@property(nonatomic,strong)NSMutableArray* acModelArray;

@property(nonatomic,copy)NSString* memberID;


@end
