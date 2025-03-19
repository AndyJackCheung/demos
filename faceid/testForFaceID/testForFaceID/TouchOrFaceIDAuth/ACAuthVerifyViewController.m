//
//  ACAuthVerifyViewController.m
//
//  Created by andylym on 2025/3/5.
//

#import "ACAuthVerifyViewController.h"
#import "ACAuthID.h"
#import "ACKeyChainTool.h"

@interface ACAuthVerifyViewController ()

@property (strong, nonatomic) UIImageView * imageV;

@end

@implementation ACAuthVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createVerifyUIStyle];
    
    [self lockVerify];
    
}
- (void)createVerifyUIStyle{
    
    NSString * username = [ACKeyChainTool getUsernameFromKeychain];
    
    NSString * newUsername = @"";
    if ([username length] > 0) {
        if ([username containsString:@"@"]) {
            NSArray * usernameArr = [username componentsSeparatedByString:@"@"];
            NSString * startStr = [usernameArr.firstObject substringToIndex:3];
            newUsername = [NSString stringWithFormat:@"%@***%@", startStr, usernameArr.lastObject];
        }else{
            
            NSString * startStr = [username substringToIndex:2];
            NSString * endStr = [username substringFromIndex:username.length - 2];
            newUsername = [NSString stringWithFormat:@"%@***%@", startStr, endStr];
        }
    }
    
    self.imageV = [[UIImageView alloc] init];
    [self.imageV setUserInteractionEnabled:true];
    [self.view addSubview:self.imageV];
    [self.imageV setImage:UIIMAGE(IS_IPHONE_X ? @"ic_faceid_login" : @"ic_touchid_login")];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY).offset(-40);
        make.centerX.equalTo(self.view);
    }];
    
    UITapGestureRecognizer * tapgest = [[UITapGestureRecognizer alloc] init];
    [self.imageV addGestureRecognizer:tapgest];
    [tapgest addTarget:self action:@selector(touchLock)];
    
    UILabel * tipLab = [[UILabel alloc] init];
    [tipLab setText:IS_IPHONE_X ? @"轻触以使用Face ID解锁" : @"轻触以使用Touch ID解锁"];
    [self.view addSubview:tipLab];
    [tipLab setTextColor:[UIColor darkGrayColor]];
    [tipLab setFont:[UIFont systemFontOfSize:12]];
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageV.mas_bottom).offset(5);
        make.centerX.equalTo(self.view);
    }];
    
    UILabel * accountLab = [[UILabel alloc] init];
    [accountLab setText:newUsername];
    [accountLab setTextColor:UIColor.whiteColor];
    [self.view addSubview:accountLab];
    [accountLab setFont: [UIFont systemFontOfSize:18]];
    [accountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(tipLab.mas_bottom).offset(10);
    }];
}
- (void)touchLock{
    
    [self lockVerify];
    
}

- (void)lockVerify{
    
    ACAuthID * authID = [[ACAuthID alloc] init];
    [authID AC_showAuthIDWithDescribe:nil block:^(ACAuthIDState state, NSError *error) {
        if (state == ACAuthIDStateNotSupport) { // 不支持TouchID/FaceID
            NSLog(@"对不起，当前设备不支持指纹/面容ID");
            [self.view makeToast:@"当前设备不支持指纹/面容ID" duration:1.5 position:CSToastPositionCenter];
        } else if(state == ACAuthIDStateFail) { // 认证失败
            NSLog(@"指纹/面容ID不正确，认证失败");
            [self.view makeToast:@"指纹/面容ID不正确，认证失败" duration:1.5 position:CSToastPositionCenter];
        } else if(state == ACAuthIDStateTouchIDLockout) {   // 多次错误，已被锁定
            NSLog(@"多次错误，指纹/面容ID已被锁定，请到手机解锁界面输入密码");
            [self.view makeToast:@"多次错误，指纹/面容ID已被锁定，请到手机解锁界面输入密码" duration:1.5 position:CSToastPositionCenter];
        } else if (state == ACAuthIDStateSuccess) { // TouchID/FaceID验证成功
            [self.view makeToast:@"TouchID/FaceID验证成功" duration:1.5 position:CSToastPositionCenter];
            [self dismissViewControllerAnimated:true completion:^{}];
        }
    }];
    
}

@end
