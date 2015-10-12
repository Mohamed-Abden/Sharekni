//
//  BestDriver.m
//  Sharekni
//
//  Created by Ahmed Askar on 10/9/15.
//
//

#import "BestDriver.h"

@implementation BestDriver

+ (NSDictionary *)mapping {
    NSMutableDictionary *mapping = [NSMutableDictionary dictionary];
    mapping[@"AccountId"] = @"AccountId";
    mapping[@"AccountName"] = @"AccountName";
    mapping[@"AccountPhoto"] = @"AccountPhoto";
    mapping[@"AccountMobile"] = @"AccountMobile";
    mapping[@"NationalityArName"] = @"NationalityArName";
    mapping[@"NationalityEnName"] = @"NationalityEnName";
    mapping[@"NationalityFrName"] = @"NationalityFrName";
    mapping[@"NationalityChName"] = @"NationalityChName";
    mapping[@"NationalityUrName"] = @"NationalityUrName";
    mapping[@"Rating"] = @"Rating";
    return mapping;
}

@end