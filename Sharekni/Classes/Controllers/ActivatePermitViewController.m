//
//  ActivatePermitViewController.m
//  sharekni
//
//  Created by Ahmed Askar on 11/23/15.
//
//

#import "ActivatePermitViewController.h"
#import <KVNProgress/KVNProgress.h>
#import "Constants.h"

@interface ActivatePermitViewController ()

@property (nonatomic ,weak) IBOutlet UIWebView *permitWebView ;

@end

@implementation ActivatePermitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    // Do any additional setup after loading the view from its nib.
    self.title = GET_STRING(@"Permit");
    
    UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(0, 0, 22, 22);
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"Back_icn"] forState:UIControlStateNormal];
    [_backBtn setHighlighted:NO];
    [_backBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
    
    [KVNProgress showWithStatus:GET_STRING(@"loading")];

    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_permitWebView setScalesPageToFit:YES];
    [_permitWebView loadRequest:request];
    
    [ActivatePermitViewController attemptRotationToDeviceOrientation];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [KVNProgress dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [KVNProgress dismiss];
    NSLog(@"Error : %@",error);
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
