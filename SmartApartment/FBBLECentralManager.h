//
//  FBBLECentralManager.h
//  X5
//
//  Created by farbell-imac on 16/9/1.
//
//

#import <Foundation/Foundation.h>

@protocol FBBLECentralManagerDelegate <NSObject>
- (void)fbBleCentralManagerDelegateActivateRedbag;
- (void)fbBleCentralManagerDelegateUploadDoorRecord:(NSString*)localID;

@end

@interface FBBLECentralManager : NSObject

@property(nonatomic,weak) id<FBBLECentralManagerDelegate>delegate;
+(instancetype) shareInsatance;


- (void)startCentralManagerService;
- (void)stopCentralManagerService;


- (void)startScanWithButton:(UIButton *)scanButton;
- (void)disconnectForAll;
@end
