//
//  AccessBtn.m
//  SmartApartment
//
//  Created by Jevons on 2017/5/5.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "AccessBtn.h"

@implementation AccessBtn
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.layer.cornerRadius = 5.f;
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = MainBlue.CGColor;
         [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [self setTitleColor:MainBlue forState:UIControlStateNormal];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
}

-(void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    if (enabled) {
        self.layer.borderColor = MainBlue.CGColor;
    }else{
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;       
    }
}
@end
