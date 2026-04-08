#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

%ctor {
    // ننتظر التطبيق حتى يفتح بالكامل
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification 
    object:nil 
    queue:[NSOperationQueue mainQueue] 
    usingBlock:^(NSNotification *note) {
        
        // تأخير 5 ثواني لضمان تحميل الواجهة
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // محاولة مناداة FLEXManager
            Class flexClass = NSClassFromString(@"FLEXManager");
            if (flexClass) {
                id sharedManager = [flexClass performSelector:@selector(sharedManager)];
                if ([sharedManager respondsToSelector:@selector(showExplorer)]) {
                    [sharedManager performSelector:@selector(showExplorer)];
                }
            }
        });
    }];
}
