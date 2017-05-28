//
//  HouseInputCell.h
//  SmartApartment
//
//  Created by Trudian on 16/12/10.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HouseInputCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *roomName;
@property (weak, nonatomic) IBOutlet UILabel *preRead;
@property (weak, nonatomic) IBOutlet UITextField *curInput;

@end
