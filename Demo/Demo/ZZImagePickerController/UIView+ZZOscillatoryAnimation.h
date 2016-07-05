//
//  UIView+ZZOscillatoryAnimation.h
//  Demo
//
//  Created by 刘威振 on 6/29/16.
//  Copyright © 2016 刘威振. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ZZOscillatoryAnimationToBigger,
    ZZOscillatoryAnimationToSmaller,
} ZZOscillatoryAnimationType;

@interface UIView (ZZOscillatoryAnimation)

+ (void)zz_showOscillatoryAnimationWithLayer:(CALayer *)layer type:(ZZOscillatoryAnimationType)type;

@end
