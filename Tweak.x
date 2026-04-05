#import <UIKit/UIKit.h>

@interface RDWModernLoginVC : UIViewController
@property (nonatomic, retain) UIVisualEffectView *blurView;
@property (nonatomic, retain) UIView *alertContainer;
@property (nonatomic, retain) UIImageView *logoView;
@property (nonatomic, retain) UITextField *codeField;
@property (nonatomic, retain) UILabel *statusLabel;
@property (nonatomic, retain) NSArray *masterCodes; 
@end

@implementation RDWModernLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];

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
    // 1. النغمشة (Blur)
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
    self.blurView.frame = self.view.bounds;
    [self.view addSubview:self.blurView];

    // 2. الحاوية
    self.alertContainer = [[UIView alloc] init];
    self.alertContainer.backgroundColor = [UIColor colorWithRed:0.07 green:0.08 blue:0.10 alpha:0.96];
    self.alertContainer.layer.cornerRadius = 25;
    self.alertContainer.layer.shadowOpacity = 0.8;
    self.alertContainer.layer.shadowRadius = 20;
    [self.view addSubview:self.alertContainer];

    // 3. اللوجو
    self.logoView = [[UIImageView alloc] init];
    self.logoView.contentMode = UIViewContentModeScaleAspectFit;
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://i.ibb.co/7xZ41GWF/IMG-3601.jpg"] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        if (d) dispatch_async(dispatch_get_main_queue(), ^{ self.logoView.image = [UIImage imageWithData:d]; });
    }] resume];
    [self.alertContainer addSubview:self.logoView];

    // 4. النصوص والجمالية
    UILabel *title = [[UILabel alloc] init];
    title.text = @"Rimawi Digital World";
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont boldSystemFontOfSize:22];
    title.textAlignment = NSTextAlignmentCenter;
    [self.alertContainer addSubview:title];

    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.text = @"نسخة حصرية لمتجر RDW\nأدخل الكود لشحن 30 يوم";
    self.statusLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.7];
    self.statusLabel.font = [UIFont systemFontOfSize:12];
    self.statusLabel.numberOfLines = 2;
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    [self.alertContainer addSubview:self.statusLabel];

    // 5. خانة الكود
    self.codeField = [[UITextField alloc] init];
    self.codeField.placeholder = @"RDW-XXXXXX";
    self.codeField.textAlignment = NSTextAlignmentCenter;
    self.codeField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    self.codeField.textColor = [UIColor whiteColor];
    self.codeField.layer.cornerRadius = 12;
    [self.alertContainer addSubview:self.codeField];

    // 6. زر التفعيل
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"شحن الرصيد" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor colorWithRed:0.72 green:0.56 blue:0.17 alpha:1.00]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 12;
    [btn addTarget:self action:@selector(processCode) forControlEvents:UIControlEventTouchUpInside];
    [self.alertContainer addSubview:btn];

    // 7. توقيع كمال
    UILabel *dev = [[UILabel alloc] init];
    dev.text = @"تم التفعيل بواسطة المطوّر كمال";
    dev.textColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    dev.font = [UIFont systemFontOfSize:10];
    [self.alertContainer addSubview:dev];

    [self setupLayout];
}

- (void)processCode {
    NSString *input = self.codeField.text;
    NSUserDefaults *p = [NSUserDefaults standardUserDefaults];
    NSString *myID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];

    // فحص إذا الكود موجود في اللستة
    if (![self.masterCodes containsObject:input]) {
        [self updateStatus:@"كود غير صحيح!" color:[UIColor redColor]];
        return;
    }

    // فحص إذا الكود مستخدم من قبل
    NSString *usedBy = [p objectForKey:[NSString stringWithFormat:@"UsedBy_%@", input]];
    if (usedBy) {
        if ([usedBy isEqualToString:myID]) [self updateStatus:@"استعملت هذا الكود مسبقاً!" color:[UIColor orangeColor]];
        else [self updateStatus:@"هذا الكود مستخدم على جهاز آخر!" color:[UIColor redColor]];
        return;
    }

    // شحن 30 يوم إضافية
    [p setObject:myID forKey:[NSString stringWithFormat:@"UsedBy_%@", input]];
    NSDate *currentExp = [p objectForKey:@"RDW_Expiry"];
    if (!currentExp || [[NSDate date] compare:currentExp] == NSOrderedDescending) {
        currentExp = [NSDate date];
    }
    
    NSDate *newExp = [currentExp dateByAddingTimeInterval:30 * 24 * 3600];
    [p setObject:newExp forKey:@"RDW_Expiry"];
    [p synchronize];

    [self updateStatus:@"تم شحن 30 يوم بنجاح!" color:[UIColor greenColor]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)updateStatus:(NSString *)m color:(UIColor *)c {
    self.statusLabel.text = m; self.statusLabel.textColor = c;
}

- (void)setupLayout {
    self.alertContainer.translatesAutoresizingMaskIntoConstraints = NO;
    for (UIView *v in self.alertContainer.subviews) v.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.alertContainer.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.alertContainer.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.alertContainer.widthAnchor constraintEqualToConstant:300],
        [self.alertContainer.heightAnchor constraintEqualToConstant:480],
        [self.logoView.topAnchor constraintEqualToAnchor:self.alertContainer.topAnchor constant:25],
        [self.logoView.centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [self.logoView.widthAnchor constraintEqualToConstant:100], [self.logoView.heightAnchor constraintEqualToConstant:100],
        [self.codeField.topAnchor constraintEqualToAnchor:self.statusLabel.bottomAnchor constant:30],
        [self.codeField.centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [self.codeField.widthAnchor constraintEqualToConstant:240], [self.codeField.heightAnchor constraintEqualToConstant:40]
    ]];
    UIView *last = self.alertContainer.subviews.lastObject;
    [last.bottomAnchor constraintEqualToAnchor:self.alertContainer.bottomAnchor constant:-10].active = YES;
    [last.centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor].active = YES;
}
@end

__attribute__((constructor)) static void init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSUserDefaults *p = [NSUserDefaults standardUserDefaults];
        NSDate *exp = [p objectForKey:@"RDW_Expiry"];
        
        // إذا لم يكن هناك تاريخ أو التاريخ انتهى: اظهر القفل
        if (!exp || [[NSDate date] compare:exp] == NSOrderedDescending) {
            UIWindow *win = nil;
            if (@available(iOS 13.0, *)) {
                for (UIWindowScene* s in [UIApplication sharedApplication].connectedScenes) {
                    if (s.activationState == UISceneActivationStateForegroundActive) { win = s.windows.firstObject; break; }
                }
            }
            if (!win) win = [UIApplication sharedApplication].windows.firstObject;
            UIViewController *root = win.rootViewController;
            if (root) {
                while (root.presentedViewController) root = root.presentedViewController;
                RDWModernLoginVC *vc = [[RDWModernLoginVC alloc] init];
                vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
                [root presentViewController:vc animated:YES completion:nil];
            }
        }
    });
}
