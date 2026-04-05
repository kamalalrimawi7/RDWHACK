#import <UIKit/UIKit.h>

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
            // الكود صح - دخول ناجح
        } else {
            // الكود غلط - توجيه للانستا وإعادة القفل
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.instagram.com/rimawi.dw"] options:@{} completionHandler:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                showRDWAlert();
            });
        }
    }];
    
    [alert addAction:loginAction];
    alert.modalInPresentation = YES; 

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
    if (root) {
        while (root.presentedViewController) root = root.presentedViewController;
        [root presentViewController:alert animated:YES completion:nil];
    }
}

__attribute__((constructor)) static void init() {
    // تم الضبط على ثانيتين (2.0) بناءً على طلبك يا وحش
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        showRDWAlert();
    });
}
