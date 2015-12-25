//
//  MostRideDetails.m
//  Sharekni
//
//  Created by Mohamed Abd El-latef on 10/18/15.
//
//

#import "MostRideDetails.h"
#import "MobAccountManager.h"
@implementation MostRideDetails

+ (NSDictionary *)mapping {
    NSMutableDictionary *mapping = [NSMutableDictionary dictionary];
    mapping[@"RouteId"] = @"RouteId";
    mapping[@"RouteArName"] = @"RouteArName";
    mapping[@"RouteEnName"] = @"RouteEnName";
    mapping[@"NoOfSeats"] = @"NoOfSeats";
    mapping[@"AccountId"] = @"AccountId";
    mapping[@"DriverName"] = @"DriverName";
    mapping[@"DriverMobile"] = @"DriverMobile";
    mapping[@"DriverPhoto"] = @"DriverPhoto";    
//    mapping[@"Rating"] = @"Rating";
    
    mapping[@"NationalityArName"] = @"NationalityArName";
    mapping[@"NationlityEnName"] = @"NationlityEnName";
    mapping[@"NationlityFrName"] = @"NationlityFrName";
    mapping[@"NationlityChName"] = @"NationlityChName";
    mapping[@"NationlityUrName"] = @"NationlityUrName";
    
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
    
    
    mapping[@"CoordinatesStartLat"] = @"CoordinatesStartLat";
    mapping[@"CoordinatesStartLng"] = @"CoordinatesStartLng";
    mapping[@"CoordinatesEndLat"] = @"CoordinatesEndLat";
    mapping[@"CoordinatesEndLng"] = @"CoordinatesEndLng";
    
    mapping[@"Saturday"] = @"Saturday";
    mapping[@"Sunday"] = @"Sunday";
    mapping[@"Monday"] = @"Monday";
    mapping[@"Tuesday"] = @"Tuesday";
    mapping[@"Wendenday"] = @"Wendenday";
    mapping[@"Thrursday"] = @"Thrursday";
    mapping[@"Friday"] = @"Friday";
    
    mapping[@"StartTime"] = @"StartTime";
    mapping[@"EndTime"] = @"EndTime";
    return mapping;
}

- (void)setAccountId:(NSString *)AccountId{
    _AccountId = AccountId;
    __block MostRideDetails *blockSelf = self;
    [[MobAccountManager sharedMobAccountManager] getCalculatedRatingForAccount:AccountId WithSuccess:^(NSString *rating) {
        blockSelf.Rating = rating;
    } Failure:^(NSString *error) {
        blockSelf.Rating = @"0.0";
    }];
}

- (void)setDriverPhoto:(NSString *)DriverPhoto
{
    __block MostRideDetails *blockSelf = self;
    _DriverPhoto = DriverPhoto ;
    [[MobAccountManager sharedMobAccountManager] GetPhotoWithName:DriverPhoto withSuccess:^(UIImage *image, NSString *filePath) {
        if(image){
            blockSelf.driverImage = image;
            blockSelf.driverImagePath = filePath;
        }
        else{
            blockSelf.driverImage = [UIImage imageNamed:@"thumbnail"];
            blockSelf.driverImagePath = nil;
        }
    } Failure:^(NSString *error) {
        blockSelf.driverImage = [UIImage imageNamed:@"thumbnail"];
        blockSelf.driverImagePath = nil;
    }];
}

@end
