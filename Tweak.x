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
}
@end

@interface RDWLoginVC : UIViewController
@property (nonatomic, retain) UITextField *codeField;
@property (nonatomic, retain) UILabel *statusL;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@end

@implementation RDWLoginVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    UIView *cont = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-320)/2, (self.view.frame.size.height-540)/2, 320, 540)];
    cont.backgroundColor = [UIColor colorWithWhite:0.05 alpha:0.98];
    cont.layer.cornerRadius = 40; cont.layer.borderWidth = 1.2; cont.layer.borderColor = RDW_GOLD.CGColor;
    [self.view addSubview:cont];

    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(110, 30, 100, 100)];
    logo.layer.cornerRadius = 50; logo.clipsToBounds = YES;
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://i.ibb.co/7xZ41GWF/IMG-3601.jpg"] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        if (d) dispatch_async(dispatch_get_main_queue(), ^{ logo.image = [UIImage imageWithData:d]; });
    }] resume];
    [cont addSubview:logo];

    self.codeField = [[UITextField alloc] initWithFrame:CGRectMake(40, 250, 240, 55)];
    self.codeField.placeholder = @"أدخل كود RDW"; self.codeField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    self.codeField.textColor = RDW_GOLD; self.codeField.textAlignment = NSTextAlignmentCenter;
    self.codeField.layer.cornerRadius = 18; [cont addSubview:self.codeField];

    self.statusL = [[UILabel alloc] initWithFrame:CGRectMake(20, 180, 280, 50)];
    self.statusL.textColor = [UIColor whiteColor]; self.statusL.textAlignment = NSTextAlignmentCenter;
    self.statusL.numberOfLines = 2; self.statusL.text = @"أدخل كود التفعيل للاستمرار"; [cont addSubview:self.statusL];

    UIButton *actBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    actBtn.frame = CGRectMake(40, 325, 240, 55); [actBtn setTitle:@"تفعيل" forState:0];
    [actBtn setBackgroundColor:RDW_GOLD]; [actBtn setTitleColor:[UIColor whiteColor] forState:0];
    actBtn.layer.cornerRadius = 18; [actBtn addTarget:self action:@selector(validateOnline) forControlEvents:64];
    [cont addSubview:actBtn];

    UIButton *igBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    igBtn.frame = CGRectMake(40, 455, 240, 40); [igBtn setTitle:@"Instagram" forState:0];
    [igBtn setTitleColor:RDW_GOLD forState:0]; [igBtn addTarget:self action:@selector(goIG) forControlEvents:64];
    [cont addSubview:igBtn];
}

- (void)validateOnline {
    // ميزة منع الكود الفارغ
    NSString *input = [self.codeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (input.length < 4) {
        self.statusL.text = @"الرجاء إدخال كود صالح!";
        [RDWSecurity triggerErrorShake];
        return;
    }

    NSString *apiPath = [NSString stringWithFormat:@"%@/%@.json", RDW_DB_URL, input];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:apiPath] completionHandler:^(NSData *data, NSURLResponse *res, NSError *err) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if (json && ![json isEqual:[NSNull null]]) {
                    [RDWSecurity saveLocal:input forKey:@"RDW_CODE"];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    return;
                }
            }
            self.statusL.text = @"كود خاطئ! تواصل معنا";
            [RDWSecurity triggerErrorShake];
        });
    }] resume];
}
- (void)goIG { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RDW_INSTA] options:@{} completionHandler:nil]; }
@end

@interface RDWWalletVC : UIView
@end
@implementation RDWWalletVC
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.95];
        self.layer.cornerRadius = 20; self.layer.borderColor = RDW_GOLD.CGColor; self.layer.borderWidth = 1.5;
        self.tag = 777;
        UIButton *ren = [UIButton buttonWithType:UIButtonTypeSystem];
        ren.frame = CGRectMake(20, 20, 200, 40); [ren setTitle:@"تجديد الاشتراك" forState:0];
        [ren setBackgroundColor:RDW_GOLD]; [ren setTitleColor:[UIColor whiteColor] forState:0];
        ren.layer.cornerRadius = 10; [ren addTarget:self action:@selector(reLock) forControlEvents:64];
        [self addSubview:ren];
    }
    return self;
}
- (void)reLock {
    [self removeFromSuperview];
    UIWindow *win = (UIWindow *)[UIApplication sharedApplication].keyWindow;
    RDWLoginVC *vc = [[RDWLoginVC alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [win.rootViewController presentViewController:vc animated:YES completion:nil];
}
@end

%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        // ميزة الضغط المطول 2.5 ثانية بـ 3 أصابع
        UILongPressGestureRecognizer *lp = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(rdw_handle_lp:)];
        lp.numberOfTouchesRequired = 3;
        lp.minimumPressDuration = 2.5; 
        [self addGestureRecognizer:lp];

        [NSTimer scheduledTimerWithTimeInterval:30 repeats:YES block:^(NSTimer *timer) {
            NSString *code = [RDWSecurity loadLocal:@"RDW_CODE"];
            if (!code) { [self rdw_lock_now]; return; }
            NSString *p = [NSString stringWithFormat:@"%@/%@.json", RDW_DB_URL, code];
            [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:p] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
                if (d) {
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
                    if (!json || [json isEqual:[NSNull null]]) {
                        dispatch_async(dispatch_get_main_queue(), ^{ [RDWSecurity clearLocal]; [self rdw_lock_now]; });
                    }
                }
            }] resume];
        }];
    });
}

%new
- (void)rdw_handle_lp:(UILongPressGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateBegan) {
        if ([self viewWithTag:777]) return;
        RDWWalletVC *panel = [[RDWWalletVC alloc] initWithFrame:CGRectMake((self.frame.size.width-240)/2, 120, 240, 80)];
        [self addSubview:panel];
    }
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
%end
