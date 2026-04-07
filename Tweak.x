#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// المسميات الحقيقية من ملف Configuration.storekit الذي رفعته
#define KREA_IDS [NSSet setWithObjects: \
    @"ai.krea.app.sub.creator.max.4.monthly", \
    @"ai.krea.app.sub.creator.max.4.yearly", \
    @"ai.krea.app.sub.creator.pro.2.monthly", \
    @"ai.krea.app.sub.creator.pro.2.yearly", \
    @"pro", @"max", @"premium", nil]

// رسالة تأكيد الحقن (ستظهر بعد 3 ثواني من فتح التطبيق)
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Rimawi Digital World" 
            message:@"Krea Pro Tweak Active!" 
            preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        if ([[UIApplication sharedApplication] keyWindow].rootViewController) {
            [[UIApplication sharedApplication] keyWindow].rootViewController.presentViewController(alert, animated:YES, completion:nil);
        }
    });
}

// 1. اختراق RevenueCat
%hook RCCustomerInfo
- (NSSet *)activeEntitlements { return KREA_IDS; }
- (NSSet *)allPurchasedProductIdentifiers { return KREA_IDS; }
%end

%hook RCEntitlementInfo
- (BOOL)isActive { return YES; }
- (long long)periodType { return 1; }
%end

// 2. اختراق FeatureFlagsStore (بناءً على ملفات ConfigCat المرفوعة)
%hook FeatureFlagsStore
- (BOOL)isSubscriptionActive { return YES; }
- (BOOL)isProEnabled { return YES; }
- (BOOL)isMaxEnabled { return YES; }
- (BOOL)canUseRealtimeTool { return YES; }
- (BOOL)isUpsellVisible { return NO; }
%end

// 3. اختراق بيانات المستخدم الأساسية
%hook KreaUser
- (BOOL)isSubscribed { return YES; }
- (NSString *)subscriptionTier { return @"max"; }
%end
