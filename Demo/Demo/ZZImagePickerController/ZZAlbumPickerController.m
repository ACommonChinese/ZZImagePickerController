//
//  ZZAlbumPickerController.m
//  Demo
//
//  Created by 刘威振 on 6/28/16.
//  Copyright © 2016 刘威振. All rights reserved.
//

#import "ZZAlbumPickerController.h"
#import <Photos/Photos.h>
#import "ZZImageManager.h"
#import "ZZImagePickerController.h"
#import "ZZAlbumCell.h"

@interface ZZAlbumPickerController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSMutableArray *albumArray;
@property (nonatomic) UITableView *tableView;
@end

@implementation ZZAlbumPickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"照片";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    ZZImagePickerController *imagePickerController = (ZZImagePickerController *)self.navigationController;
    [[ZZImageManager manager] getAllAlbums:imagePickerController.configure.allowPickVideo completion:^(NSArray<ZZAlbumModel *> *albumModels) {
        self.albumArray = [NSMutableArray arrayWithArray:albumModels];
        [self configTableView];
    }];
}

- (void)configTableView {
    CGFloat top = 64;
    self.tableView                 = [[UITableView alloc] initWithFrame:CGRectMake(0, top, self.view.frame.size.width, self.view.frame.size.height - top) style:UITableViewStylePlain];
    self.tableView.rowHeight       = 70.0f;
    self.tableView.tableFooterView = UIView.new;
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    NSString *identifier           = NSStringFromClass([ZZAlbumCell class]);
    [self.tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
    [self.view addSubview:self.tableView];
}

#pragma mark - Click Event

- (void)cancel {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    ZZImagePickerController *pickerController = (ZZImagePickerController *)self.navigationController;
    if ([pickerController.pickDelegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        [pickerController.pickDelegate imagePickerControllerDidCancel:pickerController];
    }
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albumArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZAlbumCell"];
    cell.model = self.albumArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZPhotoPickerController *photoPickerVc = [[ZZPhotoPickerController alloc] init];
    photoPickerVc.model = self.albumArray[indexPath.row];
    [self.navigationController pushViewController:photoPickerVc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
