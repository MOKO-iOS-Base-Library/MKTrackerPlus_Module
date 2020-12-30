//
//  CBPeripheral+MKTPAdd.h
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/23.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBPeripheral (MKTPAdd)

#pragma mark - Read only

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *tp_batteryPower;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *tp_manufacturer;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *tp_deviceModel;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *tp_productionDate;

@property (nonatomic, strong, readonly)CBCharacteristic *tp_hardware;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *tp_sofeware;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *tp_firmware;

#pragma mark - custom

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *tp_deviceType;

/// R/W
@property (nonatomic, strong, readonly)CBCharacteristic *tp_uuid;

/// R/W
@property (nonatomic, strong, readonly)CBCharacteristic *tp_major;

/// R/W
@property (nonatomic, strong, readonly)CBCharacteristic *tp_minor;

/// R/W
@property (nonatomic, strong, readonly)CBCharacteristic *tp_measuredPower;

/// R/W
@property (nonatomic, strong, readonly)CBCharacteristic *tp_txPower;

/// R/W
@property (nonatomic, strong, readonly)CBCharacteristic *tp_broadcastInterval;

/// R/W
@property (nonatomic, strong, readonly)CBCharacteristic *tp_deviceName;

/// N/W
@property (nonatomic, strong, readonly)CBCharacteristic *tp_password;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *tp_batteryVoltage;

/// R/W
@property (nonatomic, strong, readonly)CBCharacteristic *tp_scanStatus;

/// R/W
@property (nonatomic, strong, readonly)CBCharacteristic *tp_connectable;

/// R/W
@property (nonatomic, strong, readonly)CBCharacteristic *tp_storageReminder;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *tp_disconnectType;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *tp_storageData;

/// W
@property (nonatomic, strong, readonly)CBCharacteristic *tp_reset;

/// N/W
@property (nonatomic, strong, readonly)CBCharacteristic *tp_custom;

- (void)tp_updateCharacterWithService:(CBService *)service;

- (void)tp_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic;

- (BOOL)tp_connectSuccess;

- (void)tp_setNil;

@end

NS_ASSUME_NONNULL_END
