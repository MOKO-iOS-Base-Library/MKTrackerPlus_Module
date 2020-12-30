//
//  MKTPSettingDataModel.m
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/29.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKTPSettingDataModel.h"

#import "MKMacroDefines.h"

#import "MKTPInterface.h"

@interface MKTPSettingDataModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKTPSettingDataModel

- (void)startReadDataWithSucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readButtonOffStatus]) {
            [self operationFailedBlockWithMsg:@"Read button off status error!" block:failedBlock];
            return;
        }
        if (![self readConnectableStatus]) {
            [self operationFailedBlockWithMsg:@"Read connectable status error!" block:failedBlock];
            return;
        }
        if (![self readConnectableNoteStatus]) {
            [self operationFailedBlockWithMsg:@"Read connectable notes status error!" block:failedBlock];
            return;
        }
        if (![self readButtonResetStatus]) {
            [self operationFailedBlockWithMsg:@"Read button reset status error!" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

#pragma mark - interface
- (BOOL)readButtonOffStatus {
    __block BOOL success = NO;
    [MKTPInterface tp_readButtonPowerWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.buttonOffIsOn = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readConnectableStatus {
    __block BOOL success = NO;
    [MKTPInterface tp_readConnectableWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.connectable = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readConnectableNoteStatus {
    __block BOOL success = NO;
    [MKTPInterface tp_readConnectionNotificationStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.connectableNoteIsOn = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readButtonResetStatus {
    __block BOOL success = NO;
    [MKTPInterface tp_readButtonResetStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.buttonResetIsOn = [returnData[@"result"][@"isOn"] boolValue];
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
        NSError *error = [[NSError alloc] initWithDomain:@"settingParams"
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

- (dispatch_queue_t)readQueue {
    if (!_readQueue) {
        _readQueue = dispatch_queue_create("settingParamsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end

