//
//  SavedSearchViewController.m
//  sharekni
//
//  Created by Ahmed Askar on 11/20/15.
//
//

#import "SavedSearchViewController.h"
#import "MessageUI/MessageUI.h"
#import "DriverRideCell.h"
#import "Constants.h"
#import <KVNProgress/KVNProgress.h>
#import "NSObject+Blocks.h"
#import <UIColor+Additions.h>
#import "MasterDataManager.h"
#import "RideDetailsViewController.h"
#import "DriverDetailsViewController.h"
#import "SearchResultsViewController.h"
#import "MobDriverManager.h"
#import "HelpManager.h"
#import "User.h"
#import "MobAccountManager.h"

@interface SavedSearchViewController ()
@property (weak, nonatomic) IBOutlet UILabel *noResultLabel;

@property (nonatomic ,weak) IBOutlet UITableView *driverList ;
@property (nonatomic ,strong) NSMutableArray *savedData ;

@end

@implementation SavedSearchViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = GET_STRING(@"Saved Search");
    self.noResultLabel.textColor = Red_UIColor;
    self.noResultLabel.alpha = 0;
    [self getRideDetails];
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

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getRideDetails
{
    User *user = [[MobAccountManager sharedMobAccountManager] applicationUser];
    
    __block SavedSearchViewController *blockSelf = self;
    [KVNProgress showWithStatus:GET_STRING(@"loading")];
    [[MasterDataManager sharedMasterDataManager] getSavedSearch:[NSString stringWithFormat:@"%@",user.ID] withSuccess:^(NSMutableArray *array) {
        
        blockSelf.savedData = array;
        [self.driverList reloadData];
        if (array.count == 0) {
            self.noResultLabel.alpha = 1;
        }
        else{
            self.noResultLabel.alpha = 0;
        }
        
        [KVNProgress dismiss];

    } Failure:^(NSString *error) {
        NSLog(@"Error in Best Drivers");
        [KVNProgress dismiss];
        [KVNProgress showErrorWithStatus:@"Error"];
        [blockSelf performBlock:^{
            [KVNProgress dismiss];
        } afterDelay:3];
    }];
}

#pragma mark -
#pragma mark UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.savedData.count;
}

- (DriverRideCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DriverRideCell *driverCell = (DriverRideCell *)[tableView dequeueReusableCellWithIdentifier:RIDE_CELLID];
    
    if (driverCell == nil)
    {
        driverCell = [[DriverRideCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:RIDE_CELLID];
    }
    
    MostRideDetails *driverDetails = self.savedData[indexPath.row];
    [driverCell setSavedResultRideDetails:driverDetails];
    
    return driverCell ;
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MostRideDetails *ride = self.savedData[indexPath.row];

        __block SavedSearchViewController *blockSelf = self;
    
    [KVNProgress showWithStatus:GET_STRING(@"Loading...")];
    
        [[MobDriverManager sharedMobDriverManager] findRidesFromEmirateID:ride.FromEmirateId andFromRegionID:ride.FromRegionId toEmirateID:ride.ToEmirateId andToRegionID:ride.ToRegionId PerfferedLanguageID:@"0" nationalityID:@"" ageRangeID:@"0" date:nil isPeriodic:nil saveSearch:nil WithSuccess:^(NSArray *searchResults) {
    
            [KVNProgress dismiss];
            
            if(searchResults)
            {
                SearchResultsViewController *resultViewController = [[SearchResultsViewController alloc] initWithNibName:(KIS_ARABIC)?@"SearchResultsViewController_ar":@"SearchResultsViewController" bundle:nil];
                resultViewController.results = searchResults;
                resultViewController.fromEmirate = (KIS_ARABIC)?ride.FromEmirateArName:ride.FromEmirateEnName;
                resultViewController.toEmirate = (KIS_ARABIC)?ride.ToEmirateArName:ride.ToEmirateEnName;
                resultViewController.fromRegion = (KIS_ARABIC)?ride.FromRegionArName:ride.FromRegionEnName;
                resultViewController.toRegion = (KIS_ARABIC)?ride.ToRegionArName:ride.ToRegionEnName;
                [blockSelf.navigationController pushViewController:resultViewController animated:YES];
            }
            else
            {
                [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"No Rides Found")];
            }
        } Failure:^(NSString *error) {
            [KVNProgress dismiss];
        }];
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
