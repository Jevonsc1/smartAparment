//
//  ApartmentBillCell.h
//  SmartApartment
//
//  Created by Trudian on 16/12/10.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApartmentBillCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *payType;
@property (weak, nonatomic) IBOutlet UILabel *roomNum;
@property (weak, nonatomic) IBOutlet UIView *roomNumBgView;
@property (weak, nonatomic) IBOutlet UILabel *roomRenterNAME;
@property (weak, nonatomic) IBOutlet UILabel *renters;
@property (weak, nonatomic) IBOutlet UILabel *apartmentName;

@property (weak, nonatomic) IBOutlet UILabel *payStatus;
@property (weak, nonatomic) IBOutlet UILabel *payMoney;
@property (weak, nonatomic) IBOutlet UIImageView *cellIcon;

@end
