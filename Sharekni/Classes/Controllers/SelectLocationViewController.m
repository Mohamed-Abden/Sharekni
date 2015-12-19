//
//  selectLocationViewController.m
//  Sharekni
//
//  Created by ITWORX on 10/7/15.
//
//

#import "SelectLocationViewController.h"
#import "HelpManager.h"
#import "MasterDataManager.h"
#import "Constants.h"
#import <KVNProgress/KVNProgress.h>
#import "NSObject+Blocks.h"
#import <UIColor+Additions.h>
#import <RMActionController.h>
#import <RMPickerViewController.h>
#import "MLPAutoCompleteTextField.h"
#import "MLPAutoCompleteTextFieldDataSource.h"
#import "MLPAutoCompleteTextFieldDelegate.h"
#import <MZFormSheetController.h>
#import "UIView+Borders.h"

typedef enum DirectionType : NSUInteger {
    DirectionTypeTo,
    DirectionTypeFrom
} DirectionType;

@interface SelectLocationViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,MLPAutoCompleteTextFieldDelegate,MLPAutoCompleteTextFieldDataSource>

@property (weak, nonatomic) IBOutlet UIButton *fromEmirateButton;

@property (weak, nonatomic) IBOutlet UIButton *toEmirateButton;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *containerViews;


@property (weak, nonatomic) IBOutlet MLPAutoCompleteTextField *fromRegionTextField;
@property (weak, nonatomic) IBOutlet MLPAutoCompleteTextField *toRegionTextField;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *titleLabels;

@property (weak, nonatomic) IBOutlet UIButton *DoneButton;

@property (nonatomic,strong) NSArray *emirates;
@property (nonatomic,strong) NSArray *fromRegions;
@property (nonatomic,strong) NSArray *toRegions;
@property (nonatomic,strong) NSMutableArray *fromRegionsStringsArray;
@property (nonatomic,strong) NSMutableArray *toRegionsStringsArray;

@property (nonatomic,strong) Emirate *selectedFromEmirate;
@property (nonatomic,strong) Region *selectedFromRegion;

@property (nonatomic,strong) Emirate *selectedToEmirate;
@property (nonatomic,strong) Region *selectedToRegion;

@end

@implementation SelectLocationViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [self configureData];
    [self configureUI];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void) configureData{
    __block SelectLocationViewController *blockSelf = self;
    [KVNProgress showWithStatus:GET_STRING(@"loading")];
    [[MasterDataManager sharedMasterDataManager] GetEmiratesWithSuccess:^(NSMutableArray *array) {
        blockSelf.emirates = array;
        [KVNProgress dismiss];
    } Failure:^(NSString *error) {
        NSLog(@"Error in Emirates");
        [KVNProgress dismiss];
        [KVNProgress showErrorWithStatus:GET_STRING(@"Error")];
        [blockSelf performBlock:^{
            [KVNProgress dismiss];
        } afterDelay:3];
    }];
}

- (void) configureRegionsWithDirectionType:(DirectionType)type{
    Emirate *emirate = type == DirectionTypeFrom ? self.selectedFromEmirate:self.selectedToEmirate;
    if (emirate) {
        __block SelectLocationViewController *blockSelf = self;
        [KVNProgress showWithStatus:GET_STRING(@"loading")];
        [[MasterDataManager sharedMasterDataManager] GetRegionsByEmirateID:emirate.EmirateId withSuccess:^(NSMutableArray *array) {
            if (type == DirectionTypeFrom) {
                blockSelf.fromRegions = array;
                blockSelf.fromRegionsStringsArray=  [NSMutableArray array];
                for (Region *region in array) {
                    [blockSelf.fromRegionsStringsArray addObject:(KIS_ARABIC)?region.RegionArName:region.RegionEnName];
                }
            }
            else{
                blockSelf.toRegions = array;
                blockSelf.toRegionsStringsArray=  [NSMutableArray array];
                for (Region *region in array) {
                    [blockSelf.toRegionsStringsArray addObject:(KIS_ARABIC)?region.RegionArName:region.RegionEnName];
                }
            }
            [KVNProgress dismiss];
        } Failure:^(NSString *error) {
            [KVNProgress dismiss];
            [KVNProgress showErrorWithStatus:GET_STRING(@"Error")];
            [blockSelf performBlock:^{
                [KVNProgress dismiss];
            } afterDelay:3];
        }];
    }
}

- (void) configureUI{
    
    self.navigationItem.title = GET_STRING(@"Set Direction");
    
    UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(0, 0, 22, 22);
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"Back_icn"] forState:UIControlStateNormal];
    [_backBtn setHighlighted:NO];
    [_backBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
    
    
    for (UILabel *titleLabel in self.titleLabels) {
        titleLabel.textColor = Red_UIColor;
        [titleLabel addRightBorderWithColor:Red_UIColor];
        [titleLabel addLeftBorderWithColor:Red_UIColor];
        titleLabel.backgroundColor = [UIColor whiteColor];
    }
    
    for (UIView *containerView in self.containerViews) {
        containerView.layer.cornerRadius = 20;
        containerView.layer.borderWidth = 1;
        containerView.layer.borderColor = Red_UIColor.CGColor;
        containerView.backgroundColor = [UIColor whiteColor];
    }
    
    [self.fromEmirateButton setBackgroundColor:[UIColor whiteColor]];
     self.fromEmirateButton.layer.cornerRadius = 10;
    [self.fromEmirateButton setTitleColor:Red_UIColor forState:UIControlStateNormal];
    [self.fromEmirateButton setTitle:GET_STRING(@"Select Emirate") forState:UIControlStateNormal];
    self.fromEmirateButton.layer.borderWidth = .8;
    self.fromEmirateButton.layer.borderColor = [UIColor lightGrayColor].CGColor;

    [self.toEmirateButton setBackgroundColor:[UIColor whiteColor]];
     self.toEmirateButton.layer.cornerRadius = 10;
    [self.toEmirateButton setTitleColor:Red_UIColor forState:UIControlStateNormal];
    [self.toEmirateButton setTitle:GET_STRING(@"Select Emirate") forState:UIControlStateNormal];
    self.toEmirateButton.layer.borderWidth = .8;
    self.toEmirateButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.fromRegionTextField.delegate = self;
    self.fromRegionTextField.autoCompleteDataSource = self;
    self.fromRegionTextField.autoCompleteDelegate = self;
    self.fromRegionTextField.autoCompleteTableBorderColor = Red_UIColor;
    self.fromRegionTextField.autoCompleteTableBorderWidth = 2;
    self.fromRegionTextField.autoCompleteTableBackgroundColor = [UIColor whiteColor];
    self.fromRegionTextField.autoCompleteTableAppearsAsKeyboardAccessory = YES;
    [self.fromRegionTextField setTintColor:Red_UIColor];
    self.toRegionTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    if (KIS_ARABIC)
    {
        self.fromRegionTextField.textAlignment = NSTextAlignmentRight ;
        self.toRegionTextField.textAlignment   = NSTextAlignmentRight ;
    }
    
    self.toRegionTextField.delegate = self;
    self.toRegionTextField.autoCompleteDataSource = self;
    self.toRegionTextField.autoCompleteDelegate = self;
    self.toRegionTextField.autoCompleteTableBorderColor = Red_UIColor;
    self.toRegionTextField.autoCompleteTableBorderWidth = 2;
    self.toRegionTextField.autoCompleteTableBackgroundColor = [UIColor whiteColor];
    self.toRegionTextField.autoCompleteTableAppearsAsKeyboardAccessory = YES;
    [self.toRegionTextField setTintColor:Red_UIColor];
    self.toRegionTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    UITapGestureRecognizer *dismissGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissHandler)];
    [self.view addGestureRecognizer:dismissGestureRecognizer];
    
    self.DoneButton.layer.cornerRadius = 8;
    [self.DoneButton setBackgroundColor:Red_UIColor];
    [self.DoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)DoneAction:(id)sender
{
    if (!self.selectedFromEmirate)
    {
      [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"Please select from Emirate")];
    }
    else if (self.fromRegionTextField.text.length == 0)
    {
      [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"Please Enter from Region")];
    }
    else if (![self.fromRegionsStringsArray containsObject:self.fromRegionTextField.text])
    {
      [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"Please Enter Valid from Region Name")];
    }
    else
    {
        if(self.selectedToEmirate || self.selectedToRegion || self.validateDestination)
        {
            if (!self.selectedToEmirate) {
                [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"Please select to Emirate")];
            }
            else if (self.toRegionTextField.text.length == 0)
            {
                [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"Please Enter to Region")];
                
            }
            else if (![self.toRegionsStringsArray containsObject:self.toRegionTextField.text]){
                [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"Please enter a valid to region name")];
            }else{
                NSInteger fromRegionIndex = [self.fromRegionsStringsArray indexOfObject:self.fromRegionTextField.text];
                self.selectedFromRegion = [self.fromRegions objectAtIndex:fromRegionIndex];
                NSInteger toRegionIndex = [self.toRegionsStringsArray indexOfObject:self.toRegionTextField.text];
                self.selectedToRegion = [self.toRegions objectAtIndex:toRegionIndex];
                
                self.selectionHandler(self.selectedFromEmirate,self.selectedFromRegion,self.selectedToEmirate,self.selectedToRegion);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else{
            NSInteger fromRegionIndex = [self.fromRegionsStringsArray indexOfObject:self.fromRegionTextField.text];
            self.selectedFromRegion = [self.fromRegions objectAtIndex:fromRegionIndex];
            NSInteger toRegionIndex = [self.toRegionsStringsArray indexOfObject:self.toRegionTextField.text];
            self.selectedToRegion = [self.toRegions objectAtIndex:toRegionIndex];
            
            self.selectionHandler(self.selectedFromEmirate,self.selectedFromRegion,self.selectedToEmirate,self.selectedToRegion);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void) dismissHandler{
    [self.view endEditing:YES];
}

- (void) showEmiratePickerForType:(DirectionType)type{
    __block SelectLocationViewController *blockSelf = self;
    RMAction * selectAction = [RMAction actionWithTitle:GET_STRING(@"Select Emirate")  style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        UIPickerView *picker = ((RMPickerViewController *)controller).picker;
        if (type == DirectionTypeFrom) {
            self.selectedFromEmirate = [self.emirates objectAtIndex:[picker selectedRowInComponent:0]];
            [blockSelf.fromEmirateButton setTitle:(KIS_ARABIC)?self.selectedFromEmirate.EmirateArName:self.selectedFromEmirate.EmirateEnName forState:UIControlStateNormal];
        }
        else{
            self.selectedToEmirate = [self.emirates objectAtIndex:[picker selectedRowInComponent:0]];
            [blockSelf.toEmirateButton setTitle:(KIS_ARABIC)?self.selectedToEmirate.EmirateArName:self.selectedToEmirate.EmirateEnName forState:UIControlStateNormal];
        }
        [blockSelf configureRegionsWithDirectionType:type];
    }];
    
    RMAction *cancelAction = [RMAction actionWithTitle:GET_STRING(@"Cancel") style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        NSLog(@"Row selection was canceled");
    }];
    
    //Create picker view controller
    RMPickerViewController *pickerController = [RMPickerViewController actionControllerWithStyle:RMActionControllerStyleDefault selectAction:selectAction andCancelAction:cancelAction];
    
    pickerController.picker.delegate = self;
    pickerController.picker.dataSource = self;
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

#pragma PickerViewDelgate&DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.emirates.count;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Emirate *emirate = [self.emirates objectAtIndex:row];
    return  (KIS_ARABIC)?emirate.EmirateArName:emirate.EmirateEnName;
}

#pragma TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.fromRegionTextField)
    {
        if (!self.selectedFromEmirate)
        {
            [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"Please select from Emirate first")];
            return NO;
        }
        return YES;
    }
    
    if (textField == self.toRegionTextField)
    {
        if (!self.selectedToEmirate) {
            [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"Please select to Emirate first")];
            return NO;
        }
        return YES;
    }
    return NO;
}



#pragma AutoCompelete_Delegate
- (BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
shouldStyleAutoCompleteTableView:(UITableView *)autoCompleteTableView
               forBorderStyle:(UITextBorderStyle)borderStyle
{
    return YES;
}

- (NSArray *)autoCompleteTextField:(MLPAutoCompleteTextField *)textField possibleCompletionsForString:(NSString *)string{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",string]; // if you need case sensitive search avoid '[c]' in the predicate
    NSArray * dataSourceArray ;
    if (textField == self.fromRegionTextField) {
        dataSourceArray = self.fromRegionsStringsArray;
    }
    else{
        dataSourceArray = self.toRegionsStringsArray;
    }
    NSArray *results = [dataSourceArray filteredArrayUsingPredicate:predicate];
    return results;
}

- (IBAction)choosFromEmirateHandler:(id)sender
{
    [self showEmiratePickerForType:DirectionTypeFrom];
}

- (IBAction)chooseToEmirateHandler:(id)sender
{
    [self showEmiratePickerForType:DirectionTypeTo];
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
- (BOOL)textFieldShouldEndEditing:(UITextField*)textField
{
    return [self textSouldEndEditing];
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField  resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
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
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

- (BOOL)textSouldEndEditing
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIView* view in self.view.subviews)
    {
        for (UIGestureRecognizer* recognizer in view.gestureRecognizers)
        {
            [recognizer addTarget:self action:@selector(touchEvent:)];
        }
        
        [self.view endEditing:YES];
    }
}

- (void)touchEvent:(id)sender{
    
}



@end
