//
//  MKTPFilterOptionsModel.m
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/29.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKTPFilterOptionsModel.h"

#import "MKMacroDefines.h"

#import "MKBLEBaseSDKAdopter.h"

#import "MKTPInterface.h"
#import "MKTPInterface+MKTPConfig.h"

@interface MKTPFilterOptionsModel ()

@property (nonatomic, strong)dispatch_queue_t configQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKTPFilterOptionsModel

- (void)startReadDataWithSucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.configQueue, ^{
        if (![self readStorageRssi]) {
            [self operationFailedBlockWithMsg:@"Read rssi error" block:failedBlock];
            return ;
        }
        if (![self readAdvDataFilterStatus]) {
            [self operationFailedBlockWithMsg:@"Read adv Data filter error" block:failedBlock];
            return ;
        }
        if (![self readMacAddressFilterStatus]) {
            [self operationFailedBlockWithMsg:@"Read mac filter error" block:failedBlock];
            return ;
        }
        if (![self readAdvNameFilterStatus]) {
            [self operationFailedBlockWithMsg:@"Read adv name filter error" block:failedBlock];
            return ;
        }
        if (![self readRawAdvDataStatus]) {
            [self operationFailedBlockWithMsg:@"Read raw adv data filter error" block:failedBlock];
            return ;
        }
        if (![self readProximityUUIDStatus]) {
            [self operationFailedBlockWithMsg:@"Read proximity uuid filter error" block:failedBlock];
            return ;
        }
        if (![self readMajorMinMaxValue]) {
            [self operationFailedBlockWithMsg:@"Read major filter error" block:failedBlock];
            return ;
        }
        if (![self readMinorMinMaxValue]) {
            [self operationFailedBlockWithMsg:@"Read minor filter error" block:failedBlock];
            return ;
        }
        
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

- (void)startConfigDataWithSucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.configQueue, ^{
        if (![self validParams]) {
            [self operationFailedBlockWithMsg:@"Opps！Save failed. Please check the input characters and try again." block:failedBlock];
            return ;
        }
        if (![self configStorageRssi]) {
            [self operationFailedBlockWithMsg:@"Config storage rssi error" block:failedBlock];
            return;
        }
        if (![self configAdvDataFilterStatus]) {
            [self operationFailedBlockWithMsg:@"Config adv data filter error" block:failedBlock];
            return;
        }
        if (![self configMacFilter]) {
            [self operationFailedBlockWithMsg:@"Config mac filter error" block:failedBlock];
            return;
        }
        if (![self configAdvNameFilterStatus]) {
            [self operationFailedBlockWithMsg:@"Config adv name filter error" block:failedBlock];
            return;
        }
        if (![self configRawAdvDataStatus]) {
            [self operationFailedBlockWithMsg:@"Config raw adv data filter error" block:failedBlock];
            return;
        }
        if (![self configProximityUUIDStatus]) {
            [self operationFailedBlockWithMsg:@"Config proximity UUID filter error" block:failedBlock];
            return;
        }
        if (![self configMajorMaxMinValue]) {
            [self operationFailedBlockWithMsg:@"Config major filter error" block:failedBlock];
            return;
        }
        if (![self configMinorMinMaxValue]) {
            [self operationFailedBlockWithMsg:@"Config minor filter error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

#pragma mark - interface
- (BOOL)readStorageRssi {
    __block BOOL success = NO;
    [MKTPInterface tp_readStorageRssiWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.rssiValue = [returnData[@"result"][@"rssi"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configStorageRssi {
    __block BOOL success = NO;
    [MKTPInterface tp_configStorageRssi:self.rssiValue sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readAdvDataFilterStatus {
    __block BOOL success = NO;
    [MKTPInterface tp_readAdvDataFilterStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.advDataFilterIson = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAdvDataFilterStatus {
    __block BOOL success = NO;
    [MKTPInterface tp_configAdvDataFilterStatus:self.advDataFilterIson sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readMacAddressFilterStatus {
    __block BOOL success = NO;
    [MKTPInterface tp_readMacAddressFilterStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.macIson = [returnData[@"result"][@"isOn"] boolValue];
        self.macValue = returnData[@"result"][@"filterMac"];
        self.macWhiteListIson = [returnData[@"result"][@"whiteListIson"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMacFilter {
    __block BOOL success = NO;
    [MKTPInterface tp_configMacFilterStatus:self.macIson whiteList:self.macWhiteListIson mac:self.macValue sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readAdvNameFilterStatus {
    __block BOOL success = NO;
    [MKTPInterface tp_readAdvNameFilterStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.advNameIson = [returnData[@"result"][@"isOn"] boolValue];
        self.advNameValue = returnData[@"result"][@"advName"];
        self.advNameWhiteListIson = [returnData[@"result"][@"whiteListIson"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAdvNameFilterStatus {
    __block BOOL success = NO;
    [MKTPInterface tp_configAdvNameFilterStatus:self.advNameIson whiteList:self.advNameWhiteListIson advName:self.advNameValue sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readProximityUUIDStatus {
    __block BOOL success = NO;
    [MKTPInterface tp_readProximityUUIDFilterStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.uuidIson = [returnData[@"result"][@"isOn"] boolValue];
        self.uuidValue = returnData[@"result"][@"uuid"];
        self.uuidWhiteListIson = [returnData[@"result"][@"whiteListIson"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configProximityUUIDStatus {
    __block BOOL success = NO;
    [MKTPInterface tp_configProximityUUIDFilterStatus:self.uuidIson whiteList:self.uuidWhiteListIson uuid:self.uuidValue sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readRawAdvDataStatus {
    __block BOOL success = NO;
    [MKTPInterface tp_readRawAdvDataFilterStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.rawDataIson = [returnData[@"result"][@"isOn"] boolValue];
        self.rawDataValue = returnData[@"result"][@"rawAdvData"];
        self.rawDataWhiteListIson = [returnData[@"result"][@"whiteListIson"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configRawAdvDataStatus {
    __block BOOL success = NO;
    [MKTPInterface tp_configRawAdvDataFilterStatus:self.rawDataIson whiteList:self.rawDataWhiteListIson rawAdvData:self.rawDataValue sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readMajorMinMaxValue {
    __block BOOL success = NO;
    [MKTPInterface tp_readMajorFilterStateWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.majorIson = [returnData[@"result"][@"isOn"] boolValue];
        self.majorMinValue = returnData[@"result"][@"majorMinValue"];
        self.majorMaxValue = returnData[@"result"][@"majorMaxValue"];
        self.majorWhiteListIson = [returnData[@"result"][@"whiteListIson"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMajorMaxMinValue {
    __block BOOL success = NO;
    [MKTPInterface tp_configMajorFilterStatus:self.majorIson whiteList:self.majorWhiteListIson majorMinValue:[self.majorMinValue integerValue] majorMaxValue:[self.majorMaxValue integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readMinorMinMaxValue {
    __block BOOL success = NO;
    [MKTPInterface tp_readMinorFilterStateWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.minorIson = [returnData[@"result"][@"isOn"] boolValue];
        self.minorMinValue = returnData[@"result"][@"minorMinValue"];
        self.minorMaxValue = returnData[@"result"][@"minorMaxValue"];
        self.minorWhiteListIson = [returnData[@"result"][@"whiteListIson"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMinorMinMaxValue {
    __block BOOL success = NO;
    [MKTPInterface tp_configMinorFilterStatus:self.minorIson whiteList:self.minorWhiteListIson minorMinValue:[self.minorMinValue integerValue] minorMaxValue:[self.minorMaxValue integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - params valid
- (BOOL)validParams {
    if (self.macIson) {
        if (self.macValue.length % 2 != 0 || self.macValue.length == 0 || self.macValue.length > 12) {
            return NO;
        }
    }
    if (self.advNameIson) {
        if (!ValidStr(self.advNameValue) || self.advNameValue.length > 10) {
            return NO;
        }
    }
    if (self.uuidIson) {
        if (![MKBLEBaseSDKAdopter isUUIDString:self.uuidValue]) {
            return NO;
        }
    }
    if (self.rawDataIson) {
        if (!ValidStr(self.rawDataValue) || self.rawDataValue.length > 58) {
            return NO;
        }
    }
    if (self.majorIson) {
        if (!ValidStr(self.majorMaxValue) || [self.majorMaxValue integerValue] < 0 || [self.majorMaxValue integerValue] > 65535) {
            return NO;
        }
        if (!ValidStr(self.majorMinValue) || [self.majorMinValue integerValue] < 0 || [self.majorMinValue integerValue] > 65535) {
            return NO;
        }
        if ([self.majorMaxValue integerValue] < [self.majorMinValue integerValue]) {
            return NO;
        }
    }
    if (self.minorIson) {
        if (!ValidStr(self.minorMaxValue) || [self.minorMaxValue integerValue] < 0 || [self.minorMaxValue integerValue] > 65535) {
            return NO;
        }
        if (!ValidStr(self.minorMinValue) || [self.minorMinValue integerValue] < 0 || [self.minorMinValue integerValue] > 65535) {
            return NO;
        }
        if ([self.minorMaxValue integerValue] < [self.minorMinValue integerValue]) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - private method
- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"advFilterParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":SafeStr(msg)}];
        block(error);
    })
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
        _configQueue = dispatch_queue_create("filterParamsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _configQueue;
}

@end
