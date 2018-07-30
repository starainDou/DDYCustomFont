#import "DDYDownloadFontTestVC.h"
#import "AppDelegate+DDYCustomFont.h"

#ifndef DDYTopH
#define DDYTopH (self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height)
#endif

#ifndef DDYScreenW
#define DDYScreenW [UIScreen mainScreen].bounds.size.width
#endif

#ifndef DDYScreenH
#define DDYScreenH [UIScreen mainScreen].bounds.size.height
#endif

@interface DDYDownloadFontTestVC ()

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIButton *button1;

@property (nonatomic, strong) UIButton *button2;

@property (nonatomic, strong) UIButton *button3;

@end

@implementation DDYDownloadFontTestVC

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, DDYTopH + 10, DDYScreenW-20, 30)];
        [_tipLabel setTextAlignment:NSTextAlignmentCenter];
        [_tipLabel setFont:[UIFont systemFontOfSize:20]];
        [_tipLabel setTextColor:[UIColor redColor]];
        [_tipLabel setText:@"abcd原字体100"];
        NSString *fontName = [[NSUserDefaults standardUserDefaults] objectForKey:@"DDYDownloadFontName"];
        if (fontName) {
            [_tipLabel setFont:[UIFont fontWithName:fontName size:20]];
        }
    }
    return _tipLabel;
}

- (UIButton *)button1 {
    if (!_button1) {
        _button1 = [self btnY:50 tag:101 title:@"HanziPenSC-W3"];
    }
    return _button1;
}

- (UIButton *)button2 {
    if (!_button2) {
        _button2 = [self btnY:100 tag:102 title:@"DFWaWaSC-W5"];
    }
    return _button2;
}

- (UIButton *)button3 {
    if (!_button3) {
        _button3 = [self btnY:150 tag:101 title:@"DFWaWaTC-W5"];
    }
    return _button3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.button1];
    [self.view addSubview:self.button2];
    [self.view addSubview:self.button3];
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
    [self buttonUserInteractionEnabled:NO];
    __weak __typeof (self)weakSelf = self;
    [AppDelegate ddy_MatchAndDownload:sender.titleLabel.text complete:^(CTFontDescriptorMatchingState state, CGFloat progress) {
        __strong __typeof (weakSelf)strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (state == kCTFontDescriptorMatchingDownloading) {
                strongSelf.tipLabel.text = [NSString stringWithFormat:@"a下载:%@ 进度:%.0f", sender.titleLabel.text, progress];
            } else if (state == kCTFontDescriptorMatchingDidFailWithError) {
                strongSelf.tipLabel.text = [NSString stringWithFormat:@"a错误:%@ 进度:%.0f", sender.titleLabel.text, progress];
                [strongSelf buttonUserInteractionEnabled:YES];
            } else if (state == kCTFontDescriptorMatchingDidFinish) {
                strongSelf.tipLabel.text = [NSString stringWithFormat:@"a完成:%@ 进度:%.0f%%", sender.titleLabel.text, 100.];
                [strongSelf buttonUserInteractionEnabled:YES];
                strongSelf.tipLabel.font = [UIFont fontWithName:sender.titleLabel.text size:20];
                [[NSUserDefaults standardUserDefaults] setValue:sender.titleLabel.text forKey:@"DDYDownloadFontName"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        });
    }];
}

- (void)buttonUserInteractionEnabled:(BOOL)enabled {
    self.button1.userInteractionEnabled = enabled;
    self.button2.userInteractionEnabled = enabled;
    self.button3.userInteractionEnabled = enabled;
}

@end

/** 更多字体请在Mac系统上找到Font Book.app
    选择所有字体，点击详情按钮
 */
