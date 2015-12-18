//
//  MJDetailViewController.m
//  MJPopupViewControllerDemo
//
//  Created by Martin Juhasz on 24.06.12.
//  Copyright (c) 2012 martinjuhasz.de. All rights reserved.
//

#import "AddReviewViewController.h"
#import "MobAccountManager.h"
#import "Constants.h"
#import <KVNProgress/KVNProgress.h>
#import "User.h"

@implementation AddReviewViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (KIS_ARABIC)
    {
        viewText.textAlignment = NSTextAlignmentRight ;
        self.headerTitle2.textAlignment = NSTextAlignmentRight ;
    }
    
    [self.headerTitle setText:GET_STRING(@"Write Your Review")];
    [self.headerTitle2 setText:GET_STRING(@"Your Review")];
    [self.submitBtn setTitle:GET_STRING(@"Submit") forState:UIControlStateNormal];
    
    [viewText becomeFirstResponder];
}

- (void)HideKeyboard
{
    [viewText resignFirstResponder];
}

- (IBAction)closePopup:(id)sender
{
    NSString *str = viewText.text ;
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    if (str.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:GET_STRING(@"Attention") message:GET_STRING(@"You must write your review first") delegate:nil cancelButtonTitle:GET_STRING(@"Ok") otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }
    
    User *user = [[MobAccountManager sharedMobAccountManager] applicationUser];
    
    [KVNProgress showWithStatus:GET_STRING(@"Loading...")];
    [[MobAccountManager sharedMobAccountManager] reviewDriver:self.routeDetails.AccountId.stringValue PassengerId:user.ID.stringValue RouteId:self.routeDetails.ID.stringValue ReviewText:viewText.text WithSuccess:^(NSString *user) {
        [KVNProgress dismiss];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
            [self.delegate cancelButtonClicked:self];
        }
    } Failure:^(NSString *error) {
        [KVNProgress dismiss];
    }];
}

@end