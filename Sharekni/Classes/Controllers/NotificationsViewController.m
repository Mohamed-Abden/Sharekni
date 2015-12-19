//
//  NotificationsViewController.m
//  sharekni
//
//  Created by Ahmed Askar on 11/20/15.
//
//

#import "NotificationsViewController.h"
#import "MessageUI/MessageUI.h"
#import "Constants.h"
#import <KVNProgress/KVNProgress.h>
#import "NSObject+Blocks.h"
#import <UIColor+Additions.h>
#import "MasterDataManager.h"
#import "HelpManager.h"
#import "MasterDataManager.h"
#import "MobAccountManager.h"
#import "User.h"
#import "NotificationCell.h"
#import "NotificationDetailsViewController.h"
#import "Constants.h"

@interface NotificationsViewController () <ReloadNotificationsDelegate>

@property (nonatomic ,weak) IBOutlet UITableView *notificationsList ;
@property (nonatomic ,strong) NSMutableArray *notifications;
@property (nonatomic ,strong) Notification *toBeDeletedNotification;
@end

@implementation NotificationsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = GET_STRING(@"Notifications");

    self.notifications = [NSMutableArray new];
    [self getNotifications2];
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)getNotifications
{
    User *user = [[MobAccountManager sharedMobAccountManager] applicationUser];
    
    __block NotificationsViewController *blockSelf = self;
    [KVNProgress showWithStatus:GET_STRING(@"loading")];
    
    [[MasterDataManager sharedMasterDataManager] getRequestNotifications:[NSString stringWithFormat:@"%@",user.ID] notificationType:NotificationTypeAlert WithSuccess:^(NSMutableArray *array) {
        
        blockSelf.notifications = array;

        [self.notificationsList reloadData];
        
        [self getAcceptedNotifications];
        
        
    } Failure:^(NSString *error) {
        NSLog(@"Error in Notifications");
        [KVNProgress dismiss];
        [KVNProgress showErrorWithStatus:GET_STRING(@"Error")];
        [blockSelf performBlock:^{
            [KVNProgress dismiss];
        } afterDelay:3];
    }];
}

- (void)getAcceptedNotifications{
    User *user = [[MobAccountManager sharedMobAccountManager] applicationUser];
    
    __block NotificationsViewController *blockSelf = self;
    [KVNProgress showWithStatus:GET_STRING(@"loading")];
    
    [[MasterDataManager sharedMasterDataManager] getRequestNotifications:[NSString stringWithFormat:@"%@",user.ID] notificationType:NotificationTypeAccepted WithSuccess:^(NSMutableArray *array) {
        
        [self.notifications addObjectsFromArray:array];

        [KVNProgress dismiss];
        
        [self.notificationsList reloadData];
        
    } Failure:^(NSString *error) {
        NSLog(@"Error in Notifications");
        [KVNProgress dismiss];
        [KVNProgress showErrorWithStatus:@"Error"];
        [blockSelf performBlock:^{
            [KVNProgress dismiss];
        } afterDelay:3];
    }];
}

- (void) getNotifications2{
    User *user = [[MobAccountManager sharedMobAccountManager] applicationUser];
    
    __block NotificationsViewController *blockSelf = self;
    [KVNProgress showWithStatus:GET_STRING(@"loading")];
    
    [[MasterDataManager sharedMasterDataManager] getRequestNotifications:user.ID.stringValue notificationType:NotificationTypeAlert WithSuccess:^(NSMutableArray *array) {
        
        blockSelf.notifications = array;
        [blockSelf.notificationsList reloadData];
        
        [[MasterDataManager sharedMasterDataManager] getRequestNotifications:user.ID.stringValue notificationType:NotificationTypeAccepted WithSuccess:^(NSMutableArray *array) {
            
            [blockSelf.notifications addObjectsFromArray:array];
            [blockSelf.notificationsList reloadData];
            
            [[MasterDataManager sharedMasterDataManager] getRequestNotifications:user.ID.stringValue notificationType:NotificationTypePending WithSuccess:^(NSMutableArray *array) {
                [KVNProgress dismiss];
                [blockSelf.notifications addObjectsFromArray:array];
                [blockSelf.notificationsList reloadData];
            } Failure:^(NSString *error) {
                [blockSelf handleNetworkFailure];
            }];
        } Failure:^(NSString *error) {
            [blockSelf handleNetworkFailure];
        }];
    } Failure:^(NSString *error) {
        [blockSelf handleNetworkFailure];
    }];
}

- (void) handleNetworkFailure{
    __block NotificationsViewController *blockSelf = self;
    NSLog(@"Error in Notifications");
    [KVNProgress dismiss];
    [KVNProgress showErrorWithStatus:GET_STRING(@"Error")];
    [blockSelf performBlock:^{
        [KVNProgress dismiss];
    } afterDelay:3];
}

- (void)reloadNotifications
{
    [self getNotifications2];
}

#pragma mark -
#pragma mark UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.notifications.count;
}

- (NotificationCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier  = @"NotificationCell";
    
    NotificationCell *notificationCell = (NotificationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (notificationCell == nil)
    {
        notificationCell = (NotificationCell *)[[[NSBundle mainBundle] loadNibNamed:@"NotificationCell" owner:nil options:nil] objectAtIndex:(KIS_ARABIC)?1:0];
    }
    
    Notification *notification = self.notifications[indexPath.row];
    [notificationCell setNotification:notification];

    return notificationCell ;
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Notification *notification = self.notifications[indexPath.row];

    if (notification.isPending) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"do you want to delete this request ?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
        alertView.tag = 1010;
        [alertView show];
        self.toBeDeletedNotification = notification;

    }
    else{
        NotificationDetailsViewController *notificationDetails = [[NotificationDetailsViewController alloc] initWithNibName:(KIS_ARABIC)?@"NotificationDetailsViewController_ar":@"NotificationDetailsViewController" bundle:nil];
        notificationDetails.delegate = self ;
        notificationDetails.notification = notification ;
        [self.navigationController pushViewController:notificationDetails animated:YES];
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0){
    if(alertView.tag == 1010){
        __block NotificationsViewController *blockSelf = self;
        if(self.toBeDeletedNotification && buttonIndex == 1){
            [KVNProgress showWithStatus:GET_STRING(@"loading")];
            [[MasterDataManager sharedMasterDataManager] deleteRequestWithID:self.toBeDeletedNotification.RequestId.stringValue WithSuccess:^(BOOL deleted) {
                [KVNProgress dismiss];
                if(deleted){
                    [KVNProgress showSuccessWithStatus:@"Request deleted successfully"];
                }
                else{

                    __block NotificationsViewController *blockSelf = self;
                    [KVNProgress dismiss];
                    [KVNProgress showErrorWithStatus :@"cannot delete Request"];
                    [blockSelf performBlock:^{
                        [KVNProgress dismiss];
                    } afterDelay:3];
                }
                [blockSelf getNotifications2];
            } Failure:^(NSString *error) {
                __block NotificationsViewController *blockSelf = self;
                [KVNProgress dismiss];
                [KVNProgress showErrorWithStatus :@"cannot delete Request"];
                [blockSelf performBlock:^{
                    [KVNProgress dismiss];
                } afterDelay:3];
            }];
        }
    }
}

@end
