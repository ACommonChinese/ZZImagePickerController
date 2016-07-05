//
//  ZZVideoPlayerController.m
//  Demo
//
//  Created by 刘威振 on 6/29/16.
//  Copyright © 2016 刘威振. All rights reserved.
//

#import "ZZVideoPlayerController.h"
#import "ZZImageManager.h"
#import "ZZImagePickerController.h"

@interface ZZVideoPlayerBottomView : UIView

@property (nonatomic, copy) dispatch_block_t okButtonHandler;
@end

@implementation ZZVideoPlayerBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat rgb              = 34 / 255.0;
        self.backgroundColor     = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.7];
        UIButton *okButton       = [UIButton buttonWithType:UIButtonTypeCustom];
        okButton.frame           = CGRectMake(frame.size.width - 56, 0, 44, 44);
        okButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [okButton addTarget:self action:@selector(okButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [okButton setTitle:@"确定" forState:UIControlStateNormal];
        [okButton setTitleColor:[UIColor colorWithRed:(83/255.0) green:(179/255.0) blue:(17/255.0) alpha:1.0] forState:UIControlStateNormal];
        [self addSubview:okButton];
    }
    return self;
}

- (void)okButtonClick:(UIButton *)button {
    if (self.okButtonHandler) {
        self.okButtonHandler();
    }
}

@end

// ---------------------------------------------------

@interface ZZVideoPlayerController ()

@property (nonatomic) ZZVideoPlayerBottomView *bottomView;
@property (nonatomic) AVPlayer *player;
@property (nonatomic) UIButton *playButton;
@property (nonatomic) UIImage *coverImage;
@end

@implementation ZZVideoPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"视频预览";
    
    [self addMoviePlayer];
}

- (void)addMoviePlayer {
    [[ZZImageManager manager] getPhotoWithAsset:self.model.asset onlyFinal:YES completion:^(UIImage *photo, NSDictionary *info) {
        self.coverImage = photo;
    }];
    
    // 获取视频
    [[ZZImageManager manager] getVideoWithAsset:self.model.asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.player = [AVPlayer playerWithPlayerItem:playerItem];
            AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
            playerLayer.frame = self.view.bounds;
            [self.view.layer addSublayer:playerLayer];
            // [self.player play];
            // [self addProgress];
            [self addPlayButton];
            [self addBottomView];
            [self addNotification];
        });
    }];
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pause) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)pause {
    [self.player pause];
    [self refreshUIForPause];
}

- (void)addPlayButton {
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playButton.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 44);
    [self.playButton setImage:[UIImage imageNamed:@"MMVideoPreviewPlay"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"MMVideoPreviewPlayHL"] forState:UIControlStateHighlighted];
    [self.playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playButton];
}

- (void)addBottomView {
    self.bottomView = [[ZZVideoPlayerBottomView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
    __weak typeof(self) weakSelf = self;
    self.bottomView.okButtonHandler = ^() {
        ZZImagePickerController *pickerController = (ZZImagePickerController *)weakSelf.navigationController;
        if ([pickerController.pickDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingVideo:sourceAsset:)]) {
            [pickerController.pickDelegate imagePickerController:pickerController didFinishPickingVideo:weakSelf.coverImage sourceAsset:weakSelf.model.asset];
        }
    };
    [self.view addSubview:self.bottomView];
}

- (void)playButtonClick:(UIButton *)button {
    CMTime currentTime = self.player.currentItem.currentTime;
    CMTime durationTime = self.player.currentItem.duration;
    if (self.player.rate == 0.0) {
        if (currentTime.value == durationTime.value) [self.player.currentItem seekToTime:kCMTimeZero]; // [_player.currentItem seekToTime:CMTimeMake(0, 1)]
        [self.player play];
        [self refreshUIForPlay];
    } else {
        [self.player pause];
        [self refreshUIForPause];
    }
}

- (void)refreshUIForPlay {
    [self.navigationController setNavigationBarHidden:YES];
    self.bottomView.hidden = YES;
    [self.playButton setImage:nil forState:UIControlStateNormal];
}

- (void)refreshUIForPause {
    self.bottomView.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO];
    [_playButton setImage:[UIImage imageNamed:@"MMVideoPreviewPlay"] forState:UIControlStateNormal];
}

- (void)addProgress {
    /**
    AVPlayerItem *playerItem = _player.currentItem;
    UIProgressView *progress = _progress;
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds([playerItem duration]);
        if (current) {
            [progress setProgress:(current/total) animated:YES];
        }
    }];
     */
}

- (void)dealloc {
    [self removeNotification];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
