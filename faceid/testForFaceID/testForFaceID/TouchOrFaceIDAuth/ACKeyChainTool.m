//
//  ACKeyChainTool.m
//
//  Created by andylym on 2025/3/5.
//

#import "ACKeyChainTool.h"

@implementation ACKeyChainTool
/** 获取设备唯一标识符
 */
+ (NSString*)readUserUUID{
    NSMutableDictionary *userPwd = (NSMutableDictionary *)[self load:UUIDKey];
    NSString *uuid = [userPwd objectForKey:UUIDKey];
    if (uuid == nil) {
        NSMutableDictionary *keyChain = [NSMutableDictionary dictionary];
        [keyChain setObject:UUID forKey:UUIDKey];
        [self save:UUIDKey data:keyChain];
        uuid = [keyChain objectForKey:UUIDKey];
    }
    return uuid;
}
/** 保存用户账号和密码到钥匙串中
 */
+(void)saveToKeychainWithUserName:(NSString*)UserName withPassword:(NSString*)password{
    NSMutableDictionary *keyChain = [NSMutableDictionary dictionary];
    [keyChain setObject:[NSString stringWithFormat:@"%@%@",UserName,password] forKey:USENAMEPASSWORD];
    [self save:USENAMEPASSWORD data:keyChain];

}
/** 获取钥匙串中保存的账号密码
 */
+(NSString*)getUserNameAndPasswordFromKeychain{
    NSMutableDictionary *userPwd = (NSMutableDictionary *)[self load:USENAMEPASSWORD];
    NSString *UserNameAndPassword = [userPwd objectForKey:USENAMEPASSWORD];

    return UserNameAndPassword;
}

/// 保存密码和账号
/// - Parameters:
///   - UserName: UserName description
///   - password: password description
+ (void)saveLoginInfoToKeychainWithUserName:(NSString *)UserName withPassword:(NSString *)password{
    
    [self save:KEYCHAIN_PASSWORD data:password];
    [self save:KEYCHAIN_USERNAME data:UserName];
    
}

/// 获取用户名
+ (NSString *)getUsernameFromKeychain{
    
    return [self load:KEYCHAIN_USERNAME];
}

/// 获取用户名
+ (NSString *)getPasswordFromKeychain{
    
    return [self load:KEYCHAIN_PASSWORD];
}



//取
+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            service, (__bridge id)kSecAttrService,
            service, (__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible,
            nil];
}
//存
+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}


@end
