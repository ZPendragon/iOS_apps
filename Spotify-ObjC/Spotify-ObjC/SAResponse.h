//
//  SAResponse.h
//  Spotify-ObjC
//
//  Created by Kevin Zeckser on 7/29/16.
//  Copyright © 2016 Kevin Zeckser. All rights reserved.
//

#import "SAArtist.h"
#import "SAAlbum.h"
#import "SATrack.h"
#import "SAPlaylist.h"

typedef NS_ENUM(NSInteger, NetworkResponse) {
    Success = 0,
    Failure
};

@interface SAResponse : NSObject

@property (nonatomic) NetworkResponse response;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic) NSError *error;

@end
