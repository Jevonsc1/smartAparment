//
//  TDString.h
//  TrudianLife
//
//  Created by bbapplepen on 2017/1/10.
//  Copyright © 2017年 trudian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDString : NSObject
+ (NSAttributedString*)string:(NSString*)string color:(UIColor*)color nsrange:(NSRange )nsrange;

+(CGFloat)countHeight:(NSString*)string font:(CGFloat)fontsize width:(CGFloat)width lineSpace:(CGFloat)lineSpace;

+(CGFloat)countWidth:(NSString*)string font:(CGFloat)fontsize height:(CGFloat)height lineSpace:(CGFloat)lineSpace;

+(CGFloat)countWidth:(NSString *)string fontt:(UIFont*)font height:(CGFloat)height lineSpace:(CGFloat)lineSpace;

+(NSString*)screctString:(NSString*)string dispalyNum:(NSUInteger)dispalyNum;
@end
