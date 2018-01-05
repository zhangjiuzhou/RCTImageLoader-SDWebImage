//
//  RCTImageLoader+SDWebImage.m
//  RCTImageLoader+SDWebImage
//
//  Created by 张九州 on 17/3/2.
//

#import "RCTImageLoader+SDWebImage.h"
#import <JRSwizzle/JRSwizzle.h>
#import <SDWebImage/SDWebImageManager.h>

@interface RCTImageLoader_SDWebImage : NSObject

@end

@implementation RCTImageLoader_SDWebImage

+ (void)load
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [RCTImageLoader jr_swizzleMethod:@selector(_loadURLRequest:progressBlock:completionBlock:) withMethod:@selector(c_loadURLRequest:progressBlock:completionBlock:) error:NULL];
#pragma clang diagnostic pop
}

@end

@implementation RCTImageLoader (SDWebImage)

- (RCTImageLoaderCancellationBlock)c_loadURLRequest:(NSURLRequest *)request
                                      progressBlock:(RCTImageLoaderProgressBlock)progressHandler
                                    completionBlock:(void (^)(NSError *error, id imageOrData, NSString *fetchDate))completionHandler
{
    id<SDWebImageOperation> operation =
    [[SDWebImageManager sharedManager] downloadImageWithURL:request.URL
                                                    options:0
                                                   progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                       if (progressHandler) {
                                                           progressHandler(receivedSize, expectedSize);
                                                       }
                                                   } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                       if (completionHandler) {
                                                           completionHandler(error, image, @"");
                                                       }
                                                   }];
    return ^{
        [operation cancel];
    };
}

@end
