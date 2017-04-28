//
//  TemRoomCell.h
//  SmartApartment
//
//  Created by Trudian on 16/12/1.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemRoomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *roomNum;
@property (weak, nonatomic) IBOutlet UILabel *temStatus;

@end
