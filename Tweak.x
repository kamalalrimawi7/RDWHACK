#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import <AudioToolbox/AudioToolbox.h>

// --- إعدادات RDW الثابتة ---
static NSString *const RDW_DB_URL = @"https://rdw-server-default-rtdb.firebaseio.com/codes";
static NSString *const RDW_INSTA  = @"https://www.instagram.com/rimawi.dw";
static NSString *const RDW_WA     = @"https://wa.me/972567171874?text=+أريد+شراء+كود+تفعيل+RDW+لو+سمحت";
#define RDW_GOLD [UIColor colorWithRed:0.72 green:0.56 blue:0.17 alpha:1.0]
#define RDW_GREEN [UIColor colorWithRed:0.15 green:0.68 blue:0.38 alpha:1.0]

@interface RDWSecurity : NSObject
+ (void)saveLocal:(NSString *)val forKey:(NSString *)key;
+ (NSString *)loadLocal:(NSString *)key;
+ (void)clearLocal;
+ (void)triggerErrorShake;
@end

@interface UIWindow (RDW_Fix)
- (void)rdw_lock_now;
- (void)rdw_live_server_check;
- (void)rdw_handle_lp:(UILongPressGestureRecognizer *)g;
@end

@interface RDWLoginVC : UIViewController
@property (nonatomic, retain) UITextField *codeField;
@property (nonatomic, retain) UILabel *statusL;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
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

@implementation RDWLoginVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    UIView *cont = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-320)/2, (self.view.frame.size.height-560)/2, 320, 560)];
    cont.backgroundColor = [UIColor colorWithWhite:0.05 alpha:0.98];
    cont.layer.cornerRadius = 40; cont.layer.borderWidth = 1.2; cont.layer.borderColor = RDW_GOLD.CGColor;
    [self.view addSubview:cont];

    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(110, 30, 100, 100)];
    logo.layer.cornerRadius = 50; logo.clipsToBounds = YES;
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://i.ibb.co/7xZ41GWF/IMG-3601.jpg"] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        if (d) dispatch_async(dispatch_get_main_queue(), ^{ logo.image = [UIImage imageWithData:d]; });
    }] resume];
    [cont addSubview:logo];

    self.statusL = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, 280, 50)];
    self.statusL.textColor = [UIColor whiteColor]; self.statusL.textAlignment = NSTextAlignmentCenter;
    self.statusL.numberOfLines = 2; self.statusL.text = @"جاري التحقق من الترخيص..."; [cont addSubview:self.statusL];

    self.codeField = [[UITextField alloc] initWithFrame:CGRectMake(40, 220, 240, 55)];
    self.codeField.placeholder = @"أدخل كود RDW"; self.codeField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    self.codeField.textColor = RDW_GOLD; self.codeField.textAlignment = NSTextAlignmentCenter;
    self.codeField.layer.cornerRadius = 18; [cont addSubview:self.codeField];

    UIButton *actBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    actBtn.frame = CGRectMake(40, 295, 240, 55); [actBtn setTitle:@"تفعيل واستمرار" forState:0];
    [actBtn setBackgroundColor:RDW_GOLD]; [actBtn setTitleColor:[UIColor whiteColor] forState:0];
    actBtn.layer.cornerRadius = 18; [actBtn addTarget:self action:@selector(validateOnline) forControlEvents:64];
    [cont addSubview:actBtn];

    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    buyBtn.frame = CGRectMake(40, 365, 240, 50); [buyBtn setTitle:@"شراء كود تفعيل" forState:0];
    [buyBtn setBackgroundColor:RDW_GREEN]; [buyBtn setTitleColor:[UIColor whiteColor] forState:0]; 
    buyBtn.layer.cornerRadius = 15; [buyBtn addTarget:self action:@selector(goWA) forControlEvents:64];
    [cont addSubview:buyBtn];

    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    self.spinner.color = [UIColor whiteColor]; self.spinner.center = actBtn.center; [cont addSubview:self.spinner];
}

- (void)validateOnline {
    NSString *input = [self.codeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (input.length < 4) {
        self.statusL.text = @"الرجاء إدخال كود صالح!";
        [RDWSecurity triggerErrorShake]; return;
    }
    [self.spinner startAnimating];
    NSString *apiPath = [NSString stringWithFormat:@"%@/%@.json", RDW_DB_URL, input];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:apiPath] completionHandler:^(NSData *data, NSURLResponse *res, NSError *err) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
            if (data) {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if (json && ![json isEqual:[NSNull null]]) {
                    [RDWSecurity saveLocal:input forKey:@"RDW_CODE"];
                    UIAlertController *suc = [UIAlertController alertControllerWithTitle:@"✅ تم التفعيل" message:@"أهلاً بك في عالم RDW" preferredStyle:UIAlertControllerStyleAlert];
                    [self presentViewController:suc animated:YES completion:^{
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                            [suc dismissViewControllerAnimated:YES completion:^{ [self dismissViewControllerAnimated:YES completion:nil]; }];
                        });
                    }];
                    return;
                }
            }
            self.statusL.text = @"الكود غير موجود في السيرفر!";
            [RDWSecurity triggerErrorShake];
        });
    }] resume];
}
- (void)goWA { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RDW_WA] options:@{} completionHandler:nil]; }
- (void)goIG { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RDW_INSTA] options:@{} completionHandler:nil]; }
@end

%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        // فحص "حي" من قاعدة البيانات فور التشغيل
        [self rdw_live_server_check];

        UILongPressGestureRecognizer *lp = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(rdw_handle_lp:)];
        lp.numberOfTouchesRequired = 3; lp.minimumPressDuration = 2.5; 
        [self addGestureRecognizer:lp];

        [NSTimer scheduledTimerWithTimeInterval:30 repeats:YES block:^(NSTimer *timer) {
            [self rdw_live_server_check];
        }];
    });
}

%new
- (void)rdw_live_server_check {
    NSString *savedCode = [RDWSecurity loadLocal:@"RDW_CODE"];
    
    // إذا ما في كود مخزن أصلاً، اظهر شاشة القفل فوراً
    if (!savedCode) {
        dispatch_async(dispatch_get_main_queue(), ^{ [self rdw_lock_now]; });
        return;
    }

    // إذا فيه كود مخزن، افحصه فوراً مع قاعدة البيانات (Live Check)
    NSString *p = [NSString stringWithFormat:@"%@/%@.json", RDW_DB_URL, savedCode];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:p] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        if (d) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            // لو الكود انحذف من السيرفر (صار null)
            if (!json || [json isEqual:[NSNull null]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [RDWSecurity clearLocal];
                    [self rdw_lock_now];
                });
            }
        } else if (e) {
            // في حال عدم وجود إنترنت، لا تسمح بالدخول لضمان عدم التخطي
            dispatch_async(dispatch_get_main_queue(), ^{ [self rdw_lock_now]; });
        }
    }] resume];
}

%new
- (void)rdw_lock_now {
    UIViewController *top = self.rootViewController;
    while (top.presentedViewController) top = top.presentedViewController;
    if (![top isKindOfClass:[RDWLoginVC class]]) {
        RDWLoginVC *vc = [[RDWLoginVC alloc] init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [top presentViewController:vc animated:YES completion:nil];
    }
}

%new
- (void)rdw_handle_lp:(UILongPressGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateBegan) {
        // بانل التحكم بـ 3 أصابع
        UIView *old = [self viewWithTag:777];
        if (old) return;
        UIView *panel = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width-240)/2, 120, 240, 80)];
        panel.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.95];
        panel.layer.cornerRadius = 20; panel.layer.borderColor = RDW_GOLD.CGColor; panel.layer.borderWidth = 1.5;
        panel.tag = 777;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(20, 20, 200, 40); [btn setTitle:@"تغيير الكود" forState:0];
        [btn setBackgroundColor:RDW_GOLD]; [btn setTitleColor:[UIColor whiteColor] forState:0];
        btn.layer.cornerRadius = 10; [btn addTarget:self action:@selector(rdw_lock_now) forControlEvents:64];
        [panel addSubview:btn];
        [self addSubview:panel];
    }
}
%end
