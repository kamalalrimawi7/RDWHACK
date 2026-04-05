#import <UIKit/UIKit.h>

// --- إعدادات متجر Rimawi Digital World ---
#define STORE_NAME @"Rimawi Digital World"
#define ACCESS_KEY @"RDW2026" // الكود المطلوب للدخول
#define INSTA_URL @"https://www.instagram.com/rimawi.dw"

__attribute__((constructor)) static void init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // إنشاء التنبيه (Alert)
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:STORE_NAME 
                                                                       message:@"هذا التطبيق مقدم من متجرنا.\nالرجاء إدخال كود التفعيل للاستمرار:" 
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        // حقل إدخال الكود
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"كود التفعيل...";
            textField.textAlignment = NSTextAlignmentCenter;
        }];
        
        // زر التحقق والدخول
        UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"دخول" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            UITextField *codeField = alert.textFields.firstObject;
            if ([codeField.text isEqualToString:ACCESS_KEY]) {
                // الكود صح، يكمل المستخدم طبيعي
            } else {
                // الكود غلط، يفتح الانستا ويغلق التطبيق
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:INSTA_URL] options:@{} completionHandler:nil];
                exit(0);
            }
        }];
        
        // زر توجيه للانستقرام مباشرة
        UIAlertAction *instaAction = [UIAlertAction actionWithTitle:@"طلب كود / زيارة المتجر" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:INSTA_URL] options:@{} completionHandler:nil];
            exit(0);
        }];

        [alert addAction:loginAction];
        [alert addAction:instaAction];
        
        // إظهار الواجهة فوق أي شيء في التطبيق
        UIViewController *root = [[UIApplication sharedApplication] keyWindow].rootViewController;
        if (root) {
            [root presentViewController:alert animated:YES completion:nil];
        }
    });
}
