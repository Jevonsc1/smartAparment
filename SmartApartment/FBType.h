//
//  FBType.h
//  demo_farbell
//
//  Created by 六度凶维 on 16-4-28.
//  Copyright (c) 2016年 六度凶维. All rights reserved.
//

#ifndef demo_farbell_FBType_h
#define demo_farbell_FBType_h

#include <MacTypes.h>

typedef union{
    UInt8 val;
    UInt8 bytes[1];
    
}FBByte;

typedef union{
    UInt16 val;
    UInt8 bytes[2];
}FBShort;


typedef union{
    UInt32 val;
    UInt8 bytes[4];
}FBInt;

typedef union{
    UInt64 val;
    UInt8 bytes[8];
}FBLong;



#endif
