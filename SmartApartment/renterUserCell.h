//
//  renterUserCell.h
//  SmartApartment
//
//  Created by Trudian on 16/10/31.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface renterUserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *renterName;
@property (weak, nonatomic) IBOutlet UILabel *renterPhone;
@property (weak, nonatomic) IBOutlet UILabel *renterSize;
@property (weak, nonatomic) IBOutlet UILabel *inHouseTime;
@property (weak, nonatomic) IBOutlet UIButton *callPhone;

@property (weak, nonatomic) IBOutlet UIImageView *avater;
@property (weak, nonatomic) IBOutlet UIImageView *sexIcon;
@end
