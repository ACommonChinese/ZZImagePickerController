//
//  ZZImagePickerController.m
//  Demo
//
//  Created by 刘威振 on 16/6/27.
//  Copyright © 2016年 刘威振. All rights reserved.
//

#import "ZZImagePickerController.h"
#import "ZZAlbumPickerController.h"
#import <Photos/Photos.h>
#import "ZZPhotoPickerController.h"
#import "ZZImageManager.h"

#define kNaviBarAndBottonBarBgColor  ([UIColor colorWithRed:(34/255.0) green:(34/255.0) blue:(34/255.0) alpha:1.0])
#define kOKButtonTitleColorNormal    ([UIColor colorWithRed:(83/255.0) green:(179/255.0) blue:(17/255.0) alpha:1.0])
#define kOKButtonTitleColorDisabled  ([UIColor colorWithRed:(83/255.0) green:(179/255.0) blue:(17/255.0) alpha:0.5])
#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)

#pragma mark - ZZImagePickerController

@interface ZZSimpleProgressHUD : UIView

+ (instancetype)progressHUD;
@property (nonatomic) UIActivityIndicatorView *indicatorView;
@end

@implementation ZZSimpleProgressHUD

+ (instancetype)progressHUD {
    CGRect frame                           = [UIScreen mainScreen].bounds;
    ZZSimpleProgressHUD *hud               = [[ZZSimpleProgressHUD alloc] initWithFrame:frame];
    hud.backgroundColor                    = [UIColor clearColor];
    UIView *container                      = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width - 120) / 2.0, (frame.size.height - 90) / 2.0, 120, 90)];
    container.layer.cornerRadius           = 8;
    container.clipsToBounds                = YES;
    container.backgroundColor              = [UIColor darkGrayColor];
    container.alpha                        = 0.7;
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicatorView.frame                    = CGRectMake(45, 15, 30, 30);
    hud.indicatorView                      = indicatorView;
    UILabel *label                         = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 120, 50)];
    label.textAlignment                    = NSTextAlignmentCenter;
    label.text                             = @"正在处理... ";
    label.font                             = [UIFont systemFontOfSize:15.0];
    label.textColor                        = [UIColor whiteColor];
    [container addSubview:indicatorView];
    [container addSubview:label];
    [hud addSubview:container];
    container.center = CGPointMake(frame.size.width / 2.0, frame.size.height / 2.0);
    
    return hud;
}

- (void)show {
    [self.indicatorView startAnimating];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}

- (void)dismiss {
    [self.indicatorView stopAnimating];
    [self removeFromSuperview];
}

@end

// -----------------------------------------------------------------

#pragma mark - ZZImagePickerController

@interface ZZImagePickerController ()

@property (nonatomic) ZZSimpleProgressHUD *progressHUD;
@end

@implementation ZZImagePickerController
@synthesize configure = _configure;

- (instancetype)initWithConfigure:(void (^)(ZZImagePickerConfigure *))configureHandle {
    ZZImagePickerConfigure *configure = self.configure;
    if (configureHandle) {
        configureHandle(configure);
    }
    ZZAlbumPickerController *albumPickerController = [[ZZAlbumPickerController alloc] init];
    self = [super initWithRootViewController:albumPickerController];
    [self userAuthen];
    return self;
}

- (ZZImagePickerConfigure *)configure {
    if (_configure == nil) {
        _configure                   = [[ZZImagePickerConfigure alloc] init];
        _configure.allowPickOriginal = YES;
        _configure.allowPickVideo    = YES;
        _configure.allowMaxCount     = 9;
        // _configure.allowImageAndVideo = NO;
    }
    return _configure;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNivBar];
}

- (void)configNivBar {
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.translucent = YES;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    if (iOS7Later) {
        self.navigationBar.barTintColor = kNaviBarAndBottonBarBgColor;
        self.navigationBar.tintColor = [UIColor whiteColor];
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UIBarButtonItem *barItem;
    if (iOS9Later) {
        barItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[ZZImagePickerController class]]];
    } else {
        barItem = [UIBarButtonItem appearanceWhenContainedIn:[ZZImagePickerController class], nil];
    }
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [barItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
}

// 统一配置返回按钮标题为："返回"
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (iOS7Later) viewController.automaticallyAdjustsScrollViewInsets = NO;
    if (self.childViewControllers.count > 0) {
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(3, 0, 44, 44)];
        [backButton setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        backButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [backButton addTarget:self action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)userAuthen {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusNotDetermined: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    [self authenSuccess];
                } else {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
            break;
        }
        case PHAuthorizationStatusDenied: {
            [self authenFail];
            break;
        }
        case PHAuthorizationStatusAuthorized: {
            [self authenSuccess];
            break;
        }
        default:
            break;
    }
}

- (void)authenSuccess {
    ZZPhotoPickerController *photoController = [[ZZPhotoPickerController alloc] init];
    [[ZZImageManager manager] getCameraRollAlbum:self.configure.allowPickVideo completion:^(ZZAlbumModel *albumModel) {
        if (albumModel) photoController.model = albumModel;
    }];
    [self pushViewController:photoController animated:YES];
}

- (void)authenFail {
    NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *tip = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:tip preferredStyle:UIAlertControllerStyleAlert];
    __weak __typeof(self)weakSelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (ZZSimpleProgressHUD *)progressHUD {
    if (_progressHUD == nil) {
        _progressHUD = [ZZSimpleProgressHUD progressHUD];
    }
    return _progressHUD;
}

- (void)showProgressHUD {
    [self.progressHUD show];
}

- (void)dismissProgressHUD {
    [self.progressHUD dismiss];
}

@end