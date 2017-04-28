//
//  FBBLETransfer.h
//  FBAPP
//
//  Created by farbell-imac on 16/6/7.
//  Copyright © 2016年 XiaoWen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBBLETransfer : NSObject
+ (NSData *)HexadecimalToBytes:(NSString *)str;

+ (NSData *)HexadecimalToNSData:(NSString *)str;

+ (NSString *)NSDataToHexadecimal:(NSData *)data;

+ (NSString *)HexadecimalToDecimal:(NSString *)hex;

+ (NSString *)DecimalToHexadecimal:(NSUInteger)tmpid;

+ (NSString*)formatToDecimalStringWithNSData:(NSData*)data;

@end
