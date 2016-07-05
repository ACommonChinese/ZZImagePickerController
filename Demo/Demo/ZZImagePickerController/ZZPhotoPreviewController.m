//
//  ZZPhotoPreviewController.m
//  Demo
//
//  Created by 刘威振 on 6/29/16.
//  Copyright © 2016 刘威振. All rights reserved.
//

#import "ZZPhotoPreviewController.h"
#import "ZZPhotoPreviewCell.h"
#import "ZZImageManager.h"
#import "ZZImagePickerController.h"
#import "UIViewController+ZZSimpleAlert.h"
#import "UIView+ZZOscillatoryAnimation.h"

#pragma mark - ZZPreviewTopBar

@implementation ZZPhotoPreviewModel

@end

// ------------------------------------------------------------

@interface ZZPreviewTopBar : UIView

@property (nonatomic, copy) dispatch_block_t_2 backButtonHandler;
@property (nonatomic, copy) dispatch_block_t_2 selectButtonHandler;

- (void)setSelect:(BOOL)isSelect animated:(BOOL)animated;

@end

// ------------------------------------------------------------

@interface ZZPreviewTopBar()

@property (nonatomic) UIButton *backButton;
@property (nonatomic) UIButton *selectButton;
@end

// ------------------------------------------------------------

@implementation ZZPreviewTopBar

- (void)setSelect:(BOOL)isSelect animated:(BOOL)animated {
    self.selectButton.selected = isSelect;
    if (animated) {
        [UIView zz_showOscillatoryAnimationWithLayer:self.selectButton.imageView.layer type:ZZOscillatoryAnimationToBigger];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0) blue:(34/255.0) alpha:.7];
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 44, 44)];
        [backButton setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        
        self.selectButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 54, 10, 42, 42)];
        [self.selectButton setImage:[UIImage imageNamed:@"photo_def_photoPickerVc"] forState:UIControlStateNormal];
        [self.selectButton setImage:[UIImage imageNamed:@"photo_sel_photoPickerVc"] forState:UIControlStateSelected];
        [self.selectButton addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.selectButton];
    }
    return self;
}

- (void)back:(UIButton *)button {
    if (self.backButtonHandler) {
        self.backButtonHandler(button);
    }
}

- (void)select:(UIButton *)button {
    if (self.selectButtonHandler) {
        self.selectButtonHandler(button);
    }
}

@end

// ----------------------------------------------------------------

#pragma mark - ZZPreviewBottomBar

@interface ZZPreviewBottomBar : UIView

@property (nonatomic) NSInteger selectNumber;
@property (nonatomic) UIButton    *originPhotoButton;
@property (nonatomic) UILabel     *originPhotoLabel;
@property (nonatomic) UIButton    *okButton;
@property (nonatomic) UIImageView *numberImageView;
@property (nonatomic) UILabel     *numberLable;

@property (nonatomic, copy) dispatch_block_t_2 originalButtonHandler;
@property (nonatomic, copy) dispatch_block_t_2 okButtonHandler;
@end

@interface ZZPreviewBottomBar ()

@end

@implementation ZZPreviewBottomBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat rgb = 34 / 255.0;
        self.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:.7];
        self.originPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.originPhotoButton.frame = CGRectMake(5, 0, 120, 44);
        self.originPhotoButton.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        self.originPhotoButton.contentEdgeInsets = UIEdgeInsetsMake(0, -50, 0, 0);
        self.originPhotoButton.backgroundColor = [UIColor clearColor];
        [self.originPhotoButton addTarget:self action:@selector(originalPhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.originPhotoButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.originPhotoButton setTitle:@"原图" forState:UIControlStateNormal];
        [self.originPhotoButton setTitle:@"原图" forState:UIControlStateSelected];
        [self.originPhotoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.originPhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self.originPhotoButton setImage:[UIImage imageNamed:@"preview_original_def"] forState:UIControlStateNormal];
        [self.originPhotoButton setImage:[UIImage imageNamed:@"photo_original_sel"] forState:UIControlStateSelected];
        [self addSubview:self.originPhotoButton];
        
        self.originPhotoLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, 70, 44)];
        self.originPhotoLabel.font            = [UIFont systemFontOfSize:13];
        self.originPhotoLabel.textColor       = [UIColor whiteColor];
        self.originPhotoLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.originPhotoLabel];
        
        self.okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.okButton.frame = CGRectMake(self.frame.size.width - 44 - 12, 0, 44, 44);
        self.okButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.okButton addTarget:self action:@selector(okButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.okButton setTitle:@"确定" forState:UIControlStateNormal];
        [self.okButton setTitleColor:[UIColor colorWithRed:(83/255.0) green:(179/255.0) blue:(17/255.0) alpha:1.0] forState:UIControlStateNormal];
        [self addSubview:self.okButton];
        
        self.numberImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo_number_icon"]];
        self.numberImageView.backgroundColor = [UIColor clearColor];
        self.numberImageView.frame = CGRectMake(self.frame.size.width - 56 - 24, 9, 26, 26);
        [self addSubview:self.numberImageView];
        
        self.numberLable = [[UILabel alloc] init];
        self.numberLable.frame = _numberImageView.frame;
        self.numberLable.font = [UIFont systemFontOfSize:16];
        self.numberLable.textColor = [UIColor whiteColor];
        self.numberLable.textAlignment = NSTextAlignmentCenter;
        // self.numberLable.text = [NSString stringWithFormat:@"%zd",_selectedPhotoArr.count];
        // self.numberLable.hidden = _selectedPhotoArr.count <= 0;
        self.numberLable.backgroundColor = [UIColor clearColor];
        [self addSubview:self.numberLable];
    }
    return self;
}

- (void)originalPhotoButtonClick:(UIButton *)button {
    if (self.originalButtonHandler) {
        self.originalButtonHandler(button);
    }
}

- (void)okButtonClick:(UIButton *)button {
    if (self.okButtonHandler) {
        self.okButtonHandler(button);
    }
}

- (void)setSelectNumber:(NSInteger)selectNumber {
    _selectNumber = selectNumber;
    self.numberLable.text = [NSString stringWithFormat:@"%ld", (long)_selectNumber];
}

@end

// ----------------------------------------------------------------

#pragma mark - ZZPhotoPreviewController

@interface ZZPhotoPreviewController () <UICollectionViewDataSource, UICollectionViewDelegate>

/** 主视图，显示一张张图片界面 */
@property (nonatomic) UICollectionView *collectionView;

/** 头部视图 */
@property (nonatomic) ZZPreviewTopBar *topBar;

/** 顶部视图 */
@property (nonatomic) ZZPreviewBottomBar *bottomBar;

@property (nonatomic) BOOL hiddenBars;
@end

// ----------------------------------------------------------------

@implementation ZZPhotoPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCollectionView];
    [self addBars];
}

- (void)addBars {
    __weak typeof(self) weakSelf = self;
    self.topBar = [[ZZPreviewTopBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    
    [self.topBar setBackButtonHandler:^(UIButton *button) {
        if (weakSelf.backHandler) {
            weakSelf.backHandler(weakSelf);
        }
    }];
    [self.topBar setSelectButtonHandler:^(UIButton *button) {
        if (button.selected == NO) { // 若原来没有选中
            if (weakSelf.model.currentPhoto.type != ZZAssetModelMediaTypePhoto) {
                @throw [NSException exceptionWithName:@"自定义异常" reason:@"必须是图片" userInfo:nil];
            }
            ZZImagePickerController *pickerController = (ZZImagePickerController *)weakSelf.navigationController;
            // select:check if over the maxImagesCount / 选择照片,检查是否超过了最大个数的限制
            if ([weakSelf getSelectPhotos].count >= pickerController.configure.allowMaxCount) {
                [weakSelf zz_showAlertWithTitle:[NSString stringWithFormat:@"你最多只能选择%zd张照片", pickerController.configure.allowMaxCount]];
                return;
            } else { // if not over the maxImagesCount / 如果没有超过最大个数限制
                weakSelf.model.currentPhoto.isSelected = YES;
                [weakSelf.topBar setSelect:YES animated:YES];
                [weakSelf refreshBars:YES];
            }
        } else { // 若原来选中
            weakSelf.model.currentPhoto.isSelected = button.selected = NO;
            [weakSelf refreshBars:YES];
        }
    }];
    [self.view addSubview:self.topBar];
    
    self.bottomBar = [[ZZPreviewBottomBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44.0, self.view.frame.size.width, 44)];
    [self.bottomBar setOriginalButtonHandler:^(UIButton *button) {
        BOOL isSelect = !weakSelf.bottomBar.originPhotoButton.selected;
        weakSelf.model.isSelectOriginPhoto = weakSelf.bottomBar.originPhotoButton.selected = isSelect;
        weakSelf.bottomBar.originPhotoLabel.hidden = !isSelect;
        if (weakSelf.bottomBar.originPhotoLabel.isHidden == NO) [weakSelf refreshSelectPhotoBytes];
    }];
    [self.bottomBar setOkButtonHandler:^(UIButton *button) {
        if (weakSelf.okHandler) {
            weakSelf.okHandler(weakSelf);
        }
    }];
    
    [self.view addSubview:self.bottomBar];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self refreshBars:NO];
}

- (void)refreshBars:(BOOL)animated {
    if (self.hiddenBars == YES) return;
    ZZAssetModel *model = self.model.currentPhoto;
    [self.topBar setSelect:model.isSelected animated:NO];
    NSArray<ZZAssetModel *> *selectModels = [self getSelectPhotos];
    self.bottomBar.numberLable.text = [NSString stringWithFormat:@"%zd", selectModels.count];
    if (animated) {
        [UIView zz_showOscillatoryAnimationWithLayer:self.bottomBar.numberImageView.layer type:ZZOscillatoryAnimationToSmaller];
    }
    self.bottomBar.numberLable.hidden = self.bottomBar.numberImageView.hidden = selectModels.count <= 0;
    self.bottomBar.originPhotoButton.selected = self.model.isSelectOriginPhoto;
    self.bottomBar.originPhotoLabel.hidden = !self.bottomBar.originPhotoButton.isSelected;
    if (self.model.isSelectOriginPhoto) [self refreshSelectPhotoBytes];
}

- (void)refreshSelectPhotoBytes {
    [[ZZImageManager manager] getPhotoBytes:@[self.model.currentPhoto] completion:^(NSString *totalBytes) {
        self.bottomBar.originPhotoLabel.text = [NSString stringWithFormat:@"(%@)", totalBytes];
    }];
}

- (NSArray *)getSelectPhotos {
    return [self.model.photoArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected = YES"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.model.currentPhoto) {
        [self.collectionView setContentOffset:CGPointMake(self.view.frame.size.width * [self.model.photoArr indexOfObject:self.model.currentPhoto], 0) animated:NO];
    }
    // if (iOS7Later) [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)addCollectionView {
    // self.automaticallyAdjustsScrollViewInsets = NO;
    UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection              = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize                     = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    layout.minimumInteritemSpacing      = layout.minimumLineSpacing = 0;
    self.collectionView                 = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height) collectionViewLayout:layout];
    // self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.delegate        = self;
    self.collectionView.dataSource      = self;
    self.collectionView.pagingEnabled   = YES;
    // self.collectionView.scrollsToTop = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.contentOffset   = CGPointZero;
    // self.collectionView.contentSize  = CGSizeMake(self.view.frame.size.width * self.inputData.photoArr.count, self.view.frame.size.height);
    // [self.collectionView registerNib:(nullable UINib *) forCellWithReuseIdentifier:(nonnull NSString *)]
    [self.collectionView registerClass:[ZZPhotoPreviewCell class] forCellWithReuseIdentifier:@"ZZPhotoPreviewCell"];
    [self.view addSubview:self.collectionView];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.photoArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZZPhotoPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZZPhotoPreviewCell" forIndexPath:indexPath];
    cell.model = self.model.photoArr[indexPath.row];
    // cell.model = [self.previewModels objectAtIndex:indexPath.row];
    
    /**
    // Caching
    NSInteger startIndex = MAX(indexPath.row - 1, 0);
    NSInteger endIndex   = MIN(self.inputData.photoArr.count - 1, startIndex + 2);
    NSInteger count      = endIndex - startIndex + 1;
    PHCachingImageManager *manager = [[PHCachingImageManager alloc] init];
    // (nonnull NSArray<PHAsset *> *)
    NSMutableArray *cacheAssets = [NSMutableArray arrayWithCapacity:endIndex - startIndex + 1];
    for (NSInteger i = 0; i < count; i++) {
        ZZAssetModel *assetModel = [self.inputData.photoArr objectAtIndex:i];
        [cacheAssets addObject:assetModel.asset];
    }
    self.cacheManager = manager;
    [manager startCachingImagesForAssets:cacheAssets targetSize:[[UIScreen mainScreen] bounds].size contentMode:PHImageContentModeAspectFit options:nil];
     */
    typeof(self) weakSelf = self;
    if (!cell.singleTapHandler) {
        cell.singleTapHandler = ^() {
            BOOL isHidden = weakSelf.topBar.isHidden;
            self.hiddenBars = weakSelf.topBar.hidden = weakSelf.bottomBar.hidden = !isHidden;
            [self refreshBars:NO];
        };
    }
   
    return cell;
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.model.currentPhoto = [self.model.photoArr objectAtIndex:scrollView.contentOffset.x / self.view.frame.size.width];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self refreshBars:NO];
}

@end
