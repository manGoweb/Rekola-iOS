//
//  ProfileViewController.m
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "ProfileViewController.h"
#import "SettingsCell.h"

@implementation ProfileViewController {
    NSMutableArray *_cells;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self reloadData];
}

- (void)reloadData {
    
    [_tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SettingsCell";
    SettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Change password
    if (indexPath.row == 0) {
        cell.titleLabel.text = NSLocalizedString(@"Change Password", @"Label text in table view cell");
        
    // Log out
    } else if (indexPath.row == 1) {
        cell.titleLabel.text = NSLocalizedString(@"Log Out", @"Label text in table view cell");
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Change password
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"ChangePassSegue" sender:nil];
        
    // Log out
    } else if (indexPath.row == 1) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Are you sure you want to log out?", @"Title in Action Sheet") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Button in Action Sheet") destructiveButtonTitle:NSLocalizedString(@"Log Out", @"Button in Action Sheet") otherButtonTitles:nil, nil];
        [sheet showInView:self.view];
    }
}

#pragma mark - UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [[ContentManager manager] logout];
    }
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

@end
