//
//  MKTextFieldCell.h
//  mokoLibrary_Example
//
//  Created by aa on 2020/12/16.
//  Copyright © 2020 Chengang. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

#import <MKCustomUIModule/MKTextField.h>

/*
 如果想要键盘取消第一响应者，则需要发出MKTextFieldNeedHiddenKeyboard通知即可
 [[NSNotificationCenter defaultCenter] postNotificationName:@"MKTextFieldNeedHiddenKeyboard" object:nil];
 */

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, mk_textFieldCellType) {
    mk_textFieldCell_normalType,                //带边框的
    mk_textFieldCell_topLineType,               //顶部类似于阴影的输入框
};

@interface MKTextFieldCellModel : NSObject


/// 当前index，textField内容发生改变的时候，会连同textField值和该index一起回调，可以用来标示当前是哪个cell的回调事件
@property (nonatomic, assign)NSInteger index;

#pragma mark - 右侧标签

/// 最右侧的单位标签，如果该项为空则表示没有单位
@property (nonatomic, copy)NSString *unit;

/// 右侧单位标签字体颜色，默认默认#353535
@property (nonatomic, strong)UIColor *unitColor;

/// 右侧单位标签字体大小,默认13
@property (nonatomic, strong)UIFont *unitFont;

#pragma mark - 左侧label配置

/// 左侧msg
@property (nonatomic, copy)NSString *msg;

/// 左侧msg字体颜色,默认#353535
@property (nonatomic, strong)UIColor *msgColor;

/// 左侧msg字体大小，默认15
@property (nonatomic, strong)UIFont *msgFont;

#pragma mark - textField配置

/// mk_textFieldCell_topLineType类型的时候，borderColor不起作用
@property (nonatomic, assign)mk_textFieldCellType cellType;

/// 当前textField的值
@property (nonatomic, copy)NSString *textFieldValue;

/// textField的占位符
@property (nonatomic, copy)NSString *textPlaceholder;

/// 输入框文本位置
@property (nonatomic, assign)NSTextAlignment textAlignment;

/// 输入框的字体颜色,默认#353535
@property (nonatomic, strong)UIColor *textFieldTextColor;

/// 输入框的字体大小,默认15
@property (nonatomic, strong)UIFont *textFieldTextFont;

/// 当前textField的输入类型
@property (nonatomic, assign)mk_textFieldType textFieldType;

/// textField的最大输入长度,对于textFieldType == mk_uuidMode无效
@property (nonatomic, assign)NSInteger maxLength;

@property (nonatomic, assign)UITextFieldViewMode  clearButtonMode;

/// textField边框颜色,cellType=mk_textFieldCell_topLineType类型的时候，borderColor不起作用
@property (nonatomic, strong)UIColor *borderColor;

@end

@protocol MKTextFieldCellDelegate <NSObject>

/// textField内容发送改变时的回调事件
/// @param index 当前cell所在的index
/// @param value 当前textField的值
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value;

@end

@interface MKTextFieldCell : MKBaseCell

@property (nonatomic, strong)MKTextFieldCellModel *dataModel;

@property (nonatomic, weak)id <MKTextFieldCellDelegate>delegate;

+ (MKTextFieldCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
