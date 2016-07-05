//
//  ZZBottomToolbar.h
//  Demo
//
//  Created by 刘威振 on 6/29/16.
//  Copyright © 2016 刘威振. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZAssetModel;
@interface ZZBottomToolbar : UIView

@property (nonatomic, assign) NSMutableArray<ZZAssetModel *> *selectPhotoArr;

/** 是否选中了原有图片 */
@property (nonatomic, readonly) BOOL isSelectOriginPhoto;

- (void)refresh;
- (void)previewButtonClickHandler:(dispatch_block_t)previewHandler;
- (void)okButtonClickHandler:(dispatch_block_t)okHandler;

@end