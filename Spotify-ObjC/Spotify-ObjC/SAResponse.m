//
//  SAResponse.m
//  Spotify-ObjC
//
//  Created by Kevin Zeckser on 7/29/16.
//  Copyright © 2016 Kevin Zeckser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAResponse.h"

@implementation SAResponse : NSObject 

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.items = nil;
        self.response = 0;
        self.error = nil;
    }
    return self;
}

@end
