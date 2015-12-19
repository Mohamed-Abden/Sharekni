//
//  PermitsViewController.m
//  sharekni
//
//  Created by Ahmed Askar on 11/22/15.
//
//

#import "PermitsViewController.h"
#import "Constants.h"
#import <KVNProgress/KVNProgress.h>
#import "NSObject+Blocks.h"
#import <UIColor+Additions.h>
#import "MasterDataManager.h"
#import "HelpManager.h"
#import "User.h"
#import "Permit.h"
#import "PermitCell.h"
#import "MobAccountManager.h"
#import "ActivatePermitViewController.h"

@interface PermitsViewController ()

@property (nonatomic ,strong) NSArray *permits ;
@property (nonatomic ,weak)   IBOutlet UITableView *permitsList ;
@property (nonatomic ,weak) IBOutlet UILabel *noPermits ;

@end

@implementation PermitsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = GET_STRING(@"Permits");
    
    UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(0, 0, 22, 22);
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"Back_icn"] forState:UIControlStateNormal];
    [_backBtn setHighlighted:NO];
    [_backBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
    
    self.noPermits.text = GET_STRING(@"No permits found");
    [self getPermits];
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getPermits
{
    User *user = [[MobAccountManager sharedMobAccountManager] applicationUser];
    
    __block PermitsViewController *blockSelf = self;
    [KVNProgress showWithStatus:GET_STRING(@"loading")];
    [[MasterDataManager sharedMasterDataManager] getPermits:[NSString stringWithFormat:@"%@",user.ID] WithSuccess:^(NSMutableArray *array) {
        
        blockSelf.permits = array;
        if (array.count == 0) {
            self.noPermits.hidden = NO ;
        }else{
            self.noPermits.hidden = YES ;
        }
        [KVNProgress dismiss];
        [self.permitsList reloadData];
        
    } Failure:^(NSString *error) {
        NSLog(@"Error in Notifications");
        [KVNProgress dismiss];
        [KVNProgress showErrorWithStatus:@"Error"];
        [blockSelf performBlock:^{
            [KVNProgress dismiss];
        } afterDelay:3];
    }];
}

#pragma mark -
#pragma mark UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.permits.count;
}

- (PermitCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier  = @"PermitCell";
    
    PermitCell *permitCell = (PermitCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (permitCell == nil)
    {
        permitCell = (PermitCell *)[[[NSBundle mainBundle] loadNibNamed:@"PermitCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    Permit *permit = self.permits[indexPath.row];
    [permitCell setPermit:permit];
    
    return permitCell ;
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Permit *permit = self.permits[indexPath.row];
    NSString *urlString = [NSString stringWithFormat:@"https://www.sharekni.ae/en/Route_PrintMobilePermit.aspx?p=%@",permit.ID];
    ActivatePermitViewController *activatePermit = [[ActivatePermitViewController alloc] initWithNibName:@"ActivatePermitViewController" bundle:nil];
    activatePermit.url = urlString ;
    [self.navigationController pushViewController:activatePermit animated:YES];
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
