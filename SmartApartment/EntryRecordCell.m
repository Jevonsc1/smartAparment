//
//  EntryRecordCell.m
//  SmartApartment
//
//  Created by Trudian on 17/2/10.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "EntryRecordCell.h"

@implementation EntryRecordCell
-(void)awakeFromNib{
    [super awakeFromNib];
    
}

-(void)setEntryRecord:(EntryRecord *)entryRecord{
    _entryRecord = entryRecord;
    [self.acLogMemberAvatar sd_setImageWithURL:[NSURL URLWithString:entryRecord.acLogMemberAvatar] placeholderImage:[UIImage imageNamed:@"default_user_avatar"]];
    self.acLogMemberAvatar.layer.masksToBounds = YES;
    self.acLogMemberName.text = entryRecord.acLogMemberName;
    self.acLogTime.text = [TimeDate timeDetailWithTimeIntervalString:entryRecord.acLogTime];
    self.acLogHouseName.text = entryRecord.acLogHouseName;
    self.acLogCategoryName.text = entryRecord.acLogCategoryName;
    if ([self.acLogCategoryName.text isEqualToString:@"身份证开门"]) {
        [self.acLogCategoryNameIcon setImage:[UIImage imageNamed:@"bussiness-card"]];
    }else if ([self.acLogCategoryName.text isEqualToString:@"IC卡开门"]){
        [self.acLogCategoryNameIcon setImage:[UIImage imageNamed:@"signboard"]];
    }else{
        [self.acLogCategoryNameIcon setImage:[UIImage imageNamed:@"Mobile-phone"]];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.acLogMemberAvatar.layer.cornerRadius = self.acLogMemberAvatar.height/2;
}
@end
