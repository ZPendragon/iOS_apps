//
//  SAItem.m
//  Spotify-ObjC
//
//  Created by Kevin Zeckser on 8/5/16.
//  Copyright © 2016 Kevin Zeckser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAItem.h"

@implementation SAItem

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.name = nil;
        self.image = nil;
    }
    return self;
}

+ (NSString *) fetchImageURL:(NSArray *)images {
    for (NSDictionary *image in images) {
        NSNumber *height = [image objectForKey:@"height"];
        NSNumber *width = [image objectForKey:@"width"];
        
        if (width == height) {
            NSString *url = [image objectForKey:@"url"];
            return url;
        }
    }
    return nil;
}

@end