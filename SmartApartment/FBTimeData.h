//
//  FBTimeData.h
//  X5
//
//  Created by farbell-imac on 16/6/28.
//
//

#import <Foundation/Foundation.h>
#import "FBType.h"

@interface FBTimeData : NSObject

@property(nonatomic,assign) FBShort mYear;
@property(nonatomic,assign) FBByte mMonth;
@property(nonatomic,assign) FBByte mHour;
@property(nonatomic,assign) FBByte mDay;
@property(nonatomic,assign) FBByte mMinute;
@property(nonatomic,assign) FBByte mSecond;


-(instancetype) initWithField:(UInt32)year
                        month:(UInt32)month
                         hour:(UInt32)hour
                          day:(UInt32)day
                       minute:(UInt32)minute
                       second:(UInt32)second;

-(instancetype) initWithData:(NSData*)data;

-(instancetype) initWithDefault;

-(NSString*) toJsonString;

-(NSData*) toByte;

-(UInt64) toTimeStamp;

- (unsigned long long)createCurrentNormal:(NSData*)data;
@end
