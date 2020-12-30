//
//  MKTextSwitchCell.h
//  MKCustomUIModule_Example
//
//  Created by aa on 2020/12/22.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKTextSwitchCellModel : NSObject

/// 左侧图标
@property (nonatomic, strong)UIImage *leftIcon;

/// 左侧msg
@property (nonatomic, copy)NSString *msg;

/// 左侧msg字体颜色,默认#353535
@property (nonatomic, strong)UIColor *msgColor;

/// 左侧msg字体大小，默认15
@property (nonatomic, strong)UIFont *msgFont;

/// 开关状态
@property (nonatomic, assign)BOOL isOn;

/// 当前cell所在的index
@property (nonatomic, assign)NSInteger index;

@end

@protocol mk_textSwitchCellDelegate <NSObject>

/// 开关状态发生改变了
/// @param isOn 当前开关状态
/// @param index 当前cell所在的index
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index;

@end

@interface MKTextSwitchCell : MKBaseCell

@property (nonatomic, strong)MKTextSwitchCellModel *dataModel;

@property (nonatomic, weak)id <mk_textSwitchCellDelegate>delegate;

+ (MKTextSwitchCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
