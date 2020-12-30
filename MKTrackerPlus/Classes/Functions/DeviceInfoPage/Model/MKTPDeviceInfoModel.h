//
//  MKTPDeviceInfoModel.h
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/26.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKTPDeviceInfoModel : NSObject

/**
 电池电压
 */
@property (nonatomic, copy)NSString *batteryVoltage;

/// 电池电量
@property (nonatomic, copy)NSString *batteryPower;

/**
 mac地址
 */
@property (nonatomic, copy)NSString *macAddress;

/**
 产品型号
 */
@property (nonatomic, copy)NSString *deviceModel;

/**
 软件版本
 */
@property (nonatomic, copy)NSString *software;

/**
 固件版本
 */
@property (nonatomic, copy)NSString *firmware;

/**
 硬件版本
 */
@property (nonatomic, copy)NSString *hardware;

/**
 生产日期
 */
@property (nonatomic, copy)NSString *manuDate;

/**
 厂商信息
 */
@property (nonatomic, copy)NSString *manu;

/// 开始读取设备信息
/// @param onlyVoltage 是否只读取电池电压
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
- (void)startLoadSystemInformation:(BOOL)onlyVoltage
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
