#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import <AudioToolbox/AudioToolbox.h>

// --- إعدادات RDW وروابط التواصل ---
static NSString *const RDW_DB_URL = @"https://rdw-server-default-rtdb.firebaseio.com/codes";
static NSString *const RDW_INSTA  = @"https://www.instagram.com/rimawi.dw";
static NSString *const RDW_WA     = @"https://wa.me/972567171874?text=+أريد+شراء+كود+تفعيل+RDW+لو+سمحت";
#define RDW_GOLD [UIColor colorWithRed:0.72 green:0.56 blue:0.17 alpha:1.0]

@interface RDWSecurity : NSObject
+ (void)saveLocal:(NSString *)val forKey:(NSString *)key;
+ (NSString *)loadLocal:(NSString *)key;
+ (void)clearLocal;
@end

@interface RDWLoginVC : UIViewController
@property (nonatomic, retain) UITextField *codeField;
@property (nonatomic, retain) UILabel *statusL;
@end

// --- واجهة بانل التحكم (تظهر بـ 3 أصابع) ---
@interface RDWWalletVC : UIView
@end
@implementation RDWWalletVC
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.08 alpha:0.98];
        self.layer.cornerRadius = 20; self.layer.borderColor = RDW_GOLD.CGColor; self.layer.borderWidth = 1.5;
        self.tag = 999;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(20, 20, 200, 45); 
        [btn setTitle:@"تجديد / تغيير الكود" forState:0];
        [btn setBackgroundColor:RDW_GOLD]; [btn setTitleColor:[UIColor whiteColor] forState:0];
        btn.layer.cornerRadius = 10; [btn addTarget:self action:@selector(reLock) forControlEvents:64];
        [self addSubview:btn];
    }
    return self;
}
- (void)reLock {
    [self removeFromSuperview];
    UIWindow *win = (UIWindow *)[[UIApplication sharedApplication] keyWindow];
    RDWLoginVC *vc = [[RDWLoginVC alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [win.rootViewController presentViewController:vc animated:YES completion:nil];
}
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
@end

@implementation RDWLoginVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    UIView *cont = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-300)/2, (self.view.frame.size.height-550)/2, 300, 550)];
    cont.backgroundColor = [UIColor colorWithWhite:0.05 alpha:1.0];
    cont.layer.cornerRadius = 30; cont.layer.borderWidth = 1.2; cont.layer.borderColor = RDW_GOLD.CGColor;
    [self.view addSubview:cont];

    self.codeField = [[UITextField alloc] initWithFrame:CGRectMake(30, 180, 240, 50)];
    self.codeField.placeholder = @"أدخل كود RDW"; self.codeField.backgroundColor = [UIColor whiteColor];
    self.codeField.textAlignment = NSTextAlignmentCenter; self.codeField.layer.cornerRadius = 12;
    [cont addSubview:self.codeField];

    UIButton *actBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    actBtn.frame = CGRectMake(30, 245, 240, 50); [actBtn setTitle:@"تفعيل" forState:0];
    [actBtn setBackgroundColor:RDW_GOLD]; [actBtn setTitleColor:[UIColor whiteColor] forState:0];
    actBtn.layer.cornerRadius = 12; [actBtn addTarget:self action:@selector(validate) forControlEvents:64];
    [cont addSubview:actBtn];

    UIButton *waBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    waBtn.frame = CGRectMake(30, 305, 240, 50); [waBtn setTitle:@"شراء كود (WhatsApp)" forState:0];
    [waBtn setTitleColor:[UIColor greenColor] forState:0]; [waBtn addTarget:self action:@selector(openWA) forControlEvents:64];
    [cont addSubview:waBtn];

    self.statusL = [[UILabel alloc] initWithFrame:CGRectMake(10, 430, 280, 40)];
    self.statusL.textColor = [UIColor whiteColor]; self.statusL.textAlignment = NSTextAlignmentCenter;
    [cont addSubview:self.statusL];
}
- (void)validate {
    NSString *input = [self.codeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (input.length < 3) { self.statusL.text = @"الحقل فارغ!"; return; }
    NSString *path = [NSString stringWithFormat:@"%@/%@.json", RDW_DB_URL, input];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:path] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (d) {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
                if (json && ![json isEqual:[NSNull null]]) {
                    [RDWSecurity saveLocal:input forKey:@"RDW_CODE"];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    return;
                }
            }
            self.statusL.text = @"الكود خطأ! تواصل معنا";
        });
    }] resume];
}
- (void)openWA { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RDW_WA] options:@{} completionHandler:nil]; }
@end

%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        // تفعيل البانل بـ 3 أصابع (ضغط مطول 2.5 ثانية)
        UILongPressGestureRecognizer *lp = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(rdw_handle_lp:)];
        lp.numberOfTouchesRequired = 3; lp.minimumPressDuration = 2.5;
        [self addGestureRecognizer:lp];

        [NSTimer scheduledTimerWithTimeInterval:20 repeats:YES block:^(NSTimer *timer) {
            NSString *code = [RDWSecurity loadLocal:@"RDW_CODE"];
            if (!code) { [self rdw_lock]; return; }
            NSString *p = [NSString stringWithFormat:@"%@/%@.json", RDW_DB_URL, code];
            [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:p] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
                if (d) {
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
                    if (!json || [json isEqual:[NSNull null]]) {
                        dispatch_async(dispatch_get_main_queue(), ^{ [RDWSecurity clearLocal]; [self rdw_lock]; });
                    }
                }
            }] resume];
        }];
    });
}
%new
- (void)rdw_handle_lp:(UILongPressGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateBegan) {
        if ([self viewWithTag:999]) return;
        RDWWalletVC *p = [[RDWWalletVC alloc] initWithFrame:CGRectMake((self.frame.size.width-240)/2, 120, 240, 85)];
        [self addSubview:p];
    }
}
%new
- (void)rdw_lock {
    UIViewController *top = self.rootViewController;
    while (top.presentedViewController) top = top.presentedViewController;
    if (![top isKindOfClass:[RDWLoginVC class]]) {
        RDWLoginVC *vc = [[RDWLoginVC alloc] init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [top presentViewController:vc animated:YES completion:nil];
    }
}
%end
