//
//  ContainerViewController.m
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "ContainerViewController.h"
#import "BikeViewController.h"
#import "ProfileViewController.h"
#import "MapViewController.h"

@implementation ContainerViewController {
    MapViewController *_mapViewController;
    ProfileViewController *_profileViewController;
    BikeViewController *_bikeViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadUI];
}

- (void)reloadData {
    [_segmentedControl setTitle:NSLocalizedString(@"Borrow", @"Title in segmented control") forSegmentAtIndex:0];
    [_segmentedControl setTitle:NSLocalizedString(@"Find", @"Title in segmented control") forSegmentAtIndex:1];
    [_segmentedControl setTitle:NSLocalizedString(@"Profile", @"Title in segmented control") forSegmentAtIndex:2];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BikeEmbedSegue"]) {
        UINavigationController *nav = segue.destinationViewController;
        _bikeViewController = (BikeViewController *)nav.topViewController;
        _bikeViewController.delegate = self;
        
    } else if ([segue.identifier isEqualToString:@"MapEmbedSegue"]) {
        UINavigationController *nav = segue.destinationViewController;
        _mapViewController = (MapViewController *)nav.topViewController;
        _mapViewController.delegate = self;
        
    } else if ([segue.identifier isEqualToString:@"SettingsEmbedSegue"]) {
        UINavigationController *nav = segue.destinationViewController;
        _profileViewController = (ProfileViewController *)nav.topViewController;
        _profileViewController.delegate = self;
    }
}

#pragma mark - Actions

- (IBAction)changeTab:(id)sender {
    [self reloadUI];
}

#pragma mark - Private methods

- (void)reloadUI {
    if (_segmentedControl.selectedSegmentIndex == 0) {
        _bikeViewController.navigationController.view.superview.hidden = NO;
        _mapViewController.navigationController.view.superview.hidden = YES;
        _profileViewController.navigationController.view.superview.hidden = YES;
        
    } else if (_segmentedControl.selectedSegmentIndex == 1){
        _bikeViewController.navigationController.view.superview.hidden = YES;
        _mapViewController.navigationController.view.superview.hidden = NO;
        _profileViewController.navigationController.view.superview.hidden = YES;
        
    } else {
        _bikeViewController.navigationController.view.superview.hidden = YES;
        _mapViewController.navigationController.view.superview.hidden = YES;
        _profileViewController.navigationController.view.superview.hidden = NO;
    }
}

#pragma mark - ContainerDelegate methods

- (void)controller:(UIViewController *)controller containerWillChangeType:(ContainerType)type withObject:(id)object {
    
    _segmentedControl.selectedSegmentIndex = type;
    [self reloadUI];
}

@end
