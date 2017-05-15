//
//  CashPayRecordCell.h
//  SmartApartment
//
//  Created by Trudian on 16/12/19.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CashPayRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *editMoney;
@property (weak, nonatomic) IBOutlet UILabel *resultMoney;

@end
