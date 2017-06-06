//
//  AuthtionFirstController.h
//  SmartApartment
//
//  Created by Trudian on 17/2/24.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDelegateDic.h"
@interface AuthtionFirstController : UIViewController
@property(nonatomic)NSString *renterType;//不用关注这个变量
@property(nonatomic)NSString *wayIn;//根据传入的字符串，改变操作
@property(nonatomic)NSObject<MyDelegateDic> *delegate;//委托反向传值到上一个界面
@property(nonatomic)NSMutableDictionary *mutDictionary;//宽带信息
@property(nonatomic)UIImage *frontImage;
@property(nonatomic)UIImage *backImage;
@end
