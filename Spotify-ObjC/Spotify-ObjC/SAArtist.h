//
//  SAArtist.h
//  Spotify-ObjC
//
//  Created by Kevin Zeckser on 8/1/16.
//  Copyright © 2016 Kevin Zeckser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAItem.h"

@interface SAArtist : SAItem

@property (nonatomic) NSString *artistDescription;

+ (NSArray *) configureWithJSON:(NSData *)responseData;

@end
