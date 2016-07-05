//
//  UIView+ZZOscillatoryAnimation.m
//  Demo
//
//  Created by 刘威振 on 6/29/16.
//  Copyright © 2016 刘威振. All rights reserved.
//

#import "UIView+ZZOscillatoryAnimation.h"

@implementation UIView (ZZOscillatoryAnimation)

+ (void)zz_showOscillatoryAnimationWithLayer:(CALayer *)layer type:(ZZOscillatoryAnimationType)type {
    NSNumber *animationScale1 = type == ZZOscillatoryAnimationToBigger ? @(1.15) : @(0.5);
    NSNumber *animationScale2 = type == ZZOscillatoryAnimationToBigger ? @(0.92) : @(1.15);
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        [layer setValue:animationScale1 forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            [layer setValue:animationScale2 forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                [layer setValue:@(1.0) forKeyPath:@"transform.scale"];
            } completion:nil];
        }];
    }];
}

@end
