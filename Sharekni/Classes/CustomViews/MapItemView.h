//
//  ServiceCenterView.h
//  Warshety
//
//  Created by Mohamed Abd El-latef on 11/4/14.
//  Copyright (c) 2014 Mohamed Abd El-latef. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "MapLookUp.h"
@interface MapItemView : NSObject <MKAnnotation>
@property (nonatomic,strong) NSString *arabicName;
@property (nonatomic,strong) NSString *englishName;
@property (nonatomic,strong) NSString *lat;
@property (nonatomic,strong) NSString *lng;
@property (nonatomic,strong) NSString *rides;
@property (nonatomic,strong) NSString *passengers;
@property (nonatomic,strong) NSString *comingRides;

- (instancetype) initWithLat:(NSString *)lat lng:(NSString *)lng address:(NSString *)address name:(NSString *)name;
@end