#import <UIKit/UIKit.h>
#import <Security/Security.h>

// --- مساعد الـ Keychain للحماية القصوى من الحذف ---
@interface RDWKeyChain : NSObject
+ (void)setStr:(NSString *)s forKey:(NSString *)k;
+ (NSString *)getStrWithKey:(NSString *)k;
@end

@implementation RDWKeyChain
+ (void)setStr:(NSString *)s forKey:(NSString *)k {
    NSData *d = [s dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *q = @{(__bridge id)kSecClass:(__bridge id)kSecClassGenericPassword, (__bridge id)kSecAttrAccount:k, (__bridge id)kSecValueData:d};
    SecItemDelete((__bridge CFDictionaryRef)q);
    SecItemAdd((__bridge CFDictionaryRef)q, NULL);
}
+ (NSString *)getStrWithKey:(NSString *)k {
    NSDictionary *q = @{(__bridge id)kSecClass:(__bridge id)kSecClassGenericPassword, (__bridge id)kSecAttrAccount:k, (__bridge id)kSecReturnData:(__bridge id)kCFBooleanTrue, (__bridge id)kSecMatchLimit:(__bridge id)kSecMatchLimitOne};
    CFDataRef d = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)q, (CFTypeRef *)&d) == errSecSuccess) {
        return [[NSString alloc] initWithData:(__bridge NSData *)d encoding:NSUTF8StringEncoding];
    }
    return nil;
}
@end

// --- واجهة المحفظة (البانل المخفي) ---
@interface RDWWalletView : UIView
@property (nonatomic, retain) UILabel *daysLabel;
@property (nonatomic, retain) UITextField *inputField;
@property (nonatomic, retain) NSArray *masterCodes;
@end

@implementation RDWWalletView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.07 green:0.08 blue:0.10 alpha:0.98];
        self.layer.cornerRadius = 25;
        self.layer.borderWidth = 1.5;
        self.layer.borderColor = [UIColor colorWithRed:0.72 green:0.56 blue:0.17 alpha:0.5].CGColor;

// مصفوفة الـ 200 كود (انسخها داخل ملف Tweak.x في قسم masterCodes)
self.masterCodes = @[
    @"RDW-7X2P9M", @"RDW-B4N8K1", @"RDW-Q9W5Z3", @"RDW-R2T6V8", @"RDW-L1M4N7",
    @"RDW-J9K2C5", @"RDW-S8D3F6", @"RDW-G4H1J7", @"RDW-P5L9K2", @"RDW-X3C7V1",
    @"RDW-M9N2B4", @"RDW-K1L5J8", @"RDW-H3G7F2", @"RDW-D6S9A1", @"RDW-P4O0I2",
    @"RDW-U7Y3E5", @"RDW-A8S1D4", @"RDW-Z2X6C9", @"RDW-V5B0N3", @"RDW-F8G4H7",
    @"RDW-T1R5E9", @"RDW-K3J7L2", @"RDW-Q0W4E8", @"RDW-M1N6B9", @"RDW-Y2U5I8",
    @"RDW-O4P7L0", @"RDW-S3D6F9", @"RDW-G1H5J9", @"RDW-K8L2M5", @"RDW-X4C7B1",
    @"RDW-Z9X3C2", @"RDW-N5M8L1", @"RDW-A4S7D0", @"RDW-F2G6H1", @"RDW-J5K9L3",
    @"RDW-Q7W1E4", @"RDW-R8T2Y5", @"RDW-U9I3O6", @"RDW-P0L4K7", @"RDW-V1B5N9",
    @"RDW-C2X6Z0", @"RDW-M3N7B1", @"RDW-H4G8F2", @"RDW-D5S9A3", @"RDW-K6J0L4",
    @"RDW-E7R1T5", @"RDW-Y8U2I6", @"RDW-O9P3L7", @"RDW-S0D4F8", @"RDW-G1H5J2",
    @"RDW-A6S2D7", @"RDW-F1G5H9", @"RDW-J4K8L2", @"RDW-Q9W3E7", @"RDW-R4T0Y6",
    @"RDW-U1I5O9", @"RDW-P6L0K4", @"RDW-V7B1N5", @"RDW-C8X2Z6", @"RDW-M9N3B7",
    @"RDW-H0G4F8", @"RDW-D1S5A9", @"RDW-K2J6L0", @"RDW-E3R7T1", @"RDW-Y4U8I2",
    @"RDW-O5P9L3", @"RDW-S6D0F4", @"RDW-G7H1J5", @"RDW-A2S8D4", @"RDW-F7G1H5",
    @"RDW-J2K6L0", @"RDW-Q7W1E5", @"RDW-R2T6Y0", @"RDW-U7I1O5", @"RDW-P2L6K0",
    @"RDW-V7B1N5", @"RDW-C2X6Z0", @"RDW-M7N1B5", @"RDW-H2G6F0", @"RDW-D7S1A5",
    @"RDW-K2J6L0", @"RDW-E7R1T5", @"RDW-Y2U6I0", @"RDW-O7P1L5", @"RDW-S2D6F0",
    @"RDW-G7H1J5", @"RDW-A2S8D4", @"RDW-F7G1H5", @"RDW-J2K6L0", @"RDW-Q7W1E5",
    @"RDW-B9N3M7", @"RDW-V4C8X2", @"RDW-Z1L5K9", @"RDW-J6H0G4", @"RDW-F3D7S1",
    @"RDW-P2O6I0", @"RDW-U7Y1T5", @"RDW-R2E6W0", @"RDW-Q7A1S5", @"RDW-K2L6M0",
    @"RDW-X3C9V1", @"RDW-N4M8B2", @"RDW-A5S9D3", @"RDW-G6H0J4", @"RDW-K7L1M5",
    @"RDW-P8O2I6", @"RDW-U9Y3T7", @"RDW-R0E4W8", @"RDW-Q1A5S9", @"RDW-Z2X6C0",
    @"RDW-V3B7N1", @"RDW-M4L8K2", @"RDW-H5G9F3", @"RDW-D6S0A4", @"RDW-K7J1L5",
    @"RDW-E8R2T6", @"RDW-Y9U3I7", @"RDW-O0P4L8", @"RDW-S1D5F9", @"RDW-G2H6J0",
    @"RDW-T3R7E1", @"RDW-K4J8L2", @"RDW-Q5W9E3", @"RDW-M6N0B4", @"RDW-Y7U1I5",
    @"RDW-O8P2L6", @"RDW-S9D3F7", @"RDW-G0H4J8", @"RDW-K1L5M9", @"RDW-X2C6V0",
    @"RDW-Z3X7C1", @"RDW-N4M8L2", @"RDW-A5S9D3", @"RDW-F6G0H4", @"RDW-J7K1L5",
    @"RDW-Q8W2E6", @"RDW-R9T3Y7", @"RDW-U0I4O8", @"RDW-P1L5K9", @"RDW-V2B6N0",
    @"RDW-C3X7Z1", @"RDW-M4N8B2", @"RDW-H5G9F3", @"RDW-D6S0A4", @"RDW-K7J1L5",
    @"RDW-E8R2T6", @"RDW-Y9U3I7", @"RDW-O0P4L8", @"RDW-S1D5F9", @"RDW-G2H6J0",
    @"RDW-T3R7E1", @"RDW-K4J8L2", @"RDW-Q5W9E3", @"RDW-M6N0B4", @"RDW-Y7U1I5",
    @"RDW-O8P2L6", @"RDW-S9D3F7", @"RDW-G0H4J8", @"RDW-K1L5M9", @"RDW-X2C6V0",
    @"RDW-Z3X7C1", @"RDW-N4M8L2", @"RDW-A5S9D3", @"RDW-F6G0H4", @"RDW-J7K1L5",
    @"RDW-Q8W2E6", @"RDW-R9T3Y7", @"RDW-U0I4O8", @"RDW-P1L5K9", @"RDW-V2B6N0",
    @"RDW-C3X7Z1", @"RDW-M4N8B2", @"RDW-H5G9F3", @"RDW-D6S0A4", @"RDW-K7J1L5",
    @"RDW-E8R2T6", @"RDW-Y9U3I7", @"RDW-O0P4L8", @"RDW-S1D5F9", @"RDW-G2H6J0",
    @"RDW-T3R7E1", @"RDW-K4J8L2", @"RDW-Q5W9E3", @"RDW-M6N0B4", @"RDW-Y7U1I5",
    @"RDW-O8P2L6", @"RDW-S9D3F7", @"RDW-G0H4J8", @"RDW-K1L5M9", @"RDW-X2C6V0",
    @"RDW-A1B2C3", @"RDW-D4E5F6", @"RDW-G7H8I9", @"RDW-J0K1L2", @"RDW-M3N4O5",
    @"RDW-P6Q7R8", @"RDW-S9T0U1", @"RDW-V2W3X4", @"RDW-Y5Z6A7", @"RDW-B8C9D0"
];
        UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 300, 30)];
        t.text = @"محفظة RDW الرقمية";
        t.textColor = [UIColor whiteColor];
        t.textAlignment = NSTextAlignmentCenter;
        t.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:t];

        self.daysLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, 300, 30)];
        self.daysLabel.textAlignment = NSTextAlignmentCenter;
        [self refreshDays];
        [self addSubview:self.daysLabel];

        self.inputField = [[UITextField alloc] initWithFrame:CGRectMake(30, 100, 240, 40)];
        self.inputField.placeholder = @"أدخل كود شحن جديد...";
        self.inputField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
        self.inputField.textColor = [UIColor whiteColor];
        self.inputField.textAlignment = NSTextAlignmentCenter;
        self.inputField.layer.cornerRadius = 10;
        [self addSubview:self.inputField];

        UIButton *re = [UIButton buttonWithType:UIButtonTypeSystem];
        re.frame = CGRectMake(30, 155, 240, 45);
        [re setTitle:@"شحن الرصيد" forState:UIControlStateNormal];
        [re setBackgroundColor:[UIColor colorWithRed:0.72 green:0.56 blue:0.17 alpha:1.0]];
        [re setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        re.layer.cornerRadius = 12;
        [re addTarget:self action:@selector(doRefill) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:re];

        UIButton *cl = [UIButton buttonWithType:UIButtonTypeSystem];
        cl.frame = CGRectMake(30, 210, 240, 40);
        [cl setTitle:@"إغلاق" forState:UIControlStateNormal];
        [cl setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [cl addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cl];
    }
    return self;
}

- (void)refreshDays {
    NSString *expStr = [RDWKeyChain getStrWithKey:@"RDW_Exp"];
    if (!expStr) { self.daysLabel.text = @"متبقي لديك: 0 يوماً"; self.daysLabel.textColor = [UIColor redColor]; return; }
    int d = (int)ceil(([expStr doubleValue] - [[NSDate date] timeIntervalSince1970]) / 86400.0);
    self.daysLabel.text = (d > 0) ? [NSString stringWithFormat:@"متبقي لديك: %d يوماً", d] : @"اشتراك منتهي!";
    self.daysLabel.textColor = (d > 0) ? [UIColor greenColor] : [UIColor redColor];
}

- (void)doRefill {
    NSString *code = self.inputField.text;
    NSString *myID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    if (![self.masterCodes containsObject:code]) { [self close]; [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.instagram.com/rimawi.dw"] options:@{} completionHandler:nil]; return; }
    if ([RDWKeyChain getStrWithKey:[NSString stringWithFormat:@"Used_%@", code]]) return;

    double now = [[NSDate date] timeIntervalSince1970];
    double current = [[RDWKeyChain getStrWithKey:@"RDW_Exp"] doubleValue];
    double start = (current > now) ? current : now;
    [RDWKeyChain setStr:[NSString stringWithFormat:@"%f", start + (30*86400)] forKey:@"RDW_Exp"];
    [RDWKeyChain setStr:myID forKey:[NSString stringWithFormat:@"Used_%@", code]];
    [self refreshDays];
    self.inputField.text = @"";
}
- (void)close { [self removeFromSuperview]; }
@end

// --- واجهة تسجيل الدخول الرئيسية ---
@interface RDWLoginVC : UIViewController
@property (nonatomic, retain) UITextField *codeF;
@property (nonatomic, retain) NSArray *codes;
@end

@implementation RDWLoginVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.codes = @[@"RDW-A1S2D3F4", @"RDW-B9N8M7V6", @"RDW-K5L4J3H2"];

    UIBlurEffect *b = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *bv = [[UIVisualEffectView alloc] initWithEffect:b];
    bv.frame = self.view.bounds;
    [self.view addSubview:bv];

    UIView *cont = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-300)/2, (self.view.frame.size.height-450)/2, 300, 450)];
    cont.backgroundColor = [UIColor colorWithRed:0.07 green:0.08 blue:0.10 alpha:0.95];
    cont.layer.cornerRadius = 25;
    [self.view addSubview:cont];

    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(100, 30, 100, 100)];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://i.ibb.co/7xZ41GWF/IMG-3601.jpg"] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        if (d) dispatch_async(dispatch_get_main_queue(), ^{ img.image = [UIImage imageWithData:d]; });
    }] resume];
    [cont addSubview:img];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 140, 300, 30)];
    title.text = @"Rimawi Digital World";
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont boldSystemFontOfSize:22];
    title.textAlignment = NSTextAlignmentCenter;
    [cont addSubview:title];

    UILabel *sub = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, 300, 40)];
    sub.text = @"يرجى ادخال الكود لتفعيل التطبيق";
    sub.textColor = [UIColor lightGrayColor];
    sub.font = [UIFont systemFontOfSize:13];
    sub.numberOfLines = 2;
    sub.textAlignment = NSTextAlignmentCenter;
    [cont addSubview:sub];

    self.codeF = [[UITextField alloc] initWithFrame:CGRectMake(30, 230, 240, 45)];
    self.codeF.placeholder = @"أدخل كود التفعيل...";
    self.codeF.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    self.codeF.textColor = [UIColor whiteColor];
    self.codeF.textAlignment = NSTextAlignmentCenter;
    self.codeF.layer.cornerRadius = 12;
    [cont addSubview:self.codeF];

    UIButton *act = [UIButton buttonWithType:UIButtonTypeSystem];
    act.frame = CGRectMake(30, 290, 240, 45);
    [act setTitle:@"تفعيل واستمرار" forState:UIControlStateNormal];
    [act setBackgroundColor:[UIColor colorWithRed:0.72 green:0.56 blue:0.17 alpha:1.0]];
    [act setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    act.layer.cornerRadius = 12;
    [act addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [cont addSubview:act];

    UIButton *wa = [UIButton buttonWithType:UIButtonTypeSystem];
    wa.frame = CGRectMake(30, 345, 240, 45);
    [wa setTitle:@"شراء كود تفعيل RDW" forState:UIControlStateNormal];
    [wa setBackgroundColor:[UIColor colorWithRed:0.15 green:0.68 blue:0.38 alpha:1.0]];
    [wa setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    wa.layer.cornerRadius = 12;
    [wa addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    [cont addSubview:wa];
}

- (void)login {
    NSString *in = self.codeF.text;
    if (![self.codes containsObject:in]) { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.instagram.com/rimawi.dw"] options:@{} completionHandler:nil]; return; }
    [RDWKeyChain setStr:[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970] + (30*86400)] forKey:@"RDW_Exp"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)buy {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://wa.me/972567171874?text=أريد_شراء_كود_تفعيل_لمتجر_RDW"] options:@{} completionHandler:nil];
}
@end

// --- الحقن والتشغيل ---
%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        UILongPressGestureRecognizer *g = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(openRDWWallet:)];
        g.numberOfTouchesRequired = 3;
        g.minimumPressDuration = 4.0;
        [self addGestureRecognizer:g];

        NSString *exp = [RDWKeyChain getStrWithKey:@"RDW_Exp"];
        if (!exp || [exp doubleValue] < [[NSDate date] timeIntervalSince1970]) {
            RDWLoginVC *vc = [[RDWLoginVC alloc] init];
            vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self.rootViewController presentViewController:vc animated:YES completion:nil];
        }
    });
}

%new
- (void)openRDWWallet:(UILongPressGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateBegan) {
        RDWWalletView *w = [[RDWWalletView alloc] initWithFrame:CGRectMake((self.frame.size.width-300)/2, (self.frame.size.height-300)/2, 300, 300)];
        [self addSubview:w];
    }
}
%end
