#import <Foundation/Foundation.h>

// ==========================================
// 1. تعريف الواجهات (Interfaces) للمترجم
// ==========================================
@interface RCCustomerInfo : NSObject
- (NSSet *)activeEntitlements;
- (NSSet *)allPurchasedProductIdentifiers;
@end

@interface RCEntitlementInfo : NSObject
- (BOOL)isActive;
- (BOOL)willRenew;
@end

@interface RCPurchases : NSObject
- (void)customerInfoWithCompletion:(void(^)(id info, id error))completion;
@end

// ==========================================
// 2. قائمة ضخمة بكل مسميات الاشتراكات المحتملة
// ==========================================
#define FAKE_TIERS [NSSet setWithObjects:@"pro", @"premium", @"max", @"unlimited", @"plus", @"vip", @"gold", @"subscription", @"yearly", @"monthly", @"Max", @"Pro", @"Premium", @"individual_max_yearly", @"individual_pro_yearly", @"individual_max_monthly", @"individual_pro_monthly", @"compute", @"credits", @"all_access", nil]

// ==========================================
// 3. اختراق معلومات العميل (RCCustomerInfo)
// ==========================================
%hook RCCustomerInfo

- (NSSet *)activeEntitlements {
    return FAKE_TIERS;
}

- (NSSet *)allPurchasedProductIdentifiers {
    return FAKE_TIERS;
}

%end

// ==========================================
// 4. إجبار أي اشتراك يتم فحصه على أن يكون فعالاً
// ==========================================
%hook RCEntitlementInfo

- (BOOL)isActive {
    return YES;
}

- (BOOL)willRenew {
    return YES;
}

%end

// ==========================================
// 5. اختراق مدير المشتريات لتخطي الأخطاء
// ==========================================
%hook RCPurchases

- (void)customerInfoWithCompletion:(void(^)(id info, id error))completion {
    void (^modifiedCompletion)(id, id) = ^(id info, id error) {
        if (completion) {
            completion(info, nil);
        }
    };
    %orig(modifiedCompletion);
}

%end
