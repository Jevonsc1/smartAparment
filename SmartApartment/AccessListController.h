//
//  AccessListController.h
//  SmartApartment
//
//  Created by Trudian on 17/2/15.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Community.h"

@interface AccessListController : UIViewController

@property(nonatomic,strong)NSArray<Community *>* communityArray;
@end
