//
//  FBBLETransfer.m
//  FBAPP
//
//  Created by farbell-imac on 16/6/7.
//  Copyright © 2016年 XiaoWen. All rights reserved.
//

#import "FBBLETransfer.h"

static NSMutableDictionary *_bitHexDic;
static NSMutableDictionary *_tenHexDic;
static NSMutableDictionary *_bitQDic;

@implementation FBBLETransfer

+ (NSString*)formatToDecimalStringWithNSData:(NSData*)data{
    return [self HexadecimalToDecimal:[self NSDataToHexadecimal:data]];
}

/*
 * 十六进制转NSData
 */
+ (NSData *)HexadecimalToBytes:(NSString *)str {
    NSMutableData* data = [NSMutableData data];
    int idx;
    
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    
    return data;
}

+ (NSData *)HexadecimalToNSData:(NSString *)str {
    
    if (!str || [str length] == 0) {
        
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    
    if ([str length] % 2 == 0) {
        
        range = NSMakeRange(0, 2);
        
    } else {
        
        range = NSMakeRange(0, 1);
    }
    
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

/*
 * NSData转十六进制
 */
+ (NSString *)NSDataToHexadecimal:(NSData *)data {
    Byte *bytes = (Byte *)[data bytes];
    NSString *hexStr=@"";
    for(int i=0;i<[data length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数,与 0xff 做 & 运算会将 byte 值变成 int 类型的值，也将 -128～0 间的负值都转成正值了。
        if([newHexStr length]==1)
        {
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        }
        else
        {
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
    }
    return hexStr;
}

/*
 * 二进制转十进制
 */
+ (NSString *)BinaryToDecimal:(NSString *)binary{
    NSUInteger decimal = 0;
    
    for (NSInteger index = 0; index < binary.length; index++) {
        
        double num = [[binary substringWithRange:(NSRange){binary.length - index - 1, 1}] doubleValue];
        decimal +=  num * pow(2, index);
    }
    
    return [NSString stringWithFormat:@"%ld", (unsigned long)decimal];
}

/*
 * 二进制转八进制
 */
+ (NSString *)BinaryToOctal:(NSString *)binary{
    
    return [self DecimalToOctal:[[self BinaryToDecimal:binary] integerValue]];
}

/*
 * 二进制转十六进制
 */
+ (NSString *)BinaryToHexadecimal:(NSString *)binary{
    
    return [self DecimalToHexadecimal:[[self BinaryToDecimal:binary] integerValue]];
}

/*
 * 八进制转二进制
 */
+ (NSString *)OctalToBinary:(NSString *)q{
    NSMutableString *str = [NSMutableString stringWithString:@""];
    NSUInteger count = q.length;
    
    for (NSInteger index = 0; index < count; index++) {
        
        NSString *appendStr = [[self bitQDic] objectForKey:[q substringWithRange:(NSRange){index, 1}]];
        
        if(index == 0){
            
            appendStr = [NSString stringWithFormat:@"%ld", (long)[appendStr integerValue]];
        }
        
        if (appendStr) {
            
            [str appendString:appendStr];
        }
    }
    
    return str;
}

/*
 * 八进制转十进制
 */
+ (NSString *)OctalToDecimal:(NSString *)q{
    
    return [self BinaryToDecimal:[self OctalToBinary:q]];
}

/*
 * 八进制转十六进制
 */
+ (NSString *)OctalToHexadecimal:(NSString *)q{
    
    return [self BinaryToHexadecimal:[self OctalToBinary:q]];
}

/*
 * 十进制转...
 */
+ (NSString *)tenToOtherWithNum:(NSUInteger)num system:(NSUInteger)system{
    NSMutableString *str = [NSMutableString stringWithString:@""];
    
    while (num){
        
        [str insertString:[NSString stringWithFormat:@"%lu", num % system] atIndex:0];
        num /= system;
    }
    
    return str;
}

/*
 * 十进制转二进制
 */
+ (NSString *)DecimalToBinary:(NSUInteger)tmpid{
    
    return [self tenToOtherWithNum:tmpid system:2];
}

/*
 * 十进制转八进制
 */
+ (NSString *)DecimalToOctal:(NSUInteger)tmpid{
    
    return [self tenToOtherWithNum:tmpid system:8];
}

/*
 * 十进制转十六进制
 */
+ (NSString *)DecimalToHexadecimal:(NSUInteger)tmpid{
    NSMutableString *str = [NSMutableString stringWithString:@""];
    while (tmpid) {
        [str insertString:[[self tenHexDic] objectForKey:[NSString stringWithFormat:@"%lu", tmpid % 16]] atIndex:0];
        tmpid /= 16;
    }
    return str;
}

/*
 * 十六进制转二进制
 */
+ (NSString *)HexadecimalToBinary:(NSString *)hex{
    NSMutableString *str = [NSMutableString stringWithString:@""];
    NSUInteger count = hex.length;
    
    for (NSInteger index = 0; index < count; index++) {
        
        NSString *appendStr = [[self bitHexDic] objectForKey:[hex substringWithRange:(NSRange){index, 1}]];
        
        if(index == 0){
            //过滤前面的0
            appendStr = [NSString stringWithFormat:@"%ld", (long)[appendStr integerValue]];
        }
        
        if (appendStr) {
            
            [str appendString:appendStr];
        }
    }
    
    return str;
}

/*
 * 十六进制转八进制
 */
+ (NSString *)HexadecimalToOctal:(NSString *)hex{
    
    return [self BinaryToOctal:[self HexadecimalToBinary:hex]];
}

/*
 * 十六进制转十进制
 */
+ (NSString *)HexadecimalToDecimal:(NSString *)hex {
    
    return [self BinaryToDecimal:[self HexadecimalToBinary:hex]];
}

+ (NSMutableDictionary *)bitHexDic{
    
    if(_bitHexDic == nil){
        
        NSMutableDictionary *hex = [[NSMutableDictionary alloc] initWithCapacity:16];
        [hex setObject:@"0000" forKey:@"0"];
        [hex setObject:@"0001" forKey:@"1"];
        [hex setObject:@"0010" forKey:@"2"];
        [hex setObject:@"0011" forKey:@"3"];
        [hex setObject:@"0100" forKey:@"4"];
        [hex setObject:@"0101" forKey:@"5"];
        [hex setObject:@"0110" forKey:@"6"];
        [hex setObject:@"0111" forKey:@"7"];
        [hex setObject:@"1000" forKey:@"8"];
        [hex setObject:@"1001" forKey:@"9"];
        [hex setObject:@"1010" forKey:@"A"];
        [hex setObject:@"1011" forKey:@"B"];
        [hex setObject:@"1100" forKey:@"C"];
        [hex setObject:@"1101" forKey:@"D"];
        [hex setObject:@"1110" forKey:@"E"];
        [hex setObject:@"1111" forKey:@"F"];
        [hex setObject:@"1010" forKey:@"a"];
        [hex setObject:@"1011" forKey:@"b"];
        [hex setObject:@"1100" forKey:@"c"];
        [hex setObject:@"1101" forKey:@"d"];
        [hex setObject:@"1110" forKey:@"e"];
        [hex setObject:@"1111" forKey:@"f"];
        _bitHexDic = hex;
    }
    return _bitHexDic;
}

+ (NSMutableDictionary *)tenHexDic{
    
    if(_tenHexDic == nil){
        
        NSMutableDictionary *hex = [[NSMutableDictionary alloc] initWithCapacity:16];
        [hex setObject:@"0" forKey:@"0"];
        [hex setObject:@"1" forKey:@"1"];
        [hex setObject:@"2" forKey:@"2"];
        [hex setObject:@"3" forKey:@"3"];
        [hex setObject:@"4" forKey:@"4"];
        [hex setObject:@"5" forKey:@"5"];
        [hex setObject:@"6" forKey:@"6"];
        [hex setObject:@"7" forKey:@"7"];
        [hex setObject:@"8" forKey:@"8"];
        [hex setObject:@"9" forKey:@"9"];
        [hex setObject:@"A" forKey:@"10"];
        [hex setObject:@"B" forKey:@"11"];
        [hex setObject:@"C" forKey:@"12"];
        [hex setObject:@"D" forKey:@"13"];
        [hex setObject:@"E" forKey:@"14"];
        [hex setObject:@"F" forKey:@"15"];
        [hex setObject:@"a" forKey:@"10"];
        [hex setObject:@"b" forKey:@"11"];
        [hex setObject:@"c" forKey:@"12"];
        [hex setObject:@"d" forKey:@"13"];
        [hex setObject:@"e" forKey:@"14"];
        [hex setObject:@"f" forKey:@"15"];
        _tenHexDic = hex;
    }
    
    return _tenHexDic;
}

+ (NSMutableDictionary *)bitQDic{
    
    if(_bitQDic == nil){
        
        NSMutableDictionary *hex = [[NSMutableDictionary alloc] initWithCapacity:8];
        [hex setObject:@"000" forKey:@"0"];
        [hex setObject:@"001" forKey:@"1"];
        [hex setObject:@"010" forKey:@"2"];
        [hex setObject:@"011" forKey:@"3"];
        [hex setObject:@"100" forKey:@"4"];
        [hex setObject:@"101" forKey:@"5"];
        [hex setObject:@"110" forKey:@"6"];
        [hex setObject:@"111" forKey:@"7"];
        _bitQDic = hex;
    }
    
    return _bitQDic;
}

@end
