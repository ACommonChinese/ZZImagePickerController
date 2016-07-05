//
//  ZZImageManager.h
//  Demo
//
//  Created by 刘威振 on 6/28/16.
//  Copyright © 2016 刘威振. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZAlbumModel.h"
#import "ZZAssetModel.h"

@interface ZZImageManager : NSObject

+ (instancetype)manager;

/** 相机胶卷 */
- (void)getCameraRollAlbum:(BOOL)allowPickVideo completion:(void (^)(ZZAlbumModel *))completion;

/** Get all albums 获取所有相册 */
- (void)getAllAlbums:(BOOL)allowPickVideo completion:(void (^)(NSArray<ZZAlbumModel *> *))completion;

/** Get photo 获得相册封面图 */
- (void)getPostImageWithAlbumModel:(ZZAlbumModel *)model completion:(void (^)(UIImage *postImage))completion;

/** Get photo 获得图片 */
- (void)getPhotoWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *photo,NSDictionary *info))completion;
- (void)getPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info))completion;
- (void)getPhotoWithAsset:(PHAsset *)asset onlyFinal:(BOOL)onlyFinal completion:(void (^)(UIImage *photo, NSDictionary *info))completion;
- (void)getPhotoWithAsset:(PHAsset *)asset onlyFinal:(BOOL)onlyFinal photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info))completion;

/** Get Assets 获得相册AlbumModel下的Asset */
- (void)getAssetsOfAlbum:(ZZAlbumModel *)albumModel allowPickVideo:(BOOL)allowPickVideo completion:(void (^)(NSArray<ZZAssetModel *> *models))completion;

/** Get photo bytes 获得一组照片的大小 */
- (void)getPhotoBytes:(NSArray<ZZAssetModel *> *)photos completion:(void (^)(NSString *totalBytes))completion;

// Get video
- (void)getVideoWithAsset:(PHAsset *)asset completion:(void (^)(AVPlayerItem *playerItem, NSDictionary *info))completion;

@end
