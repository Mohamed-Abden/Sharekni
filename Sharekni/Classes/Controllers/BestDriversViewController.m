//
//  BestDriversViewController.m
//  Sharekni
//
//  Created by Ahmed Askar on 9/26/15.
//
//

#import "BestDriversViewController.h"
#import "BestDriverCell.h"
#import "HelpManager.h"
#import "MasterDataManager.h"
#import "Region.h"
#import "Emirate.h"
#import "Constants.h"
#import <KVNProgress/KVNProgress.h>
#import "NSObject+Blocks.h"
#import <UIColor+Additions.h>
#import "NSObject+Blocks.h"
#import "MessageUI/MessageUI.h"
#import "DriverDetailsViewController.h"

@interface BestDriversViewController () <SendSMSDelegate,MFMessageComposeViewControllerDelegate>

@property (nonatomic ,weak) IBOutlet UITableView *driversList ;
@property (nonatomic ,strong) NSMutableArray *bestDrivers ;

@end

@implementation BestDriversViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO ;
    
    self.title = GET_STRING(@"bestDrivers");
    [self getBestDrivers];
}

#pragma mark - Methods
- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getBestDrivers
{
    __block BestDriversViewController *blockSelf = self;
    [KVNProgress showWithStatus:GET_STRING(@"loading")];
    [[MasterDataManager sharedMasterDataManager] GetBestDrivers:^(NSMutableArray *array) {
        blockSelf.bestDrivers = array;
        [KVNProgress dismiss];
        [self.driversList reloadData];
        
    } Failure:^(NSString *error) {
        NSLog(@"Error in Best Drivers");
        [KVNProgress dismiss];
        [KVNProgress showErrorWithStatus:@"Error"];
        [blockSelf performBlock:^{
            [KVNProgress dismiss];
        } afterDelay:3];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.bestDrivers.count;
}

- (BestDriverCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *driverIdentifier = @"BestDriverCell";
    BestDriverCell *driverCell = (BestDriverCell*)[tableView dequeueReusableCellWithIdentifier:driverIdentifier];
    if (driverCell == nil) {
        driverCell = (BestDriverCell *)[[[NSBundle mainBundle] loadNibNamed:@"BestDriverCell" owner:nil options:nil] objectAtIndex:(KIS_ARABIC)?1:0];

        driverCell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    driverCell.delegate = self ;
    BestDriver *driver = self.bestDrivers[indexPath.row];
    [driverCell setDriver:driver];
    
    return driverCell ;
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BestDriver *driver = self.bestDrivers[indexPath.row];
    DriverDetailsViewController *driverDetails = [[DriverDetailsViewController alloc] initWithNibName:(KIS_ARABIC)?@"DriverDetailsViewController_ar":@"DriverDetailsViewController" bundle:nil];
    driverDetails.isBestDriver = YES ;
    driverDetails.bestDriver = driver;
    [self.navigationController pushViewController:driverDetails animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 91;
}

#pragma mark - Message Delegate
- (void)sendSMSFromPhone:(NSString *)phone
{
    if(![MFMessageComposeViewController canSendText])
    {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = @[phone];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void) messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch(result)
    {
        case MessageComposeResultCancelled: break; //handle cancelled event
        case MessageComposeResultFailed: break; //handle failed event
        case MessageComposeResultSent: break; //handle sent event
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
