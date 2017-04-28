//
//  MyDelegateDic.h
//  SmartApartment
//
//  Created by Trudian on 16/11/10.
//  Copyright © 2016年 Trudian. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol MyDelegateDic<NSObject>
@optional
-(void)passValue:(NSDictionary *)value;
@optional
-(void)passValueForSignRoom:(NSDictionary *)value;
@end
