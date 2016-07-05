//
//  ZZImagePickerControllerConfigure.h
//  Demo
//
//  Created by 刘威振 on 16/6/27.
//  Copyright © 2016年 刘威振. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZImagePickerConfigure : NSObject

/// Default is YES.if set NO, the original photo button will hide. user can't picking original photo.
@property (nonatomic) BOOL allowPickOriginal;

/// Default is YES. if set NO, user can't picking video.
@property (nonatomic, assign) BOOL allowPickVideo;

/// Default is 9. max allow choosed asset count
@property (nonatomic) NSInteger allowMaxCount;

/// Default is NO. Allow choose image and video together
/// 此属性暂时强制为NO，即不允许即选择图片又选择视频, 留待以后做调束
@property (nonatomic, readonly) BOOL allowImageAndVideo;

@end
