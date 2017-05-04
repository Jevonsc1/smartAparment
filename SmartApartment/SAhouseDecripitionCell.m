//
//  SAhouseDecripitionCell.m
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/9.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "SAhouseDecripitionCell.h"
//#import "SAhouseDescriptionDodel.h"

@implementation SAhouseDecripitionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (void)setModel:(House *)model{
    _model = model;
    self.houseNumer.text= model.houseNum.stringValue;
    self.rentMoneyLabel.text = [NSString stringWithFormat:@"租金%@元/月",model.houseMonthRent];
    self.depositMoneyLabel.text = [NSString stringWithFormat:@"押金%@元",model.houseRequestRentDeposit];
}

@end
