//
//  MKNormalTextCell.h
//  mokoLibrary_Example
//
//  Created by aa on 2020/12/16.
//  Copyright © 2020 Chengang. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNormalTextCellModel : NSObject

/// 左侧的icon，如果不写则左侧不显示
@property (nonatomic, strong)UIImage *leftIcon;

/// 左侧msg字体大小，默认15
@property (nonatomic, strong)UIFont *leftMsgTextFont;

/// 左侧msg字体颜色,默认#353535
@property (nonatomic, strong)UIColor *leftMsgTextColor;

/// 左侧msg
@property (nonatomic, copy)NSString *leftMsg;

/// 右侧msg字体大小，默认13
@property (nonatomic, strong)UIFont *rightMsgTextFont;

/// 右侧msg字体颜色，默认#808080
@property (nonatomic, strong)UIColor *rightMsgTextColor;

/// 右侧msg
@property (nonatomic, copy)NSString *rightMsg;

/// 是否显示右侧的箭头
@property (nonatomic, assign)BOOL showRightIcon;

/// 点击cell之后触发的方法，选填
@property (nonatomic, copy)NSString *methodName;

@end

@interface MKNormalTextCell : MKBaseCell

+ (MKNormalTextCell *)initCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)MKNormalTextCellModel *dataModel;

@end

NS_ASSUME_NONNULL_END
