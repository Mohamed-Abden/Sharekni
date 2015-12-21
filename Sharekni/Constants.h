//
//  Constants.h
//  Sharekni
//
//  Created by Mohamed Abd El-latef on 9/26/15.
//
//

#ifndef Sharekni_Constants_h
#define Sharekni_Constants_h



#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


#define appDelegate (AppDelegate*)[[UIApplication sharedApplication] delegate]


#define RGBA(r, g, b, a) [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:a]

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


#define String_Open_Tag @"<string xmlns=\"http://tempuri.org/\">"
#define String_Close_Tag @"</string>"
#define XML_Open_Tag @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
#define XML_Tag2 @"<string xmlns=\"http://MobAccount.org/\">"
#define XML_Tag1 @"<string xmlns=\"http://Sharekni-MobIOS-Data.org/\">"
#define XML_Tag3 @"<string xmlns=\"http://Sharekni-MobIOS-Data.org/\">"

//#define Sharkeni_BASEURL @"http://sharekni.sdgstaff.com/_mobfiles/"
//#define Sharkeni_BASEURL @"http://sharekni-web.sdg.ae/_mobfiles/"
//#define Sharkeni_BASEURL @"https://www.sharekni.ae/_mobfiles/"
//12:23
#define Sharkeni_BASEURL @"http://213.42.51.219/_mobfiles/"

#define GetAgeRanges_URL @"cls_mobios.asmx/GetAgeRanges"
#define GetEmirates_URL @"cls_mobios.asmx/GetEmirates"
#define GetBestDrivers_URL @"cls_mobios.asmx/GetBestDrivers"
#define GetMostRides_URL @"cls_mobios.asmx/GetMostDesiredRides"
#define GetMostRideDetails_URL @"cls_mobios.asmx/GetMostDesiredRideDetails"
#define GetDriverRideDetails_URL @"cls_mobios.asmx/GetDriverDetailsByAccountId"
#define GetRouteByRouteId_URL @"cls_mobios.asmx/GetRouteByRouteId"
#define GetReviewList_URL @"cls_mobios.asmx/Driver_GetReviewList"
#define Passenger_ReviewDriver @"cls_mobios.asmx/Passenger_ReviewDriver"
#define Passenger_SendAlert @"cls_mobios.asmx/Passenger_SendAlert"
#define Driver_AcceptRequest @"cls_mobios.asmx/Driver_AcceptRequest"



#define Passenger_GetSavedSearch @"cls_mobios.asmx/Passenger_GetSavedSearch"
#define RegisterVehicleWithETService @"cls_mobios.asmx/Driver_RegisterVehicleWithETService"
#define GetVehicleById @"cls_mobios.asmx/GetVehicleById"




#define GetEmployers_URL @"cls_mobios.asmx/GetEmployers"
#define GetRegionById_URL @"cls_mobios.asmx/GetRegionById"
#define GetNationalities_URL @"cls_mobios.asmx/GetNationalities"
#define GetRegionsByEmirateId_URL @"cls_mobios.asmx/GetRegionsByEmirateId"
#define GetTermsAndConditions_URL @"cls_mobios.asmx/GetTermsAndConditions"
#define GetPrefferedLanguages_URL @"cls_mobios.asmx/GetPrefferedLanguages"
#define GetPhoto_URL @"cls_mobios.asmx/GetPhotoPath"
#define RegisterPassenger_URL @"cls_mobios.asmx/RegisterPassenger"
#define ChangePassword_URL @"cls_mobios.asmx/ChangePassword"
#define CheckLogin_URL @"cls_mobios.asmx/CheckLogin"
#define ConfirmMobile_URL @"cls_mobios.asmx/Confirm_Mobile"
#define DriverReviewList_URL @"cls_mobios.asmx/Driver_GetReviewList"
#define PassengerReviewList_URL @"cls_mobios.asmx/Passenger_GetReviewList"
#define EditProfile_URL @"cls_mobios.asmx/EditProfile"
#define ForgotPassword_URL @"cls_mobios.asmx/ForgetPassword"
#define GetCalculatedRating_URL @"cls_mobios.asmx/GetCalculatedRating"
#define GetPrefferedLanguages_URL @"cls_mobios.asmx/GetPrefferedLanguages"
#define Passenger_FindRide_URL @"cls_mobios.asmx/Passenger_FindRide"

//MobVehicle
#define GetVehicles_URL @"cls_mobios.asmx/Get?id=%@"
#define GetVehiclesByDriveID_URL @"cls_mobios.asmx/GetByDriverId?id=%@"


#pragma Colors
#define Red_HEX @"E30613"
#define Yellow_HEX @"f30c12"
#define Red_UIColor [UIColor add_colorWithRGBHexString:Red_HEX]
#define Yellow_UIColor [UIColor add_colorWithRGBHexString:Yellow_HEX]

#pragma ENUMS

typedef enum RoadType : NSUInteger {
    PeriodicType,
    SingleRideType
} RoadType;

typedef enum NotificationType : NSUInteger {
    NotificationTypeAccepted,
    NotificationTypeAlert,
    NotificationTypePending
} NotificationType;

typedef enum WebViewType : NSUInteger {
    WebViewPrivacyType,
    WebViewTermsAndConditionsType
} WebViewType;

typedef enum AccountType : NSUInteger {
    AccountTypeDriver,
    AccountTypePassenger,
    AccountTypeBoth,
    AccountTypeNone
} AccountType;

typedef enum TextFieldType : NSUInteger {
    PickupTextField,
    DestinationTextField,
    NationalityTextField,
    LanguageTextField,
    AgeRangeTextField,
    VehiclesTextField
} TextFieldType;


#define API_PARAMETERS_KEYS

#define Account_KEY         @"AccountID"
#define Gender_KEY          @"PreferredGender"
#define Time_KEY            @"Time"
#define FromEmirateID_KEY   @"FromEmirateID"
#define FromRegionID_KEY    @"FromRegionID"
#define ToEmirateID_KEY     @"ToEmirateID"
#define ToRegionID_KEY      @"ToRegionID"
#define Language_KEY        @"PrefferedLanguageId"
#define Nationality_KEY     @"PrefferedNationlaities"
#define AgeRange_KEY        @"AgeRangeId"
#define StartDate_KEY       @"StartDate"
#define IsPeriodic_KEY      @"IsPeriodic"
#define id_KEY @"id"
#define fileName_KEY @"s_FileName"

#define Driver_Ride_CELLHEIGHT 170

#define VIEWS_OFFSET 0
#define VIEW_PADDING_DEFAULT 0
#define VIEW_PADDING_STATUS 20
#define VIEW_DIMENSIONS 320
#define VIEW_DIMENSIONS_IPad 768
#define VIEW_PADDING 44
#define VIEW_PADDING_IOS7 64
#define VIEW_HIEGHT 480
#define VIEW_HIEGHT_IPHONE5 528

#define GoogleMapsAPIKey @"AIzaSyBxG-5UNm22YqbwQZReb7Yv6eJ02ztjpxQ"
#define GoogleMaps_ProjectNumber @"308520536406"
#define GoogleMaps_ApplicationID @"sharekni-1121"

//#define KIS_ARABIC ([[KUSER_DEFAULTS valueForKey:KUSER_LANGUAGE_KEY] isEqualToString:@"ar"])
#define KIS_SYS_LANGUAGE_ARABIC ([[[NSLocale preferredLanguages] objectAtIndex:0] isEqualToString:@"ar"])
#define KUSER_DEFAULTS ([NSUserDefaults standardUserDefaults])
#define KUSER_TOKEN_KEY @"KUSER_TOKEN_KEY"
#define KUSER_LANGUAGE_KEY @"KUSER_LANGUAGE_KEY"
#define KNEEDS_TO_COMPLETE_PROFILE_KEY @"KNEEDS_TO_COMPLETE_PROFILE_KEY"

#import "Languages.h"


#endif
