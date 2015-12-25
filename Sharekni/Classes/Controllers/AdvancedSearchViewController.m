//
//  AdvancedSearchViewController.m
//  Sharekni
//
//  Created by Ahmed Askar on 9/26/15.
//
//

#import "AdvancedSearchViewController.h"
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
#import "MobDriverManager.h"
#import "MLPAutoCompleteTextField.h"
#import "MLPAutoCompleteTextFieldDataSource.h"
#import "MLPAutoCompleteTextFieldDelegate.h"
#import "MobAccountManager.h"

@interface AdvancedSearchViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,MLPAutoCompleteTextFieldDelegate,MLPAutoCompleteTextFieldDataSource>
//Outlets
@property (weak, nonatomic) IBOutlet UIView *saveSearchView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView ;
@property (weak, nonatomic) IBOutlet UILabel *saveSearchLabel;
@property (weak, nonatomic) IBOutlet UIImageView *saveSearchSwitchImage;

@property (weak, nonatomic) IBOutlet UIButton *setDirectionBtuton;
@property (weak, nonatomic) IBOutlet UIButton *languageButton;
@property (weak, nonatomic) IBOutlet UIButton *ageRangeButton;

@property (weak, nonatomic) IBOutlet UILabel *startPointLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;

@property (weak, nonatomic) IBOutlet UILabel *helpLabel;

@property (weak, nonatomic) IBOutlet UIView *emiratesAndRegionsView;

@property (weak, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet MLPAutoCompleteTextField *nationalityTextField;

@property (weak, nonatomic) IBOutlet UIView *typeView;

@property (weak, nonatomic) IBOutlet UIView *sepratorLine;
@property (weak, nonatomic) IBOutlet UILabel *optionalHeader;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UILabel *pickupTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dropoffTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeSwitchImage;
@property (weak, nonatomic) IBOutlet UIImageView *genderSwitchImage;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *periodicLabel;
@property (weak, nonatomic) IBOutlet UILabel *singleRideLabel;
@property (weak, nonatomic) IBOutlet UIView *genderView;

@property (strong, nonatomic)  NSDateFormatter *dateFormatter;
@property (assign, nonatomic)  RoadType selectedType;
@property (assign, nonatomic)  BOOL isFemaleOnly;
@property (strong,nonatomic) NSDate *pickupDate;
@property (strong,nonatomic) NSDate *pickupTime;

@property (strong,nonatomic) NSArray *nationalties;
@property (strong,nonatomic) NSMutableArray *nationaltiesStringsArray;
@property (strong,nonatomic) NSArray *languages;
@property (strong,nonatomic) NSArray *ageRanges;

@property (strong,nonatomic) AgeRange *selectedAgeRange;
@property (strong,nonatomic) Nationality *selectedNationality;
@property (strong,nonatomic) Language *selectedLanguage;

@property (strong,nonatomic) Emirate *fromEmirate;
@property (strong,nonatomic) Emirate *toEmirate;

@property (strong,nonatomic) Region *fromRegion;
@property (strong,nonatomic) Region *toRegion;

@property (nonatomic,assign) BOOL saveSearchEnabled;

@property (weak ,nonatomic) IBOutlet UIButton *bothBtn ;
@property (weak ,nonatomic) IBOutlet UIButton *maleBtn ;
@property (weak ,nonatomic) IBOutlet UIButton *femaleBtn ;

@property (weak ,nonatomic) IBOutlet UIButton *acceptBtn ;
@property (weak ,nonatomic) IBOutlet UIButton *notAcceptBtn ;

@end

@implementation AdvancedSearchViewController

-(NSDateFormatter *)dateFormatter{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void) viewDidLoad {
    [super viewDidLoad];
 
    self.title = GET_STRING(@"advancedSearch");
    
    UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(0, 0, 22, 22);
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"Back_icn"] forState:UIControlStateNormal];
    [_backBtn setHighlighted:NO];
    [_backBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
    
    int height = self.searchButton.frame.origin.y + self.searchButton.frame.size.height + 15;
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, height)];
    self.selectedType = SingleRideType;
    self.isFemaleOnly = NO;
    [self configureData];
    [self configureRoadTypeView];
    [self configureGenderView];
    [self configureUI];
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

- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma Data
- (void) configureData{
    __block AdvancedSearchViewController *blockSelf = self;
    [KVNProgress showWithStatus:GET_STRING(@"loading")];
    [[MasterDataManager sharedMasterDataManager] GetNationalitiesByID:@"0" WithSuccess:^(NSMutableArray *array) {
        blockSelf.nationalties = array;
        blockSelf.nationaltiesStringsArray = [NSMutableArray array];
        for (Nationality *nationality in array) {
            [blockSelf.nationaltiesStringsArray addObject:(KIS_ARABIC)?nationality.NationalityArName:nationality.NationalityEnName];
        }
        [[MasterDataManager sharedMasterDataManager] GetAgeRangesWithSuccess:^(NSMutableArray *array) {
            blockSelf.ageRanges = array;
            [[MasterDataManager sharedMasterDataManager] GetPrefferedLanguagesWithSuccess:^(NSMutableArray *array) {
                [KVNProgress dismiss];
                blockSelf.languages = array;
                [[MasterDataManager sharedMasterDataManager] GetEmiratesWithSuccess:^(NSMutableArray *array) {
                    
                } Failure:^(NSString *error) {
                    
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

- (void) configureUI{
    
    [self.setDirectionBtuton setBackgroundColor:Red_UIColor];
    self.setDirectionBtuton.layer.cornerRadius = 10;
    [self.setDirectionBtuton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.setDirectionBtuton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.setDirectionBtuton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    [self.languageButton setBackgroundColor:[UIColor whiteColor]];
    [self.languageButton setTitleColor:Red_UIColor forState:UIControlStateNormal];
    [self.languageButton setTitleColor:Red_UIColor forState:UIControlStateHighlighted];
    [self.languageButton setTitleColor:Red_UIColor forState:UIControlStateSelected];

    
    [self.ageRangeButton setBackgroundColor:[UIColor whiteColor]];
    [self.ageRangeButton setTitleColor:Red_UIColor forState:UIControlStateNormal];
    [self.ageRangeButton setTitleColor:Red_UIColor forState:UIControlStateHighlighted];
    [self.ageRangeButton setTitleColor:Red_UIColor forState:UIControlStateSelected];
    
    self.searchButton.layer.cornerRadius = 8;
    
    self.nationalityTextField.textColor    = Red_UIColor;
    UIColor *color = [UIColor add_colorWithRGBHexString:Red_HEX];
    self.nationalityTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:GET_STRING(@"preferedLang") attributes:@{NSForegroundColorAttributeName: color}];
    
    self.startPointLabel.textColor     = Red_UIColor;
    self.destinationLabel.textColor    = Red_UIColor;
    self.optionalHeader.textColor          =  Red_UIColor;
    self.sepratorLine.backgroundColor      = Red_UIColor;
    self.dateLabel.textColor = Red_UIColor;
    self.timeLabel.textColor = Red_UIColor;
    self.dateLabel.textColor = Red_UIColor;
    self.timeLabel.textColor = Red_UIColor;

    
    [self.languageButton setTitle:GET_STRING(@"Choose a language") forState:UIControlStateNormal];
    [self.ageRangeButton setTitle:GET_STRING(@"Choose age range") forState:UIControlStateNormal];
    
    UITapGestureRecognizer *saveSearchTapGestureRecognizer  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveSearchViewTapped)];
    [self.saveSearchView addGestureRecognizer:saveSearchTapGestureRecognizer];
    
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
    
    self.nationalityTextField.delegate = self;
    self.nationalityTextField.autoCompleteDataSource = self;
    self.nationalityTextField.autoCompleteDelegate = self;
    self.nationalityTextField.autoCompleteTableBorderColor = Red_UIColor;
    self.nationalityTextField.autoCompleteTableBorderWidth = 2;
    self.nationalityTextField.autoCompleteTableBackgroundColor = [UIColor whiteColor];
    self.nationalityTextField.autoCompleteTableCellTextColor = Red_UIColor;
    self.nationalityTextField.autoCompleteTableAppearsAsKeyboardAccessory = YES;
    [self.nationalityTextField setTintColor:Red_UIColor];
    
    self.helpLabel.alpha = 1;
    self.emiratesAndRegionsView.alpha = 0;
    
    self.saveSearchLabel.textColor = [UIColor darkGrayColor];
    
    User *applicationUser = [[MobAccountManager sharedMobAccountManager] applicationUser];
    if (!applicationUser) {
        self.saveSearchView.alpha = 0;
        CGRect frame = self.searchButton.frame;
        frame.origin.y = self.saveSearchView.frame.origin.y;
        self.searchButton.frame = frame;
        
        CGSize contentSize = self.scrollView.contentSize;
        contentSize.height = self.searchButton.frame.origin.y + self.searchButton.frame.size.height + 15;
        self.scrollView.contentSize = contentSize;
    }
}

- (void) configureRoadTypeView{
    switch (self.selectedType) {
        case SingleRideType:
            self.singleRideLabel.textColor = [UIColor add_colorWithRGBHexString:Red_HEX];
            self.periodicLabel.textColor = [UIColor darkGrayColor];
            self.typeSwitchImage.image = [UIImage imageNamed:@"select_Left"];
            break;
        case PeriodicType:
            self.periodicLabel.textColor = [UIColor add_colorWithRGBHexString:Red_HEX];
            self.singleRideLabel.textColor = [UIColor darkGrayColor];
            self.typeSwitchImage.image = [UIImage imageNamed:@"select_Right"];
            break;
        default:
            break;
    }
}

- (void) configureGenderView{
    if (self.isFemaleOnly)
    {
        self.genderSwitchImage.image = [UIImage imageNamed:(KIS_ARABIC)?@"select_Left":@"select_Right"];
        self.genderLabel.textColor = [UIColor add_colorWithRGBHexString:Red_HEX];
    }else{
        self.genderSwitchImage.image = [UIImage imageNamed:(KIS_ARABIC)?@"select_Right":@"select_Left"];
        self.genderLabel.textColor = [UIColor darkGrayColor];
    }
}

#pragma Actions&Handler

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

- (void) saveSearchViewTapped{
    self.saveSearchEnabled = !self.saveSearchEnabled;
    if (self.saveSearchEnabled)
    {
        self.saveSearchLabel.textColor = Red_UIColor;
        self.saveSearchSwitchImage.image = [UIImage imageNamed:(KIS_ARABIC)?@"select_Left":@"select_Right"];
    }else{
        self.saveSearchLabel.textColor = [UIColor darkGrayColor];
        self.saveSearchSwitchImage.image = [UIImage imageNamed:(KIS_ARABIC)?@"select_Right":@"select_Left"];
    }
}

- (IBAction)searchAction:(id)sender {
    NSDate *todayDate_;
    NSDate *pickupDate_;
    NSComparisonResult compareResult = NSOrderedDescending;
    if (self.pickupDate) {
//        if (!self.pickupTime) {
            pickupDate_ = [self.pickupDate dateBySettingHour:0 minute:0 second:0];
            todayDate_ = [[NSDate date] dateBySettingHour:0 minute:0 second:0];
//        }
//        else{
//            pickupDate_ = self.pickupDate;
//            todayDate_   = [NSDate date];
//        }
        
        compareResult = [pickupDate_ compare:todayDate_];
    }
    
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
    
    if (!self.fromEmirate) {
          [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"Please select start point")];
    }
    else if (compareResult == NSOrderedAscending){
        [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"invalid start date or time ")];
    }
    else{
        __block AdvancedSearchViewController *blockSelf = self;
        [KVNProgress showWithStatus:GET_STRING(@"Loading...")];
        [[MobDriverManager sharedMobDriverManager] findRidesFromEmirate:self.fromEmirate andFromRegion:self.fromRegion toEmirate:self.toEmirate andToRegion:self.toRegion PerfferedLanguage:self.selectedLanguage nationality:self.selectedNationality ageRange:self.selectedAgeRange date:self.pickupDate isPeriodic:(self.selectedType == PeriodicType) ?@(YES):@(NO) saveSearch:self.saveSearchEnabled Gender:gender Smoke:acceptSmoke WithSuccess:^(NSArray *searchResults) {
            [KVNProgress dismiss];
            if(searchResults){
                SearchResultsViewController *resultViewController = [[SearchResultsViewController alloc] initWithNibName:(KIS_ARABIC)?@"SearchResultsViewController_ar":@"SearchResultsViewController" bundle:nil];
                resultViewController.results = searchResults;
                resultViewController.fromEmirate =(KIS_ARABIC)?blockSelf.fromEmirate.EmirateArName:blockSelf.fromEmirate.EmirateEnName;
                resultViewController.toEmirate = (KIS_ARABIC)? blockSelf.toEmirate.EmirateArName:blockSelf.toEmirate.EmirateEnName;
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

#pragma Pickers

- (void) showDatePicker{
    //    self.pickupDate = [[NSDate date] dateBySettingHour:10];
    __block AdvancedSearchViewController  *blockSelf = self;
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
    dateSelectionController.title = @"select Pickup Date";
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeDate;
    dateSelectionController.datePicker.date = self.pickupDate ? self.pickupDate : [NSDate date];
    
    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:dateSelectionController animated:YES completion:nil];
}

- (void) showTimePicker{
    
    __block AdvancedSearchViewController *blockSelf = self;
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
    dateSelectionController.title = @"select Pickup Time";
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeTime;
    dateSelectionController.datePicker.date = self.pickupDate ? self.pickupDate : [NSDate date];
    
    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:dateSelectionController animated:YES completion:nil];
}

- (void) showPickerWithTextFieldType:(TextFieldType)type{
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
                [self.languageButton setTitle:(KIS_ARABIC)?language.LanguageArName:language.LanguageEnName forState:UIControlStateNormal];
                self.selectedLanguage = language;
            }
            break;
            case AgeRangeTextField:
            {
                AgeRange *range = [self.ageRanges objectAtIndex:selectedRow];
                [self.ageRangeButton setTitle:range.Range forState:UIControlStateNormal];
                self.selectedAgeRange = range;
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
        default:
            break;
    }
    //Now just present the picker controller using the standard iOS presentation method
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void) showLocationPicker{
    SelectLocationViewController *selectLocationViewController = [[SelectLocationViewController alloc] initWithNibName:(KIS_ARABIC)?@"SelectLocationViewController_ar":@"SelectLocationViewController" bundle:nil];
    __block AdvancedSearchViewController *blockSelf = self;
    [selectLocationViewController setSelectionHandler:^(Emirate *fromEmirate, Region *fromRegion,Emirate *toEmirate, Region *toRegion) {
        self.helpLabel.alpha = 0;
        self.emiratesAndRegionsView.alpha = 1;
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
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.nationalityTextField){
//        [self showPickerWithTextFieldType:NationalityTextField];
        return YES;
    }
    return NO;

}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    if (textField == self.nationalityTextField) {
        if([self.nationaltiesStringsArray containsObject:textField.text]){
            self.selectedNationality  = self.nationalties[[self.nationaltiesStringsArray indexOfObject:textField.text] ];
        }
        else{
            [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"Please Choose a valid nationality.")];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma PickerViewDeelgate&DataSource
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *title = @"";
    switch (pickerView.tag) {
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
            
        default:
            break;
    }
    
    return title;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (pickerView.tag) {
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
            
        default:
            break;
    }
    return 0;

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (IBAction)setDirectionButtonHandler:(id)sender {
    [self showLocationPicker];
}
- (IBAction)ageRangeButtonHandler:(id)sender {
    [self showPickerWithTextFieldType:AgeRangeTextField];
}
- (IBAction)languageButtonHandler:(id)sender {
    [self showPickerWithTextFieldType:LanguageTextField];
}

#pragma AutoCompelete_Delegate
- (BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
shouldStyleAutoCompleteTableView:(UITableView *)autoCompleteTableView
               forBorderStyle:(UITextBorderStyle)borderStyle{
    return YES;
}

- (NSArray *)autoCompleteTextField:(MLPAutoCompleteTextField *)textField      possibleCompletionsForString:(NSString *)string{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",string]; // if you need case sensitive search avoid '[c]' in the predicate
    NSArray *results = [self.nationaltiesStringsArray filteredArrayUsingPredicate:predicate];
    return results;
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


@end
