
//  AuthenticationManager.m
//  Sharekni
//
//  Created by Mohamed Abd El-latef on 9/26/15.
//
//

#import "MobAccountManager.h"
#import "Nationality.h"
#import <Genome.h>
#import "Ride.h"
#import "Sharekni.pch"
#import "CreatedRide.h"
#import "HelpManager.h"

#define ID_KEY @"id"

#define FirstName_KEY @"firstName"
#define LastName_KEY  @"lastName"
#define Mobile_KEY    @"mobile"
#define UserName_KEY  @"username"
#define Password_KEY  @"password"
#define photoName_KEY @"photoName"
#define BirthDate_KEY @"BirthDate"
#define NationalityId_KEY @"NationalityId"
#define PreferredLanguageId_KEY @"PreferredLanguageId"

#define OldPassword_KEY @"oldPassword"
#define NewPassword_KEY @"newPassword"

#define AccountID_KEY @"AccountID"
#define Code_KEY @"Code"

#define DriverId_KEY @"DriverId"
#define PassengerId_KEY @"PassengerId"
#define RouteId_KEY @"RouteId"

#define NewPhotoName_KEY @"NewPhotoName"

#define Email_KEY @"email"


@implementation MobAccountManager

- (NSString *) applicationUserID{
    return self.applicationUser.ID.stringValue;
}

- (void) registerPassengerWithFirstName:(NSString *)firstName lastName:(NSString *)lastName mobile:(NSString *)mobile username:(NSString *)username password:(NSString *)password gender:(NSString *)gender imagePath:(NSString *)photoName birthDate:(NSString *)birthDate nationalityID:(NSString *)nationalityId PreferredLanguageId:(NSString *)langID WithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure{

    NSString *body = [NSString stringWithFormat:@"cls_mobios.asmx/RegisterPassenger?firstName=%@&lastName=%@&mobile=%@&username=%@&password=%@&gender=%@&photoName=%@&BirthDate=%@&NationalityId=%@&PreferredLanguageId=%@",firstName,lastName,mobile,username,password,gender,photoName,birthDate,nationalityId,langID];
    
    [self.operationManager GET:body parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseString = [self jsonStringFromResponse:responseString];

        if([responseString containsString:@"-2"]){
            failure(@"Failed");
        }
        else if ([responseString containsString:@"-1"]){
            failure(@"Failed");
        }
        else{
            success(nil);
        }
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        failure(@"cannot register");
    }];
    ///cls_mobios.asmx/RegisterPassenger?firstName=ahmedta&lastName=ahmed&mobile=551100552&username=ahmes.fa@gmail.com&password=12345&gender=M&photoName=cdce99b9-a7bc-43d9-88ec-2d06ce0f0ec82015-14153204851-978.png&BirthDate=08/12/1991&NationalityId=139&PreferredLanguageId=1
}

- (void) registerDriverWithFirstName:(NSString *)firstName lastName:(NSString *)lastName mobile:(NSString *)mobile username:(NSString *)username password:(NSString *)password gender:(NSString *)gender imagePath:(NSString *)photoName birthDate:(NSString *)birthDate nationalityID:(NSString *)nationalityId PreferredLanguageId:(NSString *)langID WithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure{
    
 
    NSString *body = [NSString stringWithFormat:@"cls_mobios.asmx/RegisterDriver?firstName=%@&lastName=%@&mobile=%@&username=%@&password=%@&gender=%@&photoName=%@&licenseScannedFileName=%@&TrafficFileNo=%@&BirthDate=%@&NationalityId=%@&PreferredLanguageId=%@",firstName,lastName,mobile,username,password,gender,photoName,@"",@"",birthDate,nationalityId,langID];
    
    [self.operationManager GET:body parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseString = [self jsonStringFromResponse:responseString];
        if ([responseString containsString:@"-2"])
        {
            failure(GET_STRING(@"Mobile number already exists"));
        }
        else if ([responseString containsString:@"-1"])
        {
            failure(NSLocalizedString(GET_STRING(@"Email already exists"),nil));
        }
        else{
            success(nil);
        }
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        failure(GET_STRING(@"Sorry ,cannot register now."));
    }];
}

- (void) changeOldPassword:(NSString *)oldPassword toNewPassword:(NSString *) newPassword WithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure{
//    NSDictionary *parameters = @{ID_KEY:@"",
//                                 OldPassword_KEY:oldPassword,
//                                 NewPassword_KEY:newPassword};

NSString *path = [NSString stringWithFormat:@"cls_mobios.asmx/ChangePassword?id=%@&oldPassword=%@&newPassword=%@",self.applicationUserID,oldPassword,newPassword];
    [self.operationManager GET:path parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        
    }];
}

- (void) checkLoginWithUserName:(NSString *)userName andPassword:(NSString *)password WithSuccess:(void (^)(User *user))success Failure:(void (^)(NSString *error))failure{
   
    NSString *path = [NSString stringWithFormat:@"cls_mobios.asmx/CheckLogin?username=%@&password=%@",userName,password];
    __block MobAccountManager *blockSelf = self;
    [self.operationManager GET:path parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseString = [self jsonStringFromResponse:responseString];
        if ([responseString containsString:@"ID"]) {
            NSError *jsonError;
            NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:objectData
                                                                             options:NSJSONReadingMutableContainers
                                                                               error:&jsonError];
            User *user = [User gm_mappedObjectWithJsonRepresentation:resultDictionary];
            blockSelf.applicationUser = user;
            [[HelpManager sharedHelpManager] saveUserNameInUserDefaults:userName];
            [[HelpManager sharedHelpManager] saveUserPasswordInUserDefaults:password];
            [self getUser:user.ID.stringValue WithSuccess:^(User *user) {
                blockSelf.applicationUser = user;
                success(blockSelf.applicationUser);
             
            } Failure:^(NSString *error) {

            }];
        }
        else if ([responseString containsString:@"-"])
        {
            failure(GET_STRING(@"Please check your username and password"));
        }
        else{
            failure(GET_STRING(@"Please check your username and password"));
        }
        
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error)
    {
            failure(GET_STRING(@"Please check your username and password"));
    }];
}

- (void) forgetPassword:(NSString *)number andEmail:(NSString *)email WithSuccess:(void (^)(NSString *user))success Failure:(void (^)(NSString *error))failure{
    NSString *path = [NSString stringWithFormat:@"cls_mobios.asmx/ForgetPassword?mobile=%@&email=%@",number,email];
    
    [self.operationManager GET:path parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
       
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        responseString = [self jsonStringFromResponse:responseString];

        if (responseString)
        {
            NSString *str = GET_STRING(@"A reset password link has been sent to your email");
            success(str);
        }else{
            failure(GET_STRING(@"data are not matching"));
        }
        
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        failure(GET_STRING(@"data are not matching"));
    }];
}

- (void) confirmMobileWithCode:(NSString *)code WithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure{

    NSString *path = [NSString stringWithFormat:@"cls_mobios.asmx/Confirm_Mobile?AccountID=%@&Code=%@",self.applicationUserID,code];
    [self.operationManager GET:path parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        
    }];
}

- (void) GetPassengerReviewListWithPassengerId:(NSString *)passengerId andRouteId:(NSString *)routeId WithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure{

    NSString *path = [NSString stringWithFormat:@"cls_mobios.asmx/Passenger_GetReviewList?PassengerId=%@&RouteId=%@",passengerId,routeId];
    [self.operationManager GET:path parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        
    }];
}

- (void) editProfileWithFirstName:(NSString *)firstName lastName:(NSString *)lastName gender:(NSString *)gender birthDate:(NSString *)birthDate nationalityID:(NSString *)nationalityId PreferredLanguageId:(NSString *)langID imagePath:(NSString *)photoName WithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure{
    
    NSString *path;
    //= [NSString stringWithFormat:@"cls_mobios.asmx/Passenger_GetReviewList?PassengerId=%@&RouteId=%@",passengerId,routeId];
    [self.operationManager GET:path parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        
    }];

}

- (void) forgotPasswordWithMobile:(NSString *)mobile email:(NSString *)email WithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure{

    NSString *path = [NSString stringWithFormat:@"cls_mobios.asmx/ForgetPassword?mobile=%@&email=%@",mobile,email];
    [self.operationManager GET:path parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        
    }];

}

- (void) GetCalculatedRatingsForAccountID:(NSString *)accountID WithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure{
    NSString *path = [NSString stringWithFormat:@"cls_mobios.asmx/GetCalculatedRating?AccountId=%@",accountID];
    [self.operationManager GET:path parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        
    }];
}

- (void) getJoinedRidesWithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure{

    NSString *path = [NSString stringWithFormat:@"cls_mobios.asmx/Passenger_MyApprovedRides?AccountId=%@",self.applicationUser.ID.stringValue];
    
    [self.operationManager GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseString = [self jsonStringFromResponse:responseString];
        NSError *jsonError;
        NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *resultDictionaries = [NSJSONSerialization JSONObjectWithData:objectData
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:&jsonError];
        NSMutableArray *rides = [NSMutableArray array];
        for (NSDictionary *dictionary in resultDictionaries) {
            Ride *ride= [Ride gm_mappedObjectWithJsonRepresentation:dictionary];
            [rides addObject:ride];
        }
        success(rides);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

- (void) getCreatedRidesWithSuccess:(void (^)(NSMutableArray *array))success Failure:(void (^)(NSString *error))failure{
    NSString *path = [NSString stringWithFormat:@"cls_mobios.asmx/Driver_MyRides?AccountId=%@",self.applicationUser.ID.stringValue];
    
    [self.operationManager GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseString = [self jsonStringFromResponse:responseString];
        NSError *jsonError;
        NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *resultDictionaries = [NSJSONSerialization JSONObjectWithData:objectData
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:&jsonError];
        NSMutableArray *rides = [NSMutableArray array];
        for (NSDictionary *dictionary in resultDictionaries) {
            CreatedRide *ride= [CreatedRide gm_mappedObjectWithJsonRepresentation:dictionary];
            [rides addObject:ride];
        }
        success(rides);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

- (void) reviewDriver:(NSString *)driverId PassengerId:(NSString *)passengerId RouteId:(NSString *)routeId ReviewText:(NSString *)reviewText WithSuccess:(void (^)(NSString *user))success Failure:(void (^)(NSString *error))failure
{
    NSString *path = [NSString stringWithFormat:@"cls_mobios.asmx/Passenger_ReviewDriver?PassengerId=%@&DriverId=%@&RouteId=%@&ReviewText=%@",passengerId,driverId,routeId,reviewText];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self.operationManager GET:path parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject)
    {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseString = [self jsonStringFromResponse:responseString];
        
        if (![responseString containsString:@"1"]){
            failure(@"Error");
        }
        success(responseString);
        
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        failure(@"incorrect");
    }];
}

- (void) EditreviewWithID:(NSString *)reviewID ReviewText:(NSString *)reviewText WithSuccess:(void (^)(BOOL deleted))success Failure:(void (^)(NSString *error))failure{
    
    NSString *path = [NSString stringWithFormat:@"cls_mobios.asmx/EditReview?ReviewId=%@&ReviewText=%@",reviewID,reviewText];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.operationManager GET:path parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject)
     {
         NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         responseString = [self jsonStringFromResponse:responseString];
         
         if ([responseString containsString:@"1"]) {
             success(YES);
         }
         else{
             success(NO);
         }
         
     } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
         failure(@"incorrect");
     }];
}

- (void) joinRidePassenger:(NSString *)PassengerID RouteID:(NSString *)RouteID DriverID:(NSString *)DriverID Remark:(NSString *)remark WithSuccess:(void (^)(NSString *user))success Failure:(void (^)(NSString *error))failure
{
//    NSString *path = [NSString stringWithFormat:@"cls_mobios.asmx/Passenger_SendAlert?DriverId=%@&PassengerId=%@&RouteId=%@&s_Remarks=%@",DriverID,PassengerID,RouteID,remark];
    NSString *path = [NSString stringWithFormat:@"cls_mobios.asmx/Passenger_SendAlert?RouteID=%@&PassengerID=%@&DriverID=%@&s_Remarks=%@",RouteID,PassengerID,DriverID,remark];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self.operationManager GET:path parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject)
     {
         NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         responseString = [self jsonStringFromResponse:responseString];
         
         if (![responseString containsString:@"1"]){
             failure(@"Error");
         }
         success(responseString);
         
     } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
         failure(@"incorrect");
     }];

}

- (void) registerVehicle:(NSString *)AccountId TrafficFileNo:(NSString *)TrafficFileNo BirthDate:(NSString *)BirthDate WithSuccess:(void (^)(NSString *user))success Failure:(void (^)(NSString *error))failure
{
    NSString *path = [NSString stringWithFormat:@"/_mobfiles/cls_mobios.asmx/Driver_RegisterVehicleWithETService?AccountId=%@&TrafficFileNo=%@&BirthDate=%@",AccountId,TrafficFileNo,BirthDate];
    
    [self.operationManager GET:path parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject)
     {
         NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         responseString = [self jsonStringFromResponse:responseString];
         
         if ([responseString containsString:@"1"])
         {
             [[NSUserDefaults standardUserDefaults] setValue:TrafficFileNo forKey:@"TrafficFileNo"];
             [[NSUserDefaults standardUserDefaults] setValue:AccountId forKey:@"AccountId"];
             [[NSUserDefaults standardUserDefaults] setValue:BirthDate forKey:@"BirthDate"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             success(responseString);
         }
         else if ([responseString containsString:@"-2"])
         {
             failure(@"You can't use this file number");
         }
         else if ([responseString containsString:@"-3"])
         {
             failure(@"Date birth invalid");
         }
         else if ([responseString containsString:@"-4"])
         {
             failure(@"License verified, but no cars found");
         }
         else if ([responseString containsString:@"-5"])
         {
             failure(@"Invalid data please check again");
         }
         else if ([responseString containsString:@"-6"])
         {
             failure(@"Invalid data please check again");
             success(responseString);
         }
     } failure:^void(AFHTTPRequestOperation * operation, NSError * error){
         failure(@"incorrect");
     }];
}

- (void) acceptRequest:(NSString *)RequestId andIsAccepted:(NSString *)IsAccept WithSuccess:(void (^)(NSString *response))success Failure:(void (^)(NSString *error))failure
{
    NSString *path = [NSString stringWithFormat:@"cls_mobios.asmx/Driver_AcceptRequest?RequestId=%@&IsAccept=%@",RequestId,IsAccept];
    [self.operationManager GET:path parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject)
    {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseString = [self jsonStringFromResponse:responseString];
        
        if([responseString containsString:@"-2"]){
            failure(@"Failed");
        }
        else if ([responseString containsString:@"-1"]){
            failure(@"Failed");
        }
        else{
            success(nil);
        }

        
        } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
            failure(error);
    }];
}

- (void) getUser:(NSString *)userID WithSuccess:(void (^)(User *user))success Failure:(void (^)(NSString *error))failure
{
    NSString *path = [NSString stringWithFormat:@"cls_mobios.asmx/Get?id=%@",userID];
    [self.operationManager GET:path parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseString = [self jsonStringFromResponse:responseString];
        NSError *jsonError;
        NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *resultDictionaries = [NSJSONSerialization JSONObjectWithData:objectData
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:&jsonError];
        NSMutableArray *users = [NSMutableArray array];
        for (NSDictionary *dictionary in resultDictionaries) {
            User *user= [User gm_mappedObjectWithJsonRepresentation:dictionary];
            [users addObject:user];
        }
        if (users.count >0) {
            success(users[0]);
        }

    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"Error %@",error.description);
        failure(error.description);
    }];

}

- (void) deleteRideWithID:(NSString *)rideID withSuccess:(void (^)(BOOL deletedSuccessfully))success Failure:(void (^)(NSString *error))failure{
    NSString *path =[NSString stringWithFormat:@"cls_mobios.asmx/Route_Delete?RouteId=%@",rideID];
    [self.operationManager GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseString = [self jsonStringFromResponse:responseString];
        NSLog(@"delete response :%@",responseString);
        if ([responseString containsString:@"1"]) {
            success(YES);
        }
        else{
            success(NO);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}


- (void) leaveRideWithID:(NSString *) routeID withSuccess:(void (^)(BOOL deletedSuccessfully))success Failure:(void (^)(NSString *error))failure{
    NSString *path =[NSString stringWithFormat:@"cls_mobios.asmx/Passenger_RemovePassenger?RoutePassengerId=%@",routeID];
    [self.operationManager GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseString = [self jsonStringFromResponse:responseString];
        NSLog(@"delete response :%@",responseString);
        if ([responseString containsString:@"1"])
        {
            success(YES);
        }
        else{
            success(NO);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

- (void) addPermitForRouteID:(NSString *)routeID vehicleId:(NSString *)vehicleId passengerIDs:(NSArray *)passengers withSuccess:(void (^)(NSString *addedSuccessfully))success Failure:(void (^)(NSString *error))failure{
    NSString *passengersString = [NSString stringWithFormat:@"%@",passengers[0]];
    for (int i=1; i<passengers.count; i++) {
        NSString *passenger = passengers[i];
        passengersString = [passengersString stringByAppendingString:[NSString stringWithFormat:@",%@",passenger]];
    }
    NSString *path =[NSString stringWithFormat:@"cls_mobios.asmx/Permit_Insert?AccountId=%@&RouteId=%@&VehicleId=%@&_passengerIDs=%@",self.applicationUserID,routeID,vehicleId,passengersString];
    [self.operationManager GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseString = [self jsonStringFromResponse:responseString];
            success(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

- (void) addPassengerRatingWithPassengerID:(NSString *)PassengerID inRouteID:(NSString *)routeID noOfStars:(NSInteger)noOfStars WithSuccess:(void (^)(NSString *response))success Failure:(void (^)(NSString *error))failure{
    NSString *driverID = self.applicationUserID;
    NSString *path = [NSString stringWithFormat:@"cls_mobios.asmx/Driver_RatePassenger?DriverId=%@&PassengerId=%@&RouteId=%@&NoOfStars=%ld",driverID,PassengerID,routeID,(long)noOfStars];
    [self.operationManager GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseString = [self jsonStringFromResponse:responseString];
        success(responseString);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

- (void) addDriverRatingWithDriverID:(NSString *)driverID inRouteID:(NSString *)routeID noOfStars:(NSInteger)noOfStars WithSuccess:(void (^)(NSString *response))success Failure:(void (^)(NSString *error))failure{
    NSString *passengerID = self.applicationUserID;
    NSString *path = [NSString stringWithFormat:@"cls_mobios.asmx/Passenger_RateDriver?PassengerId=%@&DriverId=%@&RouteId=%@&NoOfStars=%ld",passengerID,driverID,routeID,(long)noOfStars];
    [self.operationManager GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseString = [self jsonStringFromResponse:responseString];
        success(responseString);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

- (void) getDriverRate:(NSString *)driverID inRouteID:(NSString *)routeID WithSuccess:(void (^)(NSString *response))success Failure:(void (^)(NSString *error))failure
{
    NSString *passengerID = self.applicationUserID;
    
    NSString *path = [NSString stringWithFormat:@"cls_mobios.asmx/Passenger_GetDriverRate?PassengerId=%@&DriverId=%@&RouteId=%@",passengerID,driverID,routeID];
    
    [self.operationManager GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseString = [self jsonStringFromResponse:responseString];
        success(responseString);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];

}

- (void) getCalculatedRatingForAccount:(NSString *)accountID WithSuccess:(void (^)(NSString *rating))success Failure:(void (^)(NSString *error))failure{
    NSString *path = [NSString stringWithFormat:@"cls_mobios.asmx/GetCalculatedRating?AccountId=%@",accountID];
    [self.operationManager GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseString = [self jsonStringFromResponse:responseString];
        NSString *rating = [NSString stringWithFormat:@"%li",(long)responseString.integerValue];
        success(rating);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

- (void) verifyMobileNumber:(NSString *)accountId WithSuccess:(void (^)(NSString *user))success Failure:(void (^)(NSString *error))failure
{
    NSString *path =[NSString stringWithFormat:@"cls_mobios.asmx/SendMobileVerification?AccountID=%@",accountId];
    
    [self.operationManager GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseString = [self jsonStringFromResponse:responseString];
        NSLog(@"delete response :%@",responseString);
        if ([responseString containsString:@"1"]) {
            
            success(responseString);
        }
        else{
            success(responseString);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

- (void) confirmMobileNumber:(NSString *)accountId andCode:(NSString *)code WithSuccess:(void (^)(NSString *user))success Failure:(void (^)(NSString *error))failure
{
    NSString *path =[NSString stringWithFormat:@"CLS_Mobios.asmx/Confirm_Mobile?AccountID=%@&Code=%@",accountId,code];
    
    [self.operationManager GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseString = [self jsonStringFromResponse:responseString];
        NSLog(@"delete response :%@",responseString);
        if ([responseString containsString:@"1"])
        {
            success(responseString);
        }
        else{
            success(responseString);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

- (void) updateUserProfileWithAccountID:(NSString *)accountID firstName:(NSString *)firstName lastName:(NSString *)lastName gender:(NSString *)gender imagePath:(NSString *)photoName birthDate:(NSString *)birthDate nationalityID:(NSString *)nationalityId PreferredLanguageId:(NSString *)langID Mobile:(NSString *)mobile WithSuccess:(void (^)(NSString *user))success Failure:(void (^)(NSString *error))failure
{
    NSString *body = [NSString stringWithFormat:@"CLS_Mobios.asmx/EditProfile?id=%@&firstName=%@&lastName=%@&gender=%@&NewPhotoName=%@&BirthDate=%@&NationalityId=%@&PreferredLanguageId=%@&Mobile=%@",accountID,firstName,lastName,gender,photoName,birthDate,nationalityId,langID,mobile];
    
    [self.operationManager GET:body parameters:nil success:^void(AFHTTPRequestOperation * operation, id responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseString = [self jsonStringFromResponse:responseString];
        
        if([responseString containsString:@"1"])
        {
            success(responseString);
        }
        else if ([responseString containsString:@"0"])
        {
            failure(@"Failed");
        }
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        failure(@"cannot register");
    }];
}

SYNTHESIZE_SINGLETON_FOR_CLASS(MobAccountManager);
@end
