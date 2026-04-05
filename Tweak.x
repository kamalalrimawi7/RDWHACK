#import <UIKit/UIKit.h>

// دالة لإظهار التنبيه بشكل متكرر
static void showRDWAlert() {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Rimawi Digital World" 
                                                                   message:@"الرجاء إدخال كود التفعيل للاستمرار:" 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"أدخل كود RDW هنا...";
        textField.textAlignment = NSTextAlignmentCenter;
        textField.secureTextEntry = YES;
    }];
    
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"دخول" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        UITextField *codeField = alert.textFields.firstObject;
        
        if ([codeField.text isEqualToString:@"RDW2026"]) {
            // الكود صح - مبروك
        } else {
            // الكود غلط - افتح الانستا وارجع طلع التنبيه فوراً
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.instagram.com/rimawi.dw"] options:@{} completionHandler:nil];
            showRDWAlert(); 
        }
    }];
    
    [alert addAction:loginAction];

    // الطريقة الأضمن لإيجاد الـ Window بدون Errors
    UIWindow *window = nil;
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                window = scene.windows.firstObject;
                break;
            }
        }
    }
    if (!window) window = [UIApplication sharedApplication].windows.firstObject;

    UIViewController *root = window.rootViewController;
    while (root.presentedViewController) root = root.presentedViewController;
    
    [root presentViewController:alert animated:YES completion:nil];
}

__attribute__((constructor)) static void init() {
    // تشغيل سريع جداً (0.2 ثانية) عشان يظهر فوراً
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        showRDWAlert();
    });
}
