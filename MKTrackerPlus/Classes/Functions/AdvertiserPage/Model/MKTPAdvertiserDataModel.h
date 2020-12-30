//
//  MKTPAdvertiserDataModel.h
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/26.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKTPAdvertiserDataModel : NSObject

@property (nonatomic, copy)NSString *deviceName;

@property (nonatomic, copy)NSString *proximityUUID;

@property (nonatomic, copy)NSString *major;

@property (nonatomic, copy)NSString *minor;

@property (nonatomic, copy)NSString *interval;

@property (nonatomic, copy)NSString *measurePower;

/*
 0,   //RadioTxPower:-40dBm
 1,   //-20dBm
 2,   //-16dBm
 3,   //-12dBm
 4,    //-8dBm
 5,    //-4dBm
 6,       //0dBm
 7,       //3dBm
 8,       //4dBm
 
 */
@property (nonatomic, assign)NSInteger txPower;

/// 04类型的设备不支持
@property (nonatomic, copy)NSString *advTriggerTime;
/// 04类型的设备不支持
@property (nonatomic, assign)BOOL advTriggerIsOn;

- (void)startReadWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)startConfigWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
