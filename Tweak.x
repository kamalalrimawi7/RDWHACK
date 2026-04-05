#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import <AudioToolbox/AudioToolbox.h>

// --- إعدادات RDW ---
static NSString *const RDW_DB_URL = @"https://rdw-server-default-rtdb.firebaseio.com/codes";
static NSString *const RDW_INSTA  = @"https://www.instagram.com/rimawi.dw";
static NSString *const RDW_WA     = @"https://wa.me/972567171874?text=+أريد+شراء+كود+تفعيل+RDW+لو+سمحت";
#define RDW_GOLD [UIColor colorWithRed:0.72 green:0.56 blue:0.17 alpha:1.0]

@interface UIWindow (RDW_Final)
- (void)rdw_security_check;
- (void)rdw_lock_screen;
- (void)rdw_show_panel:(UILongPressGestureRecognizer *)gesture;
@end

@interface RDWSecurity : NSObject
+ (void)saveLocal:(NSString *)val forKey:(NSString *)key;
+ (NSString *)loadLocal:(NSString *)key;
+ (void)clearLocal;
+ (void)triggerErrorShake;
@end

@implementation RDWSecurity
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
@end

@implementation RDWLoginVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    UIView *cont = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-300)/2, (self.view.frame.size.height-500)/2, 300, 500)];
    cont.backgroundColor = [UIColor colorWithWhite:0.05 alpha:1.0];
    cont.layer.cornerRadius = 30; cont.layer.borderWidth = 1.2; cont.layer.borderColor = RDW_GOLD.CGColor;
    [self.view addSubview:cont];

    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(100, 30, 100, 100)];
    logo.layer.cornerRadius = 50; logo.clipsToBounds = YES;
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://i.ibb.co/7xZ41GWF/IMG-3601.jpg"] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        if (d) dispatch_async(dispatch_get_main_queue(), ^{ logo.image = [UIImage imageWithData:d]; });
    }] resume];
    [cont addSubview:logo];

    self.codeField = [[UITextField alloc] initWithFrame:CGRectMake(30, 200, 240, 50)];
    self.codeField.placeholder = @"أدخل كود التفعيل"; self.codeField.backgroundColor = [UIColor whiteColor];
    self.codeField.textAlignment = NSTextAlignmentCenter; self.codeField.layer.cornerRadius = 12;
    [cont addSubview:self.codeField];

    UIButton *actBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    actBtn.frame = CGRectMake(30, 270, 240, 55); [actBtn setTitle:@"تفعيل واستمرار" forState:0];
    [actBtn setBackgroundColor:RDW_GOLD]; [actBtn setTitleColor:[UIColor whiteColor] forState:0];
    actBtn.layer.cornerRadius = 15; [actBtn addTarget:self action:@selector(validate) forControlEvents:64];
    [cont addSubview:actBtn];

    self.statusL = [[UILabel alloc] initWithFrame:CGRectMake(10, 340, 280, 40)];
    self.statusL.textColor = [UIColor whiteColor]; self.statusL.textAlignment = NSTextAlignmentCenter;
    self.statusL.font = [UIFont systemFontOfSize:12]; [cont addSubview:self.statusL];
}

- (void)validate {
    NSString *input = [self.codeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // منع الكود الفارغ نهائياً
    if (input.length < 3) {
        self.statusL.text = @"خطأ: الحقل فارغ أو الكود قصير جداً!";
        [RDWSecurity triggerErrorShake];
        return;
    }

    NSString *path = [NSString stringWithFormat:@"%@/%@.json", RDW_DB_URL, input];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:path] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!d) { self.statusL.text = @"مشكلة في السيرفر"; return; }
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            
            if (!json || [json isEqual:[NSNull null]]) {
                self.statusL.text = @"الكود غير صحيح!";
                [RDWSecurity triggerErrorShake];
                return;
            }

            [RDWSecurity saveLocal:input forKey:@"RDW_CODE"];
            
            // إضافة Pop-up نجاح التفعيل
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"✅ تم التفعيل" message:@"استمتع بميزات متجر RDW" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [alert dismissViewControllerAnimated:YES completion:^{ [self dismissViewControllerAnimated:YES completion:nil]; }];
                });
            }];
        });
    }] resume];
}
@end

// --- واجهة بانل التحكم ---
@interface RDWWalletVC : UIView
@end
@implementation RDWWalletVC
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.08 alpha:0.98];
        self.layer.cornerRadius = 20; self.layer.borderColor = RDW_GOLD.CGColor; self.layer.borderWidth = 1.5;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(20, 20, 200, 45); [btn setTitle:@"تجديد / تغيير الكود" forState:0];
        [btn setBackgroundColor:RDW_GOLD]; [btn setTitleColor:[UIColor whiteColor] forState:0];
        btn.layer.cornerRadius = 10; [btn addTarget:self action:@selector(reLock) forControlEvents:64];
        [self addSubview:btn];
    }
    return self;
}
- (void)reLock {
    [self removeFromSuperview];
    UIWindow *win = (UIWindow *)[[UIApplication sharedApplication] keyWindow];
    if ([win respondsToSelector:@selector(rdw_lock_screen)]) { [win rdw_lock_screen]; }
}
@end

// --- الهوك الرئيسي ---
%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        [self rdw_security_check];
        
        // إيماءة الضغط المطول بـ 3 أصابع لمدة ثانيتين ونصف
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(rdw_show_panel:)];
        longPress.numberOfTouchesRequired = 3;
        longPress.minimumPressDuration = 2.5; // المدة المطلوبة لظهور البانل
        [self addGestureRecognizer:longPress];

        [NSTimer scheduledTimerWithTimeInterval:30 repeats:YES block:^(NSTimer *timer) { [self rdw_security_check]; }];
    });
}

%new
- (void)rdw_security_check {
    NSString *code = [RDWSecurity loadLocal:@"RDW_CODE"];
    if (!code) { [self rdw_lock_screen]; return; }

    NSString *path = [NSString stringWithFormat:@"%@/%@.json", RDW_DB_URL, code];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:path] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        if (d) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (!json || [json isEqual:[NSNull null]]) {
                dispatch_async(dispatch_get_main_queue(), ^{ [RDWSecurity clearLocal]; [self rdw_lock_screen]; });
            }
        }
    }] resume];
}

%new
- (void)rdw_lock_screen {
    UIViewController *top = self.rootViewController;
    while (top.presentedViewController) top = top.presentedViewController;
    if (![top isKindOfClass:[RDWLoginVC class]]) {
        RDWLoginVC *vc = [[RDWLoginVC alloc] init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [top presentViewController:vc animated:YES completion:nil];
    }
}

%new
- (void)rdw_show_panel:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if ([self viewWithTag:999]) return;
        RDWWalletVC *p = [[RDWWalletVC alloc] initWithFrame:CGRectMake((self.frame.size.width-240)/2, 120, 240, 85)];
        p.tag = 999; [self addSubview:p];
        
        // اهتزاز خفيف عند ظهور البانل
        UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        [gen impactOccurred];
    }
}
%end
