//
//  SAArtist.m
//  Spotify-ObjC
//
//  Created by Kevin Zeckser on 7/29/16.
//  Copyright © 2016 Kevin Zeckser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAArtist.h"

@implementation SAArtist

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.artistDescription = nil;
    }
    return self;
}

+ (NSArray *) configureWithJSON:(NSData *)responseData {
    
    NSError *jsonError = nil;
    NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData: responseData
                                                               options: NSJSONReadingMutableContainers
                                                                 error: &jsonError];
    NSMutableArray *returnedArtists = [[NSMutableArray alloc] init];
    NSArray *dataFromJSON;
    
    if ([jsonResult objectForKey:@"artists"]) {
        NSDictionary *artistResponse = [jsonResult objectForKey:@"artists"];
        NSArray *artists = [artistResponse objectForKey:@"items"];
        for (NSDictionary *artistEntry in artists) {
            NSArray *images = [artistEntry objectForKey:@"images"];
            SAArtist *artist = [[SAArtist alloc] init];
            artist.name = [artistEntry objectForKey:@"name"];
            artist.image = [self fetchImageURL:images];
            artist.artistDescription = @"This band is awesome!";
            [returnedArtists addObject: artist];
        }
        dataFromJSON = returnedArtists;
    }
    return dataFromJSON;
}

@end
