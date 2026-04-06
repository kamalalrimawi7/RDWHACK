#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>

// --- روابط متجر RDW المحدثة بناءً على الصور ---
static NSString *const RDW_URL   = @"https://rdw-server-default-rtdb.firebaseio.com/codes"; [cite: 156]
static NSString *const RDW_USERS = @"https://rdw-server-default-rtdb.firebaseio.com/users"; [cite: 157]
static NSString *const RDW_WA    = @"https://wa.me/972567171874?text=%D9%84%D9%82%D8%AF%20%D9%88%D8%A7%D8%AC%D9%87%D8%AA%20%D9%85%D8%B4%D9%83%D9%84%D8%A9%D8%8C%20%D9%87%D9%84%20%D9%8A%D9%85%D9%83%D9%86%D9%83%20%D9%85%D8%B3%D8%A7%D8%B9%D8%AF%D8%AA%D9%8A%3F"; [cite: 157]
static NSString *const RDW_IG    = @"https://www.instagram.com/rimawi.dw"; [cite: 157]
#define RDW_GOLD [UIColor colorWithRed:0.72 green:0.56 blue:0.17 alpha:1.0] [cite: 158]

// --- إعلان الواجهات المضافة لـ UIWindow ---
@interface UIWindow (RDW)
- (void)rdw_lock;
- (void)rdw_periodicCheck; [cite: 159]
- (void)rdw_p:(UILongPressGestureRecognizer*)g;
- (UIViewController *)topMostController;
@end

// --- Helpers ---
@interface RDWCore : NSObject
+ (NSString *)myID;
+ (void)vibe:(BOOL)impact;
+ (void)playSoundNamed:(NSString *)name; [cite: 160]
@end

@implementation RDWCore
+ (NSString *)myID {
    NSString *stored = [[NSUserDefaults standardUserDefaults] stringForKey:@"RDW_UDID"];
    if (!stored) { [cite: 161]
        NSString *newId = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; [cite: 162]
        if (!newId) newId = [[NSUUID UUID] UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:newId forKey:@"RDW_UDID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        stored = newId;
    } [cite: 163]
    return stored;
}
+ (void)vibe:(BOOL)impact {
    if (impact) {
        UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        [gen impactOccurred]; [cite: 164]
    } else {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    } [cite: 165]
}
+ (void)playSoundNamed:(NSString *)name {
    if ([name isEqualToString:@"success"]) AudioServicesPlaySystemSound(1057);
    else if ([name isEqualToString:@"error"]) AudioServicesPlaySystemSound(1053);
    else AudioServicesPlaySystemSound(1104); [cite: 166]
}
@end

// --- الحصول على المتحكم العلوي بطريقة آمنة ---
static UIViewController *RDWTopMostController(void) {
    UIWindow *keyWindow = nil;
    if (@available(iOS 13.0, *)) { [cite: 167]
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *ws = (UIWindowScene *)scene;
                for (UIWindow *w in ws.windows) { [cite: 168]
                    if (w.isKeyWindow) { keyWindow = w; break; } [cite: 169]
                }
                if (keyWindow) break;
            } [cite: 170]
        }
    }
    if (!keyWindow) {
        keyWindow = [UIApplication sharedApplication].delegate.window ?: [UIApplication sharedApplication].windows.firstObject;
    } [cite: 171]
    UIViewController *top = keyWindow.rootViewController;
    while (top.presentedViewController) top = top.presentedViewController;
    return top; [cite: 172]
}

// --- واجهة القفل (Login VC) ---
@interface RDWLoginVC : UIViewController
@property (nonatomic, retain) UITextField *inputField;
@property (nonatomic, retain) UILabel *msgL;
@property (nonatomic, retain) UIView *box; [cite: 173]
@end

@implementation RDWLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor]; [cite: 174]
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *bv = [[UIVisualEffectView alloc] initWithEffect:blur];
    bv.frame = self.view.bounds; [self.view addSubview:bv]; [cite: 175]
    
    CGFloat w = MIN(self.view.frame.size.width - 40, 340);
    self.box = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-w)/2, (self.view.frame.size.height-560)/2, w, 560)];
    self.box.backgroundColor = [UIColor colorWithWhite:0.02 alpha:0.98]; [cite: 176]
    self.box.layer.cornerRadius = 28; self.box.layer.borderColor = RDW_GOLD.CGColor; self.box.layer.borderWidth = 1.5;
    [self.view addSubview:self.box];

    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((w-120)/2, 30, 120, 120)]; [cite: 177]
    img.layer.cornerRadius = 60; img.layer.borderWidth = 3; img.layer.borderColor = RDW_GOLD.CGColor; img.clipsToBounds = YES;
    img.backgroundColor = [UIColor colorWithWhite:0.05 alpha:1];
    [self.box addSubview:img]; [cite: 178]
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://i.ibb.co/7xZ41GWF/IMG-3601.jpg"] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        if (d) dispatch_async(dispatch_get_main_queue(), ^{ img.image = [UIImage imageWithData:d]; });
    }] resume]; [cite: 179]

    UILabel *t1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, w, 30)];
    t1.text = @"Rimawi Digital World"; t1.textColor = RDW_GOLD; [cite: 180]
    t1.textAlignment = NSTextAlignmentCenter; t1.font = [UIFont boldSystemFontOfSize:22];
    [self.box addSubview:t1];

    UILabel *t2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, w, 20)]; [cite: 181]
    t2.text = @"نسخة حصرية لمتجر RDW"; t2.textColor = [UIColor whiteColor]; t2.textAlignment = NSTextAlignmentCenter; t2.font = [UIFont systemFontOfSize:13];
    [self.box addSubview:t2]; [cite: 182]
    
    self.msgL = [[UILabel alloc] initWithFrame:CGRectMake(20, 230, w-40, 30)];
    self.msgL.textColor = [UIColor systemRedColor]; self.msgL.textAlignment = NSTextAlignmentCenter; self.msgL.font = [UIFont systemFontOfSize:13]; [cite: 183]
    [self.box addSubview:self.msgL];

    self.inputField = [[UITextField alloc] initWithFrame:CGRectMake(20, 270, w-40, 55)];
    self.inputField.placeholder = @"أدخل كود RDW هنا"; [cite: 184]
    self.inputField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.04];
    self.inputField.textColor = [UIColor whiteColor]; self.inputField.textAlignment = NSTextAlignmentCenter; self.inputField.layer.cornerRadius = 14;
    self.inputField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.box addSubview:self.inputField]; [cite: 185]
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn1.frame = CGRectMake(20, 340, w-40, 55); [btn1 setTitle:@"تفعيل النسخة" forState:0];
    [btn1 setBackgroundColor:RDW_GOLD]; [cite: 186]
    [btn1 setTitleColor:[UIColor whiteColor] forState:0]; btn1.layer.cornerRadius = 14; [btn1 addTarget:self action:@selector(goCheck) forControlEvents:UIControlEventTouchUpInside];
    [self.box addSubview:btn1];

    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem]; [cite: 187]
    btn2.frame = CGRectMake(20, 410, w-40, 50); [btn2 setTitle:@"شراء كود تفعيل" forState:0];
    [btn2 setBackgroundColor:[UIColor colorWithRed:0.1 green:0.5 blue:0.2 alpha:1]]; [cite: 188]
    [btn2 setTitleColor:[UIColor whiteColor] forState:0];
    btn2.layer.cornerRadius = 14; [btn2 addTarget:self action:@selector(goWA) forControlEvents:UIControlEventTouchUpInside];
    [self.box addSubview:btn2]; [cite: 189]
    
    UILabel *dev = [[UILabel alloc] initWithFrame:CGRectMake(0, self.box.frame.size.height-30, w, 20)];
    dev.text = @"تم التطوير بواسطة كمال"; dev.textColor = [UIColor grayColor]; [cite: 190]
    dev.textAlignment = NSTextAlignmentCenter; dev.font = [UIFont systemFontOfSize:11];
    [self.box addSubview:dev];

    [self showInitialLockedAlertIfNeeded]; [cite: 191]
}

- (void)showInitialLockedAlertIfNeeded {
    BOOL shown = [[NSUserDefaults standardUserDefaults] boolForKey:@"RDW_INITIAL_LOCK_SHOWN"]; [cite: 192]
    if (!shown) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RDW_INITIAL_LOCK_SHOWN"]; [cite: 193]
        UIAlertController *a = [UIAlertController alertControllerWithTitle:@"🔒 التطبيق مقفل" message:@"الرجاء إدخال كود التفعيل لفتح التطبيق" preferredStyle:UIAlertControllerStyleAlert];
        [a addAction:[UIAlertAction actionWithTitle:@"حسناً" style:UIAlertActionStyleDefault handler:nil]]; [cite: 194]
        [self presentViewController:a animated:YES completion:nil];
    }
}

- (void)goCheck {
    NSString *code = [self.inputField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; [cite: 195]
    if (code.length < 4) { [self showError:@"مفتاح خاطئ وغير صالح!"]; return; } [cite: 196]

    NSString *urlS = [NSString stringWithFormat:@"%@/%@.json", RDW_URL, code];
    NSURL *url = [NSURL URLWithString:urlS]; [cite: 197]
    __weak typeof(self) weakSelf = self;
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        __strong typeof(weakSelf) strongSelf = weakSelf; [cite: 198]
        if (!strongSelf) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!d) { [strongSelf showError:@"خطأ في الاتصال"]; return; }
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (!json || [json isEqual:[NSNull null]]) {
                [strongSelf showError:@"الكود غير موجود!"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ [cite: 199]
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RDW_IG] options:@{} completionHandler:nil];
                });
                return;
            }
            NSString *uBy = json[@"usedBy"] ?: @"";
            NSString *myU = [RDWCore myID]; [cite: 200]
            double expiry = [json[@"expiry"] doubleValue];

            if ([uBy isEqualToString:@""]) {
                [strongSelf activateAndStackCode:code existingExpiry:expiry];
            } else if ([uBy isEqualToString:myU]) {
                [strongSelf finalizeActivationForCode:code expiry:expiry]; [cite: 201]
            } else {
                [strongSelf showError:@"هذا المفتاح مستخدم على جهاز آخر!"]; [cite: 202]
            }
        });
    }] resume]; [cite: 203]
}

- (void)activateAndStackCode:(NSString *)code existingExpiry:(double)existingExpiry {
    NSString *myU = [RDWCore myID];
    double now = [[NSDate date] timeIntervalSince1970]; [cite: 204]
    double codeExpiry = now + (30 * 24 * 3600);
    NSDictionary *p = @{@"usedBy": myU, @"expiry": @(codeExpiry)}; [cite: 205]
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json", RDW_URL, code]]];
    [req setHTTPMethod:@"PATCH"];
    [req setHTTPBody:[NSJSONSerialization dataWithJSONObject:p options:0 error:nil]]; [cite: 206]
    __weak typeof(self) weakSelf = self;
    [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        __strong typeof(weakSelf) strongSelf = weakSelf; [cite: 207]
        if (!strongSelf) return;

        __weak typeof(strongSelf) weakInner = strongSelf;
        [weakInner addDaysToUser:30 completion:^(BOOL ok) {
            __strong typeof(weakInner) strongInner = weakInner; [cite: 208]
            if (!strongInner) return;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (ok) [strongInner finalizeActivationForCode:code expiry:codeExpiry];
                else [strongInner showError:@"خطأ أثناء تفعيل الكود"];
            }); [cite: 209]
        }];
    }] resume];
}

- (void)addDaysToUser:(int)days completion:(void(^)(BOOL ok))completion {
    NSString *udid = [RDWCore myID]; [cite: 210]
    NSString *userURL = [NSString stringWithFormat:@"%@/%@.json", RDW_USERS, udid];

    __weak typeof(self) weakSelf = self; [cite: 211]
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:userURL] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        __strong typeof(weakSelf) strongSelf = weakSelf; [cite: 212]
        if (!strongSelf) {
            if (completion) completion(NO);
            return; [cite: 213]
        }

        double now = [[NSDate date] timeIntervalSince1970]; [cite: 214]
        double addSeconds = days * 24 * 3600;
        double newExpiry = now + addSeconds; [cite: 215]
        if (d) {
            NSDictionary *j = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil]; [cite: 216]
            if (j && ![j isEqual:[NSNull null]] && j[@"expiry"]) {
                double cur = [j[@"expiry"] doubleValue]; [cite: 217]
                if (cur > now) newExpiry = cur + addSeconds;
            }
        }
        NSDictionary *payload = @{@"expiry": @(newExpiry)}; [cite: 218]
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:userURL]];
        [req setHTTPMethod:@"PATCH"];
        [req setHTTPBody:[NSJSONSerialization dataWithJSONObject:payload options:0 error:nil]]; [cite: 219]
        [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *d2, NSURLResponse *r2, NSError *e2) {
            if (completion) completion(e2==nil); [cite: 220]
        }] resume];
    }] resume];
}

- (void)finalizeActivationForCode:(NSString *)code expiry:(double)expiry {
    NSMutableArray *arr = [[[NSUserDefaults standardUserDefaults] objectForKey:@"RDW_KEYS"] mutableCopy]; [cite: 221]
    if (!arr) arr = [NSMutableArray array];
    if (![arr containsObject:code]) [arr addObject:code];
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"RDW_KEYS"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [RDWCore vibe:YES]; [cite: 222]
    [RDWCore playSoundNamed:@"success"];
    UIAlertController *a = [UIAlertController alertControllerWithTitle:@"✅ تم التفعيل" message:@"أهلاً بك في Rimawi Digital World" preferredStyle:UIAlertControllerStyleAlert]; [cite: 223]
    [self presentViewController:a animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.2*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [a dismissViewControllerAnimated:YES completion:^{
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }); [cite: 224]
    }];
}

- (void)showError:(NSString *)msg {
    self.msgL.text = msg;
    [RDWCore vibe:NO]; [RDWCore playSoundNamed:@"error"];
    UIColor *orig = self.box.backgroundColor; [cite: 225]
    [UIView animateWithDuration:0.12 animations:^{ self.box.backgroundColor = [UIColor colorWithRed:0.35 green:0.05 blue:0.05 alpha:0.95]; [cite: 226]
    } completion:^(BOOL fin){
        [UIView animateWithDuration:0.25 animations:^{ self.box.backgroundColor = orig; }];
    }]; [cite: 227]
}

- (void)goWA {
    NSString *msg = @"لقد واجهت مشكلة، هل يمكنك مساعدتي؟"; [cite: 228]
    NSString *enc = [msg stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlS = [NSString stringWithFormat:@"https://wa.me/972567171874?text=%@", enc];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlS] options:@{} completionHandler:nil]; [cite: 229]
}

@end

// --- لوحة التحكم (Hidden Panel) ---
@interface RDWPanel : UIView
@property (nonatomic, retain) UILabel *lbl;
@property (nonatomic, retain) UITextField *fld;
@property (nonatomic, retain) UIButton *extendBtn; [cite: 230]
@property (nonatomic, retain) UIButton *supportBtn;
@end [cite: 231]

@implementation RDWPanel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame]; [cite: 232]
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.05 alpha:0.98]; self.layer.cornerRadius = 18; [cite: 233]
        self.layer.borderColor = RDW_GOLD.CGColor; self.layer.borderWidth = 2; self.tag = 888;

        self.lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, frame.size.width-20, 60)];
        self.lbl.numberOfLines = 2; [cite: 234]
        self.lbl.textColor = [UIColor whiteColor]; self.lbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.lbl];

        self.fld = [[UITextField alloc] initWithFrame:CGRectMake(16, 80, frame.size.width-32, 44)]; [cite: 235]
        self.fld.placeholder = @"أدخل كود تمديد"; self.fld.backgroundColor = [UIColor colorWithWhite:1 alpha:0.06];
        self.fld.textAlignment = NSTextAlignmentCenter; self.fld.layer.cornerRadius = 10; self.fld.textColor = [UIColor whiteColor]; [cite: 236]
        [self addSubview:self.fld];

        self.extendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.extendBtn.frame = CGRectMake((frame.size.width-160)/2, 134, 160, 44);
        [self.extendBtn setTitle:@"تمديد الاشتراك" forState:0];
        [self.extendBtn setBackgroundColor:RDW_GOLD]; [cite: 237]
        [self.extendBtn setTitleColor:[UIColor whiteColor] forState:0];
        self.extendBtn.layer.cornerRadius = 10; [self.extendBtn addTarget:self action:@selector(stack) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.extendBtn];

        self.supportBtn = [UIButton buttonWithType:UIButtonTypeSystem]; [cite: 238]
        self.supportBtn.frame = CGRectMake((frame.size.width-160)/2, 188, 160, 40);
        [self.supportBtn setTitle:@"الدعم الفني" forState:0];
        [self.supportBtn setBackgroundColor:[UIColor colorWithRed:0.12 green:0.45 blue:0.9 alpha:1]]; [self.supportBtn setTitleColor:[UIColor whiteColor] forState:0]; [cite: 239]
        self.supportBtn.layer.cornerRadius = 10; [self.supportBtn addTarget:self action:@selector(openSupport) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.supportBtn];

        [self refresh];
    }
    return self; [cite: 240]
}

- (void)refresh {
    NSString *udid = [RDWCore myID];
    NSString *userURL = [NSString stringWithFormat:@"%@/%@.json", RDW_USERS, udid]; [cite: 241]
    __weak typeof(self) weakSelf = self;
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:userURL] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        int days = 0; [cite: 242]
        if (d) {
            NSDictionary *j = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil]; [cite: 243]
            if (j && ![j isEqual:[NSNull null]] && j[@"expiry"]) {
                double expiry = [j[@"expiry"] doubleValue]; [cite: 244]
                double now = [[NSDate date] timeIntervalSince1970];
                days = (int)ceil((expiry - now) / 86400.0);
                if (days < 0) days = 0; [cite: 245]
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) return;
            NSString *k = [[[NSUserDefaults standardUserDefaults] objectForKey:@"RDW_KEYS"] firstObject] ?: @"-";
            strongSelf.lbl.text = [NSString stringWithFormat:@"كودك: %@\nمتبقي: %d يوم", k, days];
        }); [cite: 246]
    }] resume];
}

- (void)stack {
    NSString *code = [self.fld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; [cite: 247]
    if (code.length < 4) {
        [self showLocalError:@"مفتاح خاطئ وغير صالح"];
        return; [cite: 248]
    }
    NSString *urlS = [NSString stringWithFormat:@"%@/%@.json", RDW_URL, code];
    NSURL *url = [NSURL URLWithString:urlS]; [cite: 249]
    __weak typeof(self) weakSelf = self;
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        __strong typeof(weakSelf) strongSelf = weakSelf; [cite: 250]
        if (!strongSelf) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!d) { [strongSelf showLocalError:@"خطأ في الاتصال"]; return; }
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (!json || [json isEqual:[NSNull null]]) { [strongSelf showLocalError:@"الكود غير موجود"]; return; }
            NSString *uBy = json[@"usedBy"] ?: @"";
            NSString *myU = [RDWCore myID]; [cite: 251]
 
            if ([uBy isEqualToString:@""] || [uBy isEqualToString:myU]) {
                double now = [[NSDate date] timeIntervalSince1970];
                double codeExpiry = now + (30 * 24 * 3600);
                NSDictionary *p = @{@"usedBy": myU, @"expiry": @(codeExpiry)}; [cite: 252]
               
                NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json", RDW_URL, code]]];
                [req setHTTPMethod:@"PATCH"];
                [req setHTTPBody:[NSJSONSerialization dataWithJSONObject:p options:0 error:nil]]; [cite: 253]
                __weak typeof(strongSelf) weakInner = strongSelf;
                [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *d2, NSURLResponse *r2, NSError *e2) {
                    __strong typeof(weakInner) strongInner = weakInner; [cite: 254]
                    if (!strongInner) return;

                    __weak typeof(strongInner) weakInner2 = strongInner;
                    [weakInner2 addDaysToUser:30 completion:^(BOOL ok) {
                        __strong typeof(weakInner2) strongInner2 = weakInner2; [cite: 255]
                        if (!strongInner2) return;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (ok) {
                                [strongInner2 showLocalSuccess:@"تمت إضافة 30 يوم"]; [cite: 256]
                                NSMutableArray *arr = [[[NSUserDefaults standardUserDefaults] objectForKey:@"RDW_KEYS"] mutableCopy];
                                if (!arr) arr = [NSMutableArray array];
                                if (![arr containsObject:code]) [arr addObject:code]; [cite: 257]
                                [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"RDW_KEYS"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                [strongInner2 refresh]; [cite: 258]
                            } else {
                                [strongInner2 showLocalError:@"خطأ أثناء التحديث"];
                            } [cite: 259]
                        });
                    }];
                }] resume];
            } else {
                [strongSelf showLocalError:@"هذا المفتاح مستخدم"]; [cite: 260]
            }
        });
    }] resume]; [cite: 261]
}

- (void)addDaysToUser:(int)days completion:(void(^)(BOOL ok))completion {
    NSString *udid = [RDWCore myID];
    NSString *userURL = [NSString stringWithFormat:@"%@/%@.json", RDW_USERS, udid]; [cite: 262]
    __weak typeof(self) weakSelf = self;
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:userURL] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        __strong typeof(weakSelf) strongSelf = weakSelf; [cite: 263]
        if (!strongSelf) {
            if (completion) completion(NO);
            return; [cite: 264]
        }

        double now = [[NSDate date] timeIntervalSince1970]; [cite: 265]
        double addSeconds = days * 24 * 3600;
        double newExpiry = now + addSeconds; [cite: 266]
        if (d) {
            NSDictionary *j = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil]; [cite: 267]
            if (j && ![j isEqual:[NSNull null]] && j[@"expiry"]) {
                double cur = [j[@"expiry"] doubleValue]; [cite: 268]
                if (cur > now) newExpiry = cur + addSeconds;
            }
        }
        NSDictionary *payload = @{@"expiry": @(newExpiry)}; [cite: 269]
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:userURL]];
        [req setHTTPMethod:@"PATCH"];
        [req setHTTPBody:[NSJSONSerialization dataWithJSONObject:payload options:0 error:nil]]; [cite: 270]
        [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *d2, NSURLResponse *r2, NSError *e2) {
            if (completion) completion(e2==nil); [cite: 271]
        }] resume];
    }] resume];
}

- (void)openSupport {
    NSString *msg = @"لقد واجهت مشكلة، هل يمكنك مساعدتي؟"; [cite: 272]
    NSString *enc = [msg stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlS = [NSString stringWithFormat:@"https://wa.me/972567171874?text=%@", enc];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlS] options:@{} completionHandler:nil]; [cite: 273]
}

- (void)showLocalError:(NSString *)m {
    [RDWCore vibe:NO]; [RDWCore playSoundNamed:@"error"];
    UIAlertController *a = [UIAlertController alertControllerWithTitle:@"خطأ" message:m preferredStyle:UIAlertControllerStyleAlert]; [cite: 274]
    [a addAction:[UIAlertAction actionWithTitle:@"حسناً" style:UIAlertActionStyleDefault handler:nil]];
    UIViewController *top = RDWTopMostController();
    [top presentViewController:a animated:YES completion:nil]; [cite: 275]
}

- (void)showLocalSuccess:(NSString *)m {
    [RDWCore vibe:YES]; [RDWCore playSoundNamed:@"success"];
    UIAlertController *a = [UIAlertController alertControllerWithTitle:@"نجاح" message:m preferredStyle:UIAlertControllerStyleAlert]; [cite: 276]
    [a addAction:[UIAlertAction actionWithTitle:@"حسناً" style:UIAlertActionStyleDefault handler:nil]];
    UIViewController *top = RDWTopMostController();
    [top presentViewController:a animated:YES completion:nil]; [cite: 277]
}

@end

// --- الـ Hook الرئيسي على UIWindow ---
%hook UIWindow

- (void)makeKeyAndVisible {
    %orig; [cite: 278]
    // فحص دوري كل 30 ثانية
    __weak typeof(self) weakWin = self; [cite: 279]
    [NSTimer scheduledTimerWithTimeInterval:30 repeats:YES block:^(NSTimer *t) {
        __strong typeof(weakWin) strongWin = weakWin; [cite: 280]
        if (!strongWin) return;
        if ([strongWin respondsToSelector:@selector(rdw_periodicCheck)]) {
            [(id)strongWin rdw_periodicCheck]; [cite: 281]
        }
    }];

    // إضافة إيماءة الضغط بـ 3 أصابع لمدة ثانيتين
    UILongPressGestureRecognizer *lp = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(rdw_p:)]; [cite: 282]
    lp.numberOfTouchesRequired = 3; lp.minimumPressDuration = 2.0; [self addGestureRecognizer:lp];

    // القفل الفوري عند التشغيل الأول أو عند عدم وجود مفاتيح
    NSArray *k = [[NSUserDefaults standardUserDefaults] objectForKey:@"RDW_KEYS"]; [cite: 283]
    if (!k || k.count == 0) {
        if ([self respondsToSelector:@selector(rdw_lock)]) {
            [(id)self rdw_lock]; [cite: 284]
        }
    }
}

%new
- (void)rdw_lock {
    UIViewController *top = [self topMostController]; [cite: 285]
    if (![top isKindOfClass:[RDWLoginVC class]]) {
        RDWLoginVC *vc = [[RDWLoginVC alloc] init]; [cite: 286]
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [top presentViewController:vc animated:YES completion:nil];
    }
}

%new
- (void)rdw_p:(UILongPressGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateBegan) {
        if ([self viewWithTag:888]) return; [cite: 287]
        RDWPanel *p = [[RDWPanel alloc] initWithFrame:CGRectMake((self.frame.size.width-300)/2, 120, 300, 240)];
        p.alpha = 0.0; p.transform = CGAffineTransformMakeScale(0.8, 0.8);
        [self addSubview:p]; [cite: 288]
        [UIView animateWithDuration:0.28 animations:^{ p.alpha = 1.0; p.transform = CGAffineTransformIdentity; }]; [cite: 289]
    }
}

%new
- (void)rdw_periodicCheck {
    NSString *udid = [RDWCore myID];
    NSString *userURL = [NSString stringWithFormat:@"%@/%@.json", RDW_USERS, udid]; [cite: 290]
    __weak typeof(self) weakSelf = self;
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:userURL] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        __strong typeof(weakSelf) strongSelf = weakSelf; [cite: 291]
        if (!strongSelf) return;
        __block BOOL shouldLock = NO;
        double now = [[NSDate date] timeIntervalSince1970]; [cite: 292]
        if (d) {
            NSDictionary *j = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil]; [cite: 293]
            if (!j || [j isEqual:[NSNull null]] || !j[@"expiry"]) {
                shouldLock = YES; [cite: 294]
            } else {
                double expiry = [j[@"expiry"] doubleValue]; [cite: 295]
                if (expiry < now) shouldLock = YES;
            }
        }
        
        NSString *codesURL = [NSString stringWithFormat:@"%@.json", RDW_URL]; [cite: 296]
        [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:codesURL] completionHandler:^(NSData *d2, NSURLResponse *r2, NSError *e2) {
            __strong typeof(weakSelf) strongSelf2 = weakSelf; [cite: 297]
            if (!strongSelf2) return;
            if (d2) {
                NSDictionary *all = [NSJSONSerialization JSONObjectWithData:d2 options:0 error:nil]; [cite: 298]
                BOOL hasValid = NO;
                for (NSString *key in all) {
                    NSDictionary *c = all[key]; [cite: 299]
                    if (![c isKindOfClass:[NSDictionary class]]) continue;
                    NSString *usedBy = c[@"usedBy"] ?: @"";
                    double cexp = [c[@"expiry"] doubleValue]; [cite: 300]
                    if ([usedBy isEqualToString:udid] && cexp > now) { hasValid = YES; break; } [cite: 301]
                }
                if (!hasValid) shouldLock = YES; [cite: 302]
            }
            if (shouldLock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"RDW_KEYS"]; [cite: 303]
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    if ([strongSelf2 respondsToSelector:@selector(rdw_lock)]) {
                        [(id)strongSelf2 rdw_lock];
                    } [cite: 304]
                });
            }
        }] resume];
    }] resume]; [cite: 305]
}

%end

// --- فئة مساعدة لـ UIWindow ---
@implementation UIWindow (RDWUtils)

- (UIViewController *)topMostController {
    UIWindow *keyWindow = nil;
    if (@available(iOS 13.0, *)) { [cite: 306]
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *ws = (UIWindowScene *)scene;
                for (UIWindow *w in ws.windows) { [cite: 307]
                    if (w.isKeyWindow) { keyWindow = w; break; } [cite: 308]
                }
                if (keyWindow) break;
            } [cite: 309]
        }
    }
    if (!keyWindow) {
        keyWindow = [UIApplication sharedApplication].delegate.window ?: [UIApplication sharedApplication].windows.firstObject;
    } [cite: 310]
    UIViewController *top = keyWindow.rootViewController;
    while (top.presentedViewController) top = top.presentedViewController;
    return top;
}

@end
