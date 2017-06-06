//
//  SelectDoorCardCell.m
//  SmartApartment
//
//  Created by Jevons on 2017/5/4.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "SelectDoorCardCell.h"
@interface SelectDoorCardCell()
@property (weak, nonatomic) IBOutlet UIButton *checkBox;
@property (weak, nonatomic) IBOutlet UILabel *acNameLable;

@end

@implementation SelectDoorCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setAcmodel:(AcModel *)acmodel{
    _acmodel = acmodel;
    self.checkBox.enabled = acmodel.acIsOnline.boolValue;
    self.acNameLable.text = acmodel.acName;
    if (!acmodel.acIsOnline.boolValue) {
        self.mode = SelectDoorCardCellDisabled;
    }
}

-(void)setMode:(SelectDoorCardCellMode)mode{
    _mode = mode;
    if (mode == SelectDoorCardCellChecked && self.checkBox.enabled) {
        self.checkBox.selected = YES;
    }
}
@end
