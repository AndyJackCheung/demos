集成face/touch id 功能


在Podfile文件中加入以下这两个库，当然，这两个库不是必须，

pod 'Masonry', '1.1.0'

pod 'Toast', '4.0.0'

再cd 到工程目录，再pod install安装这两个第三方库

导入头文件

#import "ACAuthVerifyViewController.h"

实现跳转

    ACAuthVerifyViewController *next = [[ACAuthVerifyViewController alloc] init];
    
    [next setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    [next setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    [self presentViewController:next animated:YES completion:^{
    
        [self.view makeToast:@"present success" duration:1.5 position:CSToastPositionCenter];
    
    }];
    
    
    
    
