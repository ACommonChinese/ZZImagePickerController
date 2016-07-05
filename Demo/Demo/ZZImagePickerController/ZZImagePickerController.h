//
//  ZZImagePickerController.h
//  Demo
//
//  Created by 刘威振 on 16/6/27.
//  Copyright © 2016年 刘威振. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "ZZImagePickerConfigure.h"

@class ZZImagePickerController;

#pragma mark - protocol
@protocol ZZImagePickerControllerDelegate <NSObject>
@optional
// The picker does not dismiss itself; the client dismisses it in these callbacks.
// Assets will be a empty array if user not picking original photo.
// 这个照片选择器不会自己dismiss，用户dismiss这个选择器的时候，会走下面的回调
// 如果用户没有选择发送原图,Assets将是空数组
- (void)imagePickerController:(ZZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets infos:(NSArray<NSDictionary *> *)infos;
- (void)imagePickerControllerDidCancel:(ZZImagePickerController *)picker;
- (void)imagePickerController:(ZZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAsset:(PHAsset *)asset;

@end

#pragma mark - ZZImagePickerController
@interface ZZImagePickerController : UINavigationController
@property (nonatomic, assign) id<ZZImagePickerControllerDelegate> pickDelegate;
@property (nonatomic, readonly) ZZImagePickerConfigure *configure;

- (instancetype)initWithConfigure:(void (^)(ZZImagePickerConfigure *))configureHandle;
- (void)showProgressHUD;
- (void)dismissProgressHUD;
@end
