//
//  IDCardCell.h
//  SmartApartment
//
//  Created by Trudian on 17/3/8.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *frontImage;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *selectIcon;

@end
