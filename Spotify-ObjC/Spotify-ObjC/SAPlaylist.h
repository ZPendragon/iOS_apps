//
//  SAPlaylist.h
//  Spotify-ObjC
//
//  Created by Kevin Zeckser on 8/5/16.
//  Copyright © 2016 Kevin Zeckser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAItem.h"

@interface SAPlaylist : SAItem

@property (nonatomic) int numberOfTracks;
@property (nonatomic) NSString *playlistDescription;

+ (NSArray *) configureWithJSON:(NSData *)responseData;

@end
