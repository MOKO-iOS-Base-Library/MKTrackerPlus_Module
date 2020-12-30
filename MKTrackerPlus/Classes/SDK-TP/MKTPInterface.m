//
//  MKTPInterface.m
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/24.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKTPInterface.h"

#import "MKTPCentralManager.h"

#import "MKTPOperation.h"
#import "MKTPAdopter.h"
#import "CBPeripheral+MKTPAdd.h"
#import "MKTPOperationID.h"

#define centralManager [MKTPCentralManager shared]

@implementation MKTPInterface

+ (void)tp_readBatteryPowerWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                            failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_tp_taskReadBatteryPowerOperation
                           characteristic:centralManager.peripheral.tp_batteryPower
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)tp_readDeviceModelWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                           failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_tp_taskReadDeviceModelOperation
                           characteristic:centralManager.peripheral.tp_deviceModel
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)tp_readProductionDateWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                              failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_tp_taskReadProductionDateOperation
                           characteristic:centralManager.peripheral.tp_productionDate
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)tp_readFirmwareWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                        failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_tp_taskReadFirmwareOperation
                           characteristic:centralManager.peripheral.tp_firmware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)tp_readHardwareWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                        failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_tp_taskReadHardwareOperation
                           characteristic:centralManager.peripheral.tp_hardware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)tp_readSoftwareWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                        failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_tp_taskReadSoftwareOperation
                           characteristic:centralManager.peripheral.tp_sofeware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)tp_readManufacturerWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                            failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_tp_taskReadManufacturerOperation
                           characteristic:centralManager.peripheral.tp_manufacturer
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)tp_readTrackerDeviceTypeWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                 failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_tp_taskReadDeviceTypeOperation
                           characteristic:centralManager.peripheral.tp_deviceType
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)tp_readProximityUUIDWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                             failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_tp_taskReadProximityUUIDOperation
                           characteristic:centralManager.peripheral.tp_uuid
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)tp_readMajorWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                     failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_tp_taskReadMajorOperation
                           characteristic:centralManager.peripheral.tp_major
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)tp_readMinorWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                     failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_tp_taskReadMinorOperation
                           characteristic:centralManager.peripheral.tp_minor
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)tp_readMeasurePowerWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                            failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_tp_taskReadMeasuredPowerOperation
                           characteristic:centralManager.peripheral.tp_measuredPower
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)tp_readTxPowerWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                       failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_tp_taskReadTxPowerOperation
                           characteristic:centralManager.peripheral.tp_txPower
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)tp_readAdvIntervalWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                           failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_tp_taskReadBroadcastIntervalOperation
                           characteristic:centralManager.peripheral.tp_broadcastInterval
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)tp_readAdvNameWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                       failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_tp_taskReadDeviceNameOperation
                           characteristic:centralManager.peripheral.tp_deviceName
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)tp_readBatteryVoltageWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                              failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_tp_taskReadBatteryVoltageOperation
                           characteristic:centralManager.peripheral.tp_batteryVoltage
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)tp_readScanStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                          failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_tp_taskReadScanStatusOperation
                           characteristic:centralManager.peripheral.tp_scanStatus
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)tp_readConnectableWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                           failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_tp_taskReadConnectableStatusOperation
                           characteristic:centralManager.peripheral.tp_connectable
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)tp_readTrackingNotificationWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                    failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_tp_taskReadStorageReminderOperation
                           characteristic:centralManager.peripheral.tp_storageReminder
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

#pragma mark - 自定义FF10特征API

+ (void)tp_readMacAddressWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                          failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_tp_taskReadMacAddressOperation
                       characteristic:centralManager.peripheral.tp_custom
                             resetNum:NO
                          commandData:@"ea200000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)tp_readADVTriggerConditionsWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                    failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_tp_taskReadADVTriggerConditionsOperation
                       characteristic:centralManager.peripheral.tp_custom
                             resetNum:NO
                          commandData:@"ea210000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)tp_readScanningTriggerConditionsWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                         failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_tp_taskReadScanningTriggerConditionsOperation
                       characteristic:centralManager.peripheral.tp_custom
                             resetNum:NO
                          commandData:@"ea220000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)tp_readStorageRssiWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                           failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_tp_taskReadStorageRssiOperation
                       characteristic:centralManager.peripheral.tp_custom
                             resetNum:NO
                          commandData:@"ea230000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)tp_readStorageIntervalWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                               failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_tp_taskReadStorageIntervalOperation
                       characteristic:centralManager.peripheral.tp_custom
                             resetNum:NO
                          commandData:@"ea240000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)tp_readButtonPowerWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                           failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_tp_taskReadButtonPowerStatusOperation
                       characteristic:centralManager.peripheral.tp_custom
                             resetNum:NO
                          commandData:@"ea280000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)tp_readMovementSensitivityWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                   failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_tp_taskReadMovementSensitivityOperation
                       characteristic:centralManager.peripheral.tp_custom
                             resetNum:NO
                          commandData:@"ea400000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)tp_readMacAddressFilterStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                      failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_tp_taskReadMacFilterStatusOperation
                       characteristic:centralManager.peripheral.tp_custom
                             resetNum:NO
                          commandData:@"ea410000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)tp_readAdvNameFilterStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                   failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_tp_taskReadAdvNameFilterStatusOperation
                       characteristic:centralManager.peripheral.tp_custom
                             resetNum:NO
                          commandData:@"ea420000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)tp_readRawAdvDataFilterStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                      failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_tp_taskReadRawAdvDataFilterStatusOperation
                       characteristic:centralManager.peripheral.tp_custom
                             resetNum:NO
                          commandData:@"ea430000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)tp_readAdvDataFilterStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                   failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_tp_taskReadAdvDataFilterStatusOperation
                       characteristic:centralManager.peripheral.tp_custom
                             resetNum:NO
                          commandData:@"ea460000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)tp_readProximityUUIDFilterStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                         failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_tp_taskReadProximityUUIDFilterStatusOperation
                       characteristic:centralManager.peripheral.tp_custom
                             resetNum:NO
                          commandData:@"ea470000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)tp_readScanIntervalParamsWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                  failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_tp_taskReadScanWindowDataOperation
                       characteristic:centralManager.peripheral.tp_custom
                             resetNum:NO
                          commandData:@"ea600000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)tp_readNumberOfVibrationsWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                  failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_tp_taskReadNumberOfVibrationsOperation
                       characteristic:centralManager.peripheral.tp_custom
                             resetNum:NO
                          commandData:@"ea620000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)tp_readMajorFilterStateWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_tp_taskReadMajorFilterStateOperation
                       characteristic:centralManager.peripheral.tp_custom
                             resetNum:NO
                          commandData:@"ea630000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)tp_readMinorFilterStateWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_tp_taskReadMinorFilterStateOperation
                       characteristic:centralManager.peripheral.tp_custom
                             resetNum:NO
                          commandData:@"ea640000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)tp_readButtonResetStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                 failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_tp_taskReadButtonResetStatusOperation
                 characteristic:centralManager.peripheral.tp_custom
                       resetNum:NO
                    commandData:@"ea650000"
                   successBlock:sucBlock
                   failureBlock:failedBlock];
}

+ (void)tp_readLowBatteryReminderRulesWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                       failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_tp_taskReadLowBatteryReminderRulesOperation
                       characteristic:centralManager.peripheral.tp_custom
                             resetNum:NO
                          commandData:@"ea680000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)tp_readTrackingDataFormatWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                  failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_tp_taskReadTrackingDataFormatOperation
                       characteristic:centralManager.peripheral.tp_custom
                             resetNum:NO
                          commandData:@"ea690000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)tp_readConnectionNotificationStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                            failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_tp_taskReadConnectionNotificationStatusOperation
                       characteristic:centralManager.peripheral.tp_custom
                             resetNum:NO
                          commandData:@"ea6a0000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)tp_readStorageDataNumberWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                 failedBlock:(nonnull void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_tp_taskReadStorageDataNumberOperation
                       characteristic:centralManager.peripheral.tp_custom
                             resetNum:NO
                          commandData:@"eaf20000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

@end
