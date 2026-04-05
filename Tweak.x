#import <UIKit/UIKit.h>

@interface RDWModernLoginVC : UIViewController
@property (nonatomic, retain) UIView *alertContainer;
@property (nonatomic, retain) UIImageView *logoView;
@property (nonatomic, retain) UITextField *codeField;
@property (nonatomic, retain) UIButton *loginBtn;
@property (nonatomic, retain) UIButton *waBtn;
@end

@implementation RDWModernLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // خلفية شفافة فخمة
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65]; 
    
    // 1. حاوية التنبيه (Glassmorphism Style)
    self.alertContainer = [[UIView alloc] init];
    self.alertContainer.backgroundColor = [UIColor colorWithRed:0.09 green:0.10 blue:0.12 alpha:0.98];
    self.alertContainer.layer.cornerRadius = 25;
    self.alertContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.alertContainer.layer.shadowOffset = CGSizeMake(0, 10);
    self.alertContainer.layer.shadowRadius = 20;
    self.alertContainer.layer.shadowOpacity = 0.8;
    [self.view addSubview:self.alertContainer];
    
    // 2. لوجو الصقر (RDW)
    self.logoView = [[UIImageView alloc] init];
    self.logoView.contentMode = UIViewContentModeScaleAspectFit;
    [self.alertContainer addSubview:self.logoView];
    
    // 3. نصوص المتجر
    UILabel *titleL = [[UILabel alloc] init];
    titleL.text = @"Rimawi Digital World";
    titleL.textColor = [UIColor whiteColor];
    titleL.font = [UIFont boldSystemFontOfSize:20];
    titleL.textAlignment = NSTextAlignmentCenter;
    [self.alertContainer addSubview:titleL];
    
    // 4. خانة الكود (كيبورد كامل حروف وأرقام)
    self.codeField = [[UITextField alloc] init];
    self.codeField.placeholder = @"أدخل كود التفعيل...";
    self.codeField.textAlignment = NSTextAlignmentCenter;
    self.codeField.secureTextEntry = YES;
    self.codeField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    self.codeField.textColor = [UIColor whiteColor];
    self.codeField.layer.cornerRadius = 10;
    self.codeField.keyboardType = UIKeyboardTypeDefault;
    [self.alertContainer addSubview:self.codeField];
    
    // 5. زر التفعيل الذهبي
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.loginBtn setTitle:@"تفعيل واستمرار" forState:UIControlStateNormal];
    [self.loginBtn setBackgroundColor:[UIColor colorWithRed:0.72 green:0.56 blue:0.17 alpha:1.00]];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginBtn.layer.cornerRadius = 10;
    [self.loginBtn addTarget:self action:@selector(attemptLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.alertContainer addSubview:self.loginBtn];
    
    // 6. زر شراء كود (WhatsApp)
    self.waBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.waBtn setTitle:@"شراء كود تفعيل RDW" forState:UIControlStateNormal];
    [self.waBtn setBackgroundColor:[UIColor colorWithRed:0.15 green:0.68 blue:0.38 alpha:1.00]];
    [self.waBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.waBtn.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightBold];
    self.waBtn.layer.cornerRadius = 10;
    [self.waBtn addTarget:self action:@selector(openWhatsApp) forControlEvents:UIControlEventTouchUpInside];
    [self.alertContainer addSubview:self.waBtn];

    [self setupLayout];
    [self loadLogo];
}

- (void)loadLogo {
    NSURL *url = [NSURL URLWithString:@"https://i.ibb.co/68vC0XgS/image.png"];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *res, NSError *err) {
        if (data) dispatch_async(dispatch_get_main_queue(), ^{ self.logoView.image = [UIImage imageWithData:data]; });
    }] resume];
}

- (void)setupLayout {
    self.alertContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.logoView.translatesAutoresizingMaskIntoConstraints = NO;
    self.codeField.translatesAutoresizingMaskIntoConstraints = NO;
    self.loginBtn.translatesAutoresizingMaskIntoConstraints = NO;
    self.waBtn.translatesAutoresizingMaskIntoConstraints = NO;
    for (UIView *v in self.alertContainer.subviews) v.translatesAutoresizingMaskIntoConstraints = NO;

    [NSLayoutConstraint activateConstraints:@[
        [self.alertContainer.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.alertContainer.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.alertContainer.widthAnchor constraintEqualToConstant:300],
        [self.alertContainer.heightAnchor constraintEqualToConstant:480],
        
        [self.logoView.centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [self.logoView.topAnchor constraintEqualToAnchor:self.alertContainer.topAnchor constant:25],
        [self.logoView.widthAnchor constraintEqualToConstant:110],
        [self.logoView.heightAnchor constraintEqualToConstant:110],
        
        [self.alertContainer.subviews[2].topAnchor constraintEqualToAnchor:self.logoView.bottomAnchor constant:10],
        [self.alertContainer.subviews[2].centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        
        [self.codeField.centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [self.codeField.topAnchor constraintEqualToAnchor:self.logoView.bottomAnchor constant:70],
        [self.codeField.widthAnchor constraintEqualToConstant:250],
        [self.codeField.heightAnchor constraintEqualToConstant:42],
        
        [self.loginBtn.topAnchor constraintEqualToAnchor:self.codeField.bottomAnchor constant:15],
        [self.loginBtn.centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [self.loginBtn.widthAnchor constraintEqualToConstant:180],
        [self.loginBtn.heightAnchor constraintEqualToConstant:48],
        
        [self.waBtn.topAnchor constraintEqualToAnchor:self.loginBtn.bottomAnchor constant:12],
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
    NSString *urlStr = @"https://wa.me/972567171874?text=%D8%A3%D8%B1%D9%8A%D8%AF%20%D8%B4%D8%B1%D8%A7%D8%A1%20%D9%83%D9%88%D8%AF%20%D8%AA%D9%81%D8%B9%D9%8A%D9%84%20%D9%84%D9%85%D8%AA%D8%AC%D8%B1%20RDW";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
}

- (BOOL)modalInPresentation { return YES; }
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

        UIViewController *root = window.rootViewController;
        if (root) {
            while (root.presentedViewController) root = root.presentedViewController;
            RDWModernLoginVC *vc = [[RDWModernLoginVC alloc] init];
            vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [root presentViewController:vc animated:YES completion:nil];
        }
    });
}
