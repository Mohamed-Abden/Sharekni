//
//  RideDetailsViewController.m
//  sharekni
//
//  Created by Ahmed Askar on 10/31/15.
//
//

#import "RideDetailsViewController.h"
#import "MessageUI/MessageUI.h"
#import "Constants.h"
#import <KVNProgress/KVNProgress.h>
#import "NSObject+Blocks.h"
#import <UIColor+Additions.h>
#import "MasterDataManager.h"
#import "Review.h"
#import "ReviewCell.h"
#import "UIView+Borders.h"
#import <UIColor+Additions/UIColor+Additions.h>
#import "Constants.h"
#import "NSStringEmpty.h"
#import "MapItemView.h"
#import "MapItemPopupViewController.h"
#import "MapInfoWindow.h"
#import "RouteDetails.h"
#import <GoogleMaps/GoogleMaps.h>
#import "AddReviewViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "MobAccountManager.h"
#import "PassengerCell.h"
#import "Passenger.h"
#import "AddRemarksViewController.h"
#import "LoginViewController.h"
#import "CreateRideViewController.h"
#import "HCSStarRatingView.h"

#define VERTICAL_SPACE 15
#define REVIEWS_CELL_HEIGHT  110
#define PASSENGER_ALERT_TAG  1199
#define DELETE_RIDE_ALERT_TAG  1188

@interface RideDetailsViewController ()<GMSMapViewDelegate,MJDetailPopupDelegate,MJAddRemarkPopupDelegate,MFMessageComposeViewControllerDelegate,UIAlertViewDelegate>
{
    __weak IBOutlet UIScrollView *contentView ;
    __weak IBOutlet UITableView *reviewList ;
    __weak IBOutlet UIView *passengersHeader;
    __weak IBOutlet UIButton *joinRideBtn ;
    
    __weak IBOutlet UILabel *FromRegionName ;
    __weak IBOutlet UILabel *ToRegionName ;
    __weak IBOutlet UILabel *startingTime ;
    __weak IBOutlet UILabel *availableDays ;
    
    __weak IBOutlet UILabel *language ;
    __weak IBOutlet UILabel *smoking ;
    __weak IBOutlet UILabel *nationality ;
    __weak IBOutlet UILabel *gender ;
    __weak IBOutlet UILabel *ageRange ;
    
    __weak IBOutlet MKMapView *_MKmapView;

    __weak IBOutlet UIView *locationsView;
    __weak IBOutlet UILabel *preferenceLbl ;
    __weak IBOutlet UILabel *reviewLbl ;
    __weak IBOutlet UIView *preferenceView ;
    __weak IBOutlet UIButton *secondButton;
    __weak IBOutlet UIView *reviewsView ;
    __weak IBOutlet UITableView *passengersList;
    __weak IBOutlet UIView *placeholderRatingView;
    GMSMapView *_mapView;
    __weak IBOutlet UIButton *firstButton;
    __weak IBOutlet UIView *passengersView;
    __weak IBOutlet UIButton *thirdButton;
}

@property (nonatomic ,strong) HCSStarRatingView *driverRatingsView ;

@property (nonatomic ,strong) NSMutableArray *reviews ;
@property (nonatomic ,strong) NSMutableArray *markers ;
@property (nonatomic ,strong) NSArray *passengers ;
@property (nonatomic ,strong) Passenger *toBeDeletedpassenger ;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *passengersHeaderLabels;
@property (nonatomic ,strong) RouteDetails *routeDetails ;
@property (nonatomic ,strong) UIBarButtonItem *loadingBarButton;
@end

@implementation RideDetailsViewController

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void) viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"rideDetails", nil);

    UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(0, 0, 22, 22);
    [_backBtn setBackgroundImage:[UIImage imageNamed:NSLocalizedString(@"Back_icn", nil)] forState:UIControlStateNormal];
    [_backBtn setHighlighted:NO];
    [_backBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
    
    [contentView setScrollEnabled:YES];
    [contentView setContentSize:contentView.frame.size];
    
    [preferenceLbl addRightBorderWithColor:Red_UIColor];
    [preferenceLbl addLeftBorderWithColor:Red_UIColor];
//    preferenceLbl.layer.
    [preferenceLbl setTextColor:Red_UIColor];
    
    [reviewLbl addRightBorderWithColor:Red_UIColor];
    [reviewLbl addLeftBorderWithColor:Red_UIColor];
    [reviewLbl setTextColor:Red_UIColor];

    
    preferenceView.layer.cornerRadius = 20;
    preferenceView.layer.borderWidth  = 1;
    preferenceView.layer.borderColor  = Red_UIColor.CGColor;
    
    reviewsView.layer.cornerRadius = 20;
    reviewsView.layer.borderWidth  = 1;
    
    passengersHeader.backgroundColor = [UIColor whiteColor];
    
    reviewsView.layer.borderColor  = Red_UIColor.CGColor;
    
    joinRideBtn.layer.cornerRadius = 8;

    [passengersHeader addBottomBorderWithColor:[UIColor lightGrayColor]];
    for (UILabel *label in self.passengersHeaderLabels) {
        [label setTextColor:Red_UIColor];
    }
    
    passengersList.separatorColor = [UIColor lightGrayColor];
    
    [passengersList registerClass:[PassengerCell class] forCellReuseIdentifier:PASSENGER_CELLID];
    [passengersList registerNib:[UINib nibWithNibName:@"PassengerCell" bundle:nil] forCellReuseIdentifier:PASSENGER_CELLID];

    //Actions
    firstButton.alpha = 0;
    secondButton.alpha = 0;
    thirdButton.alpha = 0;

    [self configureMapView];
    [self configureData];
}

- (HCSStarRatingView *) driverRatingsView{
    if (!_driverRatingsView) {
        _driverRatingsView = [[HCSStarRatingView alloc] initWithFrame:placeholderRatingView.frame];
        _driverRatingsView.maximumValue = 5;
        _driverRatingsView.minimumValue = 0;
        _driverRatingsView.value = 0;
        _driverRatingsView.tintColor = [UIColor whiteColor];
        _driverRatingsView.backgroundColor = [UIColor clearColor];
        [_driverRatingsView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
        _driverRatingsView.accurateHalfStars = YES;
        _driverRatingsView.emptyStarImage = [[UIImage imageNamed:@"star-empty"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _driverRatingsView.filledStarImage = [[UIImage imageNamed:@"start-filled"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [placeholderRatingView removeFromSuperview];
    }
    return _driverRatingsView;
}

- (void) didChangeValue:(HCSStarRatingView *)sender {
 //Rate Driver
    __block RideDetailsViewController *blockSelf = self;
    NSString *driverID = self.driverDetails ? self.driverDetails.ID : self.joinedRide.Account.stringValue;
    NSString *routeID;
    if (self.driverDetails) {
        routeID = self.driverDetails.RouteId;
    }
    else if (self.createdRide){
        routeID = self.createdRide.RouteID.stringValue;
    }
    else if (self.joinedRide){
        routeID = self.joinedRide.RouteID.stringValue;
    }
    self.navigationItem.rightBarButtonItem = self.loadingBarButton;
    [[MobAccountManager sharedMobAccountManager] addDriverRatingWithDriverID:driverID inRouteID:routeID noOfStars:sender.value WithSuccess:^(NSString *response) {
        blockSelf.navigationItem.rightBarButtonItem = nil;
        [KVNProgress showSuccessWithStatus:NSLocalizedString(@"Rating added successfully", nil)];
        [blockSelf performBlock:^{
            [KVNProgress dismiss];
        } afterDelay:3];
        
    } Failure:^(NSString *error) {
        [KVNProgress showErrorWithStatus:NSLocalizedString(@"Unable to add Rating now", nil)];
        [blockSelf performBlock:^{
            [KVNProgress dismiss];
        } afterDelay:3];
        blockSelf.navigationItem.rightBarButtonItem = nil;
    }];
}

- (void) popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) showRideDetailsData
{
    FromRegionName.text = [NSString stringWithFormat:@"%@ : %@",(KIS_ARABIC)?self.routeDetails.FromEmirateArName:self.routeDetails.FromEmirateEnName,(KIS_ARABIC)?self.routeDetails.FromRegionArName:self.routeDetails.FromRegionEnName];
    
    ToRegionName.text = [NSString stringWithFormat:@"%@ : %@",(KIS_ARABIC)?self.routeDetails.ToEmirateArName:self.routeDetails.ToEmirateEnName,(KIS_ARABIC)?self.routeDetails.ToRegionArName:self.routeDetails.ToRegionEnName];
    
    startingTime.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"From", nil),self.routeDetails.StartFromTime];
    
    availableDays.text = [NSString stringWithFormat:@"%@ : %@",NSLocalizedString(@"Ride Days", nil),[self getAvailableDays]];
    
    if ([NSStringEmpty isNullOrEmpty:(KIS_ARABIC)?self.routeDetails.NationalityArName:self.routeDetails.NationalityEnName])
    {
        nationality.text = NSLocalizedString(@"Not Set", nil);
    }
    else
    {
        nationality.text = (KIS_ARABIC)?self.routeDetails.NationalityArName:self.routeDetails.NationalityEnName ;
    }
    
    if ([NSStringEmpty isNullOrEmpty:self.routeDetails.AgeRange])
    {
        ageRange.text = NSLocalizedString(@"Not Set", nil);
    }
    else
    {
        ageRange.text = self.routeDetails.AgeRange ;
    }
    
    if (self.routeDetails.IsSmoking.boolValue) {
        smoking.text = @"Yes";
    }else{
        smoking.text = @"No";
    }
    
    if ([NSStringEmpty isNullOrEmpty:(KIS_ARABIC)?self.routeDetails.PrefLanguageArName:self.routeDetails.PrefLanguageEnName])
    {
        language.text = NSLocalizedString(@"Not Set", nil);
    }
    else
    {
        language.text = (KIS_ARABIC)?self.routeDetails.PrefLanguageArName:self.routeDetails.PrefLanguageEnName;
    }
    
    gender.text = self.routeDetails.PreferredGender;
}

- (void) configureData{
    __block RideDetailsViewController *blockSelf = self;
    __block UITableView *blockPassengersList = passengersList;
    __block UITableView *blockReviewsList = reviewList;
    [KVNProgress showWithStatus:NSLocalizedString(@"loading...", nil)];
    
    NSString *routeID;
    NSString *accountID ;
    if (self.driverDetails) {
        routeID = self.driverDetails.RouteId;
        accountID = self.driverDetails.ID;
    }
    else if (self.createdRide){
        routeID = self.createdRide.RouteID.stringValue;
        accountID = [[MobAccountManager sharedMobAccountManager] applicationUserID];
    }
    else if (self.joinedRide){
        routeID = self.joinedRide.RouteID.stringValue;
        accountID = [[MobAccountManager sharedMobAccountManager] applicationUserID];
    }
    
   [[MasterDataManager sharedMasterDataManager] GetRouteByRouteId:routeID withSuccess:^(RouteDetails *routeDetails) {
       
       blockSelf.routeDetails = routeDetails;
       [blockSelf configurePins];
       [blockSelf focusMapToShowAllMarkers];
       [blockSelf showRideDetailsData];
       
       [[MasterDataManager sharedMasterDataManager] getReviewList:routeDetails.AccountId.stringValue andRoute:routeDetails.ID.stringValue withSuccess:^(NSMutableArray *array) {
           blockSelf.reviews = array;
           
           if (array.count == 0) {
               reviewLbl.hidden = YES ;
           }
           [blockReviewsList reloadData];
           
           if (blockSelf.createdRide) {
               [[MasterDataManager sharedMasterDataManager] getPassengersByRouteId:blockSelf.routeDetails.ID.stringValue withSuccess:^(NSMutableArray *array) {
                   blockSelf.passengers = array;
                   [blockPassengersList reloadData];
                   [KVNProgress dismiss];
                   [blockSelf configureFrames];
                   [blockSelf configureActionsButtons];
                   
               } Failure:^(NSString *error) {
                   [blockSelf handleResponseError];
                   [blockSelf configureFrames];
                   [blockSelf configureActionsButtons];
               }];
           }
           else{
               [KVNProgress dismiss];
               [blockSelf configureFrames];
               [blockSelf configureActionsButtons];
           }
           
       } Failure:^(NSString *error) {
           [blockSelf handleResponseError];
           [blockSelf configureFrames];
           [blockSelf configureActionsButtons];
       }];
       
    } Failure:^(NSString *error) {
       [blockSelf handleResponseError];
       [blockSelf configureFrames];
        [blockSelf configureActionsButtons];
   }];
}

- (void) configureActionsButtons{
    
    if (self.createdRide) {
        [firstButton setTitle:NSLocalizedString(@"Delete", nil) forState:UIControlStateNormal];
        [firstButton addTarget:self action:@selector(deleteRideAction) forControlEvents:UIControlEventTouchUpInside];
        
        [secondButton setTitle:NSLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
        [secondButton addTarget:self action:@selector(editRideAction) forControlEvents:UIControlEventTouchUpInside];
        
        [thirdButton setTitle:NSLocalizedString(@"Permit", nil) forState:UIControlStateNormal];
        [thirdButton addTarget:self action:@selector(permitRideAction) forControlEvents:UIControlEventTouchUpInside];
        
        firstButton.alpha = 1;
        secondButton.alpha = 1;
        if(self.passengers.count > 0){
            thirdButton.alpha = 1;
        }
        else{
            thirdButton.alpha = 0;
        }
    }
    else{
        [firstButton setTitle:NSLocalizedString(@"Review", nil) forState:UIControlStateNormal];
        [firstButton addTarget:self action:@selector(addReviewAction) forControlEvents:UIControlEventTouchUpInside];
        firstButton.alpha = 1;
        secondButton.alpha = 0;
        thirdButton.alpha = 0;
        if (self.joinedRide) {
            [locationsView addSubview:self.driverRatingsView];
        }
    }
}

- (void) configureFrames{
    if(self.passengers.count > 0){
        CGRect passengersLabelFrame = passengersHeader.frame;
        passengersLabelFrame.origin.y = locationsView.frame.origin.y + locationsView.frame.size.height + VERTICAL_SPACE;
        passengersHeader.frame = passengersLabelFrame;
        
        CGRect passengersViewFrame = passengersView.frame;
        passengersViewFrame.origin.y = passengersHeader.frame.origin.y + passengersHeader.frame.size.height;
        passengersViewFrame.size.height = self.passengers.count * REVIEWS_CELL_HEIGHT + 10;
        passengersView.frame = passengersViewFrame;
        
        
        CGRect passengersListFrame = passengersList.frame;
        passengersListFrame.size.height = self.passengers.count *REVIEWS_CELL_HEIGHT;
        passengersList.frame = passengersListFrame;
        
        CGRect PreferencesLabelFrame = preferenceLbl.frame;
        PreferencesLabelFrame.origin.y = passengersView.frame.origin.y + passengersView.frame.size.height + VERTICAL_SPACE;
        preferenceLbl.frame = PreferencesLabelFrame;
    }
    else{
        passengersHeader.alpha = 0;
        passengersView.alpha = 0;
        
        CGRect PreferencesLabelFrame = preferenceLbl.frame;
        PreferencesLabelFrame.origin.y = locationsView.frame.origin.y + locationsView.frame.size.height + VERTICAL_SPACE;
        preferenceLbl.frame = PreferencesLabelFrame;
    }
    
    CGRect PreferencesViewFrame = preferenceView.frame;
    PreferencesViewFrame.origin.y = preferenceLbl.frame.origin.y + VERTICAL_SPACE;
    preferenceView.frame = PreferencesViewFrame;
    
    
    if(self.reviews.count > 0){
        CGRect reviewsLabelFrame = reviewLbl.frame;
        reviewsLabelFrame.origin.y = preferenceView.frame.origin.y + preferenceView.frame.size.height + VERTICAL_SPACE;
        reviewLbl.frame = reviewsLabelFrame;
        
        CGRect reviewsViewFrame = reviewsView.frame;
        reviewsViewFrame.origin.y = reviewLbl.frame.origin.y + VERTICAL_SPACE;
        reviewsViewFrame.size.height = (self.reviews.count * REVIEWS_CELL_HEIGHT) + 10;
        reviewsView.frame = reviewsViewFrame;
        
        CGRect reviewsListFrame = reviewList.frame;
        reviewsListFrame.size.height = self.reviews.count *REVIEWS_CELL_HEIGHT;
        reviewList.frame = reviewsListFrame;
        
        CGRect buttonFrame = joinRideBtn.frame;
        buttonFrame.origin.y = reviewsView.frame.origin.y + reviewsView.frame.size.height + VERTICAL_SPACE;
        joinRideBtn.frame = buttonFrame;
    }
    else{
        reviewLbl.hidden = YES;
        reviewsView.hidden = YES;
        
        CGRect buttonFrame = joinRideBtn.frame;
        buttonFrame.origin.y = preferenceView.frame.origin.y + preferenceView.frame.size.height + VERTICAL_SPACE;
        joinRideBtn.frame = buttonFrame;
    }

    if (self.joinedRide || self.createdRide) {
        joinRideBtn.alpha = 0;
        CGSize contentSize = contentView.contentSize ;
        contentSize.height = joinRideBtn.frame.origin.y;
        contentView.contentSize = contentSize;
    }
    else{
        CGSize contentSize = contentView.contentSize ;
        contentSize.height = joinRideBtn.frame.origin.y + joinRideBtn.frame.size.height + VERTICAL_SPACE;
        contentView.contentSize = contentSize;
    }
}

- (void) handleResponseError{
    NSLog(@"Error in Best Drivers");
    [KVNProgress dismiss];
    [KVNProgress showErrorWithStatus:@"Error"];
    [self performBlock:^{
        [KVNProgress dismiss];
    } afterDelay:3];
}

- (NSString *)getAvailableDays{
    NSMutableString *str = [[NSMutableString alloc] init];
    
    if (self.routeDetails.Saturday.boolValue) {
        [str appendString:NSLocalizedString(@"Sat ", nil)];
    }
    if (self.routeDetails.Sunday.boolValue) {
        [str appendString:NSLocalizedString(@"Sun ", nil)];
    }
    if (self.routeDetails.Monday.boolValue) {
        [str appendString:NSLocalizedString(@"Mon ", nil)];
    }
    if (self.routeDetails.Tuesday.boolValue) {
        [str appendString:NSLocalizedString(@"Tue ", nil)];
    }
    if (self.routeDetails.Wendenday.boolValue) {
        [str appendString:NSLocalizedString(@"Wed ", nil)];
        
    }
    if (self.routeDetails.Thrursday.boolValue) {
        [str appendString:NSLocalizedString(@"Thu ", nil)];
        
    }
    if (self.routeDetails.Friday.boolValue) {
        [str appendString:NSLocalizedString(@"Fri ", nil)];
    }
    
    return str ;
}

#pragma mark - Event Handler
- (void) addReviewAction{
    User *user = [[MobAccountManager sharedMobAccountManager] applicationUser];
    if (user) {
        AddReviewViewController *addReview = [[AddReviewViewController alloc] initWithNibName:@"AddReviewViewController" bundle:nil];
        
        addReview.routeDetails = self.routeDetails ;
        addReview.delegate = self;
        [self presentPopupViewController:addReview animationType:MJPopupViewAnimationSlideBottomBottom];
    }
    else{
        LoginViewController *loginView =  [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        UINavigationController *navg = [[UINavigationController alloc] initWithRootViewController:loginView];
        loginView.isLogged = YES ;
        [self presentViewController:navg animated:YES completion:nil];
    }
}

- (void) deleteRideAction{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Confirm", nil) message:NSLocalizedString(@"Do you want to delete this ride", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Delete", nil), nil];
        alertView.tag = DELETE_RIDE_ALERT_TAG;
        [alertView show];
}

- (void) editRideAction{
    CreateRideViewController *editRideViewController = [[CreateRideViewController alloc] initWithNibName:@"CreateRideViewController" bundle:nil];
    editRideViewController.routeDetails = self.routeDetails;
    __block RideDetailsViewController *blockSelf = self;
    [editRideViewController setEditHandler:^{
        [blockSelf refreshInfo];
    }];
    [self.navigationController pushViewController:editRideViewController animated:YES];
}

- (void) permitRideAction{
    [KVNProgress showWithStatus:NSLocalizedString(@"Loading...", nil)];
    __block RideDetailsViewController *blockSelf = self;
    NSMutableArray *passengersIDS = [NSMutableArray array];
    for (Passenger *passenger in self.passengers) {
        [passengersIDS addObject:passenger.ID.stringValue];
    }
    
    [[MobAccountManager sharedMobAccountManager] addPermitForRouteID:self.routeDetails.ID.stringValue vehicleId:self.routeDetails.VehicelId.stringValue passengerIDs:passengersIDS withSuccess:^(NSString *addedSuccessfully) {
        [KVNProgress dismiss];
        [KVNProgress showSuccessWithStatus:NSLocalizedString(@"Permit added successfully.", nil)];
        [blockSelf performBlock:^{
            [KVNProgress dismiss];
            [blockSelf configureData];
        } afterDelay:3];
    } Failure:^(NSString *error) {
        [KVNProgress showErrorWithStatus:NSLocalizedString(@"an error occured when permit this ride", nil)];
        [blockSelf configureData];
        [blockSelf performBlock:^{
            [KVNProgress dismiss];
        } afterDelay:3];
    }];
}

- (void) cancelButtonClicked:(AddReviewViewController *)addReviewViewController{

    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    [self refreshReviews];
}

- (void) dismissButtonClicked:(AddRemarksViewController *)addRemarksViewController{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];

}

- (IBAction)joinThisRide:(id)sender{
    User *user = [[MobAccountManager sharedMobAccountManager] applicationUser];
    if (user != nil)
    {
        AddRemarksViewController *addRemark = [[AddRemarksViewController alloc] initWithNibName:@"AddRemarksViewController" bundle:nil];
        addRemark.driverDetails = self.driverDetails ;
        addRemark.delegate = self;
        [self presentPopupViewController:addRemark animationType:MJPopupViewAnimationSlideBottomBottom];
    }
    else
    {
        LoginViewController *loginView =  [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        UINavigationController *navg = [[UINavigationController alloc] initWithRootViewController:loginView];
        loginView.isLogged = YES ;
        [self presentViewController:navg animated:YES completion:nil];
    }
}

- (void) deleteRide{
    [KVNProgress showWithStatus:NSLocalizedString(@"Loading...", nil)];
    __block RideDetailsViewController *blockSelf = self;
    [[MobAccountManager sharedMobAccountManager] deleteRideWithID:self.routeDetails.ID.stringValue withSuccess:^(BOOL deletedSuccessfully) {
        [KVNProgress dismiss];
        [KVNProgress showSuccessWithStatus:NSLocalizedString(@"Ride Delete successfully.", nil)];
        [blockSelf performBlock:^{
            [KVNProgress dismiss];
            [blockSelf configureData];
        } afterDelay:3];
        
    } Failure:^(NSString *error) {
        [KVNProgress showErrorWithStatus:NSLocalizedString(@"an error occured when deleting ride", nil)];
        [blockSelf configureData];
        [blockSelf performBlock:^{
            [KVNProgress dismiss];
        } afterDelay:3];
    }];
}

- (void) deletePassenger:(Passenger *)passenger{
    __block RideDetailsViewController *blockSelf = self;
    
    [KVNProgress showWithStatus:NSLocalizedString(@"loading...", nil)];
    [[MasterDataManager sharedMasterDataManager] deletePassengerWithID:passenger.ID.stringValue withSuccess:^(NSString *response) {
        [KVNProgress dismiss];
        if([response containsString:@"1"]){
            [KVNProgress showSuccessWithStatus:NSLocalizedString(@"Passenger removed successfully", nil)];
            [blockSelf performBlock:^{
                [KVNProgress dismiss];
            } afterDelay:3];
            [blockSelf refreshPassengers];
        }
        else{
            [KVNProgress showErrorWithStatus:NSLocalizedString(@"Unable to remover passenger", nil)];
            [blockSelf performBlock:^{
                [KVNProgress dismiss];
            } afterDelay:3];
        }
    } Failure:^(NSString *error) {
        [blockSelf handleResponseError];
    }];
}

#pragma mark -
#pragma mark UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex{
    if (tableView == reviewList) {
        return self.reviews.count;
    }
    else{
        return self.passengers.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == reviewList) {
        static NSString *CellIdentifier  = @"ReviewCell";
        
        ReviewCell *reviewCell = (ReviewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (reviewCell == nil)
        {
            reviewCell = (ReviewCell *)[[[NSBundle mainBundle] loadNibNamed:@"ReviewCell" owner:nil options:nil] objectAtIndex:0];
        }
        
        Review *review = self.reviews[indexPath.row];
        [reviewCell setReview:review];
        
        return reviewCell ;
    }
    else{
//        PassengerCell *passengerCell = (PassengerCell *)[tableView dequeueReusableCellWithIdentifier:PASSENGER_CELLID];
//        
//        if (passengerCell == nil)
//        {
            PassengerCell *passengerCell = [[PassengerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PASSENGER_CELLID];
//        }
        
        Passenger *passenger = self.passengers[indexPath.row];
        passengerCell.nameLabel.text = passenger.AccountName;
        passengerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        __block Passenger*blockPasseger = passenger;
        __block RideDetailsViewController *blockSelf = self;
        [passengerCell setCallHandler:^{
            if(blockPasseger.AccountMobile.length > 0){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat: @"tel:%@",blockPasseger.AccountMobile]]];
            }
            else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Account Mobile Number not avialable",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:nil, nil];
                [alertView show];
            }
        }];
        [passengerCell setMessageHandler:^{
            if(blockPasseger.AccountMobile.length > 0){
                [blockSelf sendSMSFromPhone:blockPasseger.AccountMobile];
            }
            else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Account Mobile Number not avialable",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:nil, nil];
                [alertView show];
            }
        }];
        [passengerCell setDeleteHandler:^{
            blockSelf.toBeDeletedpassenger = passenger;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"do you want to delete this passenger ?",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:@"Delete", nil];
            alertView.tag = PASSENGER_ALERT_TAG;
            [alertView show];
        }];
        [passengerCell setRatingHandler:^(float rating) {
            [blockSelf addRatingForPassenger:blockPasseger noOfStars:rating];
            NSLog(@"Rating handler");
        }];
        return passengerCell ;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == reviewList) {
        return REVIEWS_CELL_HEIGHT;
    }
    else{
        return PASSENGER_CELLHEIGHT;
    }
}
#pragma mark -
#pragma mark GOOGLE_MAPS

- (void) configureMapView{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:24.4667
                                                            longitude:54.3667
                                                                 zoom:15];
    
    CGRect frame ;
    if (IS_IPHONE_6) {
        frame =  CGRectMake(_MKmapView.frame.origin.x, _MKmapView.frame.origin.y, 375.0f, 280);
    }else if (IS_IPHONE_6P){
        frame =  CGRectMake(_MKmapView.frame.origin.x, _MKmapView.frame.origin.y, 414.0f, 280);
    }
    _mapView = [GMSMapView mapWithFrame:frame camera:camera];
    _mapView.myLocationEnabled = YES;
    _mapView.delegate = self;
    [contentView addSubview:_mapView];
    [_MKmapView removeFromSuperview];
}

- (void) configurePins
{
    [_mapView clear];
    self.markers = [NSMutableArray array];
        CLLocationCoordinate2D startPosition = CLLocationCoordinate2DMake(self.routeDetails.StartLat.doubleValue, self.routeDetails.StartLng.doubleValue);
        GMSMarker *startMarker = [GMSMarker markerWithPosition:startPosition];
    MapItemView *startItem = [[MapItemView alloc] initWithLat:self.routeDetails.StartLat lng:self.routeDetails.StartLng address:self.routeDetails.FromStreetName name:(KIS_ARABIC)?self.routeDetails.FromEmirateArName:self.routeDetails.FromEmirateEnName];
        startItem.arabicName = (KIS_ARABIC)?self.routeDetails.FromRegionArName:self.routeDetails.FromRegionEnName;
    startItem.englishName = (KIS_ARABIC)?self.routeDetails.FromRegionArName:self.routeDetails.FromRegionEnName;
        startItem.rides = self.routeDetails.NoOfSeats.stringValue;
        startMarker.userData = startItem;
    startMarker.title = (KIS_ARABIC)?self.routeDetails.FromEmirateArName:self.routeDetails.FromEmirateEnName;
        startMarker.icon = [UIImage imageNamed:@"Location"];
        startMarker.map = _mapView;
        [self.markers addObject:startMarker];
    
    CLLocationCoordinate2D endPosition = CLLocationCoordinate2DMake(self.routeDetails.EndLat.doubleValue, self.routeDetails.EndLng.doubleValue);
    GMSMarker *endMarker = [GMSMarker markerWithPosition:endPosition];
    MapItemView *endItem = [[MapItemView alloc] initWithLat:self.routeDetails.EndLat lng:self.routeDetails.EndLng address:self.routeDetails.ToStreetName name:(KIS_ARABIC)?self.routeDetails.ToEmirateArName:self.routeDetails.ToEmirateEnName];
    endItem.arabicName = (KIS_ARABIC)?self.routeDetails.ToRegionArName:self.routeDetails.ToRegionEnName;
    endItem.englishName = (KIS_ARABIC)?self.routeDetails.ToRegionArName:self.routeDetails.ToRegionEnName;
    endItem.rides = self.routeDetails.NoOfSeats.stringValue;
    endMarker.userData = endItem;
    endMarker.title = (KIS_ARABIC)?self.routeDetails.ToEmirateArName:self.routeDetails.ToEmirateEnName;
    endMarker.icon = [UIImage imageNamed:@"Location"];
    endMarker.map = _mapView;
    [self.markers addObject:endMarker];
    
    GMSMutablePath *path = [GMSMutablePath path];
    [path addCoordinate:CLLocationCoordinate2DMake(self.routeDetails.StartLat.doubleValue, self.routeDetails.StartLng.doubleValue)];
    [path addCoordinate:CLLocationCoordinate2DMake(self.routeDetails.EndLat.doubleValue,self.routeDetails.EndLng.doubleValue)];
    
    GMSPolyline *rectangle = [GMSPolyline polylineWithPath:path];
    rectangle.strokeWidth = 2.f;
    rectangle.strokeColor = Red_UIColor;
    rectangle.map = _mapView;
}

- (void) addRatingForPassenger:(Passenger *)passenger noOfStars:(NSInteger)noOfStars{
    __block RideDetailsViewController *blockSelf = self;
    self.navigationItem.rightBarButtonItem = self.loadingBarButton;
[[MobAccountManager sharedMobAccountManager] addPassengerRatingWithPassengerID:passenger.ID.stringValue inRouteID:self.routeDetails.ID.stringValue noOfStars:noOfStars WithSuccess:^(NSString *response) {
    blockSelf.navigationItem.rightBarButtonItem = nil;
    [KVNProgress showSuccessWithStatus:NSLocalizedString(@"Rating added successfully", nil)];
    [blockSelf performBlock:^{
        [KVNProgress dismiss];
    } afterDelay:3];

} Failure:^(NSString *error) {
    [KVNProgress showErrorWithStatus:NSLocalizedString(@"Unable to add Rating now", nil)];
    [blockSelf performBlock:^{
        [KVNProgress dismiss];
    } afterDelay:3];
}];
}

- (void) focusMapToShowAllMarkers{
    CLLocationCoordinate2D myLocation = ((GMSMarker *)_markers.firstObject).position;
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:myLocation coordinate:myLocation];
    
    for (GMSMarker *marker in self.markers)
        bounds = [bounds includingCoordinate:marker.position];
    
    [_mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:40.0f]];
}

#pragma mark - Message Delegate
- (void) sendSMSFromPhone:(NSString *)phone{
    if(![MFMessageComposeViewController canSendText])
    {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = @[phone];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void) messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    switch(result)
    {
        case MessageComposeResultCancelled: break; //handle cancelled event
        case MessageComposeResultFailed: break; //handle failed event
        case MessageComposeResultSent: break; //handle sent event
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == PASSENGER_ALERT_TAG && buttonIndex == 1) {
        [self deletePassenger:self.toBeDeletedpassenger];
    }
    if (alertView.tag == DELETE_RIDE_ALERT_TAG && buttonIndex == 1) {
        [self deleteRide];
    }

}

- (void) refreshReviews{
    __block RideDetailsViewController *blockSelf = self;
    __block UITableView *blockReviewsList = reviewList;
    [KVNProgress showWithStatus:NSLocalizedString(@"loading...", nil)];
    [[MasterDataManager sharedMasterDataManager] getReviewList:self.routeDetails.AccountId.stringValue andRoute:self.routeDetails.ID.stringValue withSuccess:^(NSMutableArray *array) {
        [KVNProgress dismiss];
        blockSelf.reviews = array;
        
        
        if (array.count == 0) {
            reviewLbl.hidden = YES ;
        }
        [blockReviewsList reloadData];
        [blockSelf configureFrames];
    }Failure:^(NSString *error) {
        [KVNProgress dismiss];
        [blockSelf handleResponseError];
    }];
}

- (void) refreshPassengers{
    __block RideDetailsViewController *blockSelf = self;
    __block UITableView *blockPassengersList = passengersList;
    [KVNProgress showWithStatus:NSLocalizedString(@"loading...", nil)];
    
    if (blockSelf.createdRide) {
        [[MasterDataManager sharedMasterDataManager] getPassengersByRouteId:self.routeDetails.ID.stringValue withSuccess:^(NSMutableArray *array) {
            blockSelf.passengers = array;
            [blockPassengersList reloadData];
            [KVNProgress dismiss];
            [blockSelf configureFrames];
        } Failure:^(NSString *error) {
            [blockSelf handleResponseError];
            [blockSelf configureFrames];
            [blockSelf configureActionsButtons];
        }];
    }
}

- (void) refreshInfo{
    __block RideDetailsViewController *blockSelf = self;
    [KVNProgress showWithStatus:NSLocalizedString(@"loading...", nil)];
    
    NSString *routeID;
    NSString *accountID ;
    if (self.driverDetails) {
        routeID = self.driverDetails.RouteId;
        accountID = self.driverDetails.ID;
    }
    else if (self.createdRide){
        routeID = self.createdRide.RouteID.stringValue;
        accountID = [[MobAccountManager sharedMobAccountManager] applicationUserID];
    }
    else if (self.joinedRide){
        routeID = self.joinedRide.RouteID.stringValue;
        accountID = [[MobAccountManager sharedMobAccountManager] applicationUserID];
    }
    
    [[MasterDataManager sharedMasterDataManager] GetRouteByRouteId:routeID withSuccess:^(RouteDetails *routeDetails) {
        blockSelf.routeDetails = routeDetails;
        [blockSelf configurePins];
        [blockSelf focusMapToShowAllMarkers];
        [blockSelf showRideDetailsData];
    } Failure:^(NSString *error) {
        [blockSelf handleResponseError];
        [blockSelf configureFrames];
        [blockSelf configureActionsButtons];
    }];
}

- (UIBarButtonItem *) loadingBarButton{
    if (!_loadingBarButton) {
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [activityIndicatorView startAnimating];
        _loadingBarButton  = [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
    }
    return _loadingBarButton;
}
@end
