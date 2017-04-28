//
//  FBTimeData.m
//  X5
//
//  Created by farbell-imac on 16/6/28.
//
//

#import "FBTimeData.h"
#import "FBBLETransfer.h"

@implementation FBTimeData


#if 0
-(instancetype)initWithData:(NSData *)data{
    self = [super init];
    if(self){
        FBShort tYear;
        FBByte  tMonth;
        FBByte  tday;
        FBByte tHour;
        FBByte tMinute;
        FBByte tSecond;
        
        [data getBytes:tYear.bytes length:2];
        [data getBytes:tMonth.bytes length:1];
        [data getBytes:tday.bytes length:1];
        [data getBytes:tHour.bytes length:1];
        [data getBytes:tMinute.bytes length:1];
        [data getBytes:tSecond.bytes length:1];
        
        
        self.mYear      = tYear;
        self.mMonth     = tMonth;
        self.mDay       = tday;
        self.mHour      = tHour;
        self.mMinute    = tMinute;
        self.mSecond    = tSecond;
        
    }
    return self;
}

#endif


-(instancetype)initWithData:(NSData *)data{
    self = [super init];
    if(self){
        [self formatToCurrentTimeWithNSDataTime:data];
    }
    return self;
}


// Format NSData time to current time
- (void)formatToCurrentTimeWithNSDataTime:(NSData*)data{
    NSData *subData = [NSData data];
    if (data.length == 10) {
        subData = [data subdataWithRange:NSMakeRange(2, 8)];
    }else{
        subData = data;
    }
    
    if (subData.length == 8) {
        UInt16 yearData ;
        [subData getBytes:&yearData range:NSMakeRange(0, 2)];
        NSData *monthData = [subData subdataWithRange:NSMakeRange(2, 1)];
        NSData *dayData = [subData subdataWithRange:NSMakeRange(3, 1)];
        NSData *hourData = [subData subdataWithRange:NSMakeRange(4, 1)];
        NSData *minData = [subData subdataWithRange:NSMakeRange(5, 1)];
        NSData *secondData = [subData subdataWithRange:NSMakeRange(6, 1)];
        
        FBShort tYear;
        tYear.val = 0;
        FBByte  tMonth;
        tMonth.val = 0;
        FBByte  tday;
        tday.val = 0;
        FBByte tHour;
        tHour.val = 0;
        FBByte tMinute;
        tMinute.val= 0;
        FBByte tSecond;
        tSecond.val = 0;

        tYear.val = (UInt16)yearData;
        tMonth.val = (UInt8)[self transfer1:monthData];
        tday.val = (UInt8)[self transfer1:dayData];
        tHour.val = (UInt8)[self transfer1:hourData];
        tMinute.val = (UInt8)[self transfer1:minData];
        tSecond.val = (UInt8)[self transfer1:secondData];

        self.mYear      = tYear;
        self.mMonth     = tMonth;
        self.mDay       = tday;
        self.mHour      = tHour;
        self.mMinute    = tMinute;
        self.mSecond    = tSecond;
        
    }else{
         NSLog(@"Length not right");
    }
}
- (int)transfer1:(NSData*)data{
    NSString *decimal = [FBBLETransfer formatToDecimalStringWithNSData:data];
    int result = decimal.intValue;
    return result;
}

/**
 *  创建正常时间，将年，月，日，时，分，秒转换成NSDate
 *
 *  @param data
 */
- (unsigned long long)createCurrentNormal:(NSData*)data{
    NSData *subData = [NSData data];
    if (data.length == 10) {
        subData = [data subdataWithRange:NSMakeRange(2, 8)];
    }else{
        subData = data;
    }
    
    if (subData.length == 8) {
        UInt16 yearData ;
        [subData getBytes:&yearData range:NSMakeRange(0, 2)];
        NSData *monthData  = [subData subdataWithRange:NSMakeRange(2, 1)];
        NSData *dayData    = [subData subdataWithRange:NSMakeRange(3, 1)];
        NSData *hourData   = [subData subdataWithRange:NSMakeRange(4, 1)];
        NSData *minData    = [subData subdataWithRange:NSMakeRange(5, 1)];
        NSData *secondData = [subData subdataWithRange:NSMakeRange(6, 1)];
        
        NSInteger year     = yearData;
        NSInteger month    = [self transfer:monthData];
        NSInteger day      = [self transfer:dayData];
        NSInteger hour     = [self transfer:hourData];
        NSInteger miniute  = [self transfer:minData];
        NSInteger second   = [self transfer:secondData];
        
        NSLog(@"[createCurrentNormal] %ld,%ld,%ld,%ld,%ld,%ld",(long)year,(long)month,(long)day,(long)hour,(long)miniute,(long)second);
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [[NSDateComponents alloc]init];
        [comps setValue:year forComponent:NSCalendarUnitYear];
        [comps setValue:month forComponent:NSCalendarUnitMonth];
        [comps setValue:day forComponent:NSCalendarUnitDay];
        [comps setValue:hour forComponent:NSCalendarUnitHour];
        [comps setValue:miniute forComponent:NSCalendarUnitMinute];
        [comps setValue:second forComponent:NSCalendarUnitSecond];
        NSDate *dateCom = [calendar dateFromComponents:comps];
        
//        NSTimeZone *zone = [NSTimeZone systemTimeZone];
//        NSInteger interval = [zone secondsFromGMTForDate: dateCom];
//        NSDate *localeDate = [dateCom  dateByAddingTimeInterval: interval];
        
        unsigned long long timestamp = (long)[dateCom timeIntervalSince1970];
        
        NSLog(@"返回正常时间 ：%@ 时间戳：%llu", dateCom,timestamp);
        return timestamp;
    }else{
        NSLog(@"Length not right");
    }
    return 0;
}
- (NSInteger)transfer:(NSData*)data{
    NSString *decimal = [FBBLETransfer formatToDecimalStringWithNSData:data];
    NSInteger result = decimal.integerValue;
    return result;
}

-(instancetype)initWithField:(UInt32)year
                       month:(UInt32)month
                        hour:(UInt32)hour
                         day:(UInt32)day
                      minute:(UInt32)minute
                      second:(UInt32)second{
    
    self = [super init];
    if(self){
        FBShort tYear;
        tYear.val = year;
        FBByte  tMonth;
        tMonth.val  = month;
        FBByte  tday;
        tday.val    = day;
        FBByte tHour;
        tHour.val   = hour;
        FBByte tMinute;
        tMinute.val = minute;
        FBByte tSecond;
        tSecond.val = second;
        
        
        self.mYear      = tYear;
        self.mMonth     = tMonth;
        self.mDay       = tday;
        self.mHour      = tHour;
        self.mMinute    = tMinute;
        self.mSecond    = tSecond;
    }
    return self;
}

-(instancetype)initWithDefault{
    self = [super init];
    if(self){
//        NSDate* date = [[NSDate alloc]initWithTimeIntervalSinceNow:NSTimeIntervalSince1970];
        
    }
    return self;
}

-(NSData*) toByte{
    
    NSMutableData* data = [[NSMutableData alloc]initWithCapacity:8];
    [data appendBytes:self.mYear.bytes length:2];
    [data appendBytes:self.mMonth.bytes length:1];
    [data appendBytes:self.mDay.bytes length:1];
    [data appendBytes:self.mHour.bytes length:1];
    [data appendBytes:self.mMinute.bytes length:1];
    [data appendBytes:self.mSecond.bytes length:1];
    FBByte buf;
    buf.val = 0;
    [data appendBytes:buf.bytes length:1];
    
    
    return data;
}

-(NSString*) toJsonString{
    NSString* jsonString = [[NSString alloc]initWithFormat:@"{`year`:%u,`month`:%u,`day`:%u,`hour`:%u,`minute`:%u,`second`:%u}",self.mYear.val,self.mMonth.val,self.mDay.val,self.mHour.val,self.mMinute.val,self.mSecond.val];
    
    return jsonString;
}

-(UInt64)toTimeStamp{
    NSData* data = [self toByte];
    FBLong timestamp;
    timestamp.val = 0;
    [data getBytes:timestamp.bytes range:NSMakeRange(0, 8)];
    return timestamp.val;
}


@end
