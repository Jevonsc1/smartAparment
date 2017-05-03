//
//  SAapartementCell.m
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/8.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "SAapartementCell.h"
#import "Community.h"
#import "UIImageView+WebCache.h"

//#import "MJExtension.h"

//#import "SAhouseInfoModel.h"

//#import "UIImage+UIImageScale.h"

@interface SAapartementCell()

@property (weak, nonatomic) IBOutlet UILabel *apartmentName;

@property (weak, nonatomic) IBOutlet UILabel *lastRoomCount;//剩余房间数

@property (weak, nonatomic) IBOutlet UILabel *persentIn;//入住率


@end

@implementation SAapartementCell

- (void)setCommunity:(Community *)community{
    //公寓名字
    self.apartmentName.text=community.communityName;
    //判断是否被驳回
    if(community.communityStatus.intValue == 20){
        self.rejImage.hidden = NO;
    }else{
        self.rejImage.hidden = YES;
    }
    //公寓图片
    if (community.communityPicAffixs.count>0) {
        NSString *imageString = community.communityPicAffixs[0];
        [self.apartmentImage sd_setImageWithURL:[NSURL URLWithString:imageString] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            [self.apartmentImage setContentMode:UIViewContentModeScaleAspectFill];
            self.apartmentImage.clipsToBounds = YES;
        }];
        
    }
    
    NSArray *array = community.houseInfoList;
    NSInteger roomCount = array.count;//房间数
    NSMutableArray *houseArray = [NSMutableArray array];
    for (House* house in array) {
        if ([house.houseStatus.stringValue isEqualToString:LOGINHOUSE]) {
            [houseArray addObject:house];
        }
    }

    
    NSInteger roomInCount = houseArray.count;//出租
    if (roomInCount>0) {
        CGFloat persenIN = (CGFloat)roomInCount/roomCount;
        NSString *persenInString = [NSString stringWithFormat:@"%2.f%%",persenIN*100];
        
        NSInteger roomLeft = roomCount-roomInCount;
        NSString *roomLeftString = [NSString stringWithFormat:@"%ld间",(long)roomLeft];
        //剩余房间数
        self.lastRoomCount.text = roomLeftString;
        
        //入住率
        self.persentIn.text = persenInString;
    }else{
        //房子一间没租出去
        self.lastRoomCount.text = [NSString stringWithFormat:@"%ld间",(long)roomCount];
        self.persentIn.text=@"%0";
    }
    
}
- (UIImage *)scaleToSize:(CGSize)newSize andImage:(UIImage *)image {
    CGFloat width = image.size.width;
    CGFloat height= image.size.height;
    CGFloat newSizeWidth = newSize.width;
    CGFloat newSizeHeight= newSize.height;
    if (width <= newSizeWidth &&
        height <= newSizeHeight) {
        return image;
    }
    
    if (width == 0 || height == 0 || newSizeHeight == 0 || newSizeWidth == 0) {
        return nil;
    }
    CGSize size;
    if (width / height > newSizeWidth / newSizeHeight) {
        size = CGSizeMake(newSizeWidth, newSizeWidth * height / width);
    } else {
        size = CGSizeMake(newSizeHeight * width / height, newSizeHeight);
    }
    return [self drawImageWithSize:size andImage:image];
}
- (UIImage *)drawImageWithSize: (CGSize)size andImage:(UIImage *)image {
    CGSize drawSize = CGSizeMake(floor(size.width), floor(size.height));
    UIGraphicsBeginImageContext(drawSize);
    
    [image drawInRect:CGRectMake(0, 0, drawSize.width, drawSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
