//
//  Languages.m
//  KaizenCare
//
//  Created by Askar on 3/25/12.
//  Copyright (c) 2012 Askar. All rights reserved.
//

#import "Languages.h"

#define LANGUAGE_KEY @"language_key"
#define LANGUAGE_CHANGE_NOTIFICATION @"language_change_notification"

@interface Languages()

@end

@implementation Languages
{
    NSBundle *currentBundle;
}

@synthesize language ;

#pragma mark - Initialization

- (id)init{
	self = [super init];
	if (self) {
		NSNumber *userLang = [[NSUserDefaults standardUserDefaults] objectForKey:LANGUAGE_KEY];
		if (userLang == nil) {
			NSString *deviceLang = [[NSLocale preferredLanguages] objectAtIndex:0];
			if ([deviceLang isEqualToString:@"ar"]) {
				language = Arabic;
			} else {
				language = English;
			}
			[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:language] forKey:LANGUAGE_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
		} else {
			language = [userLang intValue];
		}
		
		[self adjustBundle];
	}
	return self;
}

+ (Languages *)sharedLanguageInstance
{
    static Languages *_sharedInstance = nil ;
    
    static dispatch_once_t oncePredict ;
    
    dispatch_once(&oncePredict, ^{
        _sharedInstance = [[Languages alloc] init];
    });

    return _sharedInstance ;
}

#pragma mark - Adujusting Language

- (void)setLanguage:(LanguageType)newLanguage{
	if (language != newLanguage) {
		language = newLanguage;
		[self adjustBundle];
	}
}

- (void)adjustBundle
{    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:language] forKey:LANGUAGE_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
	switch (language) {
		case Arabic:
			currentBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"ar" ofType:@"lproj"]];
			break;
		case English:
			currentBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"]];
			break;
	}
}

#pragma mark - Getting Strings

- (NSString *)getStringForKey:(NSString *)key{
	return [currentBundle localizedStringForKey:key value:@"key not found" table:nil];
}

@end
