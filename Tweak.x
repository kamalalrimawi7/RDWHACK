#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// المسميات الحقيقية من ملفات التطبيق
#define KREA_IDS [NSSet setWithObjects: \
    @"ai.krea.app.sub.creator.max.4.monthly", \
    @"ai.krea.app.sub.creator.max.4.yearly", \
    @"ai.krea.app.sub.creator.pro.2.monthly", \
    @"ai.krea.app.sub.creator.pro.2.yearly", \
    @"pro", @"max", @"premium", nil]

// كود عرض الرسالة متوافق 100% مع معايير Apple الجديدة
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = nil;
        
        // طريقة حديثة للحصول على النافذة بدون استخدام keyWindow المرفوض
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
                message:@"Krea Pro Tweak Active!" 
                preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [window.rootViewController presentViewController:alert animated:YES completion:nil];
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

// 2. اختراق FeatureFlagsStore
%hook FeatureFlagsStore
- (BOOL)isSubscriptionActive { return YES; }
- (BOOL)isProEnabled { return YES; }
- (BOOL)isMaxEnabled { return YES; }
- (BOOL)canUseRealtimeTool { return YES; }
- (BOOL)isUpsellVisible { return NO; }
%end

// 3. اختراق بيانات المستخدم
%hook KreaUser
- (BOOL)isSubscribed { return YES; }
- (NSString *)subscriptionTier { return @"max"; }
%end
