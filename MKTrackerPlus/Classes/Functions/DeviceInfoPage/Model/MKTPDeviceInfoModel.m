//
//  MKTPDeviceInfoModel.m
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/26.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKTPDeviceInfoModel.h"

#import "MKMacroDefines.h"

#import "MKTPInterface.h"
#import "MKTPInterface+MKTPConfig.h"

@interface MKTPDeviceInfoModel ()

@property (nonatomic, strong)dispatch_queue_t configQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKTPDeviceInfoModel

- (void)startLoadSystemInformation:(BOOL)onlyVoltage
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.configQueue, ^{
        if (![self readBattery]) {
            [self operationFailedBlockWithMsg:@"Read battery error" block:failedBlock];
            return ;
        }
        if (![self readBatteryPower]) {
            [self operationFailedBlockWithMsg:@"Read battery power error" block:failedBlock];
            return ;
        }
        if (onlyVoltage) {
            moko_dispatch_main_safe(^{
                sucBlock();
            });
            return;
        }
        if (![self readMacAddress]) {
            [self operationFailedBlockWithMsg:@"Read mac address error" block:failedBlock];
            return ;
        }
        if (![self readDeviceModel]) {
            [self operationFailedBlockWithMsg:@"Read device model error" block:failedBlock];
            return ;
        }
        if (![self readSoftware]) {
            [self operationFailedBlockWithMsg:@"Read software error" block:failedBlock];
            return ;
        }
        if (![self readHardware]) {
            [self operationFailedBlockWithMsg:@"Read hardware error" block:failedBlock];
            return ;
        }
        if (![self readFirmware]) {
            [self operationFailedBlockWithMsg:@"Read firmware error" block:failedBlock];
            return ;
        }
        if (![self readManuDate]) {
            [self operationFailedBlockWithMsg:@"Read manu date error" block:failedBlock];
            return ;
        }
        if (![self readManu]) {
            [self operationFailedBlockWithMsg:@"Read manu error" block:failedBlock];
            return ;
        }
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

#pragma mark - interface
- (BOOL)readBattery {
    __block BOOL success = NO;
    [MKTPInterface tp_readBatteryVoltageWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.batteryVoltage = returnData[@"result"][@"batteryVoltage"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readBatteryPower {
    __block BOOL success = NO;
    [MKTPInterface tp_readBatteryPowerWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.batteryPower = returnData[@"result"][@"batteryPower"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readMacAddress {
    __block BOOL success = NO;
    [MKTPInterface tp_readMacAddressWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.macAddress = returnData[@"result"][@"macAddress"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readDeviceModel {
    __block BOOL success = NO;
    [MKTPInterface tp_readDeviceModelWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.deviceModel = returnData[@"result"][@"modeID"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readSoftware {
    __block BOOL success = NO;
    [MKTPInterface tp_readSoftwareWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.software = returnData[@"result"][@"software"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readFirmware {
    __block BOOL success = NO;
    [MKTPInterface tp_readFirmwareWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        NSArray *firmwareList = [returnData[@"result"][@"firmware"] componentsSeparatedByString:@"-"];
        NSMutableArray *tempList = [NSMutableArray array];
        for (NSInteger i = 0; i < firmwareList.count; i ++) {
            if (i != 0) {
                [tempList addObject:firmwareList[i]];
            }
        }
        NSString *tempString = @"";
        for (NSInteger i = 0; i < tempList.count; i ++) {
            tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"-%@",tempList[i]]];
        }
        self.firmware = [tempString substringFromIndex:1];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readHardware {
    __block BOOL success = NO;
    [MKTPInterface tp_readHardwareWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.hardware = returnData[@"result"][@"hardware"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readManuDate {
    __block BOOL success = NO;
    [MKTPInterface tp_readProductionDateWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.manuDate = returnData[@"result"][@"productionDate"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readManu {
    __block BOOL success = NO;
    [MKTPInterface tp_readManufacturerWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.manu = returnData[@"result"][@"manufacturer"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"deviceInformation"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    });
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
        _configQueue = dispatch_queue_create("deviceInfoParamsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _configQueue;
}

@end
