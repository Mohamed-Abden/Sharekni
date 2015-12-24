//
//  AppDelegate.m
//  Sharekni
//
//  Created by ITWORX on 9/17/15.
//
//

#import "AppDelegate.h"
#import "MasterDataManager.h"
#import "Sharekni.pch"
#import "MobAccountManager.h"
#import <MZFormSheetController.h>
#import "WelcomeViewController.h"
#import <KVNProgress/KVNProgress.h>
#import <KVNProgress/KVNProgressConfiguration.h>
#import "WelcomeViewController.h"
#import "HomeViewController.h"
#import "SplashViewController.h"
#import <REFrostedViewController.h>
#import "HomeViewController.h"
#import "SideMenuTableViewController.h"
#import "Languages.h"


@import AdSupport;
@import CoreTelephony;
@import MobileCoreServices;
@import iAd;
@import StoreKit;
@import SystemConfiguration;
@import MobileAppTracker;

//com.sharekni.sharekni
//rta.ae.sharekni

NSString * const TUNE_ADVERTISER_ID  = @"189698";
NSString * const TUNE_CONVERSION_KEY = @"172510cf81e7148e5a01851f65fb0c7e";
NSString * const TUNE_PACKAGE_NAME   = @"rta.ae.sharekni";

@import GoogleMaps;

@interface AppDelegate ()<REFrostedViewControllerDelegate,TuneDelegate>
@property (nonatomic,strong) UINavigationController *splashNavigationController;
@property (nonatomic,strong) REFrostedViewController *homeViewController;
@property (nonatomic,strong) UINavigationController *welcomeNavigationController;
@end

@implementation AppDelegate


- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    sleep(1);
    [Tune initializeWithTuneAdvertiserId:TUNE_ADVERTISER_ID
                       tuneConversionKey:TUNE_CONVERSION_KEY
                         tunePackageName:TUNE_PACKAGE_NAME
                                wearable:NO];
    
    [Tune setDelegate:self];
    
    [Tune setRedirectUrl:@"https://itunes.apple.com/us/app/rta-sharekni/id989008714?ls=1&mt=8"];
    
    [Tune setDebugMode:NO];
    
    [Tune setAllowDuplicateRequests:NO];
    
    [Tune checkForDeferredDeeplink:self];
    
    [Tune startAppToAppMeasurement:TUNE_PACKAGE_NAME advertiserId:TUNE_ADVERTISER_ID offerId:@"" publisherId:@"" redirect:YES];

    [Tune measureSession];

    [self configureAppearance];
    
    self.window.rootViewController = self.splashNavigationController;

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)tuneDidSucceedWithData:(NSData *)data
{
    NSLog(@"data :%@",data);
}

- (void)tuneDidFailWithError:(NSError *)error
{
    NSLog(@"error :%@",error);
}

- (void)reloadApp
{
    self.splashNavigationController = nil ;
    self.welcomeNavigationController = nil ;
    self.window.rootViewController = nil ;
    self.window.rootViewController = self.splashNavigationController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

#pragma mark - APPEARANCE
- (void) configureAppearance{
    [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
    [[MZFormSheetBackgroundWindow appearance] setBlurRadius:1.0];
    [[MZFormSheetBackgroundWindow appearance] setBlurEffectStyle:UIBlurEffectStyleDark];
    [[MZFormSheetBackgroundWindow appearance] setBackgroundColor:[UIColor clearColor]];
    
    
    [[UINavigationBar appearance] setBarTintColor:RGBA(230, 0, 10, 1)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    KVNProgressConfiguration * progressConfiguration = [KVNProgress configuration];
    progressConfiguration.backgroundType = KVNProgressBackgroundTypeSolid;
    
    [GMSServices provideAPIKey:GoogleMapsAPIKey];
}

- (UINavigationController *)splashNavigationController{
    if (!_splashNavigationController) {
        SplashViewController *splashViewController = [[SplashViewController alloc] initWithNibName:@"SplashViewController" bundle:nil];
        __block AppDelegate *blockSelf = self;
        [splashViewController setFinishedCallBack:^(User *user) {
//            [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
                if (user) {
                    blockSelf.window.rootViewController = blockSelf.homeViewController;
                }
                else{
                    blockSelf.window.rootViewController = blockSelf.welcomeNavigationController;
                }
            [blockSelf.window makeKeyAndVisible];
//            } completion:nil];
        }];
        _splashNavigationController = [[UINavigationController alloc] initWithRootViewController:splashViewController];
    }
    return _splashNavigationController;
}

- (REFrostedViewController *) homeViewController {
    
    HomeViewController *homeViewControlle = [[HomeViewController alloc] initWithNibName:(KIS_ARABIC)?@"HomeViewController_ar":@"HomeViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeViewControlle];
    SideMenuTableViewController  *menuController = [[SideMenuTableViewController alloc] initWithNavigationController:navigationController];
    
    
    // Create frosted view controller
    //
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.liveBlur = YES;
    frostedViewController.delegate = self;
    
    return frostedViewController;
}

- (UINavigationController *)welcomeNavigationController
{
    if (!_welcomeNavigationController) {
        WelcomeViewController *welcomeViewController = [[WelcomeViewController alloc] initWithNibName:(KIS_ARABIC)?@"WelcomeViewController_ar":@"WelcomeViewController" bundle:nil];
        
               _welcomeNavigationController = [[UINavigationController alloc] initWithRootViewController:welcomeViewController];
        }
    return _welcomeNavigationController;
}

- (void)showWelcomeNavigationController{
    self.window.rootViewController = self.welcomeNavigationController;
}


@end
