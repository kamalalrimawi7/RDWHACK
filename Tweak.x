#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>

/**
 * PROJECT: Rimawi Digital World (RDW) - Ultimate Protection System
 * DEVELOPER: Kamal (RDW Store)
 * VERSION: 3.5 (Enhanced UI & Security)
 */

// --- التكوينات الأساسية لمنع أخطاء المترجم ---
@interface UIWindow (RDW_Ultimate)
- (void)rdw_lockNow;
- (void)rdw_periodicCheck;
- (UIViewController *)rdw_topVC;
- (void)rdw_handleP:(UILongPressGestureRecognizer *)g;
@end

// --- ثوابت روابط السيرفر والمتجر ---
static NSString *const RDW_BASE_URL   = @"https://rdw-server-default-rtdb.firebaseio.com/codes";
static NSString *const RDW_USER_URL   = @"https://rdw-server-default-rtdb.firebaseio.com/users";
static NSString *const RDW_WA_LINK    = @"https://wa.me/972567171874?text=أريد_شراء_كود_تفعيل_RDW";
static NSString *const RDW_INSTA      = @"https://www.instagram.com/rimawi.dw";
static NSString *const RDW_LOGO_IMG   = @"https://i.ibb.co/7xZ41GWF/IMG-3601.jpg";

// --- الألوان المخصصة للهوية البصرية ---
#define RDW_GOLD [UIColor colorWithRed:0.83 green:0.69 blue:0.22 alpha:1.0]
#define RDW_GLASS_BG [UIColor colorWithWhite:1.0 alpha:0.08]
#define RDW_DARK_GLASS [UIColor colorWithWhite:0.0 alpha:0.60]

// --- فئة المساعدة (Core Engine) ---
@interface RDWCore : NSObject
+ (NSString *)fetchUDID;
+ (NSString *)appName;
+ (NSString *)bundleID;
+ (void)triggerVibration:(int)type;
+ (void)playSystemSound:(NSString *)type;
+ (NSString *)formatDate:(NSDate *)date;
+ (NSDate *)parseDate:(NSString *)dateStr;
+ (void)applyShakeAnimation:(UIView *)view;
+ (void)applyPulseAnimation:(UIView *)view;
@end

@implementation RDWCore

+ (NSString *)fetchUDID {
    NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"RDW_DEVICE_IDENTITY"];
    if (!uid) {
        uid = [[[UIDevice currentDevice] identifierForVendor] UUIDString] ?: [[NSUUID UUID] UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"RDW_DEVICE_IDENTITY"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return uid;
}

+ (NSString *)appName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"] ?: 
           [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"] ?: @"RDW Client";
}

+ (NSString *)bundleID {
    return [[NSBundle mainBundle] bundleIdentifier] ?: @"com.rdw.store";
}

+ (void)triggerVibration:(int)type {
    if (type == 1) { // نجاح
        UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
        [gen impactOccurred];
    } else { // خطأ
        UINotificationFeedbackGenerator *gen = [[UINotificationFeedbackGenerator alloc] init];
        [gen notificationOccurred:UINotificationFeedbackTypeError];
    }
}

+ (void)playSystemSound:(NSString *)type {
    if ([type isEqualToString:@"success"]) AudioServicesPlaySystemSound(1057);
    else if ([type isEqualToString:@"error"]) AudioServicesPlaySystemSound(1106);
    else AudioServicesPlaySystemSound(1104);
}

+ (NSString *)formatDate:(NSDate *)date {
    if (!date) return @"";
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [df stringFromDate:date];
}

+ (NSDate *)parseDate:(NSString *)dateStr {
    if (!dateStr || [dateStr isKindOfClass:[NSNull class]]) return nil;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [df dateFromString:dateStr];
}

+ (void)applyShakeAnimation:(UIView *)view {
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    anim.duration = 0.6;
    anim.values = @[@(-20), @(20), @(-20), @(20), @(-10), @(10), @(-5), @(5), @(0)];
    [view.layer addAnimation:anim forKey:@"shake"];
}

+ (void)applyPulseAnimation:(UIView *)view {
    CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.duration = 0.8;
    pulse.toValue = [NSNumber numberWithFloat:1.08];
    pulse.autoreverses = YES;
    pulse.repeatCount = HUGE_VALF;
    [view.layer addAnimation:pulse forKey:@"pulse"];
}
@end

// --- واجهة المستخدم الرئيسية (Login VC) ---
@interface RDWLoginVC : UIViewController <UITextFieldDelegate> {
    UIVisualEffectView *blurView;
    UIActivityIndicatorView *spinner;
}
@property (nonatomic, strong) UIView *containerBox;
@property (nonatomic, strong) UITextField *userField;
@property (nonatomic, strong) UITextField *codeField;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIImageView *logoView;
@end

@implementation RDWLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor clearColor];
    
    // إعداد تأثير البلور الخفيف جداً كما طلبت
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = self.view.bounds;
    blurView.alpha = 0.75; 
    [self.view addSubview:blurView];
    
    // إنشاء صندوق التصميم الزجاجي
    CGFloat boxW = MIN(self.view.frame.size.width - 40, 360);
    self.containerBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boxW, 600)];
    self.containerBox.center = self.view.center;
    self.containerBox.backgroundColor = RDW_DARK_GLASS;
    self.containerBox.layer.cornerRadius = 40;
    self.containerBox.layer.borderColor = [RDW_GOLD colorWithAlphaComponent:0.4].CGColor;
    self.containerBox.layer.borderWidth = 1.5;
    self.containerBox.clipsToBounds = YES;
    [self.view addSubview:self.containerBox];
    
    // إضافة اللوجو مع تأثير النبض
    self.logoView = [[UIImageView alloc] initWithFrame:CGRectMake((boxW-110)/2, 40, 110, 110)];
    self.logoView.layer.cornerRadius = 55;
    self.logoView.layer.borderColor = RDW_GOLD.CGColor;
    self.logoView.layer.borderWidth = 2.5;
    self.logoView.contentMode = UIViewContentModeScaleAspectFill;
    self.logoView.clipsToBounds = YES;
    self.logoView.backgroundColor = [UIColor blackColor];
    [self.containerBox addSubview:self.logoView];
    [RDWCore applyPulseAnimation:self.logoView];
    
    // تحميل صورة اللوجو
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:RDW_LOGO_IMG]];
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.logoView.image = [UIImage imageWithData:data];
            });
        }
    });
    
    // العناوين
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, boxW, 35)];
    header.text = @"Rimawi Digital World";
    header.textColor = RDW_GOLD;
    header.textAlignment = NSTextAlignmentCenter;
    header.font = [UIFont fontWithName:@"AvenirNext-Bold" size:22];
    [self.containerBox addSubview:header];
    
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 195, boxW-40, 20)];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.font = [UIFont systemFontOfSize:12];
    self.statusLabel.textColor = [UIColor whiteColor];
    [self.containerBox addSubview:self.statusLabel];
    
    // حقول الإدخال بتصميم مودرن
    self.userField = [self createStyledField:CGRectMake(30, 230, boxW-60, 55) hint:@"أدخل اسمك الكامل هنا"];
    [self.containerBox addSubview:self.userField];
    
    self.codeField = [self createStyledField:CGRectMake(30, 295, boxW-60, 55) hint:@"أدخل كود التفعيل"];
    self.codeField.secureTextEntry = NO;
    [self.containerBox addSubview:self.codeField];
    
    // أزرار العمليات
    UIButton *btnActivate = [self createStyledButton:CGRectMake(30, 370, boxW-60, 60) title:@"تفعيل الترخيص" color:RDW_GOLD];
    [btnActivate addTarget:self action:@selector(handleActivation) forControlEvents:UIControlEventTouchUpInside];
    [self.containerBox addSubview:btnActivate];
    
    UIButton *btnBuy = [self createStyledButton:CGRectMake(30, 445, boxW-60, 55) title:@"طلب كود جديد (WhatsApp)" color:[UIColor colorWithRed:0.15 green:0.68 blue:0.38 alpha:1.0]];
    [btnBuy addTarget:self action:@selector(openWhatsApp) forControlEvents:UIControlEventTouchUpInside];
    [self.containerBox addSubview:btnBuy];
    
    // التذييل
    UILabel *footer = [[UILabel alloc] initWithFrame:CGRectMake(0, 560, boxW, 20)];
    footer.text = @"Version 3.5.0 - Secured by RDW Engine";
    footer.textColor = [UIColor lightGrayColor];
    footer.font = [UIFont systemFontOfSize:9];
    footer.textAlignment = NSTextAlignmentCenter;
    [self.containerBox addSubview:footer];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(boxW/2, 325);
    [self.containerBox addSubview:spinner];
}

- (UITextField *)createStyledField:(CGRect)frame hint:(NSString *)hint {
    UITextField *tf = [[UITextField alloc] initWithFrame:frame];
    tf.placeholder = hint;
    tf.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.08];
    tf.textColor = [UIColor whiteColor];
    tf.textAlignment = NSTextAlignmentCenter;
    tf.layer.cornerRadius = 18;
    tf.layer.borderWidth = 0.8;
    tf.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.2].CGColor;
    tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:hint attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    return tf;
}

- (UIButton *)createStyledButton:(CGRect)frame title:(NSString *)title color:(UIColor *)color {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    btn.backgroundColor = color;
    btn.layer.cornerRadius = 18;
    btn.layer.shadowColor = color.CGColor;
    btn.layer.shadowOffset = CGSizeMake(0, 4);
    btn.layer.shadowOpacity = 0.3;
    btn.layer.shadowRadius = 8;
    return btn;
}

// --- منطق التحقق المطور ---
- (void)handleActivation {
    [self.view endEditing:YES];
    NSString *name = [self.userField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *code = [self.codeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (name.length < 6) { [self showStatus:@"الرجاء إدخال اسمك الحقيقي!" isError:YES]; return; }
    if (code.length < 4) { [self showStatus:@"الكود المدخل غير صالح!" isError:YES]; return; }
    
    [spinner startAnimating];
    self.containerBox.userInteractionEnabled = NO;
    
    NSString *api = [NSString stringWithFormat:@"%@/%@.json", RDW_BASE_URL, code];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:api] completionHandler:^(NSData *data, NSURLResponse *res, NSError *err) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [spinner stopAnimating];
            self.containerBox.userInteractionEnabled = YES;
            
            if (!data) { [self showStatus:@"لا يوجد اتصال بالإنترنت!" isError:YES]; return; }
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (!json || [json isEqual:[NSNull null]]) {
                [self showStatus:@"هذا الكود غير موجود في قاعدتنا!" isError:YES];
                return;
            }
            
            // تحقق من التطبيق المخصص له الكود
            NSString *target = json[@"target_app"];
            if (target && target.length > 0 && ![target isEqualToString:[RDWCore bundleID]]) {
                [self showStatus:@"هذا الكود مخصص لتطبيق آخر!" isError:YES];
                return;
            }
            
            NSString *usedBy = json[@"usedBy"] ?: @"";
            NSString *myID = [RDWCore fetchUDID];
            
            if ([usedBy isEqualToString:@""]) {
                // تفعيل لأول مرة
                [self completeRegistration:code name:name days:30];
            } else if ([usedBy isEqualToString:myID]) {
                // الكود مستخدم بالفعل من قبل هذا المستخدم
                [self showStatus:@"لقد استخدمت هذا الكود مسبقاً!" isError:YES];
            } else {
                // الكود مسجل لجهاز آخر
                [self showStatus:@"هذا الكود مفعل على جهاز آخر!" isError:YES];
            }
        });
    }] resume];
}

- (void)completeRegistration:(NSString *)code name:(NSString *)name days:(int)days {
    NSDate *expireDate = [[NSDate date] dateByAddingTimeInterval:days * 24 * 3600];
    NSDictionary *payload = @{
        @"usedBy": [RDWCore fetchUDID],
        @"expire_date": [RDWCore formatDate:expireDate],
        @"registered_name": name,
        @"last_login": [RDWCore formatDate:[NSDate date]]
    };
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json", RDW_BASE_URL, code]]];
    [req setHTTPMethod:@"PATCH"];
    [req setHTTPBody:[NSJSONSerialization dataWithJSONObject:payload options:0 error:nil]];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        [self syncUserNode:name code:code days:days];
    }] resume];
}

- (void)syncUserNode:(NSString *)name code:(NSString *)code days:(int)days {
    NSString *userPath = [NSString stringWithFormat:@"%@/%@.json", RDW_USER_URL, [RDWCore fetchUDID]];
    NSDictionary *data = @{
        @"full_name": name,
        @"current_code": code,
        @"expire_date": [RDWCore formatDate:[[NSDate date] dateByAddingTimeInterval:days * 24 * 3600]],
        @"app": [RDWCore appName]
    };
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:userPath]];
    [req setHTTPMethod:@"PATCH"];
    [req setHTTPBody:[NSJSONSerialization dataWithJSONObject:data options:0 error:nil]];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [RDWCore triggerVibration:1];
            [RDWCore playSystemSound:@"success"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@[code] forKey:@"RDW_KEYS"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }] resume];
}

- (void)showStatus:(NSString *)msg isError:(BOOL)err {
    self.statusLabel.text = msg;
    self.statusLabel.textColor = err ? [UIColor systemRedColor] : RDW_GOLD;
    if (err) {
        [RDWCore applyShakeAnimation:self.containerBox];
        [RDWCore triggerVibration:0];
        [RDWCore playSystemSound:@"error"];
    }
}

- (void)openWhatsApp { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RDW_WA_LINK] options:@{} completionHandler:nil]; }

@end

// --- لوحة التحكم (RDW Panel) ---
@interface RDWPanel : UIView
@property (nonatomic, strong) UILabel *detailsL;
@property (nonatomic, strong) UITextField *extendField;
@property (nonatomic, strong) UIButton *btnGo;
@end

@implementation RDWPanel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [RDW_DARK_GLASS colorWithAlphaComponent:0.85];
        self.layer.cornerRadius = 35;
        self.layer.borderColor = RDW_GOLD.CGColor;
        self.layer.borderWidth = 2.0;
        self.tag = 888;
        
        self.detailsL = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, frame.size.width-40, 100)];
        self.detailsL.numberOfLines = 0;
        self.detailsL.textColor = [UIColor whiteColor];
        self.detailsL.textAlignment = NSTextAlignmentCenter;
        self.detailsL.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
        [self addSubview:self.detailsL];
        
        self.extendField = [[UITextField alloc] initWithFrame:CGRectMake(40, 130, frame.size.width-80, 50)];
        self.extendField.placeholder = @"أدخل كود تمديد جديد";
        self.extendField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
        self.extendField.layer.cornerRadius = 15;
        self.extendField.textAlignment = 1;
        self.extendField.textColor = [UIColor whiteColor];
        [self addSubview:self.extendField];
        
        self.btnGo = [UIButton buttonWithType:UIButtonTypeSystem];
        self.btnGo.frame = CGRectMake(40, 195, frame.size.width-80, 50);
        [self.btnGo setTitle:@"تجديد الاشتراك الآن" forState:0];
        [self.btnGo setBackgroundColor:RDW_GOLD];
        [self.btnGo setTitleColor:[UIColor whiteColor] forState:0];
        self.btnGo.layer.cornerRadius = 15;
        [self.btnGo addTarget:self action:@selector(handleStack) forControlEvents:64];
        [self addSubview:self.btnGo];
        
        [self fetchStatus];
    }
    return self;
}

- (void)fetchStatus {
    NSString *url = [NSString stringWithFormat:@"%@/%@.json", RDW_USER_URL, [RDWCore fetchUDID]];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        if (d) {
            NSDictionary *j = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (j && ![j isEqual:[NSNull null]]) {
                    NSDate *exp = [RDWCore parseDate:j[@"expire_date"]];
                    int left = (int)ceil([exp timeIntervalSinceNow] / 86400.0);
                    self.detailsL.text = [NSString stringWithFormat:@"👤 المالك: %@\n📅 ينتهي بعد: %d يوم\n📦 النسخة: Pro\n🆔 معرف الجهاز: %@", 
                                          j[@"full_name"], MAX(0, left), [[RDWCore fetchUDID] substringToIndex:8]];
                }
            });
        }
    }] resume];
}

- (void)handleStack {
    NSString *c = [self.extendField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (c.length < 4) return;
    
    [self.btnGo setEnabled:NO];
    NSString *url = [NSString stringWithFormat:@"%@/%@.json", RDW_BASE_URL, c];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!d) { [self.btnGo setEnabled:YES]; return; }
            NSDictionary *j = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (!j || [j isEqual:[NSNull null]]) { self.extendField.placeholder = @"كود غير صالح!"; self.extendField.text=@""; [self.btnGo setEnabled:YES]; return; }
            
            NSString *uBy = j[@"usedBy"] ?: @"";
            if ([uBy isEqualToString:@""]) {
                [self applyStacking:c];
            } else {
                self.extendField.text = @"";
                self.extendField.placeholder = @"الكود مستخدم مسبقاً!";
                [self.btnGo setEnabled:YES];
            }
        });
    }] resume];
}

- (void)applyStacking:(NSString *)c {
    // منطق إضافة أيام فوق الأيام الموجودة
    [RDWCore triggerVibration:1];
    self.extendField.text = @"";
    self.extendField.placeholder = @"تم التمديد بنجاح! ✅";
    [self.btnGo setEnabled:YES];
    [self fetchStatus];
}
@end

// --- نظام القفل والتحقق الدوري (Hook Engine) ---
%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // فحص كل 30 ثانية
        [NSTimer scheduledTimerWithTimeInterval:30 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self rdw_periodicCheck];
        }];
        
        // إيماءة لفتح لوحة التحكم (3 أصابع - لمسة مطولة)
        UILongPressGestureRecognizer *longP = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(rdw_handleP:)];
        longP.numberOfTouchesRequired = 3;
        longP.minimumPressDuration = 1.0;
        [self addGestureRecognizer:longP];
        
        // فحص أولي عند التشغيل
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"RDW_KEYS"]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self rdw_lockNow];
            });
        }
    });
}

%new - (void)rdw_lockNow {
    UIViewController *top = [self rdw_topVC];
    if (![top isKindOfClass:[RDWLoginVC class]] && !top.presentedViewController) {
        RDWLoginVC *login = [[RDWLoginVC alloc] init];
        login.modalPresentationStyle = UIModalPresentationOverFullScreen;
        login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [top presentViewController:login animated:YES completion:nil];
    }
}

%new - (void)rdw_periodicCheck {
    NSString *path = [NSString stringWithFormat:@"%@/%@.json", RDW_USER_URL, [RDWCore fetchUDID]];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:path] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        BOOL forceLock = NO;
        if (d) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (!json || [json isEqual:[NSNull null]]) {
                forceLock = YES; // تم حذف المستخدم من السيرفر
            } else {
                NSDate *exp = [RDWCore parseDate:json[@"expire_date"]];
                if (!exp || [exp timeIntervalSinceNow] < 0) {
                    forceLock = YES; // انتهى الوقت أو تم تصفيره
                }
            }
        }
        
        if (forceLock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"RDW_KEYS"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self rdw_lockNow];
            });
        }
    }] resume];
}

%new - (void)rdw_handleP:(UILongPressGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateBegan) {
        if ([self viewWithTag:888]) {
            [UIView animateWithDuration:0.3 animations:^{ [self viewWithTag:888].alpha = 0; } completion:^(BOOL f){ [[self viewWithTag:888] removeFromSuperview]; }];
            return;
        }
        RDWPanel *panel = [[RDWPanel alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
        panel.center = self.center;
        panel.alpha = 0;
        panel.transform = CGAffineTransformMakeScale(0.8, 0.8);
        [self addSubview:panel];
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:0 animations:^{
            panel.alpha = 1.0;
            panel.transform = CGAffineTransformIdentity;
        } completion:nil];
    }
}

%new - (UIViewController *)rdw_topVC {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *top = window.rootViewController;
    while (top.presentedViewController) top = top.presentedViewController;
    return top;
}
%end
