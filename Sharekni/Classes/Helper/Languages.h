//
//  Languages.h
//  KaizenCare
//
//  Created by Askar on 3/25/12.
//  Copyright (c) 2012 Askar. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GET_STRING(key) [[Languages sharedLanguageInstance] getStringForKey:key]
#define KIS_ARABIC  ([Languages sharedLanguageInstance].language == 0)
#define LANGUAGE_KEY @"language_key"
#define LANGUAGE_CHANGE_NOTIFICATION @"language_change_notification"

typedef enum {
	Arabic = 0,
	English
} LanguageType;

@interface Languages : NSObject

@property (nonatomic, readonly) LanguageType language;

// Initialization
+ (Languages *)sharedLanguageInstance;

// Setting Language
- (void)setLanguage:(LanguageType)newLanguage;

// Getting Strings
- (NSString *)getStringForKey:(NSString *)key;

// Adjust Bundle
- (void)adjustBundle;
@end
