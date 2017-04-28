//
//  RenterNameCell.h
//  SmartApartment
//
//  Created by Trudian on 16/12/27.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RenterNameCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *renterName;
@property (weak, nonatomic) IBOutlet UIImageView *cellIcon;
@property (weak, nonatomic) IBOutlet UILabel *cellName;

@end
