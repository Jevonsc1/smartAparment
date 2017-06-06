//
//  TDPricingPackageInfoViewController.h
//  SmartApartment
//
//  Created by 刘靖 on 2017/2/23.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    eligiblyOne,
    eligiblyTwo,
    eligiblyThree,
    eligiblyFour,
    eligiblyCustom,
    nextStep,
} PackageInfoButtonTag;

@interface TDPricingPackageInfoViewController : UIViewController

@property (strong, nonatomic) NSString *telecomID;
@end
