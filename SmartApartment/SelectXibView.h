//
//  SelectXibView.h
//  SmartApartment
//
//  Created by Trudian on 17/2/10.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectXibView : UIView
@property (weak, nonatomic) IBOutlet UILabel *labelOne;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelThree;
@property (weak, nonatomic) IBOutlet UILabel *labelFour;
@property (weak, nonatomic) IBOutlet UILabel *labelFive;
@property (weak, nonatomic) IBOutlet UIView *lastView;
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@property (weak, nonatomic) IBOutlet UIButton *buttonFour;
@property (weak, nonatomic) IBOutlet UIButton *buttonFive;

-(void)setAllTextColor:(UIColor*)textColor;

@end
