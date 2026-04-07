#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>

// --- روابط متجر RDW ---
static NSString *const RDW_URL   = @"https://rdw-server-default-rtdb.firebaseio.com/codes";
static NSString *const RDW_USERS = @"https://rdw-server-default-rtdb.firebaseio.com/users";

// الروابط المحدثة بالرسائل المطلوبة
static NSString *const RDW_WA_BUY = @"https://wa.me/972567171874?text=%D9%87%D9%84%20%D9%8A%D9%85%D9%83%D9%86%D9%86%D9%8A%20%D8%B4%D8%B1%D8%A7%D8%A1%20%D9%83%D9%88%D8%AF%20%D8%AA%D9%81%D8%B9%D9%8A%D9%84%20RDW%20%D9%84%D9%88%20%D8%B3%D9%85%D8%AD%D8%AA%20%D8%9F";
static NSString *const RDW_WA_SUPPORT = @"https://wa.me/972567171874?text=%D9%84%D9%82%D8%AF%20%D9%88%D8%A7%D8%AC%D9%87%D8%AA%20%D9%85%D8%B4%D9%83%D9%84%D8%A9%2C%20%D9%87%D9%84%20%D9%8A%D9%85%D9%83%D9%86%D9%83%20%D9%85%D8%B3%D8%A7%D8%B1%D8%B9%D8%AF%D8%AA%D9%8A%20%D8%9F";
static NSString *const RDW_IG    = @"https://www.instagram.com/rimawi.dw";

#define RDW_GOLD [UIColor colorWithRed:0.72 green:0.56 blue:0.17 alpha:1.0]

// --- Helpers ---
@interface RDWCore : NSObject
+ (NSString *)myID;
+ (void)vibe:(BOOL)impact;
+ (void)playSoundNamed:(NSString *)name;
+ (NSString *)dateToStr:(NSDate *)d;
+ (NSDate *)strToDate:(NSString *)s;
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
+ (NSString *)dateToStr:(NSDate *)d {
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [f stringFromDate:d];
}
+ (NSDate *)strToDate:(NSString *)s {
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [f dateFromString:s];
}
@end

// --- Lock Screen VC ---
@interface RDWLoginVC : UIViewController
@property (nonatomic, retain) UITextField *inputField;
@property (nonatomic, retain) UILabel *msgL;
@property (nonatomic, retain) UIView *box;
@end

@implementation RDWLoginVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *bv = [[UIVisualEffectView alloc] initWithEffect:blur];
    bv.frame = self.view.bounds; 
    bv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:bv];
    
    CGFloat w = MIN(self.view.frame.size.width - 40, 340);
    self.box = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-w)/2, (self.view.frame.size.height-560)/2, w, 560)];
    self.box.backgroundColor = [UIColor colorWithWhite:0.02 alpha:0.95];
    self.box.layer.cornerRadius = 28; 
    self.box.layer.borderColor = RDW_GOLD.CGColor; 
    self.box.layer.borderWidth = 1.5;
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
    [btn1 setBackgroundColor:RDW_GOLD]; [btn1 setTitleColor:[UIColor whiteColor] forState:0]; btn1.layer.cornerRadius = 14; 
    [btn1 addTarget:self action:@selector(goCheck) forControlEvents:UIControlEventTouchUpInside];
    [self.box addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn2.frame = CGRectMake(20, 410, w-40, 50); [btn2 setTitle:@"شراء كود تفعيل" forState:0];
    [btn2 setBackgroundColor:[UIColor colorWithRed:0.1 green:0.5 blue:0.2 alpha:1]]; [btn2 setTitleColor:[UIColor whiteColor] forState:0];
    btn2.layer.cornerRadius = 14; [btn2 addTarget:self action:@selector(goWA) forControlEvents:UIControlEventTouchUpInside];
    [self.box addSubview:btn2];
    
    UILabel *dev = [[UILabel alloc] initWithFrame:CGRectMake(0, self.box.frame.size.height-30, w, 20)];
    dev.text = @"تم التطوير بواسطة كمال"; dev.textColor = [UIColor grayColor]; dev.textAlignment = NSTextAlignmentCenter; dev.font = [UIFont systemFontOfSize:11];
    [self.box addSubview:dev];
}

- (void)goCheck {
    NSString *code = [self.inputField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (code.length < 4) { [self showError:@"مفتاح خاطئ وغير صالح!"]; return; }
    NSString *urlS = [NSString stringWithFormat:@"%@/%@.json", RDW_URL, code];
    __weak typeof(self) weakSelf = self;
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlS] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!d) { [weakSelf showError:@"خطأ في الاتصال"]; return; }
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (!json || [json isEqual:[NSNull null]]) { [weakSelf showError:@"الكود غير موجود!"]; return; }
            NSString *uBy = json[@"usedBy"] ?: @"", *myU = [RDWCore myID];
            if ([uBy isEqualToString:@""]) [weakSelf activateAndStackCode:code];
            else if ([uBy isEqualToString:myU]) [weakSelf finalizeActivationForCode:code];
            else [weakSelf showError:@"هذا المفتاح مستخدم على جهاز آخر!"];
        });
    }] resume];
}

- (void)activateAndStackCode:(NSString *)code {
    NSString *myU = [RDWCore myID];
    NSDate *codeExp = [[NSDate date] dateByAddingTimeInterval:30*24*3600];
    NSDictionary *p = @{@"usedBy": myU, @"expire_date": [RDWCore dateToStr:codeExp]};
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json", RDW_URL, code]]];
    [req setHTTPMethod:@"PATCH"]; [req setHTTPBody:[NSJSONSerialization dataWithJSONObject:p options:0 error:nil]];
    __weak typeof(self) weakSelf = self;
    [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        [weakSelf addDaysToUser:30 completion:^(BOOL ok) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (ok) [weakSelf finalizeActivationForCode:code];
                else [weakSelf showError:@"خطأ أثناء تفعيل الكود"];
            });
        }];
    }] resume];
}

- (void)addDaysToUser:(int)days completion:(void(^)(BOOL ok))completion {
    NSString *userURL = [NSString stringWithFormat:@"%@/%@.json", RDW_USERS, [RDWCore myID]];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:userURL] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        NSDate *newExp = [[NSDate date] dateByAddingTimeInterval:days * 24 * 3600];
        if (d) {
            NSDictionary *j = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (j && ![j isEqual:[NSNull null]]) {
                NSDate *curDate = nil;
                if (j[@"expire_date"]) curDate = [RDWCore strToDate:j[@"expire_date"]];
                else if (j[@"expiry"]) curDate = [NSDate dateWithTimeIntervalSince1970:[j[@"expiry"] doubleValue]];
                if (curDate && [curDate timeIntervalSinceNow] > 0) newExp = [curDate dateByAddingTimeInterval:days * 24 * 3600];
            }
        }
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:userURL]];
        [req setHTTPMethod:@"PATCH"]; [req setHTTPBody:[NSJSONSerialization dataWithJSONObject:@{@"expire_date": [RDWCore dateToStr:newExp]} options:0 error:nil]];
        [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *d2, NSURLResponse *r2, NSError *e2) {
            if (completion) completion(e2==nil);
        }] resume];
    }] resume];
}

- (void)finalizeActivationForCode:(NSString *)code {
    NSMutableArray *arr = [[[NSUserDefaults standardUserDefaults] objectForKey:@"RDW_KEYS"] mutableCopy] ?: [NSMutableArray array];
    if (![arr containsObject:code]) [arr addObject:code];
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"RDW_KEYS"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [RDWCore vibe:YES]; [RDWCore playSoundNamed:@"success"];
    UIAlertController *a = [UIAlertController alertControllerWithTitle:@"✅ تم التفعيل" message:@"أهلاً بك في Rimawi Digital World" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:a animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.2*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [a dismissViewControllerAnimated:YES completion:^{ [self dismissViewControllerAnimated:YES completion:nil]; }];
        });
    }];
}

- (void)showError:(NSString *)msg {
    self.msgL.text = msg; [RDWCore vibe:NO]; [RDWCore playSoundNamed:@"error"];
    [UIView animateWithDuration:0.12 animations:^{ self.box.backgroundColor = [UIColor colorWithRed:0.35 green:0.05 blue:0.05 alpha:0.95]; } completion:^(BOOL fin){
        [UIView animateWithDuration:0.25 animations:^{ self.box.backgroundColor = [UIColor colorWithWhite:0.02 alpha:0.95]; }];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RDW_IG] options:@{} completionHandler:nil];
    });
}

- (void)goWA { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RDW_WA_BUY] options:@{} completionHandler:nil]; }
@end

// --- Panel (3-finger) ---
@interface RDWPanel : UIView
@property (nonatomic, retain) UILabel *lbl;
@property (nonatomic, retain) UITextField *fld;
@property (nonatomic, retain) UIButton *extendBtn, *supportBtn;
- (void)refresh;
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
        self.fld.placeholder = @"أدخل كود تمديد جديد"; self.fld.backgroundColor = [UIColor colorWithWhite:1 alpha:0.06];
        self.fld.textAlignment = NSTextAlignmentCenter; self.fld.layer.cornerRadius = 10; self.fld.textColor = [UIColor whiteColor];
        [self addSubview:self.fld];
        self.extendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.extendBtn.frame = CGRectMake((frame.size.width-160)/2, 134, 160, 44);
        [self.extendBtn setTitle:@"تمديد الاشتراك" forState:0]; [self.extendBtn setBackgroundColor:RDW_GOLD];
        [self.extendBtn setTitleColor:[UIColor whiteColor] forState:0]; self.extendBtn.layer.cornerRadius = 10;
        [self.extendBtn addTarget:self action:@selector(stack) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.extendBtn];
        self.supportBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.supportBtn.frame = CGRectMake((frame.size.width-160)/2, 188, 160, 40);
        [self.supportBtn setTitle:@"الدعم الفني" forState:0]; [self.supportBtn setBackgroundColor:[UIColor colorWithRed:0.12 green:0.45 blue:0.9 alpha:1]];
        [self.supportBtn setTitleColor:[UIColor whiteColor] forState:0]; self.supportBtn.layer.cornerRadius = 10;
        [self.supportBtn addTarget:self action:@selector(openSupport) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.supportBtn];
        [self refresh];
    }
    return self;
}
- (void)refresh {
    NSString *userURL = [NSString stringWithFormat:@"%@/%@.json", RDW_USERS, [RDWCore myID]];
    __weak typeof(self) weakSelf = self;
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:userURL] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        int days = 0;
        if (d) {
            NSDictionary *j = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (j && ![j isEqual:[NSNull null]]) {
                NSDate *expD = nil;
                if (j[@"expire_date"]) expD = [RDWCore strToDate:j[@"expire_date"]];
                else if (j[@"expiry"]) expD = [NSDate dateWithTimeIntervalSince1970:[j[@"expiry"] doubleValue]];
                if (expD) days = (int)ceil([expD timeIntervalSinceNow] / 86400.0);
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *k = [[[NSUserDefaults standardUserDefaults] objectForKey:@"RDW_KEYS"] firstObject] ?: @"-";
            weakSelf.lbl.text = [NSString stringWithFormat:@"كودك: %@\nمتبقي: %d يوم", k, MAX(0, days)];
        });
    }] resume];
}
- (void)stack {
    NSString *code = [self.fld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (code.length < 4) { [self showLocalError:@"مفتاح غير صالح"]; return; }
    __weak typeof(self) weakSelf = self;
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json", RDW_URL, code]] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!d) { [weakSelf showLocalError:@"خطأ اتصال"]; return; }
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (!json || [json isEqual:[NSNull null]]) { [weakSelf showLocalError:@"غير موجود"]; return; }
            NSString *uBy = json[@"usedBy"] ?: @"", *myU = [RDWCore myID];
            
            if ([uBy isEqualToString:@""]) { // يضيف الأيام فقط إذا كان الكود جديد تماماً
                NSDate *codeExp = [[NSDate date] dateByAddingTimeInterval:30*24*3600];
                NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json", RDW_URL, code]]];
                [req setHTTPMethod:@"PATCH"]; [req setHTTPBody:[NSJSONSerialization dataWithJSONObject:@{@"usedBy":myU, @"expire_date":[RDWCore dateToStr:codeExp]} options:0 error:nil]];
                [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *d2, NSURLResponse *r2, NSError *e2) {
                    [weakSelf addDaysToUser:30 completion:^(BOOL ok) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (ok) {
                                [weakSelf showLocalSuccess:@"تمت إضافة 30 يوم بنجاح"];
                                NSMutableArray *arr = [[[NSUserDefaults standardUserDefaults] objectForKey:@"RDW_KEYS"] mutableCopy] ?: [NSMutableArray array];
                                if (![arr containsObject:code]) [arr addObject:code];
                                [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"RDW_KEYS"];
                                [[NSUserDefaults standardUserDefaults] synchronize]; [weakSelf refresh];
                            }
                        });
                    }];
                }] resume];
            } else if ([uBy isEqualToString:myU]) {
                [weakSelf showLocalError:@"لقد استخدمت هذا الكود مسبقاً!"]; // منع التكرار
            } else {
                [weakSelf showLocalError:@"مستخدم على جهاز آخر!"];
            }
        });
    }] resume];
}
- (void)addDaysToUser:(int)days completion:(void(^)(BOOL ok))completion {
    NSString *userURL = [NSString stringWithFormat:@"%@/%@.json", RDW_USERS, [RDWCore myID]];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:userURL] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        NSDate *newE = [[NSDate date] dateByAddingTimeInterval:days * 24 * 3600];
        if (d) {
            NSDictionary *j = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (j && ![j isEqual:[NSNull null]]) {
                NSDate *curDate = nil;
                if (j[@"expire_date"]) curDate = [RDWCore strToDate:j[@"expire_date"]];
                else if (j[@"expiry"]) curDate = [NSDate dateWithTimeIntervalSince1970:[j[@"expiry"] doubleValue]];
                if (curDate && [curDate timeIntervalSinceNow] > 0) newE = [curDate dateByAddingTimeInterval:days * 24 * 3600];
            }
        }
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:userURL]];
        [req setHTTPMethod:@"PATCH"]; [req setHTTPBody:[NSJSONSerialization dataWithJSONObject:@{@"expire_date":[RDWCore dateToStr:newE]} options:0 error:nil]];
        [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *d2, NSURLResponse *r2, NSError *e2) {
            if (completion) completion(e2==nil);
        }] resume];
    }] resume];
}

- (void)openSupport { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RDW_WA_SUPPORT] options:@{} completionHandler:nil]; }

- (void)showLocalError:(NSString *)m {
    [RDWCore vibe:NO]; [RDWCore playSoundNamed:@"error"];
    UIAlertController *a = [UIAlertController alertControllerWithTitle:@"خطأ" message:m preferredStyle:UIAlertControllerStyleAlert];
    [a addAction:[UIAlertAction actionWithTitle:@"حسناً" style:UIAlertActionStyleDefault handler:nil]];
    [[self topMostController] presentViewController:a animated:YES completion:nil];
}
- (void)showLocalSuccess:(NSString *)m {
    [RDWCore vibe:YES]; [RDWCore playSoundNamed:@"success"];
    UIAlertController *a = [UIAlertController alertControllerWithTitle:@"نجاح" message:m preferredStyle:UIAlertControllerStyleAlert];
    [a addAction:[UIAlertAction actionWithTitle:@"حسناً" style:UIAlertActionStyleDefault handler:nil]];
    [[self topMostController] presentViewController:a animated:YES completion:nil];
}
- (UIViewController *)topMostController {
    UIWindow *kw = nil;
    if (@available(iOS 13.0, *)) {
        for (UIScene *s in [UIApplication sharedApplication].connectedScenes) {
            if (s.activationState == UISceneActivationStateForegroundActive && [s isKindOfClass:[UIWindowScene class]]) {
                for (UIWindow *w in ((UIWindowScene *)s).windows) { if (w.isKeyWindow) { kw = w; break; } }
            }
        }
    }
    if (!kw) kw = [UIApplication sharedApplication].delegate.window ?: [UIApplication sharedApplication].windows.firstObject;
    UIViewController *top = kw.rootViewController;
    while (top.presentedViewController) top = top.presentedViewController;
    return top;
}
@end

// --- UIWindow Hooks ---
%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        [NSTimer scheduledTimerWithTimeInterval:30 repeats:YES block:^(NSTimer *t) {
            if ([self respondsToSelector:@selector(rdw_periodicCheck)]) [self performSelector:@selector(rdw_periodicCheck)];
        }];
        UILongPressGestureRecognizer *lp = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(rdw_p:)];
        lp.numberOfTouchesRequired = 3; lp.minimumPressDuration = 2.0; [self addGestureRecognizer:lp];
        NSArray *k = [[NSUserDefaults standardUserDefaults] objectForKey:@"RDW_KEYS"];
        if (!k || k.count == 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                if ([self respondsToSelector:@selector(rdw_lock)]) [self performSelector:@selector(rdw_lock)];
            });
        }
    });
}
%new
- (void)rdw_lock {
    UIViewController *top = [self performSelector:@selector(topMostController)];
    if (![top isKindOfClass:[RDWLoginVC class]]) {
        RDWLoginVC *vc = [[RDWLoginVC alloc] init];
        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [top presentViewController:vc animated:YES completion:nil];
    }
}
%new
- (void)rdw_p:(UILongPressGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateBegan) {
        if ([self viewWithTag:888]) { [[self viewWithTag:888] removeFromSuperview]; return; }
        RDWPanel *p = [[RDWPanel alloc] initWithFrame:CGRectMake((self.frame.size.width-300)/2, 120, 300, 240)];
        p.alpha = 0; p.transform = CGAffineTransformMakeScale(0.8, 0.8); [self addSubview:p];
        [UIView animateWithDuration:0.28 animations:^{ p.alpha = 1; p.transform = CGAffineTransformIdentity; }];
    }
}
%new
- (void)rdw_periodicCheck {
    NSString *udid = [RDWCore myID];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json", RDW_USERS, udid]] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        __block BOOL lock = NO;
        if (d) {
            NSDictionary *j = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (!j || [j isEqual:[NSNull null]]) { lock = YES; }
            else {
                NSDate *expD = nil;
                if (j[@"expire_date"]) expD = [RDWCore strToDate:j[@"expire_date"]];
                else if (j[@"expiry"]) expD = [NSDate dateWithTimeIntervalSince1970:[j[@"expiry"] doubleValue]];
                if (!expD || [expD timeIntervalSinceNow] < 0) lock = YES;
            }
        }
        if (lock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"RDW_KEYS"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if ([self respondsToSelector:@selector(rdw_lock)]) [self performSelector:@selector(rdw_lock)];
            });
        }
    }] resume];
}
%new
- (UIViewController *)topMostController {
    UIWindow *kw = nil;
    if (@available(iOS 13.0, *)) {
        for (UIScene *s in [UIApplication sharedApplication].connectedScenes) {
            if (s.activationState == UISceneActivationStateForegroundActive && [s isKindOfClass:[UIWindowScene class]]) {
                for (UIWindow *w in ((UIWindowScene *)s).windows) { if (w.isKeyWindow) { kw = w; break; } }
            }
        }
    }
    if (!kw) kw = [UIApplication sharedApplication].delegate.window ?: [UIApplication sharedApplication].windows.firstObject;
    UIViewController *top = kw.rootViewController;
    while (top.presentedViewController) top = top.presentedViewController;
    return top;
}
%end
