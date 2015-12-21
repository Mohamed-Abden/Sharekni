//
//  Notification.h
//  sharekni
//
//  Created by Ahmed Askar on 11/22/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Notification : NSObject

@property (nonatomic,strong) NSNumber *RequestId;
@property (nonatomic,strong) NSNumber *DriverAccept;
@property (nonatomic,strong) NSString *DriverName;
@property (nonatomic,strong) NSString *RouteName;
@property (nonatomic,strong) NSString *Remarks;
@property (nonatomic,strong) NSString *RequestDate;
@property (nonatomic,strong) NSString *PassengerMobile;
@property (nonatomic,strong) NSString *PassengerName;
@property (nonatomic,strong) NSString *AccountPhoto;
@property (nonatomic,strong) NSString *AccountGender;
@property (nonatomic,strong) NSString *AccountGenderAr;
@property (nonatomic,strong) NSString *AccountGenderEn;
@property (nonatomic,strong) NSString *AccountNationality;
@property (nonatomic,strong) NSString *NationalityArName;
@property (nonatomic,strong) NSString *NationalityEnName;
@property (nonatomic,strong) NSString *NationalityFrName;
@property (nonatomic,strong) NSString *NationalityChName;
@property (nonatomic,strong) NSString *NationalityUrName;
@property (nonatomic,assign) BOOL isPending;

@property (nonatomic ,strong) UIImage *image ;
@property (nonatomic ,strong) NSString *imagePath ;

@end