//
//  RouteDetails.m
//  sharekni
//
//  Created by Mohamed Abd El-latef on 11/19/15.
//
//

#import "RouteDetails.h"
#import "HelpManager.h"
@implementation RouteDetails

+ (NSDictionary *)mapping {
    
    NSMutableDictionary *mapping = [NSMutableDictionary dictionary];
    
    mapping[@"ID"] = @"ID";
    mapping[@"RouteArName"] = @"RouteArName";
    mapping[@"RouteEnName"] = @"RouteEnName";
    mapping[@"PreferredGender"] = @"PreferredGender";
    
    mapping[@"NoOfSeats"] = @"NoOfSeats";
    mapping[@"AccountId"] = @"AccountId";
    
    mapping[@"NationalityId"] = @"NationalityId";
    mapping[@"NationalityArName"] = @"NationalityArName";
    mapping[@"NationalityEnName"] = @"NationalityEnName";
    mapping[@"NationalityFrName"] = @"NationalityFrName";
    mapping[@"NationalityChName"] = @"NationalityChName";
    mapping[@"NationalityUrName"] = @"NationalityUrName";
    
    mapping[@"PrefLanguageId"] = @"PrefLanguageId";
    mapping[@"PrefLanguageArName"] = @"PrefLanguageArName";
    mapping[@"PrefLanguageEnName"] = @"PrefLanguageEnName";
    mapping[@"PrefLanguageFrName"] = @"PrefLanguageFrName";
    mapping[@"PrefLanguageChName"] = @"PrefLanguageChName";
    mapping[@"PrefLanguageUrName"] = @"PrefLanguageUrName";
    
    mapping[@"FromEmirateId"] = @"FromEmirateId";
    mapping[@"ToEmirateId"] = @"ToEmirateId";
    mapping[@"FromRegionId"] = @"FromRegionId";
    mapping[@"ToRegionId"] = @"ToRegionId";
    
    mapping[@"FromEmirateArName"] = @"FromEmirateArName";
    mapping[@"FromEmirateEnName"] = @"FromEmirateEnName";
    mapping[@"FromEmirateNameFr"] = @"FromEmirateNameFr";
    mapping[@"FromEmirateNameCh"] = @"FromEmirateNameCh";
    mapping[@"FromEmirateNameUr"] = @"FromEmirateNameUr";
    
    mapping[@"ToEmirateArName"] = @"ToEmirateArName";
    mapping[@"ToEmirateEnName"] = @"ToEmirateEnName";
    mapping[@"ToEmirateNameFr"] = @"ToEmirateNameFr";
    mapping[@"ToEmirateNameCh"] = @"ToEmirateNameCh";
    mapping[@"ToEmirateNameUr"] = @"ToEmirateNameUr";
    
    mapping[@"FromRegionArName"] = @"FromRegionArName";
    mapping[@"FromRegionEnName"] = @"FromRegionEnName";
    mapping[@"FromRegionNameFr"] = @"FromRegionNameFr";
    mapping[@"FromRegionNameCh"] = @"FromRegionNameCh";
    mapping[@"FromRegionNameUr"] = @"FromRegionNameUr";
    
    mapping[@"ToRegionArName"] = @"ToRegionArName";
    mapping[@"ToRegionEnName"] = @"ToRegionEnName";
    mapping[@"ToRegionNameFr"] = @"ToRegionNameFr";
    mapping[@"ToRegionNameCh"] = @"ToRegionNameCh";
    mapping[@"ToRegionNameUr"] = @"ToRegionNameUr";
    
    mapping[@"VehicelId"] = @"VehicelId";
    mapping[@"VehicleArName"] = @"VehicleArName";
    mapping[@"VehicleEnName"] = @"VehicleEnName";
    
    mapping[@"BasisId"] = @"BasisId";
    mapping[@"BasisArName"] = @"BasisArName";
    mapping[@"BasisEnName"] = @"BasisEnName";
    mapping[@"BasisFrName"] = @"BasisFrName";
    mapping[@"BasisChName"] = @"BasisChName";
    mapping[@"BasisUrName"] = @"BasisUrName";
    
    mapping[@"IsSmoking"] = @"IsSmoking";
    mapping[@"IsRounded"] = @"IsRounded";
    mapping[@"IsPassenger"] = @"IsPassenger";
    
    mapping[@"Saturday"] = @"Saturday";
    mapping[@"Sunday"] = @"Sunday";
    mapping[@"Monday"] = @"Monday";
    mapping[@"Tuesday"] = @"Tuesday";
    mapping[@"Wendenday"] = @"Wendenday";
    mapping[@"Thrursday"] = @"Thrursday";
    mapping[@"Friday"] = @"Friday";
    
    mapping[@"StartTime"] = @"StartTime";
    mapping[@"EndTime"] = @"EndTime";
    mapping[@"StartFromTime"] = @"StartFromTime";
    mapping[@"StartToTime"] = @"StartToTime";
    mapping[@"EndFromTime"] = @"EndFromTime";
    mapping[@"EndToTime_"] = @"EndToTime_";
    
    mapping[@"FromStreetName"] = @"FromStreetName";
    mapping[@"ToStreetName"] = @"ToStreetName";
    mapping[@"Remarks"] = @"Remarks";
    
    mapping[@"StartDate"] = @"StartDate";
    mapping[@"AgeRangeId"] = @"AgeRangeId";
    mapping[@"StartLat"] = @"StartLat";
    mapping[@"StartLng"] = @"StartLng";
    mapping[@"EndLat"] = @"EndLat";
    mapping[@"EndLng"] = @"EndLng";
    mapping[@"AgeRangeID"] = @"AgeRangeID";
    mapping[@"AgeRange"] = @"AgeRange";
    mapping[@"AccountRating"] = @"AccountRating";    
    return mapping;
}

- (void) setStartFromTime:(NSString *)StartFromTime{
    _StartFromTime = StartFromTime;
    _StartFromTime = [[HelpManager sharedHelpManager] timeFormateFromTimeString:_StartFromTime];
}

- (void) setEndFromTime:(NSString *)EndFromTime{
    _EndFromTime = EndFromTime;
    _EndFromTime = [[HelpManager sharedHelpManager] timeFormateFromTimeString:_EndFromTime];
}

- (void) setStartToTime:(NSString *)StartToTime{
    _StartToTime = StartToTime;
    _StartToTime = [[HelpManager sharedHelpManager] timeFormateFromTimeString:_StartToTime];
}

- (void) setEndToTime_:(NSString *)EndToTime_{
    _EndToTime_ = EndToTime_;
    _EndToTime_ = [[HelpManager sharedHelpManager] timeFormateFromTimeString:_EndToTime_];
}

- (void)setPreferredGender:(NSString *)PreferredGender{
    if ([PreferredGender containsString:@"M"]) {
        _PreferredGender = @"Male";
    }
    else if ([PreferredGender containsString:@"F"]){
        _PreferredGender = @"Female";
    }
    else{
        _PreferredGender = @"Not Specified";
    }
}
@end
