#import <UIKit/UIKit.h>

@interface RDWModernLoginVC : UIViewController
@property (nonatomic, retain) UIView *alertContainer;
@property (nonatomic, retain) UIImageView *logoView;
@property (nonatomic, retain) UITextField *codeField;
@end

@implementation RDWModernLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65]; 
    
    self.alertContainer = [[UIView alloc] init];
    self.alertContainer.backgroundColor = [UIColor colorWithRed:0.09 green:0.10 blue:0.12 alpha:0.98];
    self.alertContainer.layer.cornerRadius = 25;
    self.alertContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.alertContainer.layer.shadowOffset = CGSizeMake(0, 10);
    self.alertContainer.layer.shadowOpacity = 0.8;
    [self.view addSubview:self.alertContainer];
    
    self.logoView = [[UIImageView alloc] init];
    // السطر اللي كان عامل المشكلة صلحته هون:
    self.logoView.contentMode = UIViewContentModeScaleAspectFit; 
    
    NSURL *url = [NSURL URLWithString:@"https://i.ibb.co/68vC0XgS/image.png"];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *res, NSError *err) {
        if (data) dispatch_async(dispatch_get_main_queue(), ^{ self.logoView.image = [UIImage imageWithData:data]; });
    }] resume];
    [self.alertContainer addSubview:self.logoView];
    
    self.codeField = [[UITextField alloc] init];
    self.codeField.placeholder = @"كود التفعيل...";
    self.codeField.textAlignment = NSTextAlignmentCenter;
    self.codeField.secureTextEntry = YES;
    self.codeField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    self.codeField.textColor = [UIColor whiteColor];
    self.codeField.layer.cornerRadius = 10;
    self.codeField.keyboardType = UIKeyboardTypeDefault; 
    [self.alertContainer addSubview:self.codeField];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [loginBtn setTitle:@"تفعيل واستمرار" forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:[UIColor colorWithRed:0.72 green:0.56 blue:0.17 alpha:1.00]];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 10;
    [loginBtn addTarget:self action:@selector(attemptLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.alertContainer addSubview:loginBtn];
    
    UIButton *waBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [waBtn setTitle:@"شراء كود تفعيل RDW" forState:UIControlStateNormal];
    [waBtn setBackgroundColor:[UIColor colorWithRed:0.15 green:0.68 blue:0.38 alpha:1.00]];
    [waBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    waBtn.layer.cornerRadius = 10;
    [waBtn addTarget:self action:@selector(openWhatsApp) forControlEvents:UIControlEventTouchUpInside];
    [self.alertContainer addSubview:waBtn];

    [self setupLayout];
}

- (void)setupLayout {
    self.alertContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.logoView.translatesAutoresizingMaskIntoConstraints = NO;
    self.codeField.translatesAutoresizingMaskIntoConstraints = NO;
    for (UIView *v in self.alertContainer.subviews) v.translatesAutoresizingMaskIntoConstraints = NO;

    [NSLayoutConstraint activateConstraints:@[
        [self.alertContainer.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.alertContainer.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.alertContainer.widthAnchor constraintEqualToConstant:300],
        [self.alertContainer.heightAnchor constraintEqualToConstant:450],
        
        [self.logoView.centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [self.logoView.topAnchor constraintEqualToAnchor:self.alertContainer.topAnchor constant:20],
        [self.logoView.widthAnchor constraintEqualToConstant:100],
        [self.logoView.heightAnchor constraintEqualToConstant:100],
        
        [self.codeField.centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [self.codeField.topAnchor constraintEqualToAnchor:self.logoView.bottomAnchor constant:30],
        [self.codeField.widthAnchor constraintEqualToConstant:240],
        [self.codeField.heightAnchor constraintEqualToConstant:40],
        
        [self.alertContainer.subviews[3].topAnchor constraintEqualToAnchor:self.codeField.bottomAnchor constant:15],
        [self.alertContainer.subviews[3].centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [self.alertContainer.subviews[3].widthAnchor constraintEqualToConstant:160],
        [self.alertContainer.subviews[3].heightAnchor constraintEqualToConstant:45],
        
        [self.alertContainer.subviews[4].topAnchor constraintEqualToAnchor:self.alertContainer.subviews[3].bottomAnchor constant:10],
        [self.alertContainer.subviews[4].centerXAnchor constraintEqualToAnchor:self.alertContainer.centerXAnchor],
        [self.alertContainer.subviews[4].widthAnchor constraintEqualToConstant:220],
        [self.alertContainer.subviews[4].heightAnchor constraintEqualToConstant:40]
    ]];
}

- (void)attemptLogin {
    if ([self.codeField.text isEqualToString:@"RDW2026"]) [self dismissViewControllerAnimated:YES completion:nil];
    else [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.instagram.com/rimawi.dw"] options:@{} completionHandler:nil];
}

- (void)openWhatsApp {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://wa.me/972567171874?text=أريد+شراء+كود+تفعيل+RDW"] options:@{} completionHandler:nil];
}
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
