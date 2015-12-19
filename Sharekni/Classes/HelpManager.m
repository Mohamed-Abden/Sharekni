//
//  HelpManager.m
//  Sharekni
//
//  Created by ITWORX on 9/28/15.
//
//

#import "HelpManager.h"
#import <UIColor+Additions.h>
#import <CRToast.h>
#import "Constants.h"
#import "NSObject+Blocks.h"

#define USERNAME_KEY @"APPLICATION_USER_NAME"
#define PASSWORD_KEY @"APPLICATION_USER_PASSWORD"

@implementation HelpManager

- (void) showAlertWithMessage:(NSString *)message{
//    NSDictionary *options = @{
//                              kCRToastTextKey :message,
//                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
//                              kCRToastBackgroundColorKey : [UIColor whiteColor],
//                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeSpring),
//                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeSpring),
//                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionBottom),
//                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
//                              kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
//                              kCRToastTextColorKey : [UIColor add_colorWithRGBHexString:Red_HEX]
//                              
////                              kCRToastImageKey : [UIImage imageNamed:@""],
////                              kCRToastImageAlignmentKey :NSTextAlignmentLeft,
//                              };
//    [CRToastManager showNotificationWithOptions:options
//                                completionBlock:^{
//                                    NSLog(@"Completed");
//                                    
//                                }];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"", nil) message:message delegate:nil cancelButtonTitle:GET_STRING(@"Ok") otherButtonTitles:nil, nil];
    [alertView show];
}

- (NSString *)imagesDirectory{
    if (!_imagesDirectory) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *basePath = paths.firstObject;
        _imagesDirectory = [basePath stringByAppendingPathComponent:@"CahcedImages"];
        if(![[NSFileManager defaultManager] fileExistsAtPath:_imagesDirectory]){
            [[NSFileManager defaultManager] createDirectoryAtPath:_imagesDirectory withIntermediateDirectories:NO attributes:0 error:nil];
        }
    }
    return _imagesDirectory;
}


- (NSInteger) yearsBetweenDate:(NSDate *)date1 andDate:(NSDate *)date2{
    NSTimeInterval distanceBetweenDates = [date1 timeIntervalSinceDate:date2];
    double secondsInyear = 60 * 60 * 24 * 365;
    NSInteger yearsBetweenDates = distanceBetweenDates / secondsInyear;
    return yearsBetweenDates;
}

- (BOOL) isDateBefor1900:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger desiredComponents = (NSCalendarUnitYear);
    NSDateComponents *components = [calendar components:desiredComponents fromDate:date];
    if (components.year > 1900) {
        return NO;
    }
    else{
        return YES;
    }
}

- (void) saveUserPasswordInUserDefaults:(NSString *)password{
    [[NSUserDefaults standardUserDefaults] setValue:password forKey:PASSWORD_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *) getUserPasswordFromUserDefaults{
    NSString *password = [[NSUserDefaults standardUserDefaults] valueForKey:PASSWORD_KEY];
    return password;
}

- (void) saveUserNameInUserDefaults:(NSString *)userName{
    [[NSUserDefaults standardUserDefaults] setValue:userName forKey:USERNAME_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *) getUserNameFromUserDefaults{
    NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:USERNAME_KEY];
    return userName;
}

- (void) deleteUserFromUSerDefaults{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERNAME_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:PASSWORD_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDateFormatter *)dateFormatter{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

- (NSString *) timeFormateFromTimeString:(NSString *)inputString {
    if ([inputString containsString:@"AM"]) {
         inputString = [inputString stringByReplacingOccurrencesOfString:@"AM" withString:@" AM"];
    }
    else if ([inputString containsString:@"PM"]) {
        inputString = [inputString stringByReplacingOccurrencesOfString:@"PM" withString:@" PM"];
    }
    
    self.dateFormatter.dateFormat = @"MMM dd yyy hh:mm a";
    NSDate *startTime = [self.dateFormatter dateFromString:inputString];
    
    
    self.dateFormatter.dateFormat = @"hh:mm a";
    NSString *timeString = [self.dateFormatter stringFromDate:startTime];
    return timeString;
}

SYNTHESIZE_SINGLETON_FOR_CLASS(HelpManager);
@end