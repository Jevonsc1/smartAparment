//
//  TDBindingICCardStartViewController.h
//  SmartApartment
//
//  Created by 刘靖 on 2017/4/7.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDBindingICCardBaseViewController.h"
#import "AcModel.h"
@interface TDBindingICCardStartViewController : TDBindingICCardBaseViewController

@property (strong, nonatomic) NSString *houseID;

@property(copy,nonatomic)NSString* memberID;

@property (nonatomic,strong)AcModel* acmodel;

@end
