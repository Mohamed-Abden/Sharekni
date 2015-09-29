//
//  HelpManager.h
//  Sharekni
//
//  Created by ITWORX on 9/28/15.
//
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

@interface HelpManager : NSObject
- (void) showToastWithMessage:(NSString *)message;
+(HelpManager *) sharedHelpManager;
@end