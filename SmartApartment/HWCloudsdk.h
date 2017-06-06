//
//  HWCloudsdk.h
//  wssdk_noframe
//
//  Created by mhz on 14-8-5.
//  Copyright (c) 2014年 com.hanvon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;
// 回掉block
typedef void (^successBlock)(id responseObject);
typedef void (^failureBlock)(NSError *error);
@interface HWCloudsdk : NSObject


#pragma mark  名片识别

/**
 *  传入图片识别名片
 *
 *  @param language         语言类型 chns 简体 chnt繁体 en英文 auto 多语言
 *  @param cardImage        图片
 *  @param cardImageData    图片二进制
 *  @param cardImage        图片路径
 *  @param apiKey           apikey
 *
 *  @return result
 */
-(NSString *)cardLanguage:(NSString *)language
                cardImage:(UIImage *) cardImage
                   apiKey:(NSString *)apiKey;

-(NSString *)cardLanguage:(NSString *)language
            cardImageData:(NSData *) cardImageData
                   apiKey:(NSString *)apiKey;

-(NSString *)cardLanguage:(NSString *)language
            cardImagePath:(NSString *) cardImagePath
                   apiKey:(NSString *)apiKey;


/**
 *  传入图片识别名片
 *
 *  @param language         语言类型 chns 简体 chnt繁体 en英文
 *  @param cardImage        图片
 *  @param cardImageData    图片二进制
 *  @param cardImage        图片路径
 *  @param apiKey           apikey
 *  @param successBlock     成功回掉
 *  @param failureBlock     失败回掉
 *
 */


-(void )cardLanguage:(NSString *)language
           cardImage:(UIImage *) cardImage
              apiKey:(NSString *)apiKey
        successBlock:(successBlock)successBlock
        failureBlock:(failureBlock)failureBlock;

-(void )cardLanguage:(NSString *)language
       cardImageData:(NSData *) cardImageData
              apiKey:(NSString *)apiKey
        successBlock:(successBlock)successBlock
        failureBlock:(failureBlock)failureBlock;


-(void )cardLanguage:(NSString *)language
       cardImagePath:(NSString *) cardImagePath
              apiKey:(NSString *)apiKey
        successBlock:(successBlock)successBlock
        failureBlock:(failureBlock)failureBlock;

#pragma mark  文本识别

/**
 *  传入文本图片识别
 *
 *  @param language         语言类型 chns 简体 chnt繁体 en英文
 *  @param textImage        文本图片
 *  @param textImageData    文本图片二进制
 *  @param textImagePath    文本图片路径
 *  @param apiKey           apikey
 *
 *  @return result
 */
-(NSString *) lang:(NSString *) language
         textImage:(UIImage *) textImage
            apiKey:(NSString *) apiKey;

-(NSString *) lang:(NSString *) language
     textImageData:(NSData *) textImageData
            apiKey:(NSString *) apiKey;

-(NSString *) lang:(NSString *) language
     textImagePath:(NSString *) textImagePath
            apiKey:(NSString *) apiKey;


/**
 *  传入文本图片识别
 *
 *  @param language         语言类型 chns 简体 chnt繁体 en英文
 *  @param textImage        文本图片
 *  @param textImageData    文本图片二进制
 *  @param textImagePath    文本图片路径
 *  @param apiKey           apikey
 *  @param successBlock     成功回掉
 *  @param failureBlock     失败回掉
 *
 */
-(void ) lang:(NSString *) language
    textImage:(UIImage *) textImage
       apiKey:(NSString *) apiKey
 successBlock:(successBlock)successBlock
 failureBlock:(failureBlock)failureBlock;

-(void ) lang:(NSString *) language
textImageData:(NSData *) textImageData
       apiKey:(NSString *) apiKey
 successBlock:(successBlock)successBlock
 failureBlock:(failureBlock)failureBlock;

-(void ) lang:(NSString *) language
textImagePath:(NSString *) textImagePath
       apiKey:(NSString *) apiKey
 successBlock:(successBlock)successBlock
 failureBlock:(failureBlock)failureBlock;



#pragma mark  单字手写识别

/**
 *  单字手写识别
 *
 *  @param type         1:手写轨迹识别 2:获取单字的联想字
 *  @param language     语言类型 chns 简体 chnt繁体 en英文
 *  @param data         当 type==1 时:单字手写数据。
 *  @param apiKey       apikey
 */

- (NSString *) type:(NSString *) type
               lang:(NSString *) language
     handSingleData:(NSString *) data
             apiKey:(NSString *) apiKey;

/**
 *  单字手写识别
 *
 *  @param type             1:手写轨迹识别 2:获取单字的联想字
 *  @param language         语言类型 chns 简体 chnt繁体 en英文
 *  @param data             当 type==1 时:单字手写数据。
 *  @param apiKey           apikey
 *  @param successBlock     成功回掉
 *  @param failureBlock     失败回掉
 */
- (void ) type:(NSString *) type
          lang:(NSString *) language
handSingleData:(NSString *) data
        apiKey:(NSString *) apiKey
  successBlock:(successBlock)successBlock
  failureBlock:(failureBlock)failureBlock;



#pragma mark 行手写识别

/**
 *  行手写识别
 *
 *  @param language     语言类型 chns 简体 chnt繁体 en英文
 *  @param data         当 type==1 时:单字手写数据。
 *  @param apiKey       apikey
 *
 */

- (NSString *) lang:(NSString *) language
       handLineData:(NSString *) data
             apiKey:(NSString *) apiKey;

/**
 *  行手写识别
 *
 *  @param language         语言类型 chns 简体 chnt繁体 en英文
 *  @param data             当 type==1 时:单字手写数据。
 *  @param apiKey           apikey
 *  @param successBlock     成功回掉
 *  @param failureBlock     失败回掉
 *
 */
- (void ) lang:(NSString *) language
  handLineData:(NSString *) data
        apiKey:(NSString *) apiKey
  successBlock:(successBlock)successBlock
  failureBlock:(failureBlock)failureBlock;



#pragma mark 叠写识别
/**
 *  叠写识别
 *
 *  @param language      语言类型 chns 简体 chnt繁体 en英文
 *  @param data          行手写数据
 *  @param apiKey        服务授权 Key(iOS Key)
 *
 *  @return result
 */

- (NSString *) lang:(NSString *) language
     handRepeatData:(NSString *) data
             apiKey:(NSString *) apiKey;

/**
 *  叠写识别
 *
 *  @param language         语言类型 chns 简体 chnt繁体 en英文
 *  @param data             行手写数据
 *  @param apiKey           服务授权 Key(iOS Key)
 *  @param successBlock     成功回掉
 *  @param failureBlock     失败回掉
 *
 */

- (void) lang:(NSString *) language
handRepeatData:(NSString *) data
       apiKey:(NSString *) apiKey
 successBlock:(successBlock)successBlock
 failureBlock:(failureBlock)failureBlock;

#pragma mark 身份证识别

/**
 *  传入身份证图片识别
 *
 *  @param idCardImage          身份证图片
 *  @param idCardImagePath      身份证图片路径
 *  @param idCardImageData      身份证图片二进制
 *  @param apiKey               apikey
 *
 *  @return result
 */
-(NSString *)idCardImage:(UIImage *)idCardImage
                  apiKey:(NSString *) apiKey;

-(NSString *)idCardImagePath:(NSString *)idCardImagePath
                      apiKey:(NSString *) apiKey;

-(NSString *)idCardImageData:(NSData *)idCardImageData
                      apiKey:(NSString *) apiKey;


/**
 *  传入身份证图片识别
 *
 *  @param idCardImage          身份证图片
 *  @param idCardImagePath      身份证图片路径
 *  @param idCardImageData      身份证图片二进制
 *  @param apiKey               apikey
 *  @param successBlock         成功回掉
 *  @param failureBlock         失败回掉
 *
 */
-(void )idCardImage:(UIImage *)idCardImage
             apiKey:(NSString *) apiKey
       successBlock:(successBlock)successBlock
       failureBlock:(failureBlock)failureBlock;

-(void )idCardImagePath:(NSString *)idCardImagePath
                 apiKey:(NSString *) apiKey
           successBlock:(successBlock)successBlock
           failureBlock:(failureBlock)failureBlock;

-(void )idCardImageData:(NSData *)idCardImageData
                 apiKey:(NSString *) apiKey
           successBlock:(successBlock)successBlock
           failureBlock:(failureBlock)failureBlock;


#pragma mark 人脸定位识别

/**
 *  人脸定位识别
 *
 *  @param faceImage        人脸图片
 *  @param faceImagePath    人脸图片路径
 *  @param faceImageData    人脸图片二进制
 *  @param apiKey           apikey
 *
 *  @return result
 */
-(NSString *)faceImage:(UIImage *)faceImage
                apiKey:(NSString *)apiKey;

-(NSString *)faceImagePath:(NSString *)faceImagePath
                    apiKey:(NSString *)apiKey;

-(NSString *)faceImageData:(NSData *)faceImageData
                    apiKey:(NSString *)apiKey;

/**
 *  人脸定位识别
 *
 *  @param faceImage        人脸图片
 *  @param faceImagePath    人脸图片路径
 *  @param faceImageData    人脸图片二进制
 *  @param apiKey           apikey
 *  @param successBlock     成功回掉
 *  @param failureBlock     失败回掉
 *
 */
-(void )faceImage:(UIImage *)faceImage
           apiKey:(NSString *)apiKey
     successBlock:(successBlock)successBlock
     failureBlock:(failureBlock)failureBlock;

-(void )faceImagePath:(NSString *)faceImagePath
               apiKey:(NSString *)apiKey
         successBlock:(successBlock)successBlock
         failureBlock:(failureBlock)failureBlock;

-(void )faceImageData:(NSData *)faceImageData
               apiKey:(NSString *)apiKey
         successBlock:(successBlock)successBlock
         failureBlock:(failureBlock)failureBlock;


#pragma mark 年龄、表情识别

/**
 *  传入人脸图片识别年龄、表情
 *
 *  @param faceImage        人脸图片
 *  @param faceImagePath    人脸图片路径
 *  @param faceImageData    人脸图片二进制
 *
 *  @return result
 */
-(NSString *)theFaceImage:(UIImage *)faceImage
                   apiKey:(NSString *)apiKey;

-(NSString *)theFaceImagePath:(NSString *)faceImagePath
                       apiKey:(NSString *)apiKey;

-(NSString *)theFaceImageData:(NSData *)faceImageData
                       apiKey:(NSString *)apiKey;


/**
 *  传入人脸图片识别年龄、表情
 *
 *  @param faceImage        人脸图片
 *  @param faceImagePath    人脸图片路径
 *  @param faceImageData    人脸图片二进制
 *  @param successBlock     成功回掉
 *  @param failureBlock     失败回掉
 *
 */
-(void )theFaceImage:(UIImage *)faceImage
              apiKey:(NSString *)apiKey
        successBlock:(successBlock)successBlock
        failureBlock:(failureBlock)failureBlock;

-(void )theFaceImagePath:(NSString *)faceImagePath
                  apiKey:(NSString *)apiKey
            successBlock:(successBlock)successBlock
            failureBlock:(failureBlock)failureBlock;

-(void )theFaceImageData:(NSData *)faceImageData
                  apiKey:(NSString *)apiKey
            successBlock:(successBlock)successBlock
            failureBlock:(failureBlock)failureBlock;

#pragma mark 手写公式识别
/**
 *  手写公式识别
 *
 *  @param formulaData      公式数据
 *  @param apiKey           apikey
 *
 *  @return result
 */

-(NSString *)formulaData:(NSString *)formulaData
                  apiKey:(NSString *)apiKey;


/**
 *  手写公式识别
 *
 *  @param formulaData      公式数据
 *  @param apiKey           apikey
 *  @param successBlock     成功回掉
 *  @param failureBlock     失败回掉
 *
 */
-(void )formulaData:(NSString *)formulaData
             apiKey:(NSString *)apiKey
       successBlock:(successBlock)successBlock
       failureBlock:(failureBlock)failureBlock;

#pragma mark 题目识别

/**
 *  传入题目图片识别
 *
 *  @param problemImage         图片
 *  @param problemImagePath     图片路径
 *  @param problemImageData     图片二进制
 *  @param apiKey               apikey
 *
 *  @return result
 */
-(NSString *)problemImage:(UIImage *)problemImage
                   apiKey:(NSString *)apiKey;


-(NSString *)problemImagePath:(NSString *)problemImagePath
                       apiKey:(NSString *)apiKey;

-(NSString *)problemImageData:(NSData *)problemImageData
                       apiKey:(NSString *)apiKey;


/**
 *  传入题目图片识别
 *
 *  @param problemImage         图片
 *  @param problemImagePath     图片路径
 *  @param problemImageData     图片二进制
 *  @param apiKey               apikey
 *  @param successBlock         成功回掉
 *  @param failureBlock         失败回掉
 *
 */
-(void )problemImage:(UIImage *)problemImage
              apiKey:(NSString *)apiKey
        successBlock:(successBlock)successBlock
        failureBlock:(failureBlock)failureBlock;

-(void )problemImagePath:(NSString *)problemImagePath
                  apiKey:(NSString *)apiKey
            successBlock:(successBlock)successBlock
            failureBlock:(failureBlock)failureBlock;

-(void )problemImageData:(NSData *)problemImageData
                  apiKey:(NSString *)apiKey
            successBlock:(successBlock)successBlock
            failureBlock:(failureBlock)failureBlock;


/**
 *  云数字识别
 *
 *  @param textImage        文本图片
 *  @param textImageData    文本图片二进制
 *  @param textImagePath    文本图片路径
 *  @param apiKey           apikey
 *  @param successBlock     成功回掉
 *  @param failureBlock     失败回掉
 *
 */
-(void )digitalImage:(UIImage *) textImage
       apiKey:(NSString *) apiKey
 successBlock:(successBlock)successBlock
 failureBlock:(failureBlock)failureBlock;

-(void )digitalImageData:(NSData *) textImageData
       apiKey:(NSString *) apiKey
 successBlock:(successBlock)successBlock
 failureBlock:(failureBlock)failureBlock;

-(void )digitalImagePath:(NSString *) textImagePath
       apiKey:(NSString *) apiKey
 successBlock:(successBlock)successBlock
 failureBlock:(failureBlock)failureBlock;


@end
