//
//  EditMoneyCell.h
//  SmartApartment
//
//  Created by Trudian on 16/12/19.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditMoneyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *editMoney;
@property (weak, nonatomic) IBOutlet UILabel *editLabel;

@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@end
