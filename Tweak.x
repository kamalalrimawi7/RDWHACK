#import <UIKit/UIKit.h>
#import <Security/Security.h>

// --- إعدادات متجر RDW ---
static NSString *const RDW_DB_URL = @"https://rdw-server-default-rtdb.firebaseio.com/codes";
static NSString *const RDW_INSTA  = @"https://www.instagram.com/rimawi.dw";
static NSString *const RDW_WA     = @"https://wa.me/972567171874?text=طلب_تفعيل_متجر_RDW";

#define RDW_GOLD [UIColor colorWithRed:0.72 green:0.56 blue:0.17 alpha:1.0]
#define RDW_GREEN [UIColor colorWithRed:0.15 green:0.68 blue:0.38 alpha:1.0]

// تعريف الواجهة لحل مشكلة الـ Build في GitHub
@interface UIWindow (RDW)
- (void)rdw_security_check;
- (void)rdw_lock_screen;
- (void)rdw_show_panel;
@end

@interface RDWSecurity : NSObject
+ (NSString *)getUDID;
+ (void)saveLocal:(NSString *)val forKey:(NSString *)key;
+ (NSString *)loadLocal:(NSString *)key;
+ (void)clearLocal;
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
+ (void)clearLocal {
    SecItemDelete((__bridge CFDictionaryRef)@{(__bridge id)kSecClass:(__bridge id)kSecClassGenericPassword, (__bridge id)kSecAttrAccount:@"RDW_EXP"});
    SecItemDelete((__bridge CFDictionaryRef)@{(__bridge id)kSecClass:(__bridge id)kSecClassGenericPassword, (__bridge id)kSecAttrAccount:@"RDW_CODE"});
}
@end

// --- واجهة تسجيل الدخول والتجديد ---
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

    UIView *cont = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-320)/2, (self.view.frame.size.height-520)/2, 320, 520)];
    cont.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.07 alpha:0.95];
    cont.layer.cornerRadius = 35; cont.layer.borderWidth = 1.5; 
    cont.layer.borderColor = [RDW_GOLD colorWithAlphaComponent:0.4].CGColor;
    [self.view addSubview:cont];

    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(110, 35, 100, 100)];
    logo.layer.cornerRadius = 50; logo.clipsToBounds = YES;
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://i.ibb.co/7xZ41GWF/IMG-3601.jpg"] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        if (d) dispatch_async(dispatch_get_main_queue(), ^{ logo.image = [UIImage imageWithData:d]; });
    }] resume];
    [cont addSubview:logo];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 145, 320, 35)];
    title.text = @"Rimawi Digital World"; title.textColor = [UIColor whiteColor];
    title.font = [UIFont boldSystemFontOfSize:22]; title.textAlignment = NSTextAlignmentCenter; [cont addSubview:title];

    self.statusL = [[UILabel alloc] initWithFrame:CGRectMake(25, 185, 270, 50)];
    self.statusL.text = @"أدخل كود التفعيل للاستمرار\nأو لتمديد اشتراكك الحالي"; self.statusL.numberOfLines = 2;
    self.statusL.textColor = [UIColor lightGrayColor]; self.statusL.font = [UIFont systemFontOfSize:13];
    self.statusL.textAlignment = NSTextAlignmentCenter; [cont addSubview:self.statusL];

    self.codeField = [[UITextField alloc] initWithFrame:CGRectMake(40, 250, 240, 50)];
    self.codeField.placeholder = @"RDW-XXXX-XXXX"; self.codeField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.08];
    self.codeField.textColor = [UIColor whiteColor]; self.codeField.textAlignment = NSTextAlignmentCenter;
    self.codeField.layer.cornerRadius = 15; [cont addSubview:self.codeField];

    UIButton *actBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    actBtn.frame = CGRectMake(40, 320, 240, 55); [actBtn setTitle:@"تفعيل واستمرار" forState:UIControlStateNormal];
    [actBtn setBackgroundColor:RDW_GOLD]; [actBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; 
    actBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18]; actBtn.layer.cornerRadius = 18;
    [actBtn addTarget:self action:@selector(validateOnline) forControlEvents:UIControlEventTouchUpInside];
    [cont addSubview:actBtn];

    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    buyBtn.frame = CGRectMake(40, 390, 240, 50); [buyBtn setTitle:@"شراء كود تفعيل" forState:UIControlStateNormal];
    [buyBtn setBackgroundColor:RDW_GREEN]; [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; 
    buyBtn.layer.cornerRadius = 15; [buyBtn addTarget:self action:@selector(goWA) forControlEvents:UIControlEventTouchUpInside];
    [cont addSubview:buyBtn];

    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    self.spinner.color = [UIColor whiteColor]; self.spinner.center = actBtn.center; [cont addSubview:self.spinner];
}

- (void)validateOnline {
    [self.spinner startAnimating];
    NSString *input = self.codeField.text;
    NSString *myUDID = [RDWSecurity getUDID];
    NSString *apiPath = [NSString stringWithFormat:@"%@/%@.json", RDW_DB_URL, input];

    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:apiPath] completionHandler:^(NSData *data, NSURLResponse *res, NSError *err) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
            if (err || !data) { self.statusL.text = @"خطأ في الشبكة!"; return; }
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            // الحالة 1: الكود غلط أو محذوف
            if (!json || [json isEqual:[NSNull null]]) {
                self.statusL.text = @"الكود خاطئ أو غير موجود!";
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RDW_INSTA] options:@{} completionHandler:nil];
                });
                return;
            }

            // الحالة 2: الكود مكرر
            NSString *usedBy = json[@"usedBy"];
            if (![usedBy isEqualToString:@""] && ![usedBy isEqualToString:myUDID]) {
                self.statusL.text = @"الكود مستخدم على جهاز آخر!"; return;
            }

            // الحالة 3: تفعيل ناجح أو تمديد
            [self finalizeActivation:input udid:myUDID serverExp:[json[@"expiry"] doubleValue]];
        });
    }] resume];
}

- (void)finalizeActivation:(NSString *)code udid:(NSString *)udid serverExp:(double)sExp {
    // التمديد الذكي: إذا الكود لسه شغال بنزيد فوقه، وإذا مخلص بنبدأ من هسا
    double now = [[NSDate date] timeIntervalSince1970];
    double currentLocalExp = [[RDWSecurity loadLocal:@"RDW_EXP"] doubleValue];
    double baseTime = (currentLocalExp > now) ? currentLocalExp : now;
    double newExp = baseTime + (30 * 86400); // إضافة 30 يوم

    NSDictionary *patch = @{@"usedBy": udid, @"expiry": @(newExp)};
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json", RDW_DB_URL, code]]];
    [req setHTTPMethod:@"PATCH"]; [req setHTTPBody:[NSJSONSerialization dataWithJSONObject:patch options:0 error:nil]];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        if (!e) dispatch_async(dispatch_get_main_queue(), ^{
            [RDWSecurity saveLocal:code forKey:@"RDW_CODE"];
            [RDWSecurity saveLocal:[NSString stringWithFormat:@"%f", newExp] forKey:@"RDW_EXP"];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }] resume];
}

- (void)goWA { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RDW_WA] options:@{} completionHandler:nil]; }
- (BOOL)modalInPresentation { return YES; }
@end

// --- واجهة المحفظة ---
@interface RDWWalletVC : UIView
@end
@implementation RDWWalletVC
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.07 green:0.07 blue:0.09 alpha:0.98];
        self.layer.cornerRadius = 25; self.layer.borderWidth = 1.5; self.layer.borderColor = RDW_GOLD.CGColor;

        UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, frame.size.width, 30)];
        t.text = @"محفظة RDW"; t.textColor = [UIColor whiteColor];
        t.font = [UIFont boldSystemFontOfSize:18]; t.textAlignment = NSTextAlignmentCenter; [self addSubview:t];

        UILabel *d = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, frame.size.width, 30)];
        double exp = [[RDWSecurity loadLocal:@"RDW_EXP"] doubleValue];
        int days = (int)ceil((exp - [[NSDate date] timeIntervalSince1970]) / 86400);
        d.text = [NSString stringWithFormat:@"متبقي: %d يوم", (days > 0 ? days : 0)];
        d.textColor = RDW_GOLD; d.textAlignment = NSTextAlignmentCenter; [self addSubview:d];

        UIButton *ren = [UIButton buttonWithType:UIButtonTypeSystem];
        ren.frame = CGRectMake(40, 95, 200, 45); [ren setTitle:@"تجديد الاشتراك" forState:UIControlStateNormal];
        [ren setBackgroundColor:RDW_GREEN]; [ren setTitleColor:[UIColor whiteColor] forState:0];
        ren.layer.cornerRadius = 12; [ren addTarget:self action:@selector(openRenew) forControlEvents:64];
        [self addSubview:ren];

        UIButton *c = [UIButton buttonWithType:UIButtonTypeSystem];
        c.frame = CGRectMake(40, 150, 200, 30); [c setTitle:@"إغلاق" forState:0];
        [c setTitleColor:[UIColor lightGrayColor] forState:0]; [c addTarget:self action:@selector(close) forControlEvents:64];
        [self addSubview:c];
    }
    return self;
}
- (void)openRenew { [self close]; [(UIWindow *)[UIApplication sharedSession].keyWindow rdw_lock_screen]; }
- (void)close { [UIView animateWithDuration:0.3 animations:^{ self.alpha = 0; } completion:^(BOOL f){ [self removeFromSuperview]; }]; }
@end

// --- الهوك الرئيسي (الإصلاح الجذري) ---
%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        // فحص أولي وتثبيت حساس اللمس
        [self rdw_security_check];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rdw_show_panel)];
        tap.numberOfTouchesRequired = 3;
        [self addGestureRecognizer:tap];
        
        // فحص دوري كل دقيقة للتأكد من وجود الكود في السيرفر
        [NSTimer scheduledTimerWithTimeInterval:60 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self rdw_security_check];
        }];
    });
}

%new
- (void)rdw_security_check {
    NSString *code = [RDWSecurity loadLocal:@"RDW_CODE"];
    NSString *expStr = [RDWSecurity loadLocal:@"RDW_EXP"];
    
    if (!code || !expStr || [expStr doubleValue] < [[NSDate date] timeIntervalSince1970]) {
        [self rdw_lock_screen]; return;
    }

    // التأكد من أن الكود لسه موجود في السيرفر ولم يُحذف
    NSString *path = [NSString stringWithFormat:@"%@/%@.json", RDW_DB_URL, code];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:path] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        if (!e && d) {
            NSDictionary *j = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (!j || [j isEqual:[NSNull null]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [RDWSecurity clearLocal]; // مسح التفعيل محلياً
                    [self rdw_lock_screen];   // قفل الشاشة
                });
            }
        }
    }] resume];
}

%new
- (void)rdw_lock_screen {
    if (![self.rootViewController.presentedViewController isKindOfClass:[RDWLoginVC class]]) {
        RDWLoginVC *vc = [[RDWLoginVC alloc] init];
        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self.rootViewController presentViewController:vc animated:YES completion:nil];
    }
}

%new
- (void)rdw_show_panel {
    if (![RDWSecurity loadLocal:@"RDW_CODE"]) return;
    if ([self viewWithTag:999]) return;
    RDWWalletVC *panel = [[RDWWalletVC alloc] initWithFrame:CGRectMake((self.frame.size.width-280)/2, 120, 280, 200)];
    panel.tag = 999; panel.alpha = 0; [self addSubview:panel];
    [UIView animateWithDuration:0.3 animations:^{ panel.alpha = 1; }];
}
%end
