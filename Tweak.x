#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import <AudioToolbox/AudioToolbox.h>

// --- إعدادات RDW الثابتة ---
static NSString *const RDW_DB_URL = @"https://rdw-server-default-rtdb.firebaseio.com/codes";
static NSString *const RDW_INSTA  = @"https://www.instagram.com/rimawi.dw";
static NSString *const RDW_WA     = @"https://wa.me/972567171874?text=+أريد+شراء+كود+تفعيل+RDW+لو+سمحت";

#define RDW_GOLD [UIColor colorWithRed:0.72 green:0.56 blue:0.17 alpha:1.0]
#define RDW_GREEN [UIColor colorWithRed:0.15 green:0.68 blue:0.38 alpha:1.0]

// --- حل أخطاء GitHub Compiler ---
@interface UIWindow (RDW_Final)
- (void)rdw_security_check;
- (void)rdw_lock_screen;
- (void)rdw_show_panel;
@end

@interface RDWSecurity : NSObject
+ (NSString *)getUDID;
+ (void)saveLocal:(NSString *)val forKey:(NSString *)key;
+ (NSString *)loadLocal:(NSString *)key;
+ (void)clearLocal;
+ (void)triggerErrorShake;
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
+ (void)triggerErrorShake {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    UINotificationFeedbackGenerator *gen = [[UINotificationFeedbackGenerator alloc] init];
    [gen notificationOccurred:UINotificationFeedbackTypeError];
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

    UIView *cont = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-320)/2, (self.view.frame.size.height-540)/2, 320, 540)];
    cont.backgroundColor = [UIColor colorWithRed:0.03 green:0.03 blue:0.05 alpha:0.96];
    cont.layer.cornerRadius = 40; cont.layer.borderWidth = 1.2; cont.layer.borderColor = RDW_GOLD.CGColor;
    [self.view addSubview:cont];

    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(110, 30, 100, 100)];
    logo.layer.cornerRadius = 50; logo.clipsToBounds = YES; logo.layer.borderWidth = 2; logo.layer.borderColor = RDW_GOLD.CGColor;
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://i.ibb.co/7xZ41GWF/IMG-3601.jpg"] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        if (d) dispatch_async(dispatch_get_main_queue(), ^{ logo.image = [UIImage imageWithData:d]; });
    }] resume];
    [cont addSubview:logo];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 140, 320, 35)];
    title.text = @"Rimawi Digital World"; title.textColor = [UIColor whiteColor];
    title.font = [UIFont boldSystemFontOfSize:22]; title.textAlignment = NSTextAlignmentCenter; [cont addSubview:title];

    self.statusL = [[UILabel alloc] initWithFrame:CGRectMake(20, 180, 280, 50)];
    self.statusL.text = @"نظام الحماية والتحقق من التراخيص\nأدخل كود التفعيل للاستمرار"; self.statusL.numberOfLines = 2;
    self.statusL.textColor = [UIColor lightGrayColor]; self.statusL.font = [UIFont systemFontOfSize:13];
    self.statusL.textAlignment = NSTextAlignmentCenter; [cont addSubview:self.statusL];

    self.codeField = [[UITextField alloc] initWithFrame:CGRectMake(40, 250, 240, 55)];
    self.codeField.placeholder = @"RDW-XXXX-XXXX"; self.codeField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.07];
    self.codeField.textColor = RDW_GOLD; self.codeField.textAlignment = NSTextAlignmentCenter;
    self.codeField.layer.cornerRadius = 18; [cont addSubview:self.codeField];

    UIButton *actBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    actBtn.frame = CGRectMake(40, 325, 240, 55); [actBtn setTitle:@"تفعيل واستمرار" forState:0];
    [actBtn setBackgroundColor:RDW_GOLD]; [actBtn setTitleColor:[UIColor whiteColor] forState:0]; 
    actBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18]; actBtn.layer.cornerRadius = 18;
    [actBtn addTarget:self action:@selector(validateOnline) forControlEvents:64];
    [cont addSubview:actBtn];

    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    buyBtn.frame = CGRectMake(40, 395, 240, 50); [buyBtn setTitle:@"شراء كود تفعيل" forState:0];
    [buyBtn setBackgroundColor:RDW_GREEN]; [buyBtn setTitleColor:[UIColor whiteColor] forState:0]; 
    buyBtn.layer.cornerRadius = 15; [buyBtn addTarget:self action:@selector(goWA) forControlEvents:64];
    [cont addSubview:buyBtn];

    UIButton *igBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    igBtn.frame = CGRectMake(40, 455, 240, 40); [igBtn setTitle:@"متابعتنا على إنستجرام" forState:0];
    [igBtn setTitleColor:RDW_GOLD forState:0]; [igBtn addTarget:self action:@selector(goIG) forControlEvents:64];
    [cont addSubview:igBtn];

    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    self.spinner.color = [UIColor whiteColor]; self.spinner.center = actBtn.center; [cont addSubview:self.spinner];
}

- (void)validateOnline {
    [self.spinner startAnimating];
    NSString *input = self.codeField.text;
    NSString *apiPath = [NSString stringWithFormat:@"%@/%@.json", RDW_DB_URL, input];

    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:apiPath] completionHandler:^(NSData *data, NSURLResponse *res, NSError *err) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
            if (!data) { self.statusL.text = @"تأكد من اتصالك بالإنترنت!"; [RDWSecurity triggerErrorShake]; return; }
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (!json || [json isEqual:[NSNull null]]) {
                self.statusL.text = @"كود خاطئ! سيتم تحويلك للمتجر..";
                [RDWSecurity triggerErrorShake];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{ [self goIG]; });
                return;
            }

            // تفعيل ناجح مع اهتزاز نجاح Haptic
            UIImpactFeedbackGenerator *successGen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
            [successGen impactOccurred];
            
            [RDWSecurity saveLocal:input forKey:@"RDW_CODE"];
            [RDWSecurity saveLocal:[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970] + 2592000] forKey:@"RDW_EXP"];
            
            UIAlertController *suc = [UIAlertController alertControllerWithTitle:@"✅ تم التفعيل" message:@"أهلاً بك في عالم Rimawi Digital World" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:suc animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [suc dismissViewControllerAnimated:YES completion:^{ [self dismissViewControllerAnimated:YES completion:nil]; }];
                });
            }];
        });
    }] resume];
}
- (void)goWA { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RDW_WA] options:@{} completionHandler:nil]; }
- (void)goIG { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RDW_INSTA] options:@{} completionHandler:nil]; }
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
        t.text = @"RDW Control Center"; t.textColor = [UIColor whiteColor];
        t.font = [UIFont boldSystemFontOfSize:18]; t.textAlignment = NSTextAlignmentCenter; [self addSubview:t];

        UIButton *ren = [UIButton buttonWithType:UIButtonTypeSystem];
        ren.frame = CGRectMake(40, 70, 200, 45); [ren setTitle:@"تجديد / تمديد الاشتراك" forState:0];
        [ren setBackgroundColor:RDW_GOLD]; [ren setTitleColor:[UIColor whiteColor] forState:0];
        ren.layer.cornerRadius = 12; [ren addTarget:self action:@selector(openRenew) forControlEvents:64];
        [self addSubview:ren];

        UIButton *c = [UIButton buttonWithType:UIButtonTypeSystem];
        c.frame = CGRectMake(40, 130, 200, 30); [c setTitle:@"إغلاق" forState:0];
        [c setTitleColor:[UIColor lightGrayColor] forState:0]; [c addTarget:self action:@selector(close) forControlEvents:64];
        [self addSubview:c];
    }
    return self;
}
- (void)openRenew {
    [self removeFromSuperview];
    UIWindow *keyWin = nil;
    for (UIWindow *win in [UIApplication sharedApplication].windows) { if (win.isKeyWindow) { keyWin = win; break; } }
    if ([keyWin respondsToSelector:@selector(rdw_lock_screen)]) { [keyWin rdw_lock_screen]; }
}
- (void)close { [UIView animateWithDuration:0.3 animations:^{ self.alpha = 0; } completion:^(BOOL f){ [self removeFromSuperview]; }]; }
@end

// --- الهوك الرئيسي وإدارة الأمان المستمر ---
%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        [self rdw_security_check];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rdw_show_panel)];
        tap.numberOfTouchesRequired = 3; [self addGestureRecognizer:tap];

        // الفحص الدوري: لو حذفت الكود من السيرفر، يطرد المستخدم فوراً
        [NSTimer scheduledTimerWithTimeInterval:30 repeats:YES block:^(NSTimer *timer) { [self rdw_security_check]; }];
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
            if (!json || [json isEqual:[NSNull null]]) {
                dispatch_async(dispatch_get_main_queue(), ^{ [RDWSecurity clearLocal]; [self rdw_lock_screen]; });
            }
        }
    }] resume];
}

%new
- (void)rdw_lock_screen {
    UIViewController *root = self.rootViewController;
    while (root.presentedViewController) root = root.presentedViewController;
    if (![root isKindOfClass:[RDWLoginVC class]]) {
        RDWLoginVC *vc = [[RDWLoginVC alloc] init];
        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [root presentViewController:vc animated:YES completion:nil];
    }
}

%new
- (void)rdw_show_panel {
    if ([self viewWithTag:777]) return;
    RDWWalletVC *panel = [[RDWWalletVC alloc] initWithFrame:CGRectMake((self.frame.size.width-280)/2, 160, 280, 180)];
    panel.tag = 777; panel.alpha = 0; [self addSubview:panel];
    [UIView animateWithDuration:0.3 animations:^{ panel.alpha = 1; }];
}
%end
