#import "HVSonMenu.h"

static const CGFloat kMenuW      = 280.0;
static const CGFloat kMenuH      = 380.0;
static const CGFloat kMenuCorner = 20.0;
static const CGFloat kBtnSize    = 48.0;

#pragma mark - HVSonMenuView

@implementation HVSonMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self _setup];
    }
    return self;
}

- (void)_setup {
    self.backgroundColor     = [UIColor whiteColor];
    self.layer.cornerRadius  = kMenuCorner;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth   = 0.5;
    self.layer.borderColor   = [UIColor colorWithWhite:0 alpha:0.08].CGColor;

    // Title
    UILabel *title = [[UILabel alloc] init];
    title.translatesAutoresizingMaskIntoConstraints = NO;
    title.text      = @"H Van Son";
    title.font      = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    title.textColor = [UIColor colorWithRed:0.10 green:0.10 blue:0.12 alpha:1.0];
    title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:title];

    // Subtitle
    UILabel *sub = [[UILabel alloc] init];
    sub.translatesAutoresizingMaskIntoConstraints = NO;
    sub.text      = @"VideoStar Tool";
    sub.font      = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    sub.textColor = [UIColor colorWithWhite:0.55 alpha:1.0];
    sub.textAlignment = NSTextAlignmentCenter;
    [self addSubview:sub];

    // Close
    UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem];
    close.translatesAutoresizingMaskIntoConstraints = NO;
    [close setTitle:@"✕" forState:UIControlStateNormal];
    [close setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    close.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    [close addTarget:self action:@selector(_closeTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:close];

    // Separator
    UIView *sep = [[UIView alloc] init];
    sep.translatesAutoresizingMaskIntoConstraints = NO;
    sep.backgroundColor = [UIColor colorWithWhite:0 alpha:0.08];
    [self addSubview:sep];

    // Content area (để sau này cắm feature buttons)
    UIView *content = [[UIView alloc] init];
    content.translatesAutoresizingMaskIntoConstraints = NO;
    content.tag = 0x777;
    [self addSubview:content];

    [NSLayoutConstraint activateConstraints:@[
        [title.topAnchor      constraintEqualToAnchor:self.topAnchor constant:22],
        [title.leadingAnchor  constraintEqualToAnchor:self.leadingAnchor constant:16],
        [title.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16],

        [sub.topAnchor        constraintEqualToAnchor:title.bottomAnchor constant:2],
        [sub.leadingAnchor    constraintEqualToAnchor:self.leadingAnchor constant:16],
        [sub.trailingAnchor   constraintEqualToAnchor:self.trailingAnchor constant:-16],

        [close.topAnchor      constraintEqualToAnchor:self.topAnchor constant:14],
        [close.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-14],
        [close.widthAnchor    constraintEqualToConstant:24],
        [close.heightAnchor   constraintEqualToConstant:24],

        [sep.topAnchor        constraintEqualToAnchor:sub.bottomAnchor constant:14],
        [sep.leadingAnchor    constraintEqualToAnchor:self.leadingAnchor constant:16],
        [sep.trailingAnchor   constraintEqualToAnchor:self.trailingAnchor constant:-16],
        [sep.heightAnchor     constraintEqualToConstant:1],

        [content.topAnchor    constraintEqualToAnchor:sep.bottomAnchor constant:12],
        [content.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16],
        [content.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16],
        [content.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-16],
    ]];

    // Kéo panel bằng pan gesture toàn panel
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_onPan:)];
    pan.cancelsTouchesInView = NO;
    [self addGestureRecognizer:pan];
}

- (void)_closeTapped {
    if (self.onClose) self.onClose();
}

- (void)_onPan:(UIPanGestureRecognizer *)g {
    UIView *sv = self.superview;
    if (!sv) return;
    CGPoint t = [g translationInView:sv];
    CGPoint c = self.center;
    c.x += t.x;
    c.y += t.y;

    CGFloat halfW = self.bounds.size.width  * 0.5;
    CGFloat halfH = self.bounds.size.height * 0.5;
    CGFloat topSafe   = 40.0;
    CGFloat botSafe   = 40.0;
    c.x = MAX(halfW + 4.0, MIN(c.x, sv.bounds.size.width  - halfW - 4.0));
    c.y = MAX(halfH + topSafe, MIN(c.y, sv.bounds.size.height - halfH - botSafe));

    self.center = c;
    [g setTranslation:CGPointZero inView:sv];
}

@end

#pragma mark - HVSonToggleButton

@implementation HVSonToggleButton

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor     = [UIColor whiteColor];
        self.layer.cornerRadius  = frame.size.width * 0.5;
        self.layer.borderWidth   = 1.0;
        self.layer.borderColor   = [UIColor colorWithWhite:0 alpha:0.15].CGColor;
        self.layer.shadowColor   = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.20;
        self.layer.shadowRadius  = 6.0;
        self.layer.shadowOffset  = CGSizeMake(0, 2);
        self.titleLabel.font     = [UIFont boldSystemFontOfSize:13];
        [self setTitle:@"VS" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    }
    return self;
}

@end

#pragma mark - HVSonRootViewController

@implementation HVSonRootViewController

- (void)loadView {
    UIView *root = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    root.backgroundColor = [UIColor clearColor];
    self.view = root;

    CGFloat w = root.bounds.size.width;
    HVSonToggleButton *btn = [[HVSonToggleButton alloc] initWithFrame:CGRectMake(w - kBtnSize - 20, 120, kBtnSize, kBtnSize)];
    [btn addTarget:self action:@selector(_toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    UIPanGestureRecognizer *btnPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_onButtonPan:)];
    btnPan.cancelsTouchesInView = NO;
    [btn addGestureRecognizer:btnPan];

    self.toggleButton = btn;
    [root addSubview:btn];
}

- (void)_toggleMenu {
    if (self.menuView.superview) {
        [self.menuView removeFromSuperview];
        self.menuView = nil;
        return;
    }
    CGSize s = self.view.bounds.size;
    CGRect f = CGRectMake((s.width  - kMenuW) * 0.5,
                          (s.height - kMenuH) * 0.5,
                          kMenuW, kMenuH);
    HVSonMenuView *menu = [[HVSonMenuView alloc] initWithFrame:f];
    __weak typeof(self) weakSelf = self;
    menu.onClose = ^{
        __strong typeof(weakSelf) sSelf = weakSelf;
        if (!sSelf) return;
        [sSelf.menuView removeFromSuperview];
        sSelf.menuView = nil;
    };
    self.menuView = menu;
    [self.view addSubview:menu];
}

- (void)_onButtonPan:(UIPanGestureRecognizer *)g {
    UIView *sv = self.view;
    CGPoint t = [g translationInView:sv];
    CGPoint c = self.toggleButton.center;
    c.x += t.x;
    c.y += t.y;
    CGFloat half = kBtnSize * 0.5;
    c.x = MAX(half + 4.0, MIN(c.x, sv.bounds.size.width  - half - 4.0));
    c.y = MAX(half + 40.0, MIN(c.y, sv.bounds.size.height - half - 40.0));
    self.toggleButton.center = c;
    [g setTranslation:CGPointZero inView:sv];
}

- (BOOL)shouldAutorotate { return YES; }
- (UIInterfaceOrientationMask)supportedInterfaceOrientations { return UIInterfaceOrientationMaskAll; }
- (UIStatusBarStyle)preferredStatusBarStyle { return UIStatusBarStyleDefault; }

@end

#pragma mark - HVSonWindow (passthrough)

@implementation HVSonWindow

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hit = [super hitTest:point withEvent:event];
    if (hit == self) return nil;
    if (hit == self.rootViewController.view) return nil;
    return hit;
}

@end
