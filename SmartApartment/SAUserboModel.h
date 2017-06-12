//
//  SAUserboModel.h
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/17.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAUserboModel : NSObject

@property(nonatomic,copy)NSString *boBackIDCardImgPath;

@property(nonatomic,copy)NSString *boCertificateNum;

@property(nonatomic,copy)NSString *boFrontIDCardImgPath;

@property(nonatomic,copy)NSString *boID;

@property(nonatomic,copy)NSString *boIDCardNum;

@property(nonatomic,copy)NSString *boIsDisable;

@property(nonatomic,copy)NSString *boMaxHouseNum;

@property(nonatomic,copy)NSString *boStatus;

@property(nonatomic,copy)NSString *boTrueName;

@property(nonatomic,copy)NSString *boValidTime;

@property(nonatomic,copy)NSString *boValidateStatus;

@property(nonatomic,copy)NSArray *boBank;

@end
