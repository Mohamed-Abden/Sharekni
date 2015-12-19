//
//  CreateRideViewController.m
//  sharekni
//
//  Created by Mohamed Abd El-latef on 10/24/15.
//
//20027

#import "CreateRideViewController.h"
#import "MasterDataManager.h"
#import <RMActionController.h>
#import <RMDateSelectionViewController.h>
#import <NSDate+Components.h>
#import <NSDate+Time.h>
#import <UIColor+Additions.h>
#import "Constants.h"
#import "MasterDataManager.h"
#import <KVNProgress/KVNProgress.h>
#import "NSObject+Blocks.h"
#import <RMPickerViewController.h>
#import "AgeRange.h"
#import "Language.h"
#import "Nationality.h"
#import <KLCPopup/KLCPopup.h>
#import "PickupLocationView.h"
#import <MZFormSheetController.h>
#import "SelectLocationViewController.h"
#import "MobDriverManager.h"
#import "HelpManager.h"
#import "UIView+Borders.h"
#import "MobVehicleManager.h"
#import "Vehicle.h"
#import "MasterDataManager.h"
#import "MobDriverManager.h"
#import "MLPAutoCompleteTextField.h"
@interface CreateRideViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,MLPAutoCompleteTextFieldDataSource,MLPAutoCompleteTextFieldDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *seat4ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *seat3ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *seat2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *seat1ImageView;
@property (weak, nonatomic) IBOutlet UIView *emiratesAndRegionsView;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectAgeRangeButton;
@property (weak, nonatomic) IBOutlet UIButton *selectLanguageButton;
@property (weak, nonatomic) IBOutlet UIButton *selectVehicleButton;
@property (weak, nonatomic) IBOutlet UIButton *setDirectionButton;
@property (weak, nonatomic) IBOutlet UILabel *rideDetailsSectionLabel;
@property (weak, nonatomic) IBOutlet UIView *rideDetailsView;
@property (weak, nonatomic) IBOutlet UIView *optionsView;
@property (weak, nonatomic) IBOutlet UILabel *optionalSectionLabel;
@property (weak, nonatomic) IBOutlet UITextField *rideNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *startPointLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *periodicLabel;
@property (weak, nonatomic) IBOutlet UIImageView *switchImageView;
@property (weak, nonatomic) IBOutlet UILabel *singleRideLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *availableSeatsLabel;

@property (weak, nonatomic) IBOutlet UIView *timeView;

@property (weak, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet MLPAutoCompleteTextField *nationalityTextField;
@property (weak, nonatomic) IBOutlet UIView *typeView;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UIView *genderView;
@property (nonatomic,assign) float animatedDistance ;

@property (weak, nonatomic) IBOutlet UILabel *satLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunLabel;
@property (weak, nonatomic) IBOutlet UILabel *monLabel;
@property (weak, nonatomic) IBOutlet UILabel *tueLabel;
@property (weak, nonatomic) IBOutlet UILabel *wedLabel;
@property (weak, nonatomic) IBOutlet UILabel *thrLabel;
@property (weak, nonatomic) IBOutlet UILabel *friLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysOfWeek;

@property (strong, nonatomic)  NSDateFormatter *dateFormatter;
@property (assign, nonatomic)  RoadType selectedType;
@property (assign, nonatomic)  BOOL isFemaleOnly;
@property (strong,nonatomic)   NSDate *pickupDate;
@property (strong,nonatomic)   NSDate *pickupTime;

@property (strong,nonatomic) NSArray *nationalties;
@property (nonatomic,strong) NSMutableArray *nationaltiesStringsArray;
@property (strong,nonatomic) NSArray *languages;
@property (strong,nonatomic) NSArray *ageRanges;
@property (strong,nonatomic) NSArray *vehicles;

@property (strong,nonatomic) AgeRange *selectedAgeRange;
@property (strong,nonatomic) Nationality *selectedNationality;
@property (strong,nonatomic) Language *selectedLanguage;
@property (strong,nonatomic) Vehicle *selectedVehicle;

@property (strong,nonatomic) Emirate *fromEmirate;
@property (strong,nonatomic) Emirate *toEmirate;

@property (strong,nonatomic) Region *fromRegion;
@property (strong,nonatomic) Region *toRegion;

@property (assign,nonatomic) BOOL isEdit;

@property (assign,nonatomic) BOOL seat1Active;
@property (assign,nonatomic) BOOL seat2Active;
@property (assign,nonatomic) BOOL seat3Active;
@property (assign,nonatomic) BOOL seat4Active;


@property (assign,nonatomic) BOOL satActive;
@property (assign,nonatomic) BOOL sunActive;
@property (assign,nonatomic) BOOL monActive;
@property (assign,nonatomic) BOOL tueActive;
@property (assign,nonatomic) BOOL wedActive;
@property (assign,nonatomic) BOOL thrActive;
@property (assign,nonatomic) BOOL friActive;
@property (assign, nonatomic) NSInteger noOfSeats;


@property (weak ,nonatomic) IBOutlet UIButton *bothBtn ;
@property (weak ,nonatomic) IBOutlet UIButton *maleBtn ;
@property (weak ,nonatomic) IBOutlet UIButton *femaleBtn ;

@property (weak ,nonatomic) IBOutlet UIButton *acceptBtn ;
@property (weak ,nonatomic) IBOutlet UIButton *notAcceptBtn ;


@end

@implementation CreateRideViewController

-(NSDateFormatter *)dateFormatter{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.isEdit = (self.ride != nil) || (self.routeDetails !=nil);

    [self configureUI];
    [self configureSeats];
    [self configureDaysLabels];
    [self configureData];
    [self configureRoadTypeView];
    [self configureGenderView];
}

- (void) configureEditMode{
    
    //Emirates and regions view
    
    if (self.routeDetails) {
        [KVNProgress dismiss];
        self.helpLabel.alpha = 0;
        self.emiratesAndRegionsView.alpha = 1;
        
        NSString *fromText = [NSString stringWithFormat:@"%@,%@",(KIS_ARABIC)?self.routeDetails.FromEmirateArName:self.routeDetails.FromEmirateEnName,(KIS_ARABIC)?self.routeDetails.FromRegionArName:self.routeDetails.FromRegionEnName];
        
        self.startPointLabel.text = fromText;
        
        NSString *toText = [NSString stringWithFormat:@"%@,%@",(KIS_ARABIC)?self.routeDetails.ToEmirateArName:self.routeDetails.ToEmirateEnName,(KIS_ARABIC)?self.routeDetails.ToRegionArName:self.routeDetails.ToRegionEnName];
        self.destinationLabel.text = toText;
        [self configureUIWithRouteDetails];
    }
    else{
        self.helpLabel.alpha = 0;
        self.emiratesAndRegionsView.alpha = 1;
        NSString *fromText = [NSString stringWithFormat:@"%@,%@",(KIS_ARABIC)?self.ride.FromEmirateArName:self.ride.FromEmirateEnName,(KIS_ARABIC)?self.ride.FromRegionArName:self.ride.FromRegionEnName];
        
        self.startPointLabel.text = fromText;
        
        NSString *toText = [NSString stringWithFormat:@"%@,%@",(KIS_ARABIC)?self.ride.ToEmirateArName:self.ride.ToEmirateEnName,(KIS_ARABIC)?self.ride.ToRegionArName:self.ride.ToRegionEnName];
        self.destinationLabel.text = toText;
        
        __block CreateRideViewController *blockSelf = self;
        [KVNProgress showWithStatus:GET_STRING(@"Loading...")];
        [[MasterDataManager sharedMasterDataManager] GetRouteByRouteId:self.ride.RouteID.stringValue withSuccess:^(RouteDetails *routeDetails_) {
            [KVNProgress dismiss];
            blockSelf.routeDetails = routeDetails_;
            [blockSelf configureUIWithRouteDetails];
        } Failure:^(NSString *error) {
            [KVNProgress dismiss];
            [blockSelf handleManagerFailure];
        }];
    }
}

- (void) configureUIWithRouteDetails{
    
    //Ride Name
    self.rideNameTextField.text = self.routeDetails.RouteEnName;
    
    //RoadType
    self.selectedType = self.routeDetails.IsRounded.boolValue ? PeriodicType : SingleRideType;
    [self configureRoadTypeView];
    

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //Start Date
    dateFormatter.dateFormat = @"dd/MM/yyyy";
    NSDate *startDate = [dateFormatter dateFromString:self.routeDetails.StartDate];
    
    dateFormatter.dateFormat = @"dd/MM/yyyy";
    NSString *dateString = [dateFormatter stringFromDate:startDate];
    self.dateLabel.text  = dateString;
    
    //Start Time
//    if ([self.routeDetails.StartFromTime containsString:@"AM"]) {
//        self.routeDetails.StartFromTime = [self.routeDetails.StartFromTime stringByReplacingOccurrencesOfString:@"AM" withString:@" AM"];
//    }
//    else if ([self.routeDetails.StartFromTime containsString:@"PM"]) {
//        self.routeDetails.StartFromTime = [self.routeDetails.StartFromTime stringByReplacingOccurrencesOfString:@"PM" withString:@" PM"];
//    }
//    
//    dateFormatter.dateFormat = @"MMM dd yyy hh:mm a";
//    NSDate *startTime = [dateFormatter dateFromString:self.routeDetails.StartFromTime];
//    
//
//    dateFormatter.dateFormat = @"hh:mm a";
    NSString *timeString = self.routeDetails.StartFromTime;
    dateFormatter.dateFormat = @"hh:mm a";
    NSDate *startTime = [dateFormatter dateFromString:timeString];
    self.pickupTime = startTime;
    
    self.pickupDate = startDate;
    self.pickupDate = [self.pickupDate dateByAddingHour:startTime.hour];
    self.pickupDate = [self.pickupDate dateByAddingMinute:startTime.minute];
    
    self.timeLabel.text = timeString;
    
    //Vehicle
    if (self.vehicles && (self.ride || self.routeDetails)) {
        NSNumber *ID = self.routeDetails.VehicelId;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ID == %ld",ID.integerValue];
        NSArray *result = [self.vehicles filteredArrayUsingPredicate:predicate];
        self.selectedVehicle = result.count > 0 ? result[0]:nil;
        if (self.selectedVehicle) {
            [self.selectVehicleButton setTitle:(KIS_ARABIC)?self.selectedVehicle.ModelArName:self.selectedVehicle.ModelEnName forState:UIControlStateNormal];
        }
        else{
        [self.selectVehicleButton setTitle:GET_STRING(@"Select vehicle")  forState:UIControlStateNormal];
        }
    }
    else{
        self.selectedVehicle = nil;
        [self.selectVehicleButton setTitle:GET_STRING(@"Select vehicle") forState:UIControlStateNormal];
    }
    
    //no of seats
    self.noOfSeats = self.routeDetails.NoOfSeats.integerValue;
    switch (self.noOfSeats) {
        case 1:
            self.seat1Active = YES;
            self.seat2Active = NO;
            self.seat3Active = NO;
            self.seat4Active = NO;
            [self.seat1ImageView setImage:[UIImage imageNamed:@"SeatActive"]];
            
            
            break;
        case 2:
            self.seat1Active = YES;
            self.seat2Active = YES;
            self.seat3Active = NO;
            self.seat4Active = NO;
            [self.seat1ImageView setImage:[UIImage imageNamed:@"SeatActive"]];
            [self.seat2ImageView setImage:[UIImage imageNamed:@"SeatActive"]];
            
            break;
        case 3:
            self.seat1Active = YES;
            self.seat2Active = YES;
            self.seat3Active = YES;
            self.seat4Active = NO;
            [self.seat1ImageView setImage:[UIImage imageNamed:@"SeatActive"]];
            [self.seat2ImageView setImage:[UIImage imageNamed:@"SeatActive"]];
            [self.seat3ImageView setImage:[UIImage imageNamed:@"SeatActive"]];
            
            break;
        case 4:
            self.seat1Active = YES;
            self.seat2Active = YES;
            self.seat3Active = YES;
            self.seat4Active = YES;
            [self.seat1ImageView setImage:[UIImage imageNamed:@"SeatActive"]];
            [self.seat2ImageView setImage:[UIImage imageNamed:@"SeatActive"]];
            [self.seat3ImageView setImage:[UIImage imageNamed:@"SeatActive"]];
            [self.seat4ImageView setImage:[UIImage imageNamed:@"SeatActive"]];
            
            break;
            
        default:
            break;
    }
    
    
    //language
    NSNumber *languageID = self.routeDetails.PrefLanguageId;
    if (languageID.integerValue != 0 &&self.languages.count > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"LanguageId ==%d",languageID.integerValue];
        NSArray *result = [self.languages filteredArrayUsingPredicate:predicate];
        self.selectedLanguage = result.count > 0 ? result[0]:nil;
        [self.selectLanguageButton setTitle:(KIS_ARABIC)?self.selectedLanguage.LanguageArName:self.selectedLanguage.LanguageEnName forState:UIControlStateNormal];
    }
    else{
        self.selectedLanguage = nil;
    }
    
    //Age Range
    NSString  *RangeID = self.routeDetails.AgeRangeID;
    if (RangeID.integerValue != 0 &&self.ageRanges.count > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"RangeId ==%d",RangeID.integerValue];
        NSArray *result = [self.ageRanges filteredArrayUsingPredicate:predicate];
        self.selectedAgeRange = result.count > 0 ? result[0]:nil;
        [self.selectAgeRangeButton setTitle:self.selectedAgeRange.Range forState:UIControlStateNormal];
    }
    else{
        self.selectedAgeRange = nil;
    }
    
    //Nationality
    NSNumber *nationalityID = self.routeDetails.NationalityId;
    if (nationalityID.integerValue != 0 &&self.nationalties.count > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ID ==%d",nationalityID.integerValue];
        NSArray *result = [self.nationalties filteredArrayUsingPredicate:predicate];
        self.selectedNationality = result.count > 0 ? result[0]:nil;;
        [self.nationalityTextField setText:(KIS_ARABIC)?self.selectedNationality.NationalityArName:self.selectedNationality.NationalityEnName];
    }
    else{
        self.selectedNationality = nil;
    }
    
    //Gender
    self.isFemaleOnly = NO;
    [self configureGenderView];
    
    //Days Of Week
    [self configureDaysLabels];
    
    [self.createButton setTitle:GET_STRING(@"Edit Ride") forState:UIControlStateNormal];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

#pragma SEATS

- (void) configureSeats{
    self.seat1Active = NO;
    self.seat2Active = NO;
    self.seat3Active = NO;
    self.seat4Active = NO;
    UITapGestureRecognizer *seat1Gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seat1GestureHandler)];
    [self.seat1ImageView addGestureRecognizer:seat1Gesture];
    
    UITapGestureRecognizer *seat2Gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seat2GestureHandler)];
    [self.seat2ImageView addGestureRecognizer:seat2Gesture];
    
    UITapGestureRecognizer *seat3Gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seat3GestureHandler)];
    [self.seat3ImageView addGestureRecognizer:seat3Gesture];
    
    UITapGestureRecognizer *seat4Gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seat4GestureHandler)];
    [self.seat4ImageView addGestureRecognizer:seat4Gesture];
}

- (void) seat1GestureHandler{
    self.seat1Active = !self.seat1Active;
    if(self.seat1Active){
        [self.seat1ImageView setImage:[UIImage imageNamed:@"SeatActive"]];
        self.noOfSeats ++;
    }
    else{
        [self.seat1ImageView setImage:[UIImage imageNamed:@"Seat"]];
        self.noOfSeats --;
    }
}

- (void) seat2GestureHandler{
    self.seat2Active = !self.seat2Active;
    if(self.seat2Active){
        [self.seat2ImageView setImage:[UIImage imageNamed:@"SeatActive"]];
        self.noOfSeats ++;
    }
    else{
        [self.seat2ImageView setImage:[UIImage imageNamed:@"Seat"]];
        self.noOfSeats --;
    }
}

- (void) seat3GestureHandler{
    self.seat3Active = !self.seat3Active;
    if(self.seat3Active){
        [self.seat3ImageView setImage:[UIImage imageNamed:@"SeatActive"]];
        self.noOfSeats ++;
    }
    else{
        [self.seat3ImageView setImage:[UIImage imageNamed:@"Seat"]];
        self.noOfSeats --;
    }
    
}

- (void) seat4GestureHandler{
    self.seat4Active = !self.seat4Active;
    if(self.seat4Active){
        [self.seat4ImageView setImage:[UIImage imageNamed:@"SeatActive"]];
        self.noOfSeats ++;
    }
    else{
        [self.seat4ImageView setImage:[UIImage imageNamed:@"Seat"]];
        self.noOfSeats --;
    }
}

#pragma ACTIONS
- (IBAction) selectVehilceAction:(id)sender {
    if(self.vehicles.count == 0){
        [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"Please configure your vehicles first")];
    }
    else{
        [self showPickerWithTextFieldType:VehiclesTextField];
    }
}

- (IBAction) setDirectionAction:(id)sender {
    if(self.isEdit){
        [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"Directions can't be edited.")];
    }
    else{
        [self showLocationPicker];
    }
}

- (IBAction) selectLanguageAction:(id)sender {
    [self showPickerWithTextFieldType:LanguageTextField];
}

- (IBAction) selectAgeRangeAction:(id)sender {
    [self showPickerWithTextFieldType:AgeRangeTextField];
}

#pragma DAYSOFWEEK
- (void) configureDaysLabels
{
    if (self.isEdit)
    {
        self.satActive = self.routeDetails.Saturday.boolValue;
        self.sunActive = self.routeDetails.Sunday.boolValue;
        self.monActive = self.routeDetails.Monday.boolValue;
        self.tueActive = self.routeDetails.Tuesday.boolValue;
        self.wedActive = self.routeDetails.Wendenday.boolValue;
        self.thrActive = self.routeDetails.Thrursday.boolValue;
        self.friActive = self.routeDetails.Friday.boolValue;
        
        if ([self.routeDetails.IsSmoking intValue] == 1) {
            self.acceptBtn.selected = YES;
        }else{
            self.acceptBtn.selected = NO ;
        }
        
        if ([self.routeDetails.IsSmoking intValue] == 0) {
            self.notAcceptBtn.selected = YES;
        }else{
            self.notAcceptBtn.selected = NO ;
        }
        
        if ([self.routeDetails.PreferredGender isEqualToString:@"Male"]) {
            self.maleBtn.selected = YES ;
        }else if ([self.routeDetails.PreferredGender isEqualToString:@"Female"]){
            self.femaleBtn.selected = YES ;
        }else if ([self.routeDetails.PreferredGender isEqualToString:@"Both"])
        {
            self.bothBtn.selected = YES ;
        }
        
    }
    else
    {
        self.satActive = NO;
        self.sunActive = NO;
        self.monActive = NO;
        self.tueActive = NO;
        self.wedActive = NO;
        self.thrActive = NO;
        self.friActive = NO;
    }
    self.daysOfWeek.textColor = Red_UIColor;
    self.daysOfWeek.text = GET_STRING(@"Days Of Week");
    self.daysOfWeek.backgroundColor   = [UIColor whiteColor];
    
    
    UITapGestureRecognizer *satGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(satTapped)];
    self.satLabel.layer.cornerRadius = self.satLabel.frame.size.width/2;
    self.satLabel.clipsToBounds = YES;
    self.satLabel.layer.borderWidth = .4;
    [self.satLabel addGestureRecognizer:satGesture];
    
    if(self.satActive){
        self.satLabel.layer.borderColor = Red_UIColor.CGColor;
        self.satLabel.backgroundColor = Red_UIColor;
        self.satLabel.textColor = [UIColor whiteColor];
    }
    else{
        self.satLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.satLabel.backgroundColor = [UIColor lightGrayColor];
        self.satLabel.textColor = [UIColor whiteColor];
    }
    
    UITapGestureRecognizer *sunGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sunTapped)];
    self.sunLabel.layer.cornerRadius = self.sunLabel.frame.size.width/2;
    self.sunLabel.clipsToBounds = YES;
    self.sunLabel.layer.borderWidth = .4;
    [self.sunLabel addGestureRecognizer:sunGesture];
    
    if(self.sunActive){
        self.sunLabel.backgroundColor = Red_UIColor;
        self.sunLabel.layer.borderColor = Red_UIColor.CGColor;
        self.sunLabel.textColor = [UIColor whiteColor];
    }
    else{
        self.sunLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.sunLabel.backgroundColor = [UIColor lightGrayColor];
        self.sunLabel.textColor = [UIColor whiteColor];
    }
    
    UITapGestureRecognizer *monGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(monTapped)];
    self.monLabel.layer.cornerRadius = self.monLabel.frame.size.width/2;
    self.monLabel.clipsToBounds = YES;
    self.monLabel.layer.borderWidth = .4;

    [self.monLabel addGestureRecognizer:monGesture];
    
    if(self.monActive){
        self.monLabel.backgroundColor = Red_UIColor;
        self.monLabel.layer.borderColor = Red_UIColor.CGColor;
        self.monLabel.textColor = [UIColor whiteColor];
    }
    else{
        self.monLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.monLabel.backgroundColor = [UIColor lightGrayColor];
        self.monLabel.textColor = [UIColor whiteColor];
    }
    
    UITapGestureRecognizer *tueGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tueTapped)];
    self.tueLabel.layer.cornerRadius = self.tueLabel.frame.size.width/2;
    self.tueLabel.clipsToBounds = YES;
    self.tueLabel.layer.borderWidth = .4;
    [self.tueLabel addGestureRecognizer:tueGesture];
    
    if(self.tueActive){
        self.tueLabel.backgroundColor = Red_UIColor;
        self.tueLabel.layer.borderColor = Red_UIColor.CGColor;
        self.tueLabel.textColor = [UIColor whiteColor];
    }
    else{
        self.tueLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.tueLabel.backgroundColor = [UIColor lightGrayColor];
        self.tueLabel.textColor = [UIColor whiteColor];
    }
    
    UITapGestureRecognizer *wedGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wedTapped)];
    self.wedLabel.layer.cornerRadius = self.wedLabel.frame.size.width/2;
    self.wedLabel.clipsToBounds = YES;
    self.wedLabel.layer.borderWidth = .4;
    [self.wedLabel addGestureRecognizer:wedGesture];
    
    if(self.wedActive){
        self.wedLabel.backgroundColor = Red_UIColor;
        self.wedLabel.layer.borderColor = Red_UIColor.CGColor;
        self.wedLabel.textColor = [UIColor whiteColor];
    }
    else{
        self.wedLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.wedLabel.backgroundColor = [UIColor lightGrayColor];
        self.wedLabel.textColor = [UIColor whiteColor];
    }
    
    UITapGestureRecognizer *thrGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thrTapped)];
    self.thrLabel.layer.cornerRadius = self.thrLabel.frame.size.width/2;
    self.thrLabel.clipsToBounds = YES;
    self.thrLabel.layer.borderWidth = .4;
    [self.thrLabel addGestureRecognizer:thrGesture];
    
    if(self.thrActive){
        self.thrLabel.backgroundColor = Red_UIColor;
        self.thrLabel.layer.borderColor = Red_UIColor.CGColor;
        self.thrLabel.textColor = [UIColor whiteColor];
    }
    else{
        self.thrLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.thrLabel.backgroundColor = [UIColor lightGrayColor];
        self.thrLabel.textColor = [UIColor whiteColor];
    }
    
    UITapGestureRecognizer *friGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(friTapped)];
    self.friLabel.layer.cornerRadius = self.friLabel.frame.size.width/2;
    self.friLabel.clipsToBounds = YES;
    self.friLabel.layer.borderWidth = .4;
    [self.friLabel addGestureRecognizer:friGesture];
    
    if(self.friActive){
        self.friLabel.backgroundColor = Red_UIColor;
        self.friLabel.layer.borderColor = Red_UIColor.CGColor;
        self.friLabel.textColor = [UIColor whiteColor];
    }
    else{
        self.friLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.friLabel.backgroundColor = [UIColor lightGrayColor];
        self.friLabel.textColor = [UIColor whiteColor];
    }
}

- (void) satTapped{
    self.satActive =  !self.satActive;
    if(self.satActive){
        self.satLabel.backgroundColor = Red_UIColor;
        self.satLabel.textColor = [UIColor whiteColor];
    }
    else{
        self.satLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.satLabel.backgroundColor = [UIColor lightGrayColor];
        self.satLabel.textColor = [UIColor whiteColor];;
    }
}
- (void) sunTapped{
    self.sunActive = !self.sunActive;
    if(self.sunActive){
        self.sunLabel.backgroundColor = Red_UIColor;
        self.sunLabel.textColor = [UIColor whiteColor];
    }
    else{
        self.sunLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.sunLabel.backgroundColor = [UIColor lightGrayColor];
        self.sunLabel.textColor = [UIColor whiteColor];
    }
}
- (void) monTapped{
    self.monActive = !self.monActive;
    if(self.monActive){
        self.monLabel.backgroundColor = Red_UIColor;
        self.monLabel.textColor = [UIColor whiteColor];
    }
    else{
        self.monLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.monLabel.backgroundColor = [UIColor lightGrayColor];
        self.monLabel.textColor = [UIColor whiteColor];
    }
}
- (void) tueTapped{
    self.tueActive = !self.tueActive;
    if(self.tueActive){
        self.tueLabel.backgroundColor = Red_UIColor;
        self.tueLabel.textColor = [UIColor whiteColor];
    }
    else{
        self.tueLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.tueLabel.backgroundColor = [UIColor lightGrayColor];
        self.tueLabel.textColor = [UIColor whiteColor];
    }
}
- (void) wedTapped{
    self.wedActive = !self.wedActive;
    if(self.wedActive){
        self.wedLabel.backgroundColor = Red_UIColor;
        self.wedLabel.textColor = [UIColor whiteColor];
    }
    else{
        self.wedLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.wedLabel.backgroundColor = [UIColor lightGrayColor];
        self.wedLabel.textColor = [UIColor whiteColor];
    }
}
- (void) thrTapped{
    self.thrActive = !self.thrActive;
    if(self.thrActive){
        self.thrLabel.backgroundColor = Red_UIColor;
        self.thrLabel.textColor = [UIColor whiteColor];
    }
    else{
        self.thrLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.thrLabel.backgroundColor = [UIColor lightGrayColor];
        self.thrLabel.textColor = [UIColor whiteColor];
    }
}
- (void) friTapped{
    self.friActive = !self.friActive;
    if(self.friActive){
        self.friLabel.backgroundColor = Red_UIColor;
        self.friLabel.textColor = [UIColor whiteColor];
    }
    else{
        self.friLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.friLabel.backgroundColor = [UIColor lightGrayColor];
        self.friLabel.textColor = [UIColor whiteColor];
    }
}

#pragma Data
- (void) configureData{
    __block CreateRideViewController *blockSelf = self;
    [KVNProgress showWithStatus:GET_STRING(@"loading")];
    [[MasterDataManager sharedMasterDataManager] getSavedVehicleById:nil WithSuccess:^(NSMutableArray *array) {
        blockSelf.vehicles = array;
        [[MasterDataManager sharedMasterDataManager] GetNationalitiesByID:@"0" WithSuccess:^(NSMutableArray *array) {
            blockSelf.nationalties = array;
            blockSelf.nationaltiesStringsArray = [NSMutableArray array];
            for (Nationality *nationality in blockSelf.nationalties) {
                [blockSelf.nationaltiesStringsArray addObject:(KIS_ARABIC)?nationality.NationalityArName:nationality.NationalityEnName];
            }
            [[MasterDataManager sharedMasterDataManager] GetAgeRangesWithSuccess:^(NSMutableArray *array) {
                blockSelf.ageRanges = array;
                [[MasterDataManager sharedMasterDataManager] GetPrefferedLanguagesWithSuccess:^(NSMutableArray *array) {
                    blockSelf.languages = array;
                    if (blockSelf.isEdit || self.routeDetails) {
                        [blockSelf configureEditMode];
                    }
                    else{
                        blockSelf.noOfSeats = 0;
                        [KVNProgress dismiss];
                    }
                } Failure:^(NSString *error) {
                    [blockSelf handleManagerFailure];
                }];
            } Failure:^(NSString *error) {
                [blockSelf handleManagerFailure];
            }];
        } Failure:^(NSString *error) {
            [blockSelf handleManagerFailure];
        }];
    } Failure:^(NSString *error) {
            [blockSelf handleManagerFailure];        
    }];
}

- (void) handleManagerFailure{
    [KVNProgress dismiss];
    [KVNProgress showErrorWithStatus:@"Error"];
    [self performBlock:^{
        [KVNProgress dismiss];
    } afterDelay:3];
}

#pragma UI

- (void) configureUI
{
    self.title = GET_STRING(@"Create Ride");
    
    UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(0, 0, 22, 22);
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"Back_icn"] forState:UIControlStateNormal];
    [_backBtn setHighlighted:NO];
    [_backBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
    
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.scrollView.frame.size.height)];
    self.selectedType = SingleRideType;
    self.isFemaleOnly = false;

    
    self.dateView.layer.cornerRadius = 10;
    self.dateView.layer.masksToBounds = YES;
    
    self.timeView.layer.cornerRadius = 10;
    self.timeView.layer.masksToBounds = YES;
    
    self.createButton.layer.cornerRadius = 8;
    
    [self.selectVehicleButton setTitleColor:Red_UIColor forState:UIControlStateNormal];
    [self.selectVehicleButton setBackgroundColor:[UIColor whiteColor]];
    
    [self.selectLanguageButton setTitleColor:Red_UIColor forState:UIControlStateNormal];
    [self.selectLanguageButton setBackgroundColor:[UIColor whiteColor]];
    
    [self.selectAgeRangeButton setTitleColor:Red_UIColor forState:UIControlStateNormal];
    [self.selectAgeRangeButton setBackgroundColor:[UIColor whiteColor]];
    
    self.nationalityTextField.textColor             = Red_UIColor;
    self.destinationLabel.textColor                 = Red_UIColor;
    self.startPointLabel.textColor                  = Red_UIColor;

    self.rideDetailsSectionLabel.textColor          = Red_UIColor;
    self.optionalSectionLabel.textColor             = Red_UIColor;
    
    [self.rideDetailsSectionLabel addRightBorderWithColor:Red_UIColor];
    [self.rideDetailsSectionLabel addLeftBorderWithColor:Red_UIColor];
    [self.optionalSectionLabel addRightBorderWithColor:Red_UIColor];
    [self.optionalSectionLabel addLeftBorderWithColor:Red_UIColor];
    
    UITapGestureRecognizer *dateTapGestureRecognizer  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDatePicker)];
    [self.dateView addGestureRecognizer:dateTapGestureRecognizer];
    
    UITapGestureRecognizer *TimeTapGestureRecognizer  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTimePicker)];
    [self.timeView addGestureRecognizer:TimeTapGestureRecognizer];
    
    UITapGestureRecognizer *typeGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(typeChangedHandler)];
    self.typeView.userInteractionEnabled = YES;
    [self.typeView addGestureRecognizer:typeGestureRecognizer];
    
    UITapGestureRecognizer *genderGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(genderChangedHandler)];
    self.genderView.userInteractionEnabled = YES;
    [self.genderView addGestureRecognizer:genderGestureRecognizer];
    
    UITapGestureRecognizer *dismissGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissHandler)];
    [self.view addGestureRecognizer:dismissGestureRecognizer];
    
    self.rideDetailsView.layer.cornerRadius = 20;
    self.rideDetailsView.backgroundColor = [UIColor clearColor];
    self.rideDetailsView.layer.borderColor = Red_UIColor.CGColor;
    self.rideDetailsView.layer.borderWidth = 1.0f;

    self.optionsView.layer.cornerRadius = 20;
    self.optionsView.backgroundColor = [UIColor clearColor];
    self.optionsView.layer.borderColor = Red_UIColor.CGColor;
    self.optionsView.layer.borderWidth = 1.0f;
    
    if(self.isEdit){
        self.helpLabel.alpha = 0;
        self.emiratesAndRegionsView.alpha = 1;
    }
    else {
        self.helpLabel.alpha = 1;
        self.emiratesAndRegionsView.alpha = 0;
    }
    [self configrueNationalityAutoCompelete];
}

- (void) configrueNationalityAutoCompelete{
    self.nationalityTextField.delegate = self;
    self.nationalityTextField.autoCompleteDataSource = self;
    self.nationalityTextField.autoCompleteDelegate = self;
    self.nationalityTextField.autoCompleteTableBorderColor = Red_UIColor;
    self.nationalityTextField.autoCompleteTableBorderWidth = 2;
    self.nationalityTextField.autoCompleteTableBackgroundColor = [UIColor whiteColor];
    self.nationalityTextField.autoCompleteTableAppearsAsKeyboardAccessory = YES;
    self.nationalityTextField.autoCompleteTableCellTextColor = [UIColor blackColor];
    [self.nationalityTextField setTintColor:Red_UIColor];
}

- (void) configureRoadTypeView{
    switch (self.selectedType) {
        case SingleRideType:
            self.singleRideLabel.textColor = [UIColor add_colorWithRGBHexString:Red_HEX];
            self.periodicLabel.textColor = [UIColor darkGrayColor];
            self.switchImageView.image = [UIImage imageNamed:@"select_Left"];
            break;
        case PeriodicType:
            self.periodicLabel.textColor = [UIColor add_colorWithRGBHexString:Red_HEX];
            self.singleRideLabel.textColor = [UIColor darkGrayColor];
            self.switchImageView.image = [UIImage imageNamed:@"select_Right"];
            break;
        default:
            break;
    }
}

- (void) configureGenderView{
    if (self.isFemaleOnly) {
        self.genderLabel.textColor = [UIColor add_colorWithRGBHexString:Red_HEX];
    }
    else{
        self.genderLabel.textColor = [UIColor darkGrayColor];
    }
}

#pragma Actions&Handler

- (void) popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) genderChangedHandler{
    self.isFemaleOnly = !self.isFemaleOnly;
    [self configureGenderView];
}

- (void) typeChangedHandler{
    if (self.selectedType == SingleRideType) {
        self.selectedType = PeriodicType;
    }
    else{
        self.selectedType = SingleRideType;
    }
    [self configureRoadTypeView];
}

- (void) dismissHandler{
    [self.view endEditing:YES];
}

- (IBAction) creatRideAction:(id)sender {
    NSDate *todayDate_;
    NSDate *pickupDate_;
    NSComparisonResult compareResult = NSOrderedDescending;
    if (self.pickupDate && !self.isEdit) {
        if (!self.pickupTime) {
            pickupDate_ = [self.pickupDate dateBySettingHour:0 minute:0 second:0];
            todayDate_ = [[NSDate date] dateBySettingHour:0 minute:0 second:0];
        }
        else{
            pickupDate_ = self.pickupDate;
            todayDate_   = [NSDate date];
        }
        
        compareResult = [pickupDate_ compare:todayDate_];
    }
    
    if ((!self.fromEmirate || !self.toEmirate)&& !self.isEdit) {
            [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"Please set startpoint and destination.")];
    }
    else if (!self.selectedVehicle &&!self.isEdit){
        if(!self.isEdit){
            [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"Please select Vehicle")];
        }
    }
    else if (self.rideNameTextField.text.length == 0){
        [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"Please enter ride name.")];
    }
    else if (!self.pickupDate){
        [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"Please select start date")];
    }
    else if (!self.pickupTime){
        [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"Please select start time")];
    }
    else if (compareResult == NSOrderedAscending){
        [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"invalid start date or time")];
    }
    else if (self.noOfSeats == 0){
        [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"Please select number of available seats.")];
        
    }
    else if (!self.satActive && !self.sunActive && !self.monActive && !self.tueActive && !self.wedActive && !self.thrActive && !self.friActive){
        [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"Please select days of week.")];
    }
    else{
        
        if (self.nationalityTextField.text.length > 0) {
            BOOL validNationality = [self.nationaltiesStringsArray containsObject:self.nationalityTextField.text];
            if (validNationality){
                self.selectedNationality = [self.nationalties objectAtIndex:[self.nationaltiesStringsArray indexOfObject:self.nationalityTextField.text]];
            }
            else{
                [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"Please Choose a valid nationality.")];
                return;
            }
        }
        __block CreateRideViewController *blockSelf = self;
        [KVNProgress showWithStatus:GET_STRING(@"Loading...")];
        BOOL isRounded = self.selectedType == PeriodicType ? YES : NO;
       
        NSString *gender ;
        if (self.bothBtn.selected) {
            gender = @"N";
        }else if (self.maleBtn.selected){
            gender = @"M";
        }else if (self.femaleBtn.selected){
            gender = @"F";
        }else{
            gender = @"N";
        }
        
        NSString *acceptSmoke ;
        if (self.acceptBtn.selected) {
            acceptSmoke = @"1";
        }else if (self.notAcceptBtn.selected){
            acceptSmoke = @"0";
        }else{
            acceptSmoke = @"";
        }
        
        NSString *fromEmirateID = self.isEdit ? self.routeDetails.FromEmirateId.stringValue : self.fromEmirate.EmirateId;
        NSString *toEmirateID = self.isEdit ? self.routeDetails.ToEmirateId.stringValue : self.toEmirate.EmirateId;
        NSString *fromRegionID = self.isEdit ? self.routeDetails.FromRegionId.stringValue : self.fromRegion.ID;
        NSString *toRegionID = self.isEdit ? self.routeDetails.ToRegionId.stringValue : self.toRegion.ID;
        
        Region *fromRegion = self.fromRegion;
        Region *toRegion = self.toRegion;
        if (self.isEdit &&(!fromRegion || !toRegion)) {
            fromRegion = [[MasterDataManager sharedMasterDataManager] getRegionByID:fromRegionID inEmirateWithID:fromEmirateID];
            toRegion = [[MasterDataManager sharedMasterDataManager] getRegionByID:toRegionID inEmirateWithID:toEmirateID];
        }
        
        NSString *startLat = fromRegion.RegionLatitude;
        NSString *startLng = fromRegion.RegionLongitude;
        
        NSString *endLat = toRegion.RegionLatitude;
        NSString *endLng = toRegion.RegionLongitude;
        
        
        [[MobDriverManager sharedMobDriverManager] createEditRideWithName:self.rideNameTextField.text fromEmirateID:fromEmirateID fromRegionID:fromRegionID toEmirateID:toEmirateID toRegionID:toRegionID isRounded:isRounded date:self.pickupDate saturday:self.satActive sunday:self.sunActive monday:self.monActive tuesday:self.tueActive wednesday:self.wedActive thursday:self.thrActive friday:self.friActive PreferredGender:gender vehicleID:self.isEdit ? self.routeDetails.VehicelId.stringValue : self.selectedVehicle.ID.stringValue noOfSeats:self.noOfSeats language:self.selectedLanguage nationality:self.selectedNationality  ageRange:self.selectedAgeRange  isEdit:self.isEdit routeID:self.routeDetails.ID.stringValue startLat:startLat startLng:startLng endLat:endLat endLng:endLng Smoke:acceptSmoke WithSuccess:^(NSString *response) {
            [KVNProgress dismiss];
            
            if ([response containsString:@"1"]) {
                [KVNProgress showSuccessWithStatus:self.isEdit ?  GET_STRING(@"Ride edited successfully") : GET_STRING(@"Ride created successfully")];
                [blockSelf performBlock:^{
                    [KVNProgress dismiss];
                    [blockSelf.navigationController popViewControllerAnimated:YES];
                } afterDelay:3];
                if (blockSelf.isEdit && blockSelf.editHandler) {
                    blockSelf.editHandler();
                }
            }
            else if ([response containsString:@"0"]){
                [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"Error")];
            }
            else if ([response containsString:@"-2"]){
                [[HelpManager sharedHelpManager] showAlertWithMessage:self.isEdit ? GET_STRING(@"An error happend when trying to create ride") : GET_STRING(@"You cannot create more than two rides.")];
            }
        } Failure:^(NSString *error) {
            [KVNProgress dismiss];
            [KVNProgress showErrorWithStatus:GET_STRING(@"An error happend when trying to create ride")];
            [blockSelf performBlock:^{
                [KVNProgress dismiss];
            } afterDelay:3];
        }];
    }
}

#pragma Pickers

- (void) showDatePicker{
    __block CreateRideViewController *blockSelf = self;
    RMAction *selectAction = [RMAction actionWithTitle:GET_STRING(@"Select") style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        NSDate *date =  ((UIDatePicker *)controller.contentView).date;
        blockSelf.dateFormatter.dateFormat = @"dd/MM/yyyy";
        NSString *dateString = [self.dateFormatter stringFromDate:date];
        blockSelf.dateLabel.text = dateString;
        
        NSInteger hour = [[NSDate date] hour];
        NSInteger minutes  = [[NSDate date] minute];
        if (blockSelf.pickupTime) {
            hour = blockSelf.pickupTime.hour;
            minutes = blockSelf.pickupTime.minute;
        }
        blockSelf.pickupDate = [[date dateBySettingHour:hour] dateBySettingMinute:minutes];
    }];
    
    //Create cancel action
    RMAction *cancelAction = [RMAction actionWithTitle:GET_STRING(@"Cancel") style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        
    }];
    
    //Create date selection view controller
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleWhite selectAction:selectAction andCancelAction:cancelAction];
    dateSelectionController.title = GET_STRING(@"Select Pickup Date");
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeDate;
    dateSelectionController.datePicker.date = self.pickupDate ? self.pickupDate : [NSDate date];
    
    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:dateSelectionController animated:YES completion:nil];
}

- (void) showTimePicker{
    
    __block CreateRideViewController *blockSelf = self;
    RMAction *selectAction = [RMAction actionWithTitle:GET_STRING(@"Select") style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        NSDate *date =  ((UIDatePicker *)controller.contentView).date;
        blockSelf.pickupTime = date;
        blockSelf.dateFormatter.dateFormat = @"HH:mm a";
        NSString *time = [self.dateFormatter stringFromDate:date];
        blockSelf.timeLabel.text = time;
        NSInteger hour = date.hour;
        NSInteger minutes = date.minute;
        blockSelf.pickupDate = [blockSelf.pickupDate dateBySettingHour:hour minute:minutes second:0];

    }];
    
    //Create cancel action
    RMAction *cancelAction = [RMAction actionWithTitle:GET_STRING(@"Cancel") style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        
    }];
    
    //Create date selection view controller
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleWhite selectAction:selectAction andCancelAction:cancelAction];
    dateSelectionController.title = GET_STRING(@"Select Pickup Time");
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeTime;
    dateSelectionController.datePicker.date = self.pickupDate;
    
    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:dateSelectionController animated:YES completion:nil];
}

- (void) showPickerWithTextFieldType:(TextFieldType)type
{
    RMAction *selectAction = [RMAction actionWithTitle:GET_STRING(@"Select") style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        UIPickerView *picker = ((RMPickerViewController *)controller).picker;
        NSInteger selectedRow = [picker selectedRowInComponent:0];
        switch (picker.tag) {
            case NationalityTextField:
            {
                Nationality *nationality = [self.nationalties objectAtIndex:selectedRow];
                self.nationalityTextField.text = (KIS_ARABIC)?nationality.NationalityArName:nationality.NationalityEnName;
                self.selectedNationality = nationality;
            }
                break;
            case LanguageTextField:
            {
                Language *language = [self.languages objectAtIndex:selectedRow];
                [self.selectLanguageButton setTitle:(KIS_ARABIC)?language.LanguageArName:language.LanguageEnName forState:UIControlStateNormal];
                self.selectedLanguage = language;
            }
                break;
            case AgeRangeTextField:
            {
                AgeRange *range = [self.ageRanges objectAtIndex:selectedRow];
                [self.selectAgeRangeButton  setTitle:range.Range forState:UIControlStateNormal];
                self.selectedAgeRange = range;
            }
                break;
            case VehiclesTextField:
            {
                Vehicle *vehicle = [self.vehicles objectAtIndex:selectedRow];
                [self.selectVehicleButton setTitle:(KIS_ARABIC)?vehicle.ModelArName:vehicle.ModelEnName forState:UIControlStateNormal];
                self.selectedVehicle = vehicle;
            }
                break;
                
            default:
                break;
        }
    }];
    
    
    RMAction *cancelAction = [RMAction actionWithTitle:GET_STRING(@"Cancel") style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        NSLog(@"Row selection was canceled");
    }];
    
    //Create picker view controller
    RMPickerViewController *pickerController = [RMPickerViewController actionControllerWithStyle:RMActionControllerStyleDefault selectAction:selectAction andCancelAction:cancelAction];
    
    pickerController.picker.delegate = self;
    pickerController.picker.dataSource = self;
    pickerController.picker.tag = type;
    NSInteger selectedRow = 0;
    switch (type) {
        case NationalityTextField:
        {
            if (self.selectedNationality) {
                selectedRow = [self.nationalties indexOfObject:self.selectedNationality];
            }
        }
            break;
        case LanguageTextField:
        {
            if (self.selectedLanguage) {
                selectedRow = [self.languages indexOfObject:self.selectedLanguage];
            }
        }
            break;
        case AgeRangeTextField:
        {
            if (self.selectedAgeRange) {
                selectedRow = [self.ageRanges indexOfObject:self.selectedAgeRange];
            }
        }
            break;
        case VehiclesTextField:
        {
            if (self.selectedVehicle) {
                selectedRow = [self.vehicles indexOfObject:self.selectedVehicle];
            }
        }
            break;
        default:
            break;
    }
    [pickerController.picker selectRow:selectedRow inComponent:0 animated:YES];
    //Now just present the picker controller using the standard iOS presentation method
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void) showLocationPicker{
    SelectLocationViewController *selectLocationViewController = [[SelectLocationViewController alloc] initWithNibName:(KIS_ARABIC)?@"SelectLocationViewController_ar":@"SelectLocationViewController" bundle:nil];
    selectLocationViewController.validateDestination = YES;
    __block CreateRideViewController *blockSelf = self;
    [selectLocationViewController setSelectionHandler:^(Emirate *fromEmirate, Region *fromRegion,Emirate *toEmirate, Region *toRegion) {
        
        blockSelf.helpLabel.alpha = 0;
        blockSelf.emiratesAndRegionsView.alpha = 1;
        
        NSString *fromText = [NSString stringWithFormat:@"%@,%@",(KIS_ARABIC)?fromEmirate.EmirateArName:fromEmirate.EmirateEnName,(KIS_ARABIC)?fromRegion.RegionArName:fromRegion.RegionEnName];
        
        blockSelf.fromEmirate = fromEmirate;
        blockSelf.fromRegion = fromRegion;
        blockSelf.startPointLabel.text = fromText;
        
        NSString *toText = [NSString stringWithFormat:@"%@,%@",(KIS_ARABIC)?toEmirate.EmirateArName:toEmirate.EmirateEnName,(KIS_ARABIC)?toRegion.RegionArName:toRegion.RegionEnName];
        blockSelf.toEmirate = toEmirate;
        blockSelf.toRegion = toRegion;
        blockSelf.destinationLabel.text = toText;
        
    }];
    [self.navigationController pushViewController:selectLocationViewController animated:YES];
}

#pragma PickerViewDeelgate&DataSource

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = @"";
    switch (pickerView.tag)
    {
        case NationalityTextField:
        {
            Nationality *nationality = [self.nationalties objectAtIndex:row];
            title = (KIS_ARABIC)?nationality.NationalityArName:nationality.NationalityEnName;
        }
            break;
        case AgeRangeTextField:
        {
            AgeRange *range = [self.ageRanges objectAtIndex:row];
            title = range.Range;
        }
            break;
        case LanguageTextField:
        {
            Language *language = [self.languages objectAtIndex:row];
            title = (KIS_ARABIC)?language.LanguageArName:language.LanguageEnName;
        }
            break;
        case VehiclesTextField:
        {
            Vehicle *vehicle = [self.vehicles objectAtIndex:row];
            title = (KIS_ARABIC)?vehicle.ModelArName:vehicle.ModelEnName;
        }
            break;
            
        default:
            break;
    }
    
    return title;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (pickerView.tag)
    {
        case NationalityTextField:
        {
            return self.nationalties.count;
        }
            break;
        case AgeRangeTextField:
        {
            return self.ageRanges.count;
        }
            break;
        case LanguageTextField:
        {
            return self.languages.count;
        }
            break;
        case VehiclesTextField:
        {
            return self.vehicles.count;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

#pragma AutoCompelete_Delegate
- (BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
shouldStyleAutoCompleteTableView:(UITableView *)autoCompleteTableView
               forBorderStyle:(UITextBorderStyle)borderStyle{
    return YES;
}

- (NSArray *)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
      possibleCompletionsForString:(NSString *)string{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",string]; // if you need case sensitive search avoid '[c]' in the predicate
    NSArray *results = [self.nationaltiesStringsArray filteredArrayUsingPredicate:predicate];
    return results;
}

- (BOOL) isValidNationality{
    BOOL validNationality = [self.nationaltiesStringsArray containsObject:self.nationalityTextField.text];
    if (!validNationality) {
        return NO;
    }
    return YES;
}

- (IBAction)selectGenderType:(id)sender
{
    switch ([sender tag])
    {
        case 0:
            if (self.bothBtn.selected) {
                self.bothBtn.selected = NO ;
            }else{
                self.bothBtn.selected = YES ;
            }
            self.maleBtn.selected = NO ;
            self.femaleBtn.selected = NO;
            break;
        case 1:
            self.bothBtn.selected = NO ;
            if (self.maleBtn.selected) {
                self.maleBtn.selected = NO ;
            }else{
                self.maleBtn.selected = YES ;
            }
            self.femaleBtn.selected = NO;
            break;
        case 2:
            self.bothBtn.selected = NO ;
            self.maleBtn.selected = NO ;
            if (self.femaleBtn.selected)
            {
                self.femaleBtn.selected = NO;
            }else{
                self.femaleBtn.selected = YES;
            }
            break;
        default:
            break;
    }
}

- (IBAction)selectIsSmoke:(id)sender
{
    switch ([sender tag])
    {
        case 10:
            if (self.acceptBtn.selected)
            {
                self.acceptBtn.selected = NO ;
            }else{
                self.acceptBtn.selected = YES ;
            }
            self.notAcceptBtn.selected = NO ;
            break;
        case 11:
            self.acceptBtn.selected = NO ;
            if (self.notAcceptBtn.selected)
            {
                self.notAcceptBtn.selected = NO ;
            }else{
                self.notAcceptBtn.selected = YES ;
            }
            break;
        default:
            break;
    }
}

#pragma TextFieldDelegate
#pragma mark - TextFieldDelegate

// This code handles the scrolling when tabbing through infput fields
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 220;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 140;
//when clicking the return button in the keybaord

#pragma TextField Delegate
- (BOOL)textFieldShouldEndEditing:(UITextField*)textField{
        return [self textSouldEndEditing];
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField{
   
    [textField resignFirstResponder];
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    [self textDidBeginEditing:textFieldRect];
}

- (void)textDidBeginEditing:(CGRect)textRect{
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textRect.origin.y + 0.5 * textRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        self.animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        self.animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= self.animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
            return YES;
}

- (BOOL)textSouldEndEditing{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += self.animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
    return YES;
}

#pragma Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UIView* view in self.view.subviews) {
        for (UIGestureRecognizer* recognizer in view.gestureRecognizers) {
            [recognizer addTarget:self action:@selector(touchEvent:)];
        }
        
        //        [self.view endEditing:YES];
    }
}

- (void)touchEvent:(id)sender{
    
    
}
@end
