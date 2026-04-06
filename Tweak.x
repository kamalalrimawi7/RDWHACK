#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>

// --- روابط متجر RDW ---
static NSString *const RDW_URL   = @"https://rdw-server-default-rtdb.firebaseio.com/codes";
static NSString *const RDW_USERS = @"https://rdw-server-default-rtdb.firebaseio.com/users";
static NSString *const RDW_WA    = @"https://wa.me/972567171874?text=%D9%84%D9%82%D8%AF%20%D9%88%D8%A7%D8%AC%D9%87%D8%AA%20%D9%85%D8%B4%D9%83%D9%84%D8%A9%D8%8C%20%D9%87%D9%84%20%D9%8A%D9%85%D9%83%D9%86%D9%83%20%D9%85%D8%B3%D8%A7%D8%B9%D8%AF%D8%AA%D9%8A%3F";
static NSString *const RDW_IG    = @"https://www.instagram.com/rimawi.dw";

#define RDW_GOLD [UIColor colorWithRed:0.72 green:0.56 blue:0.17 alpha:1.0]

// --- إعلان الواجهات المضافة لـ UIWindow لتجنب أخطاء المترجم ---
@interface UIWindow (RDW)
- (void)rdw_lock;
- (void)rdw_periodicCheck;
- (void)rdw_p:(UILongPressGestureRecognizer*)g;
- (UIViewController *)topMostController;
@end

// --- Helpers ---
@interface RDWCore : NSObject
+ (NSString *)myID;
+ (void)vibe:(BOOL)impact;
+ (void)playSoundNamed:(NSString *)name;
@end

@implementation RDWCore
+ (NSString *)myID {
    NSString *stored = [[NSUserDefaults standardUserDefaults] stringForKey:@"RDW_UDID"];
    if (!stored) {
        NSString *newId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        if (!newId) newId = [[NSUUID UUID] UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:newId forKey:@"RDW_UDID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        stored = newId;
    }
    return stored;
}
+ (void)vibe:(BOOL)impact {
    if (impact) {
        UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        [gen impactOccurred];
    } else {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}
+ (void)playSoundNamed:(NSString *)name {
    if ([name isEqualToString:@"success"]) AudioServicesPlaySystemSound(1057);
    else if ([name isEqualToString:@"error"]) AudioServicesPlaySystemSound(1053);
    else AudioServicesPlaySystemSound(1104);
}
@end

// --- Helper function to get topmost controller in a scene-safe way ---
static UIViewController *RDWTopMostController(void) {
    UIWindow *keyWindow = nil;
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *ws = (UIWindowScene *)scene;
                for (UIWindow *w in ws.windows) {
                    if (w.isKeyWindow) { keyWindow = w; break; }
                }
                if (keyWindow) break;
            }
        }
    }
    if (!keyWindow) {
        keyWindow = [UIApplication sharedApplication].delegate.window ?: [UIApplication sharedApplication].windows.firstObject;
    }
    UIViewController *top = keyWindow.rootViewController;
    while (top.presentedViewController) top = top.presentedViewController;
    return top;
}

// --- Lock Screen VC ---
@interface RDWLoginVC : UIViewController
@property (nonatomic, retain) UITextField *inputField;
@property (nonatomic, retain) UILabel *msgL;
@property (nonatomic, retain) UIView *box;
@end

@implementation RDWLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *bv = [[UIVisualEffectView alloc] initWithEffect:blur];
    bv.frame = self.view.bounds; [self.view addSubview:bv];

    CGFloat w = MIN(self.view.frame.size.width - 40, 340);
    self.box = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-w)/2, (self.view.frame.size.height-560)/2, w, 560)];
    self.box.backgroundColor = [UIColor colorWithWhite:0.02 alpha:0.98];
    self.box.layer.cornerRadius = 28; self.box.layer.borderColor = RDW_GOLD.CGColor; self.box.layer.borderWidth = 1.5;
    [self.view addSubview:self.box];

    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((w-120)/2, 30, 120, 120)];
    img.layer.cornerRadius = 60; img.layer.borderWidth = 3; img.layer.borderColor = RDW_GOLD.CGColor; img.clipsToBounds = YES;
    img.backgroundColor = [UIColor colorWithWhite:0.05 alpha:1];
    [self.box addSubview:img];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://i.ibb.co/7xZ41GWF/IMG-3601.jpg"] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        if (d) dispatch_async(dispatch_get_main_queue(), ^{ img.image = [UIImage imageWithData:d]; });
    }] resume];

    UILabel *t1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, w, 30)];
    t1.text = @"Rimawi Digital World"; t1.textColor = RDW_GOLD; t1.textAlignment = NSTextAlignmentCenter; t1.font = [UIFont boldSystemFontOfSize:22];
    [self.box addSubview:t1];

    UILabel *t2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, w, 20)];
    t2.text = @"نسخة حصرية لمتجر RDW"; t2.textColor = [UIColor whiteColor]; t2.textAlignment = NSTextAlignmentCenter; t2.font = [UIFont systemFontOfSize:13];
    [self.box addSubview:t2];

    self.msgL = [[UILabel alloc] initWithFrame:CGRectMake(20, 230, w-40, 30)];
    self.msgL.textColor = [UIColor systemRedColor]; self.msgL.textAlignment = NSTextAlignmentCenter; self.msgL.font = [UIFont systemFontOfSize:13];
    [self.box addSubview:self.msgL];

    self.inputField = [[UITextField alloc] initWithFrame:CGRectMake(20, 270, w-40, 55)];
    self.inputField.placeholder = @"أدخل كود RDW هنا"; self.inputField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.04];
    self.inputField.textColor = [UIColor whiteColor]; self.inputField.textAlignment = NSTextAlignmentCenter; self.inputField.layer.cornerRadius = 14;
    self.inputField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.box addSubview:self.inputField];

    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn1.frame = CGRectMake(20, 340, w-40, 55); [btn1 setTitle:@"تفعيل النسخة" forState:0];
    [btn1 setBackgroundColor:RDW_GOLD]; [btn1 setTitleColor:[UIColor whiteColor] forState:0]; btn1.layer.cornerRadius = 14; [btn1 addTarget:self action:@selector(goCheck) forControlEvents:UIControlEventTouchUpInside];
    [self.box addSubview:btn1];

    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn2.frame = CGRectMake(20, 410, w-40, 50); [btn2 setTitle:@"شراء كود تفعيل" forState:0];
    [btn2 setBackgroundColor:[UIColor colorWithRed:0.1 green:0.5 blue:0.2 alpha:1]]; [btn2 setTitleColor:[UIColor whiteColor] forState:0];
    btn2.layer.cornerRadius = 14; [btn2 addTarget:self action:@selector(goWA) forControlEvents:UIControlEventTouchUpInside];
    [self.box addSubview:btn2];

    UILabel *dev = [[UILabel alloc] initWithFrame:CGRectMake(0, self.box.frame.size.height-30, w, 20)];
    dev.text = @"تم التطوير بواسطة كمال"; dev.textColor = [UIColor grayColor]; dev.textAlignment = NSTextAlignmentCenter; dev.font = [UIFont systemFontOfSize:11];
    [self.box addSubview:dev];

    [self showInitialLockedAlertIfNeeded];
}

- (void)showInitialLockedAlertIfNeeded {
    BOOL shown = [[NSUserDefaults standardUserDefaults] boolForKey:@"RDW_INITIAL_LOCK_SHOWN"];
    if (!shown) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RDW_INITIAL_LOCK_SHOWN"];
        UIAlertController *a = [UIAlertController alertControllerWithTitle:@"🔒 التطبيق مقفل" message:@"الرجاء إدخال كود التفعيل لفتح التطبيق" preferredStyle:UIAlertControllerStyleAlert];
        [a addAction:[UIAlertAction actionWithTitle:@"حسناً" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:a animated:YES completion:nil];
    }
}

- (void)goCheck {
    NSString *code = [self.inputField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (code.length < 4) { [self showError:@"مفتاح خاطئ وغير صالح!"]; return; }

    NSString *urlS = [NSString stringWithFormat:@"%@/%@.json", RDW_URL, code];
    NSURL *url = [NSURL URLWithString:urlS];
    __weak typeof(self) weakSelf = self;
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!d) { [strongSelf showError:@"خطأ في الاتصال"]; return; }
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (!json || [json isEqual:[NSNull null]]) {
                [strongSelf showError:@"الكود غير موجود!"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RDW_IG] options:@{} completionHandler:nil];
                });
                return;
            }
            NSString *uBy = json[@"usedBy"] ?: @"";
            NSString *myU = [RDWCore myID];
            double expiry = [json[@"expiry"] doubleValue];

            if ([uBy isEqualToString:@""]) {
                [strongSelf activateAndStackCode:code existingExpiry:expiry];
            } else if ([uBy isEqualToString:myU]) {
                [strongSelf finalizeActivationForCode:code expiry:expiry];
            } else {
                [strongSelf showError:@"هذا المفتاح مستخدم على جهاز آخر!"];
            }
        });
    }] resume];
}

- (void)activateAndStackCode:(NSString *)code existingExpiry:(double)existingExpiry {
    NSString *myU = [RDWCore myID];
    double now = [[NSDate date] timeIntervalSince1970];
    double codeExpiry = now + (30 * 24 * 3600);
    NSDictionary *p = @{@"usedBy": myU, @"expiry": @(codeExpiry)};
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json", RDW_URL, code]]];
    [req setHTTPMethod:@"PATCH"];
    [req setHTTPBody:[NSJSONSerialization dataWithJSONObject:p options:0 error:nil]];

    __weak typeof(self) weakSelf = self;
    [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;

        __weak typeof(strongSelf) weakInner = strongSelf;
        [weakInner addDaysToUser:30 completion:^(BOOL ok) {
            __strong typeof(weakInner) strongInner = weakInner;
            if (!strongInner) return;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (ok) [strongInner finalizeActivationForCode:code expiry:codeExpiry];
                else [strongInner showError:@"خطأ أثناء تفعيل الكود"];
            });
        }];
    }] resume];
}

- (void)addDaysToUser:(int)days completion:(void(^)(BOOL ok))completion {
    NSString *udid = [RDWCore myID];
    NSString *userURL = [NSString stringWithFormat:@"%@/%@.json", RDW_USERS, udid];

    __weak typeof(self) weakSelf = self;
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:userURL] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            if (completion) completion(NO);
            return;
        }

        double now = [[NSDate date] timeIntervalSince1970];
        double addSeconds = days * 24 * 3600;
        double newExpiry = now + addSeconds;
        if (d) {
            NSDictionary *j = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (j && ![j isEqual:[NSNull null]] && j[@"expiry"]) {
                double cur = [j[@"expiry"] doubleValue];
                if (cur > now) newExpiry = cur + addSeconds;
            }
        }
        NSDictionary *payload = @{@"expiry": @(newExpiry)};
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:userURL]];
        [req setHTTPMethod:@"PATCH"];
        [req setHTTPBody:[NSJSONSerialization dataWithJSONObject:payload options:0 error:nil]];
        [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *d2, NSURLResponse *r2, NSError *e2) {
            if (completion) completion(e2==nil);
        }] resume];
    }] resume];
}

- (void)finalizeActivationForCode:(NSString *)code expiry:(double)expiry {
    NSMutableArray *arr = [[[NSUserDefaults standardUserDefaults] objectForKey:@"RDW_KEYS"] mutableCopy];
    if (!arr) arr = [NSMutableArray array];
    if (![arr containsObject:code]) [arr addObject:code];
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"RDW_KEYS"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [RDWCore vibe:YES]; [RDWCore playSoundNamed:@"success"];
    UIAlertController *a = [UIAlertController alertControllerWithTitle:@"✅ تم التفعيل" message:@"أهلاً بك في Rimawi Digital World" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:a animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.2*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [a dismissViewControllerAnimated:YES completion:^{
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        });
    }];
}

- (void)showError:(NSString *)msg {
    self.msgL.text = msg;
    [RDWCore vibe:NO]; [RDWCore playSoundNamed:@"error"];
    UIColor *orig = self.box.backgroundColor;
    [UIView animateWithDuration:0.12 animations:^{ self.box.backgroundColor = [UIColor colorWithRed:0.35 green:0.05 blue:0.05 alpha:0.95]; } completion:^(BOOL fin){
        [UIView animateWithDuration:0.25 animations:^{ self.box.backgroundColor = orig; }];
    }];
}

- (void)goWA {
    NSString *msg = @"لقد واجهت مشكلة، هل يمكنك مساعدتي؟";
    NSString *enc = [msg stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlS = [NSString stringWithFormat:@"https://wa.me/972567171874?text=%@", enc];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlS] options:@{} completionHandler:nil];
}

@end

// --- Panel (3-finger) ---
@interface RDWPanel : UIView
@property (nonatomic, retain) UILabel *lbl;
@property (nonatomic, retain) UITextField *fld;
@property (nonatomic, retain) UIButton *extendBtn;
@property (nonatomic, retain) UIButton *supportBtn;
@end

@implementation RDWPanel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.05 alpha:0.98]; self.layer.cornerRadius = 18;
        self.layer.borderColor = RDW_GOLD.CGColor; self.layer.borderWidth = 2; self.tag = 888;

        self.lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, frame.size.width-20, 60)];
        self.lbl.numberOfLines = 2; self.lbl.textColor = [UIColor whiteColor]; self.lbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.lbl];

        self.fld = [[UITextField alloc] initWithFrame:CGRectMake(16, 80, frame.size.width-32, 44)];
        self.fld.placeholder = @"أدخل كود تمديد"; self.fld.backgroundColor = [UIColor colorWithWhite:1 alpha:0.06];
        self.fld.textAlignment = NSTextAlignmentCenter; self.fld.layer.cornerRadius = 10; self.fld.textColor = [UIColor whiteColor];
        [self addSubview:self.fld];

        self.extendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.extendBtn.frame = CGRectMake((frame.size.width-160)/2, 134, 160, 44);
        [self.extendBtn setTitle:@"تمديد الاشتراك" forState:0];
        [self.extendBtn setBackgroundColor:RDW_GOLD]; [self.extendBtn setTitleColor:[UIColor whiteColor] forState:0];
        self.extendBtn.layer.cornerRadius = 10; [self.extendBtn addTarget:self action:@selector(stack) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.extendBtn];

        self.supportBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.supportBtn.frame = CGRectMake((frame.size.width-160)/2, 188, 160, 40);
        [self.supportBtn setTitle:@"الدعم الفني" forState:0];
        [self.supportBtn setBackgroundColor:[UIColor colorWithRed:0.12 green:0.45 blue:0.9 alpha:1]]; [self.supportBtn setTitleColor:[UIColor whiteColor] forState:0];
        self.supportBtn.layer.cornerRadius = 10; [self.supportBtn addTarget:self action:@selector(openSupport) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.supportBtn];

        [self refresh];
    }
    return self;
}

- (void)refresh {
    NSString *udid = [RDWCore myID];
    NSString *userURL = [NSString stringWithFormat:@"%@/%@.json", RDW_USERS, udid];
    __weak typeof(self) weakSelf = self;
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:userURL] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        int days = 0;
        if (d) {
            NSDictionary *j = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (j && ![j isEqual:[NSNull null]] && j[@"expiry"]) {
                double expiry = [j[@"expiry"] doubleValue];
                double now = [[NSDate date] timeIntervalSince1970];
                days = (int)ceil((expiry - now) / 86400.0);
                if (days < 0) days = 0;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) return;
            NSString *k = [[[NSUserDefaults standardUserDefaults] objectForKey:@"RDW_KEYS"] firstObject] ?: @"-";
            strongSelf.lbl.text = [NSString stringWithFormat:@"كودك: %@\nمتبقي: %d يوم", k, days];
        });
    }] resume];
}

- (void)stack {
    NSString *code = [self.fld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (code.length < 4) {
        [self showLocalError:@"مفتاح خاطئ وغير صالح"];
        return;
    }
    NSString *urlS = [NSString stringWithFormat:@"%@/%@.json", RDW_URL, code];
    NSURL *url = [NSURL URLWithString:urlS];
    __weak typeof(self) weakSelf = self;
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!d) { [strongSelf showLocalError:@"خطأ في الاتصال"]; return; }
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (!json || [json isEqual:[NSNull null]]) { [strongSelf showLocalError:@"الكود غير موجود"]; return; }
            NSString *uBy = json[@"usedBy"] ?: @"";
            NSString *myU = [RDWCore myID];
 
            if ([uBy isEqualToString:@""] || [uBy isEqualToString:myU]) {
                double now = [[NSDate date] timeIntervalSince1970];
                double codeExpiry = now + (30 * 24 * 3600);
                NSDictionary *p = @{@"usedBy": myU, @"expiry": @(codeExpiry)};
               
                NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json", RDW_URL, code]]];
                [req setHTTPMethod:@"PATCH"];
                [req setHTTPBody:[NSJSONSerialization dataWithJSONObject:p options:0 error:nil]];
                __weak typeof(strongSelf) weakInner = strongSelf;
                [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *d2, NSURLResponse *r2, NSError *e2) {
                    __strong typeof(weakInner) strongInner = weakInner;
                    if (!strongInner) return;

                    __weak typeof(strongInner) weakInner2 = strongInner;
                    [weakInner2 addDaysToUser:30 completion:^(BOOL ok) {
                        __strong typeof(weakInner2) strongInner2 = weakInner2;
                        if (!strongInner2) return;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (ok) {
                                [strongInner2 showLocalSuccess:@"تمت إضافة 30 يوم"];
                                NSMutableArray *arr = [[[NSUserDefaults standardUserDefaults] objectForKey:@"RDW_KEYS"] mutableCopy];
                                if (!arr) arr = [NSMutableArray array];
                                if (![arr containsObject:code]) [arr addObject:code];
                                [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"RDW_KEYS"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                [strongInner2 refresh];
                            } else {
                                [strongInner2 showLocalError:@"خطأ أثناء التحديث"];
                            }
                        });
                    }];
                }] resume];
            } else {
                [strongSelf showLocalError:@"هذا المفتاح مستخدم"];
            }
        });
    }] resume];
}

- (void)addDaysToUser:(int)days completion:(void(^)(BOOL ok))completion {
    NSString *udid = [RDWCore myID];
    NSString *userURL = [NSString stringWithFormat:@"%@/%@.json", RDW_USERS, udid];

    __weak typeof(self) weakSelf = self;
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:userURL] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            if (completion) completion(NO);
            return;
        }

        double now = [[NSDate date] timeIntervalSince1970];
        double addSeconds = days * 24 * 3600;
        double newExpiry = now + addSeconds;
        if (d) {
            NSDictionary *j = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (j && ![j isEqual:[NSNull null]] && j[@"expiry"]) {
                double cur = [j[@"expiry"] doubleValue];
                if (cur > now) newExpiry = cur + addSeconds;
            }
        }
        NSDictionary *payload = @{@"expiry": @(newExpiry)};
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:userURL]];
        [req setHTTPMethod:@"PATCH"];
        [req setHTTPBody:[NSJSONSerialization dataWithJSONObject:payload options:0 error:nil]];
        [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *d2, NSURLResponse *r2, NSError *e2) {
            if (completion) completion(e2==nil);
        }] resume];
    }] resume];
}

- (void)openSupport {
    NSString *msg = @"لقد واجهت مشكلة، هل يمكنك مساعدتي؟";
    NSString *enc = [msg stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlS = [NSString stringWithFormat:@"https://wa.me/972567171874?text=%@", enc];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlS] options:@{} completionHandler:nil];
}

- (void)showLocalError:(NSString *)m {
    [RDWCore vibe:NO]; [RDWCore playSoundNamed:@"error"];
    UIAlertController *a = [UIAlertController alertControllerWithTitle:@"خطأ" message:m preferredStyle:UIAlertControllerStyleAlert];
    [a addAction:[UIAlertAction actionWithTitle:@"حسناً" style:UIAlertActionStyleDefault handler:nil]];
    UIViewController *top = RDWTopMostController();
    [top presentViewController:a animated:YES completion:nil];
}

- (void)showLocalSuccess:(NSString *)m {
    [RDWCore vibe:YES]; [RDWCore playSoundNamed:@"success"];
    UIAlertController *a = [UIAlertController alertControllerWithTitle:@"نجاح" message:m preferredStyle:UIAlertControllerStyleAlert];
    [a addAction:[UIAlertAction actionWithTitle:@"حسناً" style:UIAlertActionStyleDefault handler:nil]];
    UIViewController *top = RDWTopMostController();
    [top presentViewController:a animated:YES completion:nil];
}

@end

// --- Main hook on UIWindow to enforce lock and periodic checks ---
%hook UIWindow

- (void)makeKeyAndVisible {
    %orig;

    // Schedule periodic check (every 30s)
    __weak typeof(self) weakWin = self;
    [NSTimer scheduledTimerWithTimeInterval:30 repeats:YES block:^(NSTimer *t) {
        __strong typeof(weakWin) strongWin = weakWin;
        if (!strongWin) return;
        if ([strongWin respondsToSelector:@selector(rdw_periodicCheck)]) {
            [(id)strongWin rdw_periodicCheck];
        }
    }];

    // Add 3-finger long press (2 seconds)
    UILongPressGestureRecognizer *lp = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(rdw_p:)];
    lp.numberOfTouchesRequired = 3; lp.minimumPressDuration = 2.0; [self addGestureRecognizer:lp];

    // Immediately lock on first run or if no local keys
    NSArray *k = [[NSUserDefaults standardUserDefaults] objectForKey:@"RDW_KEYS"];
    if (!k || k.count == 0) {
        if ([self respondsToSelector:@selector(rdw_lock)]) {
            [(id)self rdw_lock];
        }
    }
}

%new
- (void)rdw_lock {
    UIViewController *top = [self topMostController];
    if (![top isKindOfClass:[RDWLoginVC class]]) {
        RDWLoginVC *vc = [[RDWLoginVC alloc] init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [top presentViewController:vc animated:YES completion:nil];
    }
}

%new
- (void)rdw_p:(UILongPressGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateBegan) {
        if ([self viewWithTag:888]) {
            [[self viewWithTag:888] removeFromSuperview];
            return;
        }
        RDWPanel *p = [[RDWPanel alloc] initWithFrame:CGRectMake((self.frame.size.width-300)/2, 120, 300, 240)];
        p.alpha = 0.0; p.transform = CGAffineTransformMakeScale(0.8, 0.8);
        [self addSubview:p];
        [UIView animateWithDuration:0.28 animations:^{ p.alpha = 1.0; p.transform = CGAffineTransformIdentity; }];
    }
}

%new
- (void)rdw_periodicCheck {
    NSString *udid = [RDWCore myID];
    NSString *userURL = [NSString stringWithFormat:@"%@/%@.json", RDW_USERS, udid];

    __weak typeof(self) weakSelf = self;
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:userURL] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        __block BOOL shouldLock = NO;
        double now = [[NSDate date] timeIntervalSince1970];
        if (d) {
            NSDictionary *j = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (!j || [j isEqual:[NSNull null]] || !j[@"expiry"]) {
                shouldLock = YES;
            } else {
                double expiry = [j[@"expiry"] doubleValue];
                if (expiry < now) shouldLock = YES;
            }
        } else {
            // network error: continue to check codes
        }

        NSString *codesURL = [NSString stringWithFormat:@"%@.json", RDW_URL];
        [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:codesURL] completionHandler:^(NSData *d2, NSURLResponse *r2, NSError *e2) {
            __strong typeof(weakSelf) strongSelf2 = weakSelf;
            if (!strongSelf2) return;
            if (d2) {
                NSDictionary *all = [NSJSONSerialization JSONObjectWithData:d2 options:0 error:nil];
                BOOL hasValid = NO;
                for (NSString *key in all) {
                    NSDictionary *c = all[key];
                    if (![c isKindOfClass:[NSDictionary class]]) continue;
                    NSString *usedBy = c[@"usedBy"] ?: @"";
                    double cexp = [c[@"expiry"] doubleValue];
                    if ([usedBy isEqualToString:udid] && cexp > now) { hasValid = YES; break; }
                }
                if (!hasValid) shouldLock = YES;
            } else {
                // cannot fetch codes: be conservative and do not change lock state immediately
            }
            if (shouldLock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"RDW_KEYS"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    if ([strongSelf2 respondsToSelector:@selector(rdw_lock)]) {
                        [(id)strongSelf2 rdw_lock];
                    }
                });
            }
        }] resume];
    }] resume];
}

%end

// --- Utility category to find topmost controller in a scene-safe way ---
@implementation UIWindow (RDWUtils)

- (UIViewController *)topMostController {
    UIWindow *keyWindow = nil;
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *ws = (UIWindowScene *)scene;
                for (UIWindow *w in ws.windows) {
                    if (w.isKeyWindow) { keyWindow = w; break; }
                }
                if (keyWindow) break;
            }
        }
    }
    if (!keyWindow) {
        keyWindow = [UIApplication sharedApplication].delegate.window ?: [UIApplication sharedApplication].windows.firstObject;
    }
    UIViewController *top = keyWindow.rootViewController;
    while (top.presentedViewController) top = top.presentedViewController;
    return top;
}

@end
