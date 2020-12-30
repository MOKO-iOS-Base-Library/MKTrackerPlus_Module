//
//  MKTPTriggerSensitivityView.h
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/29.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKTPTriggerSensitivityView : UIView

/// showView
/// @param value 当前slider的值
/// @param block slider值发生改变时候的回调
+ (void)showWithValue:(NSInteger)value
        completeBlock:(void (^)(NSInteger resultValue))block;

@end

NS_ASSUME_NONNULL_END
