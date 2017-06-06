//
//  TDBindingICCardPromptViewController.h
//  SmartApartment
//
//  Created by 刘靖 on 2017/4/7.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    BindingICCardStatusSuccess,
    BindingICCardStatusFailure,
} BindingICCardStatus;

@interface TDBindingICCardPromptViewController : UIViewController

@property (assign, nonatomic) BindingICCardStatus status;
@property (strong, nonatomic) NSString *statusDesc;
@end
