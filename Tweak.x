#import <Foundation/Foundation.h>

// --- تعريف الكلاسات للمترجم (مهم جداً لحل خطأ Makefile) ---
@interface RCCustomerInfo : NSObject
- (NSSet *)activeEntitlements;
@end

@interface RCPurchases : NSObject
+ (instancetype)sharedPurchases;
- (void)customerInfoWithCompletion:(void(^)(RCCustomerInfo *customerInfo, NSError *error))completion;
@end
// -------------------------------------------------------

%hook RCCustomerInfo
- (NSSet *)activeEntitlements {
    // إرجاع ميزات البريميوم
    return [NSSet setWithObjects:@"pro", @"premium", @"unlimited", @"plus", nil];
}
%end

%hook RCPurchases
- (void)customerInfoWithCompletion:(void(^)(id customerInfo, NSError *error))completion {
    %orig(^(id customerInfo, NSError *error) {
        if (completion) {
            // إرجاع المعلومات للمستخدم وكأنها بريميوم وبدون أخطاء
            completion(customerInfo, nil);
        }
    });
}
%end
