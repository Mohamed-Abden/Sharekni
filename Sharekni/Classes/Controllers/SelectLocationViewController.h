//
//  selectLocationViewController.h
//  Sharekni
//
//  Created by ITWORX on 10/7/15.
//
//

#import <UIKit/UIKit.h>
#import "Emirate.h"
#import "Region.h"
@interface SelectLocationViewController : UIViewController
@property (nonatomic,strong) NSString *viewTitle;

@property (strong, nonatomic) void (^selectionHandler) (Emirate*,Region*) ;
@end