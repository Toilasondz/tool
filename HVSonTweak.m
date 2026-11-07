#import <UIKit/UIKit.h>
#import "HVSonMenu.h"

static HVSonWindow *gHVSonWindow = nil;

static UIWindowScene *HVSonFindScene(void) {
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (![scene isKindOfClass:[UIWindowScene class]]) continue;
            UIWindowScene *ws = (UIWindowScene *)scene;
            if (ws.activationState == UISceneActivationStateForegroundActive) return ws;
        }
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]]) return (UIWindowScene *)scene;
        }
    }
    return nil;
}

static void HVSonInstallWindow(void) {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{ HVSonInstallWindow(); });
        return;
    }
    if (gHVSonWindow) {
        gHVSonWindow.hidden = NO;
        return;
    }

    HVSonWindow *window = nil;
    if (@available(iOS 13.0, *)) {
        UIWindowScene *scene = HVSonFindScene();
        if (scene) window = [[HVSonWindow alloc] initWithWindowScene:scene];
    }
    if (!window) {
        window = [[HVSonWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    if (!window) return;

    window.windowLevel       = UIWindowLevelAlert + 1;
    window.backgroundColor   = [UIColor clearColor];
    window.rootViewController = [[HVSonRootViewController alloc] init];
    window.hidden            = NO;

    gHVSonWindow = window;
}

__attribute__((constructor))
static void HVSonDylibInit(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        HVSonInstallWindow();
        [[NSNotificationCenter defaultCenter]
            addObserverForName:UIApplicationDidBecomeActiveNotification
                        object:nil
                         queue:[NSOperationQueue mainQueue]
                    usingBlock:^(__unused NSNotification *n) {
            HVSonInstallWindow();
        }];
    });
}
