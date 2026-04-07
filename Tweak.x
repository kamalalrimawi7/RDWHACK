#import <Foundation/Foundation.h>

// --- تعريف الواجهات للمترجم ---
@interface RCCustomerInfo : NSObject
- (NSSet *)activeEntitlements;
@end

@interface RCPurchases : NSObject
- (void)customerInfoWithCompletion:(void(^)(id info, id error))completion;
@end
// -----------------------------

%hook RCCustomerInfo
- (NSSet *)activeEntitlements {
    // إرجاع مسميات البريميوم الشائعة
    return [NSSet setWithObjects:@"pro", @"premium", @"unlimited", @"plus", nil];
}
%end

%hook RCPurchases
- (void)customerInfoWithCompletion:(void(^)(id info, id error))completion {
    // حل مشكلة الأقواس عبر تعريف الـ Block بشكل منفصل
    void (^modifiedCompletion)(id, id) = ^(id info, id error) {
        if (completion) {
            completion(info, nil);
        }
    };
    
    // تمرير الـ Block الجديد الجاهز
    %orig(modifiedCompletion);
}
%end
