//
//  SelectDoorCardCell.h
//  SmartApartment
//
//  Created by Jevons on 2017/5/4.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AcModel.h"
typedef NS_ENUM(NSInteger, SelectDoorCardCellMode) {
    
    SelectDoorCardCellUnckeck,
    
    SelectDoorCardCellChecked,
    
    SelectDoorCardCellDisabled
    
};

@interface SelectDoorCardCell : UITableViewCell
@property(nonatomic,assign)SelectDoorCardCellMode mode;
@property(nonatomic,strong)AcModel* acmodel;
@end
