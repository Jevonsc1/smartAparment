//
//  RenterBillCell.h
//  SmartApartment
//
//  Created by Trudian on 17/1/9.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RenterACBillCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *renterIcon;
@property (weak, nonatomic) IBOutlet UILabel *renterName;
@property (weak, nonatomic) IBOutlet UILabel *apartmentName;
@property (weak, nonatomic) IBOutlet UILabel *payType;
@property (weak, nonatomic) IBOutlet UILabel *Renters;
@property (weak, nonatomic) IBOutlet UILabel *payMoney;
@property (weak, nonatomic) IBOutlet UILabel *payStatus;
@property (weak, nonatomic) IBOutlet UILabel *roomNum;

@end
