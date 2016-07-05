//
//  ZZPhotoPreviewController.h
//  Demo
//
//  Created by 刘威振 on 6/29/16.
//  Copyright © 2016 刘威振. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZAssetModel.h"

@interface ZZPhotoPreviewModel : NSObject

@property (nonatomic) BOOL isSelectOriginPhoto;
@property (nonatomic) ZZAssetModel *currentPhoto;
@property (nonatomic) NSArray<ZZAssetModel *> *photoArr;
@end

// ------------------------------------------------------------

@interface ZZPhotoPreviewController : UIViewController

@property (nonatomic) ZZPhotoPreviewModel *model;
@property (nonatomic) dispatch_block_t_2 backHandler;
@property (nonatomic) dispatch_block_t_2 okHandler;
@end
