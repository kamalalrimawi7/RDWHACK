#import <UIKit/UIKit.h>
#import <Security/Security.h>

// --- إعدادات السيرفر والروابط ---
static NSString *const RDW_DB_URL = @"https://rdw-server-default-rtdb.firebaseio.com/codes";
static NSString *const RDW_INSTA  = @"https://www.instagram.com/rimawi.dw";
static NSString *const RDW_WA     = @"https://wa.me/972567171874?text=اريد_شراء_كود_متجر_RDW";

// لون ذهبي مخصص لمتجر RDW
#define RDW_GOLD [UIColor colorWithRed:0.72 green:0.56 blue:0.17 alpha:1.0]
#define RDW_GREEN [UIColor colorWithRed:0.15 green:0.68 blue:0.38 alpha:1.0]

@interface RDWSecurity : NSObject
+ (NSString *)getUDID;
+ (void)saveLocal:(NSString *)val forKey:(NSString *)key;
+ (NSString *)loadLocal:(NSString *)key;
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
@end

// --- واجهة تسجيل الدخول الاحترافية ---
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
    self.statusL.text = @"هذه نسخة حصرية لمتجر RDW\nيرجى تفعيل الكود للاستمرار"; self.statusL.numberOfLines = 2;
    self.statusL.textColor = [UIColor lightGrayColor]; self.statusL.font = [UIFont systemFontOfSize:13];
    self.statusL.textAlignment = NSTextAlignmentCenter; [cont addSubview:self.statusL];

    self.codeField = [[UITextField alloc] initWithFrame:CGRectMake(40, 250, 240, 50)];
    self.codeField.placeholder = @"أدخل كود RDW الحصري..."; self.codeField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.08];
    self.codeField.textColor = [UIColor whiteColor]; self.codeField.textAlignment = NSTextAlignmentCenter;
    self.codeField.layer.cornerRadius = 15; [cont addSubview:self.codeField];

    UIButton *actBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    actBtn.frame = CGRectMake(40, 320, 240, 55); [actBtn setTitle:@"تفعيل واستمرار" forState:UIControlStateNormal];
    [actBtn setBackgroundColor:RDW_GOLD]; [actBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; 
    actBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18]; actBtn.layer.cornerRadius = 18;
    [actBtn addTarget:self action:@selector(validateOnline) forControlEvents:UIControlEventTouchUpInside];
    [cont addSubview:actBtn];

    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    buyBtn.frame = CGRectMake(40, 390, 240, 50); [buyBtn setTitle:@"شراء كود تفعيل RDW" forState:UIControlStateNormal];
    [buyBtn setBackgroundColor:RDW_GREEN]; [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; 
    buyBtn.layer.cornerRadius = 15; [buyBtn addTarget:self action:@selector(goWA) forControlEvents:UIControlEventTouchUpInside];
    [cont addSubview:buyBtn];

    UILabel *dev = [[UILabel alloc] initWithFrame:CGRectMake(0, 480, 320, 20)];
    dev.text = @"تم التفعيل بواسطة المطور كمال"; dev.textColor = [UIColor darkGrayColor];
    dev.font = [UIFont systemFontOfSize:10]; dev.textAlignment = NSTextAlignmentCenter; [cont addSubview:dev];

    // حل مشكلة الـ Spinner
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
            if (err || !data) { self.statusL.text = @"خطأ: تأكد من اتصالك بالإنترنت!"; return; }
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (!json || [json isEqual:[NSNull null]]) { [self failAction:@"الكود غير صحيح!"]; return; }

            NSString *usedBy = json[@"usedBy"];
            if (![usedBy isEqualToString:@""] && ![usedBy isEqualToString:myUDID]) {
                self.statusL.text = @"الكود مفعل على جهاز آخر!"; return;
            }
            [self finalizeActivation:input udid:myUDID serverExp:[json[@"expiry"] doubleValue]];
        });
    }] resume];
}

- (void)finalizeActivation:(NSString *)code udid:(NSString *)udid serverExp:(double)sExp {
    double now = [[NSDate date] timeIntervalSince1970];
    double newExp = (sExp > now ? sExp : now) + (30 * 86400);
    NSDictionary *patch = @{@"usedBy": udid, @"expiry": @(newExp)};
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json", RDW_DB_URL, code]]];
    [req setHTTPMethod:@"PATCH"]; [req setHTTPBody:[NSJSONSerialization dataWithJSONObject:patch options:0 error:nil]];
    [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        if (!e) dispatch_async(dispatch_get_main_queue(), ^{
            [RDWSecurity saveLocal:[NSString stringWithFormat:@"%f", newExp] forKey:@"RDW_EXP"];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }] resume];
}

- (void)failAction:(NSString *)msg {
    self.statusL.text = msg;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RDW_INSTA] options:@{} completionHandler:nil];
    });
}
- (void)goWA { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RDW_WA] options:@{} completionHandler:nil]; }
- (BOOL)modalInPresentation { return YES; }
@end

// --- واجهة المحفظة (Wallet) ---
@interface RDWWalletVC : UIViewController
@end
@implementation RDWWalletVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.95];
    self.view.layer.cornerRadius = 25; self.view.layer.borderWidth = 1;
    self.view.layer.borderColor = [RDW_GOLD colorWithAlphaComponent:0.5].CGColor;

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 280, 25)];
    title.text = @"محفظة RDW"; title.textColor = [UIColor whiteColor];
    title.font = [UIFont boldSystemFontOfSize:18]; title.textAlignment = NSTextAlignmentCenter; [self.view addSubview:title];

    UILabel *daysL = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 280, 30)];
    double exp = [[RDWSecurity loadLocal:@"RDW_EXP"] doubleValue];
    int days = (int)ceil((exp - [[NSDate date] timeIntervalSince1970]) / 86400);
    daysL.text = [NSString stringWithFormat:@"متبقي لديك: %d يوماً", (days > 0 ? days : 0)];
    daysL.textColor = RDW_GOLD; daysL.textAlignment = NSTextAlignmentCenter; [self.view addSubview:daysL];

    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.frame = CGRectMake(145, 90, 120, 45); [closeBtn setTitle:@"إغلاق" forState:UIControlStateNormal];
    [closeBtn setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.1]]; [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeBtn.layer.cornerRadius = 15; [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
}
- (void)close { [self.view removeFromSuperview]; }
@end

// --- الهوك الرئيسي ---
%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        [self performSelector:@selector(checkRDWSubscription) withObject:nil afterDelay:1.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showRDWWallet)];
        tap.numberOfTouchesRequired = 3; [self addGestureRecognizer:tap];
    });
}
%new
- (void)checkRDWSubscription {
    NSString *localExp = [RDWSecurity loadLocal:@"RDW_EXP"];
    if (!localExp || [localExp doubleValue] < [[NSDate date] timeIntervalSince1970]) {
        RDWLoginVC *vc = [[RDWLoginVC alloc] init];
        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self.rootViewController presentViewController:vc animated:YES completion:nil];
    }
}
%new
- (void)showRDWWallet {
    RDWWalletVC *wallet = [[RDWWalletVC alloc] init];
    wallet.view.frame = CGRectMake((self.frame.size.width-280)/2, 120, 280, 150);
    [self.rootViewController.view addSubview:wallet.view];
}
%end
