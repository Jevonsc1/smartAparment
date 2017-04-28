//
//  PopHome.m
//  SmartApartment
//
//  Created by Trudian on 16/11/5.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "PopHome.h"

@implementation PopHome
+(void)popToController:(NSString *)name andVC:(UIViewController *)vc{
    NSArray * ctrlArray = vc.navigationController.viewControllers;
    
    for (UIViewController *ctrl in ctrlArray) {
        if ([NSStringFromClass(ctrl.class) isEqualToString:name]) {
            [vc.navigationController popToViewController:ctrl animated:YES];
        }
        
        
    }
}
@end
