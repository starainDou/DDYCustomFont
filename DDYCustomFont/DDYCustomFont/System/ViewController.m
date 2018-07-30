#import "ViewController.h"
#import "DDYDownloadFontTestVC.h"
#import "DDYLocalCustomFontTestVC.h"

#ifndef DDYTopH
#define DDYTopH (self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height)
#endif

#ifndef DDYScreenW
#define DDYScreenW [UIScreen mainScreen].bounds.size.width
#endif

#ifndef DDYScreenH
#define DDYScreenH [UIScreen mainScreen].bounds.size.height
#endif

@interface ViewController ()

@property (nonatomic, strong) UIButton *button1;

@property (nonatomic, strong) UIButton *button2;

@end

@implementation ViewController

- (UIButton *)button1 {
    if (!_button1) {
        _button1 = [self btnY:50 tag:101 title:@"Apple Download"];
    }
    return _button1;
}

- (UIButton *)button2 {
    if (!_button2) {
        _button2 = [self btnY:100 tag:102 title:@"Local Custom"];
    }
    return _button2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.button1];
    [self.view addSubview:self.button2];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (NSString *fontName in [UIFont familyNames]) {
                NSLog(@"系统字体:%@", fontName);
            }
        });
    });
}

- (UIButton *)btnY:(CGFloat)y tag:(NSUInteger)tag title:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor lightGrayColor]];
    [button setFrame:CGRectMake(10, DDYTopH + y, DDYScreenW-20, 40)];
    [button setTag:tag];
    [button addTarget:self action:@selector(handleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}

- (void)handleBtn:(UIButton *)sender {
    if (sender.tag == 101) {
        [self.navigationController pushViewController:[DDYDownloadFontTestVC new] animated:YES];
    } else if (sender.tag == 102) {
        [self.navigationController pushViewController:[DDYLocalCustomFontTestVC new] animated:YES];
    }
}

@end
