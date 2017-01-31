//
//  SARequestManager.m
//  Spotify-ObjC
//
//  Created by Kevin Zeckser on 7/29/16.
//  Copyright © 2016 Kevin Zeckser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SARequestManager.h"

@interface SARequestManager ()

@end

@implementation SARequestManager

static NSURLSession *session;
static SARequestManager *sharedInstance = nil;

- (void) singletonInit {
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    session = [NSURLSession sessionWithConfiguration: sessionConfig];
}

+ (SARequestManager *) sharedInstance {
    static dispatch_once_t dispatchOncePredicate = 0;
    dispatch_once(&dispatchOncePredicate, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance singletonInit];
    });
    return sharedInstance;
}

- (void) getItemsWithQuery:(NSString *)query :(NSString *)parameter completion:(Completion)completion {
    NSMutableString *path = [NSMutableString stringWithFormat: @"https://api.spotify.com/v1/search?q=%@&type=%@", query, parameter];
    NSString *locale = @"&market=US";
    [path appendString: locale];
    NSURL *url = [NSURL URLWithString: path];
    NSLog(@"%@", path);
    NSURLSessionDataTask *task = [session dataTaskWithURL: url
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            SAResponse *result = [[SAResponse alloc] init];
                                            if (!data) {
                                                result.error = error;
                                                result.response = Failure;
                                            } else {
                                                result.response = Success;
                                                NSArray *itemsFromJSON;
                                                if ([parameter isEqualToString:@"artist"]) {
                                                    itemsFromJSON = [SAArtist configureWithJSON:data];
                                                } else if ([parameter isEqualToString:@"album"]) {
                                                    itemsFromJSON = [SAAlbum configureWithJSON:data];
                                                } else if ([parameter isEqualToString:@"track"]) {
                                                    itemsFromJSON = [SATrack configureWithJSON:data];
                                                } else if ([parameter isEqualToString:@"playlist"]) {
                                                    itemsFromJSON = [SAPlaylist configureWithJSON:data];
                                                }
                                                
                                                [result setItems: itemsFromJSON];
                                            }
                                            dispatch_sync(dispatch_get_main_queue(), ^{
                                                completion(result);
                                            });
                                        }];
    [task resume];
}

@end
