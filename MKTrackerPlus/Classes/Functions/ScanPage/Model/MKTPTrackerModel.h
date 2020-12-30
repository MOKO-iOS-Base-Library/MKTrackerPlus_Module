//
//  MKTPTrackerModel.h
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/24.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;
@interface MKTPTrackerModel : NSObject

@property (nonatomic, assign)BOOL isTrackerPlus;

@property (nonatomic, strong)CBPeripheral *peripheral;

/// Current rssi of the device
@property (nonatomic, assign)NSInteger rssi;

/// Device name
@property (nonatomic, copy)NSString *deviceName;

@property (nonatomic, assign)NSInteger major;

@property (nonatomic, assign)NSInteger minor;

/// RSSI@1m
@property (nonatomic, assign)NSInteger rssi1m;

@property (nonatomic, assign)NSInteger txPower;

/// Battery voltage in mV.
/// Note:isTrackerPlus = NO;
@property (nonatomic, assign)NSInteger batteryVoltage;

/// Battery charge percentage.
/// Note:isTrackerPlus = YES;
@property (nonatomic, assign)NSInteger batteryPercentage;

/// Percentage of Capacity.
/// Note:isTrackerPlus = YES;
@property (nonatomic, assign)NSInteger capacityPercentage;

/// mac address
@property (nonatomic, copy)NSString *macAddress;

/// Whether the current device can be connected.
@property (nonatomic, assign)BOOL connectable;

/// Whether the device's scanning function is turned on.
@property (nonatomic, assign)BOOL track;

/// Whether the device is charging.
@property (nonatomic, assign)BOOL isCharging;

/// Far and near information, immediate (within 10cm), near (within 1m), far (within 1m), unknown (no signal)
@property (nonatomic, copy)NSString *proximity;

/// cell上面显示的时间
@property (nonatomic, copy)NSString *scanTime;

/**
 上一次扫描到的时间
 */
@property (nonatomic, copy)NSString *lastScanDate;

/**
 当前model所在的row
 */
@property (nonatomic, assign)NSInteger index;

@end

NS_ASSUME_NONNULL_END
