//
//  SAItem.h
//  Spotify-ObjC
//
//  Created by Kevin Zeckser on 8/5/16.
//  Copyright © 2016 Kevin Zeckser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAItem : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *image;

+ (NSString *) fetchImageURL:(NSArray *)images;

@end
