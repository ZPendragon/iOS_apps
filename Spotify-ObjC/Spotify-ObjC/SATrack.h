//
//  SATrack.h
//  Spotify-ObjC
//
//  Created by Kevin Zeckser on 8/5/16.
//  Copyright © 2016 Kevin Zeckser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAItem.h"

@interface SATrack : SAItem

@property (nonatomic) NSString *trackDescription;

+ (NSArray *) configureWithJSON:(NSData *)responseData;

@end
