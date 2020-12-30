//
//  CBPeripheral+MKTPAdd.m
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/23.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "CBPeripheral+MKTPAdd.h"

#import <objc/runtime.h>

#import "MKTPSDKDefines.h"

static const char *tp_batteryPowerKey = "tp_batteryPowerKey";
static const char *tp_manufacturerKey = "tp_manufacturerKey";
static const char *tp_deviceModelKey = "tp_deviceModelKey";
static const char *tp_productionDateKey = "tp_productionDateKey";
static const char *tp_hardwareKey = "tp_hardwareKey";
static const char *tp_softwareKey = "tp_softwareKey";
static const char *tp_firmwareKey = "tp_firmwareKey";

static const char *tp_deviceTypeKey = "tp_deviceTypeKey";
static const char *tp_uuidKey = "tp_uuidKey";
static const char *tp_majorKey = "tp_majorKey";
static const char *tp_minorKey = "tp_minorKey";
static const char *tp_measuredPowerKey = "tp_measuredPowerKey";
static const char *tp_txPowerKey = "tp_txPowerKey";
static const char *tp_broadcastIntervalKey = "tp_broadcastIntervalKey";
static const char *tp_deviceNameKey = "tp_deviceNameKey";
static const char *tp_passwordKey = "tp_passwordKey";
static const char *tp_batteryVoltageKey = "tp_batteryVoltageKey";
static const char *tp_scanStatusKey = "tp_scanStatusKey";
static const char *tp_connectableKey = "";
static const char *tp_storageReminderKey = "tp_storageReminderKey";
static const char *tp_disconnectTypeKey = "tp_disconnectTypeKey";
static const char *tp_storageDataKey = "tp_storageDataKey";
static const char *tp_resetKey = "tp_resetKey";
static const char *tp_customKey = "tp_customKey";

static const char *tp_passwordNotifySuccessKey = "tp_passwordNotifySuccessKey";
static const char *tp_customNotifySuccessKey = "tp_customNotifySuccessKey";

@implementation CBPeripheral (MKTracker)

/*
 
 */

#pragma mark - public method
- (void)tp_updateCharacterWithService:(CBService *)service {
    NSArray *characteristicList = service.characteristics;
    if ([service.UUID isEqual:MKUUID(@"180F")]) {
        //电池电量
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:MKUUID(@"2A19")]) {
                objc_setAssociatedObject(self, &tp_batteryPowerKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                break;
            }
        }
        return;
    }
    if ([service.UUID isEqual:MKUUID(@"180A")]) {
        //设备信息
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:MKUUID(@"2A24")]) {
                objc_setAssociatedObject(self, &tp_deviceModelKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"2A25")]) {
                objc_setAssociatedObject(self, &tp_productionDateKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"2A26")]) {
                objc_setAssociatedObject(self, &tp_firmwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"2A27")]) {
                objc_setAssociatedObject(self, &tp_hardwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"2A28")]) {
                objc_setAssociatedObject(self, &tp_softwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"2A29")]) {
                objc_setAssociatedObject(self, &tp_manufacturerKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return;
    }
    if ([service.UUID isEqual:MKUUID(@"FF00")]) {
        //自定义服务
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:MKUUID(@"FF00")]) {
                objc_setAssociatedObject(self, &tp_deviceTypeKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF01")]) {
                objc_setAssociatedObject(self, &tp_uuidKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF02")]) {
                objc_setAssociatedObject(self, &tp_majorKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF03")]) {
                objc_setAssociatedObject(self, &tp_minorKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF04")]) {
                objc_setAssociatedObject(self, &tp_measuredPowerKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF05")]) {
                objc_setAssociatedObject(self, &tp_txPowerKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF06")]) {
                objc_setAssociatedObject(self, &tp_broadcastIntervalKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF07")]) {
                objc_setAssociatedObject(self, &tp_deviceNameKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF08")]) {
                objc_setAssociatedObject(self, &tp_passwordKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [self setNotifyValue:YES forCharacteristic:characteristic];
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF09")]) {
                objc_setAssociatedObject(self, &tp_batteryVoltageKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF0A")]) {
                objc_setAssociatedObject(self, &tp_scanStatusKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF0B")]) {
                objc_setAssociatedObject(self, &tp_connectableKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF0C")]) {
                objc_setAssociatedObject(self, &tp_storageReminderKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF0D")]) {
                objc_setAssociatedObject(self, &tp_disconnectTypeKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF0E")]) {
                objc_setAssociatedObject(self, &tp_storageDataKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF0F")]) {
                objc_setAssociatedObject(self, &tp_resetKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF10")]) {
                objc_setAssociatedObject(self, &tp_customKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [self setNotifyValue:YES forCharacteristic:characteristic];
            }
        }
        return;
    }
}

- (void)tp_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic {
    if ([characteristic.UUID isEqual:MKUUID(@"FF08")]) {
        objc_setAssociatedObject(self, &tp_passwordNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF10")]) {
        objc_setAssociatedObject(self, &tp_customNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
}

- (BOOL)tp_connectSuccess {
    if (![objc_getAssociatedObject(self, &tp_customNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &tp_passwordNotifySuccessKey) boolValue]) {
        return NO;
    }
    if (!self.tp_batteryPower || !self.tp_manufacturer || !self.tp_deviceModel
        || !self.tp_productionDate || !self.tp_hardware || !self.tp_sofeware || !self.tp_firmware) {
        return NO;
    }
    if (!self.tp_deviceType || !self.tp_uuid || !self.tp_major || !self.tp_minor || !self.tp_measuredPower || !self.tp_broadcastInterval || !self.tp_deviceName || !self.tp_password || !self.tp_batteryVoltage || !self.tp_scanStatus || !self.tp_storageReminder || !self.tp_disconnectType || !self.tp_storageData || !self.tp_reset || !self.tp_custom) {
        return NO;
    }
    return YES;
}

- (void)tp_setNil {
    objc_setAssociatedObject(self, &tp_batteryPowerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &tp_manufacturerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &tp_deviceModelKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &tp_productionDateKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &tp_hardwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &tp_softwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &tp_firmwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &tp_deviceTypeKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &tp_uuidKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &tp_majorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &tp_minorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &tp_measuredPowerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &tp_broadcastIntervalKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &tp_deviceNameKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &tp_passwordKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &tp_batteryVoltageKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &tp_scanStatusKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &tp_storageReminderKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &tp_disconnectTypeKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &tp_storageDataKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &tp_resetKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &tp_customKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &tp_passwordNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &tp_customNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter

- (CBCharacteristic *)tp_batteryPower {
    return objc_getAssociatedObject(self, &tp_batteryPowerKey);
}

- (CBCharacteristic *)tp_manufacturer {
    return objc_getAssociatedObject(self, &tp_manufacturerKey);
}

- (CBCharacteristic *)tp_deviceModel {
    return objc_getAssociatedObject(self, &tp_deviceModelKey);
}

- (CBCharacteristic *)tp_productionDate {
    return objc_getAssociatedObject(self, &tp_productionDateKey);
}

- (CBCharacteristic *)tp_hardware {
    return objc_getAssociatedObject(self, &tp_hardwareKey);
}

- (CBCharacteristic *)tp_sofeware {
    return objc_getAssociatedObject(self, &tp_softwareKey);
}

- (CBCharacteristic *)tp_firmware {
    return objc_getAssociatedObject(self, &tp_firmwareKey);
}

- (CBCharacteristic *)tp_deviceType {
    return objc_getAssociatedObject(self, &tp_deviceTypeKey);
}

- (CBCharacteristic *)tp_uuid {
    return objc_getAssociatedObject(self, &tp_uuidKey);
}

- (CBCharacteristic *)tp_major {
    return objc_getAssociatedObject(self, &tp_majorKey);
}

- (CBCharacteristic *)tp_minor {
    return objc_getAssociatedObject(self, &tp_minorKey);
}

- (CBCharacteristic *)tp_measuredPower {
    return objc_getAssociatedObject(self, &tp_measuredPowerKey);
}

- (CBCharacteristic *)tp_txPower {
    return objc_getAssociatedObject(self, &tp_txPowerKey);
}

- (CBCharacteristic *)tp_broadcastInterval {
    return objc_getAssociatedObject(self, &tp_broadcastIntervalKey);
}

- (CBCharacteristic *)tp_deviceName {
    return objc_getAssociatedObject(self, &tp_deviceNameKey);
}

- (CBCharacteristic *)tp_password {
    return objc_getAssociatedObject(self, &tp_passwordKey);
}

- (CBCharacteristic *)tp_batteryVoltage {
    return objc_getAssociatedObject(self, &tp_batteryVoltageKey);
}

- (CBCharacteristic *)tp_scanStatus {
    return objc_getAssociatedObject(self, &tp_scanStatusKey);
}

- (CBCharacteristic *)tp_connectable {
    return objc_getAssociatedObject(self, &tp_connectableKey);
}

- (CBCharacteristic *)tp_storageReminder {
    return objc_getAssociatedObject(self, &tp_storageReminderKey);
}

- (CBCharacteristic *)tp_disconnectType {
    return objc_getAssociatedObject(self, &tp_disconnectTypeKey);
}

- (CBCharacteristic *)tp_storageData {
    return objc_getAssociatedObject(self, &tp_storageDataKey);
}

- (CBCharacteristic *)tp_reset {
    return objc_getAssociatedObject(self, &tp_resetKey);
}

- (CBCharacteristic *)tp_custom {
    return objc_getAssociatedObject(self, &tp_customKey);
}

@end
