

typedef NS_ENUM(NSInteger, mk_tp_taskOperationID) {
    mk_tp_defaultTaskOperationID,
    
#pragma mark - Read
    mk_tp_taskReadBatteryPowerOperation,       //电池电量
    mk_tp_taskReadDeviceModelOperation,        //读取产品型号
    mk_tp_taskReadProductionDateOperation,     //读取生产日期
    mk_tp_taskReadFirmwareOperation,           //读取固件版本
    mk_tp_taskReadHardwareOperation,           //读取硬件类型
    mk_tp_taskReadSoftwareOperation,           //读取软件版本
    mk_tp_taskReadManufacturerOperation,       //读取厂商信息
    mk_tp_taskReadDeviceTypeOperation,         //读取产品类型
    mk_tp_taskReadProximityUUIDOperation,      //Proximity UUID
    mk_tp_taskReadMajorOperation,              //major
    mk_tp_taskReadMinorOperation,              //minor
    mk_tp_taskReadMeasuredPowerOperation,      //RSSI@1m
    mk_tp_taskReadTxPowerOperation,            //tx power
    mk_tp_taskReadBroadcastIntervalOperation,  //广播间隔
    mk_tp_taskReadDeviceNameOperation,         //读取设备广播名称
    mk_tp_taskReadBatteryVoltageOperation,     //读取电池电压
    mk_tp_taskReadScanStatusOperation,          //设备扫描状态
    mk_tp_taskReadConnectableStatusOperation,   //设备连接状态
    mk_tp_taskReadStorageReminderOperation,        //追踪提醒
    
#pragma mark - 自定义
    mk_tp_taskReadMacAddressOperation,         //读取mac地址
    mk_tp_taskReadADVTriggerConditionsOperation,   //移动触发条件
    mk_tp_taskReadScanningTriggerConditionsOperation,   //读取扫描触发条件
    mk_tp_taskReadStorageRssiOperation,             //读取存储RSSI条件
    mk_tp_taskReadStorageIntervalOperation,        //读取存储间隔
    mk_tp_taskReadButtonPowerStatusOperation,       //读取按键开关机状态
    mk_tp_taskReadMovementSensitivityOperation,     //读取设备移动灵敏度
    mk_tp_taskReadMacFilterStatusOperation,         //读取Mac过滤条件
    mk_tp_taskReadAdvNameFilterStatusOperation,     //读取广播名称过滤条件
    mk_tp_taskReadRawAdvDataFilterStatusOperation,  //读取原始数据过滤条件
    mk_tp_taskReadAdvDataFilterStatusOperation,     //读取advData过滤条件状态
    mk_tp_taskReadProximityUUIDFilterStatusOperation,   //读取UUID过滤条件
    mk_tp_taskReadScanWindowDataOperation,          //读取scan window和scan interval
    mk_tp_taskReadNumberOfVibrationsOperation,      //读取马达震动次数
    mk_tp_taskReadMajorFilterStateOperation,        //读取Major过滤条件
    mk_tp_taskReadMinorFilterStateOperation,        //读取Minor过滤条件
    mk_tp_taskReadButtonResetStatusOperation,       //读取按键复位状态
    mk_tp_taskReadLowBatteryReminderRulesOperation, //读取低电量提醒规则
    mk_tp_taskReadTrackingDataFormatOperation,   //读取追踪数据格式状态
    mk_tp_taskReadConnectionNotificationStatusOperation,    //读取连接提醒状态
    mk_tp_taskReadStorageDataNumberOperation,       //读取存储数据条数
   
#pragma mark - Config
    
    
    mk_tp_taskConfigProximityUUIDOperation,    //配置UUID
    mk_tp_taskConfigMajorOperation,            //配置Major
    mk_tp_taskConfigMinorOperation,            //配置Minor
    mk_tp_taskConfigMeasuredPowerOperation,    //配置RSSI@1m
    mk_tp_taskConfigTxPowerOperation,          //配置Tx Power
    mk_tp_taskConfigAdvIntervalOperation,      //配置广播间隔
    mk_tp_taskConfigDeviceNameOperation,       //配置广播名称
    mk_tp_taskConfigPasswordOperation,               //密码
    mk_tp_taskConfigScanStatusOperation,       //配置扫描状态
    mk_tp_taskConfigConnectableStatusOperation, //配置可连接状态
    mk_tp_taskConfigStorageReminderOperation,      //配置追踪报警
    mk_tp_taskConfigFactoryDataResetOperation,      //恢复出厂配置
    
#pragma mark - 自定义
    
    mk_tp_taskConfigPowerOffOperation,          //关机
    mk_tp_taskClearAllDatasOperation,           //清除设备所有缓存数据
    mk_tp_taskConfigAdvTriggerConditionsOperation, //配置移动触发条件
    mk_tp_taskConfigScanningTriggerConditionsOperation, //配置扫描触发条件
    mk_tp_taskConfigStorageRssiOperation,           //配置存储RSSI条件
    mk_tp_taskConfigStorageIntervalOperation,      //配置存储间隔
    mk_tp_taskConfigDateOperation,             //配置时间
    mk_tp_taskConfigButtonPowerStatusOperation, //配置按键关机状态
    mk_tp_taskConfigMovementSensitivityOperation,   //配置当前设备移动灵敏度
    mk_tp_taskConfigMacFilterStatusOperation,       //配置当前mac地址过滤条件
    mk_tp_taskConfigAdvNameFilterStatusOperation,   //配置当前advName地址过滤条件
    mk_tp_taskConfigRawAdvDataFilterStatusOperation,    //配置当前raw adv dat地址过滤条件
    mk_tp_taskConfigAdvDataFilterStatusOperation,       //配置advData过滤条件状态
    mk_tp_taskConfigProximityUUIDFilterStatusOperation, //配置proximity uuid过滤条件状态
    mk_tp_taskSendVibrationCommandsOperation,           //震动
    mk_tp_taskConfigScannWindowOperation,               //配置扫描窗口
    mk_tp_taskConfigNumberOfVibrationsOperation,        //配置马达震动次数
    mk_tp_taskConfigMajorFilterStateOperation,          //配置Major过滤条件
    mk_tp_taskConfigMinorFilterStateOperation,          //配置Minor过滤条件
    mk_tp_taskConfigButtonResetStatusOperation,         //配置按键复位功能
    mk_tp_taskConfigLowBatteryReminderRulesOperation,   //配置低电量提醒规则
    mk_tp_taskConfigTrackingDataFormatOperation,        //配置是否保存Raw Data
    mk_tp_taskConfigConnectionNotificationStatusOperation,  //配置是否开启连接提醒
};
