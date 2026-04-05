#import <UIKit/UIKit.h>

@interface RDWModernLoginVC : UIViewController <UITextFieldDelegate>
@property (nonatomic, retain) UIView *alertContainer;
@property (nonatomic, retain) UIImageView *logoView;
@property (nonatomic, retain) UITextField *codeField;
@end

@implementation RDWModernLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // خلفية شفافة مع تعتيم فخم
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65]; 
    
    // 1. حاوية التنبيه (تصميم زجاجي داكن بظلال قوية)
    self.alertContainer = [[UIView alloc] init];
    self.alertContainer.backgroundColor = [UIColor colorWithRed:0.09 green:0.10 blue:0.12 alpha:0.98];
    self.alertContainer.layer.cornerRadius = 25;
    self.alertContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.alertContainer.layer.shadowOffset = CGSizeMake(0, 12);
    self.alertContainer.layer.shadowRadius = 25;
    self.alertContainer.layer.shadowOpacity = 0.9;
    [self.view addSubview:self.alertContainer];
    
    // 2. جلب لوجو الصقر الذهبي (RDW) من الرابط المباشر
    self.logoView = [[UIImageView alloc] init];
    self.logoView.contentMode = UIViewModeScaleAspectFit;
    NSString *imgUrl = @"https://i.ibb.co/68vC0XgS/image.png";
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:imgUrl] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.logoView.image = [UIImage imageWithData:data];
            });
        }
    }];
    [task resume];
    [self.alertContainer addSubview:self.logoView];
    
    // 3. نصوص متجر RDW
    UILabel *titleL = [[UILabel alloc] init];
    titleL.text = @"Rimawi Digital World";
    titleL.textColor = [UIColor whiteColor];
    titleL.font = [UIFont boldSystemFontOfSize:20];
    titleL.textAlignment = NSTextAlignmentCenter;
    [self.alertContainer addSubview:titleL];

    UILabel *msgL = [[UILabel alloc] init];
    msgL.text = @"هذه النسخة حصرية لمتجر RDW\nيرجى تفعيل الكود للاستمرار";
    msgL.textColor = [UIColor lightGrayColor];
    msgL.font = [UIFont systemFontOfSize:14];
    msgL.numberOfLines = 2;
    msgL.textAlignment = NSTextAlignmentCenter;
    [self.alertContainer addSubview:msgL];
    
    // 4. خانة الكود (كيبورد كامل - حروف وأرقام)
    self.codeField = [[UITextField alloc] init];
    self.codeField.placeholder = @"أدخل الكود هنا...";
    self.codeField.textAlignment = NSTextAlignmentCenter;
    self.codeField.secureTextEntry = YES;
    self.codeField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    self.codeField.textColor = [UIColor whiteColor];
    self.codeField.layer.cornerRadius = 10;
    self.codeField.keyboardType = UIKeyboardTypeDefault; 
    [self.alertContainer addSubview:self.codeField];
    
    // 5. زر التفعيل الذهبي
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [loginBtn setTitle:@"تفعيل واستمرار" forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [loginBtn setBackgroundColor:[UIColor colorWithRed:0.72 green:0.56 blue:0.17 alpha:1.00]];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 10;
    [loginBtn addTarget:self action:@selector(attemptLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.alertContainer addSubview:loginBtn];
    
    // 6. زر شراء الكود المحدث (WhatsApp)
    UIButton *waBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [waBtn setTitle:@"شراء كود تفعيل RDW" forState:UIControlStateNormal];
    [waBtn setBackgroundColor:[UIColor colorWithRed:0.15 green:0.68 blue:0.38 alpha:1.00]];
    [waBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    waBtn.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightBold];
    waBtn.layer.cornerRadius = 10;
    [waBtn addTarget:self action:@selector(openWhatsApp) forControlEvents:UIControlEventTouchUpInside];
    [self.alertContainer addSubview:waBtn];
    
    // 7. توقيع المطور كمال
    UILabel *devL = [[UILabel alloc] init];
    devL.text = @"تم التفعيل بواسطة المطور كمال © 2026";
    devL.textColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    devL.font = [UIFont systemFontOfSize:10];
    devL.textAlignment = NSTextAlignmentCenter;
    [self.alertContainer addSubview:devL];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    self.alertContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.logoView.translatesAutoresizingMaskIntoConstraints = NO;
    self.codeField.translatesAutoresizingMaskIntoConstraints = NO;
    for (UIView *v in self.alertContainer.subviews) v.translatesAutoresizingMaskIntoConstraints = NO;

    [NSLayoutConstraint activateConstraints:@[
        [self.alertContainer.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.alertContainer.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.alertContainer.widthAnchor constraintEqualToConstant:300],
        [self.alertContainer.heightAnchor constraintEqualToConstant:490],
        
        [self.logoView.centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [self.logoView.topAnchor constraintEqualToAnchor:self.alertContainer.topAnchor constant:25],
        [self.logoView.widthAnchor constraintEqualToConstant:120],
        [self.logoView.heightAnchor constraintEqualToConstant:120],
        
        [self.codeField.centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [self.codeField.topAnchor constraintEqualToAnchor:self.alertContainer.subviews[2].bottomAnchor constant:75],
        [self.codeField.widthAnchor constraintEqualToConstant:250],
        [self.codeField.heightAnchor constraintEqualToConstant:42],
        
        [self.alertContainer.subviews[4].topAnchor constraintEqualToAnchor:self.codeField.bottomAnchor constant:15],
        [self.alertContainer.subviews[4].centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [self.alertContainer.subviews[4].widthAnchor constraintEqualToConstant:180],
        [self.alertContainer.subviews[4].heightAnchor constraintEqualToConstant:48],
        
        [self.alertContainer.subviews[5].topAnchor constraintEqualToAnchor:self.alertContainer.subviews[4].bottomAnchor constant:12],
        [self.alertContainer.subviews[5].centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [self.alertContainer.subviews[5].widthAnchor constraintEqualToConstant:230],
        [self.alertContainer.subviews[5].heightAnchor constraintEqualToConstant:40],

        [self.alertContainer.subviews[6].bottomAnchor constraintEqualToAnchor:self.alertContainer.bottomAnchor constant:-12],
        [self.alertContainer.subviews[6].centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor]
    ]];
}

- (void)attemptLogin {
    if ([self.codeField.text isEqualToString:@"RDW2026"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.instagram.com/rimawi.dw"] options:@{} completionHandler:nil];
    }
}

- (void)openWhatsApp {
    NSString *urlStr = @"https://wa.me/972567171874?text=أريد+شراء+كود+تفعيل+لمتجر+RDW"; 
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
}

- (BOOL)modalInPresentation { return YES; }
@end

__attribute__((constructor)) static void init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        RDWModernLoginVC *vc = [[RDWModernLoginVC alloc] init];
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        UIViewController *root = window.rootViewController;
        if (root) {
            while (root.presentedViewController) root = root.presentedViewController;
            vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [root presentViewController:vc animated:YES completion:nil];
        }
    });
}
