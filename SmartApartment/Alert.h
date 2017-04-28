//
//  Alert.h
//  CarLife
//
//  Created by kenshinhu on 2/28/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface Alert : NSObject
+(void)showFail:(NSString *)msg View:(UIView *)view andTime:(int)delay complete:(void (^)(BOOL isComplete))complete;
+(void)showSucces:(NSString *)msg View:(UIView *)view andTime:(int)delay complete:(void(^)(BOOL isComplete))complete ;
+(void)showFail:(NSString *)msg View:(UIView *)view andY:(CGFloat)offset andTime:(int)delay complete:(void (^)(BOOL isComplete))complete;

@end
