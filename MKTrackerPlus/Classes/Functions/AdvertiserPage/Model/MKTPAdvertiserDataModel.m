//
//  MKTPAdvertiserDataModel.m
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/26.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKTPAdvertiserDataModel.h"

#import "MKMacroDefines.h"

#import "MKTPInterface.h"
#import "MKTPInterface+MKTPConfig.h"

#import "MKTPDeviceTypeManager.h"

@interface MKTPAdvertiserDataModel ()

@property (nonatomic, strong)dispatch_queue_t configQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKTPAdvertiserDataModel

- (void)startReadWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.configQueue, ^{
        if (![self readDeviceName]) {
            [self operationFailedBlockWithMsg:@"Read device name error" block:failedBlock];
            return ;
        }
        if (![self readUUID]) {
            [self operationFailedBlockWithMsg:@"Read proximity uuid error" block:failedBlock];
            return ;
        }
        if (![self readMajor]) {
            [self operationFailedBlockWithMsg:@"Read major error" block:failedBlock];
            return ;
        }
        if (![self readMinor]) {
            [self operationFailedBlockWithMsg:@"Read minor error" block:failedBlock];
            return ;
        }
        if (![self readInterval]) {
            [self operationFailedBlockWithMsg:@"Read interval error" block:failedBlock];
            return ;
        }
        if (![self readMeasurePower]) {
            [self operationFailedBlockWithMsg:@"Read measure power error" block:failedBlock];
            return ;
        }
        if (![self readTxPower]) {
            [self operationFailedBlockWithMsg:@"Read txPower error" block:failedBlock];
            return ;
        }
        if ([MKTPDeviceTypeManager shared].supportAdvTrigger) {
            if (![self readADVTriggerConditions]) {
                [self operationFailedBlockWithMsg:@"Read conditions error" block:failedBlock];
                return ;
            }
        }
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

- (void)startConfigWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.configQueue, ^{
        if (![self configDeviceName:self.deviceName]) {
            [self operationFailedBlockWithMsg:@"Config device name error" block:failedBlock];
            return ;
        }
        if (![self configUUID:self.proximityUUID]) {
            [self operationFailedBlockWithMsg:@"Config proximityUUID error" block:failedBlock];
            return ;
        }
        if (![self configMajor:[self.major integerValue]]) {
            [self operationFailedBlockWithMsg:@"Config major error" block:failedBlock];
            return ;
        }
        if (![self configMinor:[self.minor integerValue]]) {
            [self operationFailedBlockWithMsg:@"Config minor error" block:failedBlock];
            return ;
        }
        if (![self configInterval:[self.interval integerValue]]) {
            [self operationFailedBlockWithMsg:@"Config interval error" block:failedBlock];
            return ;
        }
        if (![self configMeasurePower:[self.measurePower integerValue]]) {
            [self operationFailedBlockWithMsg:@"Config measurePower error" block:failedBlock];
            return ;
        }
        if (![self configTxPower:self.txPower]) {
            [self operationFailedBlockWithMsg:@"Config Tx Power error" block:failedBlock];
            return ;
        }
        if ([MKTPDeviceTypeManager shared].supportAdvTrigger) {
            if (!self.advTriggerIsOn) {
                //关闭
                if (![self closeTriggerConditions]) {
                    [self operationFailedBlockWithMsg:@"Config trigger conditions error" block:failedBlock];
                    return ;
                }
            }else {
                //打开
                if (![self configTriggerConditions:[self.advTriggerTime integerValue]]) {
                    [self operationFailedBlockWithMsg:@"Config trigger conditions error" block:failedBlock];
                    return ;
                }
            }
        }
        
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

#pragma mark - interface
- (BOOL)readDeviceName {
    __block BOOL success = NO;
    [MKTPInterface tp_readAdvNameWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.deviceName = returnData[@"result"][@"deviceName"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configDeviceName:(NSString *)deviceName {
    __block BOOL success = NO;
    [MKTPInterface tp_configDeviceName:deviceName sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readUUID {
    __block BOOL success = NO;
    [MKTPInterface tp_readProximityUUIDWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.proximityUUID = returnData[@"result"][@"uuid"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configUUID:(NSString *)uuid {
    __block BOOL success = NO;
    [MKTPInterface tp_configProximityUUID:uuid sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readMajor {
    __block BOOL success = NO;
    [MKTPInterface tp_readMajorWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.major = returnData[@"result"][@"major"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMajor:(NSInteger)major {
    __block BOOL success = NO;
    [MKTPInterface tp_configMajor:major sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readMinor {
    __block BOOL success = NO;
    [MKTPInterface tp_readMinorWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.minor = returnData[@"result"][@"minor"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMinor:(NSInteger)minor {
    __block BOOL success = NO;
    [MKTPInterface tp_configMinor:minor sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readInterval {
    __block BOOL success = NO;
    [MKTPInterface tp_readAdvIntervalWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.interval = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configInterval:(NSInteger)interval {
    __block BOOL success = NO;
    [MKTPInterface tp_configAdvInterval:interval sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readMeasurePower {
    __block BOOL success = NO;
    [MKTPInterface tp_readMeasurePowerWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.measurePower = returnData[@"result"][@"measuredPower"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMeasurePower:(NSInteger)measurePower {
    __block BOOL success = NO;
    [MKTPInterface tp_configMeasuredPower:measurePower sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readTxPower {
    __block BOOL success = NO;
    [MKTPInterface tp_readTxPowerWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.txPower = [self fetchTxPowerWithString:returnData[@"result"][@"txPower"]];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTxPower:(NSInteger)txPower {
    __block BOOL success = NO;
    [MKTPInterface tp_configTxPower:[self fetchTxPowerValue:txPower] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readADVTriggerConditions {
    __block BOOL success = NO;
    [MKTPInterface tp_readADVTriggerConditionsWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.advTriggerTime = returnData[@"result"][@"conditions"][@"time"];
        self.advTriggerIsOn = [returnData[@"result"][@"conditions"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)closeTriggerConditions {
    __block BOOL success = NO;
    [MKTPInterface tp_closeAdvTriggerConditionsWithSucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTriggerConditions:(NSInteger)time {
    __block BOOL success = NO;
    [MKTPInterface tp_configAdvTrigger:time sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"advertisingParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":SafeStr(msg)}];
        block(error);
    })
}

- (NSInteger)fetchTxPowerWithString:(NSString *)string {
    if ([string isEqualToString:@"-40dBm"]) {
        return 0;
    }
    if ([string isEqualToString:@"-20dBm"]) {
        return 1;
    }
    if ([string isEqualToString:@"-16dBm"]) {
        return 2;
    }
    if ([string isEqualToString:@"-12dBm"]) {
        return 3;
    }
    if ([string isEqualToString:@"-8dBm"]) {
        return 4;
    }
    if ([string isEqualToString:@"-4dBm"]) {
        return 5;
    }
    if ([string isEqualToString:@"0dBm"]) {
        return 6;
    }
    if ([string isEqualToString:@"3dBm"]) {
        return 7;
    }
    if ([string isEqualToString:@"4dBm"]) {
        return 8;
    }
    return 5;
}

- (mk_tp_txPower)fetchTxPowerValue:(NSInteger)txPower {
    if (txPower == 0) {
        return mk_tp_txPowerNeg40dBm;
    }
    if (txPower == 1) {
        return mk_tp_txPowerNeg20dBm;
    }
    if (txPower == 2) {
        return mk_tp_txPowerNeg16dBm;
    }
    if (txPower == 3) {
        return mk_tp_txPowerNeg12dBm;
    }
    if (txPower == 4) {
        return mk_tp_txPowerNeg8dBm;
    }
    if (txPower == 5) {
        return mk_tp_txPowerNeg4dBm;
    }
    if (txPower == 6) {
        return mk_tp_txPower0dBm;
    }
    if (txPower == 7) {
        return mk_tp_txPower3dBm;
    }
    if (txPower == 8) {
        return mk_tp_txPower4dBm;
    }
    return mk_tp_txPowerNeg4dBm;
}

#pragma mark - getter
- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

- (dispatch_queue_t)configQueue {
    if (!_configQueue) {
        _configQueue = dispatch_queue_create("deviceInfoReadParamsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _configQueue;
}

@end
