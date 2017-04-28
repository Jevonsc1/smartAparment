//
//  FBBLECentralManager.m
//  X5
//
//  Created by farbell-imac on 16/9/1.
//
//

#import "FBBLECentralManager.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreMotion/CoreMotion.h>

#import "FBBLETransfer.h"
#import "TDBLENodeTool.h"


#define FBBLE_SERVICE_UUID               @[[CBUUID UUIDWithString:@"FFF0"]]
#define FBBLE_CHARACTERISTICS_LOCALUUID  @"FFF5"
#define FBBLE_CHARACTERISTICS_WRITEUUID  @"FFF6"
#define FBBLE_PERIPHERALNAME             @"TrudBleAcces"
#define SCAN_TIME_INTERVAL               5

@interface FBBLECentralManager()<CBPeripheralDelegate,CBCentralManagerDelegate>
@property (strong, nonatomic) NSMutableArray <CBPeripheral *> *peripherals;
@property (strong, nonatomic) NSTimer *scanTimeoutTimer;
@property (assign, nonatomic) NSTimeInterval scanTimeInterval;
@property (assign, nonatomic) BOOL isScanning;
@property (strong, nonatomic) CBCentralManager   *myCentralManager;
@property (strong, nonatomic)CBCharacteristic   *myWritableCharacteristic;
@property (strong, nonatomic)CBCharacteristic   *myLocalIDCharacteristic;
@end

@implementation FBBLECentralManager
{
    BOOL noPeripheral;
    CMMotionManager    *motionManager;

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.peripherals = [[NSMutableArray alloc] init];
        self.myCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey:@YES}];
    }
    return self;
}

+ (instancetype) shareInsatance
{
    static FBBLECentralManager* Instance = nil;
    static dispatch_once_t dispatch;
    dispatch_once(&dispatch, ^{
        Instance = [[FBBLECentralManager alloc] init];
    });
    
    return Instance;
}

# pragma mark - Private Menthos
- (void)startScanWithButton:(UIButton *)scanButton {
    if ([_scanTimeoutTimer isValid]) {
        return;
    }
    
    if (self.myCentralManager.state == CBManagerStatePoweredOff) {
        [MBProgressHUD showMessage:@"请开启蓝牙后重试"];
    }
    
    if (self.myCentralManager.state == CBManagerStatePoweredOn) {
        [self scan];
    }
}

-(void)scan{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showProgress];
    });
        
    if (self.myCentralManager) {
            //            [myCentralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"FFF0"]] options:nil];
        [self.myCentralManager scanForPeripheralsWithServices:nil options:nil];
    }
        
    if (!_scanTimeoutTimer || ![_scanTimeoutTimer isValid]) {
        
        _scanTimeoutTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(scanTimeout) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_scanTimeoutTimer forMode:NSDefaultRunLoopMode];
    }
    _scanTimeInterval = SCAN_TIME_INTERVAL;
    [_scanTimeoutTimer start];

}


- (void)scanTimeout {
    
    _scanTimeInterval -= 1;
    if (_scanTimeInterval <= 0) {
        [_scanTimeoutTimer pause];
        [_scanTimeoutTimer stop];
        
        if (noPeripheral) {
            [MBProgressHUD showMessage:@"您距门禁太远了，请靠近些再试试看"];
        }else {
            [MBProgressHUD showMessage:@"在您周围找不到门禁或门禁正在被使用，请靠近门禁或稍后重试"];
                
        }
        noPeripheral = NO;
 
        
        [self disconnectForAll];
    }
}

- (void)stopScanBLE {
    
    [_scanTimeoutTimer pause];
    [_scanTimeoutTimer stop];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
    });
    if (self.myCentralManager) {
        
        [self.myCentralManager stopScan];
    }
}

- (void)disconnectForAll {
    if (_peripherals) {
        for (CBPeripheral *peripheral in _peripherals)
        {
            if (peripheral.state == CBPeripheralStateConnected || peripheral.state == CBPeripheralStateConnecting) {
                [self.myCentralManager cancelPeripheralConnection:peripheral];
            }
        }
        [_peripherals removeAllObjects];
    }
    
    [self stopScanBLE];
    
    [self startUpdateAccelerometer];
}

#pragma mark - centralManager Delegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (self.myCentralManager.state == CBCentralManagerStatePoweredOn){
        if (![_scanTimeoutTimer isValid]|| !_scanTimeoutTimer) {
            [self scan];
        }
        // 开启加速计
        [self startUpdateAccelerometer];
    }else{
        [MBProgressHUD showMessage:@"请开启蓝牙后重试"];

        // 关闭加速计（没开蓝牙）
        [self stopUpdateAccelerometer];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    //NSLog(@"扫描到蓝牙（%@）",peripheral.name);
    if ([_peripherals containsObject:peripheral]) {
        return;
    }
    
    if (!peripheral.name) {
        return;
    }
    
    [_peripherals addObject:peripheral];
    
    NSLog(@"扫描到蓝牙（%@）",peripheral.name);
    if ([peripheral.name hasPrefix:@"TRD_"]) {
        //if ([peripheral.name isEqualToString:@"TRD_0200012016041305"]) {
        if ([self isTrueLocalIDName:peripheral.name]) {
            noPeripheral = YES;
            _scanTimeInterval = SCAN_TIME_INTERVAL;
            [self.myCentralManager stopScan];
            [self.myCentralManager connectPeripheral:peripheral options:nil];
        }
    }else if ([peripheral.name isEqualToString:FBBLE_PERIPHERALNAME]) {
        _scanTimeInterval = SCAN_TIME_INTERVAL;
        [self.myCentralManager connectPeripheral:peripheral options:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    if (error) {
        NSLog(@"(%@)连接蓝牙失败: %ld, %@, %@", peripheral.name, error.code, error.domain, error.userInfo);
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    _scanTimeInterval = SCAN_TIME_INTERVAL;
    //NSLog(@"连接蓝牙成功，开始获取服务：（%@）", peripheral.name);
    peripheral.delegate = self;
    [peripheral discoverServices:FBBLE_SERVICE_UUID];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    if (error) {
        NSLog(@"(%@)didDisconnectPeripheral : %ld, %@, %@", peripheral.name, error.code, error.domain, error.userInfo);
    }else {
        //NSLog(@"(%@)didDisconnectPeripheral", peripheral.name);
    }
}

#pragma mark - peripheral Delegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    _scanTimeInterval = SCAN_TIME_INTERVAL;
    //NSLog(@"获取服务成功，开始获取特征：（%@）", peripheral.name);
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:FBBLE_CHARACTERISTICS_WRITEUUID],[CBUUID UUIDWithString:FBBLE_CHARACTERISTICS_LOCALUUID]] forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    _scanTimeInterval = SCAN_TIME_INTERVAL;
    //NSLog(@"获取特征成功，准备写入数据：（%@）", peripheral.name);
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ( [characteristic.UUID isEqual:[CBUUID UUIDWithString:FBBLE_CHARACTERISTICS_WRITEUUID] ] ) {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            self.myWritableCharacteristic = characteristic;
        }
        
        if ([peripheral.name isEqualToString:FBBLE_PERIPHERALNAME]) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:FBBLE_CHARACTERISTICS_LOCALUUID]]) {
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                [peripheral readValueForCharacteristic:characteristic];
                self.myLocalIDCharacteristic = characteristic;
            }
        }
    }
    
    //if ([peripheral.name isEqualToString:@"TRD_0200012016041305"]) {
    if ([self isTrueLocalIDName:peripheral.name]) {
        if (self.myWritableCharacteristic) {
            //NSLog(@"写入数据：（%@）, 当前时间: %lld毫秒", peripheral.name, (long long)([[NSDate date] timeIntervalSince1970]*1000));
            [peripheral writeValue:[self unlockCommand] forCharacteristic:self.myWritableCharacteristic type:CBCharacteristicWriteWithoutResponse];
        }
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"(%@): characteristic.UUID = %@; error = %@;", peripheral.name, characteristic.UUID, error.domain);
        return;
    }
    
    //NSLog(@"(%@) characteristic.UUID = %@", peripheral.name, characteristic.UUID);
    if ([characteristic.UUID.UUIDString isEqualToString:FBBLE_CHARACTERISTICS_LOCALUUID]) {
        // 一定是旧设备
        NSString *localID = [FBBLETransfer NSDataToHexadecimal:self.myLocalIDCharacteristic.value];
        if([self isTrueLocalIDName:localID]) {
            noPeripheral = YES;
            if (self.myWritableCharacteristic) {
                //NSLog(@"写入数据：（%@）, 当前时间: %lld毫秒", peripheral.name, (long long)([[NSDate date] timeIntervalSince1970]*1000));
                [peripheral writeValue:[self unlockCommand] forCharacteristic:self.myWritableCharacteristic type:CBCharacteristicWriteWithoutResponse];
                [peripheral readValueForCharacteristic:self.myWritableCharacteristic];
            }else {
                NSLog(@"myWritableCharacteristic 为空");
            }
        }else {
            [self.myCentralManager cancelPeripheralConnection:peripheral];
        }
    }
    
    if ([characteristic.UUID.UUIDString isEqualToString:FBBLE_CHARACTERISTICS_WRITEUUID]) {
        //NSLog(@"收到数据：（%@）, 当前时间: %lld毫秒", peripheral.name, (long long)([[NSDate date] timeIntervalSince1970]*1000));
        NSString *string = [FBBLETransfer NSDataToHexadecimal:characteristic.value];
        if([string isEqualToString:@"9000"]){
            
            // 开门成功断开连接
            [self disconnectForAll];

            // 功能1：通知
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            [self localNotification];
            
            // 功能2：上传开门数据
            NSString *localID = [FBBLETransfer NSDataToHexadecimal:self.myLocalIDCharacteristic.value];
            if (self.delegate && [self.delegate respondsToSelector:@selector(fbBleCentralManagerDelegateUploadDoorRecord:)]) {
                [self.delegate fbBleCentralManagerDelegateUploadDoorRecord:localID];
            }
            
            // 功能3：成功开门重新开启加速更新
//            if (self.delegate && [self.delegate respondsToSelector:@selector(fbBleCentralManagerDelegateShowMessage:)]) {
//                [self.delegate fbBleCentralManagerDelegateShowMessage:@"开门成功！"];
//            }
            [MBProgressHUD showMessage:@"开门成功！"];
            [self startUpdateAccelerometer];

            // 功能4：展示红包动画
            if (self.delegate && [self.delegate respondsToSelector:@selector(fbBleCentralManagerDelegateActivateRedbag)]) {
                [self.delegate fbBleCentralManagerDelegateActivateRedbag];
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {

    if (error) {
        // 写入数据失败，后续需要考虑重写
        NSLog(@"(%@): didWriteValueForCharacteristic error = %@;", peripheral.name, error.domain);
    }
}

#pragma mark - Nouseally
- (void)startCentralManagerService
{
    // 外部调用：首页：物业
    if (self.myCentralManager==nil)
    {
        //myCentralManager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_global_queue(0, 0) options:nil];
        self.myCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey:@YES}];
    }
}

- (void)stopCentralManagerService {
    [self stopUpdateAccelerometer];
}

- (void)startUpdateAccelerometer
{
    if (self.myCentralManager.state != CBCentralManagerStatePoweredOn) {
        return;
    }
    
    if (!motionManager) {
        motionManager = [[CMMotionManager alloc] init];
    }
    
    // 开始加速更新----加速计更新间隔
    motionManager.accelerometerUpdateInterval = 0.1;
    // 开始加速更新
    [motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc]init] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        // 计算加速度
        double accelerameter = sqrt( pow( accelerometerData.acceleration.x , 2 ) + pow( accelerometerData.acceleration.y , 2 ) + pow( accelerometerData.acceleration.z , 2) );
        // 判断加速度
        if (accelerameter > 2.8f) {
            // 停止加速更新
            [self stopUpdateAccelerometer];
            [self startScanWithButton:nil];
        }
    }];
}

- (void)stopUpdateAccelerometer
{
    if (motionManager) {
        [motionManager stopAccelerometerUpdates];
    }
}

-(void)dealloc
{
    [_scanTimeoutTimer stop];
}

- (BOOL)isTrueLocalIDName:(NSString *)localIDName {
    if (!localIDName) {
        return NO;
    }
    
    NSString *localID = localIDName;
    NSString *prefix = @"TRD_";
    if ([localIDName hasPrefix:prefix]) {
        if ([localIDName length] > [prefix length]) {
            localID = [localIDName substringWithRange:NSMakeRange([prefix length], [localIDName length]-[prefix length])];
        }else {
            return NO;
        }
    }
    
    NSArray *localIDs = [NSArray arrayWithContentsOfFile:USEFUL_DOOR_NODE_PATH];
    if ([localIDs count] == 0) {
        NSDictionary *localIDDict = [NSDictionary dictionaryWithContentsOfFile:USEFUL_DOOR_NODE_PATH];
        localIDs = [localIDDict allValues];
    }
    for (NSString *obj in localIDs) {
        if ([[obj lowercaseString] isEqualToString:[localID lowercaseString]]) {
            return YES;
        }
    }
    return NO;
}

- (void)localNotification
{
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state == UIApplicationStateBackground){
        UILocalNotification *localNotification = [[UILocalNotification alloc]init];
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertBody = @"开门成功";
        UIApplication *application = [UIApplication sharedApplication];
        [application scheduleLocalNotification:localNotification];
    }
}

- (NSData*)unlockCommand
{
    NSMutableData* mutableData = [NSMutableData data];
    unsigned char cla = 0x00;
    [mutableData appendBytes:&cla length:1];
    unsigned char ins = 0x81;
    [mutableData appendBytes:&ins length:1];
    unsigned char p1 = 0x00;
    [mutableData appendBytes:&p1 length:1];
    unsigned char p2 = 0x00;
    [mutableData appendBytes:&p2 length:1];
    unsigned char p3 = 0x00;
    [mutableData appendBytes:&p3 length:1];
    
    return mutableData;
}

@end
