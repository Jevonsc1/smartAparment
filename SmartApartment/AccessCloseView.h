//
//  AccessCloseView.h
//  SmartApartment
//
//  Created by Trudian on 17/2/16.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccessCloseView : UIView
@property (weak, nonatomic) IBOutlet UIButton *oneDayBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeDayBtn;
@property (weak, nonatomic) IBOutlet UIButton *fiveDayBtn;
@property (weak, nonatomic) IBOutlet UIButton *oneWeekBrn;
@property (weak, nonatomic) IBOutlet UIButton *oneMonthBtn;
@property (weak, nonatomic) IBOutlet UIButton *forevenBtn;

//自定义的view
@property (weak, nonatomic) IBOutlet UIView *selfDayView;
//天的label
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
//输入天数的textfield
@property (weak, nonatomic) IBOutlet UITextField *selfDayTextField;
//什么时候恢复的信息label
@property (weak, nonatomic) IBOutlet UILabel *recoveryLabel;
//关闭原因
@property (weak, nonatomic) IBOutlet UITextView *closeMes;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewAutoTop;
@property (weak, nonatomic) IBOutlet UIView *msgView;
@property (weak, nonatomic) IBOutlet UILabel *viewTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftAuto;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightAuto;

@end
