//
//  HelpManager.h
//  Sharekni
//
//  Created by ITWORX on 9/28/15.
//
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "User.h"
@interface HelpManager : NSObject

@property (nonatomic,strong) NSString *imagesDirectory;
@property (nonatomic,strong) NSDateFormatter *dateFormatter;
- (void) showAlertWithMessage:(NSString *)message;
+ (HelpManager *) sharedHelpManager;
- (NSInteger) yearsBetweenDate:(NSDate *)date1 andDate:(NSDate *)date2;



- (NSString *) getUserPasswordFromUserDefaults;
- (void) deleteUserFromUSerDefaults;
- (NSString *) getUserNameFromUserDefaults;
- (void) saveUserNameInUserDefaults:(NSString *)userName;
- (void) saveUserPasswordInUserDefaults:(NSString *)password;
- (NSString *) timeFormateFromTimeString:(NSString *)inputString;
- (BOOL) isDateBefor1900:(NSDate *)date;
@end
