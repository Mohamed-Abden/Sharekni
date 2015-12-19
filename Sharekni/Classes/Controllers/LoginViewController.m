//
//  LoginViewController.m
//  Sharekni
//
//  Created by Ahmed Askar on 9/25/15.
//
//

#import "LoginViewController.h"
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
#import "ForgetPasswordViewController.h"

@interface LoginViewController ()<UITextFieldDelegate,REFrostedViewControllerDelegate>
{
    float animatedDistance ;
}
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *registerNewButton;
@property (weak, nonatomic) IBOutlet UIView *sepratorView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = GET_STRING(@"login");
    
    UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(0, 0, 22, 22);
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"Back_icn"] forState:UIControlStateNormal];
    [_backBtn setHighlighted:NO];
    [_backBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
    
    self.navigationController.navigationBarHidden = NO ;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    [self configureUI];

//    self.usernameTextField.text = @"yasmin@gmail.com";
//    self.passwordTextField.text = @"12345";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)popViewController{
    if (_isLogged) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void) configureUI{
    if ([self.usernameTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor add_colorWithRGBHexString:Red_HEX];
        self.usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:GET_STRING(@"Username (Your Email)") attributes:@{NSForegroundColorAttributeName: color}];
        self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:GET_STRING(@"Password") attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
    
    [self.forgotPasswordButton setTitleColor:Red_UIColor forState:UIControlStateNormal];
    [self.registerNewButton setTitleColor:Red_UIColor forState:UIControlStateNormal];
    self.sepratorView.backgroundColor = Red_UIColor;
    self.loginButton.layer.cornerRadius = 8;
    
}

- (IBAction)loginAction:(id)sender
{
    [self.view endEditing:YES];
    if(self.usernameTextField.text.length == 0)
    {
        [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"nameReq")];
    }
    else if (self.passwordTextField.text.length == 0)
    {
        [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"passReq")];
    }
    else
    {
        [KVNProgress showWithStatus:GET_STRING(@"Loading...")];
        [[MobAccountManager sharedMobAccountManager] checkLoginWithUserName:self.usernameTextField.text andPassword:self.passwordTextField.text WithSuccess:^(User *user) {
            [KVNProgress dismiss];
            if (user) {
                if (_isLogged) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }else{
                    REFrostedViewController *frostedViewController = [self mainViewController];
                    [self.navigationController presentViewController:frostedViewController animated:YES completion:nil];
                }
            }
            else{
            [[HelpManager sharedHelpManager] showAlertWithMessage:GET_STRING(@"Please check your username and password")];
            }
        } Failure:^(NSString *error) {
            [[HelpManager sharedHelpManager] showAlertWithMessage:error];
            [KVNProgress dismiss];
        }];
    }
}

- (IBAction)signupAction:(id)sender{
    [self.view endEditing:YES];
    RegisterViewController *registerView = [[RegisterViewController alloc] initWithNibName:(KIS_ARABIC)?@"RegisterViewController_ar":@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:registerView animated:YES];
}

- (IBAction)forgotPasswordAction:(id)sender
{
    ForgetPasswordViewController *forgetPass = [[ForgetPasswordViewController alloc] initWithNibName:@"ForgetPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:forgetPass animated:YES];
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
- (BOOL)textFieldShouldEndEditing:(UITextField*)textField{
    return [self textSouldEndEditing];
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField{
    [textField  resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    [self textDidBeginEditing:textFieldRect];
}

- (void)textDidBeginEditing:(CGRect)textRect{
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

- (BOOL)textSouldEndEditing{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UIView* view in self.view.subviews) {
        for (UIGestureRecognizer* recognizer in view.gestureRecognizers) {
            [recognizer addTarget:self action:@selector(touchEvent:)];
        }
        
        [self.view endEditing:YES];
    }
}

- (void)touchEvent:(id)sender{
    
}

- (REFrostedViewController *) mainViewController
{
    HomeViewController *homeViewControlle = [[HomeViewController alloc] initWithNibName:(KIS_ARABIC)?@"HomeViewController_ar":@"HomeViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeViewControlle];
    SideMenuTableViewController  *menuController = [[SideMenuTableViewController alloc] initWithNavigationController:navigationController];
    
    
    // Create frosted view controller
    //
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.liveBlur = YES;
    frostedViewController.delegate = self;
    
    return frostedViewController;
}

@end
