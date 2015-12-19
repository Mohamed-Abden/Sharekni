//
//  RegisterViewController.m
//  Sharekni
//
//  Created by Ahmed Askar on 9/25/15.
//
//

#import "RegisterViewController.h"
#import "Constants.h"
#import <UIColor+Additions/UIColor+Additions.h>
#import <RMActionController.h>
#import <RMPickerViewController.h>
#import "Nationality.h"
#import "Language.h"
#import "HelpManager.h"
#import <RMDateSelectionViewController.h>
#import "MasterDataManager.h"
#import <KVNProgress.h>
#import "NSObject+Blocks.h"
#import "MobAccountManager.h"
#import "HomeViewController.h"
#import "SharekniWebViewController.h"
#import "MLPAutoCompleteTextField.h"
#import <REFrostedViewController.h>
#import "SideMenuTableViewController.h"
#import "UploadImageManager.h"

#define Nationality_Tag 70
@interface RegisterViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,MLPAutoCompleteTextFieldDataSource,MLPAutoCompleteTextFieldDelegate,REFrostedViewControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *privacyButton;
//O
@property (weak,nonatomic) IBOutlet UIScrollView *container;
@property (weak,nonatomic) IBOutlet UIButton *driverBtn;
@property (weak,nonatomic) IBOutlet UIButton *passengerBtn;
@property (weak,nonatomic) IBOutlet UIButton *bothBtn;
@property (weak,nonatomic) IBOutlet UITextField *firstNametxt;
@property (weak,nonatomic) IBOutlet UITextField *lastNametxt;
@property (weak,nonatomic) IBOutlet UITextField *mobileNumberTxt;
@property (weak,nonatomic) IBOutlet UITextField *usernameTxt;
@property (weak,nonatomic) IBOutlet UITextField *passwordTxt;
@property (weak,nonatomic) IBOutlet MLPAutoCompleteTextField *nationalityTxt;
@property (weak,nonatomic) IBOutlet UITextField *preferredLanguageTxt;
@property (weak,nonatomic) IBOutlet UIView *datePickerView;
@property (weak,nonatomic) IBOutlet UIButton *switchBtn;
@property (weak,nonatomic) IBOutlet UILabel *driverLbl;
@property (weak,nonatomic) IBOutlet UILabel *passengerLbl;
@property (weak,nonatomic) IBOutlet UILabel *bothLbl;


@property (weak, nonatomic) IBOutlet UIButton *termsButton;
@property (weak,nonatomic) IBOutlet UILabel *femaleLabel;
    
@property (weak,nonatomic) IBOutlet UILabel *dateLabel;
@property (weak,nonatomic) IBOutlet UILabel *maleLabel;
@property (nonatomic,assign) float animatedDistance ;

@property (weak, nonatomic) IBOutlet UIView *firstNameView;
@property (weak, nonatomic) IBOutlet UIView *lastNameView;
@property (weak, nonatomic) IBOutlet UIView *mobileNumberView;
@property (weak, nonatomic) IBOutlet UIView *userNameView;
@property (weak, nonatomic) IBOutlet UIView *nationalityView;
@property (weak, nonatomic) IBOutlet UIView *languageView;

@property (weak, nonatomic) IBOutlet UIView *passwordView;

@property (strong,nonatomic) NSArray *nationalties;
@property (nonatomic,strong) NSMutableArray *nationaltiesStringsArray;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong,nonatomic) NSArray *languages;

@property (strong,nonatomic) Nationality *selectedNationality;
@property (strong,nonatomic) Language *selectedLanguage;
@property (strong,nonatomic) NSString *userName;
@property (strong,nonatomic) NSString *password;
@property (strong,nonatomic) NSString *firstName;
@property (strong,nonatomic) NSString *lastName;
@property (strong,nonatomic) NSString *mobileNumber;
@property (strong,nonatomic) NSDate *date;
@property (strong,nonatomic) NSDateFormatter *dateFormatter;
@property (assign,nonatomic) BOOL isMale;
@property (assign,nonatomic) AccountType accountType;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;

@property (strong,nonatomic) UIImage *profileImage;

@property (nonatomic,strong) UIToolbar *inputAccessoryView;
@end

@implementation RegisterViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO ;
    
    self.title = GET_STRING(@"registration");
    
    UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(0, 0, 22, 22);
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"Back_icn"] forState:UIControlStateNormal];
    [_backBtn setHighlighted:NO];
    [_backBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
   
    [self configureUI];
    [self configrueNationalityAutoCompelete];
    [self configureData];
    [self configureTextFields];
    self.isMale = YES;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void) popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma Data

- (void) configureUI{
    
    self.profileImageView.hidden = YES;
    
    self.dateLabel.textColor = [UIColor blackColor];
    
    [self.termsButton setTitleColor:Red_UIColor forState:UIControlStateNormal];
    [self.privacyButton setTitleColor:Red_UIColor forState:UIControlStateNormal];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDatePicker)];
    [self.datePickerView addGestureRecognizer:gesture];
    [self.dateLabel addGestureRecognizer:gesture];
    [self.dateLabel setUserInteractionEnabled:YES];
    [self.datePickerView setUserInteractionEnabled:YES];
    
    [self.driverBtn    setBackgroundImage:[UIImage imageNamed:@"driver_icon"]    forState:UIControlStateNormal];
    [self.driverBtn    setBackgroundImage:[UIImage imageNamed:@"driverActive_icon"]      forState:UIControlStateSelected];
    [self.driverBtn    setSelected:NO];
   
    [self.passengerBtn setBackgroundImage:[UIImage imageNamed:@"passenger_icon"] forState:UIControlStateNormal];
    [self.passengerBtn setBackgroundImage:[UIImage imageNamed:@"passengerActive_icon"]   forState:UIControlStateSelected];
    [self.passengerBtn    setSelected:NO];

    [self.bothBtn      setBackgroundImage:[UIImage imageNamed:@"both_icon"]      forState:UIControlStateNormal];
    [self.bothBtn      setBackgroundImage:[UIImage imageNamed:@"bothAcive_icon"]        forState:UIControlStateSelected];
    [self.bothBtn    setSelected:NO];
    self.accountType = AccountTypeNone;

    [self.switchBtn    setBackgroundImage:[UIImage imageNamed:@"select_Left"]       forState:UIControlStateNormal];
    [self.switchBtn    setBackgroundImage:[UIImage imageNamed:@"select_Right"]      forState:UIControlStateSelected];
    [self.switchBtn    setSelected:NO];
    
    self.maleLabel.textColor = Red_UIColor;
    self.femaleLabel.textColor = [UIColor darkGrayColor];
    self.maleLabel.userInteractionEnabled = YES;
    self.femaleLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *maleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maleTapped)];
    [self.maleLabel addGestureRecognizer:maleGesture];
    
    UITapGestureRecognizer *femaleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(femaleTapped)];
    [self.femaleLabel addGestureRecognizer:femaleGesture];
    
    [self.container setContentSize:self.container.frame.size];

    if ([self.firstNametxt respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor add_colorWithRGBHexString:Red_HEX];
        self.firstNametxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:GET_STRING(@"firstName") attributes:@{NSForegroundColorAttributeName: color}];
        self.lastNametxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:GET_STRING(@"lastName") attributes:@{NSForegroundColorAttributeName: color}];
        self.mobileNumberTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:GET_STRING(@"mobile") attributes:@{NSForegroundColorAttributeName: color}];
        self.usernameTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:GET_STRING(@"username") attributes:@{NSForegroundColorAttributeName: color}];
        self.passwordTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:GET_STRING(@"Password") attributes:@{NSForegroundColorAttributeName: color}];
        self.nationalityTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:GET_STRING(@"nationality") attributes:@{NSForegroundColorAttributeName: color}];
        self.preferredLanguageTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:GET_STRING(@"pLanguage") attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
    
    self.dateLabel.textColor = Red_UIColor;
    
    [self configureProfileImageView];
}

- (void) femaleTapped{

    self.isMale = NO;
    self.switchBtn.selected = YES ;
    self.maleLabel.textColor =  [UIColor darkGrayColor];
    self.femaleLabel.textColor = Red_UIColor;
}

- (void) maleTapped{
    self.switchBtn.selected = NO ;
    self.maleLabel.textColor = Red_UIColor;
    self.femaleLabel.textColor = [UIColor darkGrayColor];
    self.isMale = YES;
}

- (void) configrueNationalityAutoCompelete{
    self.nationalityTxt.delegate = self;
    self.nationalityTxt.autoCompleteDataSource = self;
    self.nationalityTxt.autoCompleteDelegate = self;
    self.nationalityTxt.autoCompleteTableBorderColor = Red_UIColor;
    self.nationalityTxt.autoCompleteTableBorderWidth = 2;
    self.nationalityTxt.autoCompleteTableBackgroundColor = [UIColor whiteColor];
    self.nationalityTxt.autoCompleteTableAppearsAsKeyboardAccessory = YES;
    self.nationalityTxt.autoCompleteTableCellTextColor = [UIColor blackColor];
    [self.nationalityTxt setTintColor:Red_UIColor];
    if (KIS_ARABIC) {
        self.nationalityTxt.textAlignment = NSTextAlignmentRight ;
    }
}

- (void) configureData{
    __block RegisterViewController*blockSelf = self;
    [[MasterDataManager sharedMasterDataManager] GetNationalitiesByID:@"0" WithSuccess:^(NSMutableArray *array) {
        blockSelf.nationalties = array;
        blockSelf.nationaltiesStringsArray = [NSMutableArray array];
        for (Nationality *nationality in blockSelf.nationalties) {
            if (KIS_ARABIC) {
                [blockSelf.nationaltiesStringsArray addObject:nationality.NationalityArName];
            }else{
                [blockSelf.nationaltiesStringsArray addObject:nationality.NationalityEnName];
            }
        }
        [[MasterDataManager sharedMasterDataManager] GetPrefferedLanguagesWithSuccess:^(NSMutableArray *array) {
            [KVNProgress dismiss];
            blockSelf.languages = array;
        } Failure:^(NSString *error) {
            [blockSelf handleManagerFailure];
        }];
    } Failure:^(NSString *error) {
        [blockSelf handleManagerFailure];
    }];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
}

- (void) handleManagerFailure{
    [KVNProgress dismiss];
    [KVNProgress showErrorWithStatus:@"Error"];
    [self performBlock:^{
        [KVNProgress dismiss];
    } afterDelay:3];
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
    if(textField.text.length == 0 ){
        [self addRedBorderToView:textField.superview];
    }
    else{
        [self addGreyBorderToView:textField.superview];
    }
    
    if (textField == self.firstNametxt){
        [self isValidFirstName];
    }
    else if (textField == self.lastNametxt){
        [self isValidLastName];
    }
    else if (textField == self.mobileNumberTxt){
        [self isValidMobileNumber];
    }
    else if (textField == self.nationalityTxt){
        [self isValidNationality];
    }
    return [self textSouldEndEditing];
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField{
    NSInteger nextTag = textField.tag + 10;
    // Try to find next responder
    if (nextTag == Nationality_Tag) {
        [textField resignFirstResponder];
    }
    UIResponder* nextResponder = [self.view viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
//    return YES;
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
//    [self.view endEditing:YES];
    if (textField == self.nationalityTxt){
        return YES;
//        [self showPickerWithTextFieldType:NationalityTextField];
    }
    else if (textField == self.preferredLanguageTxt){
        [self showPickerWithTextFieldType:LanguageTextField];
    }
    else{
        return YES;
    }
    return NO;
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField == self.mobileNumberTxt){
        if (textField.text.length < 9) {
            return YES;
        }
        return NO;
    }
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

#pragma Pickers
- (void) showPickerWithTextFieldType:(TextFieldType)type{
    RMAction *selectAction = [RMAction actionWithTitle:GET_STRING(@"Select") style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        UIPickerView *picker = ((RMPickerViewController *)controller).picker;
        NSInteger selectedRow = [picker selectedRowInComponent:0];
        switch (picker.tag) {
            case NationalityTextField:
            {
                Nationality *nationality = [self.nationalties objectAtIndex:selectedRow];
                if (KIS_ARABIC) {
                    self.nationalityTxt.text = nationality.NationalityArName;
                }else{
                    self.nationalityTxt.text = nationality.NationalityEnName;
                }

                self.selectedNationality = nationality;
                [self configureBorders];
            }
                break;
            case LanguageTextField:
            {
                Language *language = [self.languages objectAtIndex:selectedRow];
                if (KIS_ARABIC) {
                    self.preferredLanguageTxt.text = language.LanguageArName;

                }else{
                    self.preferredLanguageTxt.text = language.LanguageEnName;

                }
                self.selectedLanguage = language;
            }
                break;
            default:
                break;
        }
        [self configureBorders];
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
        default:
            break;
    }
    //Now just present the picker controller using the standard iOS presentation method
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void)showDatePicker{
    
    [self.view endEditing:YES];
    __block RegisterViewController *blockSelf = self;
    RMAction *selectAction = [RMAction actionWithTitle:GET_STRING(@"Select") style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        NSDate *date =  ((UIDatePicker *)controller.contentView).date;
        
        blockSelf.dateFormatter.dateFormat = @"dd, MMM, yyyy";
        NSString * dateString = [self.dateFormatter stringFromDate:date];
        self.dateLabel.text = dateString;
        blockSelf.date = date;
        if (([[HelpManager sharedHelpManager] yearsBetweenDate:[NSDate date] andDate:blockSelf.date] < 18)){
            UIAlertView *alertView = [[UIAlertView  alloc] initWithTitle:@"" message:GET_STRING(@"You should be older than 18 Years") delegate:self cancelButtonTitle:GET_STRING(@"Ok") otherButtonTitles:nil, nil];
            [alertView show];
            self.date = nil;
            [self configureBorders];
        }
        else if ([[HelpManager sharedHelpManager] isDateBefor1900:self.date]){
            UIAlertView *alertView = [[UIAlertView  alloc] initWithTitle:@"" message:GET_STRING(@"You cannot choose year before 1900") delegate:self cancelButtonTitle:GET_STRING(@"Ok") otherButtonTitles:nil, nil];
            [alertView show];
            self.date = nil;
            [self configureBorders];
        }
        else{
            [self configureBorders];
        }
    }];
    
    //Create cancel action
    RMAction *cancelAction = [RMAction actionWithTitle:GET_STRING(@"Cancel") style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        
    }];
    
    //Create date selection view controller
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleWhite selectAction:selectAction andCancelAction:cancelAction];
    dateSelectionController.title = @"select date of birth";
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeDate;
    dateSelectionController.datePicker.date = [NSDate date];
    
    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:dateSelectionController animated:YES completion:nil];
}

#pragma Actions
- (IBAction)registerAction:(id)sender
{
    self.userName = self.usernameTxt.text;
    self.password = self.passwordTxt.text;
    self.firstName = self.firstNametxt.text;
    self.lastName = self.lastNametxt.text;
    self.mobileNumber = self.mobileNumberTxt.text;

    BOOL validNationality = [self.nationaltiesStringsArray containsObject:self.nationalityTxt.text];
    if (validNationality){
        self.selectedNationality = [self.nationalties objectAtIndex:[self.nationaltiesStringsArray indexOfObject:self.nationalityTxt.text]];
    }
    
    if(self.accountType == AccountTypeNone){
        UIAlertView *alertView = [[UIAlertView  alloc] initWithTitle:NSLocalizedString(@"", nil) message:GET_STRING(@"Please Choose account type.") delegate:self cancelButtonTitle:GET_STRING(@"Ok") otherButtonTitles:nil, nil];
        [alertView show];
    }
    else if(self.firstName.length == 0 || self.lastName.length == 0 || self.userName.length == 0 || self.mobileNumber.length == 0 || !self.date || !self.selectedLanguage){
        UIAlertView *alertView = [[UIAlertView  alloc] initWithTitle:NSLocalizedString(@"", nil) message:GET_STRING(@"Please fill all fields") delegate:self cancelButtonTitle:GET_STRING(@"Ok") otherButtonTitles:nil, nil];
        [alertView show];
        [self configureBorders];
    }
    else if (![self isValidFirstName]){
        [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"First name mustn't have numbers")];
    }
    else if (![self isValidLastName]){
        [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"Last name mustn't have numbers")];
    }
    else if (![self isValidMobileNumber]){
        [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"Mobile Number should be only 9 and should start with [50 – 55 – 56 – 52]")];
    }
    else if (![self IsValidEmail:self.userName]){
        UIAlertView *alertView = [[UIAlertView  alloc] initWithTitle:NSLocalizedString(@"", nil) message:GET_STRING(@"Please enter a valid email address") delegate:self cancelButtonTitle:GET_STRING(@"Ok") otherButtonTitles:nil, nil];
        self.userName = @"";
        [alertView show];
        [self configureBorders];
    }
    else if (![self isValidPassword]){
        UIAlertView *alertView = [[UIAlertView  alloc] initWithTitle:NSLocalizedString(@"", nil) message:GET_STRING(@"Password must be at least 5 characters") delegate:self cancelButtonTitle:GET_STRING(@"Ok") otherButtonTitles:nil, nil];
        [alertView show];
        [self configureBorders];
    }
    else if (([[HelpManager sharedHelpManager] yearsBetweenDate:[NSDate date] andDate:self.date] < 18)){
        UIAlertView *alertView = [[UIAlertView  alloc] initWithTitle:NSLocalizedString(@"", nil) message:GET_STRING(@"You should be older than 18 Years") delegate:self cancelButtonTitle:GET_STRING(@"Ok") otherButtonTitles:nil, nil];
        [alertView show];
        self.date = nil;
        [self configureBorders];
    }
    else if ([[HelpManager sharedHelpManager] isDateBefor1900:self.date]){
        UIAlertView *alertView = [[UIAlertView  alloc] initWithTitle:NSLocalizedString(@"", nil) message:GET_STRING(@"You cannot choose year before 1900") delegate:self cancelButtonTitle:GET_STRING(@"Ok") otherButtonTitles:nil, nil];
        [alertView show];
        self.date = nil;
        [self configureBorders];
    }
    else if (!validNationality){
        UIAlertView *alertView = [[UIAlertView  alloc] initWithTitle:NSLocalizedString(@"", nil) message:GET_STRING(@"Please Choose a valid nationality.") delegate:self cancelButtonTitle:GET_STRING(@"Ok") otherButtonTitles:nil, nil];
        [alertView show];
    }

    else{
        if (self.profileImage) {
            [KVNProgress showWithStatus:GET_STRING(@"Loading...")];
            UploadImageManager *imageManager = [[UploadImageManager alloc] initWithImage:self.profileImage Success:^(NSString *fileName) {
                if (self.accountType == AccountTypeDriver ||self.accountType == AccountTypeBoth){
                    [self registerDriverWithPhotoName:fileName];
                }
                else if (self.accountType == AccountTypePassenger){
                    [self registerPassengerWithPhotoName:fileName];
                }
            } Failure:^(NSString *error) {
                [KVNProgress dismiss];
                if (self.accountType == AccountTypeDriver ||self.accountType == AccountTypeBoth){
                    [self registerDriverWithPhotoName:@""];
                }
                else if (self.accountType == AccountTypePassenger){
                    [self registerPassengerWithPhotoName:@""];
                }
            }];
            [imageManager uploadPhoto];
        }
        else{
            if (self.accountType == AccountTypeDriver ||self.accountType == AccountTypeBoth){
                [self registerDriverWithPhotoName:@""];
            }
            else if (self.accountType == AccountTypePassenger){
                [self registerPassengerWithPhotoName:@""];
            }
        }
    }
}

- (void) registerDriverWithPhotoName:(NSString *)photoName{
    self.dateFormatter.dateFormat = @"dd/MM/yyyy";
    NSString *dateString = [self.dateFormatter stringFromDate:self.date];
    [KVNProgress showWithStatus:GET_STRING(@"Loading...")];
    [[MobAccountManager sharedMobAccountManager] registerDriverWithFirstName:self.firstName lastName:self.lastName mobile:self.mobileNumber username:self.userName password:self.password gender:self.isMale ? @"M":@"F" imagePath:photoName birthDate:dateString nationalityID:self.selectedNationality.ID PreferredLanguageId:self.selectedLanguage.LanguageId WithSuccess:^(NSMutableArray *array) {
        [KVNProgress dismiss];
        [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"Registration done successfully")];
        [self loginAfterRegisteration];
    } Failure:^(NSString *error) {
        [KVNProgress dismiss];
        [[HelpManager sharedHelpManager] showAlertWithMessage:error];
    }];
}

- (void) registerPassengerWithPhotoName:(NSString *)photoName{
    self.dateFormatter.dateFormat = @"dd/MM/yyyy";
    NSString *dateString = [self.dateFormatter stringFromDate:self.date];
    [KVNProgress showWithStatus:GET_STRING(@"Loading...")];
    [[MobAccountManager sharedMobAccountManager] registerPassengerWithFirstName:self.firstName lastName:self.lastName mobile:self.mobileNumber username:self.userName password:self.password gender:self.isMale ? @"M":@"F" imagePath:photoName birthDate:dateString nationalityID:self.selectedNationality.ID PreferredLanguageId:self.selectedLanguage.LanguageId WithSuccess:^(NSMutableArray *array) {
        [KVNProgress dismiss];
        [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"Registration done successfully")];
        [self loginAfterRegisteration];
    } Failure:^(NSString *error) {
        [KVNProgress dismiss];
        [[HelpManager sharedHelpManager] showAlertWithMessage:error];
    }];

}

- (IBAction)selectHumanType:(id)sender{
    switch ([sender tag]) {
        case 99:
            [self.driverBtn    setSelected:YES];
            [self.passengerBtn setSelected:NO];
            [self.bothBtn    setSelected:NO];
            self.driverLbl.textColor = [UIColor whiteColor];
            self.passengerLbl.textColor = [UIColor darkGrayColor];
            self.bothLbl.textColor = [UIColor darkGrayColor];
            self.accountType = AccountTypeDriver;
            break;
        case 100:
            [self.passengerBtn setSelected:YES];
            [self.driverBtn    setSelected:NO];
            [self.bothBtn    setSelected:NO];
            self.driverLbl.textColor = [UIColor darkGrayColor];
            self.passengerLbl.textColor = [UIColor whiteColor];
            self.bothLbl.textColor = [UIColor darkGrayColor];
            self.accountType = AccountTypePassenger;
            break;
        case 101:
            [self.driverBtn    setSelected:NO];
            [self.passengerBtn setSelected:NO];
            [self.bothBtn    setSelected:YES];
            self.driverLbl.textColor = [UIColor darkGrayColor];
            self.passengerLbl.textColor = [UIColor darkGrayColor];
            self.bothLbl.textColor = [UIColor whiteColor];
            self.accountType = AccountTypeBoth;
            break;
        default:
            break;
    }
}

- (IBAction)termsAction:(id)sender {
    SharekniWebViewController *webViewController = [[SharekniWebViewController alloc] initWithNibName:@"SharekniWebViewController" bundle:nil];
    webViewController.type = WebViewTermsAndConditionsType;
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (IBAction)privacyAction:(id)sender {
    SharekniWebViewController *webViewController = [[SharekniWebViewController alloc] initWithNibName:@"SharekniWebViewController" bundle:nil];
    webViewController.type = WebViewPrivacyType;
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (IBAction)selectGender:(id)sender{
    UIButton *btn = (UIButton*)sender ;
    
    if (btn.selected)
    {
        self.switchBtn.selected = NO ;
        self.maleLabel.textColor = Red_UIColor;
        self.femaleLabel.textColor = [UIColor darkGrayColor];
        self.isMale = YES;
    }else{
        self.isMale = NO;
        self.switchBtn.selected = YES ;
        self.maleLabel.textColor =  [UIColor darkGrayColor];
        self.femaleLabel.textColor = Red_UIColor;;
    }
}

- (void) loginAfterRegisteration{
    [KVNProgress showWithStatus:GET_STRING(@"Loading...")];
    [[MobAccountManager sharedMobAccountManager] checkLoginWithUserName:self.userName andPassword:self.password WithSuccess:^(User *user) {
        [KVNProgress dismiss];
        if (user) {
            [self presentViewController:[self homeViewController] animated:YES completion:nil];
        }
    } Failure:^(NSString *error) {
        [KVNProgress dismiss];
    }];
}

#pragma PickerViewDeelgate&DataSource
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *title = @"";
    switch (pickerView.tag) {
        case NationalityTextField:
        {
            Nationality *nationality = [self.nationalties objectAtIndex:row];
            if (KIS_ARABIC) {
                title = nationality.NationalityArName;
            }else{
                title = nationality.NationalityEnName;
            }
        }
            break;
        case LanguageTextField:
        {
            Language *language = [self.languages objectAtIndex:row];
            if (KIS_ARABIC)
            {
                title = language.LanguageArName;
            }else{
                title = language.LanguageEnName;
            }

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

#pragma HomeViewController

- (void) mainViewController{
    
}

#pragma Borders
- (void) configureBorders{
    
    self.userName = self.usernameTxt.text;
    self.password = self.passwordTxt.text;
    self.firstName = self.firstNametxt.text;
    self.lastName = self.lastNametxt.text;
    self.mobileNumber = self.mobileNumberTxt.text;
    
    if (self.firstName.length == 0) {
        [self addRedBorderToView:self.firstNameView];
    }
    else{
        [self addGreyBorderToView:self.firstNameView];
    }
    
    if(self.lastName.length == 0){
        [self addRedBorderToView:self.lastNameView];
    }
    else{
        [self addGreyBorderToView:self.lastNameView];
    }
    
    if(self.userName.length == 0){
        [self addRedBorderToView:self.userNameView];
    }
    else{
        [self addGreyBorderToView:self.userNameView];
    }
    
    if(self.password.length == 0){
        [self addRedBorderToView:self.passwordView];
    }
    else{
        [self addGreyBorderToView:self.passwordView];
    }
    
    if(self.mobileNumber.length == 0){
        [self addRedBorderToView:self.mobileNumberView];
    }
    else{
        [self addGreyBorderToView:self.mobileNumberView];
    }
    BOOL validNationality = [self.nationaltiesStringsArray containsObject:self.nationalityTxt.text];
    if (!validNationality){
        [self addRedBorderToView:self.nationalityView];
    }
    else{
        [self addGreyBorderToView:self.nationalityView];
    }
    
    if (!self.selectedLanguage){
        [self addRedBorderToView:self.languageView];
    }
    else{
        [self addGreyBorderToView:self.languageView];
    }
    
    if (!self.date){
        [self addRedBorderToView:self.datePickerView];
    }
    else{
        [self addGreyBorderToView:self.datePickerView];
    }
    
    if (![self isValidPassword]){
        [self addRedBorderToView:self.passwordView];
    }
    else{
        [self addGreyBorderToView:self.passwordView];
    }
}

- (void) addRedBorderToView :(UIView *)view{
    view.layer.borderWidth = .5;
    view.layer.borderColor = Red_UIColor.CGColor;
}

- (void) addGreyBorderToView :(UIView *)view{
    view.layer.borderWidth = .5;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void) removeBorderFromView:(UIView *)view{
    view.layer.borderWidth = 0;
}

#pragma ProfileImage

- (void) configureProfileImageView{
    [self.profileImageView setUserInteractionEnabled:YES];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
    self.profileImageView.clipsToBounds = YES;
    UITapGestureRecognizer *profileImageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileImageTapped)];
    [self.profileImageView addGestureRecognizer:profileImageGesture];
}

- (void) profileImageTapped{
    UIActionSheet *imageSourceOptions;
    
    imageSourceOptions = [[UIActionSheet alloc]
                          initWithTitle:nil
                          delegate:nil
                          cancelButtonTitle:GET_STRING(@"Cancel")
                          destructiveButtonTitle:nil
                          otherButtonTitles:
                          GET_STRING(@"Photo Library"),
                          GET_STRING(@"Camera"),nil];
    imageSourceOptions.delegate = self;
    [imageSourceOptions showInView:self.view];
}

- (IBAction)uploadPhotoHandler:(id)sender {
    UIActionSheet *imageSourceOptions;
    
    imageSourceOptions = [[UIActionSheet alloc]
                          initWithTitle:nil
                          delegate:nil
                          cancelButtonTitle:GET_STRING(@"Cancel")
                          destructiveButtonTitle:nil
                          otherButtonTitles:
                          GET_STRING(@"Photo Library"),
                          GET_STRING(@"Camera"),nil];
    imageSourceOptions.delegate = self;
    [imageSourceOptions showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIImagePickerControllerSourceType source;
    
    if(buttonIndex == 0)
    {
        source = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if (buttonIndex == 1)
    {
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [[[UIAlertView alloc] initWithTitle:nil message:GET_STRING(@"No camera on device") delegate:nil cancelButtonTitle:GET_STRING(@"Ok") otherButtonTitles:nil] show];
            return;
        }
        source = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        return;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.sourceType = source;
    imagePickerController.delegate = self;
    if (source != UIImagePickerControllerSourceTypeCamera) {
        imagePickerController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController];
}

#pragma mark UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.profileImage = [info valueForKey:UIImagePickerControllerEditedImage];
    self.profileImageView.image = self.profileImage;
    self.profileImageView.hidden = NO;
    self.uploadButton.hidden = YES;
    [self saveProfileImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ImagePicker Delegate

- (void) imagePickerControllerDidSelectImage:(UIImage *)image withIconName:(NSString *)iconName{
    
    self.profileImage = image;
    self.profileImageView.image = self.profileImage;
    self.profileImageView.hidden = NO;
    self.uploadButton.hidden = YES;
    [self saveProfileImage];    
}

- (void) presentViewController:(UIViewController*)viewController{
    if ([viewController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController*)viewController).sourceType == UIImagePickerControllerSourceTypeCamera) {
    }
    else {
        viewController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void) saveProfileImage{
    
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

#pragma Validation

- (BOOL) isValidFirstName{
    
    NSString *firstName = self.firstNametxt.text;
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    if ([firstName rangeOfCharacterFromSet:set].location != NSNotFound) {
        [self addRedBorderToView:self.firstNameView];
        return NO;
    }
   [self addGreyBorderToView:self.firstNameView];
    return YES;
}

- (BOOL) isValidLastName{
    
    NSString *lastName = self.lastNametxt.text;
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    if ([lastName rangeOfCharacterFromSet:set].location != NSNotFound) {
        [self addRedBorderToView:self.lastNameView];
        return NO;
    }
    [self addGreyBorderToView:self.lastNameView];
    return YES;
}

- (BOOL) isValidMobileNumber{
    NSArray *begins = @[@"50",@"55",@"56",@"52"];
    NSString *mobileNumber = self.mobileNumberTxt.text;
    NSString *begin = [mobileNumber substringToIndex:mobileNumber.length > 2 ? 2 : 0];
    
    if (mobileNumber.length != 9) {
        [self addRedBorderToView:self.mobileNumberView];
        return NO;
    }
    else if (![begins containsObject:begin]){
        [self addRedBorderToView:self.mobileNumberView];
        return NO;
    }
    else{
        [self addGreyBorderToView:self.mobileNumberView];
        return YES;
    }
    return YES;
}

-(BOOL) IsValidEmail:(NSString *)checkString{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (BOOL) isValidNationality{
    BOOL validNationality = [self.nationaltiesStringsArray containsObject:self.nationalityTxt.text];
    if (!validNationality) {
        [self addRedBorderToView:self.nationalityView];
        return NO;
    }
    [self addGreyBorderToView:self.nationalityView];
    return YES;
}

- (BOOL) isValidPassword{
    if (self.passwordTxt.text.length < 5) {
        return NO;
    }
    return YES;
}

- (REFrostedViewController *) homeViewController {
    
    HomeViewController *homeViewControlle = [[HomeViewController alloc] initWithNibName:(KIS_ARABIC)?@"HomeViewController_ar":@"HomeViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeViewControlle];
    SideMenuTableViewController  *menuController = [[SideMenuTableViewController alloc] initWithNavigationController:navigationController];
    
    
    // Create frosted view controller
    //
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.liveBlur = YES;
    frostedViewController.delegate = self;
    
    return frostedViewController;
}

#pragma TextFields

- (void) configureTextFields{
    
    self.firstNametxt.inputAccessoryView = self.inputAccessoryView;
    self.lastNametxt.inputAccessoryView = self.inputAccessoryView;
    self.mobileNumberTxt.inputAccessoryView = self.inputAccessoryView;
    self.usernameTxt.inputAccessoryView = self.inputAccessoryView;
    
    UITapGestureRecognizer *dismissGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doneTapped)];
    [self.view addGestureRecognizer:dismissGesture];
}

- (UIToolbar *)inputAccessoryView{
    if (!_inputAccessoryView) {
        _inputAccessoryView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        _inputAccessoryView.barStyle = UIBarStyleDefault;
        _inputAccessoryView.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTapped)],
                         nil];
        [_inputAccessoryView sizeToFit];
    }
    return _inputAccessoryView;
}

- (void) doneTapped{
    [self.view endEditing:YES];
}

@end
