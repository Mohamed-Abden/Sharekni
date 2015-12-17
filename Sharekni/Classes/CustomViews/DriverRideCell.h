//
//  DriverRideCell.h
//  sharekni
//
//  Created by Ahmed Askar on 11/4/15.
//
//

#import <UIKit/UIKit.h>
#import "DriverDetails.h"
#import "Ride.h"
#import "MostRideDetails.h"
#import "CreatedRide.h"
#define RIDE_CELLID @"RIDECELL"

@interface DriverRideCell : UITableViewCell

@property (nonatomic ,weak) IBOutlet UILabel *RouteName ;
@property (nonatomic ,weak) IBOutlet UIView *containerView ;
@property (nonatomic ,weak) IBOutlet UILabel *FromRegionName ;
@property (nonatomic ,weak) IBOutlet UILabel *ToRegionName ;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdButton;

@property (nonatomic, copy) void (^editHandler)(void);
@property (nonatomic, copy) void (^deleteHandler)(void);
@property (nonatomic, copy) void (^detailsHandler)(void);

@property (nonatomic, copy) void (^leaveHandler)(void);
@property (nonatomic, copy) void (^driverHandler)(void);

@property (nonatomic,strong) DriverDetails *driverRideDetails;
@property (nonatomic,strong) Ride *joinedRide;
@property (nonatomic,strong) CreatedRide *createdRide;

- (void)setSavedResultRideDetails:(MostRideDetails *)rideDetails ;

@end
