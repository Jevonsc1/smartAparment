//
//  Geography.m
//  SmartApartment
//
//  Created by Jevons on 2017/5/3.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import "Geography.h"

@implementation Geography
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"sub" : [Geography class]};
}
@end
