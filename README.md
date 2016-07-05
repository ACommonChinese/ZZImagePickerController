# ZZImagePickerController
iOS图片多选 multi image select

## 需求

iOS图片多选



## 使用方法

1. 把文件夹ZZImagePickerController托入项目，并在需要使用的地方导入头文件

```
#import "ZZImagePickerController.h"
ZZImagePickerController *controller = [[ZZImagePickerController alloc] initWithConfigure:nil];
/**
ZZImagePickerController *controller2 = [[ZZImagePickerController alloc] initWithConfigure:^(ZZImagePickerConfigure *config) {
    config.allowMaxCount = 9; // 最多允许选择9张图片
    config.allowPickVideo = YES; // 允许选取视频
    config.allowPickOriginal = YES; // 允许显示图片大小
    ...
}];
 */
controller.pickDelegate = self;
[self presentViewController:controller animated:YES completion:nil];
```
2. 声明并实现协议：<ZZImagePickerControllerDelegate>

```
- (void)imagePickerController:(ZZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets infos:(NSArray<NSDictionary *> *)infos {
	// ...
}

- (void)imagePickerControllerDidCancel:(ZZImagePickerController *)picker {
	// ...
}

- (void)imagePickerController:(ZZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAsset:(PHAsset *)asset {
	// ...
}

```

**详情可参见Demo，效果图：**  

<img src="./images/1.png" width="320" height="568">
<img src="./images/2.png" width="320" height="568">
