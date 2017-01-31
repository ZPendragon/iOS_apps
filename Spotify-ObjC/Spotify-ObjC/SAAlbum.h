//
//  SAAlbum.h
//  Spotify-ObjC
//
//  Created by Kevin Zeckser on 8/4/16.
//  Copyright © 2016 Kevin Zeckser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAItem.h"

@interface SAAlbum : SAItem

@property (nonatomic) NSString *albumDescription;

+ (NSArray *) configureWithJSON:(NSData *)responseData;

@end
