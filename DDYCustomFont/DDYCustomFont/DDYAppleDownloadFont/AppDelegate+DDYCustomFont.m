#import "AppDelegate+DDYCustomFont.h"
#import <objc/runtime.h>
#import "ViewController.h"


@implementation AppDelegate (DDYCustomFont)

+ (void)load {
    // NSSelectorFromString(@"methodName") 或 @selector(methodName);
    // 交换启动方法
//    [self changeOrignalSEL:@selector(application:didFinishLaunchingWithOptions:)
//                swizzleSEL:@selector(ddy_FontApplication:didFinishLaunchingWithOptions:)];
}

#pragma mark swizzleMethod
+ (void)changeOrignalSEL:(SEL)orignalSEL swizzleSEL:(SEL)swizzleSEL {
    Method originalMethod = class_getInstanceMethod([self class], orignalSEL);
    Method swizzleMethod = class_getInstanceMethod([self class], swizzleSEL);
    if (class_addMethod([self class], orignalSEL, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod))) {
        class_replaceMethod([self class], swizzleSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzleMethod);
    }
}

#pragma mark 在程序启动后注册3DTouch
- (BOOL)ddy_FontApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    __weak __typeof (self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [AppDelegate ddy_MatchAndDownload:[[NSUserDefaults standardUserDefaults] objectForKey:@"DDYDownloadFontName"] complete:^(CTFontDescriptorMatchingState state, CGFloat progress) {
            __strong __typeof (weakSelf)strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                // 实际可能不这么硬写，可以根据需求，这只是demo
                strongSelf.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
            });
        }];
    });
//    [self ddy_FontApplication:application didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

+ (void)ddy_MatchAndDownload:(NSString *)fontName complete:(void (^)(CTFontDescriptorMatchingState, CGFloat))complete {
    if (fontName) {
        CTFontDescriptorRef descRef = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)@{(NSString *)kCTFontNameAttribute:fontName});
        CFArrayRef fontArrayRef = (__bridge CFArrayRef)[NSMutableArray arrayWithObject:(__bridge id)descRef];
        CFRelease(descRef);
        
        CTFontDescriptorMatchFontDescriptorsWithProgressHandler(fontArrayRef, NULL, ^bool(CTFontDescriptorMatchingState state, CFDictionaryRef  _Nonnull progressParameter) {
            if (state == kCTFontDescriptorMatchingDidBegin) {
                NSLog(@"字体匹配开始 %@", fontName);
            } else if (state == kCTFontDescriptorMatchingDidFinish) {
                NSLog(@"字体匹配完成 %@", fontName);
            } else if (state == kCTFontDescriptorMatchingWillBeginQuerying) {
                NSLog(@"字体即将查找 %@", fontName);
            } else if (state == kCTFontDescriptorMatchingStalled) {
                NSLog(@"字体匹配僵局 %@", fontName);
            } else if (state == kCTFontDescriptorMatchingWillBeginDownloading) {
                NSLog(@"字体开始下载 %@", fontName);
            } else if (state == kCTFontDescriptorMatchingDownloading) {
                double progressValue = [[(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingPercentage] doubleValue];
                NSLog(@"字体正在下载 %@ 下载进度 %.0f%% ", fontName, progressValue);
            } else if (state == kCTFontDescriptorMatchingDidFinishDownloading) {
                NSLog(@"字体下载完成 %@", fontName);
            } else if (state == kCTFontDescriptorMatchingDidMatch) {
                NSLog(@"字体匹配已经匹配 %@", fontName);
            } else if (state == kCTFontDescriptorMatchingDidFailWithError) {
                NSError *error = [(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingError];
                NSLog(@"字体匹配错误 %@ %@", fontName, error ? error.description : @"");
            }
            if (complete) {
                double progressValue = [[(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingPercentage] doubleValue];
                NSLog(@"回调 下载进度 %.0f%% ", progressValue);
                complete(state, progressValue);
            }
            return YES;
        });
    } else {
        NSLog(@"字体不能为空");
        if (complete) {
            complete(kCTFontDescriptorMatchingDidFailWithError, 0);
        }
    }
}

@end
