//
//  MKTPDeviceTypeManager.h
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/24.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;
@interface MKTPDeviceTypeManager : NSObject

/// 设备类型,04:不带3轴和Flash,05:只带3轴,06:只带Flash,07:同时带3轴和Flash
@property (nonatomic, copy, readonly)NSString *deviceType;

/// deviceType为05和07的支持3轴传感器触发设置
@property (nonatomic, assign, readonly)BOOL supportAdvTrigger;

/// 当前连接密码
@property (nonatomic, copy, readonly)NSString *password;

+ (MKTPDeviceTypeManager *)shared;

/// 连接设备
/// @param peripheral peripheral
/// @param password 连接密码
/// @param batteryPercentage 电池电量百分比
/// @param completeBlock 连接结果回调
- (void)connectPeripheral:(CBPeripheral *)peripheral
                 password:(NSString *)password
            completeBlock:(void (^)(NSError *error))completeBlock;

@end

NS_ASSUME_NONNULL_END
