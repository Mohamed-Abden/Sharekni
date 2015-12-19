//
//  RouteDetails.h
//  sharekni
//
//  Created by Mohamed Abd El-latef on 11/19/15.
//
//

#import <Foundation/Foundation.h>

@interface RouteDetails : NSObject
@property (nonatomic,strong) NSNumber *ID;
@property (nonatomic,strong) NSString *RouteArName;
@property (nonatomic,strong) NSString *RouteEnName;
@property (nonatomic,strong) NSString *PreferredGender;

@property (nonatomic,strong) NSNumber *IsSmoking;

@property (nonatomic,strong) NSNumber *NoOfSeats;
@property (nonatomic,strong) NSString *StartFromTime;
@property (nonatomic,strong) NSString *StartToTime;
@property (nonatomic,strong) NSString *EndFromTime;
@property (nonatomic,strong) NSString *EndToTime_;
@property (nonatomic,strong) NSNumber *IsRounded;
@property (nonatomic,strong) NSNumber *IsPassenger;

@property (nonatomic,strong) NSNumber *FromEmirateId;
@property (nonatomic,strong) NSString *FromEmirateArName;
@property (nonatomic,strong) NSString *FromEmirateEnName;
@property (nonatomic,strong) NSString *FromEmirateNameFr;
@property (nonatomic,strong) NSString *FromEmirateNameCh;
@property (nonatomic,strong) NSString *FromEmirateNameUr;

@property (nonatomic,strong) NSNumber *ToEmirateId;
@property (nonatomic,strong) NSString *ToEmirateArName;
@property (nonatomic,strong) NSString *ToEmirateEnName;
@property (nonatomic,strong) NSString *ToEmirateNameFr;
@property (nonatomic,strong) NSString *ToEmirateNameCh;
@property (nonatomic,strong) NSString *ToEmirateNameUr;

@property (nonatomic,strong) NSNumber *FromRegionId;
@property (nonatomic,strong) NSString *FromRegionArName;
@property (nonatomic,strong) NSString *FromRegionEnName;
@property (nonatomic,strong) NSString *FromRegionNameFr;
@property (nonatomic,strong) NSString *FromRegionNameCh;
@property (nonatomic,strong) NSString *FromRegionNameUr;

@property (nonatomic,strong) NSNumber *ToRegionId;
@property (nonatomic,strong) NSString *ToRegionArName;
@property (nonatomic,strong) NSString *ToRegionEnName;
@property (nonatomic,strong) NSString *ToRegionNameFr;
@property (nonatomic,strong) NSString *ToRegionNameCh;
@property (nonatomic,strong) NSString *ToRegionNameUr;


@property (nonatomic,strong) NSString *FromStreetName;
@property (nonatomic,strong) NSString *ToStreetName;

@property (nonatomic,strong) NSString *Remarks;
@property (nonatomic,strong) NSNumber *AccountId;

@property (nonatomic,strong) NSString *BasisId;
@property (nonatomic,strong) NSString *BasisArName;
@property (nonatomic,strong) NSString *BasisEnName;
@property (nonatomic,strong) NSString *BasisFrName;
@property (nonatomic,strong) NSString *BasisChName;
@property (nonatomic,strong) NSString *BasisUrName;

@property (nonatomic,strong) NSNumber *VehicelId;
@property (nonatomic,strong) NSString *VehicleArName;
@property (nonatomic,strong) NSString *VehicleEnName;

@property (nonatomic,strong) NSNumber *NationalityId;
@property (nonatomic,strong) NSString *NationalityArName;
@property (nonatomic,strong) NSString *NationalityEnName;
@property (nonatomic,strong) NSString *NationalityFrName;
@property (nonatomic,strong) NSString *NationalityChName;
@property (nonatomic,strong) NSString *NationalityUrName;

@property (nonatomic,strong) NSNumber *PrefLanguageId;
@property (nonatomic,strong) NSString *PrefLanguageArName;
@property (nonatomic,strong) NSString *PrefLanguageEnName;
@property (nonatomic,strong) NSString *PrefLanguageFrName;
@property (nonatomic,strong) NSString *PrefLanguageChName;
@property (nonatomic,strong) NSString *PrefLanguageUrName;

@property (nonatomic,strong) NSNumber *Saturday;
@property (nonatomic,strong) NSNumber *Sunday;
@property (nonatomic,strong) NSNumber *Monday;
@property (nonatomic,strong) NSNumber *Tuesday;
@property (nonatomic,strong) NSNumber *Wendenday;
@property (nonatomic,strong) NSNumber *Thrursday;
@property (nonatomic,strong) NSNumber *Friday;

@property (nonatomic,strong) NSString *StartDate;

@property (nonatomic,strong) NSNumber *AgeRangeId;
@property (nonatomic,strong) NSString *StartLat;
@property (nonatomic,strong) NSString *StartLng;
@property (nonatomic,strong) NSString *EndLat;
@property (nonatomic,strong) NSString *EndLng;
@property (nonatomic,strong) NSString *AgeRangeID;
@property (nonatomic,strong) NSString *AgeRange;
@property (nonatomic,strong) NSString *AccountRating;

@end
