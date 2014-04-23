//
//  ContainerViewController.m
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "ContainerViewController.h"
#import "BikeViewController.h"
#import "SettingsViewController.h"
#import "MapViewController.h"

@implementation ContainerViewController {
    MapViewController *_mapViewController;
    SettingsViewController *_settingsViewController;
    BikeViewController *_bikeViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	//    [_segmentedControl setTitle:locs(@"9f67a1-segmented_control", lpos_segmented_control) forSegmentAtIndex:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadUI];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BikeEmbedSegue"]) {
        _bikeViewController = segue.destinationViewController;
        
    } else if ([segue.identifier isEqualToString:@"MapEmbedSegue"]) {
        _mapViewController = segue.destinationViewController;
        
    } else if ([segue.identifier isEqualToString:@"SettingsEmbedSegue"]) {
        _settingsViewController = segue.destinationViewController;
    }
}

#pragma mark - Actions

- (IBAction)changeTab:(id)sender {
    [self reloadUI];
}

#pragma mark - Private methods

- (void)reloadUI {
    if (_segmentedControl.selectedSegmentIndex == 0) {
        _bikeViewController.view.superview.hidden = NO;
        _mapViewController.view.superview.hidden = YES;
        _settingsViewController.view.superview.hidden = YES;
        
    } else if (_segmentedControl.selectedSegmentIndex == 1){
        _bikeViewController.view.superview.hidden = YES;
        _mapViewController.view.superview.hidden = NO;
        _settingsViewController.view.superview.hidden = YES;
        
    } else {
        _bikeViewController.view.superview.hidden = YES;
        _mapViewController.view.superview.hidden = YES;
        _settingsViewController.view.superview.hidden = NO;
    }
}

@end
