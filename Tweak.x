#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// المسميات اللي استخرجناها من ملف Storekit
#define KREA_IDS [NSSet setWithObjects: \
    @"ai.krea.app.sub.creator.max.4.monthly", \
    @"ai.krea.app.sub.creator.max.4.yearly", \
    @"ai.krea.app.sub.creator.pro.2.monthly", \
    @"ai.krea.app.sub.creator.pro.2.yearly", \
    @"pro", @"max", @"premium", nil]

// 1. هوك للتأكد من الحقن (أول ما يفتح التطبيق رح تطلع رسالة)
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Rimawi Digital World" 
            message:@"Krea Pro Tweak Loaded Successfully!" 
            preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}

// 2. اختراق RevenueCat (نظام المشتريات)
%hook RCCustomerInfo
- (NSSet *)activeEntitlements { return KREA_IDS; }
- (NSSet *)allPurchasedProductIdentifiers { return KREA_IDS; }
%end

%hook RCEntitlementInfo
- (BOOL)isActive { return YES; }
- (long long)periodType { return 1; }
%end

// 3. اختراق FeatureFlags (النظام اللي بيخفي الأزرار والميزات)
// الأسماء دي مستوحاة من ملف FeatureFlagsStore.swift اللي بالـ binary
%hook FeatureFlagsStore
- (BOOL)isSubscriptionActive { return YES; }
- (BOOL)isProEnabled { return YES; }
- (BOOL)isMaxEnabled { return YES; }
- (BOOL)canUseRealtimeTool { return YES; }
- (BOOL)isUpsellVisible { return NO; }
%end

// 4. اختراق كلاسات الـ User لضمان بقاء الحالة Pro
%hook KreaUser
- (BOOL)isSubscribed { return YES; }
- (NSString *)subscriptionTier { return @"max"; }
%end
