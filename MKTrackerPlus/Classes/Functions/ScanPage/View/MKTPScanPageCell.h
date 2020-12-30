//
//  MKTPScanPageCell.h
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/24.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKTPScanPageCellDelegate <NSObject>

/// 连接按钮点击事件
/// @param index 当前cell的row
- (void)tp_scanCellConnectButtonPressed:(NSInteger)index;

@end

@class MKTPTrackerModel;
@interface MKTPScanPageCell : MKBaseCell

@property (nonatomic, strong)MKTPTrackerModel *dataModel;

@property (nonatomic, weak)id <MKTPScanPageCellDelegate>delegate;

+ (MKTPScanPageCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
