//
//  UINavigationController+Rotation.m
//  sharekni
//
//  Created by Ahmed Askar on 12/24/15.
//
//

#import "UINavigationController+Rotation.h"

@implementation UINavigationController (Rotation)

-(BOOL)shouldAutorotate
{
    return [[self.viewControllers lastObject] shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

@end
