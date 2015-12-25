//
//  MostRidesViewController.m
//  Sharekni
//
//  Created by Ahmed Askar on 9/26/15.
//
//

#import "MostRidesViewController.h"
#import "MostRidesCell.h"
#import "HelpManager.h"
#import "MasterDataManager.h"
#import <KVNProgress/KVNProgress.h>
#import "NSObject+Blocks.h"
#import <UIColor+Additions.h>
#import "NSObject+Blocks.h"
#import "MostRide.h"
#import "MostRideDetailsViewController.h"
#import <UIViewController+REFrostedViewController.h>
#import <REFrostedViewController.h>

@interface MostRidesViewController ()
@property (nonatomic ,weak) IBOutlet UITableView *ridesList ;
@property (nonatomic ,strong) NSMutableArray *mostRides ;
@end

@implementation MostRidesViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO ;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;

    self.title = GET_STRING(@"Most Rides");
    
    if (self.enableBackButton) {
        UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0, 0, 22, 22);
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"Back_icn"] forState:UIControlStateNormal];
        [_backBtn setHighlighted:NO];
        [_backBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
    }
    else {
        UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(menuItemTapped)];
        self.navigationItem.leftBarButtonItem = menuItem;
    }
    
    [self getMostRides];
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

#pragma mark - Methods
- (void) menuItemTapped{
    [self.frostedViewController presentMenuViewController];
}

#pragma mark - Methods
- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getMostRides
{
    __block MostRidesViewController *blockSelf = self;
    [KVNProgress showWithStatus:GET_STRING(@"loading")];
    [[MasterDataManager sharedMasterDataManager] GetMostRides:^(NSMutableArray *array) {
        blockSelf.mostRides = array;
        [KVNProgress dismiss];
        [self.ridesList reloadData];
        
    } Failure:^(NSString *error) {
        NSLog(@"Error in Most Rides");
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
    return self.mostRides.count;
}

- (MostRidesCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rideIdentifier = @"MostRideCell";
    MostRidesCell *rideCell = (MostRidesCell*)[tableView dequeueReusableCellWithIdentifier:rideIdentifier];
    if (rideCell == nil) {
        rideCell = (MostRidesCell *)[[[NSBundle mainBundle] loadNibNamed:@"MostRidesCell" owner:nil options:nil] objectAtIndex:(KIS_ARABIC)?1:0];
        rideCell.contentView.backgroundColor = [UIColor clearColor];
    }
    MostRide *ride = self.mostRides [indexPath.row];
    [rideCell setRide:ride];
    
    return rideCell ;
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MostRideDetailsViewController *rideDetailsView = [[MostRideDetailsViewController alloc] initWithNibName:@"MostRideDetailsViewController" bundle:nil];
    MostRide *ride = self.mostRides [indexPath.row];
    rideDetailsView.ride = ride ;
    [self.navigationController pushViewController:rideDetailsView animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
