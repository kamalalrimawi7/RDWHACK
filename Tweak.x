#import <UIKit/UIKit.h>
#import <Security/Security.h>

// --- إعدادات السيرفر المركزية ---
static NSString *const RDW_DB_URL = @"https://rdw-server-default-rtdb.firebaseio.com/codes";
static NSString *const RDW_INSTA  = @"https://www.instagram.com/rimawi.dw";
static NSString *const RDW_WA     = @"https://wa.me/972567171874?text=طلب_تفعيل_متجر_RDW";

// --- مساعد الأمان والمزامنة ---
@interface RDWSecurity : NSObject
+ (NSString *)getUDID;
+ (void)saveLocal:(NSString *)val forKey:(NSString *)key;
+ (NSString *)loadLocal:(NSString *)key;
@end

@implementation RDWSecurity
+ (NSString *)getUDID { return [[[UIDevice currentDevice] identifierForVendor] UUIDString]; }
+ (void)saveLocal:(NSString *)val forKey:(NSString *)key {
    NSData *data = [val dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *q = @{(__bridge id)kSecClass:(__bridge id)kSecClassGenericPassword, (__bridge id)kSecAttrAccount:key, (__bridge id)kSecValueData:data};
    SecItemDelete((__bridge CFDictionaryRef)q);
    SecItemAdd((__bridge CFDictionaryRef)q, NULL);
}
+ (NSString *)loadLocal:(NSString *)key {
    NSDictionary *q = @{(__bridge id)kSecClass:(__bridge id)kSecClassGenericPassword, (__bridge id)kSecAttrAccount:key, (__bridge id)kSecReturnData:(__bridge id)kCFBooleanTrue, (__bridge id)kSecMatchLimit:(__bridge id)kSecMatchLimitOne};
    CFDataRef data = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)q, (CFTypeRef *)&data) == errSecSuccess) {
        return [[NSString alloc] initWithData:(__bridge NSData *)data encoding:NSUTF8StringEncoding];
    }
    return nil;
}
@end

// --- واجهة تسجيل الدخول (The Pro Alert) ---
@interface RDWLoginVC : UIViewController
@property (nonatomic, retain) UITextField *codeField;
@property (nonatomic, retain) UILabel *statusL;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@end

@implementation RDWLoginVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *bv = [[UIVisualEffectView alloc] initWithEffect:blur];
    bv.frame = self.view.bounds; [self.view addSubview:bv];

    UIView *cont = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-320)/2, (self.view.frame.size.height-500)/2, 320, 500)];
    cont.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.07 alpha:0.95];
    cont.layer.cornerRadius = 30; cont.layer.borderWidth = 1; 
    cont.layer.borderColor = [UIColor colorWithRed:0.72 green:0.56 blue:0.17 alpha:0.3].CGColor;
    [self.view addSubview:cont];

    // الشعار (Logo)
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(110, 30, 100, 100)];
    logo.layer.cornerRadius = 50; logo.clipsToBounds = YES;
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://i.ibb.co/7xZ41GWF/IMG-3601.jpg"] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        if (d) dispatch_async(dispatch_get_main_queue(), ^{ logo.image = [UIImage imageWithData:d]; });
    }] resume];
    [cont addSubview:logo];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 140, 320, 35)];
    title.text = @"Rimawi Digital World"; title.textColor = [UIColor whiteColor];
    title.font = [UIFont boldSystemFontOfSize:24]; title.textAlignment = NSTextAlignmentCenter; [cont addSubview:title];

    self.statusL = [[UILabel alloc] initWithFrame:CGRectMake(20, 180, 280, 50)];
    self.statusL.text = @"هذه نسخة حصرية لمتجر RDW\nيرجى تفعيل الكود للاستمرار"; self.statusL.numberOfLines = 2;
    self.statusL.textColor = [UIColor lightGrayColor]; self.statusL.font = [UIFont systemFontOfSize:14];
    self.statusL.textAlignment = NSTextAlignmentCenter; [cont addSubview:self.statusL];

    self.codeField = [[UITextField alloc] initWithFrame:CGRectMake(35, 245, 250, 50)];
    self.codeField.placeholder = @"أدخل كود RDW الحصري..."; self.codeField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.07];
    self.codeField.textColor = [UIColor whiteColor]; self.codeField.textAlignment = NSTextAlignmentCenter;
    self.codeField.layer.cornerRadius = 15; [cont addSubview:self.codeField];

    // زر التفعيل (ناري)
    UIButton *actBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    actBtn.frame = CGRectMake(35, 315, 250, 55); [actBtn setTitle:@"تفعيل واستمرار" forState:UIControlStateNormal];
    [actBtn setBackgroundColor:[UIColor colorWithRed:0.72 green:0.56 blue:0.17 alpha:1.0]];
    [actBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; 
    actBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18]; actBtn.layer.cornerRadius = 18;
    [actBtn addTarget:self action:@selector(validateOnline) forControlEvents:UIControlEventTouchUpInside];
    [cont addSubview:actBtn];

    // زر الشراء
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    buyBtn.frame = CGRectMake(35, 385, 250, 50); [buyBtn setTitle:@"شراء كود تفعيل RDW" forState:UIControlStateNormal];
    [buyBtn setBackgroundColor:[UIColor colorWithRed:0.15 green:0.68 blue:0.38 alpha:1.0]];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; buyBtn.layer.cornerRadius = 15;
    [buyBtn addTarget:self action:@selector(goWA) forControlEvents:UIControlEventTouchUpInside];
    [cont addSubview:buyBtn];

    UILabel *dev = [[UILabel alloc] initWithFrame:CGRectMake(0, 460, 320, 20)];
    dev.text = @"تم التفعيل بواسطة المطوّر كمال"; dev.textColor = [UIColor darkGrayColor];
    dev.font = [UIFont systemFontOfSize:10]; dev.textAlignment = NSTextAlignmentCenter; [cont addSubview:dev];

    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.spinner.center = actBtn.center; [cont addSubview:self.spinner];
}

- (void)validateOnline {
    [self.spinner startAnimating];
    NSString *input = self.codeField.text;
    NSString *myUDID = [RDWSecurity getUDID];
    NSString *apiPath = [NSString stringWithFormat:@"%@/%@.json", RDW_DB_URL, input];

    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:apiPath] completionHandler:^(NSData *data, NSURLResponse *res, NSError *err) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
            if (err || !data) { self.statusL.text = @"خطأ: تأكد من اتصالك بالإنترنت!"; return; }

            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if ([json isEqual:[NSNull null]]) { [self failAction:@"الكود غير صحيح أو غير موجود!"]; return; }

            NSString *usedBy = json[@"usedBy"];
            if (![usedBy isEqualToString:@""] && ![usedBy isEqualToString:myUDID]) {
                self.statusL.text = @"هذا الكود مفعل على جهاز آخر!"; self.statusL.textColor = [UIColor redColor]; return;
            }

            [self finalizeActivation:input udid:myUDID serverExp:[json[@"expiry"] doubleValue]];
        });
    }] resume];
}

- (void)finalizeActivation:(NSString *)code udid:(NSString *)udid serverExp:(double)sExp {
    double now = [[NSDate date] timeIntervalSince1970];
    double newExp = (sExp > now ? sExp : now) + (30 * 86400); // إضافة 30 يوم

    NSDictionary *patch = @{@"usedBy": udid, @"expiry": @(newExp)};
    NSData *pData = [NSJSONSerialization dataWithJSONObject:patch options:0 error:nil];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json", RDW_DB_URL, code]]];
    [req setHTTPMethod:@"PATCH"]; [req setHTTPBody:pData];

    [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        if (!e) dispatch_async(dispatch_get_main_queue(), ^{
            [RDWSecurity saveLocal:[NSString stringWithFormat:@"%f", newExp] forKey:@"RDW_EXP"];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }] resume];
}

- (void)failAction:(NSString *)msg {
    self.statusL.text = msg; self.statusL.textColor = [UIColor orangeColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RDW_INSTA] options:@{} completionHandler:nil];
    });
}

- (void)goWA { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RDW_WA] options:@{} completionHandler:nil]; }
- (BOOL)modalInPresentation { return YES; }
@end

// --- الهوك الرئيسي في النظام ---
%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        [self performSelector:@selector(checkRDWSubscription) withObject:nil afterDelay:1.0];
    });
}

%new
- (void)checkRDWSubscription {
    NSString *localExp = [RDWSecurity loadLocal:@"RDW_EXP"];
    double now = [[NSDate date] timeIntervalSince1970];

    if (!localExp || [localExp doubleValue] < now) {
        RDWLoginVC *vc = [[RDWLoginVC alloc] init];
        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self.rootViewController presentViewController:vc animated:YES completion:nil];
    }
}
%end
