//
//  TDPricingPackageListTableViewCell.m
//  SmartApartment
//
//  Created by 刘靖 on 2017/2/23.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "TDPricingPackageListTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface TDPricingPackageListTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *telecomImageView;
@property (weak, nonatomic) IBOutlet UILabel *telecomNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telecomPricesLabel;
@property (weak, nonatomic) IBOutlet UILabel *telecomServiceDescLabel;

@end

@implementation TDPricingPackageListTableViewCell

- (void)reloadData:(NSDictionary *)dictionary {
    if (dictionary) {
        NSString *url = [dictionary stringForKey:@"telecomImage"];
        [_telecomImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"broadband"]];
        
        [_telecomNameLabel setText:[dictionary stringForKey:@"telecomName"]];
        [_telecomPricesLabel setText:[NSString stringWithFormat:@"%@/%@",[dictionary RMBForKey:@"telecomPrices"],[dictionary stringForKey:@"telecomPricesPeriod"]]];
        [_telecomServiceDescLabel setText:[dictionary stringForKey:@"telecomServiceDesc"]];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
