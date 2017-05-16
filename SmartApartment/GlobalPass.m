//
//  GlobalPass.m
//  SmartApartment
//
//  Created by Jevons on 2017/5/16.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import "GlobalPass.h"
static GlobalPass *sharePass;

@implementation GlobalPass


- (id)init {
    
    if (sharePass) { return sharePass; }
    
    self = [super init];
    if (self) {
        sharePass = self;
    }
    
    return self;
}

+ (GlobalPass *)pass {
    
    return [[[self class] alloc] init];
}

@end
