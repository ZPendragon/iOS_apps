//
//  SAArtistViewController.h
//  Spotify-ObjC
//
//  Created by Kevin Zeckser on 8/3/16.
//  Copyright © 2016 Kevin Zeckser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAArtist.h"
#import "SAAlbum.h"
#import "SATrack.h"
#import "SAPlaylist.h"

@interface SAItemViewController : UIViewController

@property (nonatomic) SAArtist *detailArtist;
@property (nonatomic) SAAlbum *detailAlbum;
@property (nonatomic) SATrack *detailTrack;
@property (nonatomic) SAPlaylist *detailPlaylist;

- (void)configureVC;
- (void)configureViews;
- (void)configureOutlets;
- (UIImage *)loadImage:(NSString *)url;

@end
