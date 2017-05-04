//
//  SAhouseCell.h
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/9.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SAhouseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *houseLayer;
@property (weak, nonatomic) IBOutlet UITextField *houseLayerCount;

@property(nonatomic,copy)NSString *layerString;

@end
