//
//  TourViewController.m
//  sharekni
//
//  Created by Ahmed Askar on 11/26/15.
//
//

#import "TourViewController.h"
#import "PHPageScrollView.h"
#import "KCHorizontalScroller.h"
#import "Constants.h"
#import "Tour.h"
#import "PageView.h"

@interface TourViewController () <KCHorizontalScrollerDataSource ,KCHorizontalScrollerDelegate>
{
    NSArray *allImages;
    KCHorizontalScroller *scroller ;
}
@end

@implementation TourViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = GET_STRING(@"Take a tour");
    self.navigationController.navigationBarHidden = YES ;
    
    allImages = [[Tour getInstance] getTourImages];

    
    [self setScrollUserGuide];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setScrollUserGuide
{
    if (IS_IPHONE_6)
    {
        scroller = [[KCHorizontalScroller alloc] initWithFrame:CGRectMake(0.0f,0.0f,375.0f,667.0f)];
  
    }
    else if (IS_IPHONE_6P)
    {
        scroller = [[KCHorizontalScroller alloc] initWithFrame:CGRectMake(0.0f,0.0f,414.0f,736.0f)];

    }
    else
    {
        scroller = [[KCHorizontalScroller alloc] initWithFrame:CGRectMake(0.0f,0.0f,320.0f,568.0f)];
    }
    
    scroller.dataSource = self ;
    scroller.delegate = self ;
    
    if (IS_IPHONE_6)
    {
        scroller.scrollWidth = 375.0f;
    }
    else if (IS_IPHONE_6P)
    {
        scroller.scrollWidth = 414.0f;
    }
    else
    {
        scroller.scrollWidth = 320.0f;
    }
    
    [self.view addSubview:scroller];
    
    UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake((KIS_ARABIC)?8:self.view.frame.size.width-40, 8, 32, 32);
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"Close"] forState:UIControlStateNormal];
    [_backBtn setHighlighted:NO];
    [_backBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
    [self.view addSubview:_backBtn];
}


#pragma mark - KCHorizontalScrollerDelegate
- (void) horizontalScrollerDidScrollView:(float)fractional
{
    
}

- (void)horizontalScroller:(KCHorizontalScroller *)scroller clickedViewAtIndex:(int)index
{
    NSLog(@"index %d",index);
}

#pragma mark - KCHorizontalScrollerDataSource
- (NSInteger)numberOfViewsForHorizontalScroller:(KCHorizontalScroller*)scroller
{
    return allImages.count;
}

- (UIView *)horizontalScroller:(KCHorizontalScroller*)scroller viewAtIndex:(int)index
{
    Tour *tourObj = [allImages objectAtIndex:index];
    
    if (IS_IPHONE_6)
    {
        return [[PageView alloc] initWithFrame:CGRectMake(0.0f,0.0f,375.0f,667.0f) tour:tourObj];

    }
    else if (IS_IPHONE_6P)
    {
        return [[PageView alloc] initWithFrame:CGRectMake(0.0f,0.0f,414.0f,736.0f) tour:tourObj];

    }
    else
    {
        return [[PageView alloc] initWithFrame:CGRectMake(0.0f,0.0f,320.0f,568.0f) tour:tourObj];
    }
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
