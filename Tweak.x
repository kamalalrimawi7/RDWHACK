#import <Foundation/Foundation.h>

// --- تعريف الكلاسات للمترجم بشكل دقيق ---
@interface RCCustomerInfo : NSObject
- (NSSet *)activeEntitlements;
@end

@interface RCPurchases : NSObject
- (void)customerInfoWithCompletion:(void(^)(RCCustomerInfo *customerInfo, NSError *error))completion;
@end
// ------------------------------------

%hook RCCustomerInfo
- (NSSet *)activeEntitlements {
    return [NSSet setWithObjects:@"pro", @"premium", @"unlimited", @"plus", nil];
}
%end

%hook RCPurchases
- (void)customerInfoWithCompletion:(void(^)(id customerInfo, NSError *error))completion {
    %orig(^(id customerInfo, NSError *error) {
        if (completion) {
            completion(customerInfo, nil);
        }
    });
}
%end
