//
//  SAhouseDecripitionCell.h
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/9.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "House.h"

@interface SAhouseDecripitionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *houseNumer;


@property (weak, nonatomic) IBOutlet UILabel *rentMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *depositMoneyLabel;

@property(nonatomic,strong)House *model;

@end
