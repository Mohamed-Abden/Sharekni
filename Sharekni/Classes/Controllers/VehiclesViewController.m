//
//  VehiclesViewController.m
//  sharekni
//
//  Created by Ahmed Askar on 11/20/15.
//
//

#import "VehiclesViewController.h"
#import "Constants.h"
#import <UIColor+Additions/UIColor+Additions.h>
#import <RMActionController.h>
#import <RMPickerViewController.h>
#import "HelpManager.h"
#import <RMDateSelectionViewController.h>
#import "MasterDataManager.h"
#import <KVNProgress.h>
#import "NSObject+Blocks.h"
#import "MobAccountManager.h"
#import "SharekniWebViewController.h"
#import "MLPAutoCompleteTextField.h"
#import "UIView+Borders.h"
#import "VehicleViewCell.h"
#import "Vehicle.h"
#import <UIViewController+REFrostedViewController.h>
#import <REFrostedViewController.h>

@interface VehiclesViewController () <UITableViewDataSource ,UITableViewDelegate>
{
    __weak IBOutlet UILabel *titleLabel ;
    __weak IBOutlet UIView *containerView ;
}

@property (weak ,nonatomic) IBOutlet UIView  *vehiclesView ;
@property (weak ,nonatomic) IBOutlet UIView  *vehiclesContainerView ;
@property (weak ,nonatomic) IBOutlet UILabel *vehiclesTitleLabel ;
@property (weak ,nonatomic) IBOutlet UITableView *vehiclesList ;
@property (nonatomic ,strong) NSMutableArray *vehiclesArray ;

@property (weak,nonatomic) IBOutlet UITextField *traficFileNo ;
@property (weak,nonatomic) IBOutlet UILabel *dateLabel ;
@property (weak,nonatomic) IBOutlet UIView *datePickerView ;
@property (strong,nonatomic) NSDate *date ;
@property (strong,nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation VehiclesViewController
- (IBAction)refreshAction:(id)sender {
       [self getAllVehicles];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = NSLocalizedString(@"Vehicles", nil);
    
    if (self.enableBackButton) {
        UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0, 0, 22, 22);
        [_backBtn setBackgroundImage:[UIImage imageNamed:NSLocalizedString(@"Back_icn",nil)] forState:UIControlStateNormal];
        [_backBtn setHighlighted:NO];
        [_backBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
    }
    else {
        UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(menuItemTapped)];
        self.navigationItem.leftBarButtonItem = menuItem;
    }
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"TrafficFileNo"] != nil || [[[MobAccountManager sharedMobAccountManager] applicationUser] DriverTrafficFileNo].length != 0) {
        self.vehiclesView.hidden = YES ;
        containerView.hidden = YES ;
        titleLabel.hidden = YES ;
        
        self.vehiclesTitleLabel.textColor = Red_UIColor;
        [self.vehiclesTitleLabel addRightBorderWithColor:Red_UIColor];
        [self.vehiclesTitleLabel addLeftBorderWithColor:Red_UIColor];
        self.vehiclesTitleLabel.backgroundColor = [UIColor whiteColor];
        
        self.vehiclesContainerView.layer.cornerRadius = 20;
        self.vehiclesContainerView.layer.borderWidth = 1;
        self.vehiclesContainerView.layer.borderColor = Red_UIColor.CGColor;
        self.vehiclesContainerView.backgroundColor = [UIColor whiteColor];
        
        [self getAllVehicles];
        
    }else{
        
        self.vehiclesView.hidden = YES ;
        self.dateFormatter = [[NSDateFormatter alloc] init];
        
        [self configureUI];
    }
}

- (void) menuItemTapped
{
    [self.frostedViewController presentMenuViewController];
}

- (void) popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configureUI
{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDatePicker)];
    [self.datePickerView addGestureRecognizer:gesture];
    [self.dateLabel addGestureRecognizer:gesture];
    [self.dateLabel setUserInteractionEnabled:YES];
    [self.datePickerView setUserInteractionEnabled:YES];
    
    if ([self.traficFileNo respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor add_colorWithRGBHexString:Red_HEX];
        self.traficFileNo.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Traffic File No.", nil) attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        
    }
    
    self.dateLabel.textColor = Red_UIColor;
    
    titleLabel.textColor = Red_UIColor;
    [titleLabel addRightBorderWithColor:Red_UIColor];
    [titleLabel addLeftBorderWithColor:Red_UIColor];
    titleLabel.backgroundColor = [UIColor whiteColor];
    
    containerView.layer.cornerRadius = 20;
    containerView.layer.borderWidth = 1;
    containerView.layer.borderColor = Red_UIColor.CGColor;
    containerView.backgroundColor = [UIColor whiteColor];
}

- (void)getAllVehicles
{
    __block VehiclesViewController *blockSelf = self;
    
    [KVNProgress showWithStatus:NSLocalizedString(@"loading", nil)];
    
    User *user = [[MobAccountManager sharedMobAccountManager] applicationUser];
    
    [[MasterDataManager sharedMasterDataManager] getVehicleById:[NSString stringWithFormat:@"%@",user.ID] WithSuccess:^(NSMutableArray *array) {
        
        blockSelf.vehiclesArray = array;
        
        [KVNProgress dismiss];
        self.vehiclesView.hidden = NO ;
        if (array.count == 0) {
            self.vehiclesView.hidden = YES ;
        }
        self.vehiclesList.dataSource = self ;
        self.vehiclesList.delegate = self ;
        
        [self.vehiclesList reloadData];
        
    } Failure:^(NSString *error) {
        [blockSelf handleResponseError];
    }];
}

- (void) handleResponseError{
    NSLog(@"Error in Best Drivers");
    [KVNProgress dismiss];
    [KVNProgress showErrorWithStatus:@"Error"];
    [self performBlock:^{
        [KVNProgress dismiss];
    } afterDelay:3];
}

#pragma mark - Event Handler
- (IBAction)submit:(id)sender
{
    [KVNProgress showWithStatus:@"Loading..."];
    
    User *sharedUser = [[MobAccountManager sharedMobAccountManager] applicationUser];

    self.dateFormatter.dateFormat = @"dd/MM/yyyy";
    NSString *dateString = [self.dateFormatter stringFromDate:self.date];
    
    [[MobAccountManager sharedMobAccountManager] registerVehicle:[NSString stringWithFormat:@"%@",sharedUser.ID] TrafficFileNo:self.traficFileNo.text BirthDate:dateString WithSuccess:^(NSString *user) {
        
        [KVNProgress dismiss];
        
        //If success
        self.vehiclesView.hidden = YES ;
        containerView.hidden = YES ;
        titleLabel.hidden = YES ;
        
        self.vehiclesTitleLabel.textColor = Red_UIColor;
        [self.vehiclesTitleLabel addRightBorderWithColor:Red_UIColor];
        [self.vehiclesTitleLabel addLeftBorderWithColor:Red_UIColor];
        self.vehiclesTitleLabel.backgroundColor = [UIColor whiteColor];
        
        self.vehiclesContainerView.layer.cornerRadius = 20;
        self.vehiclesContainerView.layer.borderWidth = 1;
        self.vehiclesContainerView.layer.borderColor = Red_UIColor.CGColor;
        self.vehiclesContainerView.backgroundColor = [UIColor whiteColor];
        
        [self getAllVehicles];
        
    } Failure:^(NSString *error) {
        
        [[HelpManager sharedHelpManager] showAlertWithMessage:error];
        
        [KVNProgress dismiss];
        
    }];
}

#pragma mark - Pickers
- (void)showDatePicker
{
    [self.view endEditing:YES];
    __block VehiclesViewController *blockSelf = self;
    RMAction *selectAction = [RMAction actionWithTitle:@"Select" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        NSDate *date =  ((UIDatePicker *)controller.contentView).date;
        
        blockSelf.dateFormatter.dateFormat = @"dd, MMM, yyyy";
        NSString * dateString = [self.dateFormatter stringFromDate:date];
        self.dateLabel.text = dateString;
        blockSelf.date = date;
        if (([[HelpManager sharedHelpManager] yearsBetweenDate:[NSDate date] andDate:blockSelf.date] < 18)){
            UIAlertView *alertView = [[UIAlertView  alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"invalid birthdate", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
            self.date = nil;
        }
    }];
    
    //Create cancel action
    RMAction *cancelAction = [RMAction actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        
    }];
    
    //Create date selection view controller
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleWhite selectAction:selectAction andCancelAction:cancelAction];
    dateSelectionController.title = @"select date of birth";
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeDate;
    dateSelectionController.datePicker.date = [NSDate date];
    
    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:dateSelectionController animated:YES completion:nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.vehiclesArray.count;
}

- (VehicleViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier  = @"VehicleViewCell";
    
    VehicleViewCell *vehicleCell = (VehicleViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (vehicleCell == nil)
    {
        vehicleCell = (VehicleViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"VehicleViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    Vehicle *vehicle = self.vehiclesArray[indexPath.row];
    vehicleCell.countryLbl.text = @"Dubai";
    vehicleCell.numberLbl.text = [NSString stringWithFormat:@"%@ %@",(vehicle.PlateCode)?vehicle.PlateCode:@"",(vehicle.PlateNumber)?vehicle.PlateNumber:@""];
    
    return vehicleCell ;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIView* view in self.view.subviews) {
        for (UIGestureRecognizer* recognizer in view.gestureRecognizers) {
            [recognizer addTarget:self action:@selector(touchEvent:)];
        }
        
        [self.view endEditing:YES];
    }
}

- (void)touchEvent:(id)sender{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
