//
//  MKTPDeviceTypeManager.m
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/24.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKTPDeviceTypeManager.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "MKMacroDefines.h"

#import "MKTPSDK.h"

static MKTPDeviceTypeManager *manager = nil;

@interface MKTPConfigDateModel : NSObject<mk_tp_deviceTimeProtocol>

@property (nonatomic, assign)NSInteger year;

@property (nonatomic, assign)NSInteger month;

@property (nonatomic, assign)NSInteger day;

@property (nonatomic, assign)NSInteger hour;

@property (nonatomic, assign)NSInteger minutes;

@property (nonatomic, assign)NSInteger second;

+ (MKTPConfigDateModel *)fetchCurrentTime;

@end

@implementation MKTPConfigDateModel

+ (MKTPConfigDateModel *)fetchTimeModelWithTimeStamp:(NSString *)timeStamp{
    if (!ValidStr(timeStamp)) {
        return nil;
    }
    NSArray *list = [timeStamp componentsSeparatedByString:@"-"];
    if (!ValidArray(list) || list.count != 6) {
        return nil;
    }
    MKTPConfigDateModel *timeModel = [[MKTPConfigDateModel alloc] init];
    timeModel.year = [list[0] integerValue];
    timeModel.month = [list[1] integerValue];
    timeModel.day = [list[2] integerValue];
    timeModel.hour = [list[3] integerValue];
    timeModel.minutes = [list[4] integerValue];
    timeModel.second = [list[5] integerValue];
    return timeModel;
}

+ (MKTPConfigDateModel *)fetchCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    return [self fetchTimeModelWithTimeStamp:dateString];
}

@end

@interface MKTPDeviceTypeManager ()

@property (nonatomic, strong)dispatch_queue_t connectQueue;

@property (nonatomic, strong)dispatch_semaphore_t connectSemaphore;

@property (nonatomic, copy)NSString *deviceType;

@property (nonatomic, assign)BOOL supportAdvTrigger;

@property (nonatomic, copy)NSString *password;

@end

@implementation MKTPDeviceTypeManager

+ (MKTPDeviceTypeManager *)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [MKTPDeviceTypeManager new];
        }
    });
    return manager;
}

- (void)connectPeripheral:(CBPeripheral *)peripheral
                 password:(NSString *)password
            completeBlock:(void (^)(NSError *error))completeBlock {
    [self setDefaultParams];
    dispatch_async(self.connectQueue, ^{
        NSDictionary *dic = [self connectDevice:peripheral password:password];
        if (![dic[@"success"] boolValue]) {
            [self operationFailedMsg:dic[@"msg"] completeBlock:completeBlock];
            return ;
        }
        NSString *deviceType = [self readTrackerType];
        if (![deviceType isEqualToString:@"04"] && ![deviceType isEqualToString:@"05"] && ![deviceType isEqualToString:@"06"] && ![deviceType isEqualToString:@"07"]) {
            [self operationFailedMsg:@"Oops! Something went wrong. Please check the device version or contact MOKO." completeBlock:completeBlock];
            return ;
        }
        self.deviceType = deviceType;
        self.supportAdvTrigger = ([deviceType isEqualToString:@"05"] || [deviceType isEqualToString:@"07"]);
        if (![self configDate]) {
            [self operationFailedMsg:@"Config date error" completeBlock:completeBlock];
            return;
        }
        self.password = password;
        moko_dispatch_main_safe(^{
            if (completeBlock) {
                completeBlock(nil);
            }
        });
    });
}

#pragma mark - interface
- (NSDictionary *)connectDevice:(CBPeripheral *)peripheral password:(NSString *)password {
    __block NSDictionary *connectResult = @{};
    [[MKTPCentralManager shared] connectPeripheral:peripheral password:password sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        connectResult = @{
            @"success":@(YES),
        };
        dispatch_semaphore_signal(self.connectSemaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        connectResult = @{
            @"success":@(NO),
            @"msg":SafeStr(error.userInfo[@"errorInfo"]),
        };
        dispatch_semaphore_signal(self.connectSemaphore);
    }];
    dispatch_semaphore_wait(self.connectSemaphore, DISPATCH_TIME_FOREVER);
    return connectResult;
}

- (NSString *)readTrackerType {
    __block NSString *type = @"";
    [MKTPInterface tp_readTrackerDeviceTypeWithSucBlock:^(id  _Nonnull returnData) {
        type = returnData[@"result"][@"deviceType"];
        dispatch_semaphore_signal(self.connectSemaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.connectSemaphore);
    }];
    dispatch_semaphore_wait(self.connectSemaphore, DISPATCH_TIME_FOREVER);
    return type;
}

- (BOOL)configDate {
    __block BOOL success = NO;
    MKTPConfigDateModel *dateModel = [MKTPConfigDateModel fetchCurrentTime];
    [MKTPInterface tp_configDeviceTime:dateModel sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.connectSemaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.connectSemaphore);
    }];
    dispatch_semaphore_wait(self.connectSemaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
- (void)setDefaultParams {
    self.deviceType = @"";
    self.supportAdvTrigger = NO;
}

- (void)operationFailedMsg:(NSString *)msg completeBlock:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        [self setDefaultParams];
        [[MKTPCentralManager shared] disconnect];
        if (block) {
            NSError *error = [[NSError alloc] initWithDomain:@"connectDevice"
                                                        code:-999
                                                    userInfo:@{@"errorInfo":SafeStr(msg)}];
            block(error);
        }
    });
}

#pragma mark - getter
- (dispatch_queue_t)connectQueue {
    if (!_connectQueue) {
        _connectQueue = dispatch_queue_create("com.moko.connectQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _connectQueue;
}

- (dispatch_semaphore_t)connectSemaphore {
    if (!_connectSemaphore) {
        _connectSemaphore = dispatch_semaphore_create(0);
    }
    return _connectSemaphore;
}

@end
