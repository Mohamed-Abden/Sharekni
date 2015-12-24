//
//  BaseAPIManager.h
//  Sharekni
//
//  Created by Mohamed Abd El-latef on 9/27/15.
//
//

#import <Foundation/Foundation.h>
#import <AFHTTPRequestOperationManager.h>
#import <UIKit/UIKit.h>
@interface BaseAPIManager : NSObject

@property (nonatomic,strong) AFHTTPRequestOperationManager *operationManager;

- (NSString *) jsonStringFromResponse:(NSString *)response;

- (void) GetPhotoWithName:(NSString *)name withSuccess:(void (^)(UIImage *image,NSString *filePath))success Failure:(void (^)(NSString *error))failure;

@end
