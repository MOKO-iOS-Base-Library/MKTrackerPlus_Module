//
//  Target_TrackerPlus_Module.m
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/30.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "Target_TrackerPlus_Module.h"

#import "MKTPScanController.h"

@implementation Target_TrackerPlus_Module

/// 扫描页面
- (UIViewController *)Action_TrackerPlus_Module_ScanController:(NSDictionary *)params {
    return [[MKTPScanController alloc] init];
}

@end
