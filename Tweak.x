#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 1. تعريف مسميات البرو والماكس الشاملة
#define KREA_ALL_ACCESS [NSSet setWithObjects: \
    @"ai.krea.app.sub.creator.max.4.monthly", \
    @"ai.krea.app.sub.creator.max.4.yearly", \
    @"ai.krea.app.sub.creator.pro.2.monthly", \
    @"ai.krea.app.sub.creator.pro.2.yearly", \
    @"pro", @"max", @"premium", @"unlimited", nil]

// 2. رسالة ترحيب من متجرك عند تشغيل التطبيق (للتأكد أن التويك يعمل)
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = nil;
        if (@available(iOS 13.0, *)) {
            for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                    window = ((UIWindowScene *)scene).windows.firstObject;
                    break;
                }
            }
        }
        if (window && window.rootViewController) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"RDW ULTIMATE HACK" 
                message:@"Krea Pro & Unlimited Credits Active!\nBypassing Quota System..." 
                preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Let's Go!" style:UIAlertActionStyleDefault handler:nil]];
            [window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    });
}

// --- 3. اختراق نظام النقاط (الكوتا) 3/5 و 28/30 ---
%hook KreaQuotaManager
- (NSInteger)dailyRemaining { return 9999; }
- (NSInteger)monthlyRemaining { return 9999; }
- (BOOL)hasEnoughQuotaForModel:(id)arg1 { return YES; }
- (void)deductQuotaForModel:(id)arg1 { return; } // تعطيل الخصم نهائياً
%end

%hook KreaCreditManager
- (NSInteger)availableCredits { return 9999; }
- (void)deductCredits:(NSInteger)arg1 forModel:(id)arg2 { return; }
%end

// --- 4. فتح كل الميزات (FeatureFlags) والنماذج الغالية ---
%hook FeatureFlagsStore
- (BOOL)isMaxEnabled { return YES; }
- (BOOL)isProEnabled { return YES; }
- (BOOL)isSubscriptionActive { return YES; }
- (BOOL)canUseExpensiveModels { return YES; } // لفتح Sora 2 و Veo 3
- (BOOL)canUseRealtimeCamera { return YES; }
- (BOOL)isUpsellVisible { return NO; } // إخفاء إعلانات الاشتراك
%end

// --- 5. اختراق نظام المشتريات (RevenueCat) ---
%hook RCCustomerInfo
- (NSSet *)activeEntitlements { return KREA_ALL_ACCESS; }
- (NSSet *)allPurchasedProductIdentifiers { return KREA_ALL_ACCESS; }
%end

%hook RCEntitlementInfo
- (BOOL)isActive { return YES; }
- (long long)periodType { return 1; } // Trial or Paid
%end

// --- 6. اختراق بروفايل المستخدم (User Profile) ---
%hook KreaUser
- (BOOL)isSubscribed { return YES; }
- (NSString *)subscriptionTier { return @"max"; }
- (BOOL)isProUser { return YES; }
- (BOOL)hasActiveSubscription { return YES; }
%end

// --- 7. محاولة تزييف الـ API للهيدرز (النسخة المصححة لتجنب Build Error) ---
%hook KreaAPIClient
- (id)commonHeaders {
    id originalHeaders = %orig;
    if ([originalHeaders isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *headers = [originalHeaders mutableCopy];
        [headers setObject:@"max" forKey:@"x-subscription-tier"];
        [headers setObject:@"true" forKey:@"is-pro"];
        [headers setObject:@"true" forKey:@"is_subscriber"];
        return (id)headers;
    }
    return originalHeaders;
}
%end
