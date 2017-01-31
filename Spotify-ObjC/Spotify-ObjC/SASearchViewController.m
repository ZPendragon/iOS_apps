//
//  ViewController.m
//  Spotify-ObjC
//
//  Created by Kevin Zeckser on 7/29/16.
//  Copyright © 2016 Kevin Zeckser. All rights reserved.
//

#import "SASearchViewController.h"
#import "SAItemViewController.h"

static NSString * const cellIdentifier = @"searchResultCell";
static SARequestManager *requestManager = nil;

@interface SASearchViewController () {
    NSArray *returnedItems;
    NSString *segmentParameter;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *searchSegmentControl;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation SASearchViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    self.textField.delegate = self;
    requestManager = [SARequestManager sharedInstance];
    [self configureVC];
}

// MARK: - Setup

- (void)configureVC {
    UIColor *backgroundColor = [UIColor blackColor];
    UIColor *placeholderTextColor = [UIColor whiteColor];
    self.view.backgroundColor = backgroundColor;
    self.textField.backgroundColor = backgroundColor;
    self.navigationController.navigationBar.barTintColor = backgroundColor;
    self.navigationController.navigationBar.backgroundColor = backgroundColor;
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search Spotify" attributes:@{NSForegroundColorAttributeName: placeholderTextColor}];
    segmentParameter = @"artist";
}

//MARK: - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *searchQuery = self.textField.text;
    if ([searchQuery isEqualToString:@""]) {
        return YES;
    } else {
        [requestManager getItemsWithQuery:searchQuery :segmentParameter completion:^(SAResponse *response) {
            if (response.response == Failure) {
                NSLog(@"Error fetching artists");
            } else {
                NSLog(@"Success!!!");
                returnedItems = response.items;
                [self.tableView reloadData];
            }
        }];
    }
    return YES;
}

// MARK: - Actions

- (IBAction)indexChanged:(UISegmentedControl *)sender {
    switch (self.searchSegmentControl.selectedSegmentIndex) {
        case 0:
            segmentParameter = @"artist";
            break;
        case 1:
            segmentParameter = @"album";
            break;
        case 2:
            segmentParameter = @"track";
            break;
        case 3:
            segmentParameter = @"playlist";
            break;
        default:
            break;
    }
}

// MARK: - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [returnedItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *searchCell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    
    if ([returnedItems[indexPath.row] isKindOfClass:[SAArtist class]]) {
        SAArtist *currentArtist = [[SAArtist alloc] init];
        currentArtist = returnedItems[indexPath.row];
        searchCell.textLabel.text = currentArtist.name;
        return searchCell;
    } else if ([returnedItems[indexPath.row] isKindOfClass:[SAAlbum class]]) {
        SAAlbum *currentAlbum = [[SAAlbum alloc] init];
        currentAlbum = returnedItems[indexPath.row];
        searchCell.textLabel.text = currentAlbum.name;
        return searchCell;
    } else if ([returnedItems[indexPath.row] isKindOfClass:[SATrack class]]) {
        SATrack *currentTrack = [[SATrack alloc] init];
        currentTrack = returnedItems[indexPath.row];
        searchCell.textLabel.text = currentTrack.name;
        return searchCell;
    } else if ([returnedItems[indexPath.row] isKindOfClass:[SAPlaylist class]]) {
        SAPlaylist *currentPlaylist = [[SAPlaylist alloc] init];
        currentPlaylist = returnedItems[indexPath.row];
        searchCell.textLabel.text = currentPlaylist.name;
        return searchCell;
    }
    return searchCell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SAItemViewController *destinationController = segue.destinationViewController;
        
        if ([returnedItems[indexPath.row] isKindOfClass:[SAArtist class]]) {
            SAArtist *currentArtist = returnedItems[indexPath.row];
            destinationController.detailArtist = currentArtist;
            destinationController.navigationItem.title = currentArtist.name;
        } else if ([returnedItems[indexPath.row] isKindOfClass:[SAAlbum class]]) {
            SAAlbum *currentAlbum = returnedItems[indexPath.row];
            destinationController.detailAlbum = currentAlbum;
            destinationController.navigationItem.title = currentAlbum.name;
        } else if ([returnedItems[indexPath.row] isKindOfClass:[SATrack class]]) {
            SATrack *currentTrack = returnedItems[indexPath.row];
            destinationController.detailTrack = currentTrack;
            destinationController.navigationItem.title = currentTrack.name;
        } else if ([returnedItems[indexPath.row] isKindOfClass:[SAPlaylist class]]) {
            SAPlaylist *currentPlaylist = returnedItems[indexPath.row];
            destinationController.detailPlaylist = currentPlaylist;
            destinationController.navigationItem.title = currentPlaylist.name;
        }
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                       initWithTitle: @"Search"
                                       style: UIBarButtonItemStylePlain
                                       target: nil action: nil];
        [self.navigationItem setBackBarButtonItem: backButton];
    }
}

@end
