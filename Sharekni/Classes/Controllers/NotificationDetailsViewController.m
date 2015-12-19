//
//  NotificationDetailsViewController.m
//  sharekni
//
//  Created by Ahmed Askar on 11/22/15.
//
//

#import "NotificationDetailsViewController.h"
#import "Constants.h"
#import <KVNProgress/KVNProgress.h>
#import "NSObject+Blocks.h"
#import "MobDriverManager.h"
#import "MobAccountManager.h"

@interface NotificationDetailsViewController ()
{
    __weak IBOutlet UILabel *remarks;
    __weak IBOutlet UILabel *routeName;
    __weak IBOutlet UILabel *passengerName;
    __weak IBOutlet UILabel *requestDate;
    __weak IBOutlet UILabel *passengerPhone;
    __weak IBOutlet UILabel *nationality;
    __weak IBOutlet UIImageView *userImage ;
    __weak IBOutlet UIButton *acceptBtn;
    __weak IBOutlet UIButton *declineBtn;
}
@end

@implementation NotificationDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = GET_STRING(@"Notification Details");
    
    UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(0, 0, 22, 22);
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"Back_icn"] forState:UIControlStateNormal];
    [_backBtn setHighlighted:NO];
    [_backBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
    
    if([self.notification.DriverAccept boolValue])
    {
        acceptBtn.hidden = YES ;
        declineBtn.hidden = YES ;
    }
    
    userImage.layer.cornerRadius = userImage.frame.size.width / 2.0f ;
    userImage.clipsToBounds = YES ;
    
    passengerName.text = self.notification.DriverName ;
    nationality.text = self.notification.NationalityEnName ;
    passengerPhone.text = self.notification.PassengerMobile ;
    routeName.text = self.notification.RouteName ;
    requestDate.text = self.notification.RequestDate ;
    remarks.text = self.notification.Remarks ;
    if (self.notification.image) {
        userImage.image = self.notification.image ;
    }else{
        userImage.image = [UIImage imageNamed:@"thumbnail.png"] ;
    }
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)declineReqquest:(id)sender
{
    [KVNProgress showWithStatus:GET_STRING(@"Loading...")];
    [[MobAccountManager sharedMobAccountManager] acceptRequest:[NSString stringWithFormat:@"%@",self.notification.RequestId] andIsAccepted:@"0" WithSuccess:^(NSString *response) {
        
        [KVNProgress dismiss];
        [self popViewController];
        [self.delegate reloadNotifications];

    } Failure:^(NSString *error) {
//        NSLog(@"Error in Best Drivers");
        [KVNProgress dismiss];
        [KVNProgress showErrorWithStatus:@"an error occured when trying to accept request please try again ."];
    }];
}

- (IBAction)acceptRequest:(id)sender
{
    [KVNProgress showWithStatus:GET_STRING(@"Loading...")];
    [[MobAccountManager sharedMobAccountManager] acceptRequest:[NSString stringWithFormat:@"%@",self.notification.RequestId] andIsAccepted:@"1" WithSuccess:^(NSString *response) {
        
        [KVNProgress dismiss];
        [self popViewController];
        [self.delegate reloadNotifications];
        
    } Failure:^(NSString *error) {
        NSLog(@"Error in Best Drivers");
        [KVNProgress dismiss];
        [KVNProgress showErrorWithStatus:@"Error"];
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
