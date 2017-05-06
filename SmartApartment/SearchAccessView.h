//
//  SearchAccessView.h
//  SmartApartment
//
//  Created by Trudian on 17/2/15.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchAccessView : UIView
@property (weak, nonatomic) IBOutlet UIView *communityTagView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *communityAutoHeigh;
@property (weak, nonatomic) IBOutlet UIButton *selectRoomButton;
@property (weak, nonatomic) IBOutlet UILabel *selectRoomLabel;
@property (weak, nonatomic) IBOutlet UIView *accessStatusTagView;
@property (weak, nonatomic) IBOutlet UIView *renterTypeTagView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *selectRoomView;

@end
