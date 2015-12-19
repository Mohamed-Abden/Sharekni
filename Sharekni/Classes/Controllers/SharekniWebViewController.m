//
//  SharekniWebViewController.m
//  sharekni
//
//  Created by Mohamed Abd El-latef on 11/14/15.
//
//

#import "SharekniWebViewController.h"
#import <UIColor+Additions.h>
#import <KVNProgress.h>
#import <KVNProgressConfiguration.h>

@interface SharekniWebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SharekniWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUI];
}

- (void) configureUI
{
    self.navigationController.navigationBar.translucent = YES;
    UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(0, 0, 22, 22);
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"Back_icn"] forState:UIControlStateNormal];
    [_backBtn setHighlighted:NO];
    [_backBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
   
    if (self.type == WebViewTermsAndConditionsType) {
  
        self.navigationItem.title = self.type == WebViewPrivacyType ? GET_STRING(@"Policy") : GET_STRING(@"Terms And Conditions");
        [self.acceptButton setBackgroundColor:Red_UIColor];
        NSString *acceptTitle = self.type == WebViewPrivacyType ? GET_STRING(@"Accept") : GET_STRING(@"Accept");
        [self.acceptButton setTitle:acceptTitle forState:UIControlStateNormal];
    }
    else{
        CGRect webViewFrame = self.webView.frame;
        CGRect buttonFrame = self.acceptButton.frame;
        webViewFrame.size.height += buttonFrame.size.height;
        self.webView.frame = webViewFrame;
        self.acceptButton.alpha = 0;
    }
    
    NSString *resourceName;
    if (self.type == WebViewPrivacyType) {
        resourceName = (KIS_ARABIC) ? @"privacyPolicy_ar" : @"policy";
        self.navigationItem.title = GET_STRING(@"Policy") ;
    }
    else{
        resourceName = (KIS_ARABIC) ? @"terms_condition_Ar" : @"terms_en";
        self.navigationItem.title = GET_STRING(@"Terms And Conditions");
    }
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:resourceName ofType:@"html"]isDirectory:NO]]];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    KVNProgressConfiguration *progressConfiguration = [KVNProgress configuration];
    progressConfiguration.fullScreen = NO;
    [KVNProgress setConfiguration:progressConfiguration];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    KVNProgressConfiguration *progressConfiguration = [KVNProgress configuration];
    progressConfiguration.fullScreen = NO;
    [KVNProgress setConfiguration:progressConfiguration];
}

- (IBAction)acceptAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [KVNProgress showWithStatus:GET_STRING(@"Loading...")];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [KVNProgress dismiss];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    [KVNProgress dismiss];
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
