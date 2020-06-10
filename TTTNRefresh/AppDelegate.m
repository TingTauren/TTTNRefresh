//
//  AppDelegate.m
//  TTTNRefresh
//
//  Created by jiudun on 2020/6/9.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark ----- set get
- (UIWindow *)window {
    if (_window) return _window;
    _window = [[UIWindow alloc] init];
    _window.frame = [UIScreen mainScreen].bounds;
    [_window makeKeyAndVisible];
    return _window;
}

#pragma mark ----- init Methods
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
    self.window.rootViewController = naviVC;
    
    return YES;
}

@end
