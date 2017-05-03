//
//  BBImagebaseVC.h
//  imgeChoose
//
//  Created by williamliuwen on 16/11/19.
//  Copyright © 2016年 williamliuwen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnBBImageBlock)(UIImage *bbImage);

@interface BBImagebaseVC : UIViewController

//选择拍照样式
- (void)takeBBImage;

@property(nonatomic,strong)UIImageView *bbImageView;

@property (nonatomic, copy) ReturnBBImageBlock returnBBImageBlock;

@end
