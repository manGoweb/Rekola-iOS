//
//  ProfileViewController.h
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "BaseViewController.h"
#import "ContainerDelegate.h"

@interface ProfileViewController : BaseViewController <UIActionSheetDelegate>

@property (nonatomic, weak)id<ContainerDelegate>delegate;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
