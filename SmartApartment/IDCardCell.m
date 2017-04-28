//
//  IDCardCell.m
//  SmartApartment
//
//  Created by Trudian on 17/3/8.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "IDCardCell.h"

@implementation IDCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
