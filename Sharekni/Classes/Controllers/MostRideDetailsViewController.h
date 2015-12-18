//
//  MostRideDetailsViewController.h
//  sharekni
//
//  Created by Ahmed Askar on 10/31/15.
//
//

#import <UIKit/UIKit.h>
#import "MostRide.h"

@interface MostRideDetailsViewController : UIViewController

@property (nonatomic ,strong) MostRide *ride ;

@property (nonatomic ,weak) IBOutlet UILabel *fromLbl ;
@property (nonatomic ,weak) IBOutlet UILabel *toLbl ;

@end
