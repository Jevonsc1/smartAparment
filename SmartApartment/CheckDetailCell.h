//
//  CheckDetailCell.h
//  SmartApartment
//
//  Created by Trudian on 16/12/28.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *renterIcon;
@property (weak, nonatomic) IBOutlet UILabel *renterName;
@property (weak, nonatomic) IBOutlet UILabel *renterIDNum;
@property (weak, nonatomic) IBOutlet UILabel *renterPhone;

@end
