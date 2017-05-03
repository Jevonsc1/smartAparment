//
//  SAapartementCell.h
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/8.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Community;

@interface SAapartementCell : UITableViewCell

@property(nonatomic,strong)Community *community;

@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@property (weak, nonatomic) IBOutlet UIImageView *apartmentImage;

@property (weak, nonatomic) IBOutlet UIImageView *rejImage;
@end
