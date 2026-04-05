#import <UIKit/UIKit.h>

__attribute__((constructor)) static void init() {
    // تقليل الوقت لـ 0.5 ثانية فقط عشان يظهر بسرعة البرق
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // تعريف دالة إظهار الرسالة عشان نكررها إذا الكود غلط
        void (^ __block showLoginAlert)(void) = ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Rimawi Digital World" 
                                                                           message:@"الرجاء إدخال كود التفعيل للاستمرار:" 
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = @"أدخل كود RDW هنا...";
                textField.textAlignment = NSTextAlignmentCenter;
                textField.secureTextEntry = YES; // اختياري: إذا بدك الكود مخفي
            }];
            
            // زر الدخول
            UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"دخول" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                UITextField *codeField = alert.textFields.firstObject;
                
                if ([codeField.text isEqualToString:@"RDW2026"]) {
                    // الكود صح - مبروك دخل المستخدم
                } else {
                    // الكود غلط - بنفتح الانستا وبنرجع نطلع الرسالة "خاوة"
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.instagram.com/rimawi.dw"] options:@{} completionHandler:nil];
                    showLoginAlert(); // تكرار الرسالة لمنع الدخول
                }
            }];
            
            [alert addAction:loginAction];

            // إيجاد واجهة التطبيق لإظهار الرسالة
            UIWindow *window = nil;
            for (UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    window = scene.windows.firstObject;
                    break;
                }
            }
            if (!window) window = [UIApplication sharedApplication].keyWindow;

            UIViewController *root = window.rootViewController;
            while (root.presentedViewController) root = root.presentedViewController;
            
            [root presentViewController:alert animated:YES completion:nil];
        };

        // تشغيل الدالة لأول مرة
        showLoginAlert();
    });
}
