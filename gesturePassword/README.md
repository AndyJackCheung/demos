集成九宫格手势密码的绘制功能

导入头文件
#import "ACGesturePassword/ACGestureLockViewController.h"

在合适的跳转
    ACGestureLockViewController *next = [[ACGestureLockViewController alloc] initWithUnlockType:ACUnlockTypeValidatePsw];
    [next setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self presentViewController:next animated:YES completion:^{
        NSLog(@"---present success-------");
    }];
￼

