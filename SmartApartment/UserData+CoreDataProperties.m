//
//  UserData+CoreDataProperties.m
//  SmartApartment
//
//  Created by Jevons on 2017/4/22.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import "UserData+CoreDataProperties.h"

@implementation UserData (CoreDataProperties)

+ (NSFetchRequest<UserData *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"UserData"];
}

@dynamic boStatus;
@dynamic idCardNum;
@dynamic idStatus;
@dynamic isOpenNet;
@dynamic key;
@dynamic member_sex;
@dynamic memberAddress;
@dynamic memberAvailablePD;
@dynamic memberAvatar;
@dynamic memberFreezePD;
@dynamic memberID;
@dynamic memberIsDisable;
@dynamic memberNickName;
@dynamic memberRegistTime;
@dynamic memberType;
@dynamic memberPhone;
@dynamic password;
@dynamic renterAddress;
@dynamic renterStatus;
@dynamic searchList;
@dynamic searchRecord;
@dynamic trueName;

@end
