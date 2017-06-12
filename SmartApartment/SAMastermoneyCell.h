//
//  SAMastermoneyCell.h
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/17.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SAMastermoeny.h"
#import "SAMastermoneyNew.h"

@interface SAMastermoneyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moneyName;
@property (weak, nonatomic) IBOutlet UILabel *masterName;
@property (weak, nonatomic) IBOutlet UILabel *moneyTime;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *masterRoom;

@property(nonatomic,strong)SAMastermoeny *model;
@property(nonatomic,strong)SAMastermoneyNew *modelNew;

@end
