//
//  myTabBar.h
//  SmartApartment
//
//  Created by Trudian on 16/10/29.
//  Copyright © 2016年 Trudian. All rights reserved.
//
#import <UIKit/UIKit.h>

@class MyTabBar;


@protocol MyTabBarDelegate <NSObject>

-(void)tabbarWithMiddleButtonClick:(MyTabBar *)tabBar;

@end

@interface MyTabBar : UITabBar


@property (nonatomic,weak) id<MyTabBarDelegate> myTabBarDelegate;

@property (nonatomic,strong) UIButton *middleButton;
@end
