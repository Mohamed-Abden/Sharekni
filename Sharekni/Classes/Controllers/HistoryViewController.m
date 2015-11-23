//
//  HistoryViewController.m
//  sharekni
//
//  Created by Ahmed Askar on 11/23/15.
//
//

#import "HistoryViewController.h"
#import "Constants.h"
#import "MobAccountManager.h"
#import "RideHistoryCell.h"
#import <KVNProgress.h>
#import "RideDetailsViewController.h"
#import "NSObject+Blocks.h"
#import "UIView+Borders.h"
#import "UIView+Borders.h"
#import "Constants.h"
#import <UIColor+Additions/UIColor+Additions.h>
#import "RideDetailsViewController.h"
#import "DriverDetailsViewController.h"

@interface HistoryViewController ()
{
    __weak IBOutlet UILabel *createdLblName;
    __weak IBOutlet UILabel *joinedLblName;
    __weak IBOutlet UIView *createdView;
    __weak IBOutlet UIView *joinedView;
}

@property (nonatomic ,weak) IBOutlet UIScrollView *contentView ;
@property (nonatomic ,weak) IBOutlet UITableView *createdRidesList ;
@property (nonatomic ,weak) IBOutlet UITableView *joinRidesList ;
@property (nonatomic ,strong) NSMutableArray *createdRides ;
@property (nonatomic ,strong) NSMutableArray *joinRides ;

@end

@implementation HistoryViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"History";
    
    UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(0, 0, 22, 22);
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"Back_icn"] forState:UIControlStateNormal];
    [_backBtn setHighlighted:NO];
    [_backBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
   
    [self configureUI];
    [self getCreatedRides];
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configureUI
{
    self.createdRidesList.tag = 0 ;
    self.joinRidesList.tag = 1 ;
    
    [createdLblName addRightBorderWithColor:Red_UIColor];
    [createdLblName addLeftBorderWithColor:Red_UIColor];
    
    [joinedLblName addRightBorderWithColor:Red_UIColor];
    [joinedLblName addLeftBorderWithColor:Red_UIColor];
    
    createdView.layer.cornerRadius = 20;
    createdView.layer.borderWidth = 1;
    createdView.layer.borderColor = Red_UIColor.CGColor;
    
    joinedView.layer.cornerRadius = 20;
    joinedView.layer.borderWidth = 1;
    joinedView.layer.borderColor = Red_UIColor.CGColor;
}

- (void) getCreatedRides
{
    __block HistoryViewController  *blockSelf = self;
    [KVNProgress showWithStatus:NSLocalizedString(@"Loading...", nil)];
    
    [[MobAccountManager sharedMobAccountManager] getCreatedRidesWithSuccess:^(NSMutableArray *array) {
        [KVNProgress dismiss];
        blockSelf.createdRides = array;

        [self getJoinedRides];
        
    } Failure:^(NSString *error) {
        [KVNProgress dismiss];
        [KVNProgress showErrorWithStatus:@"An error occured when getting your created rides."];
        [blockSelf performBlock:^{
            [KVNProgress dismiss];
        } afterDelay:3];
    }];
}

- (void) getJoinedRides
{
    __block HistoryViewController *blockSelf = self;
    [[MobAccountManager sharedMobAccountManager] getJoinedRidesWithSuccess:^(NSMutableArray *array) {
        blockSelf.joinRides = array;
        
        if (self.createdRides.count > 0) {
            
            self.createdRidesList.frame = CGRectMake(self.createdRidesList.frame.origin.x, self.createdRidesList.frame.origin.y, self.createdRidesList.frame.size.width, self.createdRides.count *183.0f);
            [self.createdRidesList reloadData];

            createdView.frame = CGRectMake(createdView.frame.origin.x, createdView.frame.origin.y, createdView.frame.size.width, self.createdRides.count *183.0f + 27.0f);
            
            [self.contentView setContentSize:CGSizeMake(self.contentView.frame.size.width,createdView.frame.origin.y + createdView.frame.size.height)];
            
            if (self.joinRides.count > 0)
            {
                joinedLblName.frame = CGRectMake(joinedLblName.frame.origin.x, createdView.frame.origin.y + createdView.frame.size.height + 9.0f, joinedLblName.frame.size.width, joinedLblName.frame.size.height);
                
                self.joinRidesList.frame = CGRectMake(self.joinRidesList.frame.origin.x, self.joinRidesList.frame.origin.y, self.joinRidesList.frame.size.width, self.joinRides.count *183.0f);
                
                joinedView.frame = CGRectMake(joinedView.frame.origin.x, createdView.frame.origin.y + createdView.frame.size.height +27.0f, joinedView.frame.size.width, self.joinRidesList.frame.size.height + 27.0f);
                
                [self.contentView setContentSize:CGSizeMake(self.contentView.frame.size.width,joinedView.frame.origin.y + joinedView.frame.size.height + 20.0f)];
                
                [self.joinRidesList reloadData];
            }
        }
        
    } Failure:^(NSString *error) {
        [blockSelf handleManagerFailure];
    }];
}

- (void) handleManagerFailure
{
    [KVNProgress dismiss];
    [KVNProgress showErrorWithStatus:@"Error"];
    [self performBlock:^{
        [KVNProgress dismiss];
    } afterDelay:3];
}

#pragma mark -
#pragma mark UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex{
    if (tableView.tag == 0)
    {
        return self.createdRides.count;
    }
    else
    {
        return self.joinRides.count;
    }
}

- (RideHistoryCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier  = @"RideHistoryCell";
    
    RideHistoryCell *rideCell = (RideHistoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (rideCell == nil)
    {
        rideCell = (RideHistoryCell *)[[[NSBundle mainBundle] loadNibNamed:@"RideHistoryCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    if (tableView.tag == 0)
    {
        CreatedRide *ride = self.createdRides[indexPath.row];
        [rideCell setCreatedRide:ride];
        return rideCell ;
    }
    else
    {
        Ride *ride = self.joinRides[indexPath.row];
        [rideCell setJoinedRide:ride];
        return rideCell ;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 183;
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    CreatedRide *ride = self.createdRides[indexPath.row];
    if (tableView.tag == 0)
    {
        CreatedRide *ride = self.createdRides[indexPath.row];
        RideDetailsViewController *rideDetails = [[RideDetailsViewController alloc] initWithNibName:@"RideDetailsViewController" bundle:nil];
        rideDetails.createdRide = ride ;
        [self.navigationController pushViewController:rideDetails animated:YES];
    }
    else
    {
        Ride *ride = self.joinRides[indexPath.row];
        DriverDetailsViewController *driverDetails = [[DriverDetailsViewController alloc] initWithNibName:@"DriverDetailsViewController" bundle:nil];
        driverDetails.joinedRide = ride ;
        [self.navigationController pushViewController:driverDetails animated:YES];
    }
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