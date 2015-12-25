//
//  ForgetPasswordViewController.m
//  sharekni
//
//  Created by Ahmed Askar on 11/17/15.
//
//

#import "ForgetPasswordViewController.h"
#import "MobAccountManager.h"
#import <KVNProgress.h>
#import <UIColor+Additions.h>
#import "Constants.h"
#import "HelpManager.h"
#import "RegisterViewController.h"
#import "CreateRideViewController.h"
#import "HomeViewController.h"
#import <REFrostedViewController.h>
#import "SideMenuTableViewController.h"
#import "NSObject+Blocks.h"

@interface ForgetPasswordViewController ()<UITextFieldDelegate,REFrostedViewControllerDelegate>
{
    float animatedDistance ;
}

@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = GET_STRING(@"forget");
    
    UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(0, 0, 22, 22);
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"Back_icn"] forState:UIControlStateNormal];
    [_backBtn setHighlighted:NO];
    [_backBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
    
    self.navigationController.navigationBarHidden = NO ;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    [self configureUI];

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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) configureUI{
    if ([self.mobileTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor add_colorWithRGBHexString:Red_HEX];
        self.mobileTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:GET_STRING(@"mobileReq") attributes:@{NSForegroundColorAttributeName: color}];
        self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:GET_STRING(@"mailReq") attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
    
    [self.submitButton setBackgroundColor:Red_UIColor];
    [self.submitButton setTitle:GET_STRING(@"Submit") forState:UIControlStateNormal];
    self.submitButton.layer.cornerRadius = 8;
    
}

- (IBAction)forgetAction:(id)sender
{
    [self.view endEditing:YES];

    if(self.mobileTextField.text.length == 0){
  
        [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"mobileReq")];
    }
    else if (self.emailTextField.text.length == 0)
    {
        [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"mailReq")];
    }
    else
    {
        [KVNProgress showWithStatus:GET_STRING(@"Loading...")];
        
        __block ForgetPasswordViewController *blockSelf = self;
        [[MobAccountManager sharedMobAccountManager] forgetPassword:self.mobileTextField.text andEmail:self.emailTextField.text WithSuccess:^(NSString *user) {
            [KVNProgress dismiss];
            if (user) {
                [KVNProgress showSuccessWithStatus:user];
            }else{
                [KVNProgress dismiss];
            }
            
        } Failure:^(NSString *error) {
            [KVNProgress dismiss];
            [KVNProgress showErrorWithStatus:error];
            [blockSelf performBlock:^{
                [KVNProgress dismiss];
            } afterDelay:3];
        }];
    }
}


#pragma TextFieldDelegate
#pragma mark - TextFieldDelegate

// This code handles the scrolling when tabbing through infput fields
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 220;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 140;
//when clicking the return button in the keybaord
- (BOOL)textFieldShouldEndEditing:(UITextField*)textField
{
    return [self textSouldEndEditing];
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField  resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    [self textDidBeginEditing:textFieldRect];
}

- (void)textDidBeginEditing:(CGRect)textRect
{
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textRect.origin.y + 0.5 * textRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

- (BOOL)textSouldEndEditing
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIView* view in self.view.subviews) {
        for (UIGestureRecognizer* recognizer in view.gestureRecognizers) {
            [recognizer addTarget:self action:@selector(touchEvent:)];
        }
        
        [self.view endEditing:YES];
    }
}

- (void)touchEvent:(id)sender
{
    
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
