//
//  DriverDetailsViewController.h
//  sharekni
//
//  Created by Ahmed Askar on 11/3/15.
//
//

#import <UIKit/UIKit.h>
#import "MostRideDetails.h"
#import "BestDriver.h"
@interface DriverDetailsViewController : UIViewController

@property (nonatomic ,strong) MostRideDetails *mostRideDetails ;
@property (nonatomic ,strong) BestDriver *bestDriver ;
@property (nonatomic ,assign) BOOL isBestDriver ;

@end
