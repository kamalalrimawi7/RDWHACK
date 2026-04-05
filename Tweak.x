#import <UIKit/UIKit.h>

@interface RDWLoginViewController : UIViewController
@property (nonatomic, retain) UITextField *codeField;
@property (nonatomic, retain) UIImageView *logoView;
@property (nonatomic, retain) UILabel *devLabel;
@end

@implementation RDWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // خلفية داكنة ملكية
    self.view.backgroundColor = [UIColor colorWithRed:0.04 green:0.05 blue:0.06 alpha:1.00];
    self.modalPresentationStyle = UIModalPresentationFullScreen;

    CGFloat screenWidth = self.view.frame.size.width;

    // 1. لوجو الصقر الذهبي (تنسيق الحجم والظل)
    self.logoView = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth-260)/2, 90, 260, 260)];
    self.logoView.contentMode = UIViewContentModeScaleAspectFit;
    self.logoView.layer.shadowColor = [UIColor colorWithRed:0.72 green:0.56 blue:0.17 alpha:0.8].CGColor;
    self.logoView.layer.shadowRadius = 20;
    self.logoView.layer.shadowOpacity = 0.4;
    
    NSURL *url = [NSURL URLWithString:@"https://i.ibb.co/7xZ41GWF/IMG-3601.jpg"];
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        if(data){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.logoView.image = [UIImage imageWithData:data];
            });
        }
    });
    [self.view addSubview:self.logoView];

    // 2. بصمة المطور (كمال)
    self.devLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 360, screenWidth-40, 30)];
    self.devLabel.text = @"تم التفعيل بواسطة المطور كمال";
    self.devLabel.textColor = [UIColor colorWithRed:0.85 green:0.75 blue:0.50 alpha:1.00];
    self.devLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:19];
    self.devLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.devLabel];

    // 3. خانة الكود (تصميم عصري)
    self.codeField = [[UITextField alloc] initWithFrame:CGRectMake((screenWidth-280)/2, 410, 280, 50)];
    self.codeField.placeholder = @"كود تفعيل RDW";
    self.codeField.textAlignment = NSTextAlignmentCenter;
    self.codeField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.07];
    self.codeField.textColor = [UIColor whiteColor];
    self.codeField.layer.cornerRadius = 12;
    self.codeField.layer.borderWidth = 1;
    self.codeField.layer.borderColor = [UIColor colorWithRed:0.72 green:0.56 blue:0.17 alpha:0.2].CGColor;
    self.codeField.secureTextEntry = YES;
    [self.view addSubview:self.codeField];

    // 4. زر التفعيل
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake((screenWidth-200)/2, 480, 200, 55);
    [btn setTitle:@"تفعيل واستمرار" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [btn setBackgroundColor:[UIColor colorWithRed:0.72 green:0.56 blue:0.17 alpha:1.00]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 12;
    [btn addTarget:self action:@selector(check) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    // 5. اسم المتجر في الأسفل (بدون أي إضافات تانية)
    UILabel *rights = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height-50, screenWidth-40, 30)];
    rights.text = @"Rimawi Digital World © 2026";
    rights.textColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    rights.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    rights.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:rights];
}

- (void)check {
    if ([self.codeField.text isEqualToString:@"RDW2026"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.instagram.com/rimawi.dw"] options:@{} completionHandler:nil];
        self.codeField.text = @"";
    }
}
@end

__attribute__((constructor)) static void init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        RDWLoginViewController *vc = [[RDWLoginViewController alloc] init];
        UIWindow *win = nil;
        for (UIWindowScene* s in [UIApplication sharedApplication].connectedScenes) {
            if (s.activationState == UISceneActivationStateForegroundActive) {
                win = s.windows.firstObject;
                break;
            }
        }
        if(!win) win = [UIApplication sharedApplication].windows.firstObject;
        
        UIViewController *root = win.rootViewController;
        while (root.presentedViewController) root = root.presentedViewController;
        [root presentViewController:vc animated:YES completion:nil];
    });
}
