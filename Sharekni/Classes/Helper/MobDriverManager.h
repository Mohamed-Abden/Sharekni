//
//  MobDriverManager.h
//  Sharekni
//
//  Created by ITWORX on 10/8/15.
//
//

#import "BaseAPIManager.h"
#import "SynthesizeSingleton.h"
#import "Emirate.h"
#import "Region.h"
#import "Language.h"
#import "Nationality.h"
#import "AgeRange.h"
#import "Vehicle.h"


@interface MobDriverManager : BaseAPIManager



- (void) findRidesFromEmirate:(Emirate *)fromemirate andFromRegion:(Region *)fromRegion toEmirate:(Emirate *)toEmirate andToRegion:(Region *)toRegion PerfferedLanguage:(Language *)language nationality:(Nationality *)nationality ageRange:(AgeRange *)ageRange date:(NSDate *)date isPeriodic:(NSNumber *)isPeriodic saveSearch:(BOOL)saveSearch Gender:(NSString *)gender Smoke:(NSString *)smoke WithSuccess:(void (^)(NSArray *searchResults))success Failure:(void (^)(NSString *error))failure;

- (void) findRidesFromEmirateID:(NSString *)fromEmirateID andFromRegionID:(NSString *)fromRegionID toEmirateID:(NSString *)toEmirateID andToRegionID:(NSString *)toRegionID PerfferedLanguageID:(NSString *)languageID nationalityID:(NSString *)nationalityID ageRangeID:(NSString *)ageRangeID date:(NSDate *)date isPeriodic:(NSNumber *)isPeriodic saveSearch:(NSNumber *)saveSearch WithSuccess:(void (^)(NSArray *searchResults))success Failure:(void (^)(NSString *error))failure;

- (void) getMapLookupWithSuccess:(void (^)(NSArray *items))success Failure:(void (^)(NSString *error))failure;

- (void) createEditRideWithName:(NSString *)name fromEmirateID:(NSString *)fromEmirateID fromRegionID:(NSString *)fromRegionID toEmirateID:(NSString *)toEmirateID toRegionID:(NSString *)toRegionID isRounded:(BOOL)isRounded  date:(NSDate *)date saturday:(BOOL) saturday sunday:(BOOL) sunday  monday:(BOOL) monday  tuesday:(BOOL) tuesday  wednesday:(BOOL) wednesday  thursday:(BOOL) thursday friday:(BOOL) friday PreferredGender:(NSString *)gender vehicleID:(NSString *)vehicleID noOfSeats:(NSInteger)noOfSeats language:(Language *)language nationality:(Nationality *)nationality ageRange:(AgeRange *)ageRange  isEdit:(BOOL) isEdit routeID:(NSString *)routeID startLat:(NSString *)startLat startLng:(NSString *)startLng endLat:(NSString *)endLat endLng:(NSString *)endLng Smoke:(NSString *)smoke WithSuccess:(void (^)(NSString *response))success Failure:(void (^)(NSString *error))failure;

+(MobDriverManager *) sharedMobDriverManager;
@end
