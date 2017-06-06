//
//  SelectedACView.h
//  SmartApartment
//
//  Created by Jevons on 2017/5/6.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AcModel.h"
@interface SelectedACView : UIView

@property(nonatomic,strong)AcModel* acmodel;

+(instancetype)selectedAcViewWith:(CGRect)frame AcModel:(AcModel*)model;
@end
