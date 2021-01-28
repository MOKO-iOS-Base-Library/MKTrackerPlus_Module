//
//  MKTPTabBarController.m
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/26.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKTPTabBarController.h"

#import "MKMacroDefines.h"
#import "MKBaseNavigationController.h"

#import "MKTPAdvertiserController.h"
#import "MKTPTrackerConfigController.h"
#import "MKTPSettingController.h"
#import "MKTPDeviceInfoController.h"

#import "MKTPCentralManager.h"

@interface MKTPTabBarController ()

/// 当触发01:修改密码成功,02:恢复出厂设置,03:两分钟之内没有通信,04:关机这几种类型的断开连接的时候，就不需要显示断开连接的弹窗了，只需要显示对应的弹窗
@property (nonatomic, assign)BOOL disconnectType;

@end

@implementation MKTPTabBarController

- (void)dealloc {
    NSLog(@"MKTPTabBarController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (![[self.navigationController viewControllers] containsObject:self]){
        [[MKTPCentralManager shared] disconnect];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubPages];
    [self addNotifications];
    [[MKTPCentralManager shared] notifyDisconnectType:YES];
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotoScanPage)
                                                 name:@"mk_tp_popToRootViewControllerNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dfuUpdateComplete)
                                                 name:@"mk_tp_centralDeallocNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(centralManagerStateChanged)
                                                 name:mk_tp_centralManagerStateChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disconnectTypeNotification:)
                                                 name:mk_tp_deviceDisconnectTypeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceConnectStateChanged)
                                                 name:mk_tp_peripheralConnectStateChangedNotification
                                               object:nil];
}

#pragma mark - notes
- (void)gotoScanPage {
    WS(weakSelf);
    [self dismissViewControllerAnimated:YES completion:^{
        __strong typeof(self) sself = weakSelf;
        if ([sself.delegate respondsToSelector:@selector(mk_needResetScanDelegate:)]) {
            [sself.delegate mk_needResetScanDelegate:NO];
        }
    }];
}

- (void)dfuUpdateComplete {
    WS(weakSelf);
    [self dismissViewControllerAnimated:YES completion:^{
        __strong typeof(self) sself = weakSelf;
        if ([sself.delegate respondsToSelector:@selector(mk_needResetScanDelegate:)]) {
            [sself.delegate mk_needResetScanDelegate:YES];
        }
    }];
}

- (void)disconnectTypeNotification:(NSNotification *)note {
    NSString *type = note.userInfo[@"type"];
    //00:连接一分钟之内没有输入密码,01:修改密码成功,02:恢复出厂设置,03:两分钟之内没有通信,04:关机
    self.disconnectType = YES;
    if ([type isEqualToString:@"01"]) {
        [self showAlertWithMsg:@"Password changed successfully! Please reconnect the device." title:@"Change Password"];
        return;
    }
    if ([type isEqualToString:@"02"]) {
        [self showAlertWithMsg:@"Factory reset successfully! Please reconnect the device." title:@"Factory Reset"];
        return;
    }
    if ([type isEqualToString:@"04"] || [type isEqualToString:@"03"]) {
        [self showAlertWithMsg:@"The Beacon is disconnected." title:@"Dismiss"];
        return;
    }
}

- (void)centralManagerStateChanged{
    if (self.disconnectType) {
        return;
    }
    if ([MKTPCentralManager shared].centralStatus != MKCentralManagerStateEnable) {
        [self showAlertWithMsg:@"The current system of bluetooth is not available!" title:@"Dismiss"];
    }
}

- (void)deviceConnectStateChanged {
    if (self.disconnectType) {
        return;
    }
    [self showAlertWithMsg:@"The Beacon is disconnected." title:@"Dismiss"];
    return;
}

#pragma mark - private method
- (void)showAlertWithMsg:(NSString *)msg title:(NSString *)title{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    WS(weakSelf);
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf gotoScanPage];
    }];
    [alertController addAction:moreAction];
    
    //让setting页面推出的alert消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_tp_settingPageNeedDismissAlert" object:nil];
    //让所有MKPickView消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_customUIModule_dismissPickView" object:nil];
    [self performSelector:@selector(presentAlert:) withObject:alertController afterDelay:1.2f];
}

- (void)presentAlert:(UIAlertController *)alert {
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 eddStone设备的连接状态发生改变提示弹窗
 */
- (void)disconnectAlert{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Dismiss"
                                                                             message:@"The device is disconnected"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *exitAction = [UIAlertAction actionWithTitle:@"Exit" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self gotoScanPage];
    }];
    [alertController addAction:exitAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)loadSubPages {
    MKTPAdvertiserController *advPage = [[MKTPAdvertiserController alloc] init];
    advPage.tabBarItem.title = @"ADVERTISER";
    advPage.tabBarItem.image = LOADICON(@"MKTrackerPlus", @"MKTPTabBarController", @"tp_adv_tabBarUnselected.png");
    advPage.tabBarItem.selectedImage = LOADICON(@"MKTrackerPlus", @"MKTPTabBarController", @"tp_adv_tabBarSelected.png");
    MKBaseNavigationController *advNav = [[MKBaseNavigationController alloc] initWithRootViewController:advPage];

    MKTPTrackerConfigController *trackerPage = [[MKTPTrackerConfigController alloc] init];
    trackerPage.tabBarItem.title = @"TRACKER";
    trackerPage.tabBarItem.image = LOADICON(@"MKTrackerPlus", @"MKTPTabBarController", @"tp_scanner_tabBarUnselected.png");
    trackerPage.tabBarItem.selectedImage = LOADICON(@"MKTrackerPlus", @"MKTPTabBarController", @"tp_scanner_tabBarSelected.png");
    MKBaseNavigationController *scannerNav = [[MKBaseNavigationController alloc] initWithRootViewController:trackerPage];

    MKTPSettingController *setting = [[MKTPSettingController alloc] init];
    setting.tabBarItem.title = @"SETTINGS";
    setting.tabBarItem.image = LOADICON(@"MKTrackerPlus", @"MKTPTabBarController", @"tp_setting_taabBarUnselected.png");
    setting.tabBarItem.selectedImage = LOADICON(@"MKTrackerPlus", @"MKTPTabBarController", @"tp_setting_tabBarSelected.png");
    MKBaseNavigationController *settingPage = [[MKBaseNavigationController alloc] initWithRootViewController:setting];
    
    MKTPDeviceInfoController *deviceInfo = [[MKTPDeviceInfoController alloc] init];
    deviceInfo.tabBarItem.title = @"DEVICE";
    deviceInfo.tabBarItem.image = LOADICON(@"MKTrackerPlus", @"MKTPTabBarController", @"tp_device_tabBarUnselected.png");
    deviceInfo.tabBarItem.selectedImage = LOADICON(@"MKTrackerPlus", @"MKTPTabBarController", @"tp_device_tabBarSelected.png");
    MKBaseNavigationController *deviceInfoPage = [[MKBaseNavigationController alloc] initWithRootViewController:deviceInfo];
    
    self.viewControllers = @[advNav,scannerNav,settingPage,deviceInfoPage];
}

@end
