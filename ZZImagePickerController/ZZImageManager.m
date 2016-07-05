//
//  ZZImageManager.m
//  Demo
//
//  Created by 刘威振 on 6/28/16.
//  Copyright © 2016 刘威振. All rights reserved.
//

#import "ZZImageManager.h"
#import <Photos/Photos.h>

@implementation ZZImageManager

+ (instancetype)manager {
    static ZZImageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)getCameraRollAlbum:(BOOL)allowPickVideo completion:(void (^)(ZZAlbumModel *))completion {
    PHFetchOptions *option = [self commonFetchOptionWithAllowVideo:allowPickVideo];
    NSArray *albumModels = [self albumModelsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary option:option];
    for (ZZAlbumModel *model in albumModels) {
        if ([model.name isEqualToString:@"相机胶卷"]) {
            if (completion) completion(model);
            break;
        }
    }
}

- (PHFetchOptions *)commonFetchOptionWithAllowVideo:(BOOL)allowVideo {
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    if (!allowVideo) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    return option;
}

- (void)getAllAlbums:(BOOL)allowPickVideo completion:(void (^)(NSArray<ZZAlbumModel *> *))completion {
    NSMutableArray *albumArray = [NSMutableArray array];
    PHFetchOptions *option = [self commonFetchOptionWithAllowVideo:allowPickVideo];
    NSArray *smartAlbums = [self albumModelsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny option:option]; // 智能相册
    for (ZZAlbumModel *model in smartAlbums) {
        if ([model.name isEqualToString:@"相机胶卷"]) {
            [albumArray insertObject:model atIndex:0];
        } else {
            [albumArray addObject:model];
        }
    }
    NSArray *albums = [self albumModelsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny option:option];
    for (ZZAlbumModel *model in albums) {
        if ([model.name isEqualToString:@"我的照片流"]) {
            [albumArray insertObject:model atIndex:1];
        } else {
            [albumArray addObject:model];
        }
    }
    if (completion) completion(albumArray);
}

// 获取指定类型下所有的相册
- (NSArray<ZZAlbumModel *> *)albumModelsWithType:(PHAssetCollectionType)type subtype:(PHAssetCollectionSubtype)subtype option:(PHFetchOptions *)option {
    PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:type subtype:subtype options:nil];
    NSMutableArray *resultArray = [NSMutableArray array];
    for (PHAssetCollection *collection in albums) {
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option]; // 从每一个智能相册中获取到的 PHFetchResult 中包含的才是真正的资源（PHAsset）
        if (fetchResult.count < 1) continue;
        [resultArray addObject:[ZZAlbumModel modelWithResult:fetchResult name:collection.localizedTitle]];
    }
    return resultArray;
}

- (void)getPostImageWithAlbumModel:(ZZAlbumModel *)model completion:(void (^)(UIImage *postImage))completion {
    [[ZZImageManager manager] getPhotoWithAsset:[model.result lastObject] photoWidth:80 completion:^(UIImage *photo, NSDictionary *info) {
        if (completion) {
            completion(photo);
        }
    }];
}

- (void)getPhotoWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *photo,NSDictionary *info))completion {
    [self getPhotoWithAsset:asset onlyFinal:NO completion:completion];
}

- (void)getPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info))completion {
    [self getPhotoWithAsset:asset onlyFinal:NO photoWidth:photoWidth completion:completion];
}

- (void)getPhotoWithAsset:(PHAsset *)asset onlyFinal:(BOOL)onlyFinal completion:(void (^)(UIImage *, NSDictionary *))completion {
    [self getPhotoWithAsset:asset onlyFinal:onlyFinal photoWidth:[UIScreen mainScreen].bounds.size.width completion:completion];
}

- (void)getPhotoWithAsset:(PHAsset *)asset onlyFinal:(BOOL)onlyFinal photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info))completion {
    CGFloat aspectRatio = asset.pixelWidth / asset.pixelHeight;
    CGFloat multiple    = [[UIScreen mainScreen] scale];
    CGFloat pixelWidth  = photoWidth * multiple;
    CGFloat pixelHeight = pixelWidth / aspectRatio;
    
    // http://blog.csdn.net/u010127917/article/details/50808734
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(pixelWidth, pixelHeight) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (onlyFinal == NO) {
            if (completion) { // 使用此方法，有可能调很多次，比如第一次返回一个小图片，第二次才是真正的大图片
                completion(result, info);
            }
        } else {
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
            if (downloadFinined) {
                if (completion) completion(result,info);
            }
        }
    }];
}

- (void)getAssetsOfAlbum:(ZZAlbumModel *)albumModel allowPickVideo:(BOOL)allowPickVideo completion:(void (^)(NSArray<ZZAssetModel *> *models))completion {
    NSMutableArray *photoArr = [NSMutableArray array];
    PHFetchResult *result = albumModel.result;
    for (PHAsset *asset in result) {
        ZZAssetModelMediaType type = ZZAssetModelMediaTypePhoto;
        if (asset.mediaType == PHAssetMediaTypeVideo)      type = ZZAssetModelMediaTypeVideo;
        else if (asset.mediaType == PHAssetMediaTypeAudio) type = ZZAssetModelMediaTypeAudio;
        else if (asset.mediaType == PHAssetMediaTypeImage) {
            if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) type = ZZAssetModelMediaTypeLivePhoto;
        }
        NSString *timeLength = type == ZZAssetModelMediaTypeVideo ? [NSString stringWithFormat:@"%0.0f",asset.duration] : @"";
        timeLength = [self getNewTimeFromDurationSecond:timeLength.integerValue];
        [photoArr addObject:[ZZAssetModel modelWithAsset:asset type:type timeLength:timeLength]];
    }
    if (completion) completion(photoArr);
}

- (NSString *)getNewTimeFromDurationSecond:(NSInteger)duration {
    NSString *newTime;
    if (duration < 10) {
        newTime = [NSString stringWithFormat:@"0:0%zd",duration];
    } else if (duration < 60) {
        newTime = [NSString stringWithFormat:@"0:%zd",duration];
    } else {
        NSInteger min = duration / 60;
        NSInteger sec = duration - (min * 60);
        if (sec < 10) {
            newTime = [NSString stringWithFormat:@"%zd:0%zd",min,sec];
        } else {
            newTime = [NSString stringWithFormat:@"%zd:%zd",min,sec];
        }
    }
    return newTime;
}

- (void)getPhotoBytes:(NSArray<ZZAssetModel *> *)photos completion:(void (^)(NSString *totalBytes))completion {
    __block long dataLength = 0;
    for (NSInteger i = 0; i < photos.count; i++) {
        ZZAssetModel *model = photos[i];
        [[PHImageManager defaultManager] requestImageDataForAsset:model.asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            if (model.type != ZZAssetModelMediaTypeVideo) dataLength += imageData.length;
            if (i >= photos.count - 1) {
                NSString *bytesStr = [self getDataLengthString:dataLength];
                if (completion) completion(bytesStr);
            }
        }];
    }
    /** 由于PHImageManager是异步操作，所以不可写在这里
    NSString *bytesStr = [self getDataLengthString:dataLength];
    if (completion) completion(bytesStr);
     */
}

- (NSString *)getDataLengthString:(long)dataLength {
    if (dataLength <= 0) return nil;
    NSString *bytes;
    if (dataLength >= 0.1 * (1024 * 1024)) {
        bytes = [NSString stringWithFormat:@"%0.1fM",dataLength/1024/1024.0];
    } else if (dataLength >= 1024) {
        bytes = [NSString stringWithFormat:@"%0.0fK",dataLength/1024.0];
    } else {
        bytes = [NSString stringWithFormat:@"%zdB",dataLength];
    }
    return bytes;
}

- (void)getVideoWithAsset:(PHAsset *)asset completion:(void (^)(AVPlayerItem *playerItem, NSDictionary *info))completion {
    [[PHImageManager defaultManager] requestPlayerItemForVideo:asset options:nil resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        if (completion) completion(playerItem, info);
    }];
}

@end






