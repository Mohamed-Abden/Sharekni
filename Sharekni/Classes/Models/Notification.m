//
//  Notification.m
//  sharekni
//
//  Created by Ahmed Askar on 11/22/15.
//
//

#import "Notification.h"
#import "MobAccountManager.h"

@implementation Notification

+ (NSDictionary *)mapping
{
    NSMutableDictionary *mapping = [NSMutableDictionary dictionary];
    mapping[@"RequestId"] = @"RequestId";
    mapping[@"DriverAccept"] = @"DriverAccept";
    mapping[@"DriverName"] = @"DriverName";
    mapping[@"RouteName"] = @"RouteName";
    mapping[@"Remarks"] = @"Remarks";
    mapping[@"RequestDate"] = @"RequestDate";
    mapping[@"PassengerMobile"] = @"PassengerMobile";
    mapping[@"AccountPhoto"] = @"AccountPhoto";
    mapping[@"NationalityEnName"] = @"AccountGender";
    mapping[@"NationalityFrName"] = @"AccountGenderAr";
    mapping[@"NationalityChName"] = @"AccountGenderEn";
    mapping[@"NationalityUrName"] = @"AccountNationality";
    mapping[@"NationalityEnName"] = @"NationalityArName";
    mapping[@"NationalityFrName"] = @"NationalityEnName";
    mapping[@"NationalityChName"] = @"NationalityFrName";
    mapping[@"NationalityUrName"] = @"NationalityChName";
    mapping[@"NationalityUrName"] = @"NationalityUrName";

    return mapping;
}

- (void)setAccountPhoto:(NSString *)AccountPhoto
{
    __block Notification *blockSelf = self;
    _AccountPhoto = AccountPhoto ;
    [[MobAccountManager sharedMobAccountManager] GetPhotoWithName:_AccountPhoto withSuccess:^(UIImage *image, NSString *filePath) {
        blockSelf.image = image ;
        blockSelf.imagePath = filePath;
    } Failure:^(NSString *error) {
        NSLog(@"Failed to download notification profile image");
    }];
}

@end
