//
//  AuthtionResultController.h
//  SmartApartment
//
//  Created by Trudian on 17/2/25.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AuthtionResultController : UIViewController
@property(nonatomic)NSInteger resultType;
@property(nonatomic)NSString *errCode;
@property(nonatomic)NSString *errMsg;
@property(nonatomic)NSMutableDictionary *mutDictionary;
@end
