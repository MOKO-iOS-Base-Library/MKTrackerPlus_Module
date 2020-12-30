//
//  MKCustomUIAdopter.m
//  MKCustomUIModule_Example
//
//  Created by aa on 2020/12/21.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKCustomUIAdopter.h"

#import "MKMacroDefines.h"

@implementation MKCustomUIAdopter

+ (UIButton *)customButtonWithTitle:(NSString *)title
                         titleColor:(UIColor *)titleColor
                    backgroundColor:(UIColor *)backgroundColor
                             target:(nonnull id)target
                             action:(nonnull SEL)action {
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customButton setTitle:title forState:UIControlStateNormal];
    [customButton setTitleColor:titleColor forState:UIControlStateNormal];
    [customButton setBackgroundColor:backgroundColor];
    [customButton.layer setMasksToBounds:YES];
    [customButton.layer setCornerRadius:6.f];
    [customButton addTarget:target
                     action:action
           forControlEvents:UIControlEventTouchUpInside];
    return customButton;
}

+ (NSMutableAttributedString *)attributedString:(NSArray <NSString *>*)strings
                                          fonts:(NSArray <NSFont *>*)fonts
                                         colors:(NSArray <UIColor *>*)colors {
    if (!ValidArray(strings) || !ValidArray(fonts) || !ValidArray(colors)) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    if (strings.count != fonts.count || strings.count != colors.count || fonts.count != colors.count) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    NSString *sourceString = @"";
    for (NSString *str in strings) {
        sourceString = [sourceString stringByAppendingString:str];
    }
    if (sourceString.length == 0) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithString:sourceString];
    CGFloat originPostion = 0;
    for (NSInteger i = 0; i < [strings count]; i ++) {
        NSString *tempString = strings[i];
        [resultString addAttribute:NSForegroundColorAttributeName
                             value:(id)colors[i]
                             range:NSMakeRange(originPostion, tempString.length)];
        [resultString addAttribute:NSFontAttributeName
                             value:(id)fonts[i]
                             range:NSMakeRange(originPostion, tempString.length)];
        originPostion += tempString.length;
    }
    return resultString;
}

+ (CABasicAnimation *)refreshAnimation:(NSTimeInterval)duration {
    CABasicAnimation *transformAnima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    transformAnima.duration = duration;
    transformAnima.fromValue = @(0);
    transformAnima.toValue = @(2 * M_PI);
    transformAnima.autoreverses = NO;
    transformAnima.repeatCount = MAXFLOAT;
    transformAnima.removedOnCompletion = NO;
    return transformAnima;
}

@end