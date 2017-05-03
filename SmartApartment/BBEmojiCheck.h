//
//  BBEmojiCheck.h
//  SmartApartment
//
//  Created by bbapplepen on 2016/11/21.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BBEmojiCheck : NSObject
+ (instancetype)bbManager;
//方法1：判断字符串里面是有有表情
-(BOOL)isContainsBBEmoji:(NSString *)string ;
-(BOOL)isContainsBBEmoji2:(NSString *)string;
@end
