//
//  SAHitView.m
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/7.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "SAHitView.h"

@implementation SAHitView

-(id)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *result = [super hitTest:point withEvent:event];
    [self endEditing:YES];
    return result;
}

@end
