//
//  AppDelegate.m
//  FontDesigner
//
//  Created by chenshun on 13-5-5.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "AppDelegate.h"

#import "FamilyViewController.h"

#import "SettingViewController.h"
#import "UIColor+HexColor.h"
#import "StyleViewController.h"
#include "SymbolListViewController.h"
#import "iRate.h"
#import "Flurry.h"

@implementation AppDelegate
@synthesize systemFontFamily;
@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
#if FreeApp
@synthesize adBanner;
#endif
- (void)dealloc
{
    //[adBanner release];
    [systemFontFamily release];
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    systemFontFamily = [[NSMutableArray alloc] init];
    [systemFontFamily addObjectsFromArray:[UIFont familyNames]];
    [systemFontFamily sortUsingComparator: ^NSComparisonResult(id obj1, id obj2){
        
        NSString *objStr1 = (NSString *)obj1;
        NSString *objStr2 = (NSString *)obj2;
        return [objStr1 compare:objStr2];
    }];
 
    
    SymbolListViewController *sysmbolNameViewController = [[[SymbolListViewController alloc] initWithNibName:@"SymbolListViewController" bundle:nil] autorelease];
    sysmbolNameViewController.title = NSLocalizedString(@"Symbols", @"Family");
    sysmbolNameViewController.tabBarItem.image = [UIImage imageNamed:@"symbol.png"];
    
    // Override point for customization after application launch.
    FamilyViewController *viewController1 = [[[FamilyViewController alloc] initWithNibName:@"FirstViewController" bundle:nil] autorelease];
    viewController1.title = NSLocalizedString(@"Families", @"Family");
    viewController1.tabBarItem.image = [UIImage imageNamed:@"account"];
    viewController1.type = System;

    FamilyViewController *viewController3 = [[[FamilyViewController alloc] initWithNibName:@"FirstViewController" bundle:nil] autorelease];
    viewController3.type = Custom;
    viewController3.title = NSLocalizedString(@"Custom Font", @"Family");
    viewController3.tabBarItem.image = [UIImage imageNamed:@"custom"];
    
    StyleViewController *viewController2 = [[[StyleViewController alloc] initWithNibName:@"SecondViewController" bundle:nil] autorelease];
    
    SettingViewController *viewController4 = [[[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil] autorelease];
    
    UINavigationController *sysmbolNav = [[[UINavigationController alloc] initWithRootViewController:sysmbolNameViewController] autorelease];
    
    UINavigationController *navigationController1 = [[[UINavigationController alloc] initWithRootViewController:viewController1] autorelease];
    UINavigationController *navigationController2 = [[[UINavigationController alloc] initWithRootViewController:viewController2] autorelease];
    UINavigationController *navigationController3 = [[[UINavigationController alloc] initWithRootViewController:viewController3] autorelease];
    
    UINavigationController *navigationController4 = [[[UINavigationController alloc] initWithRootViewController:viewController4] autorelease];
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:navigationController1, navigationController2, sysmbolNav, navigationController3, navigationController4, nil];
    self.window.rootViewController = self.tabBarController;

#if FreeApp
    // Initialize the banner at the bottom of the screen.
    CGPoint origin = CGPointMake(0.0, 0.0);
    // Use predefined GADAdSize constants to define the GADBannerView.
    self.adBanner = [[[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner
                                                    origin:origin]
                     autorelease];
    
    // Note: Edit SampleConstants.h to provide a definition for kSampleAdUnitID
    // before compiling.
    self.adBanner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.adBanner.adUnitID = @"a151874a72e0ad9";
    self.adBanner.delegate = self;
    [self.adBanner setRootViewController:self.tabBarController];
    self.adBanner.center =
    CGPointMake(self.window.center.x, self.adBanner.center.y);
    [self.adBanner loadRequest:[self createRequest]];
#endif
    
    [self.window makeKeyAndVisible];
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorFromHex:BlueNavigationBar]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    [iRate sharedInstance].onlyPromptIfLatestVersion = NO;
    [iRate sharedInstance].daysUntilPrompt = 1.0;
    [Flurry startSession:@"BM4D8CXT5SMRMNP6XKNQ"];
    return YES;
}

#if FreeApp
// Here we're creating a simple GADRequest and whitelisting the application
// for test ads. You should request test ads during development to avoid
// generating invalid impressions and clicks.
- (GADRequest *)createRequest {
    GADRequest *request = [GADRequest request];
   
    return request;
}

#pragma mark GADBannerViewDelegate impl

// We've received an ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Received ad successfully");
}

- (void)adView:(GADBannerView *)view
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}
#endif

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
