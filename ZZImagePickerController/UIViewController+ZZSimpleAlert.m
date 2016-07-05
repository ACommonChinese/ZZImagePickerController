//
//  UIViewController+ZZSimpleAlert.m
//  Demo
//
//  Created by 刘威振 on 6/29/16.
//  Copyright © 2016 刘威振. All rights reserved.
//

#import "UIViewController+ZZSimpleAlert.h"

@implementation UIViewController (ZZSimpleAlert)

- (void)zz_showAlertWithTitle:(NSString *)title {
    [self zz_showAlertWithTitle:title message:nil buttonTitle:@"我知道了"];
}

- (void)zz_showAlertWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
