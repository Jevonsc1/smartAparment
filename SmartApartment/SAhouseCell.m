//
//  SAhouseCell.m
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/9.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "SAhouseCell.h"
//#import "SAhouseModel.h"

@interface SAhouseCell()

@end

@implementation SAhouseCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setLayerString:(NSString *)layerString{
    _layerString = layerString;
    self.houseLayer.text = layerString;
    self.houseLayerCount.text = layerString;
}
//- (void)setModel:(SAhouseModel *)model{
////todo
////    self.houseLayer.text=model.houseLayerString;
////    self.houseLayerCount.text=model.houseLayerCountString;
//}

@end
