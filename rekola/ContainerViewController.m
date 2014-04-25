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
#import "ReturnBikeViewController.h"

@implementation ContainerViewController {
    MapViewController *_mapViewController;
    ProfileViewController *_profileViewController;
    BikeViewController *_bikeViewController;
    ReturnBikeViewController *_returnBikeController;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ContentManagerDidChangeUsingBikeNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _segmentedControl.selectedSegmentIndex = 1;
    
    [self reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(usingBikeDidChange) name:ContentManagerDidChangeUsingBikeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadUI];
}

- (void)reloadData {
    [_segmentedControl setTitle:[ContentManager manager].usingBike? NSLocalizedString(@"Return", @"Title in segmented control") : NSLocalizedString(@"Borrow", @"Title in segmented control") forSegmentAtIndex:0];
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
    
    } else if ([segue.identifier isEqualToString:@"ReturnBikeEmbedSegue"]) {
        UINavigationController *nav = segue.destinationViewController;
        _returnBikeController = (ReturnBikeViewController *)nav.topViewController;
        _returnBikeController.delegate = self;
    }
}

#pragma mark - Actions

- (IBAction)changeTab:(id)sender {
    [self reloadUI];
}

#pragma mark - Private methods

- (void)usingBikeDidChange {
    [self reloadData];
}

- (void)reloadUI {
    [self.view endEditing:YES];
    
    if (_segmentedControl.selectedSegmentIndex == 0) {
        if ([ContentManager manager].usingBike != nil) {
            _returnBikeController.navigationController.view.superview.hidden = NO;
            _bikeViewController.navigationController.view.superview.hidden = YES;
            [_returnBikeController reloadData];
            
        } else {
            _returnBikeController.navigationController.view.superview.hidden = YES;
            _bikeViewController.navigationController.view.superview.hidden = NO;
            [_bikeViewController reloadData];
        }
        
        _mapViewController.navigationController.view.superview.hidden = YES;
        _profileViewController.navigationController.view.superview.hidden = YES;
        
    } else if (_segmentedControl.selectedSegmentIndex == 1){
        _returnBikeController.navigationController.view.superview.hidden = YES;
        _bikeViewController.navigationController.view.superview.hidden = YES;
        _mapViewController.navigationController.view.superview.hidden = NO;
        _profileViewController.navigationController.view.superview.hidden = YES;
        [_mapViewController reloadData];
        
    } else {
        _returnBikeController.navigationController.view.superview.hidden = YES;
        _bikeViewController.navigationController.view.superview.hidden = YES;
        _mapViewController.navigationController.view.superview.hidden = YES;
        _profileViewController.navigationController.view.superview.hidden = NO;
        [_profileViewController reloadData];
    }
}

#pragma mark - ContainerDelegate methods

- (void)controller:(UIViewController *)controller containerWillChangeType:(ContainerType)type withObject:(id)object {
    
    _segmentedControl.selectedSegmentIndex = type;
    if (type == ContainerTypeBike) {
        _bikeViewController.bikeDetail = object;
    }
    
    [self reloadUI];
}

@end
