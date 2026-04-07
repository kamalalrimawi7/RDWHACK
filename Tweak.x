#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

%ctor {
    // استراحة لمدة 5 ثواني عشان نضمن إن التطبيق حمل الواجهة تماماً
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // البحث عن كلاس فليكس في الذاكرة
        Class flexClass = NSClassFromString(@"FLEXManager");
        
        if (flexClass) {
            // مناداة [FLEXManager sharedManager] ثم [showExplorer]
            id sharedManager = [flexClass performSelector:@selector(sharedManager)];
            [sharedManager performSelector:@selector(showExplorer)];
            
            NSLog(@"RDW: FLEX has been forced to show successfully!");
        } else {
            NSLog(@"RDW: FLEX class not found. Make sure FLEXing.dylib is injected!");
        }
    });
}
