//
//  BaseViewController.m
//  sharekni
//
//  Created by ITWORX on 10/31/15.
//
//

#import "BaseViewController.h"
#import <UIViewController+REFrostedViewController.h>
#import <REFrostedViewController.h>
#import "Constants.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (instancetype)init{
    if (self = [super init]) {
        self.enableBackButton = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.enableBackButton) {
        UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0, 0, 22, 22);
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"Back_icn"] forState:UIControlStateNormal];
        [_backBtn setHighlighted:NO];
        [_backBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
    }
    else {
        UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(menuItemTapped)];

            self.navigationItem.leftBarButtonItem = menuItem;
    }
}

- (void) menuItemTapped{
    [self.frostedViewController presentMenuViewController];
}

#pragma mark - Methods
- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
