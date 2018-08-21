#import "AppDelegate.h"
#import <CoreText/CoreText.h>

@interface AppDelegate (DDYCustomFont)

/** 在程序启动后注册3DTouch 这里自动调用 如果想手动，可以去掉交换方法 */
//- (BOOL)ddy_FontApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

+ (void)ddy_MatchAndDownload:(NSString *)fontName
                    complete:(void (^)(CTFontDescriptorMatchingState state, CGFloat progress))complete;

@end
