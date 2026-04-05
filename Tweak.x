#import <UIKit/UIKit.h>

@interface RDWModernLoginVC : UIViewController
@property (nonatomic, retain) UIView *alertContainer;
@property (nonatomic, retain) UIImageView *logoView;
@property (nonatomic, retain) UITextField *codeField;
@property (nonatomic, retain) UIButton *loginBtn; // أعطيناه اسم
@property (nonatomic, retain) UIButton *waBtn;    // أعطيناه اسم
@end

@implementation RDWModernLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65]; 

    // 1. الحاوية
    self.alertContainer = [[UIView alloc] init];
    self.alertContainer.backgroundColor = [UIColor colorWithRed:0.09 green:0.10 blue:0.12 alpha:0.98];
    self.alertContainer.layer.cornerRadius = 25;
    [self.view addSubview:self.alertContainer];

    // 2. اللوجو (مع معالجة آمنة للبيانات)
    self.logoView = [[UIImageView alloc] init];
    self.logoView.contentMode = UIViewContentModeScaleAspectFit;
    [self.alertContainer addSubview:self.logoView];

    // 3. خانة الكود
    self.codeField = [[UITextField alloc] init];
    self.codeField.placeholder = @"أدخل كود RDW...";
    self.codeField.textAlignment = NSTextAlignmentCenter;
    self.codeField.secureTextEntry = YES;
    self.codeField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    self.codeField.textColor = [UIColor whiteColor];
    self.codeField.layer.cornerRadius = 10;
    [self.alertContainer addSubview:self.codeField];

    // 4. زر التفعيل
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.loginBtn setTitle:@"تفعيل واستمرار" forState:UIControlStateNormal];
    [self.loginBtn setBackgroundColor:[UIColor colorWithRed:0.72 green:0.56 blue:0.17 alpha:1.00]];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginBtn.layer.cornerRadius = 10;
    [self.loginBtn addTarget:self action:@selector(attemptLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.alertContainer addSubview:self.loginBtn];

    // 5. زر الواتساب
    self.waBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.waBtn setTitle:@"شراء كود تفعيل RDW" forState:UIControlStateNormal];
    [self.waBtn setBackgroundColor:[UIColor colorWithRed:0.15 green:0.68 blue:0.38 alpha:1.00]];
    [self.waBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.waBtn.layer.cornerRadius = 10;
    [self.waBtn addTarget:self action:@selector(openWhatsApp) forControlEvents:UIControlEventTouchUpInside];
    [self.alertContainer addSubview:self.waBtn];

    [self setupLayout];
    [self loadLogo]; // استدعاء منفصل ومنظم للصورة
}

- (void)loadLogo {
    NSString *imgUrl = @"https://i.ibb.co/68vC0XgS/image.png";
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:imgUrl] completionHandler:^(NSData *data, NSURLResponse *res, NSError *err) {
        if (data && !err) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.logoView.image = [UIImage imageWithData:data];
            });
        }
    }] resume];
}

- (void)setupLayout {
    // تفعيل الـ Constraints لكل عنصر باسمه (أضمن طريقة لمنع الكراش)
    self.alertContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.logoView.translatesAutoresizingMaskIntoConstraints = NO;
    self.codeField.translatesAutoresizingMaskIntoConstraints = NO;
    self.loginBtn.translatesAutoresizingMaskIntoConstraints = NO;
    self.waBtn.translatesAutoresizingMaskIntoConstraints = NO;

    [NSLayoutConstraint activateConstraints:@[
        [self.alertContainer.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.alertContainer.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.alertContainer.widthAnchor constraintEqualToConstant:300],
        [self.alertContainer.heightAnchor constraintEqualToConstant:460],
        
        [self.logoView.centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [self.logoView.topAnchor constraintEqualToAnchor:self.alertContainer.topAnchor constant:25],
        [self.logoView.widthAnchor constraintEqualToConstant:110],
        [self.logoView.heightAnchor constraintEqualToConstant:110],
        
        [self.codeField.centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [self.codeField.topAnchor constraintEqualToAnchor:self.logoView.bottomAnchor constant:40],
        [self.codeField.widthAnchor constraintEqualToConstant:250],
        [self.codeField.heightAnchor constraintEqualToConstant:40],
        
        [self.loginBtn.topAnchor constraintEqualToAnchor:self.codeField.bottomAnchor constant:20],
        [self.loginBtn.centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [self.loginBtn.widthAnchor constraintEqualToConstant:200],
        [self.loginBtn.heightAnchor constraintEqualToConstant:45],
        
        [self.waBtn.topAnchor constraintEqualToAnchor:self.loginBtn.bottomAnchor constant:15],
        [self.waBtn.centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [self.waBtn.widthAnchor constraintEqualToConstant:230],
        [self.waBtn.heightAnchor constraintEqualToConstant:40]
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = nil;
        for (UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                window = scene.windows.firstObject;
                break;
            }
        }
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
