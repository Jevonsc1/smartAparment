//
//  RenterIDCell.h
//  SmartApartment
//
//  Created by Trudian on 16/12/27.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RenterIDCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *renterIcon;
@property (weak, nonatomic) IBOutlet UILabel *renterName;
@property (weak, nonatomic) IBOutlet UILabel *renterID;
@property (weak, nonatomic) IBOutlet UIImageView *renterIDIcon;
@property (weak, nonatomic) IBOutlet UILabel *renterIDNum;

@end
