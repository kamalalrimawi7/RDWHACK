#import <UIKit/UIKit.h>

__attribute__((constructor)) static void init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Rimawi Digital World" 
                                                                       message:@"هذا التطبيق مقدم من متجرنا.\nالرجاء إدخال كود التفعيل للاستمرار:" 
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"كود التفعيل...";
            textField.textAlignment = NSTextAlignmentCenter;
        }];
        
        UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"دخول" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            UITextField *codeField = alert.textFields.firstObject;
            if ([codeField.text isEqualToString:@"RDW2026"]) {
                // دخول ناجح
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.instagram.com/rimawi.dw"] options:@{} completionHandler:nil];
                exit(0);
            }
        }];
        
        [alert addAction:loginAction];

        // الطريقة الأضمن لإظهار الرسالة بدون Errors
        UIViewController *presenter = [UIApplication sharedApplication].windows.firstObject.rootViewController;
        
        // إذا كان هناك UIAlert أو شيء آخر معروض، نبحث عن الأعلى
        while (presenter.presentedViewController) {
            presenter = presenter.presentedViewController;
        }
        
        if (presenter) {
            [presenter presentViewController:alert animated:YES completion:nil];
        }
    });
}
