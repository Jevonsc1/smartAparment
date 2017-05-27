//
//  RentRoomCell.m
//  SmartApartment
//
//  Created by Trudian on 17/1/11.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "RentRoomCell.h"
//#import "UIView+SDAutoLayout.h"
#import "UIImageView+WebCache.h"
@implementation RentRoomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModelData:(Community *)modelData{
    _modelData = modelData;
    
    
    GBTagListView2 *view ;
    if (self.roomTags.subviews.count == 0   ) {
        view =  [[GBTagListView2 alloc] initWithFrame:CGRectMake(0, 0, self.roomTags.width - 30, 0)];
    }else{
        view = self.roomTags.subviews[0];
        for (UILabel *label in view.subviews) {
            [label removeFromSuperview];
        }
    }
    [view setTagWithCommunityTagArray:modelData.tagInfoList andType:@"cell"];
    view.canTouch = NO;
    [self.roomTags addSubview:view];
    [self.tagViewHeight setConstant:view.height];
    self.roomcellHeight = self.tagViewHeight.constant;
    [self.imageLeading setConstant:16*ratio];
    [self.moneyTrailing setConstant:9*ratio];
    [self.areaTrailiing setConstant:9*ratio];
    //图片数量判断
    if (modelData.communityPicAffixs.count > 0) {
        [self.roomImage sd_setImageWithURL:[NSURL URLWithString:modelData.communityPicAffixs[0]] placeholderImage:[UIImage imageNamed:@"defalt_rentroom"]];
        
        
        [self.roomImage setContentScaleFactor:[[UIScreen mainScreen] scale]];
        self.roomImage.contentMode =  UIViewContentModeScaleAspectFill;
        self.roomImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.roomImage.clipsToBounds  = YES;
    }
    [self.roomName setText:modelData.communityName];
    
    self.emptyRoomNum.text = modelData.communityEmptyHouseAmount;
    self.allRoom.text = [NSString stringWithFormat:@"间 共%@间",modelData.communityHouseAmount];
    self.roomArea.text = modelData.communityNodeName;
    
    if ([modelData.communityHouseRentMax isEqualToString:modelData.communityHouseRentMin]) {
        self.roomMoney.text = modelData.communityHouseRentMax;
    }else{
        self.roomMoney.text = [NSString stringWithFormat:@"%@~%@",modelData.communityHouseRentMin,modelData.communityHouseRentMax];
    }
    
    

}


@end
