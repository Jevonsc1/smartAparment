//
//  renterUserCell.m
//  SmartApartment
//
//  Created by Trudian on 16/10/31.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "renterUserCell.h"

@implementation renterUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)callOne:(UIButton *)sender{
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.renterPhone.text];
    // NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
    
}
@end
