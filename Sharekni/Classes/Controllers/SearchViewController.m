//
//  SearchViewController.m
//  Sharekni
//
//  Created by Ahmed Askar on 10/4/15.
//
//

#import "SearchViewController.h"
#import "AdvancedSearchViewController.h"
#import "MostRidesViewController.h"
#import "MapLookupViewController.h"
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
#import "SearchResultsViewController.h"
#import "MobAccountManager.h"
@interface SearchViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *setDirectionButton;

@property (weak, nonatomic) IBOutlet UILabel *startPointLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UILabel *pickupTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dropoffTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UILabel *saveSearchLabel;
@property (weak, nonatomic) IBOutlet UIImageView *SwitchImage;
@property (weak, nonatomic) IBOutlet UIView *timeView;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *saveSearchView;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel;

@property (weak, nonatomic) IBOutlet UIView *emiratesRegionsView;
@property (strong,nonatomic) Emirate *fromEmirate;
@property (strong,nonatomic) Emirate *toEmirate;

@property (strong,nonatomic) Region *fromRegion;
@property (strong,nonatomic) Region *toRegion;

@property (nonatomic,assign) BOOL saveSearchEnabled;

@property (strong, nonatomic)  NSDateFormatter *dateFormatter;
@property (strong,nonatomic) NSDate *pickupDate;
@property (strong,nonatomic) NSDate *pickupTime;

@end

@implementation SearchViewController

-(NSDateFormatter *)dateFormatter{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = GET_STRING(@"searchOptions");
    self.navigationController.navigationBarHidden = NO ;
    [self configureUI];
}

- (void) viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = YES;
}

- (BOOL)shouldAutorotate
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait){
        // your code for portrait mode
        return NO ;
    }else{
        return YES ;
    }
}

- (void) configureUI{
    
    [self.setDirectionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.setDirectionButton.layer.cornerRadius = 10;
    [self.setDirectionButton setBackgroundColor:Red_UIColor];
    
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.pickupTitleLabel.bounds
                                     byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerTopLeft)
                                           cornerRadii:CGSizeMake(5.0, 5.0)];
    
    self.searchButton.layer.cornerRadius = 8;
    
    self.pickupTitleLabel.backgroundColor  = [UIColor whiteColor];
    self.dropoffTitleLabel.backgroundColor = [UIColor whiteColor];
    self.pickupTitleLabel.textColor  = [UIColor blackColor];
    self.dropoffTitleLabel.textColor = [UIColor blackColor];
    self.startPointLabel.textColor     = Red_UIColor;
    self.destinationLabel.textColor    = Red_UIColor;
    
    self.dateLabel.textColor = Red_UIColor;
    self.timeLabel.textColor = Red_UIColor;
    
    [self.searchButton setBackgroundColor:Red_UIColor];

    UITapGestureRecognizer *saveSearchTapGestureRecognizer  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveSearchViewTapped)];
    [self.saveSearchView addGestureRecognizer:saveSearchTapGestureRecognizer];
    
    UITapGestureRecognizer *dateTapGestureRecognizer  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDatePicker)];
    [self.dateView addGestureRecognizer:dateTapGestureRecognizer];
    
    UITapGestureRecognizer *TimeTapGestureRecognizer  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTimePicker)];
    [self.timeView addGestureRecognizer:TimeTapGestureRecognizer];
    
    self.emiratesRegionsView.alpha = 0;
    self.helpLabel.alpha = 1;
    
    self.saveSearchLabel.textColor = [UIColor darkGrayColor];
    
    User *applicationUser = [[MobAccountManager sharedMobAccountManager] applicationUser];
    if (!applicationUser) {
        self.saveSearchView.alpha = 0;
        CGRect frame = self.searchButton.frame;
        frame.origin.y = self.saveSearchView.frame.origin.y;
        self.searchButton.frame = frame;
    }
}

- (void) saveSearchViewTapped {
    self.saveSearchEnabled = !self.saveSearchEnabled;
    if (self.saveSearchEnabled) {
        self.saveSearchLabel.textColor = Red_UIColor;
        self.SwitchImage.image = [UIImage imageNamed:(KIS_ARABIC)?@"select_Left":@"select_Right"];
    }
    else{
        self.saveSearchLabel.textColor = [UIColor darkGrayColor];
        self.SwitchImage.image = [UIImage imageNamed:(KIS_ARABIC)?@"select_Right":@"select_Left"];
    }
}

#pragma Pickers

- (void) showDatePicker{
//    self.pickupDate = [[NSDate date] dateBySettingHour:10];
    __block SearchViewController  *blockSelf = self;
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
    
    __block SearchViewController *blockSelf = self;
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
    dateSelectionController.datePicker.date = self.pickupDate ? self.pickupDate : [NSDate date];
    
    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:dateSelectionController animated:YES completion:nil];
}

- (void) showLocationPicker{
    SelectLocationViewController *selectLocationViewController = [[SelectLocationViewController alloc] initWithNibName:(KIS_ARABIC)?@"SelectLocationViewController_ar":@"SelectLocationViewController" bundle:nil];
    __block SearchViewController *blockSelf = self;
    [selectLocationViewController setSelectionHandler:^(Emirate *fromEmirate, Region *fromRegion,Emirate *toEmirate, Region *toRegion) {
        blockSelf.helpLabel.alpha = 0;
        blockSelf.emiratesRegionsView.alpha = 1;
        NSString *fromText = [NSString stringWithFormat:@"%@,%@",(KIS_ARABIC)?fromEmirate.EmirateArName:fromEmirate.EmirateEnName,(KIS_ARABIC)?fromRegion.RegionArName:fromRegion.RegionEnName];
            blockSelf.fromEmirate = fromEmirate;
            blockSelf.fromRegion = fromRegion;
            blockSelf.startPointLabel.text = fromText;
        
        blockSelf.destinationLabel.text = @"";
        if (toEmirate && toRegion) {
            NSString *toText = [NSString stringWithFormat:@"%@,%@",(KIS_ARABIC)?toEmirate.EmirateArName:toEmirate.EmirateEnName,(KIS_ARABIC)?toRegion.RegionArName:toRegion.RegionEnName];
            blockSelf.toEmirate = toEmirate;
            blockSelf.toRegion = toRegion;
            blockSelf.destinationLabel.text = toText;
        }
    }];
    
    [self.navigationController pushViewController:selectLocationViewController animated:YES];
}

#pragma TextFieldDelegate

- (IBAction) quickSearchAction:(id)sender {
    NSDate *todayDate_;
    NSDate *pickupDate_;
    NSComparisonResult compareResult = NSOrderedDescending;
    if (self.pickupDate) {
            pickupDate_ = [self.pickupDate dateBySettingHour:0 minute:0 second:0];
            todayDate_ = [[NSDate date] dateBySettingHour:0 minute:0 second:0];
            compareResult = [pickupDate_ compare:todayDate_];
    }
    
    if (!self.fromEmirate) {
        [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"Please set direction")];
    }
    else if (compareResult == NSOrderedAscending){
        [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"invalid start date or time")];
    }
    else{
        __block SearchViewController *blockSelf = self;
        [KVNProgress showWithStatus:GET_STRING(@"Loading...")];
        [[MobDriverManager sharedMobDriverManager] findRidesFromEmirate:self.fromEmirate andFromRegion:self.fromRegion toEmirate:self.toEmirate andToRegion:self.toRegion PerfferedLanguage:nil nationality:nil ageRange:nil date:self.pickupDate isPeriodic:nil saveSearch:self.saveSearchEnabled Gender:@"N" Smoke:@"" WithSuccess:^(NSArray *searchResults){
            [KVNProgress dismiss];
            if(searchResults){
                SearchResultsViewController *resultViewController = [[SearchResultsViewController alloc] initWithNibName:(KIS_ARABIC)?@"SearchResultsViewController_ar":@"SearchResultsViewController" bundle:nil];
                resultViewController.results = searchResults;
                resultViewController.fromEmirate = (KIS_ARABIC)?blockSelf.fromEmirate.EmirateArName:blockSelf.fromEmirate.EmirateEnName;
                resultViewController.toEmirate = (KIS_ARABIC)?blockSelf.toEmirate.EmirateArName:blockSelf.toEmirate.EmirateEnName;
                resultViewController.fromRegion = (KIS_ARABIC)?blockSelf.fromRegion.RegionArName:blockSelf.fromRegion.RegionEnName;
                resultViewController.toRegion = (KIS_ARABIC)?blockSelf.toRegion.RegionArName:blockSelf.toRegion.RegionEnName;
                [blockSelf.navigationController pushViewController:resultViewController animated:YES];
            }
            else{
                [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"No Rides Found")];
            }
        } Failure:^(NSString *error) {
            [KVNProgress dismiss];
        }];
    }
}

- (void) popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma Actions

- (IBAction) setDirectionAction:(id)sender {
    [self showLocationPicker];
}

- (IBAction) advancedSearch:(id)sender{
    AdvancedSearchViewController *advancedSearchView = [[AdvancedSearchViewController alloc] initWithNibName:(KIS_ARABIC)?@"AdvancedSearchViewController_ar":@"AdvancedSearchViewController" bundle:nil];
    [self.navigationController pushViewController:advancedSearchView animated:YES];
}

- (IBAction) mapLookUp:(id)sender {
    MapLookupViewController *mapLookupViewController = [[MapLookupViewController alloc] initWithNibName:@"MapLookupViewController" bundle:nil];
    [self.navigationController pushViewController:mapLookupViewController animated:YES];
}

- (IBAction) topRides:(id)sender{
    MostRidesViewController *mostRides = [[MostRidesViewController alloc] initWithNibName:@"MostRidesViewController" bundle:nil];
    mostRides.enableBackButton = YES;
    [self.navigationController pushViewController:mostRides animated:YES];
}

@end
