//
//  RenterBillCell.h
//  SmartApartment
//
//  Created by Trudian on 16/12/30.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RenterBillCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellIcon;
@property (weak, nonatomic) IBOutlet UILabel *cellName;
@property (weak, nonatomic) IBOutlet UILabel *cellContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellIconRatio;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *AnchorRatio;
@property (weak, nonatomic) IBOutlet UIImageView *cellAnchor;
@end
