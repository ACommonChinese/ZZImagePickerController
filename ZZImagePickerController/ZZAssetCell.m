//
//  ZZAssetCell.m
//  Demo
//
//  Created by 刘威振 on 6/28/16.
//  Copyright © 2016 刘威振. All rights reserved.
//

#import "ZZAssetCell.h"
#import "ZZImageManager.h"
#import "UIView+ZZOscillatoryAnimation.h"

@interface ZZAssetCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLengthLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *selectPhotoButton;
@end

@implementation ZZAssetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)selectPhotoButtonClick:(UIButton *)sender {
    if (self.clickSelectButtonHandler) {
        self.clickSelectButtonHandler(sender); // 由外部的block重新调整sender的select状态
    }
    self.selectImageView.image = sender.isSelected ? [UIImage imageNamed:@"photo_sel_photoPickerVc"] : [UIImage imageNamed:@"photo_def_photoPickerVc"];
    if (sender.isSelected) {
        [UIView zz_showOscillatoryAnimationWithLayer:self.selectImageView.layer type:ZZOscillatoryAnimationToBigger];
    }
}

- (void)setModel:(ZZAssetModel *)model {
    _model = model;
    [[ZZImageManager manager] getPhotoWithAsset:model.asset photoWidth:self.frame.size.width completion:^(UIImage *photo, NSDictionary *info) {
        self.imageView.image = photo;
    }];
    self.selectPhotoButton.selected = model.isSelected;
    self.selectImageView.image = self.selectPhotoButton.isSelected ? [UIImage imageNamed:@"photo_sel_photoPickerVc"] : [UIImage imageNamed:@"photo_def_photoPickerVc"];
    if (model.type == ZZAssetModelMediaTypeVideo) { // 如果是视频
        self.timeLengthLabel.text = model.timeLength;
        self.bottomView.hidden = NO;
        self.selectPhotoButton.hidden = self.selectImageView.hidden = YES;
    } else {
        self.bottomView.hidden = YES;
        self.selectPhotoButton.hidden = self.selectImageView.hidden = NO;
    }
}

@end
