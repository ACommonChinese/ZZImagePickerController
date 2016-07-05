//
//  ZZBottomToolbar.m
//  Demo
//
//  Created by 刘威振 on 6/29/16.
//  Copyright © 2016 刘威振. All rights reserved.
//

#import "ZZBottomToolbar.h"
#import "UIView+ZZOscillatoryAnimation.h"
#import "ZZImageManager.h"

@interface ZZBottomToolbar ()

/** 按钮－预览 */
@property (weak, nonatomic) IBOutlet UIButton *previewButton;

/** 按钮－原图 */
@property (weak, nonatomic) IBOutlet UIButton *originalPhotoButton;

/** Label－ 显示大小 */
@property (weak, nonatomic) IBOutlet UILabel *originalPhotoLable;

/** 按钮－确定 */
@property (weak, nonatomic) IBOutlet UIButton *okButton;

/** ImageView－数量 */
@property (weak, nonatomic) IBOutlet UIImageView *numberImageView;

/** Label－数量 */
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (nonatomic, copy) dispatch_block_t previewHandler;
@property (nonatomic, copy) dispatch_block_t okHandler;
@end

@implementation ZZBottomToolbar

- (void)previewButtonClickHandler:(dispatch_block_t)previewHandler {
    self.previewHandler = previewHandler;
}

- (void)okButtonClickHandler:(dispatch_block_t)okHandler {
    self.okHandler = okHandler;
}

// 预览
- (IBAction)previewButtonClick:(UIButton *)sender {
    if (self.previewHandler) self.previewHandler();
}

// 原图
- (IBAction)originalPhotoButtonClick:(UIButton *)sender {
    _isSelectOriginPhoto = self.originalPhotoButton.selected = !self.originalPhotoButton.selected;
    // self.originalPhotoLable.backgroundColor = [UIColor yellowColor];
    self.originalPhotoLable.hidden = !self.originalPhotoButton.isSelected;
    if (self.isSelectOriginPhoto) [self refreshSelectPhotoBytes];
}

// 确定
- (IBAction)okButtonClick:(UIButton *)sender {
    if (self.okHandler) self.okHandler();
}

- (void)refresh {
    self.previewButton.enabled        = self.okButton.enabled = self.originalPhotoButton.enabled = self.selectPhotoArr.count > 0;
    self.numberImageView.hidden       = self.selectPhotoArr.count <= 0;
    self.numberLabel.hidden           = self.selectPhotoArr.count <= 0;
    self.numberLabel.text             = [NSString stringWithFormat:@"%zd",self.selectPhotoArr.count];
    self.originalPhotoButton.selected = self.originalPhotoButton.enabled & self.isSelectOriginPhoto;
    self.originalPhotoLable.hidden    = !self.originalPhotoButton.isSelected;
    if (self.isSelectOriginPhoto) [self refreshSelectPhotoBytes];
    [UIView zz_showOscillatoryAnimationWithLayer:self.numberImageView.layer type:ZZOscillatoryAnimationToSmaller];
}

- (void)refreshSelectPhotoBytes {
    [[ZZImageManager manager] getPhotoBytes:self.selectPhotoArr completion:^(NSString *totalBytes) {
        // NSLog(@"%@", totalBytes);
        self.originalPhotoLable.text = totalBytes;
    }];
}

@end
