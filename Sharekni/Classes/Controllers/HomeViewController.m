//
//  HomeViewController.m
//  sharekni
//
//  Created by ITWORX on 10/28/15.
//
//

#import "HomeViewController.h"
#import "MobAccountManager.h"
#import "User.h"
#import "CreateRideViewController.h"
#import <UIColor+Additions.h>
#import "Constants.h"
#import "SearchViewController.h"
#import "VehiclesViewController.h"
#import "SavedSearchViewController.h"
#import "CreatedRidesViewController.h"
#import "Constants.h"
#import <KVNProgress/KVNProgress.h>
#import "MasterDataManager.h"
#import "NSObject+Blocks.h"
#import "NotificationsViewController.h"
#import "RidesJoinedViewController.h"
#import "PermitsViewController.h"
#import "HistoryViewController.h"
#import "VehiclesViewController.h"
#import "HelpManager.h"
#import "VerifyMobileViewController.h"
#import "UIViewController+MJPopupViewController.h"

@import MobileAppTracker;

@interface HomeViewController () <VerifyMobilePopupDelegate>

#pragma Outlets
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *mobileNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *ridesCreatedLabel;
@property (weak, nonatomic) IBOutlet UILabel *ridesJoinedLabel;
@property (weak, nonatomic) IBOutlet UILabel *vehiclesLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nationalityLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingIcon;
@property (weak, nonatomic) IBOutlet UILabel *notificationCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;


@property (weak, nonatomic) IBOutlet UIImageView *topLeftIcon;
@property (weak, nonatomic) IBOutlet UILabel *topLeftLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLeftIcon;
@property (weak, nonatomic) IBOutlet UILabel *bottomLeftLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topRightIcon;
@property (weak, nonatomic) IBOutlet UILabel *topRightLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bottomRightIcon;
@property (weak, nonatomic) IBOutlet UILabel *bottomRightLabel;

@property (weak, nonatomic) IBOutlet UIView *topLeftView;
@property (weak, nonatomic) IBOutlet UIView *topRightView;
@property (weak, nonatomic) IBOutlet UIView *bottomRightView;
@property (weak, nonatomic) IBOutlet UIView *bottomLeftView;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *driverViews;
@property (weak, nonatomic) IBOutlet UIView *ridesCreatedView;
@property (weak, nonatomic) IBOutlet UIView *ridesJoinedView;

@property (weak, nonatomic) IBOutlet UIView *vehiclesView;

@property (weak, nonatomic) IBOutlet UIImageView *verifiedImgOne;
@property (weak, nonatomic) IBOutlet UIImageView *verifiedImgTwo;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;


@property (nonatomic,strong) User *sharedUser;
@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;

    [Tune measureSession];
    
    [self configureData];
    [self configureUI];
    [self configureActionsUI];
    [self getNotifications];
    
    __block HomeViewController *blockSelf = self;
    [[MobAccountManager sharedMobAccountManager] getCalculatedRatingForAccount:self.sharedUser.ID.stringValue WithSuccess:^(NSString *rating) {
        blockSelf.ratingLabel.text = rating;
    } Failure:^(NSString *error) {
        blockSelf.ratingLabel.text = 0;
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [KVNProgress showWithStatus:NSLocalizedString(@"Loading...", nil)];
    __block HomeViewController *blockSelf = self;
    [[MobAccountManager sharedMobAccountManager] getUser:self.sharedUser.ID.stringValue WithSuccess:^(User *user) {
        blockSelf.sharedUser = user;
        [blockSelf configureUI];
        [KVNProgress dismiss];
    } Failure:^(NSString *error) {
        [KVNProgress dismiss];
    }];
}

#pragma Data
- (void) configureData{
    self.sharedUser = [[MobAccountManager sharedMobAccountManager] applicationUser];
    if(!self.sharedUser){
        //handle open home without user
    }
}
#pragma UI

- (void) configureActionsUI{
    self.topLeftView.backgroundColor = Red_UIColor;
    self.topRightView.backgroundColor = Red_UIColor;
    self.bottomLeftView.backgroundColor = Red_UIColor;
    self.bottomRightView.backgroundColor = Red_UIColor;
    
    if ([self.sharedUser.AccountStatus containsString:@"D"] || [self.sharedUser.AccountStatus containsString:@"B"]) {      //Driver
        self.topLeftIcon.image = [UIImage imageNamed:@"search-icon"];
        self.topLeftLabel.text = NSLocalizedString(@"Search", nil);
        UITapGestureRecognizer *topLeftGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchAction)];
        [self.topLeftView addGestureRecognizer:topLeftGesture];
        
        self.topRightIcon.image = [UIImage imageNamed:@"create-ride"];
        self.topRightLabel.text = NSLocalizedString(@"Create Ride", nil);
        UITapGestureRecognizer *topRightGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(createRideAction)];
        [self.topRightView addGestureRecognizer:topRightGesture];
        
        self.bottomLeftIcon.image = [UIImage imageNamed:@"history"];
        self.bottomLeftLabel.text = NSLocalizedString(@"History", nil);
        UITapGestureRecognizer *bottomLeftGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(historyAction)];
        [self.bottomLeftView addGestureRecognizer:bottomLeftGesture];
        
        self.bottomRightIcon.image = [UIImage imageNamed:@"permit"];
        self.bottomRightLabel.text = NSLocalizedString(@"Permits", nil);
        UITapGestureRecognizer *bottomRightGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(permitAction)];
        [self.bottomRightView addGestureRecognizer:bottomRightGesture];
        
        UITapGestureRecognizer *vechilesGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showVeichles:)];
        [self.vehiclesView addGestureRecognizer:vechilesGesture];
        
        UITapGestureRecognizer *createdRidesGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCreatedRides)];
        [self.ridesCreatedView addGestureRecognizer:createdRidesGesture];
        
        UITapGestureRecognizer *joinedRidesGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showJoinedRides)];
        [self.ridesJoinedView addGestureRecognizer:joinedRidesGesture];
    
    }else{
        //passenger
        self.ridesCreatedView.alpha = 0;
        self.vehiclesView.alpha = 0;
        self.ridesJoinedView.alpha = 0;
        self.topLeftIcon.image = [UIImage imageNamed:@"search-icon"];
        self.topLeftLabel.text = NSLocalizedString(@"Search", nil);
        UITapGestureRecognizer *topLeftGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchAction)];
        [self.topLeftView addGestureRecognizer:topLeftGesture];
        
        self.topRightIcon.image = [UIImage imageNamed:@"RidesJoined_home"];
        self.topRightLabel.text = NSLocalizedString(@"Rides Joined", nil);
        UITapGestureRecognizer *topRightGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showJoinedRides)];
        [self.topRightView addGestureRecognizer:topRightGesture];
        
        self.bottomLeftIcon.image = [UIImage imageNamed:@"history"];
        self.bottomLeftLabel.text = NSLocalizedString(@"History", nil);
        UITapGestureRecognizer *bottomLeftGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(historyAction)];
        [self.bottomLeftView addGestureRecognizer:bottomLeftGesture];
        
        self.bottomRightIcon.image = [UIImage imageNamed:@"SavedSearch_Home"];
        self.bottomRightLabel.text = NSLocalizedString(@"Saved Search", nil);
        UITapGestureRecognizer *bottomRightGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(savedSearchAction)];
        [self.bottomRightView addGestureRecognizer:bottomRightGesture];
    }
}

- (void) configureUI
{
    self.navigationItem.title = NSLocalizedString(@"Home Page", nil);
    self.notificationCountLabel.text = [NSString stringWithFormat:@"%@",self.sharedUser.DriverMyAlertsCount];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",self.sharedUser.FirstName,self.sharedUser.LastName];
    self.nameLabel.text = [self.nameLabel.text capitalizedString];

    self.nationalityLabel.text = (KIS_ARABIC)?self.sharedUser.NationalityArName:self.sharedUser.NationalityEnName;
    
//    if (self.sharedUser.AccountRating) {
//        self.ratingLabel.text = [NSString stringWithFormat:@"%@",self.sharedUser.AccountRating];
//    }else{
//        self.ratingLabel.text = @"0";
//    }
    
    self.emailLabel.text = self.sharedUser.Username;
    self.mobileNumberLabel.text = [NSString stringWithFormat:@"%@",self.sharedUser.Mobile];
    if ([self.sharedUser.IsPhotoVerified boolValue])
    {
        self.verifiedImgOne.hidden = NO ;
    }
    
    if ([self.sharedUser.IsMobileVerified boolValue])
    {
        self.verifiedImgTwo.hidden = NO ;
        self.verifyBtn.hidden = YES ;
    }else{
        self.verifiedImgTwo.hidden = YES ;
        self.verifyBtn.hidden = NO ;
    }
    
    NSString *ridesCreatedText = [NSString stringWithFormat:@"%@ (%@)",NSLocalizedString(@"Rides Created", nil),self.sharedUser.DriverMyRidesCount];
    NSString *ridesJoinedText = [NSString stringWithFormat:@"%@ (%@)",NSLocalizedString(@"Rides Joined", nil),self.sharedUser.PassengerJoinedRidesCount];
    NSString *vehiclesCountText = [NSString stringWithFormat:@"%@ (%@)",NSLocalizedString(@"Vehicles", nil),self.sharedUser.VehiclesCount.stringValue];
    
    
    self.profileImageView.image = self.sharedUser.userImage ? self.sharedUser.userImage : [UIImage imageNamed:@"thumbnail"];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.layer.borderWidth = 0.5f;
    self.profileImageView.clipsToBounds = YES;
    
    
    self.ridesCreatedLabel.text = ridesCreatedText;
    self.ridesJoinedLabel.text = ridesJoinedText;
    self.vehiclesLabel.text = vehiclesCountText;
}

- (IBAction) verfiyMobileAction:(id)sender
{
    [KVNProgress showWithStatus:NSLocalizedString(@"Loading...", nil)];

    [[MobAccountManager sharedMobAccountManager] verifyMobileNumber:[NSString stringWithFormat:@"%@",self.sharedUser.ID] WithSuccess:^(NSString *user)
    {
        [KVNProgress dismiss];

        if ([user containsString:@"1"]) {
            [[HelpManager sharedHelpManager] showAlertWithMessage:NSLocalizedString(@"Mobile verification code has been sent to your mobile", nil)];
            
            VerifyMobileViewController *verifyView = [[VerifyMobileViewController alloc] initWithNibName:@"VerifyMobileViewController" bundle:nil];
            
            verifyView.accountID = [NSString stringWithFormat:@"%@",self.sharedUser.ID] ;
            verifyView.delegate = self;
            [self presentPopupViewController:verifyView animationType:MJPopupViewAnimationSlideBottomBottom];
            
        }else{
            [[HelpManager sharedHelpManager] showAlertWithMessage:NSLocalizedString(@"Please check your mobile number", nil)];
        }
    } Failure:^(NSString *error) {
        [KVNProgress dismiss];
    }];
}

- (void)dismissButtonClicked:(VerifyMobileViewController *)verifyMobileNumber
{
    self.verifiedImgTwo.hidden = NO ;
    self.verifyBtn.hidden = YES ;
}

- (void) configureNavigationBar{
    
}

#pragma Gestures & Actions
- (void) searchAction{
    SearchViewController *searchView = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    searchView.enableBackButton = YES;
    [self.navigationController pushViewController:searchView animated:YES];
}

- (void) createRideAction{
    CreateRideViewController *createRideViewController = [[CreateRideViewController alloc] initWithNibName:@"CreateRideViewController" bundle:nil];
    [self.navigationController pushViewController:createRideViewController animated:YES];
}

- (void) historyAction{

    if ([[[[MobAccountManager sharedMobAccountManager] applicationUser] AccountStatus] isEqualToString:@"P"]) {
        RidesJoinedViewController *joinedRidesViewController =  [[RidesJoinedViewController alloc] initWithNibName:@"RidesJoinedViewController" bundle:nil];
        joinedRidesViewController.title =  NSLocalizedString(@"History", nil);
        [self.navigationController pushViewController:joinedRidesViewController animated:YES];
    }
    else{
        HistoryViewController *historyView = [[HistoryViewController alloc] initWithNibName:@"HistoryViewController" bundle:nil];
        [self.navigationController pushViewController:historyView animated:YES];
    }
}

- (void) permitAction{
    PermitsViewController *permitsView = [[PermitsViewController alloc] initWithNibName:@"PermitsViewController" bundle:nil];
    [self.navigationController pushViewController:permitsView animated:YES];
}

- (void) savedSearchAction{
    SavedSearchViewController *savedSearchViewController = [[SavedSearchViewController alloc] initWithNibName:@"SavedSearchViewController" bundle:nil];
    savedSearchViewController.enableBackButton = YES;
    [self.navigationController pushViewController:savedSearchViewController animated:YES];
}

- (IBAction) editAction:(id)sender {
    
}

- (IBAction) openNotifications:(id)sender{
    NotificationsViewController *notificationsView = [[NotificationsViewController alloc] initWithNibName:@"NotificationsViewController" bundle:nil];
    notificationsView.enableBackButton = YES;
    [self.navigationController pushViewController:notificationsView animated:YES];
}

- (void) getNotifications{
    User *user = [[MobAccountManager sharedMobAccountManager] applicationUser];
    
    __block HomeViewController *blockSelf = self;
    [KVNProgress showWithStatus:NSLocalizedString(@"loading", nil)];
    
    [[MasterDataManager sharedMasterDataManager] getRequestNotifications:[NSString stringWithFormat:@"%@",user.ID] isDriver:YES WithSuccess:^(NSMutableArray *array) {
        
        self.notificationCountLabel.text = [NSString stringWithFormat:@"%d",(unsigned int)array.count];
       
        [self getAcceptedNotifications];
        
        [KVNProgress dismiss];
        
    } Failure:^(NSString *error) {
        NSLog(@"Error in Notifications");
        [KVNProgress dismiss];
        [KVNProgress showErrorWithStatus:@"Error"];
        [blockSelf performBlock:^{
            [KVNProgress dismiss];
        } afterDelay:3];
    }];
}

- (void) getAcceptedNotifications{
    User *user = [[MobAccountManager sharedMobAccountManager] applicationUser];
    
    __block HomeViewController *blockSelf = self;
    [KVNProgress showWithStatus:NSLocalizedString(@"loading", nil)];
    
    [[MasterDataManager sharedMasterDataManager] getRequestNotifications:[NSString stringWithFormat:@"%@",user.ID] isDriver:NO WithSuccess:^(NSMutableArray *array) {
        
        self.notificationCountLabel.text = [NSString stringWithFormat:@"%d",(unsigned int)array.count];
        
        [KVNProgress dismiss];
        
    } Failure:^(NSString *error) {
        NSLog(@"Error in Notifications");
        [KVNProgress dismiss];
        [KVNProgress showErrorWithStatus:@"Error"];
        [blockSelf performBlock:^{
            [KVNProgress dismiss];
        } afterDelay:3];
    }];
}

- (void) showVeichles:(id)sender{
        VehiclesViewController *registerVehicle = [[VehiclesViewController alloc] initWithNibName:@"VehiclesViewController" bundle:nil];
    registerVehicle.enableBackButton = YES;
        [self.navigationController pushViewController:registerVehicle animated:YES];
}

- (void) showCreatedRides{
    CreatedRidesViewController *createdRideViewController = [[CreatedRidesViewController alloc] initWithNibName:@"CreatedRidesViewController" bundle:nil];
    [self.navigationController pushViewController:createdRideViewController animated:YES];
}

- (void) showJoinedRides{
    RidesJoinedViewController *joinedRidesViewController =  [[RidesJoinedViewController alloc] initWithNibName:@"RidesJoinedViewController" bundle:nil];
    [self.navigationController pushViewController:joinedRidesViewController animated:YES];
}

@end
