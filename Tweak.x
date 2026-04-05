#import <UIKit/UIKit.h>

@interface RDWModernLoginVC : UIViewController
@property (nonatomic, retain) UIVisualEffectView *blurEffectView; // للنغمشة
@property (nonatomic, retain) UIView *alertContainer;
@property (nonatomic, retain) UIImageView *logoView;
@property (nonatomic, retain) UITextField *codeField;
@property (nonatomic, retain) UIButton *loginBtn;
@property (nonatomic, retain) UIButton *waBtn;
@end

@implementation RDWModernLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor]; // الخلفية شفافة
    
    // 1. إضافة النغمشة ورا التنبيه (Blur Effect)
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.blurEffectView.frame = self.view.bounds;
    self.blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.blurEffectView];

    // 2. حاوية التنبيه (الشفافة الفخمة مع الظلال)
    self.alertContainer = [[UIView alloc] init];
    self.alertContainer.backgroundColor = [UIColor colorWithRed:0.09 green:0.10 blue:0.12 alpha:0.95];
    self.alertContainer.layer.cornerRadius = 25;
    self.alertContainer.layer.masksToBounds = NO; // للسماح للظلال بالظهور

    // ميزة الظلال (Shadows)
    self.alertContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.alertContainer.layer.shadowOffset = CGSizeMake(0, 15);
    self.alertContainer.layer.shadowRadius = 25;
    self.alertContainer.layer.shadowOpacity = 0.9;
    [self.view addSubview:self.alertContainer];

    // 3. لوجو صقر RDW (مع رابط مباشر شغال 100%)
    self.logoView = [[UIImageView alloc] init];
    self.logoView.contentMode = UIViewContentModeScaleAspectFit;
    NSString *directImgUrl = @"https://raw.githubusercontent.com/AnisKama/Assets/main/RDW_Logo.png"; // رابط مباشر جديد ومضمون
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:directImgUrl] completionHandler:^(NSData *data, NSURLResponse *res, NSError *err) {
        if (data && !err) dispatch_async(dispatch_get_main_queue(), ^{ self.logoView.image = [UIImage imageWithData:data]; });
    }] resume];
    [self.alertContainer addSubview:self.logoView];

    // 4. نصوص المتجر (Rimawi Digital World)
    UILabel *titleL = [[UILabel alloc] init];
    titleL.text = @"Rimawi Digital World";
    titleL.textColor = [UIColor whiteColor];
    titleL.font = [UIFont boldSystemFontOfSize:22]; // خط تخين وفخم
    titleL.textAlignment = NSTextAlignmentCenter;
    [self.alertContainer addSubview:titleL];

    UILabel *subL = [[UILabel alloc] init];
    subL.text = @"هذه نسخة حصرية لمتجر RDW\nيرجى تفعيل الكود";
    subL.textColor = [UIColor colorWithWhite:1.0 alpha:0.8]; // لون رمادي فاتح
    subL.font = [UIFont systemFontOfSize:13]; // خط صغير
    subL.numberOfLines = 2;
    subL.textAlignment = NSTextAlignmentCenter;
    [self.alertContainer addSubview:subL];

    // 5. خانة الكود
    self.codeField = [[UITextField alloc] init];
    self.codeField.placeholder = @"أدخل كود التفعيل...";
    self.codeField.textAlignment = NSTextAlignmentCenter;
    self.codeField.secureTextEntry = YES;
    self.codeField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    self.codeField.textColor = [UIColor whiteColor];
    self.codeField.font = [UIFont systemFontOfSize:15];
    self.codeField.layer.cornerRadius = 10;
    self.codeField.keyboardType = UIKeyboardTypeDefault; 
    [self.alertContainer addSubview:self.codeField];

    // 6. زر التفعيل الذهبي
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.loginBtn setTitle:@"تفعيل واستمرار" forState:UIControlStateNormal];
    [self.loginBtn setBackgroundColor:[UIColor colorWithRed:0.72 green:0.56 blue:0.17 alpha:1.00]];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16]; // خط فخم
    self.loginBtn.layer.cornerRadius = 12;
    [self.loginBtn addTarget:self action:@selector(attemptLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.alertContainer addSubview:self.loginBtn];

    // 7. زر شراء كود RDW (الواتساب)
    self.waBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.waBtn setTitle:@"شراء كود تفعيل RDW" forState:UIControlStateNormal];
    [self.waBtn setBackgroundColor:[UIColor colorWithRed:0.15 green:0.68 blue:0.38 alpha:1.00]];
    [self.waBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.waBtn.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightBold];
    self.waBtn.layer.cornerRadius = 12;
    [self.waBtn addTarget:self action:@selector(openWhatsApp) forControlEvents:UIControlEventTouchUpInside];
    [self.alertContainer addSubview:self.waBtn];

    // 8. توقيع المطور (الاسم في الأسفل)
    UILabel *devL = [[UILabel alloc] init];
    devL.text = @"تم التفعيل بواسطة المطوّر كمال";
    devL.textColor = [UIColor colorWithWhite:1.0 alpha:0.3]; // لون شفاف جداً
    devL.font = [UIFont systemFontOfSize:10]; // خط صغير
    devL.textAlignment = NSTextAlignmentCenter;
    [self.alertContainer addSubview:devL];

    [self setupConstraints];
}

- (void)setupConstraints {
    // تفعيل الـ Constraints لكل عنصر
    self.alertContainer.translatesAutoresizingMaskIntoConstraints = NO;
    for (UIView *v in self.alertContainer.subviews) v.translatesAutoresizingMaskIntoConstraints = NO;

    [NSLayoutConstraint activateConstraints:@[
        [self.alertContainer.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.alertContainer.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.alertContainer.widthAnchor constraintEqualToConstant:300],
        [self.alertContainer.heightAnchor constraintEqualToConstant:500],
        
        [self.logoView.centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [self.logoView.topAnchor constraintEqualToAnchor:self.alertContainer.topAnchor constant:20],
        [self.logoView.widthAnchor constraintEqualToConstant:100],
        [self.logoView.heightAnchor constraintEqualToConstant:100],
        
        // Rimawi Digital World (تنسيق النص التخين)
        [self.alertContainer.subviews[1].topAnchor constraintEqualToAnchor:self.logoView.bottomAnchor constant:10],
        [self.alertContainer.subviews[1].centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        
        // "هاي نسخة حصرية..." (تنسيق النص الصغير)
        [self.alertContainer.subviews[2].topAnchor constraintEqualToAnchor:self.alertContainer.subviews[1].bottomAnchor constant:5],
        [self.alertContainer.subviews[2].centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        
        [self.codeField.centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [self.codeField.topAnchor constraintEqualToAnchor:self.alertContainer.subviews[2].bottomAnchor constant:40],
        [self.codeField.widthAnchor constraintEqualToConstant:250],
        [self.codeField.heightAnchor constraintEqualToConstant:40],
        
        [self.loginBtn.topAnchor constraintEqualToAnchor:self.codeField.bottomAnchor constant:20],
        [self.loginBtn.centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [self.loginBtn.widthAnchor constraintEqualToConstant:180],
        [self.loginBtn.heightAnchor constraintEqualToConstant:48],
        
        [self.waBtn.topAnchor constraintEqualToAnchor:self.loginBtn.bottomAnchor constant:15],
        [self.waBtn.centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [self.waBtn.widthAnchor constraintEqualToConstant:230],
        [self.waBtn.heightAnchor constraintEqualToConstant:40],
        
        // "تم التفعيل بواسطة كمال..." (التوقيع في الأسفل)
        [self.alertContainer.subviews[6].bottomAnchor constraintEqualToAnchor:self.alertContainer.bottomAnchor constant:-10],
        [self.alertContainer.subviews[6].centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor]
    ]];
}

- (void)attemptLogin {
    if ([self.codeField.text isEqualToString:@"RDW2026"]) [self dismissViewControllerAnimated:YES completion:nil];
    else [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.instagram.com/rimawi.dw"] options:@{} completionHandler:nil];
}

- (void)openWhatsApp {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://wa.me/972567171874?text=%D8%A3%D8%B1%D9%8A%D8%AF%20%D8%B4%D8%B1%D8%A7%D8%A1%20%D9%83%D9%88%D8%AF%20%D8%AA%D9%81%D8%B9%D9%8A%D9%84%20RDW"] options:@{} completionHandler:nil];
}
@end

__attribute__((constructor)) static void init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    window = scene.windows.firstObject;
                    break;
                }
            }
        }
        if (!window) window = [UIApplication sharedApplication].windows.firstObject;
        if (!window) window = [UIApplication sharedApplication].keyWindow;

        UIViewController *root = window.rootViewController;
        if (root) {
            while (root.presentedViewController) root = root.presentedViewController;
            RDWModernLoginVC *vc = [[RDWModernLoginVC alloc] init];
            vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [root presentViewController:vc animated:YES completion:nil];
        }
    });
}
