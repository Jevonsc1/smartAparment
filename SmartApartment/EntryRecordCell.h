//
//  EntryRecordCell.h
//  SmartApartment
//
//  Created by Trudian on 17/2/10.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntryRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *acLogMemberAvatar;
@property (weak, nonatomic) IBOutlet UILabel *acLogMemberName;
@property (weak, nonatomic) IBOutlet UILabel *acLogCategoryName;
@property (weak, nonatomic) IBOutlet UIImageView *acLogCategoryNameIcon;
@property (weak, nonatomic) IBOutlet UILabel *acLogHouseName;
@property (weak, nonatomic) IBOutlet UILabel *acLogTime;

@end
