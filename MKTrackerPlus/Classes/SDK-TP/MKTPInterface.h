//
//  MKTPInterface.h
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/24.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKTPInterface : NSObject

#pragma mark - Device Service Information

/// Read the battery level of the device
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readBatteryPowerWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                            failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read product model
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readDeviceModelWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                           failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read the production date of the product
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readProductionDateWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                              failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read device firmware information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readFirmwareWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                        failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read device hardware information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readHardwareWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                        failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read device software information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readSoftwareWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                        failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read device manufacturer information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readManufacturerWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                            failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Reading device type.
/// The device without 3-axis sensor and flash is 0x04, the device with 3-axis sensor is 0x05,the device with flash is 0x06,the device with 3-axis sensor and flash is 0x07.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readTrackerDeviceTypeWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                 failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Reading the proximity UUID of the device
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readProximityUUIDWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                             failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Reading the major of the device
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readMajorWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                     failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Reading the minor of the device
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readMinorWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                     failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// RSSI@1M
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readMeasurePowerWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                            failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Reading Advertised Tx Power(RSSI@0m)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readTxPowerWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                       failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Reading the broadcast interval of the device
/// units:100ms
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readAdvIntervalWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                           failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Reading the broadcast name of the device
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readAdvNameWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                       failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read the battery voltage of the device
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readBatteryVoltageWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                              failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read the scan status of the device.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readScanStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                          failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read the connectable status of the device.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readConnectableWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                          failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Tracking Notification,Turn on LED reminder: 0x01; turn on motor reminder: 0x02; turn on LED and motor reminder: 0x03; store reminder off: 0x00
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readTrackingNotificationWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                    failedBlock:(nonnull void (^)(NSError *error))failedBlock;


#pragma mark - custom api
/// Reading mac address
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readMacAddressWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                          failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Reading device broadcast mobile trigger condition
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readADVTriggerConditionsWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                    failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Reading Scanning Trigger condition
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readScanningTriggerConditionsWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                         failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Reading the current stored RSSI condition, and store it once when the master scans to the slave signal strength is greater than or equal to this value.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readStorageRssiWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                           failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Reading device data storage interval
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readStorageIntervalWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                               failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read if the device can be turned off by key
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readButtonPowerWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                           failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Reading device movement sensitivity.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readMovementSensitivityWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                   failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Whether the filtering of the mac address of the device is turned on.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readMacAddressFilterStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                      failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Whether the filtering of the adversting name of the device is turned on.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readAdvNameFilterStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                   failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Whether the filtering of the raw advertising data of the device is turned on.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readRawAdvDataFilterStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                      failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Turn off this option, the Beacon will store all types of BLE ADV data.Turn on this option, the Beacon will store the corresponding ADV data according to the filtering rules.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readAdvDataFilterStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                   failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Whether the filtering of the proximity UUID of the device is turned on.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readProximityUUIDFilterStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                         failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read the scan window time and scan interval time.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readScanIntervalParamsWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                  failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read current motor vibration times.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readNumberOfVibrationsWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                  failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Whether the filtering of the major of the device is turned on.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readMajorFilterStateWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Whether the filtering of the minor of the device is turned on.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readMinorFilterStateWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                failedBlock:(nonnull void (^)(NSError *error))failedBlock;

+ (void)tp_readButtonResetStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                 failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read low battery reminder rules.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readLowBatteryReminderRulesWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                       failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read the raw data state saved by the device.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readTrackingDataFormatWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                  failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read connection reminder status.Check whether the LED and motor reminders are turned on when the current device is connected by the app.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readConnectionNotificationStatusWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                            failedBlock:(nonnull void (^)(NSError *error))failedBlock;

/// Read the number of stored data.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)tp_readStorageDataNumberWithSucBlock:(nonnull void (^)(id returnData))sucBlock
                                 failedBlock:(nonnull void (^)(NSError *error))failedBlock;


@end

NS_ASSUME_NONNULL_END
