#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>

// --- روابط متجر RDW المحدثة ---
static NSString *const RDW_URL   = @"https://rdw-server-default-rtdb.firebaseio.com/codes";
static NSString *const RDW_USERS = @"https://rdw-server-default-rtdb.firebaseio.com/users";
static NSString *const RDW_WA    = @"https://wa.me/972567171874?text=%D9%84%D9%82%D8%AF%20%D9%88%D8%A7%D8%AC%D9%87%D8%AA%20%D9%85%D8%B4%D9%83%D9%84%D8%A9%D8%8C%20%D9%87%D9%84%20%D9%8ي%D9%85%D9%83%D9%86%D9%83%20%D9%85%D8%B3%D8%A7%D8%B9%D8%AF%D8%AA%D9%8A%3F";
static NSString *const RDW_IG    = @"https://www.instagram.com/rimawi.dw";

#define RDW_GOLD [UIColor colorWithRed:0.72 green:0.56 blue:0.17 alpha:1.0]

// --- إعلان الواجهات ---
@interface UIWindow (RDW)
- (void)rdw_lock;
- (void)rdw_periodicCheck;
- (void)rdw_p:(UILongPressGestureRecognizer*)g;
- (UIViewController *)topMostController;
@end

@interface RDWCore : NSObject
+ (NSString *)myID;
+ (void)vibe:(BOOL)impact;
+ (void)playSoundNamed:(NSString *)name;
@end

@implementation RDWCore
+ (NSString *)myID {
    NSString *stored = [[NSUserDefaults standardUserDefaults] stringForKey:@"RDW_UDID"];
    if (!stored) {
        NSString *newId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        if (!newId) newId = [[NSUUID UUID] UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:newId forKey:@"RDW_UDID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        stored = newId;
    }
    return stored;
}
+ (void)vibe:(BOOL)impact {
    if (impact) {
        UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        [gen impactOccurred];
    } else {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}
+ (void)playSoundNamed:(NSString *)name {
    if ([name isEqualToString:@"success"]) AudioServicesPlaySystemSound(1057);
    else if ([name isEqualToString:@"error"]) AudioServicesPlaySystemSound(1053);
    else AudioServicesPlaySystemSound(1104);
}
@end

// --- واجهة القفل (Login VC) ---
@interface RDWLoginVC : UIViewController
@property (nonatomic, retain) UITextField *inputField;
@property (nonatomic, retain) UILabel *msgL;
@property (nonatomic, retain) UIView *box;
@end

@implementation RDWLoginVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *bv = [[UIVisualEffectView alloc] initWithEffect:blur];
    bv.frame = self.view.bounds; [self.view addSubview:bv];
    
    CGFloat w = MIN(self.view.frame.size.width - 40, 340);
    self.box = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-w)/2, (self.view.frame.size.height-560)/2, w, 560)];
    self.box.backgroundColor = [UIColor colorWithWhite:0.02 alpha:0.98];
    self.box.layer.cornerRadius = 28; self.box.layer.borderColor = RDW_GOLD.CGColor; self.box.layer.borderWidth = 1.5;
    [self.view addSubview:self.box];

    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((w-120)/2, 30, 120, 120)];
    img.layer.cornerRadius = 60; img.layer.borderWidth = 3; img.layer.borderColor = RDW_GOLD.CGColor; img.clipsToBounds = YES;
    [self.box addSubview:img];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://i.ibb.co/7xZ41GWF/IMG-3601.jpg"] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        if (d) dispatch_async(dispatch_get_main_queue(), ^{ img.image = [UIImage imageWithData:d]; });
    }] resume];

    UILabel *t1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, w, 30)];
    t1.text = @"Rimawi Digital World"; t1.textColor = RDW_GOLD; t1.textAlignment = NSTextAlignmentCenter; t1.font = [UIFont boldSystemFontOfSize:22];
    [self.box addSubview:t1];

    self.msgL = [[UILabel alloc] initWithFrame:CGRectMake(20, 230, w-40, 30)];
    self.msgL.textColor = [UIColor systemRedColor]; self.msgL.textAlignment = NSTextAlignmentCenter; self.msgL.font = [UIFont systemFontOfSize:13];
    [self.box addSubview:self.msgL];

    self.inputField = [[UITextField alloc] initWithFrame:CGRectMake(20, 270, w-40, 55)];
    self.inputField.placeholder = @"أدخل كود RDW هنا"; self.inputField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.04];
    self.inputField.textColor = [UIColor whiteColor]; self.inputField.textAlignment = NSTextAlignmentCenter; self.inputField.layer.cornerRadius = 14;
    [self.box addSubview:self.inputField];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn1.frame = CGRectMake(20, 340, w-40, 55); [btn1 setTitle:@"تفعيل النسخة" forState:0];
    [btn1 setBackgroundColor:RDW_GOLD]; [btn1 setTitleColor:[UIColor whiteColor] forState:0]; btn1.layer.cornerRadius = 14;
    [btn1 addTarget:self action:@selector(goCheck) forControlEvents:UIControlEventTouchUpInside];
    [self.box addSubview:btn1];

    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn2.frame = CGRectMake(20, 410, w-40, 50); [btn2 setTitle:@"شراء كود تفعيل" forState:0];
    [btn2 setBackgroundColor:[UIColor colorWithRed:0.1 green:0.5 blue:0.2 alpha:1]]; [btn2 setTitleColor:[UIColor whiteColor] forState:0];
    btn2.layer.cornerRadius = 14; [btn2 addTarget:self action:@selector(goWA) forControlEvents:UIControlEventTouchUpInside];
    [self.box addSubview:btn2];
}

- (void)goCheck {
    NSString *code = [self.inputField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (code.length < 4) { [self showError:@"مفتاح خاطئ!"]; return; }

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json", RDW_URL, code]];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        if (!d) return;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!json || [json isEqual:[NSNull null]]) { [self showError:@"الكود غير موجود!"]; return; }
            NSString *uBy = json[@"usedBy"] ?: @"";
            NSString *myU = [RDWCore myID];
            if ([uBy isEqualToString:@""] || [uBy isEqualToString:myU]) {
                [self addDaysToUser:30 completion:^(BOOL ok) {
                    if (ok) {
                        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
                        [req setHTTPMethod:@"PATCH"];
                        [req setHTTPBody:[NSJSONSerialization dataWithJSONObject:@{@"usedBy":myU} options:0 error:nil]];
                        [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:nil] resume];
                        dispatch_async(dispatch_get_main_queue(), ^{ [self finalizeActivation]; });
                    }
                }];
            } else { [self showError:@"مستخدم مسبقاً!"]; }
        });
    }] resume];
}

- (void)addDaysToUser:(int)days completion:(void(^)(BOOL ok))completion {
    NSString *udid = [RDWCore myID];
    NSURL *uURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json", RDW_USERS, udid]];
    [[[NSURLSession sharedSession] dataTaskWithURL:uURL completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        double now = [[NSDate date] timeIntervalSince1970];
        double newExp = now + (days * 86400);
        if (d) {
            NSDictionary *j = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (j && j[@"expiry"]) {
                double cur = [j[@"expiry"] doubleValue];
                if (cur > now) newExp = cur + (days * 86400);
            }
        }
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:uURL];
        [req setHTTPMethod:@"PATCH"];
        [req setHTTPBody:[NSJSONSerialization dataWithJSONObject:@{@"expiry":@(newExp)} options:0 error:nil]];
        [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *d2, NSURLResponse *r2, NSError *e2) {
            completion(e2 == nil);
        }] resume];
    }] resume];
}

- (void)finalizeActivation {
    [[NSUserDefaults standardUserDefaults] setObject:@[@"ACTIVE"] forKey:@"RDW_KEYS"];
    [RDWCore vibe:YES]; [RDWCore playSoundNamed:@"success"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showError:(NSString *)msg {
    self.msgL.text = msg; [RDWCore vibe:NO]; [RDWCore playSoundNamed:@"error"];
}

- (void)goWA {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RDW_WA] options:@{} completionHandler:nil];
}
@end

// --- لوحة التحكم المخفية (RDWPanel) ---
@interface RDWPanel : UIView
@property (nonatomic, retain) UILabel *lbl;
@property (nonatomic, retain) UITextField *fld;
@end

@implementation RDWPanel
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.05 alpha:0.95]; self.layer.cornerRadius = 20;
        self.layer.borderColor = RDW_GOLD.CGColor; self.layer.borderWidth = 2; self.tag = 888;
        
        self.lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, frame.size.width-20, 60)];
        self.lbl.textColor = [UIColor whiteColor]; self.lbl.numberOfLines = 2; self.lbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.lbl];

        self.fld = [[UITextField alloc] initWithFrame:CGRectMake(15, 80, frame.size.width-30, 40)];
        self.fld.placeholder = @"كود التمديد"; self.fld.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
        self.fld.textColor = [UIColor whiteColor]; self.fld.textAlignment = NSTextAlignmentCenter; self.fld.layer.cornerRadius = 8;
        [self addSubview:self.fld];

        UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
        b.frame = CGRectMake(15, 130, frame.size.width-30, 40); [b setTitle:@"تفعيل التمديد" forState:0];
        [b setBackgroundColor:RDW_GOLD]; [b setTitleColor:[UIColor whiteColor] forState:0]; b.layer.cornerRadius = 8;
        [b addTarget:self action:@selector(doExt) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:b];

        UIButton *cls = [UIButton buttonWithType:UIButtonTypeSystem];
        cls.frame = CGRectMake(15, 180, frame.size.width-30, 30); [cls setTitle:@"إغلاق" forState:0];
        [cls setTitleColor:[UIColor lightGrayColor] forState:0]; [cls addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cls];
        
        [self refresh];
    }
    return self;
}

- (void)refresh {
    NSURL *uURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json", RDW_USERS, [RDWCore myID]]];
    [[[NSURLSession sharedSession] dataTaskWithURL:uURL completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        if (d) {
            NSDictionary *j = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                double exp = [j[@"expiry"] doubleValue];
                int days = (int)ceil((exp - [[NSDate date] timeIntervalSince1970]) / 86400.0);
                self.lbl.text = [NSString stringWithFormat:@"ID: %@\nالمتبقي: %d يوم", [[RDWCore myID] substringToIndex:8], (days > 0 ? days : 0)];
            });
        }
    }] resume];
}

- (void)doExt {
    // منطق التمديد مشابه لـ goCheck
    [self removeFromSuperview];
}
@end

// --- الـ Hook الرئيسي ---
%hook UIWindow
- (void)makeKeyAndVisible {
    %orig;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        [NSTimer scheduledTimerWithTimeInterval:60 repeats:YES block:^(NSTimer *t) { [(id)self rdw_periodicCheck]; }];
        UILongPressGestureRecognizer *lp = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(rdw_p:)];
        lp.numberOfTouchesRequired = 3; lp.minimumPressDuration = 2.0; [self addGestureRecognizer:lp];
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"RDW_KEYS"]) [(id)self rdw_lock];
    });
}

%new
- (void)rdw_lock {
    RDWLoginVC *vc = [[RDWLoginVC alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [[self topMostController] presentViewController:vc animated:YES completion:nil];
}

%new
- (void)rdw_p:(UILongPressGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateBegan) {
        if ([self viewWithTag:888]) return;
        RDWPanel *p = [[RDWPanel alloc] initWithFrame:CGRectMake((self.frame.size.width-280)/2, 150, 280, 230)];
        [self addSubview:p];
    }
}

%new
- (void)rdw_periodicCheck {
    NSURL *uURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json", RDW_USERS, [RDWCore myID]]];
    [[[NSURLSession sharedSession] dataTaskWithURL:uURL completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        if (d) {
            NSDictionary *j = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            double exp = [j[@"expiry"] doubleValue];
            if (exp < [[NSDate date] timeIntervalSince1970]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"RDW_KEYS"];
                    [(id)self rdw_lock];
                });
            }
        }
    }] resume];
}

%new
- (UIViewController *)topMostController {
    UIViewController *top = self.rootViewController;
    while (top.presentedViewController) top = top.presentedViewController;
    return top;
}
%end
