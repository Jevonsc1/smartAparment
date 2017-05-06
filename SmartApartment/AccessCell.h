//
//  AccessCell.h
//  SmartApartment
//
//  Created by Trudian on 17/2/15.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccessCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *userAvater;
@property (weak, nonatomic) IBOutlet UIImageView *renterType;
@property (weak, nonatomic) IBOutlet UIImageView *billStatus;
@property (weak, nonatomic) IBOutlet UIImageView *phoneIcon;
@property (weak, nonatomic) IBOutlet UIImageView *ICCardIcon;
@property (weak, nonatomic) IBOutlet UIImageView *IDCardIcon;
@property (weak, nonatomic) IBOutlet UILabel *roomName;
@property (weak, nonatomic) IBOutlet UILabel *openStatus;

@end
