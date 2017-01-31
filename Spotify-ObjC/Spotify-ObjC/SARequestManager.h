//
//  SARequestManager.h
//  Spotify-ObjC
//
//  Created by Kevin Zeckser on 7/29/16.
//  Copyright © 2016 Kevin Zeckser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAResponse.h"

typedef void (^Completion)(SAResponse *response);

@interface SARequestManager : NSObject

+ (SARequestManager *) sharedInstance;
- (void) singletonInit;
- (void) getItemsWithQuery:(NSString *)query :(NSString *)parameter completion:(Completion)completion;

@end
