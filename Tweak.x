#import <UIKit/UIKit.h>

#define SECRET_PIN @"kamal_alaa.dw" 

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)application {
    %orig;

    // توجيه إنستجرام
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (![prefs boolForKey:@"RDW_FirstLaunch"]) {
        [prefs setBool:YES forKey:@"RDW_FirstLaunch"];
        [prefs synchronize];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.instagram.com/rimawi.dw"] options:@{} completionHandler:nil];
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\nRDWHACK ACCESS" 
            message:@"Welcome to Rimawi Digital World\nEnter Password to continue:" 
            preferredStyle:UIAlertControllerStyleAlert];

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(110, 15, 50, 50)];
        imageView.image = [UIImage systemImageNamed:@"shield.lefthalf.filled"];
        imageView.tintColor = [UIColor systemBlueColor];
        [alert.view addSubview:imageView];

        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Enter Password";
            textField.secureTextEntry = YES;
        }];

        UIAlertAction *login = [UIAlertAction actionWithTitle:@"Login" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if (![alert.textFields.firstObject.text isEqualToString:SECRET_PIN]) {
                exit(0);
            }
        }];

        [alert addAction:login];

        // تصحيح القوس وطريقة الاستدعاء
        UIWindow *window = [(id)[UIApplication sharedApplication] keyWindow];
        [window.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}
%end
