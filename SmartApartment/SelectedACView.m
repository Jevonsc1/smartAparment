//
//  SelectedACView.m
//  SmartApartment
//
//  Created by Jevons on 2017/5/6.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "SelectedACView.h"

@implementation SelectedACView

+(instancetype)selectedAcViewWith:(CGRect)frame AcModel:(AcModel *)model{
    SelectedACView* view = [[SelectedACView alloc]initWithFrame:frame];
    view.acmodel = model;
    return view;
}

-(void)setAcmodel:(AcModel *)acmodel{
    _acmodel = acmodel;
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, 80, 35)];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor lightGrayColor];
    label.text = [NSString stringWithFormat:@"您选择了"];
    [self addSubview:label];
    
    UILabel* label2 = [[UILabel alloc]initWithFrame:CGRectMake(90, 7, self.frame.size.width-75, 35)];
    label2.font = [UIFont systemFontOfSize:16];
    label2.textColor = [UIColor blackColor];
    label2.text = [NSString stringWithFormat:@"  %@", acmodel.acName];
    [self addSubview:label2];
    
    UIView* bottom = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
    bottom.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9];
    [self addSubview:bottom];
}



@end
