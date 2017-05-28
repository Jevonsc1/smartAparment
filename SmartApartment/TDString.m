//
//  TDString.m
//  TrudianLife
//
//  Created by bbapplepen on 2017/1/10.
//  Copyright © 2017年 trudian. All rights reserved.
//

#import "TDString.h"

@implementation TDString

+ (NSAttributedString*)string:(NSString*)string color:(UIColor*)color nsrange:(NSRange )nsrange
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:string];
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:16.0]
                          range:nsrange];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:color
                          range:nsrange];
    return attributedStr;
}

+(CGFloat)countHeight:(NSString*)string font:(CGFloat)fontsize width:(CGFloat)width lineSpace:(CGFloat)lineSpace{
    
    CGSize size = CGSizeMake(width, MAXFLOAT);
    NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByCharWrapping];
    [style setLineSpacing:lineSpace];
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:fontsize],NSParagraphStyleAttributeName : style.copy };
    
    CGRect frame = [string boundingRectWithSize:size options:opts attributes:attributes context:nil];
    return frame.size.height;
}

+(CGFloat)countWidth:(NSString *)string font:(CGFloat)fontsize height:(CGFloat)height lineSpace:(CGFloat)lineSpace{
    CGSize size = CGSizeMake(MAXFLOAT, height);
    NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByCharWrapping];
    [style setLineSpacing:lineSpace];
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:fontsize],NSParagraphStyleAttributeName : style.copy };
    
    CGRect frame = [string boundingRectWithSize:size options:opts attributes:attributes context:nil];
    return frame.size.width;
}

+(CGFloat)countWidth:(NSString *)string fontt:(UIFont*)font height:(CGFloat)height lineSpace:(CGFloat)lineSpace{
    CGSize size = CGSizeMake(MAXFLOAT, height);
    NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading;

    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByCharWrapping];
    [style setLineSpacing:lineSpace];
    NSDictionary *attributes = @{ NSFontAttributeName : font,NSParagraphStyleAttributeName : style.copy };
    
    CGRect frame = [string boundingRectWithSize:size options:opts attributes:attributes context:nil];
    return frame.size.width;
}

+(NSString*)screctString:(NSString*)string dispalyNum:(NSUInteger)dispalyNum{
    if (string.length>0) {
        NSString* substring1 = [string substringToIndex:dispalyNum];
        NSString* substring2 = [string substringFromIndex:string.length-dispalyNum-1];
        return [NSString stringWithFormat:@"%@****%@",substring1,substring2];
    }else{
        return nil;
    }
}
@end
