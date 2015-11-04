//
//  ReviewCell.h
//  sharekni
//
//  Created by Ahmed Askar on 11/4/15.
//
//

#import <UIKit/UIKit.h>
#import "Review.h"


@interface ReviewCell : UITableViewCell

@property (nonatomic ,weak) IBOutlet UIImageView *driverPhoto ;
@property (nonatomic ,weak) IBOutlet UILabel *driverName ;
@property (nonatomic ,weak) IBOutlet UILabel *nationality ;
@property (nonatomic ,weak) IBOutlet UILabel *comment ;
@property (nonatomic ,weak) IBOutlet UIView *bgView ;
- (void)setReview:(Review *)review ;

@end
