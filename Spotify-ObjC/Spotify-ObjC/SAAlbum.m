//
//  SAAlbum.m
//  Spotify-ObjC
//
//  Created by Kevin Zeckser on 8/4/16.
//  Copyright © 2016 Kevin Zeckser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAAlbum.h"

@implementation SAAlbum

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.albumDescription = nil;
    }
    return self;
}

+ (NSArray *) configureWithJSON:(NSData *)responseData {
    
    NSError *jsonError = nil;
    NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData: responseData
                                                               options: NSJSONReadingMutableContainers
                                                                 error: &jsonError];
    NSMutableArray *returnedAlbums = [[NSMutableArray alloc] init];
    NSArray *dataFromJSON;
    
    if ([jsonResult objectForKey:@"albums"]) {
        NSDictionary *albumResponse = [jsonResult objectForKey:@"albums"];
        NSArray *albums = [albumResponse objectForKey:@"items"];
        for (NSDictionary *albumEntry in albums) {
            NSArray *images = [albumEntry objectForKey:@"images"];
            SAAlbum *album = [[SAAlbum alloc] init];
            album.name = [albumEntry objectForKey:@"name"];
            album.image = [self fetchImageURL:images];
            album.albumDescription = @"This album is awesome!";
            [returnedAlbums addObject: album];
        }
        dataFromJSON = returnedAlbums;
    }
    return dataFromJSON;
}

@end
