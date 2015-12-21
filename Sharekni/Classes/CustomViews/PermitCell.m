//
//  PermitCell.m
//  sharekni
//
//  Created by Ahmed Askar on 11/22/15.
//
//

#import "PermitCell.h"
#import "UIView+Borders.h"
#import "Constants.h"
#import <UIColor+Additions/UIColor+Additions.h>

@implementation PermitCell

- (void)awakeFromNib {
    // Initialization code
    [_routeName addRightBorderWithColor:Red_UIColor];
    [_routeName addLeftBorderWithColor:Red_UIColor];
    
    _containerView.layer.cornerRadius = 20;
    _containerView.layer.borderWidth = 1;
    _containerView.layer.borderColor = Red_UIColor.CGColor;
}

- (void)setPermit:(Permit *)permit
{
    self.routeName.text = permit.RouteEnName ;
    self.passengerNo.text = [NSString stringWithFormat:@"%@",permit.CurrentPassengers] ;
    
    self.issueDate.text = permit.IssueDate;

    self.expireDate.text = permit.ExpireDate;
}

- (NSDate *)mfDateFromDotNetJSONString:(NSString *)string
{
    static NSRegularExpression *dateRegEx = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateRegEx = [[NSRegularExpression alloc] initWithPattern:@"^\\/date\\((-?\\d++)(?:([+-])(\\d{2})(\\d{2}))?\\)\\/$" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    NSTextCheckingResult *regexResult = [dateRegEx firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    
    if (regexResult) {
        // milliseconds
        NSTimeInterval seconds = [[string substringWithRange:[regexResult rangeAtIndex:1]] doubleValue] / 1000.0;
        // timezone offset
        if ([regexResult rangeAtIndex:2].location != NSNotFound) {
            NSString *sign = [string substringWithRange:[regexResult rangeAtIndex:2]];
            // hours
            seconds += [[NSString stringWithFormat:@"%@%@", sign, [string substringWithRange:[regexResult rangeAtIndex:3]]] doubleValue] * 60.0 * 60.0;
            // minutes
            seconds += [[NSString stringWithFormat:@"%@%@", sign, [string substringWithRange:[regexResult rangeAtIndex:4]]] doubleValue] * 60.0;
        }
        
        return [NSDate dateWithTimeIntervalSince1970:seconds];
    }
    return nil;
}

- (NSString *)getDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate ;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
