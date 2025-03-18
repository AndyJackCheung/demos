集成信息弹窗toast功能

使用cocoapods安装第三方库文件
pod 'Toast', '4.0.0'

并在合适的地方，导入头文件
#import <Toast/UIView+Toast.h>

调用方法
[self.view makeToast:@"test message" duration:1.5 position:CSToastPositionCenter];

便会显示如下信息弹窗toast
￼
/var/folders/sp/877kfvm127j515_z5vltctpm0000gn/T/TemporaryItems/NSIRD_screencaptureui_GQjBI0/截屏2025-03-18 10.47.45.png
