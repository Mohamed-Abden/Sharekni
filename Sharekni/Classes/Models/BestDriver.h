//
//  BestDriver.h
//  Sharekni
//
//  Created by Ahmed Askar on 10/9/15.
//
//

#import <Foundation/Foundation.h>

@interface BestDriver : NSObject

@property (nonatomic,strong) NSString *AccountId;
@property (nonatomic,strong) NSString *AccountName;
@property (nonatomic,strong) NSString *AccountPhoto;
@property (nonatomic,strong) NSString *AccountMobile;
@property (nonatomic,strong) NSString *NationalityArName;
@property (nonatomic,strong) NSString *NationalityEnName;
@property (nonatomic,strong) NSString *NationalityFrName;
@property (nonatomic,strong) NSString *NationalityChName;
@property (nonatomic,strong) NSString *NationalityUrName;
@property (nonatomic,assign) long Rating;

@end