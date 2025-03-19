
#import "ViewController.h"
#import "ACAuthVerifyViewController.h"
#import <Toast/UIView+Toast.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)touchOrFaceIDAuthBtnAction:(UIButton *)sender {
    ACAuthVerifyViewController *next = [[ACAuthVerifyViewController alloc] init];
    [next setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [next setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self presentViewController:next animated:YES completion:^{
        [self.view makeToast:@"present success" duration:1.5 position:CSToastPositionCenter];
    }];
}


@end
