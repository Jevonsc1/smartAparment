//
//  UIView+TDExtension.h
//  TrudianLife
//
//  Created by farbell-imac on 16/9/8.
//  Copyright © 2016年 trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TDExtension)

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

/**
 * 判断一个控件是否真正显示在主窗口
 */
- (BOOL)isShowingOnKeyWindow;

//- (CGFloat)x;
//- (void)setX:(CGFloat)x;
/** 在分类中声明@property, 只会生成方法的声明, 不会生成方法的实现和带有_下划线的成员变量*/

+ (instancetype)viewFromXib;

#pragma mark -m 圆角以及边框
+ (UIView *)cornerAndBorder:(UIView *)view andBorderWidth:(CGFloat)width andColor:(UIColor *)color andRedis:(CGFloat)redis;


@end
