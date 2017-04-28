//
//  myTabBar.m
//  SmartApartment
//
//  Created by Trudian on 16/10/29.
//  Copyright © 2016年 Trudian. All rights reserved.
//
#import "MyTabBar.h"
#import "UIView+TDExtension.h"

#define middleBtnWidth  self.superview.width/5

@class UITabBarButton;

@interface MyTabBar()

@property (nonatomic,strong) UIButton *middleButton;
@property(nonatomic, strong) UIImageView* bgView;



@end

@implementation MyTabBar


-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        //去掉所有背景
//        self.backgroundImage = [UIImage imageNamed:@"clear_bg"];
//        self.shadowImage = [UIImage imageNamed:@"clear_bg"];
        
//        UIImageView* bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TAB_BG"]];
//        [self addSubview:bgView];
//        self.bgView = bgView;
        
        UIButton *middleBtn = [[UIButton alloc] init];
        [middleBtn addTarget:self action:@selector(middleBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        [middleBtn setImage:[UIImage imageNamed:@"tabmid"] forState:UIControlStateNormal];

        [self addSubview:middleBtn];
        
        self.middleButton = middleBtn;
    }
    return self;
}


-(void)middleBtnDidClick {
    if(self.myTabBarDelegate && [self.myTabBarDelegate respondsToSelector:@selector(tabbarWithMiddleButtonClick:)]){
        [self.myTabBarDelegate tabbarWithMiddleButtonClick:self];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //也可以用layer层的position anchorPoint实现
//    self.bgView.centerX = self.centerX;
//    self.bgView.size = CGSizeMake(self.superview.width, self.superview.width/5);
//    self.bgView.y = -(middleBtnWidth-49);

    
    self.middleButton.size = CGSizeMake(middleBtnWidth,middleBtnWidth);
    self.middleButton.y = -(middleBtnWidth-49);
    self.middleButton.x = self.centerX -middleBtnWidth/2;
    
    
    int btnIndex = 0;
    
    Class class = NSClassFromString(@"UITabBarButton");
    for (UIView *btn in self.subviews) {
        if ([btn isKindOfClass:class]) {
            btn.width = self.width / 3;
            btn.x = btn.width * btnIndex;
            btnIndex++;
            if (btnIndex == 1) {
                btnIndex++;
            }
            
        }
    }

    [self bringSubviewToFront:self.middleButton];
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (self.isHidden == NO)
    {
        CGPoint newA = [self convertPoint:point toView:self.middleButton];
        
        if ( [self.middleButton pointInside:newA withEvent:event])
        {
            return self.middleButton;
            
        }else{
            
            return [super hitTest:point withEvent:event];
        }
    }else{
        
        return [super hitTest:point withEvent:event];
    }
}

@end
