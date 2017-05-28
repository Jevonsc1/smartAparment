//
//  AllAccountController.h
//  SmartApartment
//
//  Created by Trudian on 17/1/10.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllAccountController : UIViewController
@property(nonatomic)NSArray *accountArr;
@property(nonatomic)NSString *wayIn;//判断是本月已收，还是其他
                                    //本月已收有单独api,待缴以及逾期需要自己做筛选和排序
@end
