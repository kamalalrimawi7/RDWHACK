#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// كود لضمان استقرار الحقن في تطبيقات الـ IPA المحقونة يدوياً
%ctor {
    // الانتظار حتى يرسل النظام إشعار بأن التطبيق انتهى من التحميل تماماً
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification 
    object:nil 
    queue:[NSOperationQueue mainQueue] 
    usingBlock:^(NSNotification *note) {
        
        // تأخير إضافي لمدة 5 ثواني لضمان استقرار الواجهة (UI)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // محاولة العثور على مكتبة FLEX في الذاكرة
            Class flexClass = NSClassFromString(@"FLEXManager");
            
            if (flexClass) {
                // مناداة FLEX بطريقة أأمن (Safe Selector Call)
                id sharedManager = [flexClass performSelector:@selector(sharedManager)];
                if ([sharedManager respondsToSelector:@selector(showExplorer)]) {
                    [sharedManager performSelector:@selector(showExplorer)];
                    NSLog(@"[RDW] FLEX launched successfully!");
                }
            } else {
                // في حال لم يجد فليكس، بيعطيك تنبيه بسيط عشان تعرف وين المشكلة
                UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
                if (rootVC) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Rimawi Digital World" 
                                                                                   message:@"Tweak Injected, but FLEXing.dylib not found!" 
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                    [rootVC presentViewController:alert animated:YES completion:nil];
                }
            }
        });
    }];
}
