//
//  AppDelegate.h
//  FontDesigner
//
//  Created by chenshun on 13-5-5.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GADBannerView.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    NSMutableArray *systemFontFamily;
     //GADBannerView *adBanner;
}
@property (nonatomic, retain)NSMutableArray *systemFontFamily;
@property (strong, nonatomic) UIWindow *window;
//@property (nonatomic, retain) GADBannerView *adBanner;
@property (strong, nonatomic) UITabBarController *tabBarController;

@end
