//
//  SplashViewController.m
//  sharekni
//
//  Created by ITWORX on 11/25/15.
//
//

#import "SplashViewController.h"
#import "MasterDataManager.h"
#import "Emirate.h"
#import "NSObject+Blocks.h"
#import "HelpManager.h"
#import "MobAccountManager.h"
#define SPLASH_IMAGE1 @"Splash1"
#define SPLASH_IMAGE2 @"splash2"

@interface SplashViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) User *user;
@property (assign, nonatomic) BOOL getUserFinished;
@property (assign, nonatomic) BOOL timeFinished;

@end

@implementation SplashViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.getUserFinished = NO;
    self.timeFinished = NO;
    [self configureUser];
    [self configureEmirtaesAndRegions];
    [self configureData];
    __block SplashViewController *blockSelf = self;
    self.imageView.image = [UIImage imageNamed:SPLASH_IMAGE1];
    [self performBlock:^{
        [UIView animateWithDuration:.4 animations:^{
            blockSelf.imageView.image = [UIImage imageNamed:SPLASH_IMAGE2];
        }];
        [blockSelf performBlock:^{
            blockSelf.timeFinished = YES;
            if (blockSelf.getUserFinished &&blockSelf.finishedCallBack) {
                blockSelf.finishedCallBack(blockSelf.user);
            }
        } afterDelay:6];
    } afterDelay:4];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void) configureUser{
    NSString *userName = [[HelpManager sharedHelpManager] getUserNameFromUserDefaults];
    NSString *password = [[HelpManager sharedHelpManager] getUserPasswordFromUserDefaults];
    if (userName.length > 0 && password.length > 0) {
        __block SplashViewController *blockSelf = self;
        [[MobAccountManager sharedMobAccountManager] checkLoginWithUserName:userName andPassword:password WithSuccess:^(User *user) {
            blockSelf.user = user;
            blockSelf.getUserFinished = YES;
            if (blockSelf.timeFinished) {
                blockSelf.finishedCallBack(user);
            }
        } Failure:^(NSString *error) {
            blockSelf.getUserFinished = YES;
        }];
    }
    else{
        self.getUserFinished = YES;
    }
}

- (void) configureEmirtaesAndRegions{
[[MasterDataManager sharedMasterDataManager] GetEmiratesWithSuccess:^(NSMutableArray *array) {
    for (Emirate *emirte in array) {
        [[MasterDataManager sharedMasterDataManager] GetRegionsByEmirateID:emirte.EmirateId withSuccess:^(NSMutableArray *array) {
            
        } Failure:^(NSString *error) {
            NSLog(@"Failed To get regions emirtaeID : %@",emirte.EmirateId);
        }];
    }
} Failure:^(NSString *error) {
    NSLog(@"Failed To get emirtaes");
}];
}

- (void) configureData{
    [[MasterDataManager sharedMasterDataManager] GetAgeRangesWithSuccess:^(NSMutableArray *array) {

    } Failure:^(NSString *error) {
           NSLog(@"Failed To get age ranges");
    }];
    
    [[MasterDataManager sharedMasterDataManager] GetNationalitiesByID:@"0" WithSuccess:^(NSMutableArray *array) {
        
    } Failure:^(NSString *error) {
        NSLog(@"Failed To get nationalities");
    }];
    
    [[MasterDataManager sharedMasterDataManager] GetPrefferedLanguagesWithSuccess:^(NSMutableArray *array) {
        
    } Failure:^(NSString *error) {
        NSLog(@"Failed To get languages");
    }];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}




@end
