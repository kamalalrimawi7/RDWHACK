#import <UIKit/UIKit.h>

// --- واجهة الدخول المصممة خصيصاً لمتجر RDW ---
@interface RDWModernLoginVC : UIViewController <UITextFieldDelegate>
@property (nonatomic, retain) UIVisualEffectView *blurView; // التأثير الزجاجي
@property (nonatomic, retain) UIView *alertContainer;       // حاوية الرسالة
@property (nonatomic, retain) UIImageView *logoView;      // لوجو الصقر
@property (nonatomic, retain) UITextField *codeField;
@property (nonatomic, retain) UILabel *devLabel;          // جملة المطوّر كمال
@end

@implementation RDWModernLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // خلفية الصفحة (نصف شفافة)
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5]; 
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext; // لضمان الشفافية
    
    // 1. إنشاء التأثير الزجاجي (Blur) على الخلفية كاملة
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.blurView.frame = self.view.bounds;
    self.blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.blurView];
    
    // 2. إنشاء حاوية الـ Alert (الجزء الأبيض المنسق)
    self.alertContainer = [[UIView alloc] init];
    self.alertContainer.backgroundColor = [UIColor colorWithRed:0.08 green:0.09 blue:0.11 alpha:0.95]; // داكن وراقي
    self.alertContainer.layer.cornerRadius = 20; // حواف ناعمة
    self.alertContainer.clipsToBounds = YES;
    
    // --- إضافة الظلال (Shadows) للحاوية لإعطاء شعور بالعمق ---
    self.alertContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.alertContainer.layer.shadowOffset = CGSizeMake(0, 8);
    self.alertContainer.layer.shadowRadius = 15;
    self.alertContainer.layer.shadowOpacity = 0.6; // ظل قوي وواضح
    self.alertContainer.layer.masksToBounds = NO; // للسماح للظل بالظهور خارج الحواف
    
    [self.view addSubview:self.alertContainer];
    
    // 3. إضافة اللوجو (الصقر الذهبي)
    self.logoView = [[UIImageView alloc] init];
    self.logoView.contentMode = UIViewContentModeScaleAspectFit;
    
    // تحميل الصورة من الرابط المباشر
    NSURL *logoURL = [NSURL URLWithString:@"https://i.ibb.co/68vC0XgS/image.png"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:logoURL];
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.logoView.image = [UIImage imageWithData:data];
            });
        }
    });
    [self.alertContainer addSubview:self.logoView];
    
    // 4. إضافة النصوص (منسقة وعصرية)
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Rimawi Digital World";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.alertContainer addSubview:titleLabel];
    
    UILabel *msgLabel = [[UILabel alloc] init];
    msgLabel.text = @"هذه النسخة حصرية لمتجر Rimawi Digital World\nالرجاء إدخال كود التفعيل للاستمرار:";
    msgLabel.textColor = [UIColor lightGrayColor];
    msgLabel.font = [UIFont systemFontOfSize:14];
    msgLabel.textAlignment = NSTextAlignmentCenter;
    msgLabel.numberOfLines = 2;
    [self.alertContainer addSubview:msgLabel];
    
    // 5. إضافة خانة الكود (منسقة وشفافة)
    self.codeField = [[UITextField alloc] init];
    self.codeField.placeholder = @"أدخل كود RDW هنا...";
    self.codeField.textAlignment = NSTextAlignmentCenter;
    self.codeField.secureTextEntry = YES;
    self.codeField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    self.codeField.textColor = [UIColor whiteColor];
    self.codeField.layer.cornerRadius = 8;
    self.codeField.keyboardType = UIKeyboardTypeNumberPad;
    [self.alertContainer addSubview:self.codeField];
    
    // 6. إضافة زر التفعيل الذهبي
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [loginButton setTitle:@"تفعيل واستمرار" forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [loginButton setBackgroundColor:[UIColor colorWithRed:0.72 green:0.56 blue:0.17 alpha:1.00]]; // ذهبي RDW
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = 8;
    [loginButton addTarget:self action:@selector(attemptLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.alertContainer addSubview:loginButton];
    
    // 7. جملة "تم التفعيل بواسطة المطور كمال" (تحت بخط صغير)
    self.devLabel = [[UILabel alloc] init];
    self.devLabel.text = @"تم التفعيل بواسطة المطوّر كمال © 2026";
    self.devLabel.textColor = [UIColor darkGrayColor];
    self.devLabel.font = [UIFont systemFontOfSize:10];
    self.devLabel.textAlignment = NSTextAlignmentCenter;
    [self.alertContainer addSubview:self.devLabel];
    
    // --- تنسيق العناصر (Auto Layout) ---
    [self layoutModernRDWUI];
}

- (void)layoutModernRDWUI {
    self.alertContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.logoView.translatesAutoresizingMaskIntoConstraints = NO;
    self.codeField.translatesAutoresizingMaskIntoConstraints = NO;
    self.devLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    // إيجاد النصوص والزر من الحاوية لتنسيقهم
    UILabel *titleL = self.alertContainer.subviews[1]; titleL.translatesAutoresizingMaskIntoConstraints = NO;
    UILabel *msgL = self.alertContainer.subviews[2]; msgL.translatesAutoresizingMaskIntoConstraints = NO;
    UIButton *btn = self.alertContainer.subviews[4]; btn.translatesAutoresizingMaskIntoConstraints = NO;

    [NSLayoutConstraint activateConstraints:@[
        // تنسيق الحاوية بالمركز (حجم Alert)
        [self.alertContainer.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.alertContainer.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.alertContainer.widthAnchor constraintEqualToConstant:300], // عرض أكبر ومريح
        [self.alertContainer.heightAnchor constraintEqualToConstant:430], // ارتفاع منسق
        
        // تنسيق اللوجو في الأعلى
        [self.logoView.centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [self.logoView.topAnchor constraintEqualToAnchor:self.alertContainer.topAnchor constant:25],
        [self.logoView.widthAnchor constraintEqualToConstant:120],
        [self.logoView.heightAnchor constraintEqualToConstant:120],
        
        // تنسيق العنوان تحت اللوجو
        [titleL.centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [titleL.topAnchor constraintEqualToAnchor:self.logoView.bottomAnchor constant:15],
        
        // تنسيق نص الحقوق والرسالة
        [msgL.centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [msgL.topAnchor constraintEqualToAnchor:titleL.bottomAnchor constant:10],
        [msgL.widthAnchor constraintEqualToConstant:270],
        
        // تنسيق خانة الكود
        [self.codeField.centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [self.codeField.topAnchor constraintEqualToAnchor:msgL.bottomAnchor constant:20],
        [self.codeField.widthAnchor constraintEqualToConstant:240],
        [self.codeField.heightAnchor constraintEqualToConstant:40],
        
        // تنسيق زر الدخول
        [btn.centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [btn.topAnchor constraintEqualToAnchor:self.codeField.bottomAnchor constant:15],
        [btn.widthAnchor constraintEqualToConstant:160],
        [btn.heightAnchor constraintEqualToConstant:45],

        // تنسيق جملة المطوّر كمال في الأسفل
        [self.devLabel.centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [self.devLabel.bottomAnchor constraintEqualToAnchor:self.alertContainer.bottomAnchor constant:-10]
    ]];
}

- (void)attemptLogin {
    if ([self.codeField.text isEqualToString:@"RDW2026"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.instagram.com/rimawi.dw"] options:@{} completionHandler:nil];
    }
}

// ممنوع إخفاء الصفحة بالسحب
- (BOOL)modalInPresentation { return YES; }
@end

// --- تشغيل التويك عند فتح التطبيق ---
__attribute__((constructor)) static void init() {
    // ثانيتين (2.0) تأخير لضمان استقرار التطبيق
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        RDWModernLoginVC *loginVC = [[RDWModernLoginVC alloc] init];
        
        UIWindow *window = nil;
        for (UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                window = scene.windows.firstObject;
                break;
            }
        }
        if (!window) window = [UIApplication sharedApplication].windows.firstObject;

        UIViewController *root = window.rootViewController;
        if (root) {
            while (root.presentedViewController) root = root.presentedViewController;
            // استخدام OverCurrentContext لضمان ظهور الشفافية
            loginVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [root presentViewController:loginVC animated:YES completion:nil];
        }
    });
}
