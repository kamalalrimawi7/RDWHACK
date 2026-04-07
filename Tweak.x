#import <Foundation/Foundation.h>

// المسميات الحقيقية المستخرجة من ملفات التطبيق
#define KREA_IDS [NSSet setWithObjects: \
    @"ai.krea.app.sub.creator.max.4.monthly", \
    @"ai.krea.app.sub.creator.max.4.yearly", \
    @"ai.krea.app.sub.creator.pro.2.monthly", \
    @"ai.krea.app.sub.creator.pro.2.yearly", \
    @"pro", @"max", @"premium", @"plus", @"unlimited", @"compute", nil]

// هوك لمعلومات العميل
%hook RCCustomerInfo
- (NSSet *)activeEntitlements { return KREA_IDS; }
- (NSSet *)allPurchasedProductIdentifiers { return KREA_IDS; }
- (NSDictionary *)entitlements { return %orig; } // يمكن توسيعه لاحقاً لو لزم
%end

// هوك لمعلومات الاستحقاق نفسه
%hook RCEntitlementInfo
- (BOOL)isActive { return YES; }
- (void)setIsActive:(BOOL)arg1 { %orig(YES); }
- (BOOL)willRenew { return YES; }
- (long long)periodType { return 1; } // 1 تعني Normal (ليس تجريبي)
%end

// هوك إضافي لضمان عدم وجود أخطاء في واجهة المشتريات
%hook RCPurchases
- (void)customerInfoWithCompletion:(void(^)(id info, id error))completion {
    void (^modifiedCompletion)(id, id) = ^(id info, id error) {
        if (completion) completion(info, nil);
    };
    %orig(modifiedCompletion);
}
%end

// منع التطبيق من إرسال بيانات التحليل التي قد تكشف التزييف
%hook PostHog
- (void)capture:(id)arg1 properties:(id)arg2 { return; }
%end
