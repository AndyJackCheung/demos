//
//  ACAuthID.h
//
//  Created by andylym on 2025/3/5.
//

#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>

/**
 *  TouchID/FaceID 状态
 */
typedef NS_ENUM(NSUInteger, ACAuthIDState){
    
    /**
     *  当前设备不支持TouchID/FaceID
     */
    ACAuthIDStateNotSupport = 0,
    /**
     *  TouchID/FaceID 验证成功
     */
    ACAuthIDStateSuccess = 1,
    
    /**
     *  TouchID/FaceID 验证失败
     */
    ACAuthIDStateFail = 2,
    /**
     *  TouchID/FaceID 被用户手动取消
     */
    ACAuthIDStateUserCancel = 3,
    /**
     *  用户不使用TouchID/FaceID,选择手动输入密码
     */
    ACAuthIDStateInputPassword = 4,
    /**
     *  TouchID/FaceID 被系统取消 (如遇到来电,锁屏,按了Home键等)
     */
    ACAuthIDStateSystemCancel = 5,
    /**
     *  TouchID/FaceID 无法启动,因为用户没有设置密码
     */
    ACAuthIDStatePasswordNotSet = 6,
    /**
     *  TouchID/FaceID 无法启动,因为用户没有设置TouchID/FaceID
     */
    ACAuthIDStateTouchIDNotSet = 7,
    /**
     *  TouchID/FaceID 无效
     */
    ACAuthIDStateTouchIDNotAvailable = 8,
    /**
     *  TouchID/FaceID 被锁定(连续多次验证TouchID/FaceID失败,系统需要用户手动输入密码)
     */
    ACAuthIDStateTouchIDLockout = 9,
    /**
     *  当前软件被挂起并取消了授权 (如App进入了后台等)
     */
    ACAuthIDStateAppCancel = 10,
    /**
     *  当前软件被挂起并取消了授权 (LAContext对象无效)
     */
    ACAuthIDStateInvalidContext = 11,
    /**
     *  系统版本不支持TouchID/FaceID (必须高于iOS 8.0才能使用)
     */
    ACAuthIDStateVersionNotSupport = 12
};

@interface ACAuthID : LAContext

typedef void (^ACAuthIDStateBlock)(ACAuthIDState state, NSError *error);

/**
 * 启动TouchID/FaceID进行验证
 * @param describe TouchID/FaceID显示的描述
 * @param block 回调状态的block
 */
- (void)AC_showAuthIDWithDescribe:(NSString *)describe block:(ACAuthIDStateBlock)block;

@end

