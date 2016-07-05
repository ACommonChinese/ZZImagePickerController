//
//  ZZPhotoPickerController.m
//  Demo
//
//  Created by 刘威振 on 6/28/16.
//  Copyright © 2016 刘威振. All rights reserved.
//

#import "ZZPhotoPickerController.h"
#import <Photos/Photos.h>
#import "ZZImageManager.h"
#import "ZZImagePickerController.h"
#import "ZZAssetCell.h"
#import "ZZBottomToolbar.h"
#import "UIViewController+ZZSimpleAlert.h"
#import "ZZVideoPlayerController.h"
#import "ZZPhotoPreviewController.h"
#import "UIView+ZZOscillatoryAnimation.h"

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)

@interface ZZPhotoPickerController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic) NSMutableArray<ZZAssetModel *> *photoArr;
@property (nonatomic) NSMutableArray<ZZAssetModel *> *selectPhotoArr;
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) ZZBottomToolbar  *toolbar;
@end

@implementation ZZPhotoPickerController

- (NSMutableArray *)selectPhotoArr {
    if (_selectPhotoArr == nil) _selectPhotoArr = [NSMutableArray array];
    return _selectPhotoArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.model) {
        self.navigationItem.title = self.model.name;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
        ZZImagePickerController *imagePickerController = (ZZImagePickerController *)self.navigationController;
        [[ZZImageManager manager] getAssetsOfAlbum:self.model allowPickVideo:imagePickerController.configure.allowPickVideo completion:^(NSArray<ZZAssetModel *> *models) {
            self.photoArr = [NSMutableArray arrayWithArray:models];
            [self addCollectionView];
            [self addBottomToolbar];
        }];
    }
}

- (void)addBottomToolbar {
    ZZBottomToolbar *toolbar    = [[[NSBundle mainBundle] loadNibNamed:@"ZZBottomToolbar" owner:nil options:nil] firstObject];
    CGFloat rgb                 = 253 / 255.0;
    toolbar.backgroundColor     = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    toolbar.frame               = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
    [self.view addSubview:toolbar];
    self.toolbar                = toolbar;
    self.toolbar.selectPhotoArr = self.selectPhotoArr;
    __weak typeof(self) weakSelf       = self;
    [self.toolbar okButtonClickHandler:^{
        [weakSelf okHandler]();
    }];
    [weakSelf.toolbar previewButtonClickHandler:^{
        [weakSelf gotoPhotoPreviewControllerWithPhotoArray:weakSelf.selectPhotoArr currentPhoto:[weakSelf.selectPhotoArr objectAtIndex:0]];
    }];
}

- (dispatch_block_t)okHandler {
    return ^() {
        __weak typeof(self) weakSelf = self;
        ZZImagePickerController *imageController = (ZZImagePickerController *)self.navigationController;
        [imageController showProgressHUD];
        NSMutableArray *photoArr = [NSMutableArray array];
        NSMutableArray *assetArr = [NSMutableArray array];
        NSMutableArray *infoArr  = [NSMutableArray array];
        [self.selectPhotoArr removeAllObjects];
        [self.selectPhotoArr addObjectsFromArray:self.photoArr.selectAssets];
        NSInteger count = self.selectPhotoArr.count;
        if (count <= 0) {
            // 所有图片加载完毕后，回调
            if ([imageController.pickDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingPhotos:sourceAssets:infos:)]) {
                [imageController.pickDelegate imagePickerController:imageController didFinishPickingPhotos:nil sourceAssets:nil infos:nil];
            }
            [imageController dismissProgressHUD];
            return ;
        }
        for (NSInteger i = 0; i < self.selectPhotoArr.count; i++) {
            ZZAssetModel *model = self.selectPhotoArr[i];
            [[ZZImageManager manager] getPhotoWithAsset:model.asset onlyFinal:YES completion:^(UIImage *photo, NSDictionary *info) {
                if (photo) [photoArr addObject:photo];
                if (info) [infoArr addObject:info];
                // if (weakSelf.toolbar.isSelectOriginPhoto) [assetArr addObject:model.asset];
                [assetArr addObject:model.asset];
                if (photoArr.count < weakSelf.selectPhotoArr.count) return ;
                
                // 所有图片加载完毕后，回调
                if ([imageController.pickDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingPhotos:sourceAssets:infos:)]) {
                    [imageController.pickDelegate imagePickerController:imageController didFinishPickingPhotos:photoArr sourceAssets:assetArr infos:infoArr];
                }
                [imageController dismissProgressHUD];
            }];
        }
    };
}

- (void)cancel {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    ZZImagePickerController *pickerController = (ZZImagePickerController *)self.navigationController;
    if ([pickerController.pickDelegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        [pickerController.pickDelegate imagePickerControllerDidCancel:pickerController];
    }
}

- (void)addCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin                     = 4;
    CGFloat itemWH                     = (self.view.frame.size.width - 2 * margin - 4) / 4 - margin;
    layout.itemSize                    = CGSizeMake(itemWH, itemWH);
    layout.minimumInteritemSpacing     = margin;
    layout.minimumLineSpacing          = margin;
    CGFloat top                        = margin + 64;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(margin, top, self.view.frame.size.width - 2 * margin, self.view.frame.size.height - 50 - top) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource      = self;
    self.collectionView.delegate        = self;
    self.collectionView.alwaysBounceHorizontal      = NO;
    if (iOS7Later) self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 2);
    self.collectionView.scrollIndicatorInsets       = UIEdgeInsetsMake(0, 0, 0, -2);
    self.collectionView.contentSize = CGSizeMake(self.view.frame.size.width, ((_model.count + 3) / 4) * self.view.frame.size.width);
    [self.view addSubview:_collectionView];
    NSString *identifier = NSStringFromClass([ZZAssetCell class]);
    [self.collectionView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellWithReuseIdentifier:identifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.photoArr.count > 0) [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(_photoArr.count - 1) inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
}

#pragma mark - UICollectionViewDataSource && Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZZAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZZAssetCell" forIndexPath:indexPath];
    ZZAssetModel *model = [self.photoArr objectAtIndex:indexPath.row];
    cell.model = model;
    typeof(self) weakSelf = self;
    cell.clickSelectButtonHandler = ^(UIButton *button) { // 点选选择按钮
        BOOL selected = button.isSelected;
        // 1. cancel select / 取消选择
        if (selected) {
            button.selected = model.isSelected = NO;
            [weakSelf.selectPhotoArr removeObject:model];
            [weakSelf.toolbar refresh]; // 刷新底部视图
        } else {
            // 2. select:check if over the maxImagesCount / 选择照片,检查是否超过了最大个数的限制
            ZZImagePickerController *imagePickerController = (ZZImagePickerController *)self.navigationController;
            if (weakSelf.selectPhotoArr.count < imagePickerController.configure.allowMaxCount) {
                button.selected = model.isSelected = YES;
                [weakSelf.selectPhotoArr addObject:model];
                [weakSelf.toolbar refresh];
            } else {
                [self zz_showAlertWithTitle:[NSString stringWithFormat:@"你最多只能选择%zd张照片",imagePickerController.configure.allowMaxCount]];
            }
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZZAssetModel *model = self.photoArr[indexPath.row];
    if (model.type == ZZAssetModelMediaTypeVideo) { // 如果是视频
        if (self.selectPhotoArr.count > 0) {
            [self zz_showAlertWithTitle:@"选择照片时不能选择视频"];
        } else {
            ZZVideoPlayerController *controller = [[ZZVideoPlayerController alloc] init];
            controller.model = model;
            [self.navigationController pushViewController:controller animated:YES];
        }
    } else {
        [self gotoPhotoPreviewControllerWithPhotoArray:self.photoArr currentPhoto:model];
    }
}

- (void)gotoPhotoPreviewControllerWithPhotoArray:(NSArray *)photoArray currentPhoto:(ZZAssetModel *)currentPhoto {
    __weak typeof(self) weakSelf = self;
    ZZPhotoPreviewController *previewController = [[ZZPhotoPreviewController alloc] init];
    ZZPhotoPreviewModel *model = [[ZZPhotoPreviewModel alloc] init];
    model.isSelectOriginPhoto  = weakSelf.toolbar.isSelectOriginPhoto;
    model.photoArr             = [NSArray arrayWithArray:photoArray];
    model.currentPhoto         = currentPhoto;
    previewController.model    = model;
    // 返回按钮
    previewController.backHandler = ^(ZZPhotoPreviewController *controller) {
        [weakSelf refreshUI];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    // 确定按钮
    previewController.okHandler = ^(ZZPhotoPreviewController *controller) {
        [weakSelf okHandler]();
    };
    [weakSelf.navigationController pushViewController:previewController animated:YES];
}

- (void)refreshUI {
    [self.collectionView reloadData];
    [self.selectPhotoArr removeAllObjects];
    [self.selectPhotoArr addObjectsFromArray:self.photoArr.selectAssets];
    [self.toolbar refresh];
}

@end
