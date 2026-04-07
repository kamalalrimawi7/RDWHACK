#import <Foundation/Foundation.h>

// هوك لمكتبة RevenueCat لضمان تفعيل الاشتراك
%hook RCCustomerInfo
- (NSSet *)activeEntitlements {
    // نرسل مسميات البريميوم الشائعة لضمان فتح الميزات
    return [NSSet setWithObjects:@"pro", @"premium", @"unlimited", @"plus", nil];
}

- (BOOL)isPremium {
    return YES;
}
%end

// هوك إضافي للتأكد من حالة الشراء
%hook RCPurchases
- (void)customerInfoWithCompletion:(void(^)(id customerInfo, NSError *error))completion {
    %orig(^(id customerInfo, NSError *error) {
        if (completion) {
            completion(customerInfo, nil);
        }
    });
}
%end

// منع التطبيق من اكتشاف التعديل (Anti-Jailbreak/Anti-Tamper)
%hook NSBundle
- (id)objectForInfoDictionaryKey:(NSString *)key {
    if ([key isEqualToString:@"SignerIdentity"]) {
        return nil;
    }
    return %orig;
}
%end

