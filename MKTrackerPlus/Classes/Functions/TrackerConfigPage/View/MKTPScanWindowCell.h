//
//  MKTPScanWindowCell.h
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/26.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKTPScanWindowCellModel : NSObject

/// 当前cell所在index
@property (nonatomic, assign)NSInteger index;

/// 左侧msg
@property (nonatomic, copy)NSString *msg;

/// 输入框值
@property (nonatomic, copy)NSString *textValue;

/// 输入框占位符
@property (nonatomic, copy)NSString *placeHolder;

/// 右边x 0.625ms等
@property (nonatomic, copy)NSString *detailMsg;

/// 是否显示底部note
@property (nonatomic, assign)BOOL isNoteMsgCell;

@end

@protocol MKTPScanWindowCellDelegate <NSObject>

/// 输入框发生改变触发代理
/// @param value 当前输入框的值
/// @param index 当前cell所在的index
- (void)mk_scanWindowParamsChanged:(NSString *)value index:(NSInteger)index;

@end

@interface MKTPScanWindowCell : MKBaseCell

@property (nonatomic, strong)MKTPScanWindowCellModel *dataModel;

@property (nonatomic, weak)id <MKTPScanWindowCellDelegate>delegate;

+ (MKTPScanWindowCell *)initCellWithTableView:(UITableView *)tableView;

+ (CGFloat)getCellHeight:(NSString *)noteMsg;

@end

NS_ASSUME_NONNULL_END
