//
//  ZZPhotoPreviewCell.h
//  Demo
//
//  Created by 刘威振 on 6/30/16.
//  Copyright © 2016 刘威振. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZAssetModel;

@interface ZZPhotoPreviewCell : UICollectionViewCell

@property (nonatomic) ZZAssetModel *model;

@property (nonatomic, copy) dispatch_block_t singleTapHandler;
@end
