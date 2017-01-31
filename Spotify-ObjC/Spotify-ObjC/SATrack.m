//
//  SATrack.m
//  Spotify-ObjC
//
//  Created by Kevin Zeckser on 8/5/16.
//  Copyright © 2016 Kevin Zeckser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SATrack.h"

@implementation SATrack

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.trackDescription = nil;
    }
    return self;
}

+ (NSArray *) configureWithJSON:(NSData *)responseData {
    
    NSError *jsonError = nil;
    NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData: responseData
                                                               options: NSJSONReadingMutableContainers
                                                                 error: &jsonError];
    NSMutableArray *returnedTracks = [[NSMutableArray alloc] init];
    NSArray *dataFromJSON;
    
    if ([jsonResult objectForKey:@"tracks"]) {
        NSDictionary *trackResponse = [jsonResult objectForKey:@"tracks"];
        NSArray *tracks = [trackResponse objectForKey:@"items"];
        NSLog(@"%@", trackResponse);
        for (NSDictionary *trackEntry in tracks) {
            NSDictionary *currentTrack = [trackEntry objectForKey:@"album"];
            NSArray *images = [currentTrack objectForKey:@"images"];
            SATrack *track = [[SATrack alloc] init];
            track.name = [currentTrack objectForKey:@"name"];
            track.image = [self fetchImageURL:images];
            track.trackDescription = @"This track is awesome!";
            [returnedTracks addObject: track];
        }
        dataFromJSON = returnedTracks;
    }
    return dataFromJSON;
}

@end
