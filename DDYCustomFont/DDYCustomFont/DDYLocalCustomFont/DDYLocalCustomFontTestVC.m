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

@interface DDYLocalCustomFontTestVC ()

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIButton *button1;

@property (nonatomic, strong) UIButton *button2;

@end

@implementation DDYLocalCustomFontTestVC

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, DDYTopH + 10, DDYScreenW-20, 30)];
        [_tipLabel setTextAlignment:NSTextAlignmentCenter];
        [_tipLabel setFont:[UIFont systemFontOfSize:20]];
        [_tipLabel setTextColor:[UIColor redColor]];
        [_tipLabel setText:@"abcd原字体100"];
    }
    return _tipLabel;
}

- (UIButton *)button1 {
    if (!_button1) {
        _button1 = [self btnY:50 tag:101 title:@"AaQingCong"];
    }
    return _button1;
}

- (UIButton *)button2 {
    if (!_button2) {
        _button2 = [self btnY:100 tag:102 title:@"BebasNeueBold"];
    }
    return _button2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.button1];
    [self.view addSubview:self.button2];
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
    self.tipLabel.text = [NSString stringWithFormat:@"abcd字体设置完成:%@ 进度:%.0f", sender.titleLabel.text, 100.];
    self.tipLabel.font = [UIFont fontWithName:sender.titleLabel.text size:20];
}

@end

/**
 自定义字体步骤：
 1，首先下载字体库，然后把自己库托到项目里
 2，在 info.plist 中添加 'Fonts provided by application' (实际'UIAppFonts') － AaQingCong.ttf
 3，TARGETS －> Build Phases －> Copy Bundle Resources 添加字体库文件
 4，[UIFont fontWithName:@"XXX" size:18];
 */
