//
//  PassengerCell.m
//  sharekni
//
//  Created by Mohamed Abd El-latef on 11/22/15.
//
//

#import "PassengerCell.h"
#import <UIColor+Additions.h>
#import "Constants.h"

@implementation PassengerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = (PassengerCell *)[[[NSBundle mainBundle] loadNibNamed:@"PassengerCell" owner:nil options:nil] objectAtIndex:(KIS_ARABIC)?1:0];
        self.ratingView = [[HCSStarRatingView alloc] initWithFrame:self.placeholderView.frame];
        self.ratingView.maximumValue = 5;
        self.ratingView.minimumValue = 0;
        self.ratingView.value = 0;
        self.ratingView.spacing = 5;
        self.ratingView.tintColor = Yellow_UIColor;
        [self.ratingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
        self.ratingView.accurateHalfStars = YES;
        self.ratingView.emptyStarImage = [[UIImage imageNamed:@"star-empty"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.ratingView.filledStarImage = [[UIImage imageNamed:@"start-filled"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.placeholderView removeFromSuperview];
        [self addSubview:self.ratingView];
    }
    return self;
}

- (void)didChangeValue:(HCSStarRatingView *)sender {
    if(self.ratingHandler){
        self.ratingHandler(sender.value);
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)messageHandler:(id)sender {
    if (self.messageHandler) {
        self.messageHandler();
    }
}
- (IBAction)deleteHandler:(id)sender {
    if (self.deleteHandler) {
        self.deleteHandler();
    }
}
- (IBAction)callHandler:(id)sender {
    if (self.callHandler) {
        self.callHandler();
    }
}

@end
