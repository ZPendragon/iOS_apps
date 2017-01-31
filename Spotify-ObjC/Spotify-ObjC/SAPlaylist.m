//
//  SAPlaylist.m
//  Spotify-ObjC
//
//  Created by Kevin Zeckser on 8/5/16.
//  Copyright © 2016 Kevin Zeckser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAPlaylist.h"

@implementation SAPlaylist

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.numberOfTracks = 0;
        self.playlistDescription = nil;
    }
    return self;
}

+ (NSArray *) configureWithJSON:(NSData *)responseData {
    
    NSError *jsonError = nil;
    NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData: responseData
                                                               options: NSJSONReadingMutableContainers
                                                                 error: &jsonError];
    NSMutableArray *returnedPlaylists = [[NSMutableArray alloc] init];
    NSArray *dataFromJSON;
    if ([jsonResult objectForKey:@"playlists"]) {
        NSDictionary *playlistResponse = [jsonResult objectForKey:@"tracks"];
        NSArray *playlists = [playlistResponse objectForKey:@"items"];
        for (NSDictionary *playlistEntry in playlists) {
            NSArray *images = [playlistEntry objectForKey:@"images"];
            NSDictionary *playlistTracks = [playlistEntry objectForKey:@"tracks"];
            SAPlaylist *playlist = [[SAPlaylist alloc] init];
            playlist.name = [playlistEntry objectForKey:@"name"];
            playlist.image = [self fetchImageURL:images];
            playlist.numberOfTracks = (int)[[playlistTracks valueForKey:@"total"] integerValue];
            playlist.playlistDescription = @"This album is awesome!";
            [returnedPlaylists addObject: playlist];
        }
        dataFromJSON = returnedPlaylists;
    }
    return dataFromJSON;
}

@end
