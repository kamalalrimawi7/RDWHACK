#import <UIKit/UIKit.h>

@interface RDWModernLoginVC : UIViewController
@property (nonatomic, retain) UIVisualEffectView *blurView;
@property (nonatomic, retain) UIView *alertContainer;
@property (nonatomic, retain) UIImageView *logoView;
@property (nonatomic, retain) UITextField *codeField;
@property (nonatomic, retain) UIButton *loginBtn;
@property (nonatomic, retain) UIButton *waBtn;
@end

@implementation RDWModernLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];

    // 1. إضافة تأثير النغمشة (Blur) على كامل الشاشة خلف التنبيه
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.blurView.frame = self.view.bounds;
    self.blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.blurView];

    // 2. حاوية التنبيه مع زوايا دائرية وظلال عميقة
    self.alertContainer = [[UIView alloc] init];
    self.alertContainer.backgroundColor = [UIColor colorWithRed:0.07 green:0.08 blue:0.10 alpha:0.96];
    self.alertContainer.layer.cornerRadius = 25;
    self.alertContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.alertContainer.layer.shadowOffset = CGSizeMake(0, 15);
    self.alertContainer.layer.shadowRadius = 20;
    self.alertContainer.layer.shadowOpacity = 0.8;
    [self.view addSubview:self.alertContainer];

    // 3. اللوجو (باستخدام الرابط المباشر الذي زودتني به)
    self.logoView = [[UIImageView alloc] init];
    self.logoView.contentMode = UIViewContentModeScaleAspectFit;
    NSString *imgUrl = @"https://i.ibb.co/7xZ41GWF/IMG-3601.jpg";
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:imgUrl] completionHandler:^(NSData *data, NSURLResponse *res, NSError *err) {
        if (data) dispatch_async(dispatch_get_main_queue(), ^{ self.logoView.image = [UIImage imageWithData:data]; });
    }] resume];
    [self.alertContainer addSubview:self.logoView];

    // 4. النصوص والهوية الحصرية
    UILabel *titleL = [[UILabel alloc] init];
    titleL.text = @"Rimawi Digital World";
    titleL.textColor = [UIColor whiteColor];
    titleL.font = [UIFont boldSystemFontOfSize:22];
    titleL.textAlignment = NSTextAlignmentCenter;
    [self.alertContainer addSubview:titleL];

    UILabel *subL = [[UILabel alloc] init];
    subL.text = @"هذه نسخة حصرية لمتجر Rimawi Digital World\nيرجى تفعيل الكود للاستمرار";
    subL.textColor = [UIColor colorWithWhite:1.0 alpha:0.7];
    subL.font = [UIFont systemFontOfSize:12];
    subL.numberOfLines = 2;
    subL.textAlignment = NSTextAlignmentCenter;
    [self.alertContainer addSubview:subL];

    // 5. خانة إدخال كود التفعيل
    self.codeField = [[UITextField alloc] init];
    self.codeField.placeholder = @"أدخل كود التفعيل...";
    self.codeField.textAlignment = NSTextAlignmentCenter;
    self.codeField.secureTextEntry = YES;
    self.codeField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    self.codeField.textColor = [UIColor whiteColor];
    self.codeField.layer.cornerRadius = 12;
    self.codeField.keyboardType = UIKeyboardTypeDefault;
    [self.alertContainer addSubview:self.codeField];

    // 6. الأزرار (تفعيل + واتساب)
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.loginBtn setTitle:@"تفعيل واستمرار" forState:UIControlStateNormal];
    [self.loginBtn setBackgroundColor:[UIColor colorWithRed:0.72 green:0.56 blue:0.17 alpha:1.00]];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.loginBtn.layer.cornerRadius = 12;
    [self.loginBtn addTarget:self action:@selector(attemptLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.alertContainer addSubview:self.loginBtn];

    self.waBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.waBtn setTitle:@"شراء كود تفعيل RDW" forState:UIControlStateNormal];
    [self.waBtn setBackgroundColor:[UIColor colorWithRed:0.15 green:0.68 blue:0.38 alpha:1.00]];
    [self.waBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.waBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.waBtn.layer.cornerRadius = 12;
    [self.waBtn addTarget:self action:@selector(openWA) forControlEvents:UIControlEventTouchUpInside];
    [self.alertContainer addSubview:self.waBtn];

    // 7. توقيع المطور (بخط صغير وأنيق في الأسفل)
    UILabel *devL = [[UILabel alloc] init];
    devL.text = @"تم التفعيل بواسطة المطوّر كمال";
    devL.textColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    devL.font = [UIFont systemFontOfSize:10];
    devL.textAlignment = NSTextAlignmentCenter;
    [self.alertContainer addSubview:devL];

    [self setupConstraints];
}

- (void)setupConstraints {
    self.alertContainer.translatesAutoresizingMaskIntoConstraints = NO;
    for (UIView *v in self.alertContainer.subviews) v.translatesAutoresizingMaskIntoConstraints = NO;

    [NSLayoutConstraint activateConstraints:@[
        [self.alertContainer.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.alertContainer.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.alertContainer.widthAnchor constraintEqualToConstant:300],
        [self.alertContainer.heightAnchor constraintEqualToConstant:510],

        [self.logoView.centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [self.logoView.topAnchor constraintEqualToAnchor:self.alertContainer.topAnchor constant:25],
        [self.logoView.widthAnchor constraintEqualToConstant:100],
        [self.logoView.heightAnchor constraintEqualToConstant:100],

        [self.alertContainer.subviews[1].topAnchor constraintEqualToAnchor:self.logoView.bottomAnchor constant:10],
        [self.alertContainer.subviews[1].centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],

        [self.alertContainer.subviews[2].topAnchor constraintEqualToAnchor:self.alertContainer.subviews[1].bottomAnchor constant:5],
        [self.alertContainer.subviews[2].centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],

        [self.codeField.centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [self.codeField.topAnchor constraintEqualToAnchor:self.alertContainer.subviews[2].bottomAnchor constant:35],
        [self.codeField.widthAnchor constraintEqualToConstant:250],
        [self.codeField.heightAnchor constraintEqualToConstant:40],

        [self.loginBtn.topAnchor constraintEqualToAnchor:self.codeField.bottomAnchor constant:20],
        [self.loginBtn.centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [self.loginBtn.widthAnchor constraintEqualToConstant:180],
        [self.loginBtn.heightAnchor constraintEqualToConstant:48],

        [self.waBtn.topAnchor constraintEqualToAnchor:self.loginBtn.bottomAnchor constant:12],
        [self.waBtn.centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [self.waBtn.widthAnchor constraintEqualToConstant:230],
        [self.waBtn.heightAnchor constraintEqualToConstant:40],

        [self.alertContainer.subviews[6].bottomAnchor constraintEqualToAnchor:self.alertContainer.bottomAnchor constant:-12],
        [self.alertContainer.subviews[6].centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor]
    ]];
}

- (void)attemptLogin {
    if ([self.codeField.text isEqualToString:@"RDW2026"]) [self dismissViewControllerAnimated:YES completion:nil];
    else [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.instagram.com/rimawi.dw"] options:@{} completionHandler:nil];
}

- (void)openWA {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://wa.me/972567171874?text=%D8%A3%D8%B1%D9%8A%D8%AF%20%D8%B4%D8%B1%D8%A7%D8%A1%20%D9%83%D9%88%D8%AF%20%D8%AA%D9%81%D8%B9%D9%8A%D9%84%20RDW"] options:@{} completionHandler:nil];
}
@end

__attribute__((constructor)) static void init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
    });
}
