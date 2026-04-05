#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

// --- روابط متجر RDW ---
static NSString *const RDW_URL = @"https://rdw-server-default-rtdb.firebaseio.com/codes";
static NSString *const RDW_WA  = @"https://wa.me/972567171874?text=أريد_شراء_كود_تفعيل_RDW_لو_سمحت";
static NSString *const RDW_IG  = @"https://www.instagram.com/rimawi.dw";

#define RDW_GOLD [UIColor colorWithRed:0.72 green:0.56 blue:0.17 alpha:1.0]

// تعريف الدوال للـ UIWindow عشان الـ Compiler ما يعطي Error
@interface UIWindow (RDW)
- (void)rdw_lock;
- (void)rdw_p:(UILongPressGestureRecognizer *)g;
@end

@interface RDWCore : NSObject
+ (NSString *)myID;
+ (void)vibe:(int)s;
@end

@implementation RDWCore
+ (NSString *)myID { return [[[UIDevice currentDevice] identifierForVendor] UUIDString]; }
+ (void)vibe:(int)s {
    if (s) { 
        UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        [gen impactOccurred];
    } else { 
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate); 
    }
}
@end

// --- شاشة القفل الرئيسية ---
@interface RDWLoginVC : UIViewController
@property (nonatomic, retain) UITextField *inputField;
@property (nonatomic, retain) UILabel *msgL;
@end

@implementation RDWLoginVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *bv = [[UIVisualEffectView alloc] initWithEffect:blur];
    bv.frame = self.view.bounds; [self.view addSubview:bv];

    UIView *box = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-320)/2, (self.view.frame.size.height-580)/2, 320, 580)];
    box.backgroundColor = [UIColor colorWithWhite:0.02 alpha:0.95];
    box.layer.cornerRadius = 45; box.layer.borderColor = RDW_GOLD.CGColor; box.layer.borderWidth = 1.5;
    [self.view addSubview:box];

    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(110, 40, 100, 100)];
    img.layer.cornerRadius = 50; img.layer.borderWidth = 2; img.layer.borderColor = RDW_GOLD.CGColor; img.clipsToBounds = YES;
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://i.ibb.co/7xZ41GWF/IMG-3601.jpg"] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        if (d) dispatch_async(dispatch_get_main_queue(), ^{ img.image = [UIImage imageWithData:d]; });
    }] resume];
    [box addSubview:img];

    UILabel *t1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 320, 30)];
    t1.text = @"Rimawi Digital World"; t1.textColor = RDW_GOLD; t1.textAlignment = NSTextAlignmentCenter; t1.font = [UIFont boldSystemFontOfSize:22];
    [box addSubview:t1];

    UILabel *t2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 180, 320, 20)];
    t2.text = @"نسخة حصرية لمتجر RDW"; t2.textColor = [UIColor whiteColor]; t2.textAlignment = NSTextAlignmentCenter; t2.font = [UIFont systemFontOfSize:13];
    [box addSubview:t2];

    self.msgL = [[UILabel alloc] initWithFrame:CGRectMake(20, 210, 280, 30)];
    self.msgL.textColor = [UIColor systemRedColor]; self.msgL.textAlignment = NSTextAlignmentCenter; self.msgL.font = [UIFont systemFontOfSize:12];
    [box addSubview:self.msgL];

    self.inputField = [[UITextField alloc] initWithFrame:CGRectMake(40, 250, 240, 55)];
    self.inputField.placeholder = @"أدخل كود RDW هنا"; self.inputField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.05];
    self.inputField.textColor = [UIColor whiteColor]; self.inputField.textAlignment = NSTextAlignmentCenter; self.inputField.layer.cornerRadius = 15;
    [box addSubview:self.inputField];

    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn1.frame = CGRectMake(40, 320, 240, 55); [btn1 setTitle:@"تفعيل النسخة" forState:0];
    [btn1 setBackgroundColor:RDW_GOLD]; [btn1 setTitleColor:[UIColor whiteColor] forState:0]; btn1.layer.cornerRadius = 15; [btn1 addTarget:self action:@selector(goCheck) forControlEvents:UIControlEventTouchUpInside];
    [box addSubview:btn1];

    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn2.frame = CGRectMake(40, 390, 240, 50); [btn2 setTitle:@"شراء كود تفعيل" forState:0];
    [btn2 setBackgroundColor:[UIColor colorWithRed:0.1 green:0.5 blue:0.2 alpha:1]]; [btn2 setTitleColor:[UIColor whiteColor] forState:0];
    btn2.layer.cornerRadius = 15; [btn2 addTarget:self action:@selector(goWA) forControlEvents:UIControlEventTouchUpInside];
    [box addSubview:btn2];

    UILabel *dev = [[UILabel alloc] initWithFrame:CGRectMake(0, 530, 320, 20)];
    dev.text = @"تم التطوير بواسطة كمال"; dev.textColor = [UIColor grayColor]; dev.textAlignment = NSTextAlignmentCenter; dev.font = [UIFont systemFontOfSize:11];
    [box addSubview:dev];
}

- (void)goCheck {
    NSString *code = [self.inputField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (code.length < 4) { self.msgL.text = @"مفتاح خاطئ وغير صالح!"; [RDWCore vibe:0]; return; }

    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json", RDW_URL, code]] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (d) {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
                if (json && ![json isEqual:[NSNull null]]) {
                    NSString *uBy = json[@"usedBy"];
                    NSString *myU = [RDWCore myID];

                    if ([uBy isEqualToString:@""]) {
                        [self activateNew:code];
                    } else if ([uBy isEqualToString:myU]) {
                        [self done:code];
                    } else {
                        self.msgL.text = @"هذا المفتاح مستخدم على جهاز آخر!"; [RDWCore vibe:0];
                    }
                } else {
                    self.msgL.text = @"الكود غير موجود!"; [RDWCore vibe:0];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RDW_IG] options:@{} completionHandler:nil];
                    });
                }
            }
        });
    }] resume];
}

- (void)activateNew:(NSString *)c {
    double exp = [[NSDate date] timeIntervalSince1970] + (30 * 24 * 3600);
    NSDictionary *p = @{@"usedBy": [RDWCore myID], @"expiry": @(exp)};
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json", RDW_URL, c]]];
    [req setHTTPMethod:@"PATCH"]; [req setHTTPBody:[NSJSONSerialization dataWithJSONObject:p options:0 error:nil]];
    [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{ [self done:c]; });
    }] resume];
}

- (void)done:(NSString *)c {
    [RDWCore vibe:1]; [[NSUserDefaults standardUserDefaults] setObject:c forKey:@"RDW_KEY"];
    UIAlertController *a = [UIAlertController alertControllerWithTitle:@"✅ تم التفعيل" message:@"أهلاً بك في Rimawi Digital World" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:a animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [a dismissViewControllerAnimated:YES completion:^{ [self dismissViewControllerAnimated:YES completion:nil]; }];
        });
    }];
}
- (void)goWA { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RDW_WA] options:@{} completionHandler:nil]; }
@end

// --- بانل المعلومات (3 أصابع) ---
@interface RDWPanel : UIView
@property (nonatomic, retain) UILabel *lbl;
@property (nonatomic, retain) UITextField *fld;
@end

@implementation RDWPanel
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.05 alpha:0.95]; self.layer.cornerRadius = 25;
        self.layer.borderColor = RDW_GOLD.CGColor; self.layer.borderWidth = 2; self.tag = 888;
        
        self.lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 260, 60)];
        self.lbl.numberOfLines = 2; self.lbl.textColor = [UIColor whiteColor]; self.lbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.lbl];

        self.fld = [[UITextField alloc] initWithFrame:CGRectMake(20, 90, 240, 40)];
        self.fld.placeholder = @"أدخل كود تمديد"; self.fld.backgroundColor = [UIColor whiteColor];
        self.fld.textAlignment = NSTextAlignmentCenter; self.fld.layer.cornerRadius = 10; [self addSubview:self.fld];

        UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
        b.frame = CGRectMake(60, 145, 160, 40); [b setTitle:@"تمديد الاشتراك" forState:0];
        [b setBackgroundColor:RDW_GOLD]; [b setTitleColor:[UIColor whiteColor] forState:0]; b.layer.cornerRadius = 10; [b addTarget:self action:@selector(stack) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:b];
        [self refresh];
    }
    return self;
}
- (void)refresh {
    NSString *k = [[NSUserDefaults standardUserDefaults] objectForKey:@"RDW_KEY"];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json", RDW_URL, k]] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        if (d) {
            NSDictionary *j = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            int days = (int)(([j[@"expiry"] doubleValue] - [[NSDate date] timeIntervalSince1970]) / 86400);
            dispatch_async(dispatch_get_main_queue(), ^{ self.lbl.text = [NSString stringWithFormat:@"كودك: %@\nمتبقي: %d يوم", k, (days>0?days:0)]; });
        }
    }] resume];
}
- (void)stack {
    // سيتم إضافة منطق التمديد لاحقاً
}
@end

// --- الهوك الرئيسي ---
%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    [NSTimer scheduledTimerWithTimeInterval:30 repeats:YES block:^(NSTimer *t) {
        NSString *k = [[NSUserDefaults standardUserDefaults] objectForKey:@"RDW_KEY"];
        if (!k) { [self rdw_lock]; return; }
        [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json", RDW_URL, k]] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
            if (d) {
                NSDictionary *j = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
                if (!j || [j isEqual:[NSNull null]] || ![j[@"usedBy"] isEqualToString:[RDWCore myID]] || [j[@"expiry"] doubleValue] < [[NSDate date] timeIntervalSince1970]) {
                    dispatch_async(dispatch_get_main_queue(), ^{ [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"RDW_KEY"]; [self rdw_lock]; });
                }
            }
        }] resume];
    }];
    UILongPressGestureRecognizer *lp = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(rdw_p:)];
    lp.numberOfTouchesRequired = 3; lp.minimumPressDuration = 2.5; [self addGestureRecognizer:lp];
}

%new
- (void)rdw_lock {
    UIViewController *top = self.rootViewController;
    while (top.presentedViewController) top = top.presentedViewController;
    if (![top isKindOfClass:[RDWLoginVC class]]) {
        RDWLoginVC *vc = [[RDWLoginVC alloc] init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [top presentViewController:vc animated:YES completion:nil];
    }
}

%new
- (void)rdw_p:(UILongPressGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateBegan) {
        if ([self viewWithTag:888]) return;
        RDWPanel *p = [[RDWPanel alloc] initWithFrame:CGRectMake((self.frame.size.width-280)/2, 120, 280, 210)];
        [self addSubview:p];
    }
}
%end
