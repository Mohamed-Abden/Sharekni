//
//  MobDriverManager.m
//  Sharekni
//
//  Created by ITWORX on 10/8/15.
//
//

#import "MobDriverManager.h"
#import "Constants.h"
#import <Genome.h>
#import "DriverSearchResult.h"
#import "MapLookUp.h"
#import "Constants.h"   
#import "MobAccountManager.h"
@implementation MobDriverManager

- (void) findRidesFromEmirate:(Emirate *)fromemirate andFromRegion:(Region *)fromRegion toEmirate:(Emirate *)toEmirate andToRegion:(Region *)toRegion PerfferedLanguage:(Language *)language nationality:(Nationality *)nationality ageRange:(AgeRange *)ageRange date:(NSDate *)date isPeriodic:(NSNumber *)isPeriodic saveSearch:(BOOL)saveSearch Gender:(NSString *)gender Smoke:(NSString *)smoke WithSuccess:(void (^)(NSArray *searchResults))success Failure:(void (^)(NSString *error))failure{
    NSString *dateString;
    NSString *timeString;
    if(date){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"hh:mm";
        timeString = [dateFormatter stringFromDate:date];
        dateFormatter.dateFormat = @"dd/MM/yyyy";
        dateString = [dateFormatter stringFromDate:date];
    }
    else{
        dateString = @"";
        timeString = @"";
    }
    
    NSString *accountID = [[MobAccountManager sharedMobAccountManager] applicationUserID];
    if (accountID.length == 0) {
        accountID = @"0";
    }
    
    NSString *toEmirateID    = toEmirate ? toEmirate.EmirateId : @"0";
    NSString *toRegionID     = toRegion  ? toRegion.ID : @"0";
    NSString *languageId     = language  ? language.LanguageId : @"0";
    NSString *nationalityId  = nationality  ? nationality.ID : @"";
    NSString *saveSearchString = saveSearch ? @"1":@"0";
    NSString *isPeriodicString = @"";
    
    if (isPeriodic) {
        isPeriodicString = [isPeriodic boolValue] ? @"1":@"0";
    }
    NSString *requestBody = [NSString stringWithFormat:@"cls_mobios.asmx/Passenger_FindRide?AccountID=%@&PreferredGender=%@&Time=%@&FromEmirateID=%@&FromRegionID=%@&ToEmirateID=%@&ToRegionID=%@&PrefferedLanguageId=%@&PrefferedNationlaities=%@&AgeRangeId=%@&StartDate=%@&SaveFind=%@&IsPeriodic=%@&IsSmoking=%@",accountID,gender,timeString,fromemirate.EmirateId,fromRegion.ID,toEmirateID,toRegionID,languageId,nationalityId,ageRange ? ageRange.RangeId : @"0" ,dateString,saveSearchString,isPeriodicString,smoke];

    [self.operationManager GET:requestBody parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseString = [self jsonStringFromResponse:responseString];

         if ([responseString containsString:@"AccountEmail"]){
            NSError *jsonError;
            NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *resultDictionaries = [NSJSONSerialization JSONObjectWithData:objectData
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:&jsonError];
            NSMutableArray *searchResults = [NSMutableArray array];
            for (NSDictionary *dictionary in resultDictionaries) {
                DriverSearchResult *result= [DriverSearchResult gm_mappedObjectWithJsonRepresentation:dictionary];
                [searchResults addObject:result];
            }
            if (success) {
                success(searchResults);
            }
        }
         else if ([responseString containsString:@"0"]){
            success(nil);
            return;
         }
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"Error %@",error.description);
        failure(error.description);
    }];
    
}

- (void) findRidesFromEmirateID:(NSString *)fromEmirateID andFromRegionID:(NSString *)fromRegionID toEmirateID:(NSString *)toEmirateID andToRegionID:(NSString *)toRegionID PerfferedLanguageID:(NSString *)languageID nationalityID:(NSString *)nationalityID ageRangeID:(NSString *)ageRangeID date:(NSDate *)date isPeriodic:(NSNumber *)isPeriodic saveSearch:(NSNumber *)saveSearch WithSuccess:(void (^)(NSArray *searchResults))success Failure:(void (^)(NSString *error))failure{
    
    NSString *dateString;
    NSString *timeString;
    if(date){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"hh:mm";
        timeString = [dateFormatter stringFromDate:date];
        dateFormatter.dateFormat = @"dd/MM/yyyy";
        dateString = [dateFormatter stringFromDate:date];
    }
    else{
        dateString = @"";
        timeString = @"";
    }

    
    NSString *saveSearchString = saveSearch.boolValue ? @"1":@"0";
    NSString *isPeriodicString = isPeriodic ? isPeriodic.boolValue ? @"1":@"0" : @"";
    
    NSString *accountID = [[MobAccountManager sharedMobAccountManager] applicationUserID];
    if (accountID.length == 0) {
        accountID = @"0";
    }
    
    NSString *requestBody = [NSString stringWithFormat:@"cls_mobios.asmx/Passenger_FindRide?AccountID=%@&PreferredGender=%@&Time=%@&FromEmirateID=%@&FromRegionID=%@&ToEmirateID=%@&ToRegionID=%@&PrefferedLanguageId=%@&PrefferedNationlaities=%@&AgeRangeId=%@&StartDate=%@&SaveFind=%@&IsPeriodic=%@&IsSmoking=%@",accountID,@"N",timeString,fromEmirateID,fromRegionID,toEmirateID,toRegionID,languageID,nationalityID,ageRangeID ,dateString,saveSearchString,isPeriodicString,@"0"];
    
    [self.operationManager GET:requestBody parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseString = [self jsonStringFromResponse:responseString];
        
        if ([responseString containsString:@"AccountEmail"]){
            NSError *jsonError;
            NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *resultDictionaries = [NSJSONSerialization JSONObjectWithData:objectData
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:&jsonError];
            NSMutableArray *searchResults = [NSMutableArray array];
            for (NSDictionary *dictionary in resultDictionaries) {
                DriverSearchResult *result= [DriverSearchResult gm_mappedObjectWithJsonRepresentation:dictionary];
                [searchResults addObject:result];
            }
            if (success) {
                success(searchResults);
            }
        }
        else if ([responseString containsString:@"0"]){
            success(nil);
            return;
        }
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"Error %@",error.description);
        failure(error.description);
    }];
}


- (void) getMapLookupWithSuccess:(void (^)(NSArray *items))success Failure:(void (^)(NSString *error))failure{
    [self.operationManager GET:@"cls_mobios.asmx/GetFromOnlyMostDesiredRides?" parameters:nil success:^(AFHTTPRequestOperation *  operation, id responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseString = [self jsonStringFromResponse:responseString];
        NSError *jsonError;
        NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *resultDictionaries = [NSJSONSerialization JSONObjectWithData:objectData
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:&jsonError];
        NSMutableArray *mapLookUps = [NSMutableArray array];
        for (NSDictionary *dictionary in resultDictionaries) {
            MapLookUp *item= [MapLookUp gm_mappedObjectWithJsonRepresentation:dictionary];
            [mapLookUps addObject:item];
        }
        success(mapLookUps);
    } failure:^(AFHTTPRequestOperation *  operation, NSError * error) {
        
    }];
}

//GET /_mobfiles/cls_mobios.asmx/Driver_CreateCarpool?AccountID=string&EnName=string&FromEmirateID=string&ToEmirateID=string&FromRegionID=string&ToRegionID=string&IsRounded=string&Time=string&Saturday=string&Sunday=string&Monday=string&Tuesday=string&Wednesday=string&Thursday=string&Friday=string&PreferredGender=string&VehicleID=string&NoOfSeats=string&StartLat=string&StartLng=string&EndLat=string&EndLng=string&PrefferedLanguageId=string&PrefferedNationlaities=string&AgeRangeId=string&StartDate=string HTTP/1.1

- (void) createEditRideWithName:(NSString *)name fromEmirateID:(NSString *)fromEmirateID fromRegionID:(NSString *)fromRegionID toEmirateID:(NSString *)toEmirateID toRegionID:(NSString *)toRegionID isRounded:(BOOL)isRounded  date:(NSDate *)date saturday:(BOOL) saturday sunday:(BOOL) sunday  monday:(BOOL) monday  tuesday:(BOOL) tuesday  wednesday:(BOOL) wednesday  thursday:(BOOL) thursday friday:(BOOL) friday PreferredGender:(NSString *)gender vehicleID:(NSString *)vehicleID noOfSeats:(NSInteger)noOfSeats language:(Language *)language nationality:(Nationality *)nationality ageRange:(AgeRange *)ageRange  isEdit:(BOOL) isEdit routeID:(NSString *)routeID startLat:(NSString *)startLat startLng:(NSString *)startLng endLat:(NSString *)endLat endLng:(NSString *)endLng Smoke:(NSString *)smoke WithSuccess:(void (^)(NSString *response))success Failure:(void (^)(NSString *error))failure{
    
    NSString *dateString;
    NSString *timeString;
    if(date){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"hh:mm";
        timeString = [dateFormatter stringFromDate:date];
        dateFormatter.dateFormat = @"dd/MM/yyyy";
        dateString = [dateFormatter stringFromDate:date];
    }
    else{
        dateString = @"";
        timeString = @"";
    }
    
    
    NSString *accountID = [[MobAccountManager sharedMobAccountManager] applicationUserID];
    if (accountID.length == 0) {
        accountID = @"0";
    }
    
    NSString *_isRounded = isRounded ? @"1":@"0";
    NSString *_noOfSeats = [NSString  stringWithFormat:@"%li",(long)noOfSeats];
    
    NSString *languageId     = language  ? language.LanguageId : @"0";
    NSString *nationalityId  = nationality  ? nationality.ID : @"";
    NSString *ageRangeId  =   ageRange  ? ageRange.RangeId.stringValue: @"0";
    
    NSString *sat = saturday  ? @"1":@"0";
    NSString *sun = sunday    ? @"1":@"0";
    NSString *mon = monday    ? @"1":@"0";
    NSString *tue = tuesday   ? @"1":@"0";
    NSString *wed = wednesday ? @"1":@"0";
    NSString *thu = thursday  ? @"1":@"0";
    NSString *fri = friday    ? @"1":@"0";
    NSString *path;
    if (isEdit) {
        path = [NSString stringWithFormat:@"cls_mobios.asmx/Driver_EditCarpool?RouteID=%@",routeID];
    }
    else{
        path =[NSString stringWithFormat:@"cls_mobios.asmx/Driver_CreateCarpool?AccountID=%@",accountID];
    }
    NSString *requestBody = [NSString stringWithFormat:@"%@&EnName=%@&FromEmirateID=%@&ToEmirateID=%@&FromRegionID=%@&ToRegionID=%@&IsRounded=%@&Time=%@&Saturday=%@&Sunday=%@&Monday=%@&Tuesday=%@&Wednesday=%@&Thursday=%@&Friday=%@&PreferredGender=%@&VehicleID=%@&NoOfSeats=%@&StartLat=%@&StartLng=%@&EndLat=%@&EndLng=%@&PrefferedLanguageId=%@&PrefferedNationlaities=%@&AgeRangeId=%@&StartDate=%@&IsSmoking=%@",path,name,fromEmirateID,toEmirateID,fromRegionID,toRegionID,_isRounded,timeString,sat,sun,mon,tue,wed,thu,fri,gender,vehicleID,_noOfSeats,startLat,startLng,endLat,endLng,languageId,nationalityId,ageRangeId,dateString,smoke];
    
    requestBody = [requestBody stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self.operationManager GET:requestBody parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response create ride %@",responseObject);
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseString = [self jsonStringFromResponse:responseString];
        success(responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

SYNTHESIZE_SINGLETON_FOR_CLASS(MobDriverManager);
@end

//CLS_MobDriver.asmx/Passenger_FindRide?AccountID=0&PreferredGender=N&Time=&FromEmirateID=1&FromRegionID=184&ToEmirateID=1&ToRegionID=193&PrefferedLanguageId=&PrefferedNationlaities=&AgeRangeId=&StartDate=&SaveFind=&IsPeriodic=

//CLS_MobDriver.asmx/Passenger_FindRide?AccountID=0&PreferredGender=N&Time=&FromEmirateID=1&FromRegionID=184&ToEmirateID=1&ToRegionID=193&PrefferedLanguageId=&PrefferedNationlaities=0&AgeRangeId=0&StartDate=&SaveFind=&IsPeriodic=



