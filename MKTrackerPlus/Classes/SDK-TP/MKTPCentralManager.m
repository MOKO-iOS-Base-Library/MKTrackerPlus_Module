//
//  MKTPCentralManager.m
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/24.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKTPCentralManager.h"

#import "MKBLEBaseCentralManager.h"
#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseLogManager.h"

#import "MKTPPeripheral.h"
#import "MKTPOperation.h"
#import "MKTPTaskAdopter.h"
#import "CBPeripheral+MKTPAdd.h"

#import "MKTPSDKDefines.h"

NSString *const mk_tp_peripheralConnectStateChangedNotification = @"mk_tp_peripheralConnectStateChangedNotification";
NSString *const mk_tp_centralManagerStateChangedNotification = @"mk_tp_centralManagerStateChangedNotification";

NSString *const mk_tp_receiveScannerTrackedDataNotification = @"mk_tp_receiveScannerTrackedDataNotification";
NSString *const mk_tp_deviceDisconnectTypeNotification = @"mk_tp_deviceDisconnectTypeNotification";

static MKTPCentralManager *manager = nil;
static dispatch_once_t onceToken;

@interface MKTPCentralManager ()

@property (nonatomic, copy)NSString *password;

@property (nonatomic, copy)void (^sucBlock)(CBPeripheral *peripheral);

@property (nonatomic, copy)void (^failedBlock)(NSError *error);

@property (nonatomic, assign)mk_tp_bleCentralConnectStatus connectStatus;

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation MKTPCentralManager

- (instancetype)init {
    if (self = [super init]) {
        [[MKBLEBaseCentralManager shared] loadDataManager:self];
    }
    return self;
}

+ (MKTPCentralManager *)shared {
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [MKTPCentralManager new];
        }
    });
    return manager;
}

+ (void)sharedDealloc {
    [MKBLEBaseCentralManager singleDealloc];
    manager = nil;
    onceToken = 0;
}

+ (void)removeFromCentralList {
    [[MKBLEBaseCentralManager shared] removeDataManager:manager];
    manager = nil;
    onceToken = 0;
}

#pragma mark - MKBLEBaseScanProtocol
- (void)MKBLEBaseCentralManagerDiscoverPeripheral:(CBPeripheral *)peripheral
                                advertisementData:(NSDictionary<NSString *,id> *)advertisementData
                                             RSSI:(NSNumber *)RSSI {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"%@,%@",advertisementData,RSSI);
        NSDictionary *dataModel = [self parseModelWith:RSSI advDic:advertisementData peripheral:peripheral];
        if (!dataModel) {
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(mk_tp_receiveDevice:)]) {
                [self.delegate mk_tp_receiveDevice:dataModel];
            }
        });
    });
}

- (void)MKBLEBaseCentralManagerStartScan {
    if ([self.delegate respondsToSelector:@selector(mk_tp_startScan)]) {
        [self.delegate mk_tp_startScan];
    }
}

- (void)MKBLEBaseCentralManagerStopScan {
    if ([self.delegate respondsToSelector:@selector(mk_tp_stopScan)]) {
        [self.delegate mk_tp_stopScan];
    }
}

#pragma mark - MKBLEBaseCentralManagerStateProtocol
- (void)MKBLEBaseCentralManagerStateChanged:(MKCentralManagerState)centralManagerState {
    NSLog(@"蓝牙中心改变");
    [[NSNotificationCenter defaultCenter] postNotificationName:mk_tp_centralManagerStateChangedNotification object:nil];
}

- (void)MKBLEBasePeripheralConnectStateChanged:(MKPeripheralConnectState)connectState {
    //连接成功的判断必须是发送密码成功之后
    if (connectState == MKPeripheralConnectStateUnknow) {
        self.connectStatus = mk_tp_bleCentralConnectStatusUnknow;
    }else if (connectState == MKPeripheralConnectStateConnecting) {
        self.connectStatus = mk_tp_bleCentralConnectStatusConnecting;
    }else if (connectState == MKPeripheralConnectStateConnectedFailed) {
        self.connectStatus = mk_tp_bleCentralConnectStatusConnectedFailed;
    }else if (connectState == MKPeripheralConnectStateDisconnect) {
        self.connectStatus = mk_tp_bleCentralConnectStatusDisconnect;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:mk_tp_peripheralConnectStateChangedNotification object:nil];
}

#pragma mark - MKBLEBaseCentralManagerProtocol
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"+++++++++++++++++接收数据出错");
        return;
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF0D")]) {
        //引起设备断开连接的类型
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:characteristic.value];
        [[NSNotificationCenter defaultCenter] postNotificationName:mk_tp_deviceDisconnectTypeNotification
                                                            object:nil
                                                          userInfo:@{@"type":content}];
        return;
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF0E")]) {
        //广播的数据
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:characteristic.value];
        [self.dataList addObject:content];
        [[NSNotificationCenter defaultCenter] postNotificationName:mk_tp_receiveScannerTrackedDataNotification
                                                            object:nil
                                                          userInfo:@{@"content":content}];
        return;
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (error) {
        NSLog(@"+++++++++++++++++发送数据出错");
        return;
    }
    
}

#pragma mark - public method
- (CBCentralManager *)centralManager {
    return [MKBLEBaseCentralManager shared].centralManager;
}

- (CBPeripheral *)peripheral {
    return [MKBLEBaseCentralManager shared].peripheral;
}

- (MKCentralManagerState )centralStatus {
    return [MKBLEBaseCentralManager shared].centralStatus;
}

- (void)startScan {
    [[MKBLEBaseCentralManager shared] scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"FF02"],[CBUUID UUIDWithString:@"FF04"]] options:nil];
}

- (void)stopScan {
    [[MKBLEBaseCentralManager shared] stopScan];
}

- (void)connectPeripheral:(CBPeripheral *)peripheral
                 password:(NSString *)password
                 sucBlock:(void (^)(CBPeripheral * _Nonnull))sucBlock
              failedBlock:(void (^)(NSError * _Nonnull))failedBlock {
    if (!peripheral) {
        [MKBLEBaseSDKAdopter operationConnectFailedBlock:failedBlock];
        return;
    }
    if (password.length != 8 || ![MKBLEBaseSDKAdopter asciiString:password]) {
        [self operationFailedBlockWithMsg:@"Password Error" failedBlock:failedBlock];
        return;
    }
    self.password = nil;
    self.password = password;
    __weak typeof(self) weakSelf = self;
    [self connectPeripheral:peripheral successBlock:^(CBPeripheral *peripheral) {
        __strong typeof(self) sself = weakSelf;
        if (sucBlock) {
            sucBlock(peripheral);
        }
        sself.sucBlock = nil;
        sself.failedBlock = nil;
    } failedBlock:^(NSError *error) {
        __strong typeof(self) sself = weakSelf;
        sself.sucBlock = nil;
        sself.failedBlock = nil;
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

- (void)disconnect {
    [[MKBLEBaseCentralManager shared] disconnect];
}

- (BOOL)notifyScannerTrackedData:(BOOL)notify {
    if (self.connectStatus != mk_tp_bleCentralConnectStatusConnected || [MKBLEBaseCentralManager shared].peripheral == nil || [MKBLEBaseCentralManager shared].peripheral.tp_storageData == nil) {
        return NO;
    }
    [[MKBLEBaseCentralManager shared].peripheral setNotifyValue:notify
                                              forCharacteristic:[MKBLEBaseCentralManager shared].peripheral.tp_storageData];
    return YES;
}

- (BOOL)notifyDisconnectType:(BOOL)notify {
    if (self.connectStatus != mk_tp_bleCentralConnectStatusConnected || [MKBLEBaseCentralManager shared].peripheral == nil || [MKBLEBaseCentralManager shared].peripheral.tp_disconnectType == nil) {
        return NO;
    }
    [[MKBLEBaseCentralManager shared].peripheral setNotifyValue:notify
                                              forCharacteristic:[MKBLEBaseCentralManager shared].peripheral.tp_disconnectType];
    return YES;
}

- (void)addTaskWithTaskID:(mk_tp_taskOperationID)operationID
           characteristic:(CBCharacteristic *)characteristic
                 resetNum:(BOOL)resetNum
              commandData:(NSString *)commandData
             successBlock:(void (^)(id returnData))successBlock
             failureBlock:(void (^)(NSError *error))failureBlock {
    MKTPOperation <MKBLEBaseOperationProtocol>*operation = [self generateOperationWithOperationID:operationID
                                                                                   characteristic:characteristic
                                                                                         resetNum:resetNum
                                                                                      commandData:commandData
                                                                                     successBlock:successBlock
                                                                                     failureBlock:failureBlock];
    if (!operation) {
        return;
    }
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

- (void)addReadTaskWithTaskID:(mk_tp_taskOperationID)operationID
               characteristic:(CBCharacteristic *)characteristic
                 successBlock:(void (^)(id returnData))successBlock
                 failureBlock:(void (^)(NSError *error))failureBlock {
    MKTPOperation <MKBLEBaseOperationProtocol>*operation = [self generateReadOperationWithOperationID:operationID
                                                                                       characteristic:characteristic
                                                                                         successBlock:successBlock
                                                                                         failureBlock:failureBlock];
    if (!operation) {
        return;
    }
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

#pragma mark - password method
- (void)connectPeripheral:(CBPeripheral *)peripheral
             successBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    self.sucBlock = nil;
    self.sucBlock = sucBlock;
    self.failedBlock = nil;
    self.failedBlock = failedBlock;
    MKTPPeripheral *trackerPeripheral = [[MKTPPeripheral alloc] initWithPeripheral:peripheral];
    [[MKBLEBaseCentralManager shared] connectDevice:trackerPeripheral sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        [self sendPasswordToDevice];
    } failedBlock:failedBlock];
}

- (void)sendPasswordToDevice {
    NSString *commandData = @"";
    for (NSInteger i = 0; i < self.password.length; i ++) {
        int asciiCode = [self.password characterAtIndex:i];
        commandData = [commandData stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    MKTPOperation *operation = [[MKTPOperation alloc] initOperationWithID:mk_tp_taskConfigPasswordOperation resetNum:NO commandBlock:^{
        [[MKBLEBaseCentralManager shared] sendDataToPeripheral:commandData characteristic:[MKBLEBaseCentralManager shared].peripheral.tp_password type:CBCharacteristicWriteWithResponse];
    } completeBlock:^(NSError * _Nonnull error, mk_tp_taskOperationID operationID, id  _Nonnull returnData) {
        NSDictionary *dataDic = ((NSArray *)returnData[mk_tp_dataInformation])[0];
        if ([dataDic[@"state"] isEqualToString:@"01"]) {
            //密码错误
            [self operationFailedBlockWithMsg:@"Password Error" failedBlock:self.failedBlock];
            return ;
        }
        //密码正确
        MKBLEBase_main_safe(^{
            self.connectStatus = mk_tp_bleCentralConnectStatusConnected;
            [[NSNotificationCenter defaultCenter] postNotificationName:mk_tp_peripheralConnectStateChangedNotification object:nil];
            if (self.sucBlock) {
                self.sucBlock([MKBLEBaseCentralManager shared].peripheral);
            }
        });
    }];
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

#pragma mark - task method
- (MKTPOperation <MKBLEBaseOperationProtocol>*)generateOperationWithOperationID:(mk_tp_taskOperationID)operationID
                                                                 characteristic:(CBCharacteristic *)characteristic
                                                                       resetNum:(BOOL)resetNum
                                                                    commandData:(NSString *)commandData
                                                                   successBlock:(void (^)(id returnData))successBlock
                                                                   failureBlock:(void (^)(NSError *error))failureBlock{
    if (![[MKBLEBaseCentralManager shared] readyToCommunication]) {
        [self operationFailedBlockWithMsg:@"The current connection device is in disconnect" failedBlock:failureBlock];
        return nil;
    }
    if (!MKValidStr(commandData)) {
        [self operationFailedBlockWithMsg:@"The data sent to the device cannot be empty" failedBlock:failureBlock];
        return nil;
    }
    if (!characteristic) {
        [self operationFailedBlockWithMsg:@"Characteristic error" failedBlock:failureBlock];
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    MKTPOperation <MKBLEBaseOperationProtocol>*operation = [[MKTPOperation alloc] initOperationWithID:operationID resetNum:resetNum commandBlock:^{
        [[MKBLEBaseCentralManager shared] sendDataToPeripheral:commandData characteristic:characteristic type:CBCharacteristicWriteWithResponse];
    } completeBlock:^(NSError * _Nonnull error, mk_tp_taskOperationID operationID, id  _Nonnull returnData) {
        __strong typeof(self) sself = weakSelf;
        if (error) {
            MKBLEBase_main_safe(^{
                if (failureBlock) {
                    failureBlock(error);
                }
            });
            return ;
        }
        if (!returnData) {
            [sself operationFailedBlockWithMsg:@"Request data error" failedBlock:failureBlock];
            return ;
        }
        NSString *lev = returnData[mk_tp_dataStatusLev];
        if ([lev isEqualToString:@"1"]) {
            //通用无附加信息的
            NSArray *dataList = (NSArray *)returnData[mk_tp_dataInformation];
            if (!dataList) {
                [sself operationFailedBlockWithMsg:@"Request data error" failedBlock:failureBlock];
                return;
            }
            NSDictionary *resultDic = @{@"msg":@"success",
                                        @"code":@"1",
                                        @"result":(dataList.count == 1 ? dataList[0] : dataList),
                                        };
            MKBLEBase_main_safe(^{
                if (successBlock) {
                    successBlock(resultDic);
                }
            });
            return;
        }
        //对于有附加信息的
        NSDictionary *resultDic = @{@"msg":@"success",
                                    @"code":@"1",
                                    @"result":returnData[mk_tp_dataInformation],
                                    };
        MKBLEBase_main_safe(^{
            if (successBlock) {
                successBlock(resultDic);
            }
        });
    }];
    return operation;
}

- (MKTPOperation <MKBLEBaseOperationProtocol>*)generateReadOperationWithOperationID:(mk_tp_taskOperationID)operationID
                                                                     characteristic:(CBCharacteristic *)characteristic
                                                                       successBlock:(void (^)(id returnData))successBlock
                                                                       failureBlock:(void (^)(NSError *error))failureBlock{
    if (![[MKBLEBaseCentralManager shared] readyToCommunication]) {
        [self operationFailedBlockWithMsg:@"The current connection device is in disconnect" failedBlock:failureBlock];
        return nil;
    }
    if (!characteristic) {
        [self operationFailedBlockWithMsg:@"Characteristic error" failedBlock:failureBlock];
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    MKTPOperation <MKBLEBaseOperationProtocol>*operation = [[MKTPOperation alloc] initOperationWithID:operationID resetNum:NO commandBlock:^{
        [[MKBLEBaseCentralManager shared].peripheral readValueForCharacteristic:characteristic];
    } completeBlock:^(NSError * _Nonnull error, mk_tp_taskOperationID operationID, id  _Nonnull returnData) {
        __strong typeof(self) sself = weakSelf;
        if (error) {
            MKBLEBase_main_safe(^{
                if (failureBlock) {
                    failureBlock(error);
                }
            });
            return ;
        }
        if (!returnData) {
            [sself operationFailedBlockWithMsg:@"Request data error" failedBlock:failureBlock];
            return ;
        }
        NSString *lev = returnData[mk_tp_dataStatusLev];
        if ([lev isEqualToString:@"1"]) {
            //通用无附加信息的
            NSArray *dataList = (NSArray *)returnData[mk_tp_dataInformation];
            if (!dataList) {
                [sself operationFailedBlockWithMsg:@"Request data error" failedBlock:failureBlock];
                return;
            }
            NSDictionary *resultDic = @{@"msg":@"success",
                                        @"code":@"1",
                                        @"result":(dataList.count == 1 ? dataList[0] : dataList),
                                        };
            MKBLEBase_main_safe(^{
                if (successBlock) {
                    successBlock(resultDic);
                }
            });
            return;
        }
        //对于有附加信息的
        NSDictionary *resultDic = @{@"msg":@"success",
                                    @"code":@"1",
                                    @"result":returnData[mk_tp_dataInformation],
                                    };
        MKBLEBase_main_safe(^{
            if (successBlock) {
                successBlock(resultDic);
            }
        });
    }];
    return operation;
}

#pragma mark - private method
- (NSDictionary *)parseModelWith:(NSNumber *)rssi advDic:(NSDictionary *)advDic peripheral:(CBPeripheral *)peripheral {
    if ([rssi integerValue] == 127 || !MKValidDict(advDic) || !peripheral) {
        return @{};
    }
    NSData *data = advDic[@"kCBAdvDataServiceData"][[CBUUID UUIDWithString:@"FF02"]];
    BOOL isPlus = NO;
    if (!MKValidData(data)) {
        //取FF04，如果FF04存在数据，则证明是V2版本的Tracker
        data = advDic[@"kCBAdvDataServiceData"][[CBUUID UUIDWithString:@"FF04"]];
        if (MKValidData(data)) {
            isPlus = YES;
        }
    }
    NSString *dataString = [MKBLEBaseSDKAdopter hexStringFromData:data];
    if (dataString.length != 30) {
        return @{};
    }
    NSString *major = [MKBLEBaseSDKAdopter getDecimalStringWithHex:dataString range:NSMakeRange(0, 4)];
    NSString *minor = [MKBLEBaseSDKAdopter getDecimalStringWithHex:dataString range:NSMakeRange(4, 4)];
    NSNumber *rssi1m = [MKBLEBaseSDKAdopter signedHexTurnString:[dataString substringWithRange:NSMakeRange(8, 2)]];
    NSNumber *txPower = [MKBLEBaseSDKAdopter signedHexTurnString:[dataString substringWithRange:NSMakeRange(10, 2)]];
    
    NSString *distance = [self calcDistByRSSI:[rssi intValue] measurePower:labs([rssi1m integerValue])];
    NSString *proximity = @"Unknown";
    if ([distance doubleValue] <= 0.1) {
        proximity = @"Immediate";
    }else if ([distance doubleValue] > 0.1 && [distance doubleValue] <= 1.f){
        proximity = @"Near";
    }else if ([distance doubleValue] > 1.f){
        proximity = @"Far";
    }
    NSString *state = [MKBLEBaseSDKAdopter binaryByhex:[dataString substringWithRange:NSMakeRange(12, 2)]];
    BOOL connectable = [[state substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"1"];
    BOOL track = [[state substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"1"];
    BOOL isCharging = [[state substringWithRange:NSMakeRange(3, 1)] isEqualToString:@"1"];
    NSString *batteryPercentage = @"";
    NSString *capacityPercentage=  @"";
    NSString *batteryVoltage = @"";
    if (isPlus) {
        //V2版本的Tracker设备
        batteryPercentage = [MKBLEBaseSDKAdopter getDecimalStringWithHex:dataString range:NSMakeRange(14, 2)];
        capacityPercentage = [MKBLEBaseSDKAdopter getDecimalStringWithHex:dataString range:NSMakeRange(16, 2)];
    }else {
        //V1版本的Tracker设备
        batteryVoltage = [MKBLEBaseSDKAdopter getDecimalStringWithHex:dataString range:NSMakeRange(14, 4)];
    }
    NSString *tempMac = [[dataString substringWithRange:NSMakeRange(18, 12)] uppercaseString];
    NSString *macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",
    [tempMac substringWithRange:NSMakeRange(0, 2)],
    [tempMac substringWithRange:NSMakeRange(2, 2)],
    [tempMac substringWithRange:NSMakeRange(4, 2)],
    [tempMac substringWithRange:NSMakeRange(6, 2)],
    [tempMac substringWithRange:NSMakeRange(8, 2)],
    [tempMac substringWithRange:NSMakeRange(10, 2)]];
    return @{
        @"isTrackerPlus":@(isPlus),
        @"rssi":rssi,
        @"peripheral":peripheral,
        @"deviceName":(advDic[CBAdvertisementDataLocalNameKey] ? advDic[CBAdvertisementDataLocalNameKey] : @""),
        @"major":major,
        @"minor":minor,
        @"rssi1m":rssi1m,
        @"txPower":txPower,
        @"proximity":proximity,
        @"connectable":@(connectable),
        @"track":@(track),
        @"isCharging":@(isCharging),
        @"batteryPercentage":batteryPercentage,
        @"capacityPercentage":capacityPercentage,
        @"batteryVoltage":batteryVoltage,
        @"macAddress":macAddress,
    };
}

- (NSString *)calcDistByRSSI:(int)rssi measurePower:(NSInteger)measurePower{
    int iRssi = abs(rssi);
    float power = (iRssi - measurePower) / (10 * 2.0);
    return [NSString stringWithFormat:@"%.2fm",pow(10, power)];
}

- (void)operationFailedBlockWithMsg:(NSString *)message failedBlock:(void (^)(NSError *error))failedBlock {
    NSError *error = [[NSError alloc] initWithDomain:@"com.moko.trackerCentralManager"
                                                code:-999
                                            userInfo:@{@"errorInfo":message}];
    MKBLEBase_main_safe(^{
        if (failedBlock) {
            failedBlock(error);
        }
    });
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
