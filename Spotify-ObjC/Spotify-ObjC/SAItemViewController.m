//
//  SAArtistViewController.m
//  Spotify-ObjC
//
//  Created by Kevin Zeckser on 8/3/16.
//  Copyright © 2016 Kevin Zeckser. All rights reserved.
//

#import "SAItemViewController.h"

@interface SAItemViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *itemForegroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *itemBackgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation SAItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureVC];
}

- (void)configureVC {
    [self configureViews];
    [self configureOutlets];
}

- (void)configureViews {
    UIColor *backgroundColor = [UIColor blackColor];
    UIColor *textColor = [UIColor whiteColor];
    self.view.backgroundColor = backgroundColor;
    self.navigationController.navigationBar.barTintColor = backgroundColor;
    self.navigationController.navigationBar.tintColor = textColor;
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName: textColor}];
    
    self.itemForegroundImage.layer.cornerRadius = self.itemForegroundImage.bounds.size.width / 2;
    self.itemForegroundImage.clipsToBounds = true;
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.itemBackgroundImage.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.itemBackgroundImage addSubview: blurEffectView];
    
    self.descriptionLabel.textColor = textColor;
}

- (void)configureOutlets {
    if (self.detailArtist != nil) {
        UIImage *artistImage = [self loadImage:self.detailArtist.image];
        self.itemForegroundImage.image = artistImage;
        self.itemBackgroundImage.image = artistImage;
        self.descriptionLabel.text = self.detailArtist.artistDescription;
    }
}

- (UIImage *)loadImage:(NSString *)url {
    if ([url isEqualToString:@""]) {
        return [UIImage imageNamed:@"default_artist_image"];
    } else {
    NSURL *imgURL = [NSURL URLWithString: url];
    NSData *imgData = [NSData dataWithContentsOfURL:imgURL];
    return [UIImage imageWithData:imgData];
    }
}

@end
