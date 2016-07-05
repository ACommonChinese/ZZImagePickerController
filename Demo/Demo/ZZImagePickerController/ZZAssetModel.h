//
//  ZZAssetModel.h
//  Demo
//
//  Created by 刘威振 on 6/28/16.
//  Copyright © 2016 刘威振. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^dispatch_block_t_2)(id obj);

typedef enum : NSUInteger {
    ZZAssetModelMediaTypePhoto = 0,
    ZZAssetModelMediaTypeLivePhoto,
    ZZAssetModelMediaTypeVideo,
    ZZAssetModelMediaTypeAudio
} ZZAssetModelMediaType;

@class PHAsset;
@interface ZZAssetModel : NSObject

/** PHAsset，含有图片信息 */
@property (nonatomic) PHAsset *asset;

/** 是否被选中 */
@property (nonatomic) BOOL isSelected;

/** 资源类型 */
@property (nonatomic) ZZAssetModelMediaType type;

/** 时长，比如视频文件，其播放时长 */
@property (nonatomic, copy) NSString *timeLength;

/** Convenience: 实例化对象 */
+ (instancetype)modelWithAsset:(id)asset type:(ZZAssetModelMediaType)type;
+ (instancetype)modelWithAsset:(id)asset type:(ZZAssetModelMediaType)type timeLength:(NSString *)timeLength;

@end

@interface NSArray (ZZSelectAsset)

@property (nonatomic, readonly) NSArray<ZZAssetModel *> *selectAssets;

@end
