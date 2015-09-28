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
#import "Region.h"
#define id_KEY @"id"

@interface MasterDataManager ()

@end

@implementation MasterDataManager

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (void) GetAgeRangesWithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure{
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
        success(ageRanges);
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"Error %@",error.description);
        failure(error.description);
    }];
}

- (void) GetNationalitiesByID:(NSString *)ID WithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure{
    NSDictionary *parameters = @{id_KEY:ID};
    [self.operationManager GET:GetNationalities_URL parameters:parameters success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        NSLog(@"%@",responseObject);
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
        success(nationalities);
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"Error %@",error.description);
        failure(error.description);
    }];
}

- (void) GetTermsAndConditionsWithSuccess:(void (^) (TermsAndCondition *termsAndCondition))success Failure:(void (^)(NSString *error))failure{
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
        success(termsAndCondition);
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"Error %@",error.description);
        failure(error.description);
    }];
}

- (void) GetPrefferedLanguagesWithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure{
    [self.operationManager GET:GetPrefferedLanguages_URL parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        NSLog(@"%@",responseObject);
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
        success(languages);
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"Error %@",error.description);
        failure(error.description);
    }];
}

- (void) GetEmployersWithID:(NSString *)ID WithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure{
    NSDictionary *parameters = @{id_KEY:ID};
    [self.operationManager GET:GetEmployers_URL parameters:parameters success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        NSLog(@"%@",responseObject);
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
    [self.operationManager GET:GetEmirates_URL parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        NSLog(@"%@",responseObject);
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
        success(emirates);
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"Error %@",error.description);
        failure(error.description);
    }];
}

- (void) GetRegionsByID:(NSString *)ID withSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure{
    NSDictionary *parameters = @{id_KEY:ID};
    [self.operationManager GET:GetRegionById_URL parameters:parameters success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        NSLog(@"%@",responseObject);
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
        success(regions);
        
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"Error %@",error.description);
        failure(error.description);
    }];
}

- (void) GetRegionsByEmirateID:(NSString *)emirateID withSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure{
    NSDictionary *parameters = @{id_KEY:emirateID};
    [self.operationManager GET:GetRegionsByEmirateId_URL parameters:parameters success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        NSLog(@"%@",responseObject);
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
        success(regions);
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"Error %@",error.description);
        failure(error.description);
    }];
}




SYNTHESIZE_SINGLETON_FOR_CLASS(MasterDataManager);
@end