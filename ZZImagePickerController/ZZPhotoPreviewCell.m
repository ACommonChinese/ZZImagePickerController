//
//  ZZPhotoPreviewCell.m
//  Demo
//
//  Created by 刘威振 on 6/30/16.
//  Copyright © 2016 刘威振. All rights reserved.
//

#import "ZZPhotoPreviewCell.h"
#import "ZZImageManager.h"
#import "ZZAssetModel.h"

@interface ZZPhotoPreviewCell () <UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIImageView *imageView;
// @property (nonatomic) UIView *imageContainerView;
@end

@implementation ZZPhotoPreviewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.scrollView                                = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        // self.scrollView.bouncesZoom                 = YES; // default is YES
        self.scrollView.maximumZoomScale               = 2.5;
        self.scrollView.minimumZoomScale               = 1.0;
        self.scrollView.multipleTouchEnabled           = YES;
        self.scrollView.delegate                       = self;
        self.scrollView.scrollsToTop                   = NO;
        self.scrollView.showsHorizontalScrollIndicator = self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.autoresizingMask               = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.scrollView.delaysContentTouches           = NO;// default is YES
        // self.scrollView.canCancelContentTouches     = YES; // default is YES
        self.scrollView.alwaysBounceVertical           = NO;
        // self.scrollView.backgroundColor             = [UIColor redColor];
        self.scrollView.contentSize                    = self.bounds.size;
        [self addSubview:self.scrollView];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.imageView.backgroundColor        = [UIColor colorWithWhite:1.000 alpha:0.500];
        self.imageView.clipsToBounds          = YES;
        self.imageView.userInteractionEnabled = YES;
        [self.scrollView addSubview:self.imageView];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        tap2.numberOfTapsRequired    = 2;
        [tap1 requireGestureRecognizerToFail:tap2];
        [self.imageView addGestureRecognizer:tap2];
    }
    return self;
}

- (void)setModel:(ZZAssetModel *)model {
    _model = model;
    [self.scrollView setZoomScale:1.0 animated:NO];
    [[ZZImageManager manager] getPhotoWithAsset:model.asset completion:^(UIImage *photo, NSDictionary *info) {
        [self resizeSubviews:model];
        self.imageView.image = photo;
    }];
}

- (void)resizeSubviews:(ZZAssetModel *)model {
    PHAsset *asset          = model.asset;
    CGSize imageSize = CGSizeMake(asset.pixelWidth / [[UIScreen mainScreen] scale], asset.pixelHeight / [[UIScreen mainScreen] scale]);
    CGFloat imageViewWidth  = MIN(imageSize.width, self.frame.size.width);
    CGFloat imageViewHeight = imageViewWidth / (imageSize.width / imageSize.height);

    if (imageViewHeight > self.frame.size.height) {
        imageViewHeight = self.frame.size.height;
        imageViewWidth = MIN(imageSize.width, self.frame.size.width);
    }
    self.imageView.frame = CGRectMake(0, 0, imageViewWidth, imageViewHeight);
    self.imageView.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
}

/**
- (void)resizeSubviews {
    UIImage *image          = self.imageView.image;
    CGFloat imageViewWidth  = MIN(image.size.width, self.frame.size.width);
    CGFloat imageViewHeight = imageViewWidth / (image.size.width / image.size.height);
    
    if (imageViewHeight > self.frame.size.height) {
        imageViewHeight = self.frame.size.height;
        imageViewWidth = MIN(image.size.width, self.frame.size.width);
    }
    self.imageView.frame = CGRectMake(0, 0, imageViewWidth, imageViewHeight);
    self.imageView.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
}*/

- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTapHandler) {
        self.singleTapHandler();
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (self.scrollView.zoomScale > 1.0) {
        [self.scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGRect zoomRect = [self getScaleRectWithTapPoint:[tap locationInView:self.imageView]];
        [self.scrollView zoomToRect:zoomRect animated:YES];
    }
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    // self.imageContainerView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
    // self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
    /**
    // just test
    NSLog(@"====> %lf-----%lf", offsetX, offsetY);
    NSLog(@"scrollView.frame.size.width: %lf", self.scrollView.frame.size.width);
    NSLog(@"scrollView.frame.size.height: %lf", self.scrollView.frame.size.height);
    NSLog(@"scrollView.contentSize.width: %lf", self.scrollView.contentSize.width);
    NSLog(@"scrollView.contentSize.height: %lf", self.scrollView.contentSize.height);
    NSLog(@"imageView.frame.size.width: %lf", self.imageView.frame.size.width);
    NSLog(@"imageView.frame.size.height: %lf", self.imageView.frame.size.height);
    offsetX = 0;
    offsetY = 0;
     */
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

- (CGRect)getScaleRectWithTapPoint:(CGPoint)point {
    // http://www.cnblogs.com/pengyingh/articles/2341303.html
    CGFloat scale = self.scrollView.maximumZoomScale;
    CGFloat xSize = self.scrollView.frame.size.width / scale;
    CGFloat ySize = self.scrollView.frame.size.height / scale;
    return CGRectMake(point.x - xSize/2.0, point.y - ySize/2.0, xSize, ySize);
}

@end