//
//  BillSelectView.h
//  SmartApartment
//
//  Created by Trudian on 16/12/10.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillSelectView : UIView
@property (weak, nonatomic) IBOutlet UIView *searchHistoryView;
@property (weak, nonatomic) IBOutlet UIButton *overTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *waitPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *hadPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureSelect;
@property (weak, nonatomic) IBOutlet UIButton *resetSelect;


@property (weak, nonatomic) IBOutlet UIButton *allSelectBtn;


@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
@property (weak, nonatomic) IBOutlet UIButton *cashBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneleading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoleading;

@end
