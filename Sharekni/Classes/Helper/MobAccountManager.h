//
//  AuthenticationManager.h
//  Sharekni
//
//  Created by Mohamed Abd El-latef on 9/26/15.
//
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "BaseAPIManager.h"
#import "User.h"
#import "Passenger.h"

@interface MobAccountManager : BaseAPIManager

@property (nonatomic,strong) User* applicationUser;

- (NSString *) applicationUserID;

- (void) checkLoginWithUserName:(NSString *)userName andPassword:(NSString *)password WithSuccess:(void (^)(User *user))success Failure:(void (^)(NSString *error))failure;

- (void) registerPassengerWithFirstName:(NSString *)firstName lastName:(NSString *)lastName mobile:(NSString *)mobile username:(NSString *)username password:(NSString *)password gender:(NSString *)gender imagePath:(NSString *)photoName birthDate:(NSString *)birthDate nationalityID:(NSString *)nationalityId PreferredLanguageId:(NSString *)langID WithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure;

- (void) registerDriverWithFirstName:(NSString *)firstName lastName:(NSString *)lastName mobile:(NSString *)mobile username:(NSString *)username password:(NSString *)password gender:(NSString *)gender imagePath:(NSString *)photoName birthDate:(NSString *)birthDate nationalityID:(NSString *)nationalityId PreferredLanguageId:(NSString *)langID WithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure;

- (void) getJoinedRidesWithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure;

- (void) getCreatedRidesWithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure;

- (void) deleteRideWithID:(NSString *)rideID withSuccess:(void (^)(BOOL deletedSuccessfully))success Failure:(void (^)(NSString *error))failure;

- (void) forgetPassword:(NSString *)number andEmail:(NSString *)email WithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure ;

+(MobAccountManager *)sharedMobAccountManager;

- (void) reviewDriver:(NSString *)driverId PassengerId:(NSString *)passengerId RouteId:(NSString *)routeId ReviewText:(NSString *)reviewText WithSuccess:(void (^)(NSString *user))success Failure:(void (^)(NSString *error))failure ;

- (void) registerVehicle:(NSString *)AccountId TrafficFileNo:(NSString *)TrafficFileNo BirthDate:(NSString *)BirthDate WithSuccess:(void (^)(NSString *user))success Failure:(void (^)(NSString *error))failure ;

- (void) joinRidePassenger:(NSString *)PassengerID RouteID:(NSString *)RouteID DriverID:(NSString *)DriverID Remark:(NSString *)remark WithSuccess:(void (^)(NSString *user))success Failure:(void (^)(NSString *error))failure ;

- (void) acceptRequest:(NSString *)RequestId andIsAccepted:(NSString *)IsAccept WithSuccess:(void (^)(NSString *response))success Failure:(void (^)(NSString *error))failure;

- (void) leaveRideWithID:(NSString *) routeID withSuccess:(void (^)(BOOL deletedSuccessfully))success Failure:(void (^)(NSString *error))failure;


- (void) getUser:(NSString *)userID WithSuccess:(void (^)(User *user))success Failure:(void (^)(NSString *error))failure;

- (void) addPermitForRouteID:(NSString *)routeID vehicleId:(NSString *)vehicleId passengerIDs:(NSArray *)passengers withSuccess:(void (^)(NSString *addedSuccessfully))success Failure:(void (^)(NSString *error))failure;

- (void) addPassengerRatingWithPassengerID:(NSString *)PassengerID inRouteID:(NSString *)routeID noOfStars:(NSInteger)noOfStars WithSuccess:(void (^)(NSString *response))success Failure:(void (^)(NSString *error))failure;

- (void) addDriverRatingWithDriverID:(NSString *)driverID inRouteID:(NSString *)routeID noOfStars:(NSInteger)noOfStars WithSuccess:(void (^)(NSString *response))success Failure:(void (^)(NSString *error))failure;

- (void) getCalculatedRatingForAccount:(NSString *)accountID WithSuccess:(void (^)(NSString *rating))success Failure:(void (^)(NSString *error))failure;

- (void) verifyMobileNumber:(NSString *)accountId WithSuccess:(void (^)(NSString *user))success Failure:(void (^)(NSString *error))failure ;

- (void) confirmMobileNumber:(NSString *)accountId andCode:(NSString *)code WithSuccess:(void (^)(NSString *user))success Failure:(void (^)(NSString *error))failure ;

- (void) updateUserProfileWithAccountID:(NSString *)accountID firstName:(NSString *)firstName lastName:(NSString *)lastName gender:(NSString *)gender imagePath:(NSString *)photoName birthDate:(NSString *)birthDate nationalityID:(NSString *)nationalityId PreferredLanguageId:(NSString *)langID Mobile:(NSString *)mobile WithSuccess:(void (^)(NSString *user))success Failure:(void (^)(NSString *error))failure ;

@end
