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
@property (nonatomic,strong) UIToolbar *inputAccessoryView;
@end

@implementation VerifyMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.container.layer.borderColor = [[UIColor grayColor] CGColor];
    self.container.layer.borderWidth = 1 ;
    self.container.layer.cornerRadius = 4;
    
    [verificationCodeTxt becomeFirstResponder];
    if (KIS_ARABIC)
    {
        verificationCodeTxt.textAlignment = NSTextAlignmentRight ;
        self.headerTitle2.textAlignment = NSTextAlignmentRight ;
    }
    
    [verificationCodeTxt setInputAccessoryView:self.inputAccessoryView];
    
    verificationCodeTxt.placeholder = GET_STRING(@"Enter verification code");
    [self.headerTitle setText:GET_STRING(@"Write Your Code")];
    [self.headerTitle2 setText:GET_STRING(@"Your Code")];
    [self.submitBtn setTitle:GET_STRING(@"Submit") forState:UIControlStateNormal];
    [self.resendBtn setTitle:GET_STRING(@"Resend verification code") forState:UIControlStateNormal];
}

- (void)HideKeyboard{
    [verificationCodeTxt resignFirstResponder];
}

- (IBAction)closePopup:(id)sender{
    if (verificationCodeTxt.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:GET_STRING(@"Attention") message:GET_STRING(@"Please write your verification code") delegate:nil cancelButtonTitle:GET_STRING(@"Ok") otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }
    
    [KVNProgress showWithStatus:GET_STRING(@"Loading...")];
    
    [[MobAccountManager sharedMobAccountManager] confirmMobileNumber:self.accountID andCode:verificationCodeTxt.text WithSuccess:^(NSString *user)
    {
        [KVNProgress dismiss];
        
        if ([user containsString:@"1"])
        {
            [KVNProgress showSuccessWithStatus:GET_STRING(@"Mobile Verified")];
            if (self.delegate && [self.delegate respondsToSelector:@selector(dismissButtonClicked:)]) {
                [self.delegate dismissButtonClicked:self];
            }
        }else{
            [KVNProgress showErrorWithStatus:GET_STRING(@"Verification Code is wrong")];
        }

    } Failure:^(NSString *error){
        [KVNProgress dismiss];
    }];
}

- (IBAction)resendVerification:(id)sender{
    [[MobAccountManager sharedMobAccountManager] verifyMobileNumber:self.accountID WithSuccess:^(NSString *user)
     {
         if ([user isEqualToString:@"1"]) {
             [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"Mobile verification code has been sent to your mobile")];
         }
         else
         {
             [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"Please check your mobile number")];
         }
     } Failure:^(NSString *error)
    {
         
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIToolbar *)inputAccessoryView{
    if (!_inputAccessoryView) {
        _inputAccessoryView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        _inputAccessoryView.barStyle = UIBarStyleDefault;
        _inputAccessoryView.items = [NSArray arrayWithObjects:
                                     [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTapped)],
                                     nil];
        [_inputAccessoryView sizeToFit];
    }
    return _inputAccessoryView;
}

- (void) doneTapped{
    [self.view endEditing:YES];
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
