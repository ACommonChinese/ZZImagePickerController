//
//  ZZAssetCell.h
//  Demo
//
//  Created by 刘威振 on 6/28/16.
//  Copyright © 2016 刘威振. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZAssetModel.h"

@interface ZZAssetCell : UICollectionViewCell

@property (nonatomic) ZZAssetModel *model;

@property (nonatomic, copy) void (^clickSelectButtonHandler)(UIButton *selectButton);
@end
