//
//  MKTPSettingController.m
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/26.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKTPSettingController.h"

#import "Masonry.h"
#import "MKBaseTableView.h"
#import "MKMacroDefines.h"
#import "MKHudManager.h"
#import "UIView+MKAdd.h"

#import "MKNormalTextCell.h"
#import "MKTextSwitchCell.h"

#import "MKTPInterface.h"
#import "MKTPInterface+MKTPConfig.h"

#import "MKTPSettingDataModel.h"

#import "MKTPLowPowerNoteConfigView.h"
#import "MKTPTriggerSensitivityView.h"

#import "MKTPUpdateController.h"

@interface MKTPSettingController ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)NSMutableArray *section4List;

@property (nonatomic, strong)MKTPSettingDataModel *dataModel;

@property (nonatomic, strong)UITextField *passwordField;

@property (nonatomic, strong)UITextField *passwordTextField;

@property (nonatomic, strong)UITextField *confirmTextField;

/// 当前present的alert
@property (nonatomic, strong)UIAlertController *currentAlert;

@end

@implementation MKTPSettingController

- (void)dealloc {
    NSLog(@"MKTPSettingController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(needDismissAlert)
                                                 name:@"mk_tp_settingPageNeedDismissAlert"
                                               object:nil];
    [self startReadDatas];
}

#pragma mark - super method
- (void)leftButtonMethod {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_tp_popToRootViewControllerNotification" object:nil];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        //设置密码
        [self configPassword];
        return;
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        //低电量报警
        [self configLowPowerNote];
        return;
    }
    if (indexPath.section == 2 && indexPath.row == 1) {
        //设置灵敏度
        [self triggerSensitivityMethod];
        return;
    }
    if (indexPath.section == 4 && indexPath.row == 0) {
        //恢复出厂设置
        [self factoryReset];
        return;
    }
    if (indexPath.section == 4 && indexPath.row == 1) {
        //dfu升级
        [self pushDfuPage];
        return;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    if (section == 2) {
        return self.section2List.count;
    }
    if (section == 3) {
        return self.section3List.count;
    }
    if (section == 4) {
        return self.section4List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 1) {
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 2) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section2List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 3) {
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.section3List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
    cell.dataModel = self.section4List[indexPath.row];
    return cell;
}

#pragma mark - mk_textSwitchCellDelegate
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //按键开关机
        [self configButtonOff:isOn];
        return;
    }
    if (index == 1) {
        //可连接状态
        [self configConnectEnable:isOn];
        return;
    }
    if (index == 2) {
        //设置连接提醒
        [self configConnectionNotificationStatus:isOn];
        return;
    }
    if (index == 3) {
        //按键复位
        [self setButtonResetStatusEnable:isOn];
        return;
    }
    if (index == 4) {
        //app关机
        [self powerOff];
        return;
    }
}

#pragma mark - note
- (void)needDismissAlert {
    if (self.currentAlert && (self.presentedViewController == self.currentAlert)) {
        [self.currentAlert dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - interface
- (void)startReadDatas {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    WS(weakSelf);
    [self.dataModel startReadDataWithSucBlock:^{
        [[MKHudManager share] hide];
        [weakSelf processSwitchStatus];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)processSwitchStatus {
    MKTextSwitchCellModel *buttonModel = self.section1List[0];
    buttonModel.isOn = self.dataModel.buttonOffIsOn;
    buttonModel.msg = (self.dataModel.buttonOffIsOn ? @"Enable Button Off" : @"Disable Button Off");
    
    MKTextSwitchCellModel *connectModel = self.section1List[1];
    connectModel.isOn = self.dataModel.connectable;
    connectModel.msg = (self.dataModel.connectable ? @"Connectable" : @"Non-connectable");
    
    MKTextSwitchCellModel *connectNoteModel = self.section1List[2];
    connectNoteModel.isOn = self.dataModel.connectableNoteIsOn;
    
    MKTextSwitchCellModel *buttonResetModel = self.section3List[0];
    buttonResetModel.isOn = self.dataModel.buttonResetIsOn;
    buttonResetModel.msg = (self.dataModel.buttonResetIsOn ? @"Enable Button Reset" : @"Disable Button Reset");
    [self.tableView reloadData];
}

#pragma mark - 设置密码
- (void)configPassword{
    WS(weakSelf);
    self.currentAlert = nil;
    NSString *msg = @"Note:The password should be 8 characters.";
    self.currentAlert = [UIAlertController alertControllerWithTitle:@"Change Password"
                                                            message:msg
                                                     preferredStyle:UIAlertControllerStyleAlert];
    [self.currentAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        weakSelf.passwordTextField = nil;
        weakSelf.passwordTextField = textField;
        [weakSelf.passwordTextField setPlaceholder:@"Enter new password"];
        [weakSelf.passwordTextField addTarget:weakSelf
                                       action:@selector(passwordTextFieldValueChanged:)
                             forControlEvents:UIControlEventEditingChanged];
    }];
    [self.currentAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        weakSelf.confirmTextField = nil;
        weakSelf.confirmTextField = textField;
        [weakSelf.confirmTextField setPlaceholder:@"Enter new password again"];
        [weakSelf.confirmTextField addTarget:weakSelf
                                      action:@selector(passwordTextFieldValueChanged:)
                            forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [self.currentAlert addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf setPasswordToDevice];
    }];
    [self.currentAlert addAction:moreAction];
    
    [self presentViewController:self.currentAlert animated:YES completion:nil];
}

- (void)passwordTextFieldValueChanged:(UITextField *)textField{
    NSString *tempInputString = textField.text;
    if (!ValidStr(tempInputString)) {
        textField.text = @"";
        return;
    }
    textField.text = (tempInputString.length > 8 ? [tempInputString substringToIndex:8] : tempInputString);
}

- (void)setPasswordToDevice{
    NSString *password = self.passwordTextField.text;
    NSString *confirmpassword = self.confirmTextField.text;
    if (!ValidStr(password) || !ValidStr(confirmpassword) || password.length != 8 || confirmpassword.length != 8) {
        [self.view showCentralToast:@"The password should be 8 characters.Please try again."];
        return;
    }
    if (![password isEqualToString:confirmpassword]) {
        [self.view showCentralToast:@"Password do not match! Please try again."];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKTPInterface tp_configPassword:password sucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 设置按键关机功能
- (void)configButtonOff:(BOOL)enable {
    NSString *contentMsg = @"If you Disable Button Off function, you cannot turn off the beacon power with the button.";
    if (enable) {
        contentMsg = @"If you Enable Button Off function, you can turn off the beacon power with the button.";
    }
    self.currentAlert = nil;
    self.currentAlert = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                            message:contentMsg
                                                     preferredStyle:UIAlertControllerStyleAlert];
    WS(weakSelf);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        MKTextSwitchCellModel *model = weakSelf.section1List[0];
        model.isOn = !enable;
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [self.currentAlert addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf sendButtonOffStateToDevice:enable];
    }];
    [self.currentAlert addAction:moreAction];
    
    [self presentViewController:self.currentAlert animated:YES completion:nil];
}

- (void)sendButtonOffStateToDevice:(BOOL)isOn {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKTPInterface tp_configButtonPowerStatus:isOn sucBlock:^{
        [[MKHudManager share] hide];
        MKTextSwitchCellModel *model = self.section1List[0];
        model.isOn = isOn;
        model.msg = (isOn ? @"Enable Button Off" : @"Disable Button Off");
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        MKTextSwitchCellModel *model = self.section1List[0];
        model.isOn = !isOn;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - 设置可连接性
- (void)configConnectEnable:(BOOL)connect{
    NSString *msg = (connect ? @"Are you sure to make the device connectable?" : @"Are you sure to make the device Unconnectable?");
    self.currentAlert = nil;
    self.currentAlert = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                            message:msg
                                                     preferredStyle:UIAlertControllerStyleAlert];
    WS(weakSelf);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        MKTextSwitchCellModel *model = weakSelf.section1List[1];
        model.isOn = !connect;
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [self.currentAlert addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf setConnectStatusToDevice:connect];
    }];
    [self.currentAlert addAction:moreAction];
    
    [self presentViewController:self.currentAlert animated:YES completion:nil];
}

- (void)setConnectStatusToDevice:(BOOL)connect{
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKTPInterface tp_configConnectableStatus:connect sucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success!"];
        MKTextSwitchCellModel *model = self.section1List[1];
        model.isOn = connect;
        model.msg = (connect ? @"Connectable" : @"Non-connectable");
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        MKTextSwitchCellModel *model = self.section1List[1];
        model.isOn = !connect;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - 设置连接提醒状态
- (void)configConnectionNotificationStatus:(BOOL)isOn {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKTPInterface tp_configConnectionNotificationStatus:isOn sucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success!"];
        MKTextSwitchCellModel *model = self.section1List[2];
        model.isOn = isOn;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        MKTextSwitchCellModel *model = self.section1List[2];
        model.isOn = !isOn;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - 设置低电量报警
- (void)configLowPowerNote {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKTPInterface tp_readLowBatteryReminderRulesWithSucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        [self showLowPowerNoteConfigView:[returnData[@"result"][@"lTwentyInterval"] integerValue] tenValue:[returnData[@"result"][@"lTenInterval"] integerValue] fiveValue:[returnData[@"result"][@"lFiveInterval"] integerValue]];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)showLowPowerNoteConfigView:(NSInteger)twentyValue
                          tenValue:(NSInteger)tenValue
                         fiveValue:(NSInteger)fiveValue {
    [MKTPLowPowerNoteConfigView showViewWithTwentyValue:twentyValue
                                               tenValue:tenValue
                                              fiveValue:fiveValue
                                          completeBlock:^(NSInteger twentyResultValue, NSInteger tenResultValue, NSInteger fiveResultValue) {
        [self sendLowPowerValueToDevice:twentyResultValue tenValue:tenResultValue fiveValue:fiveResultValue];
    }];
}

- (void)sendLowPowerValueToDevice:(NSInteger)twentyValue
                         tenValue:(NSInteger)tenValue
                        fiveValue:(NSInteger)fiveValue {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKTPInterface tp_configLowBatteryReminderRules:twentyValue lowTenInterval:tenValue lowFiveInterval:fiveValue sucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 设置灵敏度
- (void)triggerSensitivityMethod {
    [[MKHudManager share] showHUDWithTitle:@"Reading..."
                                    inView:self.view
                             isPenetration:NO];
    [MKTPInterface tp_readMovementSensitivityWithSucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        NSInteger triggerSen = [returnData[@"result"][@"sensitivity"] integerValue];
        [self showViewWithTriggerSensitivityValue:(triggerSen - 7)];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)showViewWithTriggerSensitivityValue:(NSInteger)value {
    [MKTPTriggerSensitivityView showWithValue:value completeBlock:^(NSInteger resultValue) {
        [self configTriggerSensitivity:resultValue];
    }];
}

- (void)configTriggerSensitivity:(NSInteger)sensitivity {
    [[MKHudManager share] showHUDWithTitle:@"Setting..." inView:self.view isPenetration:NO];
    [MKTPInterface tp_configMovementSensitivity:(sensitivity + 7) sucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 设置按键复位状态
- (void)setButtonResetStatusEnable:(BOOL)isOn{
    NSString *msg = (isOn ? @"If you Enable Button Reset function, you can Reset the beacon power with the button." : @"If you Disable Button Reset function, you cannot Reset the beacon power with the button.");
    self.currentAlert = nil;
    self.currentAlert = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                            message:msg
                                                     preferredStyle:UIAlertControllerStyleAlert];
    WS(weakSelf);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        MKTextSwitchCellModel *model = weakSelf.section3List[0];
        model.isOn = !isOn;
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [self.currentAlert addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf setButtonResetStatusToDevice:isOn];
    }];
    [self.currentAlert addAction:moreAction];
    
    [self presentViewController:self.currentAlert animated:YES completion:nil];
}

- (void)setButtonResetStatusToDevice:(BOOL)isOn{
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKTPInterface tp_configButtonResetStatus:isOn sucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success!"];
        MKTextSwitchCellModel *model = self.section3List[0];
        model.isOn = isOn;
        model.msg = (isOn ? @"Enable Button Reset" : @"Disable Button Reset");
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        MKTextSwitchCellModel *model = self.section3List[0];
        model.isOn = !isOn;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - 开关机
- (void)powerOff{
    NSString *msg = @"Are you sure to turn off the device? Please make sure the device has a button to turn on!";
    self.currentAlert = nil;
    self.currentAlert = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                            message:msg
                                                     preferredStyle:UIAlertControllerStyleAlert];
    WS(weakSelf);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        MKTextSwitchCellModel *model = weakSelf.section3List[1];
        model.isOn = NO;
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [self.currentAlert addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf commandPowerOff];
    }];
    [self.currentAlert addAction:moreAction];
    
    [self presentViewController:self.currentAlert animated:YES completion:nil];
}

- (void)commandPowerOff{
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKTPInterface tp_powerOffDeviceWithSucBlock:^{
        [[MKHudManager share] hide];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        MKTextSwitchCellModel *model = self.section3List[1];
        model.isOn = YES;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - 恢复出厂设置

- (void)factoryReset{
    NSString *msg = @"Please enter the password to reset the device.";
    self.currentAlert = nil;
    self.currentAlert = [UIAlertController alertControllerWithTitle:@"Factory Reset"
                                                            message:msg
                                                     preferredStyle:UIAlertControllerStyleAlert];
    WS(weakSelf);
    [self.currentAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        weakSelf.passwordField = nil;
        weakSelf.passwordField = textField;
        weakSelf.passwordField.placeholder = @"Enter the password.";
        [textField addTarget:weakSelf action:@selector(passwordInput) forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [self.currentAlert addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf sendResetCommandToDevice];
    }];
    [self.currentAlert addAction:moreAction];
    
    [self presentViewController:self.currentAlert animated:YES completion:nil];
}

- (void)passwordInput {
    NSString *tempInputString = self.passwordField.text;
    if (!ValidStr(tempInputString)) {
        self.passwordField.text = @"";
        return;
    }
    self.passwordField.text = (tempInputString.length > 8 ? [tempInputString substringToIndex:8] : tempInputString);
}

- (void)sendResetCommandToDevice{
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKTPInterface tp_factoryDataResetWithPassword:self.passwordField.text sucBlock:^{
        [[MKHudManager share] hide];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - push dfu
- (void)pushDfuPage {
    MKTPUpdateController *vc = [[MKTPUpdateController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
- (void)loadSectionDatas {
    [self loadSecion0Datas];
    [self loadSecion1Datas];
    [self loadSecion2Datas];
    [self loadSecion3Datas];
    [self loadSecion4Datas];
    [self.tableView reloadData];
}

- (void)loadSecion0Datas {
    [self.section0List removeAllObjects];
    
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Change Password";
    cellModel.showRightIcon = YES;
    [self.section0List addObject:cellModel];
}

- (void)loadSecion1Datas {
    [self.section1List removeAllObjects];
    
    MKTextSwitchCellModel *buttonModel = [[MKTextSwitchCellModel alloc] init];
    buttonModel.msg = @"Enable Button Off";
    buttonModel.index = 0;
    [self.section1List addObject:buttonModel];
    
    MKTextSwitchCellModel *connectModel = [[MKTextSwitchCellModel alloc] init];
    connectModel.msg = @"Connectable";
    connectModel.index = 1;
    [self.section1List addObject:connectModel];
    
    MKTextSwitchCellModel *connectNoteModel = [[MKTextSwitchCellModel alloc] init];
    connectNoteModel.msg = @"Connection Notification";
    connectNoteModel.index = 2;
    [self.section1List addObject:connectNoteModel];
}

- (void)loadSecion2Datas {
    [self.section2List removeAllObjects];
    
    MKNormalTextCellModel *lowPowerModel = [[MKNormalTextCellModel alloc] init];
    lowPowerModel.leftMsg = @"Low Power Notification";
    lowPowerModel.showRightIcon = YES;
    [self.section2List addObject:lowPowerModel];
    
    MKNormalTextCellModel *triggerModel = [[MKNormalTextCellModel alloc] init];
    triggerModel.leftMsg = @"Trigger Sensitivity";
    triggerModel.showRightIcon = YES;
    [self.section2List addObject:triggerModel];
}

- (void)loadSecion3Datas {
    [self.section3List removeAllObjects];
    
    MKTextSwitchCellModel *buttonResetModel = [[MKTextSwitchCellModel alloc] init];
    buttonResetModel.msg = @"Disable Button Reset";
    buttonResetModel.index = 3;
    [self.section3List addObject:buttonResetModel];
    
    MKTextSwitchCellModel *powerOffModel = [[MKTextSwitchCellModel alloc] init];
    powerOffModel.msg = @"APP Power Off";
    powerOffModel.index = 4;
    [self.section3List addObject:powerOffModel];
}

- (void)loadSecion4Datas {
    [self.section4List removeAllObjects];
    
    MKNormalTextCellModel *resetModel = [[MKNormalTextCellModel alloc] init];
    resetModel.leftMsg = @"Reset";
    resetModel.showRightIcon = YES;
    [self.section4List addObject:resetModel];
    
    MKNormalTextCellModel *dfuModel = [[MKNormalTextCellModel alloc] init];
    dfuModel.leftMsg = @"OTA DFU";
    dfuModel.showRightIcon = YES;
    [self.section4List addObject:dfuModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"SETTINGS";
    [self.rightButton setHidden:YES];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight - 49.f);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = COLOR_WHITE_MACROS;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)section0List {
    if (!_section0List) {
        _section0List = [NSMutableArray array];
    }
    return _section0List;
}

- (NSMutableArray *)section1List {
    if (!_section1List) {
        _section1List = [NSMutableArray array];
    }
    return _section1List;
}

- (NSMutableArray *)section2List {
    if (!_section2List) {
        _section2List = [NSMutableArray array];
    }
    return _section2List;
}

- (NSMutableArray *)section3List {
    if (!_section3List) {
        _section3List = [NSMutableArray array];
    }
    return _section3List;
}

- (NSMutableArray *)section4List {
    if (!_section4List) {
        _section4List = [NSMutableArray array];
    }
    return _section4List;
}

- (MKTPSettingDataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKTPSettingDataModel alloc] init];
    }
    return _dataModel;
}

@end
