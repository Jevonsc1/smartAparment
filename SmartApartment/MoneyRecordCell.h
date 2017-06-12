//
//  MoneyRecordCell.h
//  SmartApartment
//
//  Created by Trudian on 16/11/10.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoneyRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moneyTitle;
@property (weak, nonatomic) IBOutlet UILabel *moneyTime;
@property (weak, nonatomic) IBOutlet UILabel *money;

@property (weak, nonatomic) IBOutlet UILabel *payName;
@property (weak, nonatomic) IBOutlet UILabel *payRoom;


@end
