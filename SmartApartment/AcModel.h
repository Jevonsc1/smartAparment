//
//  AcModel.h
//  SmartApartment
//
//  Created by Jevons on 2017/5/4.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AcModel : NSObject

@property(nonatomic,copy)NSString* acAPPID;

@property(nonatomic,strong)NSNumber* acIsOnline;

@property(nonatomic,copy)NSString* acName;

@property(nonatomic,strong)NSNumber* effectiveTime;

@end
