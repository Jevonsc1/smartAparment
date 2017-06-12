//
//  BankCell.h
//  SmartApartment
//
//  Created by Trudian on 16/11/2.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property(nonatomic)BOOL isSelect;
@end
