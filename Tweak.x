#import <UIKit/UIKit.h>

// --- إعدادات متجر Rimawi Digital World ---
#define STORE_NAME @"Rimawi Digital World"
#define ACCESS_KEY @"RDW2026" 
#define INSTA_URL @"https://www.instagram.com/rimawi.dw"

__attribute__((constructor)) static void init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:STORE_NAME 
                                                                       message:@"هذا التطبيق مقدم من متجرنا.\nالرجاء إدخال كود التفعيل للاستمرار:" 
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"كود التفعيل...";
            textField.textAlignment = NSTextAlignmentCenter;
        }];
        
        UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"دخول" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            UITextField *codeField = alert.textFields.firstObject;
            if ([codeField.text isEqualToString:ACCESS_KEY]) {
                // دخول ناجح
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:INSTA_URL] options:@{} completionHandler:nil];
                exit(0);
            }
        }];
        
        UIAlertAction *instaAction = [UIAlertAction actionWithTitle:@"طلب كود / زيارة المتجر" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:INSTA_URL] options:@{} completionHandler:nil];
            exit(0);
        }];

        [alert addAction:loginAction];
        [alert addAction:instaAction];
        
        // --- الطريقة الصحيحة والحديثة لإظهار الرسالة (بدل keyWindow) ---
        UIWindow *window = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
                if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                    for (UIWindow *w in windowScene.windows) {
                        if (w.isKeyWindow) {
                            window = w;
                            break;
                        }
                    }
                }
            }
        } else {
            window = [UIApplication sharedApplication].keyWindow;
        }

        UIViewController *root = window.rootViewController;
        if (root) {
            [root presentViewController:alert animated:YES completion:nil];
        }
    });
}
