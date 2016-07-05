//
//  UIViewController+ZZSimpleAlert.h
//  Demo
//
//  Created by 刘威振 on 6/29/16.
//  Copyright © 2016 刘威振. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ZZSimpleAlert)

- (void)zz_showAlertWithTitle:(NSString *)title;
- (void)zz_showAlertWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle;

@end
