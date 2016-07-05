//
//  ZZAlbumModel.h
//  Demo
//
//  Created by 刘威振 on 6/28/16.
//  Copyright © 2016 刘威振. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface ZZAlbumModel : NSObject

+ (instancetype)modelWithResult:(PHFetchResult *)result name:(NSString *)name;

@property (nonatomic) PHFetchResult *result;
@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSInteger count;

@end
