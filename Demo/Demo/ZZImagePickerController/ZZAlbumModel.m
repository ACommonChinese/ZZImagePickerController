//
//  ZZAlbumModel.m
//  Demo
//
//  Created by 刘威振 on 6/28/16.
//  Copyright © 2016 刘威振. All rights reserved.
//

#import "ZZAlbumModel.h"
#import <Photos/Photos.h>

@implementation ZZAlbumModel

+ (instancetype)modelWithResult:(PHFetchResult *)result name:(NSString *)name {
    ZZAlbumModel *model = [[ZZAlbumModel alloc] init];
    model.result = result;
    model.name   = [self getNewAlbumName:name];
    model.count  = result.count;
    return model;
}

+ (NSString *)getNewAlbumName:(NSString *)name {
    NSString *newName;
    if ([name containsString:@"Roll"])         newName = @"相机胶卷";
    else if ([name containsString:@"Stream"])  newName = @"我的照片流";
    else if ([name containsString:@"Added"])   newName = @"最近添加";
    else if ([name containsString:@"Selfies"]) newName = @"自拍";
    else if ([name containsString:@"shots"])   newName = @"截屏";
    else if ([name containsString:@"Videos"])  newName = @"视频";
    else newName = name;
    return newName;
}

@end
