//
//  AppDelegate.h
//  Sharekni
//
//  Created by ITWORX on 9/17/15.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


- (void) showWelcomeNavigationController;
- (void)reloadApp ;

@end

