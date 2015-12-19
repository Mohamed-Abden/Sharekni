//
//  AddReviewViewController.h
//  MJPopupViewControllerDemo
//
//  Created by Martin Juhasz on 24.06.12.
//  Copyright (c) 2012 martinjuhasz.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DriverDetails.h"
#import "RouteDetails.h"
#import "Review.h"

@protocol MJDetailPopupDelegate;

@interface AddReviewViewController : UIViewController
{
    __weak IBOutlet UITextView *viewText;
}

@property (weak, nonatomic) IBOutlet UILabel *headerTitle;
@property (weak, nonatomic) IBOutlet UILabel *headerTitle2;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;


@property (assign, nonatomic) id <MJDetailPopupDelegate> delegate;

@property (nonatomic ,strong) RouteDetails *routeDetails;
@property (nonatomic ,strong) NSString *accountID ;
@property (nonatomic ,assign) BOOL isEdit;
@property (nonatomic ,strong) Review *review;
@property (nonatomic, copy) void (^reviewAdded)(void);
@end

@protocol MJDetailPopupDelegate<NSObject>

@optional

- (void)cancelButtonClicked:(AddReviewViewController*)addReviewViewController;

@end
