//
//  User.h
//  Sharekni
//
//  Created by ITWORX on 9/28/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface User : NSObject

@property (nonatomic,strong) NSNumber *ID;
@property (nonatomic,strong) NSString *FirstName;
@property (nonatomic,strong) NSString *MiddleName;
@property (nonatomic,strong) NSString *LastName;
@property (nonatomic,strong) NSString *BirthDate;
@property (nonatomic,strong) NSString *PhotoPath;
@property (nonatomic,strong) NSString *Email;
@property (nonatomic,strong) NSString *Phone;
@property (nonatomic,strong) NSString *Mobile;
@property (nonatomic,strong) NSString *GenderAr;
@property (nonatomic,strong) NSString *GenderEn;
@property (nonatomic,strong) NSString *Username;
@property (nonatomic,strong) NSString *Password;
@property (nonatomic,strong) NSNumber *Active;
@property (nonatomic,strong) NSString *DateAdded;
@property (nonatomic,strong) NSNumber *NationalityId;
@property (nonatomic,strong) NSString *NationalityArName;
@property (nonatomic,strong) NSString *NationalityEnName;
@property (nonatomic,strong) NSString *NationalityFrName;
@property (nonatomic,strong) NSString *NationalityChName;
@property (nonatomic,strong) NSString *NationalityUrName;
@property (nonatomic,strong) NSNumber *EmployerId;
@property (nonatomic,strong) NSString *EmployerArName;
@property (nonatomic,strong) NSString *EmployerEnName;
@property (nonatomic,strong) NSNumber *AccountTypeId;
@property (nonatomic,strong) NSString *AccountTypeArName;
@property (nonatomic,strong) NSString *AccountTypeEnName;
@property (nonatomic,strong) NSString *AccountStatus;
@property (nonatomic,strong) NSNumber *PrefferedLanguage;

@property (nonatomic,strong) NSNumber *DriverMyRidesCount;
@property (nonatomic,strong) NSNumber *DriverMyAlertsCount;

@property (nonatomic,strong) NSNumber *PassengerJoinedRidesCount;
@property (nonatomic,strong) NSNumber *PassengerMyRidesCount;

@property (nonatomic,strong) UIImage *userImage;

@end
