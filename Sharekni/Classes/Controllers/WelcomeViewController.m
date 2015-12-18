//
//  WelcomeViewController.m
//  Sharekni
//
//  Created by Ahmed Askar on 9/22/15.
//
//

#import "WelcomeViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "SearchViewController.h"
#import "BestDriversViewController.h"
#import "MostRidesViewController.h"
#import <UIColor+Additions.h>
#import "Constants.h"
#import "TourViewController.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "Languages.h"

@interface WelcomeViewController ()
{
    NSArray* language ;
}
@property (weak, nonatomic) IBOutlet UIView *mostRidesView;
@property (weak, nonatomic) IBOutlet UIView *bestDriversView;

@property (weak, nonatomic) IBOutlet UIButton *enBtn;
@property (weak, nonatomic) IBOutlet UIButton *arBtn;

@end

@implementation WelcomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"sharkni", nil);
    self.title = GET_STRING(@"sharkni");
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBarHidden = NO ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO ;
    [self.navigationItem setHidesBackButton:YES];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    [self configureUI];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void) configureUI
{
    self.navigationController.navigationBar.translucent = YES;
    
    language = [NSArray new];
    
    self.bestDriversView.layer.cornerRadius = 10;
    self.bestDriversView.layer.borderWidth = 1.5;
    self.bestDriversView.layer.borderColor = Red_UIColor.CGColor;
    UITapGestureRecognizer *BestDrivertapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bestDriverTapped)];
    [self.bestDriversView addGestureRecognizer:BestDrivertapGesture];
    
    self.mostRidesView.layer.cornerRadius = 10;
    self.mostRidesView.layer.borderWidth = 1.5;
    self.mostRidesView.layer.borderColor = Red_UIColor.CGColor;
    UITapGestureRecognizer *mostRidestapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mostRidesTapped)];
    [self.mostRidesView addGestureRecognizer:mostRidestapGesture];
}

- (IBAction)login:(id)sender
{
    LoginViewController *loginView = [[LoginViewController alloc] initWithNibName:(KIS_ARABIC)?@"LoginViewController_ar":@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginView animated:YES];
}

- (IBAction)Register:(id)sender
{
    RegisterViewController *registerView = [[RegisterViewController alloc] initWithNibName:(KIS_ARABIC)?@"RegisterViewController_ar":@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:registerView animated:YES];
}

- (IBAction)search:(id)sender
{
    SearchViewController *searchView = [[SearchViewController alloc] initWithNibName:(KIS_ARABIC)?@"SearchViewController_ar":@"SearchViewController" bundle:nil];
    searchView.enableBackButton = YES;
    [self.navigationController pushViewController:searchView animated:YES];
}

- (IBAction)makeATour:(id)sender
{
    TourViewController *tourView = [[TourViewController alloc] initWithNibName:@"TourViewController" bundle:nil];
    [self.navigationController pushViewController:tourView animated:YES];
}

- (void)mostRidesTapped
{
    MostRidesViewController *ridesView = [[MostRidesViewController alloc] initWithNibName:@"MostRidesViewController" bundle:nil];
    ridesView.enableBackButton = YES;
    [self.navigationController pushViewController:ridesView animated:YES];
}

- (void)bestDriverTapped
{
    BestDriversViewController *driversView = [[BestDriversViewController alloc] initWithNibName:@"BestDriversViewController" bundle:nil];
    driversView.enableBackButton = YES;
    [self.navigationController pushViewController:driversView animated:YES];
}

- (IBAction)selectEnglish:(id)sender
{
    language = [NSArray arrayWithObject:@"en"];
    
    LanguageType newLanguage;
    newLanguage = English;
    if (newLanguage != [Languages sharedLanguageInstance].language)
    {
        [[Languages sharedLanguageInstance] setLanguage:newLanguage];
        [[NSNotificationCenter defaultCenter] postNotificationName:LANGUAGE_CHANGE_NOTIFICATION object:self];
        [appDelegate reloadApp];
    }
}

- (IBAction)selectArabic:(id)sender
{
    language = [NSArray arrayWithObject:@"ar"];
    LanguageType newLanguage;
    newLanguage = Arabic;
    if (newLanguage != [Languages sharedLanguageInstance].language)
    {
        [[Languages sharedLanguageInstance] setLanguage:newLanguage];
        [[NSNotificationCenter defaultCenter] postNotificationName:LANGUAGE_CHANGE_NOTIFICATION object:self];
        [appDelegate reloadApp];
    }
}

- (void)didReceiveMemoryWarning
{
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
