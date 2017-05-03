//
//  NoPayOrder.h
//  SmartApartment
//
//  Created by Jevons on 2017/5/3.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoPayOrder : NSObject
@property(nonatomic,strong)NSArray* waterOrder;
@property(nonatomic,strong)NSArray* electricOrder;
@property(nonatomic,strong)NSArray* rentOrder;
@property(nonatomic,strong)NSArray* otherOrder;

@end
