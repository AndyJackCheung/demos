//
//  ACKeyChainTool.h
//
//  Created by andylym on 2025/3/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Masonry.h"
#import <Toast/UIView+Toast.h>

//设备唯一标识符
#define UUID            [[[UIDevice currentDevice] identifierForVendor] UUIDString]
#define UUIDKey         @"UUIDKey"
#define USENAMEPASSWORD         @"USENAMEPASSWORD"//用户名和密码
#define KEYCHAIN_USERNAME         @"COM.WM.KEYCHAIN_USERNAME"//用户名和密码
#define KEYCHAIN_PASSWORD         @"COM.WM.KEYCHAIN_PASSWORD"//用户名和密码
//iPhoneX机型判断
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?  CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//图片
#define UIIMAGE(name) [UIImage imageNamed:name]


NS_ASSUME_NONNULL_BEGIN

@interface ACKeyChainTool : NSObject
/** 获取设备唯一标识符
 */
+ (NSString*)readUserUUID;
//保存用户账号和密码到钥匙串中
+(void)saveToKeychainWithUserName:(NSString*)UserName withPassword:(NSString*)password;
/** 获取钥匙串中保存的账号密码
 */
+(NSString*)getUserNameAndPasswordFromKeychain;

/// 保存密码和账号
/// - Parameters:
///   - UserName: UserName description
///   - password: password description
+ (void)saveLoginInfoToKeychainWithUserName:(NSString *)UserName withPassword:(NSString *)password;

/// 获取用户名
+ (NSString *)getUsernameFromKeychain;

/// 获取用户名
+ (NSString *)getPasswordFromKeychain;


@end

NS_ASSUME_NONNULL_END
