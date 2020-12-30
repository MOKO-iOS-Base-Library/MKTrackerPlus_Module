//
//  MKTPAdvertiserController.m
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/26.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKTPAdvertiserController.h"

#import "Masonry.h"
#import "MLInputDodger.h"

#import "MKBaseTableView.h"
#import "MKTextFieldCell.h"
#import "MKMeasureTxPowerCell.h"
#import "MKMacroDefines.h"
#import "MKHudManager.h"
#import "UIView+MKAdd.h"

#import "MKBLEBaseSDKAdopter.h"

#import "MKTPDeviceTypeManager.h"

#import "MKTPAdvertiserDataModel.h"
#import "MKTPAdvTriggerCell.h"

@interface MKTPAdvertiserController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextFieldCellDelegate,
MKMeasureTxPowerCellDelegate,
MKTPAdvTriggerCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)MKTPAdvertiserDataModel *dataModel;

@property (nonatomic, strong)UIAlertController *currentAlert;

@end

@implementation MKTPAdvertiserController

- (void)dealloc {
    NSLog(@"MKTPAdvertiserController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
    [self readDataFromDevice];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(needDismissAlert)
                                                 name:@"mk_tp_settingPageNeedDismissAlert"
                                               object:nil];
}

#pragma mark - super method
- (void)leftButtonMethod {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_tp_popToRootViewControllerNotification" object:nil];
}

- (void)rightButtonMethod {
    if (![self validConfigParams]) {
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Setting..." inView:self.view isPenetration:NO];
    WS(weakSelf);
    [self.dataModel startConfigWithSucBlock:^{
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:@"Saved Successfully!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60.f;
    }
    if (indexPath.section == 1) {
        return 120.f;
    }
    return 130.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ([MKTPDeviceTypeManager shared].supportAdvTrigger ? 3 : 2);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    return self.section2List.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 1) {
        MKMeasureTxPowerCell *cell = [MKMeasureTxPowerCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKTPAdvTriggerCell *cell = [MKTPAdvTriggerCell initCellWithTableView:tableView];
    cell.dataModel = self.section2List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKTextFieldCellDelegate
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        //BLE Name
        self.dataModel.deviceName = value;
        return;
    }
    if (index == 1) {
        //UUID
        self.dataModel.proximityUUID = value;
        return;
    }
    if (index == 2) {
        //Major
        self.dataModel.major = value;
        return;
    }
    if (index == 3) {
        //Minor
        self.dataModel.minor = value;
        return;
    }
    if (index == 4) {
        //ADV Interval
        self.dataModel.interval = value;
        return;
    }
}

#pragma mark - MKMeasureTxPowerCellDelegate
- (void)mk_measureTxPowerCell_measurePowerValueChanged:(NSString *)measurePower {
    self.dataModel.measurePower = measurePower;
}

- (void)mk_measureTxPowerCell_txPowerValueChanged:(mk_deviceTxPower)txPower {
    self.dataModel.txPower = txPower;
}

#pragma mark - MKTPAdvTriggerCellDelegate
- (void)mk_advTriggerTimeChanged:(NSString *)advTime {
    self.dataModel.advTriggerTime = advTime;
}

- (void)mk_advTriggerStatusChanged:(BOOL)isOn {
    self.dataModel.advTriggerIsOn = isOn;
}

#pragma mark - note
- (void)needDismissAlert {
    if (self.currentAlert && (self.presentedViewController == self.currentAlert)) {
        [self.currentAlert dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - interface
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    WS(weakSelf);
    [self.dataModel startReadWithSucBlock:^{
        [[MKHudManager share] hide];
        [weakSelf processCellDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)processCellDatas {
    MKTextFieldCellModel *advNameModel = self.section0List[0];
    advNameModel.textFieldValue = self.dataModel.deviceName;
    
    MKTextFieldCellModel *uuidModel = self.section0List[1];
    uuidModel.textFieldValue = self.dataModel.proximityUUID;
    
    MKTextFieldCellModel *majorModel = self.section0List[2];
    majorModel.textFieldValue = self.dataModel.major;
    
    MKTextFieldCellModel *minorModel = self.section0List[3];
    minorModel.textFieldValue = self.dataModel.minor;
    
    MKTextFieldCellModel *advIntervalModel = self.section0List[4];
    advIntervalModel.textFieldValue = self.dataModel.interval;
    
    MKMeasureTxPowerCellModel *measureModel = self.section1List[0];
    measureModel.measurePower = [self.dataModel.measurePower floatValue];
    measureModel.txPower = self.dataModel.txPower;
    
    if ([MKTPDeviceTypeManager shared].supportAdvTrigger) {
        MKTPAdvTriggerCellModel *triggerModel = self.section2List[0];
        triggerModel.isOn = self.dataModel.advTriggerIsOn;
        triggerModel.advTriggerTime = self.dataModel.advTriggerTime;
    }
    [self.tableView reloadData];
}

#pragma mark -
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    if ([MKTPDeviceTypeManager shared].supportAdvTrigger) {
        [self loadSection2Datas];
    }
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    [self.section0List removeAllObjects];
    
    MKTextFieldCellModel *advNameModel = [[MKTextFieldCellModel alloc] init];
    advNameModel.msg = @"BLE Name";
    advNameModel.textPlaceholder = @"1~10 Characters";
    advNameModel.maxLength = 10;
    advNameModel.textFieldType = mk_normal;
    advNameModel.index = 0;
    [self.section0List addObject:advNameModel];
    
    MKTextFieldCellModel *uuidModel = [[MKTextFieldCellModel alloc] init];
    uuidModel.msg = @"UUID";
    uuidModel.textPlaceholder = @"16 Bytes";
    uuidModel.textFieldType = mk_uuidMode;
    uuidModel.maxLength = 36;
    uuidModel.index = 1;
    [self.section0List addObject:uuidModel];
    
    MKTextFieldCellModel *majorModel = [[MKTextFieldCellModel alloc] init];
    majorModel.msg = @"Major";
    majorModel.textPlaceholder = @"0~65535";
    majorModel.maxLength = 5;
    majorModel.textFieldType = mk_realNumberOnly;
    majorModel.index = 2;
    [self.section0List addObject:majorModel];
    
    MKTextFieldCellModel *minorModel = [[MKTextFieldCellModel alloc] init];
    minorModel.msg = @"Minor";
    minorModel.textPlaceholder = @"0~65535";
    minorModel.maxLength = 5;
    minorModel.textFieldType = mk_realNumberOnly;
    minorModel.index = 3;
    [self.section0List addObject:minorModel];
    
    MKTextFieldCellModel *advIntervalModel = [[MKTextFieldCellModel alloc] init];
    advIntervalModel.msg = @"ADV Interval";
    advIntervalModel.textPlaceholder = @"1~100";
    advIntervalModel.maxLength = 3;
    advIntervalModel.textFieldType = mk_realNumberOnly;
    advIntervalModel.unit = @"x 100ms";
    advIntervalModel.index = 4;
    [self.section0List addObject:advIntervalModel];
}

- (void)loadSection1Datas {
    [self.section1List removeAllObjects];
    MKMeasureTxPowerCellModel *cellModel = [[MKMeasureTxPowerCellModel alloc] init];
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    [self.section2List removeAllObjects];
    MKTPAdvTriggerCellModel *cellModel = [[MKTPAdvTriggerCellModel alloc] init];
    [self.section2List addObject:cellModel];
}

#pragma mark - config
- (BOOL)validConfigParams {
    if (!ValidStr(self.dataModel.deviceName) || self.dataModel.deviceName.length > 10) {
        [self showParamsErrorAlert];
        return NO;
    }
    if (![MKBLEBaseSDKAdopter isUUIDString:self.dataModel.proximityUUID]) {
        [self showParamsErrorAlert];
        return NO;
    }
    if (!ValidStr(self.dataModel.major) || [self.dataModel.major integerValue] < 0 || [self.dataModel.major integerValue] > 65535) {
        [self showParamsErrorAlert];
        return NO;
    }
    if (!ValidStr(self.dataModel.minor) || [self.dataModel.minor integerValue] < 0 || [self.dataModel.minor integerValue] > 65535) {
        [self showParamsErrorAlert];
        return NO;
    }
    if (!ValidStr(self.dataModel.interval) || [self.dataModel.interval integerValue] < 1 || [self.dataModel.interval integerValue] > 100) {
        [self showParamsErrorAlert];
        return NO;
    }
    if ([MKTPDeviceTypeManager shared].supportAdvTrigger) {
        if (self.dataModel.advTriggerIsOn && (!ValidStr(self.dataModel.advTriggerTime) || [self.dataModel.advTriggerTime integerValue] < 1 || [self.dataModel.advTriggerTime integerValue] > 65535)) {
            [self showParamsErrorAlert];
            return NO;
        }
    }
    
    return YES;
}

- (void)showParamsErrorAlert {
    NSString *msg = @"Opps! Save failed. Please check the input characters and try again.";
    self.currentAlert = nil;
    self.currentAlert = [UIAlertController alertControllerWithTitle:@""
                                                            message:msg
                                                     preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [self.currentAlert addAction:moreAction];
    [self presentViewController:self.currentAlert animated:YES completion:nil];
}

- (void)showSaveSuccessAlert {
    NSString *msg = @"Saved Successfully!";
    self.currentAlert = nil;
    self.currentAlert = [UIAlertController alertControllerWithTitle:@""
                                                            message:msg
                                                     preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [self.currentAlert addAction:moreAction];
    [self presentViewController:self.currentAlert animated:YES completion:nil];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"ADVERTISING";
    [self.rightButton setImage:LOADICON(@"MKTrackerPlus", @"MKTPAdvertiserController", @"tp_slotSaveIcon.png") forState:UIControlStateNormal];
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

- (MKTPAdvertiserDataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKTPAdvertiserDataModel alloc] init];
    }
    return _dataModel;
}

@end
