//
//  Geography.h
//  SmartApartment
//
//  Created by Jevons on 2017/5/3.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Geography : NSObject

@property(nonatomic,copy)NSString *node_deep;
@property(nonatomic,copy)NSString *node_id;
@property(nonatomic,copy)NSString *node_is_disable;
@property(nonatomic,copy)NSString *node_name;
@property(nonatomic,copy)NSString *node_nick_name;
@property(nonatomic,copy)NSString *node_parent_id;
@property(nonatomic,strong)NSArray *sub;

@end
