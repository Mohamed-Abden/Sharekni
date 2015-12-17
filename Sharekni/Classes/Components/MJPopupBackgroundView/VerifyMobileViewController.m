//
//  VerifyMobileViewController.m
//  sharekni
//
//  Created by Ahmed Askar on 12/8/15.
//
//

#import "VerifyMobileViewController.h"
#import "MobAccountManager.h"
#import "Constants.h"
#import <KVNProgress/KVNProgress.h>
#import "User.h"
#import "HelpManager.h"

@interface VerifyMobileViewController ()

@end

@implementation VerifyMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.container.layer.borderColor = [[UIColor grayColor] CGColor];
    self.container.layer.borderWidth = 1 ;
    self.container.layer.cornerRadius = 4;
    
    [verificationCodeTxt becomeFirstResponder];
    verificationCodeTxt.textAlignment = NSTextAlignmentNatural ;
    
    verificationCodeTxt.placeholder = NSLocalizedString(@"Enter verification code", nil);
    [self.headerTitle setText:NSLocalizedString(@"Write Your Code", nil)];
    [self.headerTitle2 setText:NSLocalizedString(@"Your Code", nil)];
    [self.submitBtn setTitle:NSLocalizedString(@"Submit", nil) forState:UIControlStateNormal];
    [self.resendBtn setTitle:NSLocalizedString(@"Resend verification code", nil) forState:UIControlStateNormal];
}

- (void)HideKeyboard
{
    [verificationCodeTxt resignFirstResponder];
}

- (IBAction)closePopup:(id)sender
{
    if (verificationCodeTxt.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Attention", nil) message:NSLocalizedString(@"Please write your verification code", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }
    
    [KVNProgress showWithStatus:NSLocalizedString(@"Loading...", nil)];
    
    [[MobAccountManager sharedMobAccountManager] confirmMobileNumber:self.accountID andCode:verificationCodeTxt.text WithSuccess:^(NSString *user) {
        
        [KVNProgress dismiss];
        
        [KVNProgress showSuccessWithStatus:NSLocalizedString(@"Mobile Verified", nil)];

        if ([user containsString:@"1"])
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(dismissButtonClicked:)]) {
                [self.delegate dismissButtonClicked:self];
            }
        }else{
            [KVNProgress showErrorWithStatus:NSLocalizedString(@"Verification Code is wrong", nil)];
        }

    } Failure:^(NSString *error){
        [KVNProgress dismiss];
    }];
}

- (IBAction)resendVerification:(id)sender
{
    [[MobAccountManager sharedMobAccountManager] verifyMobileNumber:self.accountID WithSuccess:^(NSString *user)
     {
         if ([user isEqualToString:@"1"]) {
             [[HelpManager sharedHelpManager] showAlertWithMessage:NSLocalizedString(@"Mobile verification code has been sent to your mobile", nil)];
         }
         else
         {
             [[HelpManager sharedHelpManager] showAlertWithMessage:NSLocalizedString(@"Please check your mobile number", nil)];
         }
     } Failure:^(NSString *error)
    {
         
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
