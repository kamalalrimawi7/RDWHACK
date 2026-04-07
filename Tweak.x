#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 1. تعريف كل المعرفات الممكنة للبرو والماكس
#define KREA_IDS [NSSet setWithObjects: \
    @"ai.krea.app.sub.creator.max.4.monthly", \
    @"ai.krea.app.sub.creator.max.4.yearly", \
    @"ai.krea.app.sub.creator.pro.2.monthly", \
    @"ai.krea.app.sub.creator.pro.2.yearly", \
    @"pro", @"max", @"premium", @"creator", nil]

// 2. رسالة التأكيد (معدلة لتجنب أخطاء السيرفر)
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Rimawi Digital World" 
                message:@"Krea Ultimate Hack Active!\nKling & Veo Bypass Engaged." 
                preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Let's Go!" style:UIAlertActionStyleDefault handler:nil]];
            [window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    });
}

// 3. اختراق نظام المشتريات (RevenueCat)
%hook RCCustomerInfo
- (NSSet *)activeEntitlements { return KREA_IDS; }
- (NSSet *)allPurchasedProductIdentifiers { return KREA_IDS; }
%end

%hook RCEntitlementInfo
- (BOOL)isActive { return YES; }
- (long long)periodType { return 1; } // Trial or Paid
%end

// 4. اختراق نظام الائتمان (Credits) - تجميد النقاط
%hook KreaCreditManager
- (NSInteger)availableCredits { return 999999; }
- (BOOL)hasEnoughCreditsForModel:(id)arg1 { return YES; }
- (void)deductCredits:(NSInteger)arg1 forModel:(id)arg2 { return; } // منع الخصم
%end

// 5. اختراق الميزات (FeatureFlags) - فتح كل الأزرار والريل تايم
%hook FeatureFlagsStore
- (BOOL)isSubscriptionActive { return YES; }
- (BOOL)isProEnabled { return YES; }
- (BOOL)isMaxEnabled { return YES; }
- (BOOL)canUseRealtimeTool { return YES; }
- (BOOL)isUpsellVisible { return NO; }
%end

// 6. اختراق الـ API (محاولة تزييف الطلب للسيرفر)
%hook KreaAPIClient
- (NSDictionary *)commonHeaders {
    NSMutableDictionary *headers = [[%orig] mutableCopy];
    [headers setObject:@"max" forKey:@"x-subscription-tier"];
    [headers setObject:@"true" forKey:@"x-is-pro"];
    [headers setObject:@"true" forKey:@"is_subscriber"];
    return headers;
}
%end

// 7. اختراق بيانات المستخدم (User Profile)
%hook KreaUser
- (BOOL)isSubscribed { return YES; }
- (NSString *)subscriptionTier { return @"max"; }
- (BOOL)hasActiveSubscription { return YES; }
%end
