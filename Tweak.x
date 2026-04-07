#import <Foundation/Foundation.h>

// تعريف الكلاسات للمترجم ليتخطى خطأ "Undeclared identifier"
@interface RCCustomerInfo : NSObject
- (NSSet *)activeEntitlements;
@end

@interface RCPurchases : NSObject
- (void)customerInfoWithCompletion:(void(^)(RCCustomerInfo *customerInfo, NSError *error))completion;
@end

// بداية الهوك
%hook RCCustomerInfo
- (NSSet *)activeEntitlements {
    return [NSSet setWithObjects:@"pro", @"premium", @"unlimited", nil];
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

