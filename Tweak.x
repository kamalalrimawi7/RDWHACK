#import <UIKit/UIKit.h>
#import <Security/Security.h>

// --- إعدادات RDW الثابتة ---
static NSString *const RDW_DB_URL = @"https://rdw-server-default-rtdb.firebaseio.com/codes";
static NSString *const RDW_INSTA  = @"https://www.instagram.com/rimawi.dw";
static NSString *const RDW_WA     = @"https://wa.me/972567171874?text=طلب_تفعيل_متجر_RDW";

#define RDW_GOLD [UIColor colorWithRed:0.72 green:0.56 blue:0.17 alpha:1.0]
#define RDW_GREEN [UIColor colorWithRed:0.15 green:0.68 blue:0.38 alpha:1.0]

// حل مشكلة الـ Build: تعريف الدوال مسبقاً للمترجم
@interface UIWindow (RDW_Private)
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

// --- واجهة تسجيل الدخول ---
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
    self.statusL.text = @"أدخل الكود لتفعيل متجر RDW\nأو لتمديد اشتراكك الحالي"; self.statusL.numberOfLines = 2;
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

    // رجعنا زر الواتساب يا وحش
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    buyBtn.frame = CGRectMake(40, 390, 240, 50); [buyBtn setTitle:@"شراء كود جديد (WhatsApp)" forState:UIControlStateNormal];
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
            if (!json || [json isEqual:[NSNull null]]) {
                self.statusL.text = @"الكود خاطئ! سيتم توجيهك للمتجر..";
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RDW_INSTA] options:@{} completionHandler:nil];
                });
                return;
            }
            [RDWSecurity saveLocal:input forKey:@"RDW_CODE"];
            [RDWSecurity saveLocal:[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970] + 2592000] forKey:@"RDW_EXP"];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }] resume];
}

- (void)goWA { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RDW_WA] options:@{} completionHandler:nil]; }
- (BOOL)modalInPresentation { return YES; }
@end

// --- واجهة المحفظة (التحكم) ---
@interface RDWWalletVC : UIView
@end
@implementation RDWWalletVC
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.07 green:0.07 blue:0.09 alpha:0.98];
        self.layer.cornerRadius = 25; self.layer.borderWidth = 1.5; self.layer.borderColor = RDW_GOLD.CGColor;

        UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, frame.size.width, 30)];
        t.text = @"إدارة اشتراك RDW"; t.textColor = [UIColor whiteColor];
        t.font = [UIFont boldSystemFontOfSize:18]; t.textAlignment = NSTextAlignmentCenter; [self addSubview:t];

        UIButton *ren = [UIButton buttonWithType:UIButtonTypeSystem];
        ren.frame = CGRectMake(40, 70, 200, 45); [ren setTitle:@"تجديد / تغيير الكود" forState:UIControlStateNormal];
        [ren setBackgroundColor:RDW_GOLD]; [ren setTitleColor:[UIColor whiteColor] forState:0];
        ren.layer.cornerRadius = 12; [ren addTarget:self action:@selector(openRenew) forControlEvents:64];
        [self addSubview:ren];

        UIButton *c = [UIButton buttonWithType:UIButtonTypeSystem];
        c.frame = CGRectMake(40, 130, 200, 30); [c setTitle:@"إغلاق النافذة" forState:0];
        [c setTitleColor:[UIColor lightGrayColor] forState:0]; [c addTarget:self action:@selector(close) forControlEvents:64];
        [self addSubview:c];
    }
    return self;
}
- (void)openRenew {
    [self removeFromSuperview];
    UIWindow *win = (UIWindow *)[UIApplication sharedSession].keyWindow;
    if ([win respondsToSelector:@selector(rdw_lock_screen)]) { [win rdw_lock_screen]; }
}
- (void)close { [self removeFromSuperview]; }
@end

// --- الهوك الرئيسي وإدارة الأمان ---
%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        [self rdw_security_check];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rdw_show_panel)];
        tap.numberOfTouchesRequired = 3;
        [self addGestureRecognizer:tap];

        // الفحص الدوري (كل 30 ثانية) للتأكد من وجود الجهاز في Firebase
        [NSTimer scheduledTimerWithTimeInterval:30 repeats:YES block:^(NSTimer *timer) {
            [self rdw_security_check];
        }];
    });
}

%new
- (void)rdw_security_check {
    NSString *code = [RDWSecurity loadLocal:@"RDW_CODE"];
    if (!code) { [self rdw_lock_screen]; return; }

    NSString *path = [NSString stringWithFormat:@"%@/%@.json", RDW_DB_URL, code];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:path] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        if (!e && d) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            // إذا انحذف من السيرفر، اقفل فوراً
            if (!json || [json isEqual:[NSNull null]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [RDWSecurity clearLocal];
                    [self rdw_lock_screen];
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
    if ([self viewWithTag:888]) return;
    RDWWalletVC *panel = [[RDWWalletVC alloc] initWithFrame:CGRectMake((self.frame.size.width-280)/2, 150, 280, 180)];
    panel.tag = 888; [self addSubview:panel];
}
%end
