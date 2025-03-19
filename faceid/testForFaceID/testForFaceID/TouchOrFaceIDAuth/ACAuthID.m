//
//  ACAuthID.m
//
//  Created by andylym on 2025/3/5.
//

#import "ACAuthID.h"

#define iPhoneX (UIScreen.mainScreen.bounds.size.width >= 375.f && UIScreen.mainScreen.bounds.size.height >= 812.f)


@implementation ACAuthID

+ (instancetype)sharedInstance {
    static ACAuthID *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ACAuthID alloc] init];
    });
    return instance;
}

- (void)AC_showAuthIDWithDescribe:(NSString *)describe block:(ACAuthIDStateBlock)block {
    if(!describe) {
        if(iPhoneX){
            describe = @"验证已有面容";
        }else{
            describe = @"通过Home键验证已有指纹";
        }
    }
    
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"系统版本不支持TouchID/FaceID (必须高于iOS 8.0才能使用)");
            block(ACAuthIDStateVersionNotSupport, nil);
        });
        
        return;
    }
    
    LAContext *context = [[LAContext alloc] init];
    
    // 认证失败提示信息，为 @"" 则不提示
    context.localizedFallbackTitle = @"输入密码";
    
    NSError *error = nil;
    
    // LAPolicyDeviceOwnerAuthenticationWithBiometrics: 用TouchID/FaceID验证
    // LAPolicyDeviceOwnerAuthentication: 用TouchID/FaceID或密码验证, 默认是错误两次或锁定后, 弹出输入密码界面（本案例使用）
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:describe reply:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"TouchID/FaceID 验证成功");
                    block(ACAuthIDStateSuccess, error);
                });
            }else if(error){
                
                if (@available(iOS 11.0, *)) {
                    switch (error.code) {
                        case LAErrorAuthenticationFailed:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"TouchID/FaceID 验证失败");
                                block(ACAuthIDStateFail, error);
                            });
                            break;
                        }
                        case LAErrorUserCancel:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"TouchID/FaceID 被用户手动取消");
                                block(ACAuthIDStateUserCancel, error);
                            });
                        }
                            break;
                        case LAErrorUserFallback:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"用户不使用TouchID/FaceID,选择手动输入密码");
                                block(ACAuthIDStateInputPassword, error);
                            });
                        }
                            break;
                        case LAErrorSystemCancel:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"TouchID/FaceID 被系统取消 (如遇到来电,锁屏,按了Home键等)");
                                block(ACAuthIDStateSystemCancel, error);
                            });
                        }
                            break;
                        case LAErrorPasscodeNotSet:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"TouchID/FaceID 无法启动,因为用户没有设置密码");
                                block(ACAuthIDStatePasswordNotSet, error);
                            });
                        }
                            break;
                            //case LAErrorTouchIDNotEnrolled:{
                        case LAErrorBiometryNotEnrolled:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"TouchID/FaceID 无法启动,因为用户没有设置TouchID/FaceID");
                                block(ACAuthIDStateTouchIDNotSet, error);
                            });
                        }
                            break;
                            //case LAErrorTouchIDNotAvailable:{
                        case LAErrorBiometryNotAvailable:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"TouchID/FaceID 无效");
                                block(ACAuthIDStateTouchIDNotAvailable, error);
                            });
                        }
                            break;
                            //case LAErrorTouchIDLockout:{
                        case LAErrorBiometryLockout:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"TouchID/FaceID 被锁定(连续多次验证TouchID/FaceID失败,系统需要用户手动输入密码)");
                                block(ACAuthIDStateTouchIDLockout, error);
                            });
                        }
                            break;
                        case LAErrorAppCancel:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"当前软件被挂起并取消了授权 (如App进入了后台等)");
                                block(ACAuthIDStateAppCancel, error);
                            });
                        }
                            break;
                        case LAErrorInvalidContext:{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"当前软件被挂起并取消了授权 (LAContext对象无效)");
                                block(ACAuthIDStateInvalidContext, error);
                            });
                        }
                            break;
                        default:
                            break;
                    }
                }
                
            }
        }];
        
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"当前设备不支持TouchID/FaceID");
            block(ACAuthIDStateNotSupport, error);
        });
        
    }
}



@end
