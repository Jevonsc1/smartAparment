//
//  Alert.m
//  CarLife
//  提示控件
//  Created by kenshinhu on 2/28/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "Alert.h"

//Toast默认停留时间
#define ToastDispalyDuration 1.2f
//Toast到顶端/底端默认距离
#define ToastSpace 100.0f
//Toast背景颜色
#define ToastBackgroundColor [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.75]
@interface Alert ()
{
    UIButton *alertView;
}
@property(nonatomic,strong)UIButton *contentView;
@property(nonatomic,assign)CGFloat duration;
@end


static Alert *tipAlert;
@implementation Alert


+(void)showFail:(NSString *)msg View:(UIView *)view andTime:(int)delay complete:(void (^)(BOOL ))complete {
    if(!tipAlert){
        tipAlert = [[Alert alloc] init];
    }
    
    [tipAlert showAlert:msg andView:view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tipAlert hideAnimated:complete];
    });
    
}
+(void)showFail:(NSString *)msg View:(UIView *)view andY:(CGFloat)offset andTime:(int)delay complete:(void (^)(BOOL ))complete {
    if(!tipAlert){
        tipAlert = [[Alert alloc] init];
    }
    [tipAlert showAlert:msg andView:view andY:offset];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tipAlert hideAnimated:complete];
    });
    
}

- (void)hideAnimated:(void(^)(BOOL isComplete))complete{
    [UIView animateWithDuration:0.25 animations:^{
        alertView.alpha = 0;
    } completion:^(BOOL finished) {
        [alertView removeFromSuperview];
        tipAlert = nil;
        if (complete)
            complete(finished);
    }];
}
-(void)showAlert:(NSString *)msg andView:(UIView*)view andY:(CGFloat)y{
    if ( self.contentView ) {
        [self.contentView  removeFromSuperview];
    }
    UIFont *font = [UIFont boldSystemFontOfSize:16];
    NSDictionary * dict=[NSDictionary dictionaryWithObject: font forKey:NSFontAttributeName];
    CGRect rect=[msg boundingRectWithSize:CGSizeMake(250,CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,rect.size.width + 40, rect.size.height+ 20)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = font;
    textLabel.text = msg;
    textLabel.numberOfLines = 0;
    alertView = [[UIButton alloc] initWithFrame:CGRectMake(0, y, textLabel.frame.size.width, textLabel.frame.size.height)];
    alertView.centerX = view.centerX;
    alertView.layer.cornerRadius = 20.0f;
    alertView.backgroundColor = ToastBackgroundColor;
    [alertView addSubview:textLabel];
    alertView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    alertView.alpha = 1.0f;
    [view addSubview:alertView];
}
-(void)showAlert:(NSString *)msg andView:(UIView*)view{
    if (self.contentView ) {
        [self.contentView  removeFromSuperview];
    }
    if (alertView) {
        [alertView removeFromSuperview];
    }
    UIFont *font = [UIFont boldSystemFontOfSize:16];
    NSDictionary * dict=[NSDictionary dictionaryWithObject: font forKey:NSFontAttributeName];
    CGRect rect=[msg boundingRectWithSize:CGSizeMake(250,CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,rect.size.width + 40, rect.size.height+ 20)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = font;
    textLabel.text = msg;
    textLabel.numberOfLines = 0;
    alertView = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, textLabel.frame.size.width, textLabel.frame.size.height)];
    alertView.centerX = view.centerX;
    alertView.layer.cornerRadius = 20.0f;
    alertView.backgroundColor = ToastBackgroundColor;
    [alertView addSubview:textLabel];
    alertView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    alertView.alpha = 1.0f;
    [view addSubview:alertView];
}
+(void)showSucces:(NSString *)msg View:(UIView *)view andTime:(int)delay complete:(void(^)(BOOL))complete {
    if(!tipAlert){
        tipAlert = [[Alert alloc] init];
    }
    [tipAlert showAlert:msg andView:view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tipAlert hideAnimated:complete];
    });
}
@end
