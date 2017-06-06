//
//  TDMyDoorCardListTableViewCell.h
//  SmartApartment
//
//  Created by 刘靖 on 2017/4/6.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DoorCardTypeMobile,
    DoorCardTypeICCard,
    DoorCardTypeIDCard,
} DoorCardType;

@interface TDMyDoorCardListTableViewCell : UITableViewCell

@property (assign, nonatomic) DoorCardType cardType;
@property (assign, nonatomic) NSInteger status;// 1启用 2未启用 3禁用 4挂失 5敬请期待
@property (strong, nonatomic) NSString *prompt;

@property (strong, nonatomic) UIButton *reopeningButton;
@property (strong, nonatomic) UIButton *reportTheLossButton;
@property (strong, nonatomic) UIButton *detailsButton;
@end
