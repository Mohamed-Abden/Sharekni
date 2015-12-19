//
//  MasterDataManager.m
//  Sharekni
//
//  Created by Mohamed Abd El-latef on 9/27/15.
//
//

#import "MasterDataManager.h"
#import "Constants.h"
#import "AgeRange.h"
#import "Nationality.h"
#import "TermsAndCondition.h"
#import <Genome.h>
#import "Language.h"
#import "Employer.h"
#import "Emirate.h"
#import "BestDriver.h"
#import "MostRide.h"
#import "Region.h"
#import "HelpManager.h"
#import "Base64.h"
#import "Constants.h"
#import "MostRideDetails.h"
#import "DriverDetails.h"
#import "Review.h"
#import "Vehicle.h"
#import "MobAccountManager.h"
#import "Passenger.h"
#import "Notification.h"
#import "Permit.h"

#define AccountId @"AccountID"
#define FromEmirateId  @"FromEmirateID"
#define FromRegionId    @"FromRegionID"
#define ToEmirateId  @"ToEmirateID"
#define ToRegionId  @"ToRegionID"


@interface MasterDataManager ()
@property (strong,nonatomic) NSArray *nationalties;
@property (strong,nonatomic) NSArray *languages;
@property (strong,nonatomic) NSArray *ageRanges;
@property (strong,nonatomic) NSArray *emirates;
@property (strong,nonatomic) NSMutableDictionary *vehiclesDictionary;

@property (strong,nonatomic) TermsAndCondition *termsAndCondition;
@property (strong,nonatomic) NSMutableDictionary *regionsDictionary;
@end

@implementation MasterDataManager

- (instancetype)init{
    if (self = [super init]) {

    }
    return self;
}

- (NSMutableDictionary *)vehiclesDictionary{
    if (!_vehiclesDictionary) {
        _vehiclesDictionary = [[NSMutableDictionary alloc] init];
    }
    return _vehiclesDictionary;
}

- (void) GetAgeRangesWithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure{
    if (self.ageRanges) {
        success([self.ageRanges mutableCopy]);
    }
    else{
        __block MasterDataManager *blockSelf = self;
        [self.operationManager GET:GetAgeRanges_URL parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
            NSLog(@"%@",responseObject);
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            responseString = [self jsonStringFromResponse:responseString];
            NSError *jsonError;
            NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *resultDictionaries = [NSJSONSerialization JSONObjectWithData:objectData
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:&jsonError];
            NSMutableArray *ageRanges = [NSMutableArray array];
            for (NSDictionary *dictionary in resultDictionaries) {
                AgeRange *range= [AgeRange gm_mappedObjectWithJsonRepresentation:dictionary];
                [ageRanges addObject:range];
            }
            if (ageRanges.count > 0) {
                blockSelf.ageRanges = ageRanges;                
            }
            if (success) {
                success(ageRanges);
            }
        } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
            NSLog(@"Error %@",error.description);
            failure(error.description);
        }];
    }
}

- (void) GetNationalitiesByID:(NSString *)ID WithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure{
    if (self.nationalties) {
        success([self.nationalties mutableCopy]);
    }
    else{
        __block MasterDataManager *blockSelf = self;
        NSDictionary *parameters = @{id_KEY:ID};
        [self.operationManager GET:GetNationalities_URL parameters:parameters success:^void(AFHTTPRequestOperation * operation, id responseObject) {
            
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            responseString = [self jsonStringFromResponse:responseString];
            NSError *jsonError;
            NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *resultDictionaries = [NSJSONSerialization JSONObjectWithData:objectData
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:&jsonError];
            NSMutableArray *nationalities = [NSMutableArray array];
            for (NSDictionary *dictionary in resultDictionaries) {
                Nationality *nationality= [Nationality gm_mappedObjectWithJsonRepresentation:dictionary];
                [nationalities addObject:nationality];
            }
            if (nationalities.count == 0) {
                blockSelf.nationalties = nationalities;
            }
            
            if (success) {
                success(nationalities);
            }

        } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
            NSLog(@"Error %@",error.description);
            failure(error.description);
        }];
    }
}

- (void) GetTermsAndConditionsWithSuccess:(void (^) (TermsAndCondition *termsAndCondition))success Failure:(void (^)(NSString *error))failure{
    if (self.termsAndCondition) {
        success(self.termsAndCondition);
    }
    else{
        __block MasterDataManager *blockSelf = self;
        [self.operationManager GET:GetTermsAndConditions_URL parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
            NSLog(@"%@",responseObject);
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            responseString = [self jsonStringFromResponse:responseString];
            NSError *jsonError;
            NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:objectData
                                                                             options:NSJSONReadingMutableContainers
                                                                               error:&jsonError];
            
            TermsAndCondition *termsAndCondition = [TermsAndCondition gm_mappedObjectWithJsonRepresentation:resultDictionary];
            blockSelf.termsAndCondition = termsAndCondition;
            if (success) {
                success(termsAndCondition);
            }
        } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
            NSLog(@"Error %@",error.description);
            failure(error.description);
        }];
        
    }
}

- (void) GetPrefferedLanguagesWithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure{
    if (self.languages) {
        success([self.languages mutableCopy]);
    }
    else{
        __block MasterDataManager *blockSelf = self;
        [self.operationManager GET:GetPrefferedLanguages_URL parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            responseString = [self jsonStringFromResponse:responseString];
            NSError *jsonError;
            NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *resultDictionaries = [NSJSONSerialization JSONObjectWithData:objectData
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:&jsonError];
            
            NSMutableArray *languages = [NSMutableArray array];
            for (NSDictionary *dictionary in resultDictionaries) {
                Language *language= [Language gm_mappedObjectWithJsonRepresentation:dictionary];
                [languages addObject:language];
            }
            if(languages.count > 0){
                blockSelf.languages = languages;
            }

            if (success) {
                success(languages);
            }

        } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
            NSLog(@"Error %@",error.description);
            failure(error.description);
        }];
        
    }
}

- (void) GetEmployersWithID:(NSString *)ID WithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure{
    NSDictionary *parameters = @{id_KEY:ID};
    [self.operationManager GET:GetEmployers_URL parameters:parameters success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseString = [self jsonStringFromResponse:responseString];
        NSError *jsonError;
        NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *resultDictionaries = [NSJSONSerialization JSONObjectWithData:objectData
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:&jsonError];
        
        NSMutableArray *employers = [NSMutableArray array];
        for (NSDictionary *dictionary in resultDictionaries) {
            Employer *employer= [Employer gm_mappedObjectWithJsonRepresentation:dictionary];
            [employers addObject:employer];
        }
        success(employers);
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"Error %@",error.description);
        failure(error.description);
    }];
}

- (void) GetEmiratesWithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure{
    if(self.emirates){
        success([self.emirates mutableCopy]);
    }
    else{
        [self.operationManager GET:GetEmirates_URL parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            responseString = [self jsonStringFromResponse:responseString];
            NSError *jsonError;
            NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *resultDictionaries = [NSJSONSerialization JSONObjectWithData:objectData
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:&jsonError];
            NSMutableArray *emirates = [NSMutableArray array];
            for (NSDictionary *dictionary in resultDictionaries) {
                Emirate *emirtae= [Emirate gm_mappedObjectWithJsonRepresentation:dictionary];
                [emirates addObject:emirtae];
            }
            if(emirates.count > 0){
                self.emirates = emirates;
            }

            success(emirates);
        } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
            NSLog(@"Error %@",error.description);
            failure(error.description);
        }];
    }
}

- (void) GetBestDrivers:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure
{
    [self.operationManager GET:GetBestDrivers_URL parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
     
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseString = [self jsonStringFromResponse:responseString];
        NSError *jsonError;
        NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *resultDictionaries = [NSJSONSerialization JSONObjectWithData:objectData
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:&jsonError];
        NSMutableArray *bestDrivers = [NSMutableArray array];
        for (NSDictionary *dictionary in resultDictionaries) {
            BestDriver *driver= [BestDriver gm_mappedObjectWithJsonRepresentation:dictionary];

            [self GetPhotoWithName:driver.AccountPhoto withSuccess:^(UIImage *image, NSString *filePath) {
                
            } Failure:^(NSString *error) {
                
            }];
            [bestDrivers addObject:driver];
        }
        
        success(bestDrivers);
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"Error %@",error.description);
        failure(error.description);
    }];
}

- (void) GetMostRides:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure
{
    [self.operationManager GET:GetMostRides_URL parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseString = [self jsonStringFromResponse:responseString];
        NSError *jsonError;
        NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *resultDictionaries = [NSJSONSerialization JSONObjectWithData:objectData
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:&jsonError];
        NSMutableArray *mostRides = [NSMutableArray array];
        for (NSDictionary *dictionary in resultDictionaries) {
            MostRide *driver= [MostRide gm_mappedObjectWithJsonRepresentation:dictionary];
            [mostRides addObject:driver];
        }
        success(mostRides);
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"Error %@",error.description);
        failure(error.description);
    }];
}

- (void) getRideDetails:(NSString *)accountID FromEmirateID:(NSString *)fromEmirateID FromRegionID:(NSString *)fromRegionID ToEmirateID:(NSString *)toEmirateID ToRegionID:(NSString *)toRegionID WithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure
{
    NSString *path = [NSString stringWithFormat:@"cls_mobios.asmx/GetMostDesiredRideDetails?AccountID=%@&FromEmirateID=%@&FromRegionID=%@&ToEmirateID=%@&ToRegionID=%@",accountID,fromEmirateID,fromRegionID,toEmirateID,toRegionID];

    [self.operationManager GET:path parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
      
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
      
        responseString = [self jsonStringFromResponse:responseString];
        
        NSError *jsonError;
        NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *resultDictionaries = [NSJSONSerialization JSONObjectWithData:objectData
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:&jsonError];
        
        NSMutableArray *mostRideDetails = [NSMutableArray array];
        for (NSDictionary *dictionary in resultDictionaries) {
            MostRideDetails *rideDetails= [MostRideDetails gm_mappedObjectWithJsonRepresentation:dictionary];
            [mostRideDetails addObject:rideDetails];
        }
        success(mostRideDetails);
        
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error.localizedDescription);
    }];
}


- (void) getDriverRideDetails:(NSString *)accountID WithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure
{
    NSString *path = [NSString stringWithFormat:@"cls_mobios.asmx/GetDriverDetailsByAccountId?AccountId=%@",accountID];
    [self.operationManager GET:path parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        responseString = [self jsonStringFromResponse:responseString];
        
        NSError *jsonError;
        NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *resultDictionaries = [NSJSONSerialization JSONObjectWithData:objectData
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:&jsonError];
        
        NSMutableArray *rideDrivers = [NSMutableArray array];
        for (NSDictionary *dictionary in resultDictionaries) {
            DriverDetails *driverDetails = [DriverDetails gm_mappedObjectWithJsonRepresentation:dictionary];
            [rideDrivers addObject:driverDetails];
        }
        success(rideDrivers);
        
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error.localizedDescription);

    }];
}


- (void) GetRouteByRouteId:(NSString *)routeID withSuccess:(void (^)(RouteDetails *routeDetails))success Failure:(void (^)(NSString *error))failure{
    
    NSString *path = [NSString stringWithFormat:@"cls_mobios.asmx/GetRouteByRouteId?RouteId=%@",routeID];
    [self.operationManager GET:path parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        responseString = [self jsonStringFromResponse:responseString];
        
        NSError *jsonError;
        NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *resultDictionaries = [NSJSONSerialization JSONObjectWithData:objectData
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:&jsonError];
        if (resultDictionaries.count == 1) {
            RouteDetails *routeDetails = [RouteDetails gm_mappedObjectWithJsonRepresentation:resultDictionaries[0]];
            
            success(routeDetails);
        }
        else{
            failure(@"failed to map");
        }
        
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error.localizedDescription);

    }];
}


- (void) getReviewList:(NSString *)driverID andRoute:(NSString *)routeID withSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure{
    
    NSString *path = [NSString stringWithFormat:@"cls_mobios.asmx/Driver_GetReviewList?DriverId=%@&RouteId=%@",driverID,routeID];
    [self.operationManager GET:path parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        responseString = [self jsonStringFromResponse:responseString];
        
        NSError *jsonError;
        NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *resultDictionaries = [NSJSONSerialization JSONObjectWithData:objectData
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:&jsonError];
        
        NSMutableArray *reviews = [NSMutableArray array];
        for (NSDictionary *dictionary in resultDictionaries) {
            Review *review = [Review gm_mappedObjectWithJsonRepresentation:dictionary];
            [reviews addObject:review];
        }
        success(reviews);
        
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error.localizedDescription);
    }];
}

- (void) getSavedSearch:(NSString *)accountID withSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure
{
    NSString *path = [NSString stringWithFormat:@"cls_mobios.asmx/Passenger_GetSavedSearch?AccountId=%@",accountID];
    
    [self.operationManager GET:path parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        responseString = [self jsonStringFromResponse:responseString];
        
        NSError *jsonError;
        NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *resultDictionaries = [NSJSONSerialization JSONObjectWithData:objectData
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:&jsonError];
        
        NSMutableArray *rideDrivers = [NSMutableArray array];
        for (NSDictionary *dictionary in resultDictionaries) {
            MostRideDetails *rideDetails = [MostRideDetails gm_mappedObjectWithJsonRepresentation:dictionary];
            [rideDrivers addObject:rideDetails];
        }
        success(rideDrivers);
        
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error.localizedDescription);
    }];
}
- (void) getSavedVehicleById:(NSString *)accountID WithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure{
    
    if (!accountID)
    {
        accountID = [[MobAccountManager sharedMobAccountManager] applicationUserID];
    }
    
    NSMutableArray *savedVehicles = [self.vehiclesDictionary valueForKey:accountID];
    if (savedVehicles) {
        success(savedVehicles);
    }
    else{
        NSString *path = [NSString stringWithFormat:@"cls_mobios.asmx/GetByDriverId?id=%@",accountID];
        
        __block MasterDataManager *blockSelf = self;
        [self.operationManager GET:path parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
            
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            responseString = [self jsonStringFromResponse:responseString];
            
            NSError *jsonError;
            NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *resultDictionaries = [NSJSONSerialization JSONObjectWithData:objectData
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:&jsonError];
            
            NSMutableArray *vehicles = [NSMutableArray array];
            for (NSDictionary *dictionary in resultDictionaries) {
                Vehicle *vehicle = [Vehicle gm_mappedObjectWithJsonRepresentation:dictionary];
                [vehicles addObject:vehicle];
            }
            [blockSelf.vehiclesDictionary setValue:vehicles forKey:accountID];
            success(vehicles);
            
        } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
            failure(error.localizedDescription);
        }];
    }
    
}

- (void)getVehicleById:(NSString *)accountID WithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure
{
//    if (!accountID)
//    {
//        accountID = [[MobAccountManager sharedMobAccountManager] applicationUserID];
//    }
//    
//    NSMutableArray *savedVehicles = [self.vehiclesDictionary valueForKey:accountID];
//    if (savedVehicles) {
//        success(savedVehicles);
//    }
//    else{
        NSString *path = [NSString stringWithFormat:@"cls_mobios.asmx/GetByDriverId?id=%@",accountID];
        
        __block MasterDataManager *blockSelf = self;
        [self.operationManager GET:path parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
            
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            responseString = [self jsonStringFromResponse:responseString];
            
            NSError *jsonError;
            NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *resultDictionaries = [NSJSONSerialization JSONObjectWithData:objectData
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:&jsonError];
            
            NSMutableArray *vehicles = [NSMutableArray array];
            for (NSDictionary *dictionary in resultDictionaries) {
                Vehicle *vehicle = [Vehicle gm_mappedObjectWithJsonRepresentation:dictionary];
                [vehicles addObject:vehicle];
            }
            [blockSelf.vehiclesDictionary setValue:vehicles forKey:accountID];
            success(vehicles);
            
        } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
            failure(error.localizedDescription);
        }];
//    }
}

- (void)getRequestNotifications:(NSString *)accountID notificationType:(NotificationType)type WithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure ;
{
    NSString *path ;
    if (type == NotificationTypeAlert) {
        path = [NSString stringWithFormat:@"cls_mobios.asmx/Driver_AlertsForRequest?d_AccountId=%@",accountID];
    }else if (type == NotificationTypeAccepted) {
        path = [NSString stringWithFormat:@"cls_mobios.asmx/Passenger_GetAcceptedRequestsFromDriver?accountId=%@",accountID];
    }
    else if (type == NotificationTypePending) {
        path = [NSString stringWithFormat:@"cls_mobios.asmx/Passenger_GetPendingRequestsFromDriver?accountId=%@",accountID];
    }
    

    [self.operationManager GET:path parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        responseString = [self jsonStringFromResponse:responseString];
        
        NSError *jsonError;
        NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *resultDictionaries = [NSJSONSerialization JSONObjectWithData:objectData
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:&jsonError];
        
        NSMutableArray *notifications = [NSMutableArray array];
        for (NSDictionary *dictionary in resultDictionaries) {
            Notification *notification = [Notification gm_mappedObjectWithJsonRepresentation:dictionary];
            if(type == NotificationTypePending){
                notification.isPending = YES;
            }
            [notifications addObject:notification];
        }
        success(notifications);
        
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error.localizedDescription);
    }];
}

- (void)getPermits:(NSString *)accountID WithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure
{
    NSString *path = [NSString stringWithFormat:@"cls_mobios.asmx/GetPermitByDriverId?id=%@",accountID];

    [self.operationManager GET:path parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        responseString = [self jsonStringFromResponse:responseString];
        
        NSError *jsonError;
        NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *resultDictionaries = [NSJSONSerialization JSONObjectWithData:objectData
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:&jsonError];
        
        NSMutableArray *permits = [NSMutableArray array];
        for (NSDictionary *dictionary in resultDictionaries) {
            Permit *permit = [Permit gm_mappedObjectWithJsonRepresentation:dictionary];
            [permits addObject:permit];
        }
        success(permits);
        
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        failure(error.localizedDescription);
    }];
}


- (void) GetRegionsByEmirateID:(NSString *)emirateID withSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure{
    NSArray *savedRegions = [self getRegionsForEmirateID:emirateID];
    if (savedRegions) {
        success([savedRegions mutableCopy]);
    }
    else{
        __block MasterDataManager *blockSelf = self;
        NSDictionary *parameters = @{id_KEY:emirateID};
        [self.operationManager GET:GetRegionsByEmirateId_URL parameters:parameters success:^void(AFHTTPRequestOperation * operation, id responseObject) {
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            responseString = [self jsonStringFromResponse:responseString];
            NSError *jsonError;
            NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *resultDictionaries = [NSJSONSerialization JSONObjectWithData:objectData
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:&jsonError];
            NSMutableArray *regions = [NSMutableArray array];
            for (NSDictionary *dictionary in resultDictionaries) {
                Region *region= [Region gm_mappedObjectWithJsonRepresentation:dictionary];
                [regions addObject:region];
            }
            [blockSelf setRegions:regions forEmirateWithID:emirateID];
            success(regions);
        } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
            NSLog(@"Error %@",error.description);
            failure(error.description);
        }];
    }
}

- (void) setRegions:(NSArray *)regions forEmirateWithID:(NSString *)ID{
    if(!self.regionsDictionary){
        self.regionsDictionary = [NSMutableDictionary dictionary];
    }
    [self.regionsDictionary setObject:regions forKey:ID];
}

- (NSArray *) getRegionsForEmirateID:(NSString *)ID{
    NSArray *regions;
    if(self.regionsDictionary){
         regions = [self.regionsDictionary objectForKey:ID];
    }
    return regions;
}

- (void) getPassengersByRouteId:(NSString *)routeId withSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure{
    NSString *path = [NSString stringWithFormat:@"cls_mobios.asmx/GetPassengersByRouteId?id=%@",routeId];
    [self.operationManager GET:path parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseString = [self jsonStringFromResponse:responseString];
        NSError *jsonError;
        NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *resultDictionaries = [NSJSONSerialization JSONObjectWithData:objectData
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:&jsonError];
        NSMutableArray *passengers = [NSMutableArray array];
        for (NSDictionary *dictionary in resultDictionaries) {
            Passenger *passenger= [Passenger gm_mappedObjectWithJsonRepresentation:dictionary];
            [passengers addObject:passenger];
        }
        success(passengers);
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"Error %@",error.description);
        failure(error.description);
    }];
    
}

- (void) deletePassengerWithID:(NSString *)passengerID withSuccess:(void (^)(NSString *response))success Failure:(void (^)(NSString *error))failure{
    NSString *path = [NSString stringWithFormat:@"cls_mobios.asmx/Driver_RemovePassenger?RoutePassengerId=%@",passengerID];
    [self.operationManager GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseString = [self jsonStringFromResponse:responseString];
        success(responseString);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

- (void)deleteRequestWithID:(NSString *)ID WithSuccess:(void (^)(BOOL deleted))success Failure:(void (^)(NSString *error))failure {
    NSString *path = [NSString stringWithFormat:@"cls_mobios.asmx/Passenger_RemoveRequest?RoutePassengerId=%@",ID];
    [self.operationManager GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseString = [self jsonStringFromResponse:responseString];
        success([responseString containsString:@"1"]);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

- (Region *) getRegionByID:(NSString *)regionID inEmirateWithID:(NSString *)emirateID{
    NSArray *regions = [self.regionsDictionary valueForKey:emirateID];
    if (regions.count > 0) {
        Region *selectedRegion ;
        for (Region *region in regions) {
            if([region.ID isEqualToString:regionID]){
                selectedRegion = region;
                break;
            }
        }
        return selectedRegion;
    }
    else{
        return nil;
    }
}

SYNTHESIZE_SINGLETON_FOR_CLASS(MasterDataManager);
@end
