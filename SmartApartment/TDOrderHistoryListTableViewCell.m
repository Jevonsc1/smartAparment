//
//  TDOrderHistoryListTableViewCell.m
//  SmartApartment
//
//  Created by 刘靖 on 2017/2/25.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "TDOrderHistoryListTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface TDOrderHistoryListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *telecomImageView;
@property (weak, nonatomic) IBOutlet UILabel *telecomNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telecomPricesLabel;
@property (weak, nonatomic) IBOutlet UILabel *telecomServiceDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;
@end

@implementation TDOrderHistoryListTableViewCell

- (void)reloadData:(NSDictionary *)dictionary {
    if (dictionary) {
        NSArray *array = [dictionary arrayForKey:@"telecomImage"];
        if ([array count] > 0) {
            NSString *url = [array objectAtIndex:0];
            [_telecomImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"broadband"]];
        }
        
        [_telecomNameLabel setText:[dictionary stringForKey:@"telecomName"]];
        //[_telecomPricesLabel setText:[NSString stringWithFormat:@"%@/%@",[dictionary RMBForKey:@"telecomPrices"],[dictionary stringForKey:@"telecomPricesPeriod"]]];
        [_telecomPricesLabel setText:[dictionary RMBForKey:@"orderPrices"]];
        [_telecomServiceDescLabel setText:[dictionary stringForKey:@"telecomServiceDesc"]];
        [_orderDateLabel setText:[dictionary dateForKey:@"orderDate"]];
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
