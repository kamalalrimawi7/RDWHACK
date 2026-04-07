#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>

// --- تعريفات الواجهة لمنع أخطاء المترجم (Forward Declarations) ---
@interface UIWindow (RDW)
- (void)rdw_lockNow;
- (void)rdw_periodicCheck;
- (UIViewController *)rdw_topVC;
- (void)rdw_handleP:(UILongPressGestureRecognizer *)g;
@end

// --- روابط وثوابت متجر RDW ---
static NSString *const RDW_URL    = @"https://rdw-server-default-rtdb.firebaseio.com/codes";
static NSString *const RDW_USERS  = @"https://rdw-server-default-rtdb.firebaseio.com/users"; [cite: 3]

static NSString *const RDW_WA_BUY = @"https://wa.me/972567171874?text=%D9%87%D9%84%20%D9%8A%D9%85%D9%83%D9%86%D9%86%D9%8A%20%D8%B4%D8%B1%D8%A7%D8%A1%20%D9%83%D9%88%D8%AF%20%D8%AA%D9%81%D8%B9%D9%8A%D9%84%20RDW%20%D9%84%D9%88%20%D8%B3%D9%85%D8%AD%D8%AA%20%D8%9F";
static NSString *const RDW_WA_SUPPORT = @"https://wa.me/972567171874?text=%D9%84%D9%82%D8%AF%20%D9%88%D8%A7%D8%AC%D9%87%D8%AA%20%D9%85%D8%B4%D9%83%D9%84%D8%A9%D8%8C%20%D9%87%D9%84%20%D9%8A%D9%85%D9%83%D9%86%D9%83%20%D9%85%D8%B3%D8%A7%D8%B9%D8%AF%D8%AA%D9%8A%D8%9F";
static NSString *const RDW_IG    = @"https://www.instagram.com/rimawi.dw"; [cite: 4]

#define RDW_GOLD [UIColor colorWithRed:0.72 green:0.56 blue:0.17 alpha:1.0]

// --- Helper Class ---
@interface RDWCore : NSObject
+ (NSString *)myID;
+ (NSString *)getAppName;
+ (NSString *)getAppBundleID;
+ (void)vibe:(BOOL)impact;
+ (void)playSoundNamed:(NSString *)name;
+ (NSString *)dateToStr:(NSDate *)d;
+ (NSDate *)strToDate:(NSString *)s;
@end [cite: 6]

@implementation RDWCore
+ (NSString *)myID {
    NSString *stored = [[NSUserDefaults standardUserDefaults] stringForKey:@"RDW_UDID"];
    if (!stored) { [cite: 7]
        NSString *newId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        if (!newId) newId = [[NSUUID UUID] UUIDString]; [cite: 8]
        [[NSUserDefaults standardUserDefaults] setObject:newId forKey:@"RDW_UDID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        stored = newId;
    } [cite: 9]
    return stored;
}
+ (NSString *)getAppName {
    NSString *name = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    if (!name) name = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]; [cite: 10]
    return name ?: @"Unknown App";
} [cite: 11]
+ (NSString *)getAppBundleID {
    return [[NSBundle mainBundle] bundleIdentifier] ?: @"unknown.bundle.id";
} [cite: 12]
+ (void)vibe:(BOOL)impact {
    if (impact) {
        UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        [gen impactOccurred]; [cite: 13]
    } else {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    } [cite: 14]
}
+ (void)playSoundNamed:(NSString *)name {
    if ([name isEqualToString:@"success"]) AudioServicesPlaySystemSound(1057);
    else if ([name isEqualToString:@"error"]) AudioServicesPlaySystemSound(1053);
    else AudioServicesPlaySystemSound(1104);
} [cite: 15]
+ (NSString *)dateToStr:(NSDate *)d {
    if (!d) return @"";
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; [cite: 16]
    [f setTimeZone:[NSTimeZone localTimeZone]];
    return [f stringFromDate:d];
}
+ (NSDate *)strToDate:(NSString *)s {
    if (!s || [s isKindOfClass:[NSNull class]] || s.length < 5) return nil;
    NSDateFormatter *f = [[NSDateFormatter alloc] init]; [cite: 17]
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [f setTimeZone:[NSTimeZone localTimeZone]];
    return [f dateFromString:s];
} [cite: 18]
@end

// --- شاشة القفل والتفعيل (Login VC) ---
@interface RDWLoginVC : UIViewController <UITextFieldDelegate>
@property (nonatomic, retain) UITextField *inputField;
@property (nonatomic, retain) UITextField *fullNameField; [cite: 19]
@property (nonatomic, retain) UILabel *msgL;
@property (nonatomic, retain) UIView *box;
@property (nonatomic, retain) UIActivityIndicatorView *loader;
@end [cite: 20]

@implementation RDWLoginVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor]; [cite: 21]
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *bv = [[UIVisualEffectView alloc] initWithEffect:blur];
    bv.frame = self.view.bounds;
    bv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; [cite: 22]
    [self.view addSubview:bv];
    
    CGFloat w = MIN(self.view.frame.size.width - 40, 340);
    self.box = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-w)/2, (self.view.frame.size.height-600)/2, w, 580)]; [cite: 23]
    self.box.backgroundColor = [UIColor colorWithWhite:0.05 alpha:0.85];
    self.box.layer.cornerRadius = 35; 
    self.box.layer.borderColor = RDW_GOLD.CGColor;
    self.box.layer.borderWidth = 2.0; [cite: 24]
    [self.view addSubview:self.box];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((w-110)/2, 30, 110, 110)];
    img.layer.cornerRadius = 55; img.layer.borderWidth = 2; img.layer.borderColor = RDW_GOLD.CGColor; [cite: 25]
    img.clipsToBounds = YES;
    img.backgroundColor = [UIColor blackColor];
    img.contentMode = UIViewContentModeScaleAspectFill;
    [self.box addSubview:img]; [cite: 26]
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://i.ibb.co/7xZ41GWF/IMG-3601.jpg"] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        if (d) dispatch_async(dispatch_get_main_queue(), ^{ img.image = [UIImage imageWithData:d]; });
    }] resume]; [cite: 27]
    
    UILabel *t1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, w, 30)];
    t1.text = @"Rimawi Digital World"; t1.textColor = RDW_GOLD;
    t1.textAlignment = NSTextAlignmentCenter; t1.font = [UIFont boldSystemFontOfSize:22]; [cite: 28]
    [self.box addSubview:t1];
    
    self.msgL = [[UILabel alloc] initWithFrame:CGRectMake(20, 185, w-40, 25)];
    self.msgL.textColor = [UIColor systemRedColor]; self.msgL.textAlignment = NSTextAlignmentCenter; self.msgL.font = [UIFont systemFontOfSize:12]; [cite: 29]
    [self.box addSubview:self.msgL];
    self.fullNameField = [[UITextField alloc] initWithFrame:CGRectMake(20, 220, w-40, 50)]; [cite: 30]
    self.fullNameField.placeholder = @"أدخل اسمك الرباعي هنا"; self.fullNameField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    self.fullNameField.textColor = [UIColor whiteColor]; self.fullNameField.textAlignment = NSTextAlignmentCenter; self.fullNameField.layer.cornerRadius = 15; [cite: 31]
    [self.box addSubview:self.fullNameField];

    self.inputField = [[UITextField alloc] initWithFrame:CGRectMake(20, 280, w-40, 50)];
    self.inputField.placeholder = @"أدخل كود التفعيل"; self.inputField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1]; [cite: 32]
    self.inputField.textColor = [UIColor whiteColor]; self.inputField.textAlignment = NSTextAlignmentCenter; self.inputField.layer.cornerRadius = 15;
    self.inputField.autocapitalizationType = UITextAutocapitalizationTypeNone; [cite: 33]
    [self.box addSubview:self.inputField];
    
    if (@available(iOS 13.0, *)) {
        self.loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    } else { [cite: 34]
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        self.loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
#pragma clang diagnostic pop [cite: 35]
    }
    self.loader.center = CGPointMake(w/2, 310);
    [self.box addSubview:self.loader];
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem]; [cite: 36]
    btn1.frame = CGRectMake(20, 350, w-40, 55); [btn1 setTitle:@"تفعيل النسخة" forState:0];
    [btn1 setBackgroundColor:RDW_GOLD];
    [btn1 setTitleColor:[UIColor whiteColor] forState:0]; btn1.layer.cornerRadius = 15; [cite: 37]
    [btn1 addTarget:self action:@selector(goCheck) forControlEvents:UIControlEventTouchUpInside];
    [self.box addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn2.frame = CGRectMake(20, 420, w-40, 50); [cite: 38]
    [btn2 setTitle:@"شراء كود جديد" forState:0];
    [btn2 setBackgroundColor:[UIColor colorWithRed:0.1 green:0.6 blue:0.2 alpha:1]];
    [btn2 setTitleColor:[UIColor whiteColor] forState:0]; [cite: 39]
    btn2.layer.cornerRadius = 15;
    [btn2 addTarget:self action:@selector(goWA) forControlEvents:UIControlEventTouchUpInside];
    [self.box addSubview:btn2];
    UILabel *dev = [[UILabel alloc] initWithFrame:CGRectMake(0, self.box.frame.size.height-35, w, 20)]; [cite: 40]
    dev.text = @"Developed by Kamal - RDW Store";
    dev.textColor = [UIColor darkGrayColor]; dev.textAlignment = NSTextAlignmentCenter; dev.font = [UIFont systemFontOfSize:10]; [cite: 41]
    [self.box addSubview:dev];
} [cite: 42]

- (void)goCheck {
    [self.view endEditing:YES];
    NSString *code = [self.inputField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *name = [self.fullNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (name.length < 8) { [self showError:@"يرجى كتابة اسمك الرباعي!"]; return; [cite: 43]
    } [cite: 44]
    if (code.length < 4) { [self showError:@"الكود غير صالح!"]; return; [cite: 45]
    }
    
    [self.loader startAnimating];
    NSString *urlS = [NSString stringWithFormat:@"%@/%@.json", RDW_URL, code];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlS] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) { [cite: 46]
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loader stopAnimating];
            if (!d) { [self showError:@"فشل الاتصال بالسيرفر"]; return; }
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (!json || [json isEqual:[NSNull null]]) { [self showError:@"هذا الكود غير موجود!"]; return; }
     
            NSString *targetApp = json[@"target_app"]; [cite: 47]
            if (targetApp && targetApp.length > 0 && ![targetApp isEqualToString:[RDWCore getAppBundleID]]) {
                [self showError:@"هذا الكود غير مخصص لهذا التطبيق!"];
                return;
            }

            NSString *uBy = json[@"usedBy"] ?: @"", *myU = [RDWCore myID]; [cite: 48]
            if ([uBy isEqualToString:myU]) {
                [self showError:@"لقد استخدمت هذا الكود مسبقاً!"];
            } else if ([uBy isEqualToString:@""]) {
                [self registerCodeToServer:code name:name];
            } else { [cite: 49]
                [self showError:@"هذا الكود مستخدم من جهاز آخر!"];
            } [cite: 50]
        });
    }] resume];
} [cite: 51]

- (void)registerCodeToServer:(NSString *)code name:(NSString *)name {
    NSString *myU = [RDWCore myID];
    NSDate *expire = [[NSDate date] dateByAddingTimeInterval:30*24*3600];
    NSDictionary *p = @{@"usedBy": myU, @"expire_date": [RDWCore dateToStr:expire], @"registered_name": name}; [cite: 52]
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json", RDW_URL, code]]];
    [req setHTTPMethod:@"PATCH"]; [req setHTTPBody:[NSJSONSerialization dataWithJSONObject:p options:0 error:nil]]; [cite: 53]
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        [self syncUserWithDays:30 name:name code:code completion:^(BOOL ok) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (ok) [self finalizeSuccess:code];
                else [self showError:@"حدث خطأ في المزامنة"];
            });
        }]; [cite: 54]
    }] resume];
}

- (void)syncUserWithDays:(int)days name:(NSString *)name code:(NSString *)code completion:(void(^)(BOOL ok))completion {
    NSString *userPath = [NSString stringWithFormat:@"%@/%@.json", RDW_USERS, [RDWCore myID]];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:userPath] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) { [cite: 55]
        NSDate *now = [NSDate date];
        NSDate *targetExp = [now dateByAddingTimeInterval:days * 24 * 3600]; [cite: 56]
        if (d) {
            NSDictionary *j = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (j && ![j isEqual:[NSNull null]] && j[@"expire_date"]) { [cite: 57]
                NSDate *oldExp = [RDWCore strToDate:j[@"expire_date"]];
                if (oldExp && [oldExp timeIntervalSinceDate:now] > 0) { [cite: 58]
                    targetExp = [oldExp dateByAddingTimeInterval:days * 24 * 3600];
                } [cite: 59]
            }
        }
        NSDictionary *update = @{
            @"full_name": name,
            @"app_name": [RDWCore getAppName],
            @"app_id": [RDWCore getAppBundleID],
            @"expire_date": [RDWCore dateToStr:targetExp],
            [NSString stringWithFormat:@"history/%@", 
            code]: [RDWCore dateToStr:now] [cite: 60]
        };
        NSMutableURLRequest *pReq = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:userPath]];
        [pReq setHTTPMethod:@"PATCH"];
        [pReq setHTTPBody:[NSJSONSerialization dataWithJSONObject:update options:0 error:nil]]; [cite: 61]
        [[[NSURLSession sharedSession] dataTaskWithRequest:pReq completionHandler:^(NSData *d2, NSURLResponse *r2, NSError *e2) {
            if (completion) completion(e2 == nil);
        }] resume]; [cite: 62]
    }] resume];
}

- (void)finalizeSuccess:(NSString *)code {
    NSMutableArray *k = [[[NSUserDefaults standardUserDefaults] objectForKey:@"RDW_KEYS"] mutableCopy] ?: [NSMutableArray array];
    if (![k containsObject:code]) [k addObject:code]; [cite: 63]
    [[NSUserDefaults standardUserDefaults] setObject:k forKey:@"RDW_KEYS"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [RDWCore vibe:YES]; [RDWCore playSoundNamed:@"success"];
    UIAlertController *a = [UIAlertController alertControllerWithTitle:@"✅ مبروك" message:@"تم تفعيل النسخة بنجاح في متجر RDW" preferredStyle:UIAlertControllerStyleAlert]; [cite: 64]
    [self presentViewController:a animated:YES completion:^{ [cite: 65]
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [a dismissViewControllerAnimated:YES completion:^{ [self dismissViewControllerAnimated:YES completion:nil]; }];
        });
    }]; [cite: 66]
}

- (void)showError:(NSString *)msg {
    self.msgL.text = msg; [RDWCore vibe:NO]; [RDWCore playSoundNamed:@"error"];
    [UIView animateWithDuration:0.1 animations:^{ self.box.backgroundColor = [UIColor colorWithRed:0.4 green:0.1 blue:0.1 alpha:0.8]; [cite: 67]
    } completion:^(BOOL f){ [cite: 68]
        [UIView animateWithDuration:0.3 animations:^{ self.box.backgroundColor = [UIColor colorWithWhite:0.05 alpha:0.85]; }];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0*NSEC_PER_SEC), dispatch_get_main_queue(), ^{ [cite: 69]
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RDW_IG] options:@{} completionHandler:nil];
    });
} [cite: 70]
- (void)goWA { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RDW_WA_BUY] options:@{} completionHandler:nil]; }
@end

// --- لوحة التحكم (RDW Panel) ---
@interface RDWPanel : UIView
@property (nonatomic, retain) UILabel *infoL;
@property (nonatomic, retain) UITextField *codeIn; [cite: 71]
@property (nonatomic, retain) UIButton *btnX, *btnS;
@property (nonatomic, retain) UIActivityIndicatorView *pLoader;
- (void)reloadData;
@end [cite: 72]

@implementation RDWPanel
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) { [cite: 73]
        self.backgroundColor = [UIColor colorWithWhite:0.04 alpha:0.9]; 
        self.layer.cornerRadius = 25;
        self.layer.borderColor = RDW_GOLD.CGColor; self.layer.borderWidth = 2.5; self.tag = 888; [cite: 74]
        
        self.infoL = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, frame.size.width-20, 80)];
        self.infoL.numberOfLines = 4;
        self.infoL.textColor = [UIColor whiteColor]; self.infoL.textAlignment = NSTextAlignmentCenter; [cite: 75]
        self.infoL.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
        [self addSubview:self.infoL];
        self.codeIn = [[UITextField alloc] initWithFrame:CGRectMake(20, 105, frame.size.width-40, 45)]; [cite: 76]
        self.codeIn.placeholder = @"أدخل كود التمديد هنا"; self.codeIn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
        self.codeIn.textAlignment = NSTextAlignmentCenter; self.codeIn.layer.cornerRadius = 12; self.codeIn.textColor = [UIColor whiteColor]; [cite: 77]
        [self addSubview:self.codeIn];
        if (@available(iOS 13.0, *)) { [cite: 78]
            self.pLoader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
        } else { [cite: 79]
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            self.pLoader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
#pragma clang diagnostic pop [cite: 80]
        }
        self.pLoader.center = CGPointMake(frame.size.width/2, 175);
        [self addSubview:self.pLoader]; [cite: 81]
        
        self.btnX = [UIButton buttonWithType:UIButtonTypeSystem];
        self.btnX.frame = CGRectMake(20, 160, frame.size.width-40, 45);
        [self.btnX setTitle:@"تجديد الاشتراك" forState:0];
        [self.btnX setBackgroundColor:RDW_GOLD];
        [self.btnX setTitleColor:[UIColor whiteColor] forState:0]; self.btnX.layer.cornerRadius = 12; [cite: 82]
        [self.btnX addTarget:self action:@selector(doStack) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnX];
        
        self.btnS = [UIButton buttonWithType:UIButtonTypeSystem];
        self.btnS.frame = CGRectMake(20, 215, frame.size.width-40, 40); [cite: 83]
        [self.btnS setTitle:@"الدعم الفني" forState:0];
        [self.btnS setBackgroundColor:[UIColor darkGrayColor]];
        [self.btnS setTitleColor:[UIColor whiteColor] forState:0];
        self.btnS.layer.cornerRadius = 12;
        [self.btnS addTarget:self action:@selector(goS) forControlEvents:UIControlEventTouchUpInside]; [cite: 84]
        [self addSubview:self.btnS];
        
        [self reloadData];
    }
    return self;
} [cite: 85]

- (void)reloadData {
    NSString *uPath = [NSString stringWithFormat:@"%@/%@.json", RDW_USERS, [RDWCore myID]];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:uPath] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) { [cite: 86]
        NSString *name = @"...", *app = [RDWCore getAppName];
        int dLeft = 0; [cite: 87]
        if (d) {
            NSDictionary *j = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (j && ![j isEqual:[NSNull null]]) { [cite: 88]
                name = j[@"full_name"] ?: @"بدون اسم";
                NSDate *exp = [RDWCore strToDate:j[@"expire_date"]]; [cite: 89]
                if (exp) dLeft = (int)ceil([exp timeIntervalSinceNow] / 86400.0);
            } [cite: 90]
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.infoL.text = [NSString stringWithFormat:@"👤 المستفيد: %@\n⏳ متبقي: %d يوم\n📱 التطبيق: %@\n🆔 ID: %@", name, MAX(0, dLeft), app, [RDWCore myID]];
            // التحقق إذا صفر الوقت لإظهار شاشة القفل فوراً
            if (d && dLeft <= 0) {
               
                  [self triggerLockScreen]; [cite: 91]
            }
        });
    }] resume]; [cite: 92]
}

- (void)triggerLockScreen {
    UIWindow *window = nil;
    if (@available(iOS 13.0, *)) { [cite: 93]
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                for (UIWindow *w in ((UIWindowScene *)scene).windows) { if (w.isKeyWindow) { window = w;
                break; } } [cite: 94]
            }
        }
    }
    if (!window) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        window = [UIApplication sharedApplication].keyWindow;
#pragma clang diagnostic pop [cite: 95]
    }
    if (!window) window = [UIApplication sharedApplication].windows.firstObject;
    [window rdw_lockNow];
} [cite: 96]

- (void)doStack {
    [self endEditing:YES];
    NSString *c = [self.codeIn.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (c.length < 4) { [cite: 97]
        [RDWCore vibe:NO]; self.codeIn.text = @"";
        self.codeIn.placeholder = @"يرجى ادخال رمز صالح"; return; [cite: 98]
    }
    [self.pLoader startAnimating];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json", RDW_URL, c]] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) { [cite: 99]
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pLoader stopAnimating];
            if (!d) return;
            NSDictionary *j = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (j && ![j isEqual:[NSNull null]]) {
               
                 NSString *targetApp = j[@"target_app"]; [cite: 100]
                if (targetApp && targetApp.length > 0 && ![targetApp isEqualToString:[RDWCore getAppBundleID]]) {
                    [RDWCore playSoundNamed:@"error"]; self.codeIn.text = @""; self.codeIn.placeholder = @"هذا الكود غير مخصص لهذا التطبيق!"; return;
                }
                
     
                NSString *uBy = j[@"usedBy"] ?: @"", *myU = [RDWCore myID]; [cite: 101]
                // الحماية المطلوبة: منع تكرار استخدام الكود لنفس الشخص
                if ([uBy isEqualToString:myU]) {
                     [RDWCore playSoundNamed:@"error"];
                    self.codeIn.text = @""; self.codeIn.placeholder = @"لقد استخدمت هذا الكود سابقا!"; [cite: 102]
                } else if ([uBy isEqualToString:@""]) { [cite: 103]
                     [self syncStack:c];
                } else { [cite: 104]
                     [RDWCore playSoundNamed:@"error"];
                    self.codeIn.placeholder = @"هذا الكود مستخدم من جهاز آخر!"; self.codeIn.text = @""; [cite: 105]
                } [cite: 106]
            } else { [RDWCore playSoundNamed:@"error"];
                self.codeIn.placeholder = @"كود غير صحيح!"; self.codeIn.text = @""; } [cite: 107]
        });
    }] resume];
} [cite: 108]

- (void)syncStack:(NSString *)c {
    NSDate *newExpDate = [[NSDate date] dateByAddingTimeInterval:30*24*3600];
    NSDictionary *p = @{@"usedBy": [RDWCore myID], @"expire_date": [RDWCore dateToStr:newExpDate]}; [cite: 109]
    NSMutableURLRequest *re = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json", RDW_URL, c]]];
    [re setHTTPMethod:@"PATCH"];
    [re setHTTPBody:[NSJSONSerialization dataWithJSONObject:p options:0 error:nil]]; [cite: 110]
    [[[NSURLSession sharedSession] dataTaskWithRequest:re completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        [self addDays:30 code:c];
    }] resume]; [cite: 111]
}

- (void)addDays:(int)days code:(NSString *)c {
    NSString *uPath = [NSString stringWithFormat:@"%@/%@.json", RDW_USERS, [RDWCore myID]];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:uPath] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) { [cite: 112]
        NSDate *now = [NSDate date];
        NSDate *finalExp = [now dateByAddingTimeInterval:days*24*3600]; [cite: 113]
        if (d) {
            NSDictionary *j = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (j && ![j isEqual:[NSNull null]]) { [cite: 114]
                NSDate *old = [RDWCore strToDate:j[@"expire_date"]];
                if (old && [old timeIntervalSinceDate:now] > 0) finalExp = [old dateByAddingTimeInterval:days*24*3600]; [cite: 115]
            } [cite: 116]
        }
        NSDictionary *up = @{ @"expire_date": [RDWCore dateToStr:finalExp], [NSString stringWithFormat:@"history/%@", c]: [RDWCore dateToStr:now] };
        NSMutableURLRequest *re = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:uPath]]; [cite: 117]
        [re setHTTPMethod:@"PATCH"]; [re setHTTPBody:[NSJSONSerialization dataWithJSONObject:up options:0 error:nil]];
        [[[NSURLSession sharedSession] dataTaskWithRequest:re completionHandler:^(NSData *d2, NSURLResponse *r2, NSError *e2) { [cite: 118]
            dispatch_async(dispatch_get_main_queue(), ^{ 
                [RDWCore vibe:YES]; [RDWCore playSoundNamed:@"success"];
                [self reloadData]; self.codeIn.text = @""; self.codeIn.placeholder = @"تم التجديد بنجاح ✅";
            });
        }] resume]; [cite: 119]
    }] resume];
}
- (void)goS { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RDW_WA_SUPPORT] options:@{} completionHandler:nil];
} [cite: 120]
@end

// --- Hooks ---
%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ [cite: 121]
        [NSTimer scheduledTimerWithTimeInterval:35 repeats:YES block:^(NSTimer *t) {
            [self rdw_periodicCheck];
        }];
        UILongPressGestureRecognizer *lp = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(rdw_handleP:)];
        lp.numberOfTouchesRequired = 3; lp.minimumPressDuration = 1.2; [self addGestureRecognizer:lp];
        
        NSArray *k = [[NSUserDefaults standardUserDefaults] objectForKey:@"RDW_KEYS"];
        if (!k || k.count == 0) {
 
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0*NSEC_PER_SEC), dispatch_get_main_queue(), ^{ [cite: 122]
                [self rdw_lockNow];
            });
        }
    });
} [cite: 123]

%new - (void)rdw_lockNow {
    UIViewController *top = [self rdw_topVC];
    if (![top isKindOfClass:[RDWLoginVC class]] && !top.presentedViewController) { [cite: 124]
        RDWLoginVC *vc = [[RDWLoginVC alloc] init];
        vc.modalPresentationStyle = UIModalPresentationOverFullScreen; [cite: 125]
        [top presentViewController:vc animated:YES completion:nil];
    }
}

%new - (void)rdw_handleP:(UILongPressGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateBegan) {
        if ([self viewWithTag:888]) { 
            UIView *v = [self viewWithTag:888];
            [UIView animateWithDuration:0.25 animations:^{ v.alpha = 0; v.transform = CGAffineTransformMakeScale(0.8, 0.8); } completion:^(BOOL f){ [v removeFromSuperview]; }]; [cite: 126]
            return;
        } [cite: 127]
        RDWPanel *p = [[RDWPanel alloc] initWithFrame:CGRectMake((self.frame.size.width-320)/2, 120, 320, 280)];
        p.alpha = 0;
        p.transform = CGAffineTransformMakeScale(0.6, 0.6); [self addSubview:p]; [cite: 128]
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.6 options:0 animations:^{ p.alpha=1; p.transform=CGAffineTransformIdentity; } completion:nil];
    } [cite: 129]
}

// تعديل وظيفة التفتيش الدوري لفتح التطبيق تلقائياً إذا أضفت أيام من السيرفر
%new - (void)rdw_periodicCheck {
    NSString *uPath = [NSString stringWithFormat:@"%@/%@.json", RDW_USERS, [RDWCore myID]];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:uPath] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) { [cite: 130]
        if (d) {
            NSDictionary *j = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (j && ![j isEqual:[NSNull null]]) {
                NSDate *exp = [RDWCore strToDate:j[@"expire_date"]];
                
                // إذا كان الكود ما زال سارياً (أكبر من الآن)
                if (exp && [exp timeIntervalSinceNow] > 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // إعادة تفعيل المفتاح إذا كان ممسوحاً
                        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"RDW_KEYS"]) {
                            [[NSUserDefaults standardUserDefaults] setObject:@[@"RDW_ACTIVE"] forKey:@"RDW_KEYS"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            // إغلاق شاشة القفل تلقائياً إذا كانت ظاهرة
                            UIViewController *top = [self rdw_topVC];
                            if ([top isKindOfClass:[RDWLoginVC class]]) {
                                [top dismissViewControllerAnimated:YES completion:nil];
                            }
                        }
                    });
                } else {
                    // إذا انتهى الوقت أو تفرغ، قم بالقفل
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"RDW_KEYS"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [self rdw_lockNow];
                    });
                }
            } else {
                // في حال عدم وجود بيانات (حذف اليوزر من السيرفر)
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"RDW_KEYS"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self rdw_lockNow];
                });
            }
        }
    }] resume];
}

%new - (UIViewController *)rdw_topVC {
    UIWindow *kw = nil;
    if (@available(iOS 13.0, *)) { [cite: 137]
        for (UIScene *s in [UIApplication sharedApplication].connectedScenes) {
            if (s.activationState == UISceneActivationStateForegroundActive && [s isKindOfClass:[UIWindowScene class]]) {
                for (UIWindow *w in ((UIWindowScene *)s).windows) { if (w.isKeyWindow) { kw = w;
                break; } } [cite: 138]
            }
        }
    }
    if (!kw) {
        for (UIWindow *w in [UIApplication sharedApplication].windows) { if (w.isKeyWindow) { kw = w;
        break; } } [cite: 139]
    }
    if (!kw) kw = [UIApplication sharedApplication].windows.firstObject;
    UIViewController *top = kw.rootViewController;
    while (top.presentedViewController) top = top.presentedViewController; [cite: 140]
    return top;
}
%end
