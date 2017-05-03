//
//  SAshowhouseCollectionViewCell.h
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/10.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SAshowhouseCollectionViewCell;
@class SAChargeModel;

@protocol SAshowhouseCollectionViewCellDelegate <NSObject>

- (void)deletBtnCell:(SAshowhouseCollectionViewCell*)cell longPress:(UILongPressGestureRecognizer *)sender;

@end

@class SAhouseInfoModel;

@interface SAshowhouseCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)SAhouseInfoModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *closeImage;

@property (weak, nonatomic) IBOutlet UILabel *houseNum;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UILabel *loginPeople;

@property (nonatomic, assign) id <SAshowhouseCollectionViewCellDelegate> delegate;

@property(nonatomic,copy)NSString *communityID;

@property(nonatomic,strong)NSArray *chargeArray;

@property(nonatomic,strong)SAChargeModel *chargeModel;

@property(nonatomic,strong)NSMutableArray *billArray;

@property (weak, nonatomic) IBOutlet UIButton *backgroundImageBtn;


@end
