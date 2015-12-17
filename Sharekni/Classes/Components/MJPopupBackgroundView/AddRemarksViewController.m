//
//  AddRemarksViewController.m
//  sharekni
//
//  Created by Ahmed Askar on 11/20/15.
//
//

#import "AddRemarksViewController.h"
#import "MobAccountManager.h"
#import "Constants.h"
#import <KVNProgress/KVNProgress.h>
#import "User.h"

@interface AddRemarksViewController ()

@end

@implementation AddRemarksViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [viewText becomeFirstResponder];
    viewText.text = NSLocalizedString(@"I’d like to join your ride", nil);
    viewText.textAlignment = NSTextAlignmentNatural ;
    [self.headerTitle setText:NSLocalizedString(@"Write Your Remarks", nil)];
    [self.headerTitle2 setText:NSLocalizedString(@"Your Remarks", nil)];
    [self.submitBtn setTitle:NSLocalizedString(@"Submit", nil) forState:UIControlStateNormal];
}

- (void)HideKeyboard
{
    [viewText resignFirstResponder];
}

- (IBAction)closePopup:(id)sender
{
    if (viewText.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Attention", nil) message:NSLocalizedString(@"You must write your remark first", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }
    
    [KVNProgress showWithStatus:@"Loading...."];
    
    User *user = [[MobAccountManager sharedMobAccountManager] applicationUser];
    
    [[MobAccountManager sharedMobAccountManager] joinRidePassenger:[NSString stringWithFormat:@"%@",user.ID] RouteID:self.driverDetails.RouteId DriverID:self.driverDetails.AccountId Remark:viewText.text WithSuccess:^(NSString *user) {
        
        [KVNProgress dismiss];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(dismissButtonClicked:)]) {
            [self.delegate dismissButtonClicked:self];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(didJoinToRideSuccesfully)]) {
            [self.delegate didJoinToRideSuccesfully];
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
