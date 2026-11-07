#import "HVSonEngine.h"

- (void)_setup {
    // ... giữ nguyên phần setup cũ ...

    UIView *content = [self viewWithTag:0x777];
    NSArray *titles = @[
        @"📷  Auto nhập ảnh vào lớp",
        @"🕘  Code gần nhất",
        @"🎵  Auto chia beat",
        @"🎬  Auto nhập code & ảnh phân cảnh"
    ];
    NSArray *sels = @[@"_tap0", @"_tap1", @"_tap2", @"_tap3"];

    CGFloat y = 0;
    for (NSUInteger i = 0; i < titles.count; i++) {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
        b.frame = CGRectMake(0, y, content.bounds.size.width ?: 248, 44);
        b.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        b.backgroundColor = [UIColor colorWithRed:0.96 green:0.97 blue:1.0 alpha:1.0];
        b.layer.cornerRadius = 10;
        b.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        b.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 12);
        [b setTitle:titles[i] forState:UIControlStateNormal];
        [b setTitleColor:[UIColor colorWithRed:0.10 green:0.10 blue:0.12 alpha:1.0]
                forState:UIControlStateNormal];
        b.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
        SEL action = NSSelectorFromString(sels[i]);
        [b addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        [content addSubview:b];
        y += 48;
    }

    [HVSonEngine shared].onStatus = ^(NSString *msg) {
        // Cập nhật status bar nhỏ ở đáy menu (không bắt buộc)
        NSLog(@"[HVSon] %@", msg);
    };
}

- (void)_tap0 { [[HVSonEngine shared] feature0AutoImportImages]; }
- (void)_tap1 { [[HVSonEngine shared] feature1ShowLastCode];     }
- (void)_tap2 { [[HVSonEngine shared] feature2AutoBeatSplit];    }
- (void)_tap3 { [[HVSonEngine shared] feature3AutoMultiScene];   }
