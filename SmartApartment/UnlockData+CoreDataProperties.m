//
//  UnlockData+CoreDataProperties.m
//  SmartApartment
//
//  Created by Jevons on 2017/4/26.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import "UnlockData+CoreDataProperties.h"

@implementation UnlockData (CoreDataProperties)

+ (NSFetchRequest<UnlockData *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"UnlockData"];
}

@dynamic app_id;
@dynamic unlock_time;

@end
