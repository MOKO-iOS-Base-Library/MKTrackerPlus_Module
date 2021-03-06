//
//  MKTPTaskAdopter.m
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/24.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKTPTaskAdopter.h"
#import <CoreBluetooth/CoreBluetooth.h>

#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseSDKDefines.h"

#import "MKTPSDKDefines.h"

#import "MKTPOperationID.h"

NSString *const mk_tp_communicationDataNum = @"mk_tp_communicationDataNum";

@implementation MKTPTaskAdopter

+ (NSDictionary *)parseReadDataWithCharacteristic:(CBCharacteristic *)characteristic {
    NSData *readData = characteristic.value;
    NSLog(@"+++++%@-----%@",characteristic.UUID.UUIDString,readData);
    if ([characteristic.UUID isEqual:MKUUID(@"2A19")]) {
        //电池电量
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        NSString *battery = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        return [self dataParserGetDataSuccess:@{@"batteryPower":battery} operationID:mk_tp_taskReadBatteryPowerOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"2A24")]) {
        //产品型号
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"modeID":tempString} operationID:mk_tp_taskReadDeviceModelOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"2A25")]) {
        //生产日期
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"productionDate":tempString} operationID:mk_tp_taskReadProductionDateOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"2A26")]) {
        //firmware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"firmware":tempString} operationID:mk_tp_taskReadFirmwareOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"2A27")]) {
        //hardware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"hardware":tempString} operationID:mk_tp_taskReadHardwareOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"2A28")]) {
        //soft ware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"software":tempString} operationID:mk_tp_taskReadSoftwareOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"2A29")]) {
        //manufacturerKey
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"manufacturer":tempString} operationID:mk_tp_taskReadManufacturerOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF00")]) {
        //设备类型
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        return [self dataParserGetDataSuccess:@{@"deviceType":content} operationID:mk_tp_taskReadDeviceTypeOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF01")]) {
        //uuid
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        NSMutableArray *array = [NSMutableArray arrayWithObjects:[content substringWithRange:NSMakeRange(0, 8)],
                                 [content substringWithRange:NSMakeRange(8, 4)],
                                 [content substringWithRange:NSMakeRange(12, 4)],
                                 [content substringWithRange:NSMakeRange(16,4)],
                                 [content substringWithRange:NSMakeRange(20, 12)], nil];
        [array insertObject:@"-" atIndex:1];
        [array insertObject:@"-" atIndex:3];
        [array insertObject:@"-" atIndex:5];
        [array insertObject:@"-" atIndex:7];
        NSString *uuid = @"";
        for (NSString *string in array) {
            uuid = [uuid stringByAppendingString:string];
        }
        uuid = [uuid uppercaseString];
        return [self dataParserGetDataSuccess:@{@"uuid":uuid} operationID:mk_tp_taskReadProximityUUIDOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF02")]) {
        //major
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        NSString *major = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        return [self dataParserGetDataSuccess:@{@"major":major} operationID:mk_tp_taskReadMajorOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF03")]) {
        //minor
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        NSString *minor = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        return [self dataParserGetDataSuccess:@{@"minor":minor} operationID:mk_tp_taskReadMinorOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF04")]) {
        //RSSI@1M
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        NSString *measuredPower = [NSString stringWithFormat:@"%ld",(long)[[MKBLEBaseSDKAdopter signedHexTurnString:content] integerValue]];
        return [self dataParserGetDataSuccess:@{@"measuredPower":measuredPower} operationID:mk_tp_taskReadMeasuredPowerOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF05")]) {
        //txPower
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        return [self dataParserGetDataSuccess:@{@"txPower":[self fetchTxPower:content]} operationID:mk_tp_taskReadTxPowerOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF06")]) {
        //adv interval
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        NSString *interval = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        return [self dataParserGetDataSuccess:@{@"interval":interval} operationID:mk_tp_taskReadBroadcastIntervalOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF07")]) {
        //设备名称
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"deviceName":tempString} operationID:mk_tp_taskReadDeviceNameOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF08")]) {
        //当前设备状态，解锁或者修改密码或者锁定状态
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        return [self dataParserGetDataSuccess:@{@"state":content} operationID:mk_tp_taskConfigPasswordOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF09")]) {
        //电池电压
        return [self batteryData:readData];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF0A")]) {
        //设备扫描状态
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        BOOL isOn = [content isEqualToString:@"01"];
        return [self dataParserGetDataSuccess:@{@"isOn":@(isOn)} operationID:mk_tp_taskReadScanStatusOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF0B")]) {
        //设备连接状态
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        BOOL isOn = [content isEqualToString:@"01"];
        return [self dataParserGetDataSuccess:@{@"isOn":@(isOn)} operationID:mk_tp_taskReadConnectableStatusOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF0C")]) {
        //存储提醒
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        return [self dataParserGetDataSuccess:@{@"reminder":content} operationID:mk_tp_taskReadStorageReminderOperation];
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF10")]) {
        //自定义协议部分
        return [self parseFF10Data:readData];
    }
    return @{};
}

+ (NSDictionary *)parseWriteDataWithCharacteristic:(CBCharacteristic *)characteristic {
    mk_tp_taskOperationID operationID = mk_tp_defaultTaskOperationID;
    if ([characteristic.UUID isEqual:MKUUID(@"FF01")]) {
        //UUID
        operationID = mk_tp_taskConfigProximityUUIDOperation;
    }else if ([characteristic.UUID isEqual:MKUUID(@"FF02")]) {
        //Major
        operationID = mk_tp_taskConfigMajorOperation;
    }else if ([characteristic.UUID isEqual:MKUUID(@"FF03")]) {
        operationID = mk_tp_taskConfigMinorOperation;
    }else if ([characteristic.UUID isEqual:MKUUID(@"FF04")]) {
        operationID = mk_tp_taskConfigMeasuredPowerOperation;
    }else if ([characteristic.UUID isEqual:MKUUID(@"FF05")]) {
        operationID = mk_tp_taskConfigTxPowerOperation;
    }else if ([characteristic.UUID isEqual:MKUUID(@"FF06")]) {
        operationID = mk_tp_taskConfigAdvIntervalOperation;
    }else if ([characteristic.UUID isEqual:MKUUID(@"FF07")]) {
        operationID = mk_tp_taskConfigDeviceNameOperation;
    }else if ([characteristic.UUID isEqual:MKUUID(@"FF0A")]) {
        operationID = mk_tp_taskConfigScanStatusOperation;
    }else if ([characteristic.UUID isEqual:MKUUID(@"FF0B")]) {
        operationID = mk_tp_taskConfigConnectableStatusOperation;
    }else if ([characteristic.UUID isEqual:MKUUID(@"FF0C")]) {
        operationID = mk_tp_taskConfigStorageReminderOperation;
    }else if ([characteristic.UUID isEqual:MKUUID(@"FF0F")]) {
        operationID = mk_tp_taskConfigFactoryDataResetOperation;
    }
    return [self dataParserGetDataSuccess:@{@"result":@(YES)} operationID:operationID];
}

#pragma mark -
+ (NSDictionary *)parseFF10Data:(NSData *)characteristicData {
    NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:characteristicData];
    if (content.length < 8) {
        return @{};
    }
    NSString *header = [content substringWithRange:NSMakeRange(0, 2)];
    if (![header isEqualToString:@"eb"]) {
        return @{};
    }
    NSInteger len = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(6, 2)];
    NSString *function = [content substringWithRange:NSMakeRange(2, 2)];
    NSDictionary *returnDic = @{};
    mk_tp_taskOperationID operationID = mk_tp_defaultTaskOperationID;
    if ([function isEqualToString:@"20"]) {
        //读取mac address
        NSString *tempMac = [[content substringWithRange:NSMakeRange(8, 12)] uppercaseString];
        NSString *macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",[tempMac substringWithRange:NSMakeRange(0, 2)],[tempMac substringWithRange:NSMakeRange(2, 2)],[tempMac substringWithRange:NSMakeRange(4, 2)],[tempMac substringWithRange:NSMakeRange(6, 2)],[tempMac substringWithRange:NSMakeRange(8, 2)],[tempMac substringWithRange:NSMakeRange(10, 2)]];
        operationID = mk_tp_taskReadMacAddressOperation;
        returnDic = @{@"macAddress":macAddress};
    }else if ([function isEqualToString:@"21"]) {
        //移动触发条件
        BOOL isOn = NO;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (content.length == 12) {
            NSString *time = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 4)];
            [dic setValue:time forKey:@"time"];
            isOn = YES;
        }
        [dic setValue:@(isOn) forKey:@"isOn"];
        returnDic = @{
            @"conditions":dic
        };
        operationID = mk_tp_taskReadADVTriggerConditionsOperation;
    }else if ([function isEqualToString:@"22"]) {
        //读取扫描触发条件
        BOOL isOn = NO;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (content.length == 12) {
            NSString *time = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 4)];
            [dic setValue:time forKey:@"time"];
            isOn = YES;
        }
        [dic setValue:@(isOn) forKey:@"isOn"];
        returnDic = @{
            @"conditions":dic
        };
        operationID = mk_tp_taskReadScanningTriggerConditionsOperation;
    }else if ([function isEqualToString:@"23"] && content.length == 10) {
        //读取存储RSSI条件
        NSString *rssi = [NSString stringWithFormat:@"%ld",(long)[[MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(8, 2)]] integerValue]];
        returnDic = @{
                       @"rssi":rssi,
                       };
        operationID = mk_tp_taskReadStorageRssiOperation;
    }else if ([function isEqualToString:@"24"] && content.length == 10) {
        //读取存储间隔
        returnDic = @{
                       @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 2)],
                       };
        operationID = mk_tp_taskReadStorageIntervalOperation;
    }else if ([function isEqualToString:@"26"] && content.length == 8) {
        //关机
        BOOL success = [[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"00"];
        returnDic = @{
                       @"result":@(success)
                       };
        operationID = mk_tp_taskConfigPowerOffOperation;
    }else if ([function isEqualToString:@"28"] && content.length == 10) {
        //读取按键开关机状态
        BOOL isOn = [[content substringWithRange:NSMakeRange(8, 2)] isEqualToString:@"01"];
        returnDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_tp_taskReadButtonPowerStatusOperation;
    }else if ([function isEqualToString:@"29"] && content.length == 8) {
        //清除设备所有缓存数据
        returnDic = @{
                       @"result":@(YES)
                       };
        operationID = mk_tp_taskClearAllDatasOperation;
    }else if ([function isEqualToString:@"31"] && content.length == 8) {
        //配置扫描条件
        BOOL success = [[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"00"];
        returnDic = @{
                       @"result":@(success)
                       };
        operationID = mk_tp_taskConfigAdvTriggerConditionsOperation;
    }else if ([function isEqualToString:@"32"] && content.length == 8) {
        //配置扫描触发条件
        BOOL success = [[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"00"];
        returnDic = @{
                       @"result":@(success)
                       };
        operationID = mk_tp_taskConfigScanningTriggerConditionsOperation;
    }else if ([function isEqualToString:@"33"] && content.length == 8) {
        BOOL success = [[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"00"];
        returnDic = @{
                       @"result":@(success)
                       };
        operationID = mk_tp_taskConfigStorageRssiOperation;
    }else if ([function isEqualToString:@"34"] && content.length == 8) {
        //配置存储间隔
        BOOL success = [[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"00"];
        returnDic = @{
                       @"result":@(success)
                       };
        operationID = mk_tp_taskConfigStorageIntervalOperation;
    }else if ([function isEqualToString:@"35"] && content.length == 8) {
        //配置设备时间
        BOOL success = [[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"00"];
        returnDic = @{
                       @"result":@(success)
                       };
        operationID = mk_tp_taskConfigDateOperation;
    }else if ([function isEqualToString:@"38"] && content.length == 8) {
        //配置按键开关机状态
        BOOL success = [[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"00"];
        returnDic = @{
                       @"result":@(success)
                       };
        operationID = mk_tp_taskConfigButtonPowerStatusOperation;
    }else if ([function isEqualToString:@"40"] && content.length == 10) {
        //读取设备移动灵敏度
        NSString *sensitivity = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 2)];
        returnDic = @{
                       @"sensitivity":sensitivity,
                       };
        operationID = mk_tp_taskReadMovementSensitivityOperation;
    }else if ([function isEqualToString:@"41"]) {
        //读取mac过滤条件
        BOOL isOn = (len > 1);
        NSString *mac = @"";
        BOOL whiteListIson = NO;
        if (isOn && content.length >= 12) {
            whiteListIson = ([[content substringWithRange:NSMakeRange(8, 2)] isEqualToString:@"02"]);
            mac = [content substringWithRange:NSMakeRange(10, len * 2 - 2)];
        }
        returnDic = @{
                       @"isOn":@(isOn),
                       @"whiteListIson":@(whiteListIson),
                       @"filterMac":mac
                       };
        operationID = mk_tp_taskReadMacFilterStatusOperation;
    }else if ([function isEqualToString:@"42"]) {
        //读取advName过滤条件
        BOOL isOn = (len > 1);
        NSString *advName = @"";
        BOOL whiteListIson = NO;
        if (isOn && content.length >= 12) {
            whiteListIson = ([[content substringWithRange:NSMakeRange(8, 2)] isEqualToString:@"02"]);
            advName = [[NSString alloc] initWithData:[characteristicData subdataWithRange:NSMakeRange(5, len - 1)] encoding:NSUTF8StringEncoding];
        }
        returnDic = @{
                       @"isOn":@(isOn),
                       @"whiteListIson":@(whiteListIson),
                       @"advName":(advName ? advName : @""),
                       };
        operationID = mk_tp_taskReadAdvNameFilterStatusOperation;
    }else if ([function isEqualToString:@"43"]) {
        //读取raw adv data过滤条件
        BOOL isOn = (len > 1);
        NSString *rawAdvData = @"";
        BOOL whiteListIson = NO;
        if (isOn && content.length >= 12) {
            whiteListIson = ([[content substringWithRange:NSMakeRange(8, 2)] isEqualToString:@"02"]);
            rawAdvData = [content substringWithRange:NSMakeRange(10, 2 * (len - 1))];
        }
        returnDic = @{
                       @"isOn":@(isOn),
                       @"whiteListIson":@(whiteListIson),
                       @"rawAdvData":rawAdvData
                       };
        operationID = mk_tp_taskReadRawAdvDataFilterStatusOperation;
    }else if ([function isEqualToString:@"46"] && content.length == 10) {
        //读取advData过滤条件状态
        NSString *status = [content substringWithRange:NSMakeRange(8, 2)];
        returnDic = @{
                       @"isOn":@([status isEqualToString:@"01"])
                       };
        operationID = mk_tp_taskReadAdvDataFilterStatusOperation;
    }else if ([function isEqualToString:@"47"]) {
        //读取uuid过滤条件状态
        BOOL isOn = (content.length == 42);
        NSString *uuid = @"";
        BOOL whiteListIson = NO;
        if (isOn) {
            whiteListIson = ([[content substringWithRange:NSMakeRange(8, 2)] isEqualToString:@"02"]);
            NSString *tempUUID = [content substringWithRange:NSMakeRange(10, 32)];
            NSMutableArray *array = [NSMutableArray arrayWithObjects:[tempUUID substringWithRange:NSMakeRange(0, 8)],
                                     [tempUUID substringWithRange:NSMakeRange(8, 4)],
                                     [tempUUID substringWithRange:NSMakeRange(12, 4)],
                                     [tempUUID substringWithRange:NSMakeRange(16,4)],
                                     [tempUUID substringWithRange:NSMakeRange(20, 12)], nil];
            [array insertObject:@"-" atIndex:1];
            [array insertObject:@"-" atIndex:3];
            [array insertObject:@"-" atIndex:5];
            [array insertObject:@"-" atIndex:7];
            for (NSString *string in array) {
                uuid = [uuid stringByAppendingString:string];
            }
            uuid = [uuid uppercaseString];
        }
        
        returnDic = @{
                       @"isOn":@(isOn),
                       @"whiteListIson":@(whiteListIson),
                       @"uuid":uuid,
                       };
        operationID = mk_tp_taskReadProximityUUIDFilterStatusOperation;
    }else if ([function isEqualToString:@"50"] && content.length == 8) {
        //配置当前设备移动灵敏度
        BOOL success = [[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"00"];
        returnDic = @{
                       @"result":@(success)
                       };
        operationID = mk_tp_taskConfigMovementSensitivityOperation;
    }else if ([function isEqualToString:@"51"] && content.length == 8) {
        //配置当前mac地址过滤条件
        BOOL success = [[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"00"];
        returnDic = @{
                       @"result":@(success)
                       };
        operationID = mk_tp_taskConfigMacFilterStatusOperation;
    }else if ([function isEqualToString:@"52"] && content.length == 8) {
        //配置当前advName地址过滤条件
        BOOL success = [[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"00"];
        returnDic = @{
                       @"result":@(success)
                       };
        operationID = mk_tp_taskConfigAdvNameFilterStatusOperation;
    }else if ([function isEqualToString:@"53"] && content.length == 8) {
        //配置当前raw adv dat地址过滤条件
        BOOL success = [[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"00"];
        returnDic = @{
                       @"result":@(success)
                       };
        operationID = mk_tp_taskConfigRawAdvDataFilterStatusOperation;
    }else if ([function isEqualToString:@"56"] && content.length == 8) {
        //配置advData过滤条件状态
        BOOL success = [[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"00"];
        returnDic = @{
                       @"result":@(success)
                       };
        operationID = mk_tp_taskConfigAdvDataFilterStatusOperation;
    }else if ([function isEqualToString:@"57"] && content.length == 8) {
        //配置proximity uuid过滤条件状态
        BOOL success = [[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"00"];
        returnDic = @{
                       @"result":@(success)
                       };
        operationID = mk_tp_taskConfigProximityUUIDFilterStatusOperation;
    }else if ([function isEqualToString:@"60"] && content.length == 16) {
        //读取scan window和scan interval
        NSString *scanWindow = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 4)];
        NSString *scanInterval = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(12, 4)];
        returnDic = @{
                       @"scanWindow":scanWindow,
                       @"scanInterval":scanInterval,
                       };
        operationID = mk_tp_taskReadScanWindowDataOperation;
    }else if ([function isEqualToString:@"61"] && content.length == 8) {
        //震动
        BOOL success = [[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"00"];
        returnDic = @{
                       @"result":@(success)
                       };
        operationID = mk_tp_taskSendVibrationCommandsOperation;
    }else if ([function isEqualToString:@"62"] && content.length == 10) {
        //读取马达震动次数
        returnDic = @{
                       @"number":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 2)]
                       };
        operationID = mk_tp_taskReadNumberOfVibrationsOperation;
    }else if ([function isEqualToString:@"63"]) {
        //读取major过滤条件状态
        BOOL isOn = (len > 1);
        NSString *majorMinValue = @"";
        NSString *majorMaxValue = @"";
        BOOL whiteListIson = NO;
        if (isOn) {
            whiteListIson = ([[content substringWithRange:NSMakeRange(8, 2)] isEqualToString:@"02"]);
            majorMinValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(10, 4)];
            majorMaxValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(14, 4)];
        }
        returnDic = @{
                       @"isOn":@(isOn),
                       @"whiteListIson":@(whiteListIson),
                       @"majorMinValue":majorMinValue,
                       @"majorMaxValue":majorMaxValue,
                       };
        operationID = mk_tp_taskReadMajorFilterStateOperation;
    }else if ([function isEqualToString:@"64"]) {
        //读取minor过滤条件状态
        BOOL isOn = (len > 1);
        NSString *minorMinValue = @"";
        NSString *minorMaxValue = @"";
        BOOL whiteListIson = NO;
        if (isOn) {
            whiteListIson = ([[content substringWithRange:NSMakeRange(8, 2)] isEqualToString:@"02"]);
            minorMinValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(10, 4)];
            minorMaxValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(14, 4)];
        }
        returnDic = @{
                       @"isOn":@(isOn),
                       @"whiteListIson":@(whiteListIson),
                       @"minorMinValue":minorMinValue,
                       @"minorMaxValue":minorMaxValue,
                       };
        operationID = mk_tp_taskReadMinorFilterStateOperation;
    }else if ([function isEqualToString:@"65"] && content.length == 10) {
        //读取按键复位功能
        BOOL isOn = [[content substringWithRange:NSMakeRange(8, 2)] isEqualToString:@"01"];
        returnDic = @{
                       @"isOn":@(isOn),
                       };
        operationID = mk_tp_taskReadButtonResetStatusOperation;
    }else if ([function isEqualToString:@"68"] && content.length == 14) {
        //读取低电量提醒规则
        NSString *value1 = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 2)];
        NSString *value2 = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(10, 2)];
        NSString *value3 = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(12, 2)];
        returnDic = @{
                       @"lTwentyInterval":value1,
                       @"lTenInterval":value2,
                       @"lFiveInterval":value3,
                       };
        operationID = mk_tp_taskReadLowBatteryReminderRulesOperation;
    }else if ([function isEqualToString:@"69"] && content.length == 10) {
        //读取追踪数据格式状态
        returnDic = @{
                       @"state":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 2)]
                       };
        operationID = mk_tp_taskReadTrackingDataFormatOperation;
    }else if ([function isEqualToString:@"6a"] && content.length == 10) {
        //读取连接提醒
        BOOL isOn = [[content substringWithRange:NSMakeRange(8, 2)] isEqualToString:@"01"];
        returnDic = @{
                       @"isOn":@(isOn)
                       };
        operationID = mk_tp_taskReadConnectionNotificationStatusOperation;
    }else if ([function isEqualToString:@"70"] && content.length == 8) {
        //配置scan window
        BOOL success = [[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"00"];
        returnDic = @{
                       @"result":@(success)
                       };
        operationID = mk_tp_taskConfigScannWindowOperation;
    }else if ([function isEqualToString:@"72"] && content.length == 8) {
        //设置马达震动次数
        BOOL success = [[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"00"];
        returnDic = @{
                       @"result":@(success)
                       };
        operationID = mk_tp_taskConfigNumberOfVibrationsOperation;
    }else if ([function isEqualToString:@"73"] && content.length == 8) {
        //设置Major过滤条件
        BOOL success = [[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"00"];
        returnDic = @{
                       @"result":@(success)
                       };
        operationID = mk_tp_taskConfigMajorFilterStateOperation;
    }else if ([function isEqualToString:@"74"] && content.length == 8) {
        //设置Minor过滤条件
        BOOL success = [[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"00"];
        returnDic = @{
                       @"result":@(success)
                       };
        operationID = mk_tp_taskConfigMinorFilterStateOperation;
    }else if ([function isEqualToString:@"75"] && content.length == 8) {
        //设置Button reset状态
        BOOL success = [[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"00"];
        returnDic = @{
                       @"result":@(success)
                       };
        operationID = mk_tp_taskConfigButtonResetStatusOperation;
    }else if ([function isEqualToString:@"78"] && content.length == 8) {
        //设置低电量提醒规则
        BOOL success = [[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"00"];
        returnDic = @{
                       @"result":@(success)
                       };
        operationID = mk_tp_taskConfigLowBatteryReminderRulesOperation;
    }else if ([function isEqualToString:@"79"] && content.length == 8) {
        //设置是否保存Raw Data
        BOOL success = [[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"00"];
        returnDic = @{
                       @"result":@(success)
                       };
        operationID = mk_tp_taskConfigTrackingDataFormatOperation;
    }else if ([function isEqualToString:@"7a"] && content.length == 8) {
        //设置是否开启连接提醒
        BOOL success = [[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"00"];
        returnDic = @{
                       @"result":@(success)
                       };
        operationID = mk_tp_taskConfigConnectionNotificationStatusOperation;
    }else if ([function isEqualToString:@"f2"] && content.length == 16) {
        //读取存储数据条数
        NSString *storeNumber = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 4)];
        NSString *remainingNumber = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(12, 4)];
        returnDic = @{
                       @"storeNumber":storeNumber,
                       @"remainingNumber":remainingNumber,
                       };
        operationID = mk_tp_taskReadStorageDataNumberOperation;
    }
    return [self dataParserGetDataSuccess:returnDic operationID:operationID];
}

+ (NSDictionary *)batteryData:(NSData *)data{
    NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:data];
    if (!content || content.length != 4) {
        return @{};
    }
    NSString *battery = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 4)];
    return [self dataParserGetDataSuccess:@{@"batteryVoltage":battery} operationID:mk_tp_taskReadBatteryVoltageOperation];
}

+ (NSDictionary *)dataParserGetDataSuccess:(NSDictionary *)returnData operationID:(mk_tp_taskOperationID)operationID{
    if (!returnData) {
        return @{};
    }
    return @{@"returnData":returnData,@"operationID":@(operationID)};
}

+ (NSString *)fetchTxPower:(NSString *)content {
    if ([content isEqualToString:@"04"]) {
        return @"4dBm";
    }
    if ([content isEqualToString:@"03"]) {
        return @"3dBm";
    }
    if ([content isEqualToString:@"00"]) {
        return @"0dBm";
    }
    if ([content isEqualToString:@"fc"]) {
        return @"-4dBm";
    }
    if ([content isEqualToString:@"f8"]) {
        return @"-8dBm";
    }
    if ([content isEqualToString:@"f4"]) {
        return @"-12dBm";
    }
    if ([content isEqualToString:@"f0"]) {
        return @"-16dBm";
    }
    if ([content isEqualToString:@"ec"]) {
        return @"-20dBm";
    }
    if ([content isEqualToString:@"d8"]) {
        return @"-40dBm";
    }
    return @"-4dBm";
}

@end
