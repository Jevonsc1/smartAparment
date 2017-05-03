//
//  BBEmojiCheck.m
//  SmartApartment
//
//  Created by bbapplepen on 2016/11/21.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "BBEmojiCheck.h"

@implementation BBEmojiCheck

+ (instancetype)bbManager{
    static BBEmojiCheck * instance = nil;
    static dispatch_once_t dispatch;
    dispatch_once(&dispatch, ^{
        instance = [[BBEmojiCheck alloc] init];
    });
    return instance;
}

-(BOOL)isContainsBBEmoji:(NSString *)string {
    __block BOOL isEomji =NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring,NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         if (0xd800 <= hs && hs <=0xdbff) {
             if (substring.length >1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs -0xd800) * 0x400) + (ls -0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <=0x1f77f) {
                     isEomji =YES;
                 }
             }
         }else if (substring.length >1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 isEomji =YES;
             }
         }else {
             if (0x2100 <= hs && hs <=0x27ff && hs != 0x263b) {
                 isEomji =YES;
             }else if (0x2B05 <= hs && hs <=0x2b07) {
                 isEomji =YES;
             }else if (0x2934 <= hs && hs <=0x2935) {
                 isEomji =YES;
             }else if (0x3297 <= hs && hs <=0x3299) {
                 isEomji =YES;
             }else if (hs ==0xa9 || hs == 0xae || hs ==0x303d || hs == 0x3030 || hs ==0x2b55 || hs == 0x2b1c || hs ==0x2b1b || hs == 0x2b50|| hs ==0x231a ) {
                 isEomji =YES;
             }
         }
     }];
    return isEomji;
}


-(BOOL)isContainsBBEmoji2:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar high = [substring characterAtIndex: 0];
                                
                                // Surrogate pair (U+1D000-1F9FF)
                                if (0xD800 <= high && high <= 0xDBFF) {
                                    const unichar low = [substring characterAtIndex: 1];
                                    const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                    
                                    if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                        returnValue = YES;
                                    }
                                    
                                    // Not surrogate pair (U+2100-27BF)
                                } else {
                                    if (0x2100 <= high && high <= 0x27BF){
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

@end
