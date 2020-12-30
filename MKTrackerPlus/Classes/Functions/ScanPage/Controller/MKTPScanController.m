//
//  MKTPScanController.m
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/24.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKTPScanController.h"

#import "Masonry.h"

#import "NSObject+YYModel.h"

#import "UIViewController+HHTransition.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKSearchButton.h"
#import "MKSearchConditionsView.h"
#import "MKCustomUIAdopter.h"
#import "MKTrackerAboutController.h"

#import "MKTPSDK.h"
#import "MKTPDeviceTypeManager.h"
#import "MKTPDatabaseManager.h"

#import "MKTPTrackerModel.h"
#import "MKTPScanPageCell.h"

#import "MKTPTabBarController.h"
#import "MKTPUpdateController.h"

@interface MKTPAboutPageModel : NSObject<MKTrackerAboutParamsProtocol>

/// 导航栏标题,默认@"ABOUT"
@property (nonatomic, copy)NSString *title;

/// 导航栏title颜色，默认白色
@property (nonatomic, strong)UIColor *titleColor;

/// 顶部导航栏背景颜色，默认蓝色
@property (nonatomic, strong)UIColor *titleBarColor;

/// 最上面那个关于的icon
@property (nonatomic, strong)UIImage *aboutIcon;

/// 底部背景图片
@property (nonatomic, strong)UIImage *bottomBackIcon;

/// 要显示的app名字，如果不填，则默认显示当前工程的app名称
@property (nonatomic, copy)NSString *appName;

/// app当前版本，如果不填，则默认取当前工程的版本号
@property (nonatomic, copy)NSString *appVersion;

@end

@implementation MKTPAboutPageModel
@end

static CGFloat const searchButtonHeight = 40.f;

static NSTimeInterval const kRefreshInterval = 0.5f;

@interface MKTPScanController ()<UITableViewDelegate,
UITableViewDataSource,
mk_tp_centralManagerScanDelegate,
MKTPScanPageCellDelegate,
MKSearchButtonDelegate,
MKTPTabBarControllerDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)MKSearchButtonDataModel *buttonModel;

@property (nonatomic, strong)MKSearchButton *searchButton;

@property (nonatomic, strong)UIImageView *circleIcon;

/**
 数据源
 */
@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)dispatch_source_t scanTimer;

/// 当左侧按钮停止扫描的时候,currentScanStatus = NO,开始扫描的时候currentScanStatus=YES
@property (nonatomic, assign)BOOL currentScanStatus;

/// 定时刷新
@property (nonatomic, assign)CFRunLoopObserverRef observerRef;
//扫描到新的设备不能立即刷新列表，降低刷新频率
@property (nonatomic, assign)BOOL isNeedRefresh;

@property (nonatomic, strong)UITextField *passwordField;

@end

@implementation MKTPScanController

- (void)dealloc {
    NSLog(@"MKTPScanController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //移除runloop的监听
    CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), self.observerRef, kCFRunLoopCommonModes);
    [MKTPCentralManager removeFromCentralList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    self.searchButton.dataModel = self.buttonModel;
    [self runloopObserver];
    [MKTPCentralManager shared].delegate = self;
    [self performSelector:@selector(showCentralStatus) withObject:nil afterDelay:.5f];
}

#pragma mark - super method
- (void)leftButtonMethod {
    if ([MKTPCentralManager shared].centralStatus != MKCentralManagerStateEnable) {
        [self.view showCentralToast:@"The current system of bluetooth is not available!"];
        return;
    }
    self.leftButton.selected = !self.leftButton.selected;
    self.currentScanStatus = self.leftButton.selected;
    [self.circleIcon.layer removeAnimationForKey:@"mk_refreshAnimationKey"];
    if (!self.leftButton.isSelected) {
        //停止扫描
        [[MKTPCentralManager shared] stopScan];
        if (self.scanTimer) {
            dispatch_cancel(self.scanTimer);
        }
        return;
    }
    [self.dataList removeAllObjects];
    [self.tableView reloadData];
    //刷新顶部设备数量
    [self.titleLabel setText:[NSString stringWithFormat:@"DEVICE(%@)",[NSString stringWithFormat:@"%ld",(long)self.dataList.count]]];
    [self.circleIcon.layer addAnimation:[MKCustomUIAdopter refreshAnimation:2.f] forKey:@"mk_refreshAnimationKey"];
    [self scanTimerRun];
}

- (void)rightButtonMethod {
    MKTPAboutPageModel *model = [[MKTPAboutPageModel alloc] init];
    model.aboutIcon = LOADICON(@"MKTrackerPlus", @"MKTPScanController", @"tp_aboutIcon.png");
    model.appName = @"MokoTracker+";
    model.appVersion = @"1.0.0";
    MKTrackerAboutController *vc = [[MKTrackerAboutController alloc] initWithProtocol:model];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MKTPScanPageCell *cell = [MKTPScanPageCell initCellWithTableView:self.tableView];
    cell.dataModel = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 175.f;
}

#pragma mark - MKSearchButtonDelegate
- (void)mk_scanSearchButtonMethod {
    [MKSearchConditionsView showSearchKey:self.buttonModel.searchKey rssi:self.buttonModel.searchRssi minRssi:-100 searchBlock:^(NSString * _Nonnull searchKey, NSInteger searchRssi) {
        self.buttonModel.searchRssi = searchRssi;
        self.buttonModel.searchKey = searchKey;
        self.searchButton.dataModel = self.buttonModel;
        
        self.leftButton.selected = NO;
        self.currentScanStatus = NO;
        [self leftButtonMethod];
    }];
}

- (void)mk_scanSearchButtonClearMethod {
    self.buttonModel.searchRssi = -100;
    self.buttonModel.searchKey = @"";
    self.leftButton.selected = NO;
    self.currentScanStatus = NO;
    [self leftButtonMethod];
}

#pragma mark - mk_tp_centralManagerScanDelegate
- (void)mk_tp_receiveDevice:(NSDictionary *)trackerModel {
    MKTPTrackerModel *model = [MKTPTrackerModel modelWithJSON:trackerModel];
    [self updateDataWithTrackerModel:model];
}

- (void)mk_tp_stopScan {
    //如果是左上角在动画，则停止动画
    if (self.leftButton.isSelected) {
        [self.circleIcon.layer removeAnimationForKey:@"mk_refreshAnimationKey"];
        [self.leftButton setSelected:NO];
    }
}

#pragma mark - MKTPScanPageCellDelegate
- (void)tp_scanCellConnectButtonPressed:(NSInteger)index {
    [self connectDeviceWithModel:self.dataList[index]];
}

#pragma mark - MKTPTabBarControllerDelegate
- (void)mk_needResetScanDelegate:(BOOL)need {
    if (need) {
        [MKTPCentralManager shared].delegate = self;
    }
    [self performSelector:@selector(startScanDevice) withObject:nil afterDelay:(need ? 1.f : 0.1f)];
}

#pragma mark - notice method

- (void)showCentralStatus{
    if ([MKTPCentralManager shared].centralStatus != MKCentralManagerStateEnable) {
        NSString *msg = @"The current system of bluetooth is not available!";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Dismiss"
                                                                                 message:msg
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:moreAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    [self leftButtonMethod];
}

#pragma mark - 刷新
- (void)startScanDevice {
    self.leftButton.selected = NO;
    self.currentScanStatus = NO;
    [self leftButtonMethod];
}

- (void)scanTimerRun{
    if (self.scanTimer) {
        dispatch_cancel(self.scanTimer);
    }
    [[MKTPCentralManager shared] startScan];
    self.scanTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_global_queue(0, 0));
    //开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 60 * NSEC_PER_SEC);
    //间隔时间
    uint64_t interval = 60 * NSEC_PER_SEC;
    dispatch_source_set_timer(self.scanTimer, start, interval, 0);
    WS(weakSelf);
    dispatch_source_set_event_handler(self.scanTimer, ^{
        [[MKTPCentralManager shared] stopScan];
        [weakSelf needRefreshList];
    });
    dispatch_resume(self.scanTimer);
}

- (void)needRefreshList {
    //标记需要刷新
    self.isNeedRefresh = YES;
    //唤醒runloop
    CFRunLoopWakeUp(CFRunLoopGetMain());
}

- (void)runloopObserver {
    WS(weakSelf);
    __block NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    self.observerRef = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        if (activity == kCFRunLoopBeforeWaiting) {
            //runloop空闲的时候刷新需要处理的列表,但是需要控制刷新频率
            NSTimeInterval currentInterval = [[NSDate date] timeIntervalSince1970];
            if (currentInterval - timeInterval < kRefreshInterval) {
                return;
            }
            timeInterval = currentInterval;
            if (weakSelf.isNeedRefresh) {
                [weakSelf.tableView reloadData];
                [weakSelf.titleLabel setText:[NSString stringWithFormat:@"DEVICE(%@)",[NSString stringWithFormat:@"%ld",(long)weakSelf.dataList.count]]];
                weakSelf.isNeedRefresh = NO;
            }
        }
    });
    //添加监听，模式为kCFRunLoopCommonModes
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), self.observerRef, kCFRunLoopCommonModes);
}

- (void)updateDataWithTrackerModel:(MKTPTrackerModel *)trackerModel{
    if (ValidStr(self.buttonModel.searchKey)) {
        //过滤设备名字和mac地址
        [self filterTrackerDataWithSearchName:trackerModel];
        return;
    }
    if (self.buttonModel.searchRssi > self.buttonModel.minSearchRssi) {
        //开启rssi过滤
        if (trackerModel.rssi >= self.buttonModel.searchRssi) {
            [self processTrackerData:trackerModel];
        }
        return;
    }
    [self processTrackerData:trackerModel];
}

/**
 通过设备名称和mac地址过滤设备，这个时候肯定开启了rssi
 
 @param trackerModel 设备
 */
- (void)filterTrackerDataWithSearchName:(MKTPTrackerModel *)trackerModel{
    if (trackerModel.rssi < self.buttonModel.searchRssi) {
        return;
    }
    if ([[trackerModel.deviceName uppercaseString] containsString:[self.buttonModel.searchKey uppercaseString]]
        || [[trackerModel.macAddress uppercaseString] containsString:[self.buttonModel.searchKey uppercaseString]]) {
        //如果mac地址和设备名称包含搜索条件，则加入
        [self processTrackerData:trackerModel];
    }
}

- (void)processTrackerData:(MKTPTrackerModel *)trackerModel{
    //查看数据源中是否已经存在相关设备
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"macAddress == %@", trackerModel.macAddress];
    NSArray *array = [self.dataList filteredArrayUsingPredicate:predicate];
    BOOL contain = ValidArray(array);
    if (contain) {
        //如果是已经存在了，替换
        [self dataExistDataSource:trackerModel];
        return;
    }
    //不存在，则加入
    [self dataNoExistDataSource:trackerModel];
}

/**
 将扫描到的设备加入到数据源
 
 @param trackerModel 扫描到的设备
 */
- (void)dataNoExistDataSource:(MKTPTrackerModel *)trackerModel{
    [self.dataList addObject:trackerModel];
    trackerModel.index = (self.dataList.count - 1);
    trackerModel.scanTime = @"N/A";
    trackerModel.lastScanDate = kSystemTimeStamp;
    [self needRefreshList];
}

/**
 如果是已经存在了，直接替换
 
 @param trackerModel  新扫描到的数据帧
 */
- (void)dataExistDataSource:(MKTPTrackerModel *)trackerModel {
    NSInteger currentIndex = 0;
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKTPTrackerModel *dataModel = self.dataList[i];
        if ([dataModel.macAddress isEqualToString:trackerModel.macAddress]) {
            currentIndex = i;
            break;
        }
    }
    MKTPTrackerModel *dataModel = self.dataList[currentIndex];
    trackerModel.scanTime = [NSString stringWithFormat:@"%@%ld%@",@"<->",(long)([kSystemTimeStamp integerValue] - [dataModel.lastScanDate integerValue]) * 1000,@"ms"];
    trackerModel.lastScanDate = kSystemTimeStamp;
    trackerModel.index = currentIndex;
    [self.dataList replaceObjectAtIndex:currentIndex withObject:trackerModel];
    [self needRefreshList];
}

#pragma mark - 连接部分
- (void)connectDeviceWithModel:(MKTPTrackerModel *)trackerModel {
    //停止扫描
    [self.circleIcon.layer removeAnimationForKey:@"mk_refreshAnimationKey"];
    [[MKTPCentralManager shared] stopScan];
    if (self.scanTimer) {
        dispatch_cancel(self.scanTimer);
    }
    NSString *msg = @"Please enter connection password.";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter password"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    WS(weakSelf);
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        weakSelf.passwordField = nil;
        weakSelf.passwordField = textField;
        if (ValidStr([MKTPDeviceTypeManager shared].password)) {
            textField.text = [MKTPDeviceTypeManager shared].password;
        }
        weakSelf.passwordField.placeholder = @"The password is 8 characters.";
        [textField addTarget:self action:@selector(passwordInput) forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.leftButton.selected = NO;
        weakSelf.currentScanStatus = NO;
        [weakSelf leftButtonMethod];
    }];
    [alertController addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf connectDeviceWithTrackerModel:trackerModel];
    }];
    [alertController addAction:moreAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)connectDeviceWithTrackerModel:(MKTPTrackerModel *)trackerModel {
    NSString *password = self.passwordField.text;
    if (password.length != 8) {
        [self.view showCentralToast:@"The password should be 8 characters."];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Connecting..." inView:self.view isPenetration:NO];
    [[MKTPDeviceTypeManager shared] connectPeripheral:trackerModel.peripheral password:password completeBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        if (error) {
            [self.view showCentralToast:error.userInfo[@"errorInfo"]];
            [self connectFailed];
            return ;
        }
        if (trackerModel.isTrackerPlus) {
            //对于V2版本固件来说，进入通用设置页面
            [self.view showCentralToast:@"Time sync completed!"];
            [MKTPDatabaseManager clearDataTable];
            [MKTPDatabaseManager initStepDataBase];
            [self performSelector:@selector(pushTabBarPage) withObject:nil afterDelay:0.6f];
        }else {
            //对于V1版本固件来说，需要进入dfu升级页面
            MKTPUpdateController *vc = [[MKTPUpdateController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)pushTabBarPage {
    MKTPTabBarController *vc = [[MKTPTabBarController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    WS(weakSelf);
    [self hh_presentViewController:vc presentStyle:HHPresentStyleErected completion:^{
        __strong typeof(self) sself = weakSelf;
        vc.delegate = sself;
    }];
}

- (void)connectFailed {
    self.leftButton.selected = NO;
    self.currentScanStatus = NO;
    [self leftButtonMethod];
}

/**
 监听输入的密码
 */
- (void)passwordInput{
    NSString *tempInputString = self.passwordField.text;
    if (!ValidStr(tempInputString)) {
        self.passwordField.text = @"";
        return;
    }
    self.passwordField.text = (tempInputString.length > 8 ? [tempInputString substringToIndex:8] : tempInputString);
}

#pragma mark - UI
- (void)loadSubViews {
    [self.view setBackgroundColor:RGBCOLOR(237, 243, 250)];
    
    [self.leftButton setImage:nil forState:UIControlStateNormal];
    [self.leftButton addSubview:self.circleIcon];
    [self.circleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.leftButton.mas_centerX);
        make.width.mas_equalTo(22.f);
        make.centerY.mas_equalTo(self.leftButton.mas_centerY);
        make.height.mas_equalTo(22.f);
    }];
    
    [self.rightButton setImage:LOADICON(@"MKTrackerPlus", @"MKTPScanController", @"tp_scanRightAboutIcon.png") forState:UIControlStateNormal];
    
    self.titleLabel.text = @"DEVICE(0)";
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = RGBCOLOR(237, 243, 250);
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.height.mas_equalTo(searchButtonHeight + 2 * 15.f);
    }];
    
    [topView addSubview:self.searchButton];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(searchButtonHeight);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(topView.mas_bottom);
        make.bottom.mas_equalTo(-VirtualHomeHeight - 5.f);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = COLOR_WHITE_MACROS;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.borderColor = COLOR_CLEAR_MACROS.CGColor;
        _tableView.layer.cornerRadius = 6.f;
    }
    return _tableView;
}

- (UIImageView *)circleIcon{
    if (!_circleIcon) {
        _circleIcon = [[UIImageView alloc] init];
        _circleIcon.image = LOADICON(@"MKTrackerPlus", @"MKTPScanController", @"tp_scan_refreshIcon.png");
    }
    return _circleIcon;
}

- (MKSearchButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [[MKSearchButton alloc] init];
        _searchButton.delegate = self;
    }
    return _searchButton;
}

- (MKSearchButtonDataModel *)buttonModel {
    if (!_buttonModel) {
        _buttonModel = [[MKSearchButtonDataModel alloc] init];
        _buttonModel.placeholder = @"Edit Filter";
        _buttonModel.minSearchRssi = -100;
        _buttonModel.searchRssi = -100;
    }
    return _buttonModel;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (UIView *)topView {
    UIView *topView = [[UIView alloc] init];
    
    [topView addSubview:self.searchButton];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(40.f);
    }];
    return topView;
}

@end
