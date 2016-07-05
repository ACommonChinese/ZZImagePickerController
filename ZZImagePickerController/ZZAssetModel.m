//
//  ZZAssetModel.m
//  Demo
//
//  Created by 刘威振 on 6/28/16.
//  Copyright © 2016 刘威振. All rights reserved.
//

#import "ZZAssetModel.h"

@implementation ZZAssetModel

+ (instancetype)modelWithAsset:(id)asset type:(ZZAssetModelMediaType)type {
    return [self modelWithAsset:asset type:type timeLength:nil];
}

+ (instancetype)modelWithAsset:(id)asset type:(ZZAssetModelMediaType)type timeLength:(NSString *)timeLength {
    ZZAssetModel *model = [[ZZAssetModel alloc] init];
    model.asset         = asset;
    model.type          = type;
    model.isSelected    = NO;
    model.timeLength    = timeLength;
    return model;
}

@end

@implementation NSArray (ZZSelectAsset)

- (NSArray<ZZAssetModel *> *)selectAssets {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected = YES"]];
}

@end