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
    viewText.text = GET_STRING(@"I’d like to join your ride");
    
    if (KIS_ARABIC)
    {
        viewText.textAlignment = NSTextAlignmentRight ;
        self.headerTitle2.textAlignment = NSTextAlignmentRight;
    }
    
    [self.headerTitle setText:GET_STRING(@"Write Your Remarks")];
    [self.headerTitle2 setText:GET_STRING(@"Your Remarks")];
    [self.submitBtn setTitle:GET_STRING(@"Submit") forState:UIControlStateNormal];
}

- (void)HideKeyboard
{
    [viewText resignFirstResponder];
}

- (IBAction)closePopup:(id)sender
{
    if (viewText.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:GET_STRING(@"Attention") message:GET_STRING(@"You must write your remark first") delegate:nil cancelButtonTitle:GET_STRING(@"Ok") otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }
    
    [KVNProgress showWithStatus:GET_STRING(@"Loading...")];
    
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
