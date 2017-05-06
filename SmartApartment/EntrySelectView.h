//
//  EntrySelectView.h
//  SmartApartment
//
//  Created by Trudian on 17/2/10.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntrySelectView : UIView
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *todayBtn;
@property (weak, nonatomic) IBOutlet UIButton *threedayBtn;
@property (weak, nonatomic) IBOutlet UIButton *weekBtn;
@property (weak, nonatomic) IBOutlet UIButton *monthBtn;
@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;
@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (weak, nonatomic) IBOutlet UIView *selectRoomView;
@property (weak, nonatomic) IBOutlet UIButton *selectRoomBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *roomLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagViewAutoHeigh;
@property (weak, nonatomic) IBOutlet UIView *dayTagView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dayTagViewAutoHeigh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dayAllViewAutoHeight;
@property (weak, nonatomic) IBOutlet UIView *scrollBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollbgviewAutoBottom;

@property (weak, nonatomic) IBOutlet UILabel *comLabel;
@property (weak, nonatomic) IBOutlet UIView *line;


@end
