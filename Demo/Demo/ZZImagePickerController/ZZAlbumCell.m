//
//  ZZAlbumCell.m
//  Demo
//
//  Created by 刘威振 on 6/28/16.
//  Copyright © 2016 刘威振. All rights reserved.
//

#import "ZZAlbumCell.h"
#import "ZZImageManager.h"

@interface ZZAlbumCell ()

@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ZZAlbumCell

- (void)setModel:(ZZAlbumModel *)model {
    _model = model;
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:model.name attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSAttributedString *countString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  (%zd)",model.count] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    [nameString appendAttributedString:countString];
    self.nameLabel.attributedText = nameString;
    [[ZZImageManager manager] getPostImageWithAlbumModel:model completion:^(UIImage *postImage) {
        self.postImageView.image = postImage;
    }];
}

- (void)awakeFromNib {
    self.postImageView.clipsToBounds = YES;
}

@end
