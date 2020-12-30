//
//  MKTPPeripheral.h
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/23.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MKBaseBleModule/MKBLEBaseDataProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;
@interface MKTPPeripheral : NSObject<MKBLEBasePeripheralProtocol>

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral;

@end

NS_ASSUME_NONNULL_END
