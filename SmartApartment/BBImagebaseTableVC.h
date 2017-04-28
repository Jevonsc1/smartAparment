//
//  BBImagebaseTableVC.h
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/20.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnBBImageBlock)(UIImage *bbImage);

@interface BBImagebaseTableVC : UITableViewController

//选择拍照样式
- (void)takeBBImage;

@property(nonatomic,strong)UIImageView *bbImageView;

@property (nonatomic, copy) ReturnBBImageBlock returnBBImageBlock;

@end
