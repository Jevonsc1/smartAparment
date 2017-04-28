//
//  RoomOtherCell.h
//  SmartApartment
//
//  Created by Trudian on 16/12/27.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomOtherCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *cellName;
@property (weak, nonatomic) IBOutlet UITextField *cellContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *anchorAspect;

@end
