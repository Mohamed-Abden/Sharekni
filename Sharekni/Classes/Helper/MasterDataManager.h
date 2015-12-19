//
//  MasterDataManager.h
//  Sharekni
//
//  Created by Mohamed Abd El-latef on 9/27/15.
//
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "BaseAPIManager.h"
#import "TermsAndCondition.h"
#import <UIKit/UIKit.h>
#import "RouteDetails.h"
#import "Region.h"
#import "Constants.h"
@interface MasterDataManager : BaseAPIManager

+(MasterDataManager *) sharedMasterDataManager;

- (void) GetAgeRangesWithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure;

- (void) GetNationalitiesByID:(NSString *)ID WithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure;

- (void) GetTermsAndConditionsWithSuccess:(void (^)(TermsAndCondition *termsAndCondition))success Failure:(void (^)(NSString *error))failure;

- (void) GetPrefferedLanguagesWithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure;

- (void) GetEmployersWithID:(NSString *)ID WithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure;

- (void) GetEmiratesWithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure;

- (void) GetRegionsByID:(NSString *)ID withSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure;

- (void) GetRegionsByEmirateID:(NSString *)emirateID withSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure;

- (void)GetBestDrivers:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure;

- (void)GetMostRides:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure;

- (void)getRideDetails:(NSString *)accountID FromEmirateID:(NSString *)fromEmirateID FromRegionID:(NSString *)fromRegionID ToEmirateID:(NSString *)toEmirateID ToRegionID:(NSString *)toRegionID WithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure ;

- (void)getDriverRideDetails:(NSString *)accountID WithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure ;

- (void) GetRouteByRouteId:(NSString *)routeID withSuccess:(void (^)(RouteDetails *routeDetails))success Failure:(void (^)(NSString *error))failure;

- (void) getReviewList:(NSString *)driverID andRoute:(NSString *)routeID withSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure ;

- (void) getSavedSearch:(NSString *)accountID withSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure ;

- (void)getVehicleById:(NSString *)accountID WithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure ;

- (void)getSavedVehicleById:(NSString *)accountID WithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure ;

- (void)getRequestNotifications:(NSString *)accountID notificationType:(NotificationType)type WithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure ;

- (void) getPassengersByRouteId:(NSString *)routeId withSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure;

- (void) deletePassengerWithID:(NSString *)passengerID withSuccess:(void (^)(NSString *response))success Failure:(void (^)(NSString *error))failure;

- (void)getPermits:(NSString *)accountID WithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure ;

- (void)deleteRequestWithID:(NSString *)requestID WithSuccess:(void (^)(BOOL deleted))success Failure:(void (^)(NSString *error))failure ;

- (Region *) getRegionByID:(NSString *)regionID inEmirateWithID:(NSString *)emirateID;

@end
