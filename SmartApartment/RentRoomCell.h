//
//  RentRoomCell.h
//  SmartApartment
//
//  Created by Trudian on 17/1/11.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBTagListView2.h"
#import "Community.h"
@interface RentRoomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *roomImage;
@property (weak, nonatomic) IBOutlet UILabel *roomName;
@property (weak, nonatomic) IBOutlet UILabel *roomMsg;
@property (weak, nonatomic) IBOutlet UILabel *roomArea;
@property (weak, nonatomic) IBOutlet UILabel *roomMoney;
@property (weak, nonatomic) IBOutlet UIView *roomTags;
@property(nonatomic,strong)Community *modelData;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *emptyRoomNum;
@property (weak, nonatomic) IBOutlet UILabel *allRoom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *areaTrailiing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyTrailing;

@property(nonatomic)CGFloat roomcellHeight;
@end
